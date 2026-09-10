import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/fitness_blueprint_engine.dart';

class FitnessBlueprintScreen extends ConsumerStatefulWidget {
  const FitnessBlueprintScreen({super.key});

  @override
  ConsumerState<FitnessBlueprintScreen> createState() =>
      _FitnessBlueprintScreenState();
}

class _FitnessBlueprintScreenState
    extends ConsumerState<FitnessBlueprintScreen> {
  FitnessGoal _selectedGoal = FitnessGoal.hypertrophy;
  final TrainingExperience _selectedExperience =
      TrainingExperience.intermediate;
  EquipmentEnvironment _selectedEquipment = EquipmentEnvironment.commercialGym;
  int _selectedDaysPerWeek = 4;

  @override
  Widget build(BuildContext context) {
    final blueprint = FitnessBlueprintEngine.generateBlueprint(
      goal: _selectedGoal,
      experience: _selectedExperience,
      equipment: _selectedEquipment,
      frequencyDaysPerWeek: _selectedDaysPerWeek,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Dynamic Fitness Blueprint',
          regionalText: 'अनुकूली कसरत ब्लूप्रिंट जेनरेटर',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Goal Selector Chips
              const Text(
                'PRIMARY TRAINING GOAL (मुख्य प्रशिक्षण लक्ष्य)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5),
              ),
              const SizedBox(height: AppSpacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: FitnessGoal.values.map((g) {
                    final isSelected = g == _selectedGoal;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(g.label),
                        selected: isSelected,
                        selectedColor:
                            AppColors.karmaGreen.withValues(alpha: 0.2),
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.karmaGreen
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.karmaGreen
                              : AppColors.glassBorder,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedGoal = g);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Frequency & Equipment Selectors Bento
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Weekly Frequency',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textPrimary)),
                        Text(
                          '$_selectedDaysPerWeek Days / Week',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: AppColors.focusBlue),
                        ),
                      ],
                    ),
                    Slider(
                      value: _selectedDaysPerWeek.toDouble(),
                      min: 3.0,
                      max: 6.0,
                      divisions: 3,
                      activeColor: AppColors.focusBlue,
                      onChanged: (val) =>
                          setState(() => _selectedDaysPerWeek = val.round()),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Equipment:',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary)),
                        ),
                        DropdownButton<EquipmentEnvironment>(
                          value: _selectedEquipment,
                          dropdownColor: AppColors.surfaceElevated,
                          underline: const SizedBox(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.karmaGreen,
                              fontWeight: FontWeight.w700),
                          items: EquipmentEnvironment.values.map((e) {
                            return DropdownMenuItem(
                                value: e, child: Text(e.label));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedEquipment = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Hero Generated Blueprint Overview Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.karmaGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BilingualLabel(
                            primaryText: blueprint.title,
                            regionalText: blueprint.regionalTitle,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.karmaGreen.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color: AppColors.karmaGreen
                                    .withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            '4-WEEK MESOCYCLE',
                            style: TextStyle(
                                color: AppColors.karmaGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Total Sessions',
                          value: '${blueprint.weeklySessions.length}',
                          unit: '/ week',
                          isHero: true,
                          accentColor: AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Weekly Sets',
                          value: '${blueprint.totalWeeklySets}',
                          unit: 'sets',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Rep Target',
                          value:
                              '${blueprint.goal.repsMin}-${blueprint.goal.repsMax}',
                          unit: 'reps',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      blueprint.periodizationFramework,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.focusBlue,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      blueprint.biomechanicalRationale,
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Weekly Volume Distribution per Muscle Group
              const Text(
                'WEEKLY VOLUME LOAD PER MUSCLE (साप्ताहिक वॉल्यूम भार)',
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
                child: Column(
                  children:
                      blueprint.weeklyVolumeDistribution.entries.map((entry) {
                    final double frac = (entry.value / 20.0).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: AppColors.textPrimary)),
                              Text('${entry.value} sets',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: AppColors.karmaGreen)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: frac,
                              backgroundColor: AppColors.surface,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.karmaGreen),
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 5. Day-by-Day Session Breakdown
              const Text(
                'SCHEDULED TRAINING SESSIONS (सत्रवार व्यायाम योजना)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...blueprint.weeklySessions.map((sess) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sess.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColors.textPrimary)),
                                Text(sess.regionalTitle,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textMuted)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: AppRadii.radiusSm,
                              ),
                              child: Text(
                                '${sess.estimatedDurationMinutes}m • ${sess.plannedExercises.length} moves',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.focusBlue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...sess.plannedExercises.map((planned) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '• ${planned.exercise.name}',
                                  style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 11),
                                ),
                                Text(
                                  '${planned.targetSets} sets × ${planned.targetRepsMin}-${planned.targetRepsMax}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.karmaGreen),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // Activate Blueprint CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.karmaGreen,
                    foregroundColor: AppColors.textInverse,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusSm),
                  ),
                  icon: const Icon(Icons.rocket_launch_rounded, size: 20),
                  label: const Text(
                    'Activate Blueprint as Active Program',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.surfaceElevated,
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.karmaGreen, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Blueprint "${blueprint.title}" activated for the next 4-week cycle!',
                                style: const TextStyle(
                                    color: AppColors.textPrimary, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
