import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/medical_disclaimer_banner.dart';

final clinicalPrivacyGuardStateProvider =
    StateProvider<ClinicalDataPrivacyGuard>((ref) {
  return const ClinicalDataPrivacyGuard();
});

/// §P10-K Regulatory & Clinical Compliance Settings Screen
/// Route: /settings/clinical-compliance
class ClinicalComplianceSettingsScreen extends ConsumerWidget {
  const ClinicalComplianceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guard = ref.watch(clinicalPrivacyGuardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('⚖️ Regulatory & Clinical Compliance',
            style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mandatory Non-Diagnostic Medical Disclaimer Banner
              const MedicalDisclaimerBanner(),
              const SizedBox(height: AppSpacing.lg),

              // DPDP Act & HIPAA Safeguards BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined,
                            color: AppColors.teal, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Clinical Data Isolation (DPDP & HIPAA)',
                                  style: AppTypography.labelLg),
                              Text('AES-256 SQLCipher • On-Device Local First',
                                  style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'All medication logs, CGM streams, and uploaded PDF lab reports are encrypted on-device and never leave your phone unless cloud backup is explicitly turned on.',
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Compliance Status GlassCard
              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _ComplianceStatusRow(
                      label: 'Local-First SQLCipher Encryption',
                      isActive: guard.isLocalFirstEncryptionActive,
                    ),
                    const Divider(height: 16),
                    _ComplianceStatusRow(
                      label: 'DPDP Act Consent Active',
                      isActive: guard.isDpdpConsentActive,
                    ),
                    const Divider(height: 16),
                    _ComplianceStatusRow(
                      label: 'Cloud Sync Opt-In',
                      isActive: guard.isCloudBackupOptedIn,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Revoke All Clinical Consent Action
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('⚠️ Single-Tap DPDP Data Revocation',
                        style: AppTypography.labelLg.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Under the Digital Personal Data Protection Act, tapping below immediately wipes all CGM readings, medication schedules, and lab PDFs from local memory.',
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.white, size: 18),
                      label: const Text('Revoke All Clinical Access',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        ref
                                .read(clinicalPrivacyGuardStateProvider.notifier)
                                .state =
                            ref
                                .read(clinicalPrivacyGuardStateProvider)
                                .revokeAllClinicalConsent();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'All clinical data consent revoked and local stores wiped clean.')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComplianceStatusRow extends StatelessWidget {
  final String label;
  final bool isActive;

  const _ComplianceStatusRow({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withValues(alpha: 0.15)
                : AppColors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isActive ? 'ACTIVE ✓' : 'REVOKED ✗',
            style: AppTypography.labelSmall.copyWith(
              color: isActive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
