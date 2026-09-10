import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/security_models.dart';
import 'providers/security_provider.dart';

/// Screen displaying Enterprise Security Posture, Firebase App Check Attestation,
/// Biometric Health Vault Controls, and Firestore/Storage Rules Auditing.
class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(securityProvider);
    final notifier = ref.read(securityProvider.notifier);
    final report = state.report;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Enterprise Security & Hardening',
          regionalText: 'उद्यम सुरक्षा एवं डेटा संरक्षण',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSecurityArchitectureModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success / Error Banner
            if (state.successMessage != null)
              _buildMessageBanner(state.successMessage!, isError: false),

            // 1. Hero Security Score & App Check Status Card
            _buildHeroScoreCard(report, notifier),
            const SizedBox(height: AppSpacing.md),

            // 2. Biometric Health Vault Card
            _buildBiometricVaultCard(context, state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. App Check Provider Configuration
            _buildAppCheckProviderCard(report, notifier),
            const SizedBox(height: AppSpacing.md),

            // 4. Security Checkpoints Audit Matrix
            const BilingualLabel(
              primaryText: 'Enterprise Audit Matrix',
              regionalText: 'सुरक्षा मापदंड व अनुपालन रिपोर्ट',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...report.checkItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _buildCheckItemCard(item),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 5. Compliance & Encryption Badges
            _buildComplianceBadges(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBanner(String message, {required bool isError}) {
    final color = isError ? AppColors.alertRed : AppColors.karmaGreen;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
              color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroScoreCard(
      SecurityAuditReport report, SecurityNotifier notifier) {
    final isHardened = report.isEnterpriseHardened;
    final scoreColor =
        isHardened ? AppColors.karmaGreen : AppColors.energyOrange;

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
                  color: scoreColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: scoreColor, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isHardened ? Icons.verified_user : Icons.shield_outlined,
                      color: scoreColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isHardened ? 'ENTERPRISE HARDENED' : 'AUDIT WARNING',
                      style: TextStyle(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'App Check',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  Switch(
                    value: report.isAppCheckActive,
                    activeThumbColor: AppColors.focusBlue,
                    onChanged: (val) => notifier.toggleAppCheck(val),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Security Score',
                value: '${report.overallSecurityScore}',
                unit: '/100',
                accentColor: scoreColor,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Attestation:',
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                    Text(
                      report.isAppCheckActive
                          ? report.activeProvider.name.split('(').first.trim()
                          : 'Disabled (Sandbox)',
                      style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Zero secrets in client APK/IPA',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.karmaGreen, fontSize: 10),
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

  Widget _buildBiometricVaultCard(
    BuildContext context,
    SecurityState state,
    SecurityNotifier notifier,
  ) {
    final isUnlocked = state.isBiometricUnlocked;
    final settings = state.report.biometricSettings;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.fingerprint, color: AppColors.focusBlue, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Biometric Health Vault (local_auth)',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isUnlocked
                          ? AppColors.karmaGreen
                          : AppColors.energyOrange)
                      .withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  isUnlocked ? 'VAULT UNLOCKED' : 'LOCKED',
                  style: TextStyle(
                    color: isUnlocked
                        ? AppColors.karmaGreen
                        : AppColors.energyOrange,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Requires biometric re-authentication (Fingerprint / Face ID / PIN) before decrypting sensitive clinical lab reports and doctor dossiers.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.md),

          // Toggles
          _buildVaultToggle(
            title: 'Protect Clinical Lab Reports',
            value: settings.requireOnClinicalReports,
            onChanged: (val) => notifier.updateBiometricSettings(
                settings.copyWith(requireOnClinicalReports: val)),
          ),
          _buildVaultToggle(
            title: 'Protect Doctor Dossier Sharing',
            value: settings.requireOnDoctorSharing,
            onChanged: (val) => notifier.updateBiometricSettings(
                settings.copyWith(requireOnDoctorSharing: val)),
          ),
          _buildVaultToggle(
            title: 'Protect Affiliate Payout Requests',
            value: settings.requireOnAffiliatePayouts,
            onChanged: (val) => notifier.updateBiometricSettings(
                settings.copyWith(requireOnAffiliatePayouts: val)),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isUnlocked
                    ? AppColors.surfaceElevated
                    : AppColors.focusBlue,
                shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.radiusMd),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              icon: Icon(isUnlocked ? Icons.lock : Icons.fingerprint,
                  color: Colors.white, size: 16),
              label: state.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(
                      isUnlocked
                          ? 'Lock Health Vault'
                          : 'Test Biometric Re-Auth',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
              onPressed: () {
                if (isUnlocked) {
                  notifier.lockBiometricVault();
                } else {
                  notifier.authenticateBiometrics();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textPrimary, fontSize: 11)),
          Switch(
            value: value,
            activeThumbColor: AppColors.karmaGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildAppCheckProviderCard(
      SecurityAuditReport report, SecurityNotifier notifier) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.token_outlined, color: AppColors.gold, size: 18),
              SizedBox(width: 6),
              Text(
                'Firebase App Check Provider Mode',
                style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: AppCheckProviderType.values.map((p) {
              final isSelected = report.activeProvider == p;
              return ChoiceChip(
                label: Text(p.name.split('(').first.trim(),
                    style: const TextStyle(fontSize: 10)),
                selected: isSelected,
                selectedColor: AppColors.gold.withValues(alpha: 0.25),
                backgroundColor: AppColors.surfaceElevated,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) => notifier.setProvider(p),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItemCard(SecurityCheckItem item) {
    final isPassed = item.isPassed;
    final statusColor =
        isPassed ? AppColors.karmaGreen : AppColors.energyOrange;

    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPassed ? Icons.check_circle : Icons.warning_amber_rounded,
            color: statusColor,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Text(
                        item.status.name.toUpperCase(),
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  item.regionalTitle,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Text(
                  item.details,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceBadges() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel, color: AppColors.karmaGreen, size: 14),
            SizedBox(width: 6),
            Text(
              'Statutory Standards & Compliance Attestations',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBadge('DPDP Act 2023', 'India Privacy'),
            _buildBadge('ABDM Compliant', 'NHA Standards'),
            _buildBadge('AES-256 GCM', 'At-Rest Encryption'),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusSm,
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.karmaGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 10)),
          Text(subtitle,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 8)),
        ],
      ),
    );
  }

  void _showSecurityArchitectureModal(BuildContext context) {
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
                primaryText: 'Enterprise Security Architecture',
                regionalText: 'सुरक्षा वास्तुकला व नीतियां',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'FitKarma is built with zero client-side secrets. All LLM calls (Groq) and payment webhooks (RevenueCat) are mediated by Google Cloud Functions. Firebase App Check actively verifies device authenticity, and sensitive health telemetry is guarded with on-device biometrics.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Understood',
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
