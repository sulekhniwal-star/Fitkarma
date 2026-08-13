import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/shared/widgets/medical_disclaimer_banner.dart';
import 'package:fitkarma/features/predictive_health/screens/clinical_compliance_settings_screen.dart';

void main() {
  group('§P10-K Regulatory & Clinical Compliance Framework Tests', () {
    test('ClinicalDataPrivacyGuard revokeAllClinicalConsent updates consent state to false', () {
      const guard = ClinicalDataPrivacyGuard();
      expect(guard.isDpdpConsentActive, isTrue);

      final revoked = guard.revokeAllClinicalConsent();
      expect(revoked.isDpdpConsentActive, isFalse);
      expect(revoked.isCloudBackupOptedIn, isFalse);
      expect(revoked.isLocalFirstEncryptionActive, isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('ClinicalComplianceSettingsScreen renders disclaimer, compliance status, and Revoke CTA', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ClinicalComplianceSettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('⚖️ Regulatory & Clinical Compliance'), findsOneWidget);
      expect(find.textContaining('educational wellness tool and is not certified for diagnostic medical use'), findsOneWidget);
      expect(find.text('Clinical Data Isolation (DPDP & HIPAA)'), findsOneWidget);
      expect(find.text('Revoke All Clinical Access'), findsOneWidget);

      await tester.tap(find.text('Revoke All Clinical Access'));
      await tester.pumpAndSettle();

      expect(find.text('REVOKED ✗'), findsAtLeastNWidgets(1));
    });
  });
}
