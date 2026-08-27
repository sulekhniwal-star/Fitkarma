import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radii.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/theme/app_typography.dart';
import '../../../../shared/widgets/activity_rings.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../../../shared/widgets/glowing_metric.dart';
import '../../../metabolism/domain/adaptive_metabolism_engine.dart';
import '../../providers/onboarding_flow_provider.dart';

class AiDietPlanResultsScreen extends ConsumerWidget {
  const AiDietPlanResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingFlowProvider);

    // Compute tailored metabolic profile for this user's onboarding inputs
    final profile = AdaptiveMetabolismEngine.computeMetabolism(
      weightKg: onboardingState.weightKg,
      heightCm: onboardingState.heightCm,
      age: onboardingState.age,
      sex: onboardingState.sex,
      goal: onboardingState.nutritionGoal,
    );

    final totalMacrosCalories = (profile.targetProteinGrams * 4) +
        (profile.targetCarbsGrams * 4) +
        (profile.targetFatsGrams * 9);
    final proteinPercent = ((profile.targetProteinGrams * 4) / totalMacrosCalories).clamp(0.0, 1.0);
    final carbsPercent = ((profile.targetCarbsGrams * 4) / totalMacrosCalories).clamp(0.0, 1.0);
    final fatsPercent = ((profile.targetFatsGrams * 9) / totalMacrosCalories).clamp(0.0, 1.0);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                const BilingualLabel(
                  primaryText: 'Your AI Nutrition Blueprint',
                  regionalText: 'आपकी व्यक्तिगत पोषण योजना',
                  primaryStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Calibrated using your metabolic expenditure and customized for Indian dietary preferences.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 1. Calorie & Macro Target Bento Card
                BentoCard(
                  hasGlow: true,
                  glowColor: AppColors.karmaGreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GlowingMetric(
                                label: 'Daily Target',
                                value: '${profile.targetCalories}',
                                unit: 'kcal / day',
                                isHero: true,
                                accentColor: AppColors.karmaGreen,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getGoalSubtitle(onboardingState.nutritionGoal),
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.karmaGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          ActivityRings(
                            size: 100,
                            rings: [
                              RingData(
                                progress: proteinPercent,
                                color: AppColors.focusBlue,
                                strokeWidth: 8,
                              ),
                              RingData(
                                progress: carbsPercent,
                                color: AppColors.energyOrange,
                                strokeWidth: 8,
                              ),
                              RingData(
                                progress: fatsPercent,
                                color: AppColors.aiPurple,
                                strokeWidth: 8,
                              ),
                            ],
                            centerWidget: const Icon(
                              Icons.restaurant_rounded,
                              color: AppColors.karmaGreen,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      const SizedBox(height: AppSpacing.md),

                      // Macro Distribution Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMacroItem(
                            label: 'Protein',
                            regionalLabel: 'प्रोटीन',
                            value: '${profile.targetProteinGrams}g',
                            percent: '${(proteinPercent * 100).round()}%',
                            color: AppColors.focusBlue,
                          ),
                          _buildMacroItem(
                            label: 'Carbs',
                            regionalLabel: 'कार्ब्स',
                            value: '${profile.targetCarbsGrams}g',
                            percent: '${(carbsPercent * 100).round()}%',
                            color: AppColors.energyOrange,
                          ),
                          _buildMacroItem(
                            label: 'Fats',
                            regionalLabel: 'वसा',
                            value: '${profile.targetFatsGrams}g',
                            percent: '${(fatsPercent * 100).round()}%',
                            color: AppColors.aiPurple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 2. AI Nutrition Coach Insight
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.aiPurple.withValues(alpha: 0.15),
                          borderRadius: AppRadii.radiusSm,
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.aiPurple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BilingualLabel(
                              primaryText: 'AI Coach Insight',
                              regionalText: 'एआई कोच सलाह',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'To hit ${profile.targetProteinGrams}g protein on an Indian diet, distribute protein across 4 meals: incorporate paneer/tofu, sprouted moong, Greek yogurt, or sattu alongside high-protein daals.',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 3. Indian Meal Timing Split
                const Text(
                  'RECOMMENDED MEAL TIMING (भोजन समय)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildMealSplitCard(
                  time: '8:00 AM',
                  mealName: 'Breakfast / नाश्ता',
                  calories: '${(profile.targetCalories * 0.25).round()} kcal',
                  suggestion: 'Besan Chilla / 3 Eggs / Oats + Sattu shake',
                  icon: Icons.wb_sunny_outlined,
                  color: AppColors.focusBlue,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildMealSplitCard(
                  time: '1:00 PM',
                  mealName: 'Lunch / दोपहर का भोजन',
                  calories: '${(profile.targetCalories * 0.35).round()} kcal',
                  suggestion: 'Thick Daal, Paneer/Chicken, 2 Rotis, Fresh Salad',
                  icon: Icons.wb_sunny_rounded,
                  color: AppColors.energyOrange,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildMealSplitCard(
                  time: '5:30 PM',
                  mealName: 'Evening Snack / शाम का नाश्ता',
                  calories: '${(profile.targetCalories * 0.15).round()} kcal',
                  suggestion: 'Roasted Makhana, Sprout Chaat, Green Tea',
                  icon: Icons.local_cafe_outlined,
                  color: AppColors.karmaGreen,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildMealSplitCard(
                  time: '8:30 PM',
                  mealName: 'Dinner / रात्रि भोजन',
                  calories: '${(profile.targetCalories * 0.25).round()} kcal',
                  suggestion: 'Light vegetable soup with Soya chunks/Fish & sauteed greens',
                  icon: Icons.nightlight_round,
                  color: AppColors.aiPurple,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),

        // Confirm & Continue CTA
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppRadii.radiusMd,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.karmaGreen.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.radiusMd,
              ),
            ),
            onPressed: () {
              ref.read(onboardingFlowProvider.notifier).nextStep();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Accept Plan & Continue',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textInverse,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  String _getGoalSubtitle(NutritionGoal goal) {
    switch (goal) {
      case NutritionGoal.fatLoss:
        return 'Sustainable ~400 kcal Deficit Plan';
      case NutritionGoal.maintenance:
        return 'Energy Balance Maintenance Plan';
      case NutritionGoal.muscleGain:
        return 'Lean Hypertrophy ~250 kcal Surplus Plan';
    }
  }

  Widget _buildMacroItem({
    required String label,
    required String regionalLabel,
    required String value,
    required String percent,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$label ($percent)',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSplitCard({
    required String time,
    required String mealName,
    required String calories,
    required String suggestion,
    required IconData icon,
    required Color color,
  }) {
    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mealName,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      calories,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  suggestion,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
