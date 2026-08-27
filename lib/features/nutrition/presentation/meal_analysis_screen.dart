import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/meal_analysis_engine.dart';
import '../domain/nutrition_models.dart';
import '../providers/nutrition_provider.dart';

class MealAnalysisScreen extends ConsumerWidget {
  final MealPhase phase;

  const MealAnalysisScreen({
    super.key,
    this.phase = MealPhase.lunch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrition = ref.watch(nutritionProvider);
    final meals = nutrition.getMealsForPhase(phase);
    final analysis = MealAnalysisEngine.analyzeMeal(meals);
    final gradeColor = Color(analysis.grade.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: BilingualLabel(
          primaryText: '${phase.name} Analysis',
          regionalText: '${phase.regionalName} विश्लेषण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Composite Quality Score Card
              BentoCard(
                hasGlow: true,
                glowColor: gradeColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Meal Quality Score',
                          regionalText: 'भोजन गुणवत्ता समग्र स्कोर',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: gradeColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: gradeColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'GRADE ${analysis.grade.grade}',
                            style: TextStyle(color: gradeColor, fontSize: 12, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Meal Score',
                          value: '${analysis.compositeScore}',
                          unit: '/100',
                          isHero: true,
                          accentColor: gradeColor,
                        ),
                        GlowingMetric(
                          label: 'Total Calories',
                          value: '${analysis.totalCalories}',
                          unit: 'kcal',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Protein',
                          value: '${analysis.totalProteinGrams}g',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      analysis.metabolicImpactSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Multi-Dimension Quality Metrics Breakdown
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Nutritional Dimensions',
                      regionalText: 'पोषण आयाम विश्लेषण',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildDimensionProgress('Protein Density (प्रोटीन घनत्व)', analysis.proteinDensityScore, AppColors.energyOrange),
                    const SizedBox(height: AppSpacing.sm),
                    _buildDimensionProgress('Fiber & Glycemic Balance (फाइबर संतुलन)', analysis.glycemicFiberScore, AppColors.karmaGreen),
                    const SizedBox(height: AppSpacing.sm),
                    _buildDimensionProgress('Satiety & Fullness Index (तृप्ति सूचकांक)', analysis.satietyScore, AppColors.focusBlue),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Macronutrient Gram Breakdown
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMacroPill('Protein', '${analysis.totalProteinGrams}g', AppColors.energyOrange),
                    _buildMacroPill('Carbs', '${analysis.totalCarbsGrams}g', AppColors.focusBlue),
                    _buildMacroPill('Fats', '${analysis.totalFatsGrams}g', AppColors.aiPurple),
                    _buildMacroPill('Fiber', '${analysis.totalFiberGrams}g', AppColors.karmaGreen),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Smart Indian Food Calibration Suggestions
              const Text(
                'SMART INDIAN FOOD CALIBRATIONS (स्मार्ट आहार सुझाव)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...analysis.calibrationSuggestions.map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 18),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            tip,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionProgress(String label, int score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            Text('$score / 100', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: (score / 100.0).clamp(0.0, 1.0),
          backgroundColor: AppColors.surfaceElevated,
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 5,
          borderRadius: AppRadii.radiusSm,
        ),
      ],
    );
  }

  Widget _buildMacroPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13)),
      ],
    );
  }
}
