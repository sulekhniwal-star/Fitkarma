import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/longevity_score_calculator.dart';
import 'package:fitkarma/features/predictive_health/screens/longevity_screen.dart';

void main() {
  group('§P10-G Longevity Score & Biological Age Tests', () {
    const calculator = LongevityScoreCalculator();

    test('calculate computes high Longevity Score and younger biological age for optimal inputs', () {
      const inputs = LongevityInputData(
        age: 28,
        gender: 'male',
        estimatedVO2Max: 48.0,
        bodyFatPct: 15.0,
        avgSleepH: 8.0,
        sleepQuality7dAvg: 4.5,
        avgSteps7d: 10000,
        workoutsPerWeek: 5,
        restingHR: 58.0,
        hrv: 72.0,
        baselineHRV: 65.0,
        hasClinicalData: true,
      );

      final result = calculator.calculate(inputs);

      expect(result.longevityScore, greaterThanOrEqualTo(80));
      expect(result.biologicalAge, lessThan(28));
      expect(result.ageDelta, greaterThan(0));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('LongevityScreen renders Longevity score, factor breakdown, and biggest opportunity', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LongevityScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🌱 Longevity Score'), findsOneWidget);
      expect(find.textContaining('Longevity Score:'), findsOneWidget);
      expect(find.text('Biological Age'), findsOneWidget);
      expect(find.text('Chronological Age'), findsOneWidget);
      expect(find.text('Factor Breakdown'), findsOneWidget);
      expect(find.textContaining('❤️ Cardio (HRV/HR)'), findsOneWidget);
      expect(find.text('Biggest Opportunity'), findsOneWidget);
    });
  });
}
