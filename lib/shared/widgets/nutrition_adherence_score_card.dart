import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import 'package:fitkarma/features/nutrition/models/nutrition_adherence_engine.dart';
import 'package:fitkarma/features/nutrition/providers/nutrition_provider.dart';

/// §P5-J Nutrition Adherence Score Card Component
class NutritionAdherenceScoreCard extends ConsumerWidget {
  const NutritionAdherenceScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionProvider);
    const engine = NutritionAdherenceEngine();

    final adherenceLog = DailyAdherenceLog(
      totalCalories: state.totalCalories,
      totalProtein: state.totalProtein,
      loggedMeals: state.loggedMeals,
    );

    final result = engine.calculateDailyScore(
      log: adherenceLog,
      targetCalories: state.targetCalories,
      targetProtein: state.targetProtein,
    );

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppColors.teal, size: 20),
                  const SizedBox(width: 6),
                  Text('Nutrition Adherence Score', style: AppTypography.h3),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${result.totalScore.round()}/100',
                  style: AppTypography.labelMd.copyWith(
                      color: AppColors.teal, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 4 Matrix Breakdown Rows
          _AdherenceMatrixRow(
              label: 'Calorie Target (±10%)',
              pts: result.caloriePoints,
              maxPts: 30),
          const SizedBox(height: 6),
          _AdherenceMatrixRow(
              label: 'Protein Target (±15%)',
              pts: result.proteinPoints,
              maxPts: 35),
          const SizedBox(height: 6),
          _AdherenceMatrixRow(
              label: 'Logging Completeness (≥3 meals)',
              pts: result.loggingCompletenessPoints,
              maxPts: 20),
          const SizedBox(height: 6),
          _AdherenceMatrixRow(
              label: 'Meal Timing Stability (±60 min)',
              pts: result.timingStabilityPoints,
              maxPts: 15),
          const SizedBox(height: AppSpacing.md),

          // Feedback Message
          Text(
            result.feedback,
            style: AppTypography.bodySm
                .copyWith(color: AppColors.textSecondary, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _AdherenceMatrixRow extends StatelessWidget {
  final String label;
  final double pts;
  final double maxPts;

  const _AdherenceMatrixRow({
    required this.label,
    required this.pts,
    required this.maxPts,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = pts / maxPts;
    final color = ratio >= 0.8
        ? AppColors.success
        : (ratio >= 0.4 ? AppColors.accent : AppColors.error);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
            Text(
              '${pts.round()}/${maxPts.round()} pts',
              style: AppTypography.bodySm.copyWith(
                  fontSize: 11, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 4,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
