import 'package:fitkarma/features/karma/benchmarking_engine.dart';
import 'package:fitkarma/features/karma/benchmarking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = BenchmarkingEngine();

  const maleProfile = UserProfile(age: 28, gender: 'Male', country: 'India');
  const femaleProfile = UserProfile(age: 28, gender: 'Female', country: 'India');

  group('§P7-E BenchmarkingEngine Unit Tests', () {
    test('Calculates high percentile for above-average user health metrics', () {
      const highData = UserHealthData(
        avgSteps7d: 9000,      // well above mean 6500
        avgProtein7d: 85,      // well above mean 65
        avgSleepH: 7.5,        // above mean 6.5
        workoutsPerWeek: 4.0,  // above mean 2.5
      );

      final result = engine.compare(user: maleProfile, data: highData);

      expect(result.stepsPercentile, greaterThan(75));
      expect(result.proteinPercentile, greaterThan(75));
      expect(result.sleepPercentile, greaterThan(75));
      expect(result.workoutsPercentile, greaterThan(75));
      expect(result.overallPercentile, greaterThan(75));
      expect(result.topPercentageLabel, contains('Top'));
    });

    test('Identifies lowest metric as biggest opportunity', () {
      const proteinWeakData = UserHealthData(
        avgSteps7d: 9000,     // High
        avgProtein7d: 35,     // Very low (well below mean 65)
        avgSleepH: 7.5,       // High
        workoutsPerWeek: 4.0, // High
      );

      final result = engine.compare(user: maleProfile, data: proteinWeakData);

      expect(result.biggestOpportunityMetric, 'Protein');
      expect(result.biggestOpportunityTip, contains('Protein is your lowest percentile'));
    });

    test('Computes female cohort key correctly', () {
      const data = UserHealthData(
        avgSteps7d: 6000,
        avgProtein7d: 60,
        avgSleepH: 7.0,
        workoutsPerWeek: 3.0,
      );

      final result = engine.compare(user: femaleProfile, data: data);

      expect(result.cohortLabel, contains('Female'));
      expect(result.overallPercentile, greaterThanOrEqualTo(1));
      expect(result.overallPercentile, lessThanOrEqualTo(99));
    });
  });

  group('§P7-E BenchmarkingScreen Widget Tests', () {
    testWidgets('Renders hero percentile card, metric breakdown, and opportunity card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BenchmarkingScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Header & Cohort Pill
      expect(find.text('Fitness Benchmarking'), findsOneWidget);
      expect(find.textContaining('Compared to: Age 25-30 · Male · India'), findsOneWidget);

      // 2. Hero Percentile Card
      expect(find.text('Your Fitness Percentile'), findsOneWidget);
      expect(find.textContaining('Top'), findsWidgets);

      // 3. Metric Breakdown
      expect(find.text('Breakdown'), findsOneWidget);
      expect(find.text('👟 Steps'), findsOneWidget);
      expect(find.text('🥗 Protein'), findsOneWidget);
      expect(find.text('😴 Sleep'), findsOneWidget);
      expect(find.text('🏋️ Workouts'), findsOneWidget);

      // 4. Opportunity Card
      expect(find.text('Your Biggest Opportunity'), findsOneWidget);
    });
  });
}
