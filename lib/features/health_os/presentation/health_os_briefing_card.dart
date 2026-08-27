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

class HealthOsBriefingCard extends StatelessWidget {
  final DailyIntelligencePackage package;
  final VoidCallback? onTap;

  const HealthOsBriefingCard({
    super.key,
    required this.package,
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
        return 'उत्कृष्ट तैयारी';
      case ReadinessZone.moderate:
        return 'संतुलित तैयारी';
      case ReadinessZone.recovery:
        return 'सक्रिय पुनर्प्राप्ति';
      case ReadinessZone.rest:
        return 'पूर्ण विश्राम';
    }
  }

  @override
  Widget build(BuildContext context) {
    final zoneColor = _getZoneColor(package.readinessZone);

    return BentoCard(
      hasGlow: package.readinessZone == ReadinessZone.optimal,
      glowColor: zoneColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Bilingual Title + Readiness Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Daily Health OS',
                regionalText: 'दैनिक स्वास्थ्य प्रणाली',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: zoneColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: zoneColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  _getZoneRegional(package.readinessZone),
                  style: AppTypography.bodySmall.copyWith(
                    color: zoneColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Central Rings & Scores
          Row(
            children: [
              ActivityRings(
                size: 110,
                rings: [
                  RingData(
                    progress: (package.healthScore / 100).clamp(0.0, 1.0),
                    color: AppColors.karmaGreen,
                    strokeWidth: 10,
                  ),
                  RingData(
                    progress: (package.readinessScore / 100).clamp(0.0, 1.0),
                    color: zoneColor,
                    strokeWidth: 10,
                  ),
                ],
                centerWidget: Text(
                  '${package.healthScore}',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlowingMetric(
                      label: 'Readiness Score',
                      value: '${package.readinessScore}',
                      unit: '/ 100',
                      accentColor: zoneColor,
                      trend: package.readinessScore >= 75
                          ? MetricTrend.up
                          : (package.readinessScore >= 50 ? MetricTrend.neutral : MetricTrend.down),
                      trendLabel: package.readinessZone.name.toUpperCase(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      package.workoutRecommendation,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // AI Morning Briefing Narrative
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
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.aiPurple,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    package.aiBriefing,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Safety Alerts Banner (if any)
          if (package.safetyAlerts.isNotEmpty) ...[
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
                      package.safetyAlerts.first,
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
