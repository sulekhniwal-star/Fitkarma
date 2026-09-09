import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/compliance_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/compliance_models.dart';

void main() {
  group('ComplianceEngine Deterministic Evaluation Tests', () {
    const engine = ComplianceEngine();

    test('Clinical Disclaimer contains both English and Hindi text with emergency helpline', () {
      final disclaimer = engine.getStandardClinicalDisclaimer();
      expect(disclaimer.title, contains('SaMD'));
      expect(disclaimer.regionalTitle, isNotEmpty);
      expect(disclaimer.legalText, contains('FitKarma provides AI-driven lifestyle'));
      expect(disclaimer.regionalLegalText, contains('फिटकर्मा'));
      expect(disclaimer.emergencyHelpline, contains('112'));
    });

    test('Statutory consent generation contains 3 default frameworks (DPDP, ABDM, AYUSH)', () {
      final now = DateTime(2026, 9, 9, 10, 0);
      final consents = engine.generateDefaultStatutoryConsents(grantedTime: now);

      expect(consents.length, equals(3));
      expect(consents[0].consentId, equals('CONSENT-DPDP-HEALTH-TELEMETRY-01'));
      expect(consents[1].consentId, equals('CONSENT-ABDM-FHIR-SHARE-02'));
      expect(consents[2].consentId, equals('CONSENT-AYUSH-LIFESTYLE-03'));
      expect(consents.every((c) => c.isExplicitlyGranted && c.isRevocable), isTrue);
      expect(consents[0].expiresAt, equals(now.add(const Duration(days: 365))));
    });

    test('Full compliance evaluation yields 100% score when all safeguards & consents are valid', () {
      final now = DateTime(2026, 9, 9, 10, 0);
      final consents = engine.generateDefaultStatutoryConsents(grantedTime: now);

      final report = engine.evaluateCompliance(
        userConsents: consents,
        encryptionAtRestVerified: true,
        auditLoggingActive: true,
        dataErasureSupported: true,
        auditTimestamp: now,
      );

      expect(report.complianceAuditScore, equals(100.0));
      expect(report.isFullyCompliant, isTrue);
      expect(report.activeStandards.length, equals(4));
      expect(report.activeConsents.length, equals(3));
      expect(report.encryptionAtRestVerified, isTrue);
      expect(report.auditLoggingActive, isTrue);
      expect(report.dataErasureSupported, isTrue);
    });

    test('Partial compliance evaluation when encryption or consents are missing', () {
      final now = DateTime(2026, 9, 9, 10, 0);

      final report = engine.evaluateCompliance(
        userConsents: [],
        encryptionAtRestVerified: false,
        auditLoggingActive: true,
        dataErasureSupported: true,
        auditTimestamp: now,
      );

      // Only audit logging (25) + data erasure (25) = 50%
      expect(report.complianceAuditScore, equals(50.0));
      expect(report.isFullyCompliant, isFalse);
      expect(report.activeConsents, isEmpty);
    });

    test('Expired consents are excluded from active list during evaluation', () {
      final now = DateTime(2026, 9, 9, 10, 0);
      final expiredConsent = ClinicalConsentArtifact(
        consentId: 'EXPIRED-01',
        purpose: 'Old research',
        regionalPurpose: 'पुराना शोध',
        dataCategories: const ['Vitals'],
        grantedAt: now.subtract(const Duration(days: 400)),
        expiresAt: now.subtract(const Duration(days: 35)),
        isExplicitlyGranted: true,
        isRevocable: true,
      );

      final report = engine.evaluateCompliance(
        userConsents: [expiredConsent],
        encryptionAtRestVerified: true,
        auditLoggingActive: true,
        dataErasureSupported: true,
        auditTimestamp: now,
      );

      expect(report.activeConsents, isEmpty);
      expect(report.complianceAuditScore, equals(75.0)); // Missing active consent
      expect(report.isFullyCompliant, isFalse);
    });
  });
}
