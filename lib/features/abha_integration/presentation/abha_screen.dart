import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/abha_models.dart';
import '../providers/abha_provider.dart';

/// Screen managing Ayushman Bharat Health Account (ABHA) integration,
/// official ABDM Digital Health Card, FHIR R4 record syncing, and dynamic consent management.
class AbhaScreen extends ConsumerStatefulWidget {
  const AbhaScreen({super.key});

  @override
  ConsumerState<AbhaScreen> createState() => _AbhaScreenState();
}

class _AbhaScreenState extends ConsumerState<AbhaScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(abhaIntegrationProvider);
    final notifier = ref.read(abhaIntegrationProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'ABHA Health ID (ABDM)',
          regionalText: 'आयुष्मान भारत डिजिटल हेल्थ खाता',
        ),
        actions: [
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
            // Status Banner
            if (state.statusMessage != null)
              _buildStatusBanner(state.statusMessage!),

            // 1. Official ABHA Digital Health Card
            _buildAbhaDigitalCard(state.profile, notifier),
            const SizedBox(height: AppSpacing.md),

            // 2. FHIR R4 Health Records Sync Hub
            _buildFhirSyncCard(state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 3. ABDM Dynamic Consent Manager
            _buildConsentManagerCard(state.activeConsents, notifier),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.karmaGreen.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.karmaGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: AppColors.karmaGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbhaDigitalCard(
      AbhaProfile profile, AbhaIntegrationNotifier notifier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2A47), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadii.radiusMd,
        border: Border.all(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // National Emblem & ABDM Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '🇮🇳 ABDM',
                      style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'National Health Authority',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: profile.isLinked
                      ? AppColors.karmaGreen.withValues(alpha: 0.2)
                      : AppColors.energyOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: profile.isLinked
                        ? AppColors.karmaGreen
                        : AppColors.energyOrange,
                  ),
                ),
                child: Text(
                  profile.verificationStatus.label.split('(').first.trim(),
                  style: TextStyle(
                    color: profile.isLinked
                        ? AppColors.karmaGreen
                        : AppColors.energyOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // User details & QR Badge
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ABHA Number: ${profile.abhaNumber}',
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ABHA Address: ${profile.abhaAddress}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'DOB: ${profile.dateOfBirth} | Gender: ${profile.gender == "M" ? "Male" : "Female"}',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child:
                      Icon(Icons.qr_code_2, color: Color(0xFF0F172A), size: 56),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: Color(0x33FFFFFF), height: 1),
          const SizedBox(height: AppSpacing.sm),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AYUSHMAN BHARAT DIGITAL MISSION',
                style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    letterSpacing: 0.8),
              ),
              TextButton(
                onPressed: () => _showKycModal(context, notifier),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: Text(
                  profile.isLinked ? 'Re-verify' : 'Link ABHA ID',
                  style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFhirSyncCard(AbhaState state, AbhaIntegrationNotifier notifier) {
    final bundle = state.latestFhirBundle;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'FHIR R4 Health Records (HIP/HIU)',
                regionalText: 'एफएचआईआर आर४ स्वास्थ्य रिकॉर्ड्स सिंक',
              ),
              Icon(Icons.sync_alt, color: AppColors.focusBlue, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Securely package and transmit your FitKarma biological biomarkers to your ABHA PHR app (Aarogya Setu / ABHA App) in ABDM-compliant FHIR R4 Document Bundles.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          if (bundle != null) ...[
            Row(
              children: [
                Expanded(
                  child: GlowingMetric(
                    value: bundle.latestLongevityScore.toStringAsFixed(1),
                    unit: '/ 100',
                    label: 'Longevity Score',
                    accentColor: AppColors.karmaGreen,
                  ),
                ),
                Container(
                    width: 1, height: 40, color: AppColors.surfaceElevated),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GlowingMetric(
                    value: bundle.latestBiologicalAge.toStringAsFixed(1),
                    unit: 'yrs',
                    label: 'Bio Age',
                    accentColor: AppColors.focusBlue,
                  ),
                ),
                Container(
                    width: 1, height: 40, color: AppColors.surfaceElevated),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GlowingMetric(
                    value: '${bundle.weeklyStepsAverage}',
                    unit: 'steps/d',
                    label: 'Daily Steps',
                    accentColor: AppColors.energyOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated.withValues(alpha: 0.4),
                borderRadius: AppRadii.radiusSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prakriti: ${bundle.prakritiConstitution}',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'VO2 Max: ${bundle.averageVo2Max.toStringAsFixed(1)} ml/kg/min',
                    style: const TextStyle(
                        color: AppColors.focusBlue, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.karmaGreen,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.sm)),
              ),
              onPressed: state.isSyncingWithGateway
                  ? null
                  : () => notifier.syncFhirRecordsWithAbdm(),
              icon: state.isSyncingWithGateway
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.background),
                    )
                  : const Icon(Icons.cloud_upload,
                      color: AppColors.background, size: 18),
              label: Text(
                state.isSyncingWithGateway
                    ? 'Transmitting to ABDM...'
                    : 'Push Records to ABHA PHR',
                style: const TextStyle(
                    color: AppColors.background, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentManagerCard(
      List<AbhaConsentGrant> consents, AbhaIntegrationNotifier notifier) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BilingualLabel(
                primaryText: 'ABDM Dynamic Consent Manager',
                regionalText: 'डिजिटल सहमति व अनुमतियां',
              ),
              Icon(Icons.security, color: AppColors.karmaGreen, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Granular consent artifacts granting certified hospitals and doctors time-bound access under NHA guidelines. Revoke access instantly with 1-tap.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...consents.map((consent) => _buildConsentItem(consent, notifier)),
        ],
      ),
    );
  }

  Widget _buildConsentItem(
      AbhaConsentGrant consent, AbhaIntegrationNotifier notifier) {
    final bool isGranted = consent.status == AbhaConsentStatus.granted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.4),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(
          color: isGranted
              ? AppColors.glassBorder
              : AppColors.alertRed.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  consent.requesterEntityName,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isGranted
                      ? AppColors.karmaGreen.withValues(alpha: 0.15)
                      : AppColors.alertRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isGranted ? 'Active Grant' : 'Revoked',
                  style: TextStyle(
                    color:
                        isGranted ? AppColors.karmaGreen : AppColors.alertRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Purpose: ${consent.purpose.label} (${consent.purpose.code})',
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          Text(
            'Artifacts: ${consent.hiTypes.join(", ")}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valid until: ${consent.validUntil.day}/${consent.validUntil.month}/${consent.validUntil.year}',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
              if (isGranted)
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.alertRed,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () =>
                      notifier.revokeConsent(consent.consentRequestId),
                  child: const Text('Revoke Access',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                )
              else
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.karmaGreen,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () =>
                      notifier.approveConsent(consent.consentRequestId),
                  child: const Text('Re-authorize',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showKycModal(BuildContext context, AbhaIntegrationNotifier notifier) {
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
                        primaryText: 'Verify ABHA / Aadhaar KYC',
                        regionalText: 'आभा / आधार सत्यापन',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: '14-Digit ABHA or 12-Digit Aadhaar',
                      labelStyle:
                          const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.sm)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: '6-Digit OTP (Sent via UIDAI / ABDM)',
                      labelStyle:
                          const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.sm)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.focusBlue,
                            side: const BorderSide(color: AppColors.focusBlue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            notifier.initiateAadhaarKyc(_idController.text);
                          },
                          child: const Text('Send OTP'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.karmaGreen,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            final success =
                                notifier.verifyOtp(_otpController.text);
                            if (success) Navigator.pop(ctx);
                          },
                          child: const Text('Verify & Link',
                              style: TextStyle(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
              primaryText: 'Ayushman Bharat Digital Mission (ABDM)',
              regionalText: 'राष्ट्रीय डिजिटल स्वास्थ्य मिशन दर्शन',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'FitKarma fully supports India\'s ABDM ecosystem under the National Health Authority (NHA). The 14-digit ABHA ID links preventive lifestyle metrics (Biological Age, Longevity Score, Daily Steps, Prakriti) with the national digital health grid using HL7/FHIR R4 standards, empowering users with complete data ownership and time-bound consent control.',
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
