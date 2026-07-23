import 'package:fitkarma/core/brain/readiness_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ReadinessScoreCalculator calculator;

  setUp(() {
    calculator = ReadinessScoreCalculator();
  });

  group('Readiness Engine Confidence Tiers', () {
    test('Basic tier: only morning check-in inputs, no HR or HRV', () {
      final result = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
      );

      expect(result.tier, ConfidenceTier.basic);
      expect(result.confidence, 'Medium');
      expect(result.score, 100);
    });

    test('Enhanced tier: basic inputs + resting HR (no HRV)', () {
      final result = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
        restingHR: 65,
        baselineHR: 65,
      );

      expect(result.tier, ConfidenceTier.enhanced);
      expect(result.confidence, 'High');
      expect(result.score, 100);
    });

    test('Premium tier: basic inputs + resting HR + HRV', () {
      final result = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
        restingHR: 65,
        baselineHR: 65,
        hrv: 55,
        baselineHRV: 55,
      );

      expect(result.tier, ConfidenceTier.premium);
      expect(result.confidence, 'Very High');
      expect(result.score, 100);
    });
  });

  group('Readiness Score Arithmetic Calculations', () {
    test('Perfect check-in metrics result in 100 score', () {
      final result = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
      );
      expect(result.score, 100);
    });

    test('Sleep quality deductions (7 points per unit under 5)', () {
      final result = calculator.calculate(
        sleepQuality: 3, // 5 - 3 = 2 units => -14
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
      );
      expect(result.score, 86);
    });

    test('Sleep duration deductions (< 6h -> -10, < 5h -> -20)', () {
      final resultUnder6h = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 350, // < 360, but >= 300 => -10
        sorenessLevel: 1,
        stressLevel: 1,
      );
      expect(resultUnder6h.score, 90);

      final resultUnder5h = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 290, // < 300 => -20
        sorenessLevel: 1,
        stressLevel: 1,
      );
      expect(resultUnder5h.score, 80);
    });

    test('Soreness level deductions (5 points per unit above 1)', () {
      final result = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 3, // 3 - 1 = 2 units => -10
        stressLevel: 1,
      );
      expect(result.score, 90);
    });

    test('Stress level deductions (5 points per unit above 1)', () {
      final result = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 4, // 4 - 1 = 3 units => -15
      );
      expect(result.score, 85);
    });

    test(
      'Resting HR deviation deductions (delta > 0.1 -> -10, > 0.2 -> -15)',
      () {
        // Delta = (77 - 70) / 70 = 0.10 => no reduction (since not > 0.1)
        final resultNoReduction = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 480,
          sorenessLevel: 1,
          stressLevel: 1,
          restingHR: 77,
          baselineHR: 70,
        );
        expect(resultNoReduction.score, 100);

        // Delta = (78 - 70) / 70 = 0.114 => > 0.1 -> -10
        final resultModerateElevation = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 480,
          sorenessLevel: 1,
          stressLevel: 1,
          restingHR: 78,
          baselineHR: 70,
        );
        expect(resultModerateElevation.score, 90);

        // Delta = (85 - 70) / 70 = 0.214 => > 0.2 -> -15 (both >0.1 and >0.2 conditions met: -10 and -5)
        final resultHighElevation = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 480,
          sorenessLevel: 1,
          stressLevel: 1,
          restingHR: 85,
          baselineHR: 70,
        );
        expect(resultHighElevation.score, 85);
      },
    );

    test('HRV deviation deductions (delta > 0.15 -> -10)', () {
      // Delta = (50 - 45) / 50 = 0.10 => no reduction
      final resultNoReduction = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
        hrv: 45,
        baselineHRV: 50,
      );
      expect(resultNoReduction.score, 100);

      // Delta = (50 - 40) / 50 = 0.20 => > 0.15 -> -10
      final resultReduction = calculator.calculate(
        sleepQuality: 5,
        sleepDurationMin: 480,
        sorenessLevel: 1,
        stressLevel: 1,
        hrv: 40,
        baselineHRV: 50,
      );
      expect(resultReduction.score, 90);
    });

    test('Score is clamped to [0, 100]', () {
      final resultMiserable = calculator.calculate(
        sleepQuality: 1, // -28
        sleepDurationMin: 120, // -20
        sorenessLevel: 5, // -20
        stressLevel: 5, // -20
        restingHR: 100, // -15
        baselineHR: 70,
        hrv: 20, // -10
        baselineHRV: 50,
      ); // Total subtraction = 113. Clamped score should be 0.
      expect(resultMiserable.score, 0);
    });
  });
}
