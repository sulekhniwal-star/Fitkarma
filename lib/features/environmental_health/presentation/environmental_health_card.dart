import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/environmental_health_engine.dart';

class EnvironmentalHealthCard extends StatelessWidget {
  final EnvironmentalHealthSnapshot snapshot;
  final VoidCallback? onTap;

  const EnvironmentalHealthCard({
    super.key,
    required this.snapshot,
    this.onTap,
  });

  Color _getAqiColor(AqiCategory category) {
    switch (category) {
      case AqiCategory.good:
        return AppColors.karmaGreen;
      case AqiCategory.satisfactory:
        return const Color(0xFF81C784);
      case AqiCategory.moderate:
        return const Color(0xFFFFB74D);
      case AqiCategory.poor:
        return AppColors.energyOrange;
      case AqiCategory.veryPoor:
        return AppColors.alertRed;
      case AqiCategory.severe:
        return const Color(0xFFB71C1C);
    }
  }

  String _getAqiRegional(AqiCategory category) {
    switch (category) {
      case AqiCategory.good:
        return 'उत्तम वायु';
      case AqiCategory.satisfactory:
        return 'संतोषजनक वायु';
      case AqiCategory.moderate:
        return 'मध्यम वायु';
      case AqiCategory.poor:
        return 'खराब वायु';
      case AqiCategory.veryPoor:
        return 'अति खराब';
      case AqiCategory.severe:
        return 'गंभीर वायु';
    }
  }

  @override
  Widget build(BuildContext context) {
    final aqiColor = _getAqiColor(snapshot.aqiCategory);

    return BentoCard(
      hasGlow: !snapshot.outdoorWorkoutAllowed,
      glowColor: AppColors.alertRed,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Environmental Health',
                regionalText: 'पर्यावरणीय स्वास्थ्य सूचकांक',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: aqiColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: aqiColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _getAqiRegional(snapshot.aqiCategory),
                  style: AppTypography.bodySmall.copyWith(
                    color: aqiColor,
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
                label: 'Air Quality (AQI)',
                value: '${snapshot.aqi}',
                accentColor: aqiColor,
                trend: snapshot.aqi <= 100 ? MetricTrend.up : MetricTrend.down,
                trendLabel: snapshot.aqiCategory.name.toUpperCase(),
              ),
              GlowingMetric(
                label: 'Heat Index',
                value: '${snapshot.heatIndexC.round()}°C',
                accentColor: snapshot.heatRisk == HeatRiskLevel.low ? AppColors.focusBlue : AppColors.energyOrange,
              ),
              GlowingMetric(
                label: 'UV Index',
                value: snapshot.uvIndex.toStringAsFixed(1),
                accentColor: AppColors.aiPurple,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: snapshot.outdoorWorkoutAllowed
                  ? AppColors.surfaceElevated
                  : AppColors.alertRed.withValues(alpha: 0.12),
              borderRadius: AppRadii.radiusMd,
              border: Border.all(
                color: snapshot.outdoorWorkoutAllowed ? AppColors.glassBorder : AppColors.alertRed.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  snapshot.outdoorWorkoutAllowed ? Icons.wb_sunny_outlined : Icons.warning_amber_rounded,
                  color: snapshot.outdoorWorkoutAllowed ? AppColors.focusBlue : AppColors.alertRed,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    snapshot.recommendation,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (snapshot.extraHydrationMl > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.water_drop_outlined, color: AppColors.focusBlue, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Heat Advisory: +${snapshot.extraHydrationMl} ml extra hydration recommended.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
