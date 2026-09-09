import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/health_risk_models.dart';
import 'providers/health_risk_provider.dart';

/// Screen displaying South Asian Health Risk Stratification, IDRS Scoring,
/// Multi-Domain Clinical Radars, and Actionable Preventive Protocols.
class HealthRiskPreventionScreen extends ConsumerWidget {
  const HealthRiskPreventionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(healthRiskProvider);
    final tierColor = Color(report.overallRiskTier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Health Risk Prevention OS',
          regionalText: 'स्वास्थ्य जोखिम निवारण प्रणाली',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showClinicalMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Composite Health Risk Stratification Card
            _buildHeroRiskCard(report, tierColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Doctor Consultation Safeguard Banner (if triggered)
            if (report.requiresDoctorConsultation) ...[
              _buildDoctorConsultationAlert(report),
              const SizedBox(height: AppSpacing.md),
            ],

            // 3. 5-Domain Clinical Breakdown Radar Matrix
            const BilingualLabel(
              primaryText: '5-Domain South Asian Risk Breakdown',
              regionalText: 'पंच-क्षेत्रीय स्वास्थ्य जोखिम विश्लेषण',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildDomainBreakdownCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Clinical Risk Factors Detail Matrix
            const BilingualLabel(
              primaryText: 'Evaluated Clinical Biomarkers',
              regionalText: 'प्रमाणित बायोमार्कर स्थिति',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.riskFactors.map((factor) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildRiskFactorRow(factor),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Evidence-Based Preventive Protocols
            const BilingualLabel(
              primaryText: 'Actionable Preventive Protocols',
              regionalText: 'सक्रिय स्वास्थ्य सुरक्षा नियम',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeProtocols.map((prot) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildProtocolCard(prot),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroRiskCard(HealthRiskPreventionReport report, Color tierColor) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                  border: Border.all(color: tierColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      report.overallRiskTier == ClinicalRiskTier.low
                          ? Icons.verified_user
                          : report.overallRiskTier == ClinicalRiskTier.moderate
                              ? Icons.warning_amber
                              : Icons.report_problem,
                      color: tierColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      report.overallRiskTier.label,
                      style: AppTypography.metricLabel.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  'South Asian Calibrated',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Composite Clinical Risk Index',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.compositeRiskScore.toStringAsFixed(1)} / 100',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Multi-factorial synthesis of WHtR, IDRS diabetes risk, blood pressure, and autonomic recovery.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              GlowingMetric(
                value: '${report.compositeRiskScore.toInt()}',
                label: 'Risk Index',
                accentColor: tierColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: (report.compositeRiskScore / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(tierColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorConsultationAlert(HealthRiskPreventionReport report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.alertRed.withValues(alpha: 0.12),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.alertRed.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.medical_services, color: AppColors.alertRed, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinical Escalation Alert (डॉक्टर परामर्श आवश्यक)',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.alertRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.consultationReason,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                ),
                const SizedBox(height: 2),
                Text(
                  report.regionalConsultationReason,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainBreakdownCard(HealthRiskPreventionReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDomainBarRow(
            'Cardiometabolic & WHtR',
            report.cardiometabolicDomainScore,
            Icons.monitor_weight,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDomainBarRow(
            'Indian Diabetes Risk (IDRS)',
            report.idrsDiabetesDomainScore,
            Icons.bloodtype,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDomainBarRow(
            'Autonomic Vagal & Stress',
            report.autonomicDomainScore,
            Icons.favorite,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDomainBarRow(
            'Sarcopenic Deficit',
            report.sarcopeniaDomainScore,
            Icons.fitness_center,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDomainBarRow(
            'Circadian Digestive Strain',
            report.circadianDomainScore,
            Icons.nights_stay,
          ),
        ],
      ),
    );
  }

  Widget _buildDomainBarRow(String title, double score, IconData icon) {
    final color = score >= 60.0
        ? AppColors.alertRed
        : score >= 25.0
            ? AppColors.energyOrange
            : AppColors.karmaGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${score.toInt()}/100 Risk',
              style: AppTypography.metricLabel.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppRadii.radiusFull,
          child: LinearProgressIndicator(
            value: (score / 100.0).clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskFactorRow(ClinicalRiskFactor factor) {
    final factorColor = Color(factor.tier.colorCode);

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
                      factor.name,
                      style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      factor.regionalName,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: factorColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  factor.tier.label.split('(')[0].trim(),
                  style: AppTypography.metricLabel.copyWith(
                    color: factorColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Measured: ${factor.measuredValue % 1 != 0 ? factor.measuredValue.toStringAsFixed(2) : factor.measuredValue.toInt()} ${factor.unit}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Optimal Target: < ${factor.optimalThreshold} ${factor.unit}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.karmaGreen),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            factor.clinicalRationale,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolCard(PreventiveProtocol protocol) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.health_and_safety, color: AppColors.karmaGreen, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    protocol.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '+${protocol.karmaReward} Karma',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            protocol.regionalTitle,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Text(
            protocol.protocolDescription,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.insights, color: AppColors.focusBlue, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Clinical Impact: ${protocol.expectedBiometricImpact}',
                    style: AppTypography.metricLabel.copyWith(
                      color: AppColors.focusBlue,
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

  void _showClinicalMethodologyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'South Asian Health Risk Science',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma utilizes clinical consensus calibrated specifically for South Asian phenotypes:\n\n'
                '• Waist-to-Height Ratio (WHtR <0.50 target for visceral protection).\n'
                '• Indian Diabetes Risk Score (MDRF validated IDRS index).\n'
                '• Autonomic vagal tone derived from resting heart rate and recovery metrics.\n'
                '• Non-pharmaceutical lifestyle protocols with proven clinical efficacy.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
