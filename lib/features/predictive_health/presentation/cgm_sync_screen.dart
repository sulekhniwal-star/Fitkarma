import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/cgm_sync_models.dart';
import 'providers/cgm_sync_provider.dart';

/// Screen displaying Continuous Glucose Monitoring (CGM) Real-Time Telemetry,
/// Time-in-Range (TIR) Analytics, Postprandial Meal Spikes, and Shatpawali Protocols.
class ContinuousBiomarkerScreen extends ConsumerWidget {
  const ContinuousBiomarkerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(continuousBiomarkerProvider);
    final trendColor = Color(report.currentTrend.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Continuous Glucose Sync (CGM)',
          regionalText: 'निरंतर रक्त शर्करा निगरानी (CGM)',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showCgmMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Real-Time Interstitial Glucose Card
            _buildHeroGlucoseCard(report, trendColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Clinical Time-In-Range (TIR) Breakdown
            _buildTimeInRangeCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. 24-Hour Continuous Glycemic Stream
            const BilingualLabel(
              primaryText: '24-Hour Interstitial Glucose Curve',
              regionalText: '२४-घंटे निरंतर शर्करा वक्र',
            ),
            const SizedBox(height: AppSpacing.sm),
            _build24HourStreamCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Postprandial Meal Spikes & Shatpawali Correlation
            const BilingualLabel(
              primaryText: 'Postprandial Meal Excursions',
              regionalText: 'भोजनोपरांत शर्करा स्पाइक विश्लेषण',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.detectedMealSpikes.map((spike) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildMealSpikeCard(spike),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Actionable Glycemic Protocols
            const BilingualLabel(
              primaryText: 'Evidence-Based Glycemic Protocols',
              regionalText: 'शर्करा नियंत्रण व शतपावली नियम',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeProtocols.map((protocol) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildProtocolCard(protocol),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroGlucoseCard(
      ContinuousGlucoseReport report, Color trendColor) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sensors,
                        color: AppColors.karmaGreen, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Live • ${report.sensorModel}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: trendColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${report.currentTrend.symbol} ${report.currentTrend.label.split("(").first.trim()}',
                  style: AppTypography.bodySmall.copyWith(
                    color: trendColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
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
                label: 'Current Glucose',
                value: report.currentGlucoseMgDl.toInt().toString(),
                unit: 'mg/dL',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24h Mean Glucose',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.meanGlucose24h.toInt()} mg/dL (Est. HbA1c ${report.estimatedGmiHbA1c.toStringAsFixed(1)}%)',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stability: ${report.glycemicStabilityScore}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
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

  Widget _buildTimeInRangeCard(ContinuousGlucoseReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time in Range (TIR) Analytics',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${report.timeInRangePercent.toInt()}% in 70-140 mg/dL',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadii.radiusSm,
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  if (report.timeBelowRangePercent > 0)
                    Expanded(
                      flex: report.timeBelowRangePercent.toInt(),
                      child: Container(color: AppColors.aiPurple),
                    ),
                  Expanded(
                    flex: report.timeInRangePercent.toInt(),
                    child: Container(color: AppColors.karmaGreen),
                  ),
                  if (report.timeAboveRangePercent > 0)
                    Expanded(
                      flex: report.timeAboveRangePercent.toInt(),
                      child: Container(color: AppColors.energyOrange),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTirLegend(
                  'Low (<70)',
                  '${report.timeBelowRangePercent.toInt()}%',
                  AppColors.aiPurple),
              _buildTirLegend(
                  'In-Range (70-140)',
                  '${report.timeInRangePercent.toInt()}%',
                  AppColors.karmaGreen),
              _buildTirLegend(
                  'High (>140)',
                  '${report.timeAboveRangePercent.toInt()}%',
                  AppColors.energyOrange),
              _buildTirLegend(
                  'CV (Variance)',
                  '${report.glycemicVariabilityCvPercent.toStringAsFixed(1)}%',
                  AppColors.focusBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTirLegend(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label,
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        Text(value,
            style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _build24HourStreamCard(ContinuousGlucoseReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Intraday Continuous Stream',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.show_chart,
                  color: AppColors.karmaGreen, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 98,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: report.telemetryStream24h.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final point = report.telemetryStream24h[index];
                final tierColor = Color(point.rangeTier.colorCode);
                final timeLabel =
                    '${point.timestamp.hour.toString().padLeft(2, '0')}:${point.timestamp.minute.toString().padLeft(2, '0')}';

                return Container(
                  width: 68,
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: point.eventTag != null
                        ? AppColors.surfaceElevated
                        : AppColors.background,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(
                      color: point.eventTag != null
                          ? AppColors.focusBlue.withValues(alpha: 0.6)
                          : AppColors.surfaceElevated,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeLabel,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${point.glucoseValue.toInt()}',
                        style: AppTypography.titleSmall.copyWith(
                          color: tierColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      if (point.eventTag != null) ...[
                        const SizedBox(height: 2),
                        const Icon(Icons.restaurant_menu,
                            color: AppColors.focusBlue, size: 10),
                      ],
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

  Widget _buildMealSpikeCard(MealGlycemicSpikeEvent spike) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  spike.mealName,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '+${spike.spikeDelta.toInt()} mg/dL Spike',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            spike.regionalMealName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Baseline: ${spike.baselineGlucose.toInt()} mg/dL → Peak: ${spike.peakGlucose.toInt()} mg/dL',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (spike.shatpawaliCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_walk,
                          color: AppColors.karmaGreen, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        'Shatpawali Done',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.karmaGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            spike.clinicalAssessment,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(GlycemicOptimizationProtocol protocol) {
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
            'Expected Impact: ${protocol.expectedSpikeReduction}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.karmaGreen,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            protocol.instruction,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showCgmMethodologyModal(BuildContext context) {
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
                primaryText: 'Continuous Glucose Monitoring (CGM) Methodology',
                regionalText: 'निरंतर शर्करा निगरानी सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'CGM telemetry tracks interstitial glucose levels every few minutes to compute clinical Time in Range (TIR 70-140 mg/dL), Coefficient of Variation (CV%), and Estimated HbA1c (GMI).',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Postprandial Shatpawali (100-step walks) activates GLUT-4 muscular translocation to blunt glycemic excursions without excessive insulin demand.',
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
