import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/sleep_intelligence_engine.dart';

class SleepIntelligenceCard extends StatelessWidget {
  final SleepSessionData session;
  final double sleepDebtHours;
  final VoidCallback? onTap;

  const SleepIntelligenceCard({
    super.key,
    required this.session,
    this.sleepDebtHours = 1.2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final analysis = SleepIntelligenceEngine.evaluateSleep(
      session: session,
      rolling7DaySleepDebt: sleepDebtHours,
    );

    final Color scoreColor = analysis.sleepScore >= 80
        ? AppColors.karmaGreen
        : analysis.sleepScore >= 60
            ? AppColors.energyOrange
            : AppColors.alertRed;

    return BentoCard(
      hasGlow: analysis.sleepScore >= 80,
      glowColor: AppColors.aiPurple,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Sleep Intelligence',
                regionalText: 'नींद एवं रिकवरी विश्लेषण',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.aiPurple.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${session.totalSleepHours.toStringAsFixed(1)}h Total',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.aiPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Central Score Gauge with Activity Rings
          Row(
            children: [
              ActivityRings(
                size: 100,
                rings: [
                  RingData(
                    progress: analysis.deepSleepPercent,
                    color: AppColors.focusBlue,
                    strokeWidth: 8,
                  ),
                  RingData(
                    progress: analysis.remSleepPercent,
                    color: AppColors.aiPurple,
                    strokeWidth: 8,
                  ),
                ],
                centerWidget: Text(
                  '${analysis.sleepScore}',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: scoreColor,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis.sleepQualityCategory,
                      style: AppTypography.bodySmall.copyWith(
                        color: scoreColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildStagePill('Deep', '${(analysis.deepSleepPercent * 100).round()}%', AppColors.focusBlue),
                        const SizedBox(width: 6),
                        _buildStagePill('REM', '${(analysis.remSleepPercent * 100).round()}%', AppColors.aiPurple),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Bedtime & Sleep Debt Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlowingMetric(
                label: '7-Day Sleep Debt',
                value: '${analysis.sleepDebtHours.toStringAsFixed(1)}h',
                accentColor: analysis.sleepDebtHours > 2.5 ? AppColors.alertRed : AppColors.karmaGreen,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Optimal Bedtime Window', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    analysis.optimalBedtimeWindow,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStagePill(String label, String percent, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
      ),
      child: Text(
        '$label: $percent',
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
