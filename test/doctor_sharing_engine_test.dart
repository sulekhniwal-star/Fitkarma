/// §P10-J Doctor Sharing Portal — Unit Tests
///
/// Tests for DoctorSharingEngine (token lifecycle, FHIR-lite, §P10-K revoke-all)
/// and SharingToken model (create, revoke, JSON round-trip).
library;

import 'package:fitkarma/features/predictive/clinical_sharing_models.dart';
import 'package:fitkarma/features/predictive/doctor_sharing_engine.dart';
import 'package:fitkarma/features/predictive/monthly_report_models.dart';
import 'package:fitkarma/features/predictive/biological_age_estimator.dart';
import 'package:fitkarma/features/predictive/health_risk_prevention_engine.dart';
import 'package:test/test.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

MonthlyReportPayload _stubReport() {
  final bioAge = BiologicalAgeResult(
    chronologicalAge: 32,
    estimatedBiologicalAge: 29,
    ageDeltaYears: -3,
    primaryDrivers: const ['HRV', 'Sleep'],
    calculationDate: DateTime(2026, 6, 1),
  );

  return MonthlyReportPayload(
    reportMonthPeriod: 'Jun 2026',
    biologicalAgeResult: bioAge,
    systolicBpAvg: 118,
    diastolicBpAvg: 76,
    fastingGlucoseAvg: 92,
    hrvAvgMs: 68,
    hrvTrendPercent: 6.5,
    detectedRisks: const [],
    focusStrategyItems: const ['Maintain cardio baseline.'],
    generatedAt: DateTime(2026, 6, 1),
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('SharingToken', () {
    test('create generates a unique tokenId and 6-digit passcode', () {
      final t1 = SharingToken.create(mode: SharingMode.passcodeProtectedPdf);
      final t2 = SharingToken.create(mode: SharingMode.passcodeProtectedPdf);

      expect(t1.tokenId.length, equals(16));
      expect(t1.passcode.length, equals(6));
      expect(int.tryParse(t1.passcode), isNotNull, reason: 'passcode is numeric');
      expect(t1.tokenId, isNot(equals(t2.tokenId)),
          reason: 'tokens must be unique');
      expect(t1.isActive, isTrue);
    });

    test('revoke() sets status to revoked and isActive becomes false', () {
      final token = SharingToken.create(mode: SharingMode.fhirLiteExport);
      expect(token.isActive, isTrue);

      final revoked = token.revoke();
      expect(revoked.status, equals(ShareStatus.revoked));
      expect(revoked.isActive, isFalse);
    });

    test('token expires when expiresAt is in the past', () {
      final token = SharingToken(
        tokenId: 'TEST1234ABCD5678',
        passcode: '123456',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        expiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
        mode: SharingMode.passcodeProtectedPdf,
      );
      expect(token.isActive, isFalse);
    });

    test('JSON round-trip preserves all fields', () {
      final token = SharingToken.create(
        mode: SharingMode.fhirLiteExport,
        recipientLabel: 'Dr. Mehta',
      );
      final json = token.toJson();
      final restored = SharingToken.fromJson(json);

      expect(restored.tokenId, equals(token.tokenId));
      expect(restored.passcode, equals(token.passcode));
      expect(restored.mode, equals(SharingMode.fhirLiteExport));
      expect(restored.recipientLabel, equals('Dr. Mehta'));
      expect(restored.status, equals(ShareStatus.active));
    });
  });

  group('DoctorSharingEngine — token lifecycle', () {
    late DoctorSharingEngine engine;

    setUp(() => engine = DoctorSharingEngine());

    test('createToken adds to allTokens', () {
      engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      expect(engine.allTokens, hasLength(1));
    });

    test('revokeToken by ID removes from activeTokens', () {
      final t = engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      expect(engine.activeTokens, hasLength(1));

      final result = engine.revokeToken(t.tokenId);
      expect(result, isTrue);
      expect(engine.activeTokens, isEmpty);
      expect(engine.allTokens, hasLength(1)); // still in history
    });

    test('revokeToken returns false for unknown tokenId', () {
      final result = engine.revokeToken('NONEXISTENT0000Z');
      expect(result, isFalse);
    });

    test('revokeAllClinicalAccess revokes every active token', () {
      engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      engine.createToken(mode: SharingMode.fhirLiteExport);
      expect(engine.activeTokens, hasLength(2));

      final count = engine.revokeAllClinicalAccess();
      expect(count, equals(2));
      expect(engine.activeTokens, isEmpty);
    });

    test('revokeAll returns 0 when no active tokens exist', () {
      final count = engine.revokeAllClinicalAccess();
      expect(count, equals(0));
    });

    test('access log records created and revoked events', () {
      final t = engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      engine.revokeToken(t.tokenId);

      final log = engine.accessLog;
      expect(log, hasLength(2));
      expect(log[0].event, equals('created'));
      expect(log[1].event, equals('revoked'));
    });
  });

  group('DoctorSharingEngine — buildPdfContent', () {
    late DoctorSharingEngine engine;

    setUp(() => engine = DoctorSharingEngine());

    test('builds SharableReportContent with correct headline and passcode', () {
      final report = _stubReport();
      final token = engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      final content = engine.buildPdfContent(report: report, token: token);

      expect(content.headline, contains('Jun 2026'));
      expect(content.token.passcode, equals(token.passcode));
      expect(content.sections, contains('Disclaimer'));
    });

    test('toPlainText contains passcode and section headers', () {
      final report = _stubReport();
      final token = engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      final content = engine.buildPdfContent(report: report, token: token);
      final text = content.toPlainText();

      expect(text, contains(token.passcode));
      expect(text, contains('Biomarker Averages'));
      expect(text, contains('Disclaimer'));
    });

    test('all strings pass through ClinicalCopyLinter (no prohibited terms)', () {
      final report = MonthlyReportPayload(
        reportMonthPeriod: 'Jun 2026',
        biologicalAgeResult: BiologicalAgeResult(
          chronologicalAge: 40,
          estimatedBiologicalAge: 38,
          ageDeltaYears: -2,
          primaryDrivers: const ['BMI'],
          calculationDate: DateTime(2026, 6, 1),
        ),
        systolicBpAvg: 140,
        diastolicBpAvg: 90,
        fastingGlucoseAvg: 110,
        hrvAvgMs: 45,
        hrvTrendPercent: -5,
        detectedRisks: [
          HealthRiskFlag(
            riskCategory: HealthRiskCategory.hypertension,
            severity: RiskSeverity.moderate,
            triggerDescription: 'diagnosed with hypertension',
            inputSignals: const ['BP 140/90'],
            recommendedAction: 'reduce sodium intake',
            timestamp: DateTime(2026, 6, 1),
          ),
        ],
        focusStrategyItems: const ['prescribe medication for BP'],
        generatedAt: DateTime(2026, 6, 1),
      );

      final token = engine.createToken(mode: SharingMode.passcodeProtectedPdf);
      final content = engine.buildPdfContent(report: report, token: token);
      final text = content.toPlainText();

      expect(text.toLowerCase(), isNot(contains('diagnosed with')),
          reason: 'ClinicalCopyLinter should sanitize "diagnosed with"');
      expect(text.toLowerCase(), isNot(contains('prescribe')),
          reason: 'ClinicalCopyLinter should sanitize "prescribe"');
    });
  });

  group('DoctorSharingEngine — buildFhirLitePayload', () {
    test('produces a valid FHIR Bundle with expected resourceTypes', () {
      final engine = DoctorSharingEngine();
      final payload = engine.buildFhirLitePayload(
        report: _stubReport(),
        patientId: 'user-test-001',
      );

      final json = payload.toJson();
      expect(json['resourceType'], equals('Bundle'));
      expect(json['id'], equals('user-test-001'));
      expect(json['_disclaimer'], contains('§P10-K'));

      final types = (json['entry'] as List)
          .map((e) => (e as Map)['resource']['resourceType'])
          .toList();
      expect(types, containsAll(['Observation', 'Condition', 'CarePlan']));
    });
  });

  group('DoctorSharingEngine — buildAnonymizedCohortPayload §P10-K', () {
    test('does not include patientId or PII fields', () {
      final engine = DoctorSharingEngine();
      final payload = engine.buildAnonymizedCohortPayload(
        report: _stubReport(),
        cohortSegment: 'india-30-40-m',
      );

      expect(payload, isNot(contains('patientId')));
      expect(payload, isNot(contains('name')));
      expect(payload['_privacyLevel'], equals('anonymous-aggregate'));
      expect(payload['cohort'], equals('india-30-40-m'));
    });
  });
}
