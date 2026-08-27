import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/adaptive_metabolism_engine.dart';

class MetabolismCard extends StatelessWidget {
  final AdaptiveMetabolismProfile profile;
  final VoidCallback? onTap;

  const MetabolismCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  Color _getStateColor(MetabolicState state) {
    switch (state) {
      case MetabolicState.normal:
        return AppColors.karmaGreen;
      case MetabolicState.elevated:
        return AppColors.focusBlue;
      case MetabolicState.suppressed:
        return AppColors.energyOrange;
    }
  }

  String _getStateRegional(MetabolicState state) {
    switch (state) {
      case MetabolicState.normal:
        return 'सामान्य चयापचय';
      case MetabolicState.elevated:
        return 'तीव्र चयापचय';
      case MetabolicState.suppressed:
        return 'धीमा चयापचय';
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateColor = _getStateColor(profile.metabolicState);

    return BentoCard(
      hasGlow: profile.metabolicState == MetabolicState.elevated,
      glowColor: stateColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Adaptive Metabolism',
                regionalText: 'अनुकूली चयापचय प्रणाली',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: stateColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _getStateRegional(profile.metabolicState),
                  style: AppTypography.bodySmall.copyWith(
                    color: stateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlowingMetric(
                label: 'True TDEE',
                value: '${profile.dynamicTdee.round()}',
                unit: 'kcal',
                accentColor: stateColor,
                trend: profile.adaptationFactor >= 1.0 ? MetricTrend.up : MetricTrend.down,
                trendLabel: '${((profile.adaptationFactor - 1.0) * 100).round() >= 0 ? '+' : ''}${((profile.adaptationFactor - 1.0) * 100).round()}%',
              ),
              GlowingMetric(
                label: 'Daily Target',
                value: '${profile.targetCalories}',
                unit: 'kcal',
                accentColor: AppColors.karmaGreen,
              ),
              GlowingMetric(
                label: 'Protein Target',
                value: '${profile.targetProteinGrams}',
                unit: 'g',
                accentColor: AppColors.focusBlue,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroPill('Protein', '${profile.targetProteinGrams}g', AppColors.focusBlue),
                _buildMacroPill('Carbs', '${profile.targetCarbsGrams}g', AppColors.energyOrange),
                _buildMacroPill('Fats', '${profile.targetFatsGrams}g', AppColors.aiPurple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
