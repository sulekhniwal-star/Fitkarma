import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/deepened_longevity_models.dart';
import 'providers/deepened_longevity_provider.dart';

/// Screen displaying Deepened Longevity Score, 7 Biological Hallmarks of Aging,
/// South Asian Phenotype Risk Assessment, and 90-Day Cellular Longevity Roadmap.
class DeepenedLongevityScreen extends ConsumerWidget {
  const DeepenedLongevityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(deepenedLongevityProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Cellular Longevity OS',
          regionalText: 'गहन कोशिकीय दीर्घायु व आयु-वृद्धि रोधी प्रणाली',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.karmaGreen),
            tooltip: 'Recalibrate Biometrics',
            onPressed: () => _showBiometricRecalibrationModal(context, ref),
          ),
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Composite Cellular Resilience & Healthspan Card
            _buildHeroLongevityCard(report),
            const SizedBox(height: AppSpacing.md),

            // 2. 7 Hallmarks of Aging Evaluation Card
            _buildHallmarksCard(report.hallmarkEvaluations),
            const SizedBox(height: AppSpacing.md),

            // 3. South Asian Phenotype Risk Card
            _buildSouthAsianPhenotypeCard(report.southAsianRisk),
            const SizedBox(height: AppSpacing.md),

            // 4. 90-Day Cellular Longevity Roadmap Card
            _buildCellularRoadmapCard(report.cellularRoadmap),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroLongevityCard(DeepenedLongevityReport report) {
    final base = report.baseReport;
    final bool isBiologicalYounger = base.biologicalAge < base.chronologicalAge;
    final double ageDelta = (base.chronologicalAge - base.biologicalAge).abs();

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'Cellular Resilience Index',
                regionalText: 'कोशिकीय प्रतिरोध व जैविक दीर्घायु',
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(
                      color: AppColors.karmaGreen.withValues(alpha: 0.4)),
                ),
                child: Text(
                  base.tier.label.split('(').first.trim(),
                  style: const TextStyle(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: GlowingMetric(
                  value: report.compositeCellularResilienceScore
                      .toStringAsFixed(1),
                  unit: '/ 100',
                  label: 'Composite Resilience',
                  accentColor: report.compositeCellularResilienceScore >= 80
                      ? AppColors.karmaGreen
                      : (report.compositeCellularResilienceScore >= 60
                          ? AppColors.energyOrange
                          : AppColors.alertRed),
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.surfaceElevated),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isBiologicalYounger
                              ? Icons.trending_down
                              : Icons.trending_up,
                          color: isBiologicalYounger
                              ? AppColors.karmaGreen
                              : AppColors.energyOrange,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isBiologicalYounger
                              ? '${ageDelta.toStringAsFixed(1)} Yrs Younger'
                              : '${ageDelta.toStringAsFixed(1)} Yrs Accelerated',
                          style: TextStyle(
                            color: isBiologicalYounger
                                ? AppColors.karmaGreen
                                : AppColors.energyOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bio Age: ${base.biologicalAge.toStringAsFixed(1)} | Chrono: ${base.chronologicalAge.toInt()}',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      'Healthspan: ${base.tier.projectedHealthspanBonus}',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.focusBlue,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              report.primaryLongevityPillarSummary,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHallmarksCard(List<HallmarkEvaluation> hallmarks) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: '7 Biological Hallmarks of Aging',
                regionalText: 'आयु-वृद्धि के ७ प्रमुख कोशिकीय कारक',
              ),
              Icon(Icons.biotech, color: AppColors.focusBlue, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Multi-omic biological aging breakdown mapped to physiological biomarkers and cellular pathways.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...hallmarks.map((h) => _buildHallmarkItem(h)),
        ],
      ),
    );
  }

  Widget _buildHallmarkItem(HallmarkEvaluation h) {
    final Color scoreColor = h.score >= 80
        ? AppColors.karmaGreen
        : (h.score >= 60 ? AppColors.energyOrange : AppColors.alertRed);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.4),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.glassBorder),
      ),
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
                      h.hallmark.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      h.hallmark.regionalName,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${h.score.toStringAsFixed(0)} / 100',
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    h.biologicalAgeDeltaYears <= 0
                        ? '${h.biologicalAgeDeltaYears.toStringAsFixed(1)} yrs'
                        : '+${h.biologicalAgeDeltaYears.toStringAsFixed(1)} yrs',
                    style: TextStyle(
                      color: h.isProtective
                          ? AppColors.karmaGreen
                          : AppColors.energyOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (h.score / 100).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                h.primaryBiomarker,
                style: const TextStyle(
                  color: AppColors.focusBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  h.statusSummary,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSouthAsianPhenotypeCard(SouthAsianPhenotypeRisk risk) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BilingualLabel(
                primaryText: 'South Asian Phenotype Profiler',
                regionalText: 'दक्षिण एशियाई थिन-फैट फेनोटाइप विश्लेषण',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: risk.visceralAdiposityIndex > 8.0
                      ? AppColors.energyOrange.withValues(alpha: 0.15)
                      : AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  risk.visceralAdiposityIndex > 8.0
                      ? 'Elevated Visceral Risk'
                      : 'Protected Profile',
                  style: TextStyle(
                    color: risk.visceralAdiposityIndex > 8.0
                        ? AppColors.energyOrange
                        : AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildRiskMetricTile(
                title: 'Visceral Index',
                value: risk.visceralAdiposityIndex.toStringAsFixed(1),
                isOptimal: risk.visceralAdiposityIndex <= 7.0,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildRiskMetricTile(
                title: 'TG : HDL Ratio',
                value: risk.atherogenicIndexRatio.toStringAsFixed(1),
                isOptimal: risk.atherogenicIndexRatio <= 2.5,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildRiskMetricTile(
                title: 'Lp(a) Status',
                value: risk.hasElevatedLpA ? 'Elevated' : 'Normal',
                isOptimal: !risk.hasElevatedLpA,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated.withValues(alpha: 0.6),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              risk.clinicalInterpretation,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskMetricTile({
    required String title,
    required String value,
    required bool isOptimal,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated.withValues(alpha: 0.4),
          borderRadius: AppRadii.radiusSm,
          border: Border.all(
            color: isOptimal
                ? AppColors.karmaGreen.withValues(alpha: 0.3)
                : AppColors.energyOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color:
                    isOptimal ? AppColors.karmaGreen : AppColors.energyOrange,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellularRoadmapCard(List<LongevityRoadmapPhase> roadmap) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: '90-Day Cellular Longevity Roadmap',
                regionalText: '९०-दिवसीय कोशिकीय कायाकल्प रोडमैप',
              ),
              Icon(Icons.timeline, color: AppColors.karmaGreen, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Structured 3-stage protocol pairing evidence-based molecular triggers with Ayurvedic Rasayana therapies.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...roadmap.map((phase) => _buildRoadmapPhaseTile(phase)),
        ],
      ),
    );
  }

  Widget _buildRoadmapPhaseTile(LongevityRoadmapPhase phase) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.4),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.focusBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.karmaGreen,
                    child: Text(
                      '${phase.phaseNumber}',
                      style: const TextStyle(
                          color: AppColors.background,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    phase.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  phase.timeline,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...phase.cellularActions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style:
                          TextStyle(color: AppColors.karmaGreen, fontSize: 12)),
                  Expanded(
                    child: Text(
                      action,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.karmaGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.spa_outlined,
                    color: AppColors.karmaGreen, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Rasayana: ${phase.ayurvedicRasayana}',
                    style: const TextStyle(
                      color: AppColors.karmaGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBiometricRecalibrationModal(BuildContext context, WidgetRef ref) {
    double rhr = 58.0;
    double vo2Max = 45.2;
    double glucose = 88.0;
    double deepSleep = 92.0;
    double muscleMass = 34.5;
    double visceral = 5.5;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BilingualLabel(
                        primaryText: 'Recalibrate Biometrics',
                        regionalText: 'बायोमेट्रिक्स पुनर्मूल्यांकन',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSlider(
                    label: 'Resting Heart Rate: ${rhr.toInt()} bpm',
                    value: rhr,
                    min: 45.0,
                    max: 85.0,
                    onChanged: (val) => setState(() => rhr = val),
                  ),
                  _buildSlider(
                    label:
                        'VO2 Max Estimate: ${vo2Max.toStringAsFixed(1)} ml/kg/min',
                    value: vo2Max,
                    min: 25.0,
                    max: 60.0,
                    onChanged: (val) => setState(() => vo2Max = val),
                  ),
                  _buildSlider(
                    label: 'Fasting Glucose: ${glucose.toInt()} mg/dL',
                    value: glucose,
                    min: 70.0,
                    max: 130.0,
                    onChanged: (val) => setState(() => glucose = val),
                  ),
                  _buildSlider(
                    label: 'Deep Sleep: ${deepSleep.toInt()} min/night',
                    value: deepSleep,
                    min: 30.0,
                    max: 140.0,
                    onChanged: (val) => setState(() => deepSleep = val),
                  ),
                  _buildSlider(
                    label:
                        'Skeletal Muscle Mass: ${muscleMass.toStringAsFixed(1)} kg',
                    value: muscleMass,
                    min: 20.0,
                    max: 50.0,
                    onChanged: (val) => setState(() => muscleMass = val),
                  ),
                  _buildSlider(
                    label: 'Visceral Fat Index: ${visceral.toStringAsFixed(1)}',
                    value: visceral,
                    min: 1.0,
                    max: 16.0,
                    onChanged: (val) => setState(() => visceral = val),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.karmaGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md)),
                      ),
                      onPressed: () {
                        ref
                            .read(deepenedLongevityProvider.notifier)
                            .recalculate(
                              chronologicalAge: 32.0,
                              restingHeartRate: rhr,
                              hrvRmssd: 58.0,
                              vo2MaxEstimate: vo2Max,
                              fastingGlucose: glucose,
                              systolicBp: 116.0,
                              diastolicBp: 74.0,
                              dailySteps: 11200.0,
                              deepSleepMinutes: deepSleep,
                              skeletalMuscleMassKg: muscleMass,
                              hsCrpMgL: 0.8,
                              triglycerideHdlRatio: 1.8,
                              hasElevatedLpA: false,
                              visceralFatIndex: visceral,
                            );
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Synthesize Cellular Longevity',
                        style: TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.karmaGreen,
          inactiveColor: AppColors.surfaceElevated,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BilingualLabel(
              primaryText: 'Cellular Longevity Science',
              regionalText: 'कोशिकीय दीर्घायु व विज्ञान दर्शन',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'FitKarma\'s Deepened Longevity OS evaluates 7 primary hallmarks of aging across metabolic, cardiovascular, genetic, and sleep vectors. It specifically accounts for the South Asian Thin-Fat phenotype (high visceral adiposity with lower skeletal muscle) and provides a calibrated 90-day cellular rejuvenation roadmap integrating modern geroprotective protocols with classic Ayurvedic Rasayanas.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
