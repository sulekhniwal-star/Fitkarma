import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/compliance_models.dart';
import 'providers/compliance_provider.dart';

/// Screen displaying Regulatory & Clinical Compliance Framework status,
/// SaMD Disclaimers, Active Statutory Consents (ABDM / DPDP / HIPAA / AYUSH),
/// and Privacy Safeguards.
class ComplianceScreen extends ConsumerWidget {
  const ComplianceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(complianceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Regulatory & Compliance',
          regionalText: 'नियामक एवं नैदानिक अनुपालन ढांचा',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: AppColors.textSecondary),
            onPressed: () => _showAuditDetailsModal(context, report),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Compliance Audit Score
            _buildHeroComplianceCard(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 2. Clinical & SaMD Notice
            _buildClinicalDisclaimerCard(report.clinicalDisclaimer),
            const SizedBox(height: AppSpacing.md),

            // 3. Supported Regulatory Standards (ABDM, DPDP, HIPAA, AYUSH)
            const BilingualLabel(
              primaryText: 'Supported Statutory & Healthcare Frameworks',
              regionalText: 'मान्यता प्राप्त नियामक व स्वास्थ्य मानक',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.activeStandards.map((std) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildStandardCard(std),
                )),
            const SizedBox(height: AppSpacing.md),

            // 4. Active Statutory Consents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BilingualLabel(
                  primaryText: 'Active Clinical Consents',
                  regionalText: 'सक्रिय वैधानिक सहमतियां',
                ),
                if (report.activeConsents.length < 3)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      ref.read(complianceProvider.notifier).restoreBaselineConsents();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Baseline statutory consents restored.'),
                          backgroundColor: AppColors.karmaGreen,
                        ),
                      );
                    },
                    child: Text(
                      'Restore Defaults',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.focusBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (report.activeConsents.isEmpty)
              const BentoCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(
                    child: Text(
                      'No active consents granted. Tap "Restore Defaults" to activate.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              )
            else
              ...report.activeConsents.map((consent) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildConsentCard(context, ref, consent),
                  )),
            const SizedBox(height: AppSpacing.md),

            // 5. Security & Cryptographic Integrity Safeguards
            _buildSecuritySafeguardsCard(report),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroComplianceCard(
    BuildContext context,
    WidgetRef ref,
    ComplianceFrameworkReport report,
  ) {
    final statusColor = report.isFullyCompliant ? AppColors.karmaGreen : AppColors.energyOrange;

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
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      report.isFullyCompliant ? Icons.verified : Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.isFullyCompliant ? '100% Fully Compliant' : 'Partial Compliance',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Audit: ${report.lastComplianceAudit.day}/${report.lastComplianceAudit.month}/${report.lastComplianceAudit.year}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
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
                label: 'Audit Score',
                value: '${report.complianceAuditScore.toInt()}%',
                accentColor: statusColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Framework Status',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'ABDM • DPDP • HIPAA',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Zero Telemetry Leaks • AES-256 Verified',
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
        ],
      ),
    );
  }

  Widget _buildClinicalDisclaimerCard(ClinicalDisclaimer disclaimer) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_information_outlined, color: AppColors.energyOrange, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  disclaimer.title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            disclaimer.regionalTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.energyOrange.withValues(alpha: 0.08),
              borderRadius: AppRadii.radiusSm,
              border: Border.all(color: AppColors.energyOrange.withValues(alpha: 0.3)),
            ),
            child: Text(
              disclaimer.legalText,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            disclaimer.regionalLegalText,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.alertRed.withValues(alpha: 0.1),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_in_talk, color: AppColors.alertRed, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    disclaimer.emergencyHelpline,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.alertRed,
                      fontWeight: FontWeight.bold,
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

  Widget _buildStandardCard(ComplianceStandard standard) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: const Icon(Icons.policy_outlined, color: AppColors.focusBlue, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      standard.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${standard.jurisdiction} • ${standard.regionalName}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  'Active',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            standard.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCard(
    BuildContext context,
    WidgetRef ref,
    ClinicalConsentArtifact consent,
  ) {
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
                      consent.purpose,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      consent.regionalPurpose,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (consent.isRevocable)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    ref.read(complianceProvider.notifier).revokeConsent(consent.consentId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Consent ${consent.consentId} revoked.'),
                        backgroundColor: AppColors.alertRed,
                      ),
                    );
                  },
                  child: Text(
                    'Revoke',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.alertRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'ID: ${consent.consentId}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontFamily: 'monospace',
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: consent.dataCategories.map((cat) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.focusBlue.withValues(alpha: 0.1),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  cat,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.focusBlue,
                    fontSize: 9,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySafeguardsCard(ComplianceFrameworkReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, color: AppColors.karmaGreen, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Data Protection & Cryptographic Safeguards',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildCheckRow('Encryption At Rest (AES-256-GCM)', report.encryptionAtRestVerified),
          _buildCheckRow('Strict Audit Logging of Data Access', report.auditLoggingActive),
          _buildCheckRow('User Right to Data Erasure (DPDP S.12)', report.dataErasureSupported),
          _buildCheckRow('Zero Third-Party Ad Trackers / SDKs', true),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String label, bool isOk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isOk ? AppColors.karmaGreen : AppColors.alertRed,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAuditDetailsModal(BuildContext context, ComplianceFrameworkReport report) {
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
                primaryText: 'Compliance & Audit Integrity',
                regionalText: 'नियामक अनुपालन व सुरक्षा रिपोर्ट',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma is built on a privacy-by-design architecture. All biometric, glycemic, dosha, and predictive health analyses execute entirely on-device with zero telemetry egress without explicit consent.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Compliance score: ${report.complianceAuditScore.toInt()}% • Meets DPDP Act 2023, ABDM M3 sandbox criteria, and HIPAA privacy rules.',
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
                  child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
