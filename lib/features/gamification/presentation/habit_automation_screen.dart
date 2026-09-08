import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/habit_models.dart';
import 'providers/habit_provider.dart';

class HabitAutomationScreen extends ConsumerStatefulWidget {
  const HabitAutomationScreen({super.key});

  @override
  ConsumerState<HabitAutomationScreen> createState() => _HabitAutomationScreenState();
}

class _HabitAutomationScreenState extends ConsumerState<HabitAutomationScreen> {
  HabitTimeSlot? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    final habitSummary = ref.watch(habitProvider);
    final filteredHabits = _selectedTimeSlot == null
        ? habitSummary.habits
        : habitSummary.habits.where((h) => h.timeSlot == _selectedTimeSlot).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Automation System',
              style: AppTypography.titleLarge,
            ),
            Text(
              'Circadian Behavioral Loops • Auto-Triggered',
              style: AppTypography.bodySmall.copyWith(color: AppColors.focusBlue),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroAdherenceCard(habitSummary),
            const SizedBox(height: AppSpacing.md),
            _buildHabitStrengthGrid(habitSummary),
            const SizedBox(height: AppSpacing.md),
            _buildTimeSlotFilterRow(),
            const SizedBox(height: AppSpacing.md),
            _buildHabitsList(filteredHabits),
            const SizedBox(height: AppSpacing.md),
            _buildCircadianBehaviorScienceBanner(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroAdherenceCard(HabitDailySummary summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.focusBlue.withAlpha(35),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.focusBlue.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.focusBlue.withAlpha(30),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: summary.totalHabitsCount > 0
                      ? summary.completedTodayCount / summary.totalHabitsCount
                      : 0.0,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.karmaGreen),
                ),
                Text(
                  '${summary.adherencePercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY CIRCADIAN RHYTHM',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.completedTodayCount} of ${summary.totalHabitsCount} Habits Complete',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+${summary.totalEarnedKarmaPointsToday} Karma Points Earned Today',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitStrengthGrid(HabitDailySummary summary) {
    return Row(
      children: [
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Avg Habit Strength',
              value: '${summary.averageHabitStrengthIndex.toInt()}',
              unit: '/ 100 HSI',
              accentColor: AppColors.karmaGreen,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Active Loops',
              value: '${summary.totalHabitsCount}',
              unit: 'Anchors',
              accentColor: AppColors.focusBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: BentoCard(
            child: GlowingMetric(
              label: 'Daily Karma',
              value: '+${summary.totalEarnedKarmaPointsToday}',
              unit: 'KP',
              accentColor: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: FilterChip(
              label: const Text('All Day (24h)', style: TextStyle(fontSize: 11)),
              selected: _selectedTimeSlot == null,
              selectedColor: AppColors.focusBlue,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedTimeSlot = null;
                  });
                }
              },
            ),
          ),
          ...HabitTimeSlot.values.where((slot) => slot != HabitTimeSlot.anytime).map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
                label: Text('${slot.label.split(' ').first} (${slot.timeRange})', style: const TextStyle(fontSize: 11)),
                selected: isSelected,
                selectedColor: AppColors.focusBlue,
                backgroundColor: AppColors.surfaceElevated,
                onSelected: (selected) {
                  setState(() {
                    _selectedTimeSlot = selected ? slot : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHabitsList(List<Habit> habits) {
    return Column(
      children: habits.map((habit) => _buildHabitCard(habit)).toList(),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    final tierColor = Color(habit.automaticityTier.colorCode);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: habit.isCompletedToday ? AppColors.surfaceElevated : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(
          color: habit.isCompletedToday ? AppColors.karmaGreen.withAlpha(120) : AppColors.glassBorder,
          width: habit.isCompletedToday ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox Toggle
              GestureDetector(
                onTap: () {
                  ref.read(habitProvider.notifier).toggleHabit(habit.id);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: habit.isCompletedToday ? AppColors.karmaGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: habit.isCompletedToday ? AppColors.karmaGreen : AppColors.textMuted,
                      width: 2.0,
                    ),
                  ),
                  child: habit.isCompletedToday
                      ? const Icon(Icons.check, color: Colors.black, size: 20)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Habit Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            habit.title,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: habit.isCompletedToday ? AppColors.textPrimary : AppColors.textSecondary,
                              decoration: habit.isCompletedToday ? TextDecoration.none : null,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.karmaGreen.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '+${habit.rewardKarmaPoints} KP',
                            style: const TextStyle(
                              color: AppColors.karmaGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      habit.regionalTitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: habit.isCompletedToday ? AppColors.focusBlue : AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Cue and Routine Pill
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '⚓ Cue: ${habit.cueDescription}',
                            style: const TextStyle(
                              color: AppColors.focusBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '⚡ Routine: ${habit.routineDescription}',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Footer Meta (Streak + Trigger + Tier)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: AppColors.energyOrange, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.streakDays}d Streak',
                              style: const TextStyle(
                                color: AppColors.energyOrange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• ${habit.triggerSource.label}',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: tierColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            habit.automaticityTier.title.toUpperCase(),
                            style: TextStyle(
                              color: tierColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircadianBehaviorScienceBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.aiPurple.withAlpha(70)),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: AppColors.aiPurple, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BilingualLabel(
                  primaryText: 'Circadian Habit Stacking',
                  regionalText: 'सर्केडियन आदत श्रृंखला विज्ञान',
                ),
                const SizedBox(height: 2),
                Text(
                  'Habits anchored to Ayurvedic daily phases (Dinacharya) require 40% less willpower and automate through multi-sensor triggers.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
