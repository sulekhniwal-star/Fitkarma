import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../core/brain/adherence_score_calculator.dart';
import 'glass_card.dart';

/// §P7-D Adherence Score Dashboard Widget
class AdherenceScoreWidget extends StatelessWidget {
  final AdherenceResult result;

  const AdherenceScoreWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    String trendIcon = '→';
    Color trendColor = AppColors.textSecondary;
    if (result.trend == AdherenceTrend.improving) {
      trendIcon = '↑';
      trendColor = AppColors.success;
    } else if (result.trend == AdherenceTrend.declining) {
      trendIcon = '↓';
      trendColor = AppColors.accent;
    }

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('📊 Adherence Score', style: AppTypography.h3),
              if (result.xpMultiplier > 1.0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '⚡ +50% XP Boost Active',
                    style: AppTypography.labelSmall.copyWith(
                        color: AppColors.warning, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              Text('Overall: ', style: AppTypography.bodySm),
              Text('${result.overallScore}%', style: AppTypography.h2),
              const SizedBox(width: 8),
              Text(
                '$trendIcon ${result.period}',
                style: AppTypography.labelLg.copyWith(color: trendColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Breakdown Bars
          _buildScoreRow('Nutrition', result.nutritionScore, AppColors.teal),
          const SizedBox(height: 6),
          _buildScoreRow('Training', result.trainingScore, AppColors.primary),
          const SizedBox(height: 6),
          _buildScoreRow('Recovery', result.recoveryScore, AppColors.purple),

          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bg0,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your weakest area: ${result.weakestArea}',
                  style:
                      AppTypography.labelLg.copyWith(color: AppColors.accent),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tip: ${result.coachingTip}',
                  style: AppTypography.bodySm
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (result.triggersCoachCheckIn)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '🤖 AI Coach proactive check-in triggered due to < 70% adherence.',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.warning),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, int score, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(label, style: AppTypography.bodySm),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100.0,
              backgroundColor: AppColors.glassBorder,
              color: color,
              minHeight: 8.0,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 35,
          child: Text('$score%',
              style: AppTypography.labelLg, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
