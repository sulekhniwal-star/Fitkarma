import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/meal_analysis_pipeline.dart';

/// §P5-B Meal Analysis Pipeline Output Bottom Sheet / View
class MealAnalysisResultSheet extends StatelessWidget {
  final FullMealAnalysisResult result;
  final VoidCallback onConfirmLog;

  const MealAnalysisResultSheet({
    super.key,
    required this.result,
    required this.onConfirmLog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(result.foodItem.name, style: AppTypography.h2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Score: ${result.quality.overallScore}/100',
                    style: AppTypography.labelMd.copyWith(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${result.totalCalories.round()} kcal · ${result.servings} serving(s)',
              style: AppTypography.bodySm,
            ),
            const SizedBox(height: AppSpacing.md),

            // Macros Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroPill(label: 'Protein', value: '${result.totalProteinGrams.round()}g', color: AppColors.primary),
                _MacroPill(label: 'Carbs', value: '${result.totalCarbsGrams.round()}g', color: AppColors.teal),
                _MacroPill(label: 'Fat', value: '${result.totalFatGrams.round()}g', color: AppColors.accent),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Readiness & Goal Impact
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.success, size: 18),
                      const SizedBox(width: 6),
                      Text('Readiness Impact', style: AppTypography.labelMd.copyWith(color: AppColors.success)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(result.readinessImpact, style: AppTypography.bodySm),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.teal, size: 18),
                      const SizedBox(width: 6),
                      Text('Goal Impact', style: AppTypography.labelMd.copyWith(color: AppColors.teal)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(result.goalImpact, style: AppTypography.bodySm),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Template-Based Fix Suggestions
            Text('Smart Meal Fix Suggestions', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.sm),
            for (final suggestion in result.fixSuggestions)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: AppTypography.bodyMd.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.lg),

            // Confirm Log Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                ),
                onPressed: onConfirmLog,
                child: Text('Add to Food Log', style: AppTypography.labelLg.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySm),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.h3.copyWith(color: color)),
      ],
    );
  }
}
