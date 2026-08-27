import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/recovery_forecasting_engine.dart';

class RecoveryForecastingCard extends StatelessWidget {
  final RecoveryAgeReport report;
  final VoidCallback? onTap;

  const RecoveryForecastingCard({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isYounger = report.ageDelta <= 0;
    final accentColor = isYounger ? AppColors.karmaGreen : AppColors.energyOrange;

    return BentoCard(
      hasGlow: isYounger,
      glowColor: accentColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Biological Recovery Age',
                regionalText: 'जैविक रिकवरी आयु एवं पूर्वानुमान',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  isYounger
                      ? '${report.ageDelta.abs().toStringAsFixed(1)} YRS YOUNGER'
                      : '+${report.ageDelta.toStringAsFixed(1)} YRS STRAIN',
                  style: AppTypography.bodySmall.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Recovery Age Comparison Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlowingMetric(
                    label: 'Biological Age',
                    value: report.biologicalRecoveryAge.toStringAsFixed(1),
                    unit: 'years',
                    isHero: true,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Chronological: ${report.chronologicalAge} yrs',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.glassBorder,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: Text(
                    report.recoveryLongevityInsight,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.glassBorder, height: 1),
          const SizedBox(height: AppSpacing.md),

          // 48-Hour Predictive Readiness Forecast
          const Text(
            '48-HOUR READINESS FORECAST (आगामी रिकवरी पूर्वानुमान)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: report.forecasts.map((f) {
              final Color forecastColor = f.projectedReadiness >= 80
                  ? AppColors.karmaGreen
                  : f.projectedReadiness >= 60
                      ? AppColors.energyOrange
                      : AppColors.alertRed;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(
                      color: f.isPrWindow ? AppColors.karmaGreen.withValues(alpha: 0.5) : AppColors.glassBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            f.dayLabel,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${f.projectedReadiness}%',
                            style: AppTypography.titleSmall.copyWith(
                              color: forecastColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        f.optimalFocus,
                        style: AppTypography.bodySmall.copyWith(
                          color: f.isPrWindow ? AppColors.karmaGreen : AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
