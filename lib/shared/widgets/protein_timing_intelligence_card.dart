import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import 'package:fitkarma/features/nutrition/models/protein_timing_evaluator.dart';
import 'package:fitkarma/features/nutrition/providers/nutrition_provider.dart';

/// §P5-H Protein Timing & MPS Intelligence Card
class ProteinTimingIntelligenceCard extends ConsumerWidget {
  const ProteinTimingIntelligenceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionProvider);
    const evaluator = ProteinTimingEvaluator();
    final result = evaluator.evaluateDistribution(state.loggedMeals);

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
                  const Icon(Icons.bolt, color: AppColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text('MPS Protein Timing', style: AppTypography.h3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getScoreColor(result.score).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Timing Score: ${result.score.round()}/100',
                  style: AppTypography.labelMd.copyWith(color: _getScoreColor(result.score)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 3 Main Meals MPS Threshold Badges (25g Target)
          Row(
            children: [
              Expanded(
                child: _MpsMealPill(
                  label: 'Breakfast',
                  proteinG: result.breakfastProteinG,
                  isMet: result.breakfastProteinG >= ProteinTimingEvaluator.mpsThresholdGrams,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MpsMealPill(
                  label: 'Lunch',
                  proteinG: result.lunchProteinG,
                  isMet: result.lunchProteinG >= ProteinTimingEvaluator.mpsThresholdGrams,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MpsMealPill(
                  label: 'Dinner',
                  proteinG: result.dinnerProteinG,
                  isMet: result.dinnerProteinG >= ProteinTimingEvaluator.mpsThresholdGrams,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // AI Timing Nudge Message
          Text(
            result.feedback,
            style: AppTypography.bodySm.copyWith(height: 1.4, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.success;
    if (score >= 70) return AppColors.teal;
    if (score >= 40) return AppColors.accent;
    return AppColors.error;
  }
}

class _MpsMealPill extends StatelessWidget {
  final String label;
  final double proteinG;
  final bool isMet;

  const _MpsMealPill({
    required this.label,
    required this.proteinG,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMet ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.bodySm.copyWith(fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            '${proteinG.round()}g',
            style: AppTypography.labelLg.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
          Text(
            isMet ? 'MPS Met' : '<25g Target',
            style: AppTypography.bodySm.copyWith(fontSize: 9, color: color),
          ),
        ],
      ),
    );
  }
}
