import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/corporate_wellness_engine.dart';

void main() {
  group('§P16-D Corporate Wellness & Insurer Tier Tests', () {
    const engine = CorporateWellnessEngine();

    final organization = OrganizationAccount(
      localId: 'org_test_100',
      organizationName: 'Acme Corp Wellness',
      accountType: AccountType.employer,
      planTier: PlanTier.corporatePlus,
      seatLimit: 50,
      createdAt: DateTime.now(),
    );

    test('Enforces strict privacy threshold: Cohort < 10 masks all aggregate metrics', () {
      // 5 users (below threshold of 10)
      final enrollments = List.generate(
        5,
        (i) => EmployeeEnrollment(
          localId: 'enroll_$i',
          userId: 'user_$i',
          organizationId: organization.localId,
          enrolledAt: DateTime.now(),
          isActive: true,
        ),
      );

      final scores = {'user_0': 85.0, 'user_1': 90.0, 'user_2': 65.0, 'user_3': 70.0, 'user_4': 50.0};

      final report = engine.generateAggregateReport(
        organization: organization,
        enrollments: enrollments,
        userAdherenceScores: scores,
      );

      expect(report.isPrivacyThresholdMet, isFalse);
      expect(report.enrolledActiveCount, equals(5));
      expect(report.privacyStatusMessage, contains('Not enough participants yet'));
      expect(report.averageAdherenceScore, isNull);
      expect(report.weeklyActivePct, isNull);
      expect(report.adherenceDistribution, isNull);
    });

    test('Computes anonymized aggregate metrics when cohort >= 10', () {
      // 15 users (meets threshold of 10)
      final enrollments = List.generate(
        15,
        (i) => EmployeeEnrollment(
          localId: 'enroll_$i',
          userId: 'user_$i',
          organizationId: organization.localId,
          enrolledAt: DateTime.now(),
          isActive: true,
        ),
      );

      final scores = <String, double>{};
      for (int i = 0; i < 15; i++) {
        scores['user_$i'] = (60 + (i * 2)).toDouble();
      }

      final report = engine.generateAggregateReport(
        organization: organization,
        enrollments: enrollments,
        userAdherenceScores: scores,
      );

      expect(report.isPrivacyThresholdMet, isTrue);
      expect(report.enrolledActiveCount, equals(15));
      expect(report.averageAdherenceScore, isNotNull);
      expect(report.averageAdherenceScore, greaterThan(60));
      expect(report.weeklyActivePct, isNotNull);
      expect(report.adherenceDistribution, isNotNull);
      expect(report.adherenceDistribution!.containsKey('High Adherence (80%+)'), isTrue);
    });

    test('Employee enrollment creation generates unique localId and active status', () {
      final enrollment = engine.enrollEmployee(
        organizationId: 'org_123',
        userId: 'user_456',
      );

      expect(enrollment.organizationId, equals('org_123'));
      expect(enrollment.userId, equals('user_456'));
      expect(enrollment.isActive, isTrue);
      expect(enrollment.localId, startsWith('enroll_org_123_user_456_'));
    });
  });
}
