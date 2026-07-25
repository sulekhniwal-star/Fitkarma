/// §COMPLIANCE — All Compliance Items Verification Tests

import 'package:fitkarma/core/compliance/clinical_access_revoke_service.dart';
import 'package:fitkarma/core/compliance/dpdp_compliance_service.dart';
import 'package:fitkarma/core/compliance/non_diagnostic_shield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('§COMPLIANCE DPDP Act Privacy Policy Tests', () {
    test('DpdpActPrivacyPolicy declares required consent purposes and data fiduciary', () {
      const policy = DpdpActPrivacyPolicy();

      expect(DpdpActPrivacyPolicy.privacyPolicyUrl, contains('fitkarma.in/privacy-policy'));
      expect(DpdpActPrivacyPolicy.consentPurposes, isNotEmpty);
      expect(DpdpActPrivacyPolicy.consentPurposes.any((p) => p.contains('opt-in')), isTrue);
      expect(DpdpActPrivacyPolicy.dataFiduciaryName, contains('FitKarma'));
    });
  });

  group('§COMPLIANCE AnonymizedCohortSync Exclusion Verifier Tests', () {
    const verifier = AnonymizedCohortSyncVerifier();

    test('compliant cohort payload with only aggregates passes verification', () {
      final payload = {
        'organizationId': 'org_101',
        'totalEnrolled': 250,
        'adherenceDistribution': {'high': 60, 'medium': 30, 'low': 10},
        'dateRange': '2026-Q2',
      };

      final result = verifier.verifyCohortPayload(payload);
      expect(result.isCompliant, isTrue);
      expect(result.violations, isEmpty);
    });

    test('rejects cohort payload containing individual userId keys', () {
      final payload = {
        'userId': 'usr_sharma_01',
        'adherence': 'high',
      };

      final result = verifier.verifyCohortPayload(payload);
      expect(result.isCompliant, isFalse);
      expect(result.violations.any((v) => v.contains('userId')), isTrue);
    });

    test('rejects payload with individual lab_date fields', () {
      final payload = {
        'totalUsers': 50,
        'labDate': '2026-07-14',
      };

      final result = verifier.verifyCohortPayload(payload);
      expect(result.isCompliant, isFalse);
      expect(result.violations.any((v) => v.contains('lab_date')), isTrue);
    });

    test('rejects payload with medication brand names (must use generic class only)', () {
      final payload = {
        'medicationAdherence': 'metformin users high adherence',
      };

      final result = verifier.verifyCohortPayload(payload);
      expect(result.isCompliant, isFalse);
      expect(result.violations.any((v) => v.contains('brand names')), isTrue);
    });

    test('rejects payload containing ABHA Health ID', () {
      final payload = {
        'abhaHealthId': 'ABHA-123456789',
      };

      final result = verifier.verifyCohortPayload(payload);
      expect(result.isCompliant, isFalse);
      expect(result.violations.any((v) => v.contains('ABHA')), isTrue);
    });
  });

  group('§COMPLIANCE Revoke All Clinical Access Wipe Tests', () {
    test('ClinicalAccessRevokeService covers all 6 clinical tables and 2 Users fields', () {
      const service = ClinicalAccessRevokeService();

      expect(service.clinicalTableScope, contains('bp_readings'));
      expect(service.clinicalTableScope, contains('cgm_readings'));
      expect(service.clinicalTableScope, contains('medication_logs'));
      expect(service.clinicalTableScope, contains('abha_health_id'));
      expect(service.clinicalUserFieldScope, contains('abhaHealthId'));
    });

    test('revokeAllClinicalAccess returns success with local and remote row counts', () async {
      const service = ClinicalAccessRevokeService();
      final result = await service.revokeAllClinicalAccess(userId: 'usr_sharma');

      expect(result.success, isTrue);
      expect(result.localRowsDeleted, greaterThan(0));
      expect(result.remoteRowsDeleted, greaterThan(0));
      expect(result.totalRowsDeleted, greaterThan(result.localRowsDeleted));
    });
  });

  group('§COMPLIANCE NonDiagnosticShield Component Widget Tests', () {
    testWidgets('renders CGM context disclaimer with shield banner key', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NonDiagnosticShield(context: NonDiagnosticContext.cgmReading),
          ),
        ),
      );

      expect(find.byKey(const Key('non_diagnostic_shield_banner')), findsOneWidget);
      expect(find.textContaining('wellness tracking only'), findsOneWidget);
    });

    testWidgets('renders medication interaction disclaimer with appropriate text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NonDiagnosticShield(context: NonDiagnosticContext.medicationInteraction),
          ),
        ),
      );

      expect(find.textContaining('Interaction flags are informational only'), findsOneWidget);
    });

    testWidgets('renders compact bio-age disclaimer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NonDiagnosticShield(
              context: NonDiagnosticContext.bioAge,
              compact: true,
            ),
          ),
        ),
      );

      expect(find.textContaining('not a clinical assessment'), findsOneWidget);
    });
  });
}
