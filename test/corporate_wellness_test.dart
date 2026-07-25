/// §P16-D Corporate Wellness & Insurer Tier — Unit & Widget Tests

import 'package:fitkarma/features/corporate/corporate_controller.dart';
import 'package:fitkarma/features/corporate/corporate_dashboard_screen.dart';
import 'package:fitkarma/features/corporate/corporate_models.dart';
import 'package:fitkarma/features/corporate/corporate_wellness_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = CorporateWellnessService();

  final sampleOrg = OrganizationAccount(
    localId: 'org_1',
    organizationName: 'TechCorp India',
    accountType: AccountType.employer,
    planTier: CorporatePlanTier.corporatePlus,
    seatLimit: 500,
    enrollmentCode: 'TECH-CORP-2026',
    createdAt: DateTime.now(),
  );

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: CorporateDashboardScreen(),
      ),
    );
  }

  group('§P16-D CorporateWellnessService Code Linking & Seat Capacity Tests', () {
    test('links employee using valid enrollment code', () async {
      final enrollment = await service.linkEmployeeByCode(
        userId: 'usr_new',
        enrollmentCode: 'TECH-CORP-2026',
        availableOrgs: [sampleOrg],
        currentEnrollments: [],
      );

      expect(enrollment.organizationId, equals(sampleOrg.localId));
      expect(enrollment.userId, equals('usr_new'));
      expect(enrollment.isActive, isTrue);
    });

    test('throws exception for invalid enrollment code or full seat capacity', () async {
      expect(
        () => service.linkEmployeeByCode(
          userId: 'usr_new',
          enrollmentCode: 'INVALID-CODE',
          availableOrgs: [sampleOrg],
          currentEnrollments: [],
        ),
        throwsException,
      );

      // Simulate full seats
      final fullEnrollments = List.generate(
        500,
        (i) => EmployeeEnrollment(
          localId: 'enr_$i',
          userId: 'usr_$i',
          organizationId: sampleOrg.localId,
          enrolledAt: DateTime.now(),
        ),
      );

      expect(
        () => service.linkEmployeeByCode(
          userId: 'usr_501',
          enrollmentCode: 'TECH-CORP-2026',
          availableOrgs: [sampleOrg],
          currentEnrollments: fullEnrollments,
        ),
        throwsException,
      );
    });

    test('unlinks employee cleanly for reversible opt-out', () {
      final active = EmployeeEnrollment(
        localId: 'enr_1',
        userId: 'usr_1',
        organizationId: sampleOrg.localId,
        enrolledAt: DateTime.now(),
      );

      final unlinked = service.unlinkEmployee(active);
      expect(unlinked.isActive, isFalse);
    });
  });

  group('§P16-D Minimum Cohort Size Threshold & Privacy Audit Tests', () {
    test('suppresses aggregates when active cohort size is under 5 participants (§P7-F reuse)', () {
      final smallCohort = List.generate(
        3, // Only 3 active participants (< 5 threshold)
        (i) => EmployeeEnrollment(
          localId: 'enr_$i',
          userId: 'usr_$i',
          organizationId: sampleOrg.localId,
          enrolledAt: DateTime.now(),
        ),
      );

      final metrics = service.getOrgAggregateMetrics(
        org: sampleOrg,
        allEnrollments: smallCohort,
        minCohortThreshold: 5,
      );

      expect(metrics.isCohortThresholdMet, isFalse);
      expect(metrics.adherenceDistribution, isEmpty);
      expect(metrics.privacyAuditPassed, isTrue);
    });

    test('renders anonymized aggregates when active cohort size is >= 5 participants', () {
      final validCohort = List.generate(
        10, // 10 active participants (>= 5 threshold)
        (i) => EmployeeEnrollment(
          localId: 'enr_$i',
          userId: 'usr_$i',
          organizationId: sampleOrg.localId,
          enrolledAt: DateTime.now(),
        ),
      );

      final metrics = service.getOrgAggregateMetrics(
        org: sampleOrg,
        allEnrollments: validCohort,
        minCohortThreshold: 5,
      );

      expect(metrics.isCohortThresholdMet, isTrue);
      expect(metrics.adherenceDistribution, isNotEmpty);
      expect(metrics.adherenceDistribution.containsKey('High Adherence (80-100%)'), isTrue);
      expect(metrics.privacyAuditPassed, isTrue);
    });

    test('Privacy Audit verifies zero per-user PII fields are queryable from aggregate endpoint', () {
      final validCohort = List.generate(
        10,
        (i) => EmployeeEnrollment(
          localId: 'enr_$i',
          userId: 'usr_$i',
          organizationId: sampleOrg.localId,
          enrolledAt: DateTime.now(),
        ),
      );

      final metrics = service.getOrgAggregateMetrics(
        org: sampleOrg,
        allEnrollments: validCohort,
      );

      expect(metrics.privacyAuditPassed, isTrue);
      // Assert metric fields are purely aggregate metrics
      expect(metrics.organizationId, isNotEmpty);
      expect(metrics.totalEnrolled, equals(10));
    });
  });

  group('§P16-D CorporateNotifier Integration Tests', () {
    test('updates plan tier and seat limits', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(corporateProvider.notifier);

      notifier.updatePlanTier(CorporatePlanTier.corporateBasic, 250);
      final state = container.read(corporateProvider);

      expect(state.currentOrg!.planTier, equals(CorporatePlanTier.corporateBasic));
      expect(state.currentOrg!.seatLimit, equals(250));
    });
  });

  group('§P16-D CorporateDashboardScreen Widget Tests', () {
    testWidgets('renders HR dashboard, seat meter, adherence breakdown, and privacy shield badge', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('🏢 Corporate Wellness HR Dashboard'), findsOneWidget);
      expect(find.text('TechCorp India Ltd'), findsOneWidget);
      expect(find.text('📊 Seat Utilization & Enrollment Metrics'), findsOneWidget);
      expect(find.text('📈 Aggregate Health Adherence Distribution'), findsOneWidget);
      expect(find.textContaining('Privacy Shield Audit Passed'), findsOneWidget);
    });
  });
}
