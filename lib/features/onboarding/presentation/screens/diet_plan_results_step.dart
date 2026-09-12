import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../../../core/widgets/glowing_metric.dart';
import '../../../metabolism/services/metabolism_engine.dart';
import '../../domain/models/onboarding_state.dart';

class DietPlanResultsStep extends StatelessWidget {
  final OnboardingState state;
  final VoidCallback onFinish;

  const DietPlanResultsStep({
    super.key,
    required this.state,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    const engine = MetabolismEngine();
    final metabolic = engine.calculateProfile(
      weightKg: state.weightKg,
      heightCm: state.heightCm,
      age: state.age,
      gender: state.gender,
      activityLevel: state.activityLevel,
      goal: state.goal ?? Goal.fatLoss,
    );

    final dosha = state.doshaProfile;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BilingualLabel(
            english: 'Your Personalized Health Blueprint',
            hindi: 'आपकी व्यक्तिगत स्वास्थ्य योजना तैयार है',
            primaryStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                // 1. Daily Calorie Target Hero Bento
                BentoCard(
                  isGlowing: true,
                  glowColor: AppColors.primaryEmerald,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BilingualLabel(
                              english: 'Daily Calorie Target',
                              hindi: 'दैनिक कैलोरी लक्ष्य',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'BMR: ${metabolic.bmr.toInt()} kcal | TDEE: ${metabolic.tdee.toInt()} kcal',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      GlowingMetric(
                        value: '${metabolic.targetCalories.toInt()}',
                        unit: 'kcal',
                        label: 'Target',
                        hindiLabel: 'दैनिक लक्ष्य',
                        glowColor: AppColors.primaryEmerald,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Indian Macronutrient Breakdown Bento
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BilingualLabel(
                        english: 'Indian Macro Split & Protein Target',
                        hindi: 'दैनिक पोषक तत्व विभाजन',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNutrientColumn('Protein (प्रोटीन)', '${metabolic.targetProteinGrams}g', AppColors.primaryCyan),
                          _buildNutrientColumn('Carbs (कार्ब्स)', '${metabolic.targetCarbsGrams}g', AppColors.accentAmber),
                          _buildNutrientColumn('Fats (फैट्स)', '${metabolic.targetFatsGrams}g', AppColors.accentCoral),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Dosha Nutrition Guidance Bento
                if (dosha != null) ...[
                  BentoCard(
                    glowColor: AppColors.primaryCyan,
                    isGlowing: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BilingualLabel(
                              english: dosha.title,
                              hindi: dosha.titleHindi,
                              primaryStyle: AppTypography.h3.copyWith(color: AppColors.primaryCyan),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryCyan.withAlpha(40),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${dosha.dominantDosha.name.toUpperCase()} DOMINANT',
                                style: AppTypography.label.copyWith(color: AppColors.primaryCyan),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(dosha.summary, style: AppTypography.bodySmall),
                        const SizedBox(height: 4),
                        Text(dosha.summaryHindi, style: AppTypography.bilingualSub),
                        const Divider(height: 20),
                        ...dosha.dietaryGuidance.map(
                          (guide) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🌿 ', style: TextStyle(fontSize: 14)),
                                Expanded(child: Text(guide, style: AppTypography.bodySmall)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCyan,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Enter FitKarma Health OS  •  शुरू करें',
              style: AppTypography.h3.copyWith(color: AppColors.background, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientColumn(String title, String grams, Color color) {
    return Column(
      children: [
        Text(grams, style: AppTypography.h3.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(title, style: AppTypography.bodySmall),
      ],
    );
  }
}
