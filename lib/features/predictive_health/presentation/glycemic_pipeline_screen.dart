import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/glycemic_pipeline_models.dart';
import 'providers/glycemic_pipeline_provider.dart';

/// Screen displaying Retrospective Glycemic Pipeline Processing,
/// Circadian Window Segments, Postprandial Excursion Dynamics, and Metabolic Guidance.
class GlycemicPipelineScreen extends ConsumerWidget {
  const GlycemicPipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(glycemicPipelineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Glycemic Processing Pipeline',
          regionalText: 'दीर्घकालिक शर्करा विश्लेषण पाइपलाइन',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPipelineMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Retrospective Stability Card
            _buildHeroStabilityCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Glycemic Range Distribution (TIR / TAR / TBR)
            _buildRangeDistributionCard(report),
            const SizedBox(height: AppSpacing.md),

            // 3. Circadian Chrono-Glycemic Windows
            const BilingualLabel(
              primaryText: 'Circadian Glycemic Windows (24h Segments)',
              regionalText: 'दैनिक चक्र शर्करा विभाजन (२४ घंटे)',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.circadianWindows.map((win) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildCircadianWindowCard(win),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. Postprandial Meal Excursions
            const BilingualLabel(
              primaryText: 'Postprandial Excursion Dynamics',
              regionalText: 'भोजनोपरांत शर्करा प्रतिक्रिया',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.recentExcursions.map((exc) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildExcursionCard(exc),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Chrono-Nutritional & Ayurvedic Guidance
            _buildGuidanceCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStabilityCard(RetrospectiveGlycemicReport report) {
    Color zoneColor;
    switch (report.stabilityZone) {
      case GlycemicStabilityZone.optimalStable:
        zoneColor = AppColors.karmaGreen;
        break;
      case GlycemicStabilityZone.moderateVolatility:
        zoneColor = AppColors.focusBlue;
        break;
      case GlycemicStabilityZone.highDysglycemia:
        zoneColor = AppColors.alertRed;
        break;
    }

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
                  color: zoneColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: zoneColor, width: 1),
                ),
                child: Text(
                  report.stabilityZone.name,
                  style: TextStyle(
                    color: zoneColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                '${report.totalDaysAnalyzed} Days • ${report.totalSamplesProcessed} Samples',
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
                label: 'Mean Glucose',
                value: report.overallMeanGlucose.toString(),
                unit: 'mg/dL',
                accentColor: zoneColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Glycemic Variability (CV)',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.coefficientOfVariationPercent}% (SD: ±${report.standardDeviation})',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'GMI Indicator: ${report.glucoseManagementIndicatorGmi}%',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.focusBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.stabilityZone.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeDistributionCard(RetrospectiveGlycemicReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Range Distribution (70 - 140 mg/dL)',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Multi-segmented bar
          ClipRRect(
            borderRadius: AppRadii.radiusSm,
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  if (report.timeBelowRangePercent > 0)
                    Expanded(
                      flex: (report.timeBelowRangePercent * 10).toInt(),
                      child: Container(color: AppColors.alertRed),
                    ),
                  Expanded(
                    flex: (report.timeInRangePercent * 10).toInt(),
                    child: Container(color: AppColors.karmaGreen),
                  ),
                  if (report.timeAboveRangePercent > 0)
                    Expanded(
                      flex: (report.timeAboveRangePercent * 10).toInt(),
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
              _buildMetricChip('TIR (In Range)',
                  '${report.timeInRangePercent}%', AppColors.karmaGreen),
              _buildMetricChip('TAR (>140)', '${report.timeAboveRangePercent}%',
                  AppColors.energyOrange),
              _buildMetricChip('TBR (<70)', '${report.timeBelowRangePercent}%',
                  AppColors.alertRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, Color color) {
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
            Text(
              label,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCircadianWindowCard(WindowGlycemicSummary win) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                win.window.name,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'TIR: ${win.timeInRangePercent}%',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Text(
            win.window.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Mean: ${win.meanGlucose} mg/dL',
                style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Peak: ${win.peakGlucose} mg/dL',
                style: AppTypography.bodySmall.copyWith(
                    color: AppColors.energyOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 11),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'SD: ±${win.standardDeviation}',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            win.clinicalObservation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.karmaGreen,
              fontSize: 11,
            ),
          ),
          Text(
            win.regionalObservation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExcursionCard(PostprandialExcursion exc) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exc.mealName,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: exc.isSpikeExcursion
                      ? AppColors.energyOrange.withValues(alpha: 0.15)
                      : AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  exc.isSpikeExcursion
                      ? 'Spike (+${exc.deltaGlucose.toInt()} mg/dL)'
                      : 'Blunted (+${exc.deltaGlucose.toInt()} mg/dL)',
                  style: TextStyle(
                    color: exc.isSpikeExcursion
                        ? AppColors.energyOrange
                        : AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                'Baseline: ${exc.baselineGlucose.toInt()} mg/dL  ➔  Peak: ${exc.peakGlucose.toInt()} mg/dL',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                'Clearance: ${exc.recoveryHours}h',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.focusBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceCard(RetrospectiveGlycemicReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.spa_outlined,
                  color: AppColors.karmaGreen, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Metabolic & Chrono-Nutritional Guidance',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            report.actionableMetabolicRecommendation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalMetabolicRecommendation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _showPipelineMethodologyModal(BuildContext context) {
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
                primaryText: 'Retrospective Glycemic Processing',
                regionalText: 'दीर्घकालिक शर्करा विश्लेषण प्रणाली',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma analyzes multi-week continuous glucose telemetry across 5 distinct circadian windows (Dawn, Breakfast, Lunch, Dinner, Nocturnal).',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Key Clinical Metrics:\n• Coefficient of Variation (CV %): Target < 33% for stable homeostasis.\n• GMI Indicator: Derived estimated laboratory HbA1c correlation.\n• Time in Range (TIR): Optimal target > 90% between 70-140 mg/dL.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
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
