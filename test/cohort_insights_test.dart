import 'package:fitkarma/features/karma/cohort_aggregation_pipeline.dart';
import 'package:fitkarma/features/karma/cohort_insights_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const pipeline = CohortAggregationPipeline();

  const validPayload = AnonymizedCohortPayload(
    ageGroup: '25-30',
    gender: 'Male',
    region: 'Noida',
    dietType: 'Vegetarian',
    primaryGoal: 'fat_loss',
  );

  group('§P7-F Privacy Audit Tests', () {
    test('Valid anonymized payload passes privacy audit', () {
      expect(() => validPayload.auditPrivacy(), returnsNormally);
    });

    test('Payload containing email throws PrivacyViolationException', () {
      const invalidPayload = AnonymizedCohortPayload(
        ageGroup: '25-30',
        gender: 'Male',
        region: 'user@example.com',
        dietType: 'Vegetarian',
        primaryGoal: 'fat_loss',
      );

      expect(
        () => invalidPayload.auditPrivacy(),
        throwsA(isA<PrivacyViolationException>()),
      );
    });

    test('Payload containing user ID string throws PrivacyViolationException', () {
      const invalidPayload = AnonymizedCohortPayload(
        ageGroup: '25-30',
        gender: 'Male',
        region: 'Noida',
        dietType: 'Vegetarian',
        primaryGoal: 'user_id=12345',
      );

      expect(
        () => invalidPayload.auditPrivacy(),
        throwsA(isA<PrivacyViolationException>()),
      );
    });
  });

  group('§P7-F k-Anonymity Threshold Tests', () {
    test('Cohort size < 25 falls back to broader regional cohort (>= 25)', () {
      final insights = pipeline.aggregate(
        payload: validPayload,
        sampleCohortSize: 10, // Below minimum 25 threshold
        userAvgSteps: 9000,
        userAvgProtein: 80,
        userAvgReadiness: 85,
      );

      expect(insights.cohortSize, greaterThanOrEqualTo(25));
      expect(insights.isPrivacyCompliant, true);
    });

    test('Cohort size >= 25 uses exact sample size', () {
      final insights = pipeline.aggregate(
        payload: validPayload,
        sampleCohortSize: 4210, // Well above minimum 25 threshold
        userAvgSteps: 9000,
        userAvgProtein: 80,
        userAvgReadiness: 85,
      );

      expect(insights.cohortSize, 4210);
      expect(insights.isPrivacyCompliant, true);
      expect(insights.cityRank.city, 'Noida');
    });
  });

  group('§P7-F CohortInsightsScreen Widget Tests', () {
    testWidgets('Renders privacy badge, city rank, age-group rank, and network effect card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CohortInsightsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Header & Privacy Badge
      expect(find.text('Cohort Insights'), findsOneWidget);
      expect(find.textContaining('Privacy-Protected: k-Anonymity (N ≥ 25) Enforced'), findsOneWidget);

      // 2. City Rank
      expect(find.text('Noida City Rank'), findsOneWidget);
      expect(find.textContaining('Noida'), findsWidgets);

      // 3. Age-Group Rank
      expect(find.text('Age 25-30 Group'), findsOneWidget);

      // 4. Network Effect Stat Card
      expect(find.text('Network Effect Insights'), findsOneWidget);
      expect(find.textContaining('achieved their target goals'), findsOneWidget);
    });
  });
}
