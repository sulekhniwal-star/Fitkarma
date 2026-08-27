import 'package:flutter/material.dart';
import '../../../core/models/daily_intelligence_package.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/readiness_engine.dart';

class ReadinessGaugeCard extends StatelessWidget {
  final ReadinessEvaluationResult readiness;
  final VoidCallback? onTap;

  const ReadinessGaugeCard({
    super.key,
    required this.readiness,
    this.onTap,
  });

  Color _getZoneColor(ReadinessZone zone) {
    switch (zone) {
      case ReadinessZone.optimal:
        return AppColors.readinessOptimal;
      case ReadinessZone.moderate:
        return AppColors.readinessModerate;
      case ReadinessZone.recovery:
        return AppColors.readinessRecovery;
      case ReadinessZone.rest:
        return AppColors.readinessRest;
    }
  }

  String _getZoneRegional(ReadinessZone zone) {
    switch (zone) {
      case ReadinessZone.optimal:
        return 'उत्कृष्ट शारीरिक क्षमता';
      case ReadinessZone.moderate:
        return 'संतुलित क्षमता';
      case ReadinessZone.recovery:
        return 'सक्रिय पुनर्प्राप्ति';
      case ReadinessZone.rest:
        return 'पूर्ण विश्राम आवश्यक';
    }
  }

  @override
  Widget build(BuildContext context) {
    final zoneColor = _getZoneColor(readiness.zone);

    return BentoCard(
      hasGlow: readiness.zone == ReadinessZone.optimal,
      glowColor: zoneColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Body Readiness',
                regionalText: 'दैनिक शारीरिक तैयारी',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: zoneColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: zoneColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _getZoneRegional(readiness.zone),
                  style: AppTypography.bodySmall.copyWith(
                    color: zoneColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Central Score Gauge with Activity Ring
          Row(
            children: [
              ActivityRings(
                size: 110,
                rings: [
                  RingData(
                    progress: (readiness.score / 100).clamp(0.0, 1.0),
                    color: zoneColor,
                    strokeWidth: 12,
                  ),
                ],
                centerWidget: Text(
                  '${readiness.score}',
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
                      label: 'Readiness Zone',
                      value: readiness.zone.name.toUpperCase(),
                      accentColor: zoneColor,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Text(
                        readiness.tier.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Actionable Recommendation Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusMd,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.electric_bolt_rounded,
                  color: zoneColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    readiness.recommendation,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Safety Alert Banner
          if (readiness.safetyAlerts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.alertRed.withValues(alpha: 0.12),
                borderRadius: AppRadii.radiusSm,
                border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.alertRed, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      readiness.safetyAlerts.first,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.alertRed),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
