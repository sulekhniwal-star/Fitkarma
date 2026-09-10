import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../data/exercise_database.dart';
import '../domain/workout_models.dart';
import '../providers/workout_provider.dart';

class WorkoutScreenHome extends ConsumerWidget {
  const WorkoutScreenHome({super.key});

  void _showExerciseLibraryBottomSheet(BuildContext context) {
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final results = ExerciseDatabase.search(searchQuery);

            return SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Exercise & Movement Library',
                      regionalText: 'व्यायाम एवं अखाड़ा मूवमेंट सूची',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      onChanged: (val) =>
                          setModalState(() => searchQuery = val),
                      decoration: const InputDecoration(
                        hintText:
                            'Search movements (e.g. Bench Press, Desi Dand, Squat)...',
                        prefixIcon: Icon(Icons.search_rounded,
                            color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.radiusSm,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final ex = results[index];
                          final isIndianTrad =
                              ex.equipment == EquipmentType.traditionalIndian;

                          return BentoCard(
                            backgroundColor: AppColors.surface,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (isIndianTrad
                                            ? AppColors.energyOrange
                                            : AppColors.focusBlue)
                                        .withValues(alpha: 0.15),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Icon(
                                    isIndianTrad
                                        ? Icons.sports_kabaddi_rounded
                                        : Icons.fitness_center_rounded,
                                    color: isIndianTrad
                                        ? AppColors.energyOrange
                                        : AppColors.focusBlue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ex.name,
                                              style: AppTypography.titleSmall
                                                  .copyWith(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: const BoxDecoration(
                                              color: AppColors.surfaceElevated,
                                              borderRadius: AppRadii.radiusSm,
                                            ),
                                            child: Text(
                                              ex.targetMuscle.name,
                                              style: const TextStyle(
                                                  fontSize: 9,
                                                  color: AppColors.karmaGreen,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(ex.regionalName,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textMuted)),
                                      const SizedBox(height: 4),
                                      Text(
                                        ex.instructions,
                                        style: AppTypography.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 11,
                                            height: 1.2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);
    final session = workoutState.todaysSession;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Movement & Workout OS',
          regionalText: 'प्रशिक्षण एवं कसरत प्रबंधन',
          alignment: CrossAxisAlignment.center,
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.menu_book_rounded, color: AppColors.focusBlue),
            tooltip: 'Exercise Library',
            onPressed: () => _showExerciseLibraryBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Scheduled Workout Session Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.energyOrange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: session.title,
                          regionalText: session.regionalTitle,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                AppColors.energyOrange.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color: AppColors.energyOrange
                                    .withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            session.splitCategory.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.energyOrange,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Duration',
                          value: '${session.estimatedDurationMinutes}',
                          unit: 'mins',
                          isHero: true,
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Exercises',
                          value: '${session.plannedExercises.length}',
                          unit: 'moves',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Total Sets',
                          value: '${session.totalSets}',
                          unit: 'sets',
                          accentColor: AppColors.karmaGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Readiness Adaptive Note
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadii.radiusSm,
                        border: Border.all(
                            color: AppColors.karmaGreen.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt_rounded,
                              color: AppColors.karmaGreen, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Readiness Score 87% (Optimal) • Primed for target RPE 8.0–9.5 overload',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.karmaGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Start Workout Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.energyOrange,
                          foregroundColor: AppColors.textInverse,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: const RoundedRectangleBorder(
                              borderRadius: AppRadii.radiusSm),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: const Text(
                          'Start Workout / कसरत शुरू करें',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        onPressed: () {
                          ref.read(workoutProvider.notifier).startWorkout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.surfaceElevated,
                              content: Text(
                                  'Session Started! Open Active Workout Screen to log live sets.',
                                  style:
                                      TextStyle(color: AppColors.karmaGreen)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Weekly Split & Adherence Overview
              const Text(
                'WEEKLY PERIODIZATION SPLIT (साप्ताहिक विभाजन)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDaySchedulePill(
                        day: 'Mon',
                        split: 'Push',
                        isCompleted: true,
                        isToday: true),
                    _buildDaySchedulePill(
                        day: 'Tue',
                        split: 'Pull',
                        isCompleted: false,
                        isToday: false),
                    _buildDaySchedulePill(
                        day: 'Wed',
                        split: 'Legs',
                        isCompleted: false,
                        isToday: false),
                    _buildDaySchedulePill(
                        day: 'Thu',
                        split: 'Rest',
                        isCompleted: false,
                        isToday: false),
                    _buildDaySchedulePill(
                        day: 'Fri',
                        split: 'Upper',
                        isCompleted: false,
                        isToday: false),
                    _buildDaySchedulePill(
                        day: 'Sat',
                        split: 'Lower',
                        isCompleted: false,
                        isToday: false),
                    _buildDaySchedulePill(
                        day: 'Sun',
                        split: 'Yoga',
                        isCompleted: false,
                        isToday: false),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Weekly Volume Tonnage & Overload Card
              BentoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weekly Tonnage Volume',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          '${workoutState.totalVolumeTonnageThisWeek.round()} kg',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '📈 +4.8% Progressive Overload vs last week',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.karmaGreen,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Column(
                        children: [
                          const Text('Sessions',
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textMuted)),
                          Text(
                            '${workoutState.completedWorkoutsThisWeek}/5',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.focusBlue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Today's Planned Exercises Preview
              const Text(
                'PLANNED EXERCISE BLUEPRINT (आज के निर्धारित व्यायाम)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...session.plannedExercises.map((planned) {
                final ex = planned.exercise;
                final isDesi = ex.equipment == EquipmentType.traditionalIndian;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isDesi
                                    ? AppColors.energyOrange
                                    : AppColors.focusBlue)
                                .withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Icon(
                            isDesi
                                ? Icons.sports_kabaddi_rounded
                                : Icons.fitness_center_rounded,
                            color: isDesi
                                ? AppColors.energyOrange
                                : AppColors.focusBlue,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ex.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.textPrimary)),
                              Text(ex.regionalName,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${planned.targetSets} sets • ${planned.targetRepsMin}-${planned.targetRepsMax} reps',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.karmaGreen),
                            ),
                            if (planned.suggestedWeightKg > 0)
                              Text(
                                '${planned.suggestedWeightKg} kg suggested',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary),
                              )
                            else
                              const Text(
                                'Bodyweight / Akhara',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.energyOrange),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySchedulePill({
    required String day,
    required String split,
    required bool isCompleted,
    required bool isToday,
  }) {
    return Column(
      children: [
        Text(day,
            style: TextStyle(
                fontSize: 10,
                color: isToday ? AppColors.karmaGreen : AppColors.textMuted,
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w500)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.karmaGreen.withValues(alpha: 0.2)
                : (isCompleted
                    ? AppColors.focusBlue.withValues(alpha: 0.15)
                    : AppColors.surface),
            borderRadius: AppRadii.radiusSm,
            border: Border.all(
              color: isToday
                  ? AppColors.karmaGreen
                  : (isCompleted ? AppColors.focusBlue : AppColors.glassBorder),
            ),
          ),
          child: Column(
            children: [
              Text(
                split,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isToday
                      ? AppColors.karmaGreen
                      : (isCompleted
                          ? AppColors.focusBlue
                          : AppColors.textSecondary),
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_rounded,
                    color: AppColors.focusBlue, size: 10),
            ],
          ),
        ),
      ],
    );
  }
}
