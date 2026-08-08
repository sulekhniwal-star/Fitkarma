import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/cohort_insights_service.dart';
import 'package:fitkarma/features/gamification/screens/community_cohort_insights_screen.dart';

void main() {
  group('§P7-F Demographic Cohort Insights & Privacy Guarantee Tests', () {
    const service = CohortInsightsService();

    const input = UserMetricsInput(
      avgSteps: 9420,
      avgProtein: 82,
      avgReadiness: 78,
      city: 'Noida',
      ageRange: '25-30',
    );

    final stepsDist = [3000.0, 5000.0, 6800.0, 8500.0, 9420.0, 11000.0, 13000.0];
    final proteinDist = [40.0, 55.0, 70.0, 82.0, 95.0, 110.0, 125.0];
    final readinessDist = [50.0, 62.0, 70.0, 78.0, 85.0, 90.0, 96.0];

    test('processInsights calculates percentiles and maintains city cohort when raw size >= 50', () {
      final res = service.processInsights(
        metrics: input,
        rawCohortSize: 4210,
        stepsDistribution: stepsDist,
        proteinDistribution: proteinDist,
        readinessDistribution: readinessDist,
      );

      expect(res.isAnonymityPreserved, isTrue);
      expect(res.cityRank.city, equals('Noida'));
      expect(res.stepPercentile, equals(71)); // 5/7 = ~71%
      expect(res.programSuccessStat.programName, equals('Corporate Rebuild'));
    });

    test('Privacy Guarantee: raw size < 50 triggers fallback to state-level category for regional anonymity', () {
      final res = service.processInsights(
        metrics: input,
        rawCohortSize: 32, // < 50 threshold!
        stepsDistribution: stepsDist,
        proteinDistribution: proteinDist,
        readinessDistribution: readinessDist,
      );

      expect(res.isAnonymityPreserved, isFalse);
      expect(res.cityRank.city, equals('Regional Cohort (State Level)'));
      expect(res.cohortSize, equals(50));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('CommunityCohortInsightsScreen renders distribution BentoCards, leaderboard, and toggle opt-out', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: CommunityCohortInsightsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Demographic Cohort Insights'), findsOneWidget);
      expect(find.textContaining('STEPS DISTRIBUTION'), findsOneWidget);
      expect(find.textContaining('Noida Leaderboard'), findsOneWidget);
      expect(find.textContaining('Corporate Rebuild'), findsOneWidget);

      // Toggle switch to trigger opt-out / privacy fallback
      await tester.ensureVisible(find.byType(Switch));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.textContaining('Privacy Guarantee Enforced'), findsOneWidget);
      expect(find.textContaining('Regional Cohort (State Level)'), findsWidgets);
    });
  });
}
