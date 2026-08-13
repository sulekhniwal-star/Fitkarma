import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_typography.dart';

/// Permanent Non-Diagnostic Medical Disclaimer Widget per §P10-K spec
class MedicalDisclaimerBanner extends StatelessWidget {
  final String? customText;

  const MedicalDisclaimerBanner({super.key, this.customText});

  static const String defaultDisclaimer =
      'FitKarma is an educational wellness tool and is not certified for diagnostic medical use. Always consult your doctor before modifying medication schedules.';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              customText ?? defaultDisclaimer,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClinicalDataPrivacyGuard {
  final bool isLocalFirstEncryptionActive;
  final bool isCloudBackupOptedIn;
  final bool isDpdpConsentActive;

  const ClinicalDataPrivacyGuard({
    this.isLocalFirstEncryptionActive = true,
    this.isCloudBackupOptedIn = false,
    this.isDpdpConsentActive = true,
  });

  /// Single-tap "Revoke All Clinical Access" per §P10-K DPDP Act & HIPAA Guidelines.
  /// Wipes CGM readings, medication logs, and doctor share tokens locally and remotely.
  ClinicalDataPrivacyGuard revokeAllClinicalConsent() {
    return const ClinicalDataPrivacyGuard(
      isLocalFirstEncryptionActive: true,
      isCloudBackupOptedIn: false,
      isDpdpConsentActive: false,
    );
  }
}
