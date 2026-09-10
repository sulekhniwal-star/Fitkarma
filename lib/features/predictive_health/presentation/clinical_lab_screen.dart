import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/clinical_lab_models.dart';
import 'providers/clinical_lab_provider.dart';

/// Screen displaying Parsed Clinical Lab Report Intelligence, Biomarker Ranges,
/// Multi-Panel Organ Scores, and Evidence-Based Optimization Protocols.
class ClinicalReportScreen extends ConsumerWidget {
  const ClinicalReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(clinicalLabProvider);
    final scoreColor = report.overallMetabolicGradeScore >= 80
        ? AppColors.karmaGreen
        : (report.overallMetabolicGradeScore >= 60
            ? AppColors.energyOrange
            : AppColors.alertRed);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Clinical Lab Intelligence',
          regionalText: 'नैदानिक प्रयोगशाला रिपोर्ट विश्लेषण',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showLabMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Lab Overview Card
            _buildHeroLabCard(report, scoreColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Physician Consultation Banner (if triggered)
            if (report.requiresPhysicianConsult) ...[
              _buildPhysicianAlertBanner(report),
              const SizedBox(height: AppSpacing.md),
            ],

            // 3. Executive Synthesis Card
            _buildExecutiveSynthesisCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Multi-Panel Organ Summaries
            const BilingualLabel(
              primaryText: 'Clinical Organ Panels',
              regionalText: 'शारीरिक अंग व रक्त परीक्षण सारांश',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.panelSummaries.map((panel) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPanelCard(panel),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Parsed Biomarker Detail Breakdown
            const BilingualLabel(
              primaryText: 'Parsed Laboratory Biomarkers',
              regionalText: 'परीक्षित बायोमार्कर्स का विवरण',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.parsedBiomarkers.map((biomarker) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildBiomarkerCard(biomarker),
                )),
            const SizedBox(height: AppSpacing.md),

            // 6. Actionable Optimization Protocols
            const BilingualLabel(
              primaryText: 'Prescriptive Lab Optimization Protocols',
              regionalText: 'बायोमार्कर सुधार व स्वास्थ्य नियम',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.optimizationProtocols.map((protocol) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildProtocolCard(protocol),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroLabCard(
      ClinicalReportIntelligence report, Color scoreColor) {
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
                  color: AppColors.focusBlue.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.focusBlue, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.biotech,
                        color: AppColors.focusBlue, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      report.labProviderName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Tested: ${report.testDate.day}/${report.testDate.month}/${report.testDate.year}',
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
                label: 'Metabolic Score',
                value: report.overallMetabolicGradeScore.toInt().toString(),
                unit: '/100',
                accentColor: scoreColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluated Biomarkers',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${report.parsedBiomarkers.length} Parameters',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${report.panelSummaries.length} Organ Panels Analyzed',
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

  Widget _buildPhysicianAlertBanner(ClinicalReportIntelligence report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.alertRed.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: AppColors.alertRed, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_hospital_rounded,
              color: AppColors.alertRed, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doctor Consultation Recommended',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.alertRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report.physicianEscalationRationale,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  report.regionalPhysicianEscalationRationale,
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

  Widget _buildExecutiveSynthesisCard(ClinicalReportIntelligence report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppColors.focusBlue, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Clinical Synthesis & Longevity Impact',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.executiveSynthesis,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            report.regionalExecutiveSynthesis,
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

  Widget _buildPanelCard(LabPanelSummary panel) {
    final panelColor = panel.healthScore >= 80
        ? AppColors.karmaGreen
        : (panel.healthScore >= 60
            ? AppColors.energyOrange
            : AppColors.alertRed);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getCategoryIcon(panel.category.iconName),
                      color: AppColors.focusBlue, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    panel.category.name,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: panelColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${panel.healthScore.toInt()}% Optimal',
                  style: AppTypography.bodySmall.copyWith(
                    color: panelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            panel.category.regionalName,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: (panel.healthScore / 100.0).clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(panelColor),
            minHeight: 4,
            borderRadius: AppRadii.radiusSm,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${panel.optimalCount}/${panel.totalBiomarkers} Biomarkers Optimal • ${panel.keyObservation}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiomarkerCard(ParsedLabBiomarker biomarker) {
    final statusColor = Color(biomarker.status.colorCode);

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
                      biomarker.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      biomarker.regionalName,
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
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  biomarker.status.label.split(" ").first,
                  style: AppTypography.bodySmall.copyWith(
                    color: statusColor,
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
                'Measured: ${biomarker.measuredValue} ${biomarker.unit}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '• Ref: ${biomarker.referenceMin}-${biomarker.referenceMax} (Opt: ${biomarker.optimalMin}-${biomarker.optimalMax})',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            biomarker.clinicalInterpretation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.eco, color: AppColors.karmaGreen, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    biomarker.lifestylePrescription,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 11,
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

  Widget _buildProtocolCard(LabOptimizationProtocol protocol) {
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
            'Target: ${protocol.targetBiomarker} • Expected: ${protocol.expectedChange}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.focusBlue,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            protocol.actionPlan,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'bloodtype':
        return Icons.bloodtype;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'opacity':
        return Icons.opacity;
      case 'wb_sunny':
        return Icons.wb_sunny;
      default:
        return Icons.biotech;
    }
  }

  void _showLabMethodologyModal(BuildContext context) {
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
                primaryText: 'Clinical Lab Methodology',
                regionalText: 'प्रयोगशाला रिपोर्ट विश्लेषण सिद्धांत',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma standardizes blood laboratory tests across lipid, glycemic, hepatic, renal, endocrine, and hematology panels, benchmarking them against both clinical reference ranges and South Asian longevity optimal thresholds.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Critical alerts proactively trigger physician consultation recommendations, while borderline markers generate targeted dietary and exercise optimization protocols.',
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
