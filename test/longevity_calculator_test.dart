import 'package:fitkarma/features/predictive/longevity_calculator.dart';
import 'package:fitkarma/features/predictive/longevity_notifier.dart';
import 'package:fitkarma/features/predictive/longevity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = LongevityScoreCalculator();

  group('§P10-G LongevityScoreCalculator Unit Tests', () {
    test('Calculates multi-factor longevity score and biological age correctly', () {
      const input = LongevityInputData(
        estimatedVo2Max: 48.0,
        age: 28,
        isMale: true,
        bodyFatPct: 15.0,
        avgSleepHours: 8.0,
        sleepQuality7dAvg: 85.0,
        avgDailySteps7d: 10000,
        workoutsPerWeek: 4,
        restingHr: 56.0,
        hrv: 65.0,
        baselineHrv: 55.0,
        hasClinicalData: true,
      );

      final result = calculator.calculate(input);

      expect(result.chronologicalAge, 28);
      expect(result.longevityScore, greaterThanOrEqualTo(80));
      expect(result.biologicalAge, lessThan(28));
      expect(result.isYoungerThanChronological, true);
      expect(result.biggestOpportunity, isNotEmpty);
    });

    test('Extracts biggest opportunity recommendation', () {
      const suboptimalInput = LongevityInputData(
        estimatedVo2Max: 42.0,
        age: 30,
        isMale: true,
        bodyFatPct: 24.0, // High body fat -> lowest score
        avgSleepHours: 7.5,
        sleepQuality7dAvg: 80.0,
        avgDailySteps7d: 9000,
        workoutsPerWeek: 4,
        restingHr: 62.0,
        hrv: 55.0,
        hasClinicalData: false,
      );

      final result = calculator.calculate(suboptimalInput);

      expect(result.biggestOpportunity, contains('Body Composition'));
    });
  });

  group('§P10-G LongevityScreen Widget Tests', () {
    testWidgets('Renders longevity score gauge, biological age, factor breakdown, opportunity, and footer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            longevityProvider.overrideWith(LongevityNotifier.new),
          ],
          child: const MaterialApp(
            home: LongevityScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar
      expect(find.text('🌱 Longevity Score'), findsOneWidget);

      // 2. Score & Biological Age Card
      expect(find.text('Biological Age'), findsOneWidget);
      expect(find.text('Chronological Age'), findsOneWidget);
      expect(find.textContaining('younger than your actual age'), findsOneWidget);

      // 3. Factor Breakdown
      expect(find.text('Factor Breakdown:'), findsOneWidget);
      expect(find.text('❤️ Cardio (HRV/HR):'), findsOneWidget);
      expect(find.text('😴 Sleep:'), findsOneWidget);
      expect(find.text('🏃 Activity:'), findsOneWidget);

      // 4. Biggest Opportunity Card
      expect(find.text('Biggest Opportunity:'), findsOneWidget);

      // 5. Monthly Update Footer
      expect(find.text('Updated monthly. Next update: Jul 1.'), findsOneWidget);
    });
  });
}
