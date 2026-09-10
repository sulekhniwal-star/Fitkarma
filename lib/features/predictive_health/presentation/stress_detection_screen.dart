import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/stress_detection_models.dart';
import 'providers/stress_detection_provider.dart';

/// Screen displaying Inferred Autonomic Stress Monitoring, 24h Chrono-Stress Curve,
/// Contributing Biomarker Signals, and Vagal Down-Regulation Protocols.
class StressDetectionScreen extends ConsumerWidget {
  const StressDetectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(stressDetectionProvider);
    final tierColor = Color(report.currentTier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Inferred Stress & Vagal OS',
          regionalText: 'स्वायत्त तनाव व वेगल तंत्रिका निगरानी',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showAutonomicMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Real-Time Stress Score Card
            _buildHeroStressCard(report, tierColor),
            const SizedBox(height: AppSpacing.md),

            // 2. High Stress Alert Banner (if elevated or acute overload)
            if (report.currentTier == StressLevelTier.elevated ||
                report.currentTier == StressLevelTier.acuteOverload) ...[
              _buildHighStressAlert(report),
              const SizedBox(height: AppSpacing.md),
            ],

            // 3. Clinical Autonomic Synthesis Card
            _buildAutonomicSummaryCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. 24-Hour Intraday Chrono-Stress Curve
            const BilingualLabel(
              primaryText: '24-Hour Intraday Stress Timeline',
              regionalText: '२४-घंटे दैनिक तनाव व हृदय गति वक्र',
            ),
            const SizedBox(height: AppSpacing.sm),
            _build24HourTimelineCard(report),
            const SizedBox(height: AppSpacing.md),

            // 5. Active Inferred Biomarker Signals
            const BilingualLabel(
              primaryText: 'Evaluated Stress Signal Matrix',
              regionalText: 'प्रमाणित तनाव बायोमार्कर घटक',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeSignals.map((sig) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildSignalCard(sig),
                )),
            const SizedBox(height: AppSpacing.md),

            // 6. Actionable Vagal Reset & Pranayama Protocols
            const BilingualLabel(
              primaryText: 'Vagal Down-Regulation Protocols',
              regionalText: 'वेगल शांति व प्राणायाम तकनीक',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.recommendedProtocols.map((protocol) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildProtocolCard(protocol),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStressCard(InferredStressReport report, Color tierColor) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: tierColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      report.currentTier == StressLevelTier.calm
                          ? Icons.spa
                          : Icons.bolt,
                      color: tierColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.currentTier.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Passive Inferred',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Current Stress',
                value: report.currentStressScore.toInt().toString(),
                unit: '/100',
                accentColor: tierColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Avg Stress',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.dailyAverageStressScore.toInt()}/100',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Peak: ${report.peakStressHour.toString().padLeft(2, '0')}:00 • Calm: ${report.calmestHour.toString().padLeft(2, '0')}:00',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.currentTier.regionalLabel,
            style: AppTypography.bodySmall.copyWith(
              color: tierColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighStressAlert(InferredStressReport report) {
    final isAcute = report.currentTier == StressLevelTier.acuteOverload;
    final color = isAcute ? AppColors.alertRed : AppColors.energyOrange;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAcute
                      ? 'Sympathetic Overload Detected'
                      : 'Elevated Stress Detected',
                  style: AppTypography.titleSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Vagal heart rate variability is suppressed while resting pulse has surged. Engage in 4 minutes of paced diaphragmatic breathing.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutonomicSummaryCard(InferredStressReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppColors.focusBlue, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Autonomic Nervous System Assessment',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.clinicalAutonomicSummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalClinicalAutonomicSummary,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build24HourTimelineCard(InferredStressReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hourly Autonomic Trajectory',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.schedule, color: AppColors.focusBlue, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 94,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: report.intradayTimeline24h.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final reading = report.intradayTimeline24h[index];
                final color = Color(reading.tier.colorCode);

                return Container(
                  width: 62,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        reading.hourLabel,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reading.stressScore.toInt()}',
                        style: AppTypography.titleSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${reading.averageHeartRate.toInt()} bpm',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCard(InferredStressSignal sig) {
    final isHigh = sig.stressPointsContribution >= 15;
    final sigColor = isHigh
        ? AppColors.alertRed
        : (sig.stressPointsContribution >= 8
            ? AppColors.energyOrange
            : AppColors.karmaGreen);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sig.signalType.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      sig.signalType.regionalName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: sigColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '+${sig.stressPointsContribution.toInt()} Pts',
                  style: AppTypography.bodySmall.copyWith(
                    color: sigColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Measured: ${sig.measuredValue.toStringAsFixed(1)} ${sig.unit}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '• Baseline: ${sig.baselineValue.toStringAsFixed(1)} ${sig.unit}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            sig.insight,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sig.regionalInsight,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(VagalRecoveryProtocol protocol) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  protocol.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, color: AppColors.gold, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '+${protocol.karmaReward} Karma',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            protocol.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            protocol.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.air, color: AppColors.focusBlue, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Cadence: ${protocol.breathingCadence}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${protocol.durationMinutes} min',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAutonomicMethodologyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Inferred Stress Methodology',
                regionalText: 'स्वायत्त तनाव गणना पद्धति व सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma passively infers autonomic nervous system stress by continuously correlating rMSSD heart rate variability (HRV) suppression, stationary resting heart rate surges, respiratory pacing, and nocturnal sleep fragmentation.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Evidence-based yogic pranayama protocols (such as 4-7-8 and Bhramari) stimulate the vagus nerve and promote parasympathetic acetylcholine release to down-regulate acute cortisol surges.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.radiusMd,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understand & Close',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
