import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/strain_system_engine.dart';

class StrainGaugeCard extends StatelessWidget {
  final StrainCalculationResult strain;
  final VoidCallback? onTap;

  const StrainGaugeCard({
    super.key,
    required this.strain,
    this.onTap,
  });

  Color _getCategoryColor(StrainCategory category) {
    switch (category) {
      case StrainCategory.light:
        return AppColors.focusBlue;
      case StrainCategory.moderate:
        return AppColors.karmaGreen;
      case StrainCategory.high:
        return AppColors.energyOrange;
      case StrainCategory.allOut:
        return AppColors.alertRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strainColor = _getCategoryColor(strain.category);

    return BentoCard(
      hasGlow: strain.isOverreaching,
      glowColor: AppColors.alertRed,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Daily Strain & Exertion',
                regionalText: 'दैनिक शारीरिक परिश्रम',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: strainColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: strainColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  strain.category.name,
                  style: AppTypography.bodySmall.copyWith(
                    color: strainColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Central Score Gauge with Target Range Ring
          Row(
            children: [
              ActivityRings(
                size: 105,
                rings: [
                  RingData(
                    progress: (strain.currentStrain / 21.0).clamp(0.0, 1.0),
                    color: strainColor,
                    strokeWidth: 10,
                  ),
                ],
                centerWidget: Text(
                  strain.currentStrain.toStringAsFixed(1),
                  style: AppTypography.displayMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlowingMetric(
                      label: 'Target Strain Window',
                      value: '${strain.targetStrainMin.toStringAsFixed(0)} – ${strain.targetStrainMax.toStringAsFixed(0)}',
                      unit: '/ 21.0',
                      accentColor: AppColors.karmaGreen,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Based on today’s readiness score.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Exertion Sources Breakdown
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSourceItem('Steps', '${strain.stepsStrainContribution}', Icons.directions_walk_rounded, AppColors.focusBlue),
                _buildSourceItem('Workout', '${strain.workoutStrainContribution}', Icons.fitness_center_rounded, AppColors.karmaGreen),
                _buildSourceItem('Heat Cost', '${strain.heatStrainContribution}', Icons.whatshot_rounded, AppColors.energyOrange),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Actionable Status Guidance
          Text(
            strain.statusGuidance,
            style: AppTypography.bodySmall.copyWith(
              color: strain.isOverreaching ? AppColors.alertRed : AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
