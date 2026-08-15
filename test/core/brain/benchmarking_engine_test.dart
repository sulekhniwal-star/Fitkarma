import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/benchmarking_engine.dart';
import 'package:fitkarma/features/gamification/screens/benchmark_display_screen.dart';

void main() {
  group('§P7-E Benchmarking Engine & Screen Tests', () {
    const engine = BenchmarkingEngine();

    const user = UserProfileData(age: 28, gender: 'Male', country: 'India');
    const metrics = UserHealthMetricsData(
      avgSteps7d: 9400,
      avgProtein7d: 78,
      avgSleepH: 7.1,
      workoutsPerWeek: 4.2,
    );

    test(
        'BenchmarkingEngine compares user metrics against demographic cohort distribution',
        () {
      final res = engine.compare(user: user, data: metrics);

      expect(res.cohortLabel, equals('Age 28 · Male · India'));
      expect(res.stepsPercentile,
          greaterThanOrEqualTo(75)); // 9400 steps is above p75 (9000)
      expect(res.proteinPercentile, greaterThanOrEqualTo(50)); // 78g protein
      expect(res.sleepPercentile, greaterThanOrEqualTo(50)); // 7.1h sleep
      expect(res.workoutsPercentile, greaterThanOrEqualTo(75)); // 4.2 workouts
      expect(res.overallPercentile, greaterThan(65));
      expect(res.biggestOpportunityArea, equals('Protein'));
      expect(res.opportunityTip, contains('Protein is your lowest percentile'));
    });

    test('topLabel correctly converts 78th percentile into Top 22%', () {
      final res = engine.compare(user: user, data: metrics);
      expect(res.topLabel(78), equals('Top 22%'));
      expect(res.topLabel(95), equals('Top 5%'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'BenchmarkDisplayScreen renders overall percentile BentoCard, metric breakdowns, and opportunity tip',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BenchmarkDisplayScreen(user: user, metrics: metrics),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fitness Percentiles'), findsOneWidget);
      expect(find.text('Compared to: Age 28 · Male · India'), findsOneWidget);
      expect(find.text('Your Fitness Percentile'), findsOneWidget);
      expect(find.text('Metric Breakdown'), findsOneWidget);
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Workouts'), findsOneWidget);
      expect(find.text('Your biggest opportunity:'), findsOneWidget);
      expect(find.textContaining('Protein is your lowest percentile'),
          findsOneWidget);
    });
  });
}
