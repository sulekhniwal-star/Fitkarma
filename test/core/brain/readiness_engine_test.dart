import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';
import 'package:fitkarma/core/brain/decision_hierarchy.dart';
import 'package:fitkarma/core/brain/readiness_engine.dart';

void main() {
  group('ReadinessEngine & Decision Hierarchy Tests', () {
    const engine = ReadinessEngine();
    const hierarchy = DecisionHierarchy();
    const calculator = ReadinessScoreCalculator();
    const targetAdjuster = DailyTargetAdjuster();

    test('Basic tier computes readiness based on check-in only', () {
      const checkIn =
          MorningCheckIn(energyLevel: 8, muscleSoreness: 2, moodRating: 9);
      final result = engine.calculateReadiness(checkIn: checkIn);

      expect(result.tier, equals(ReadinessTier.basic));
      expect(result.score, greaterThanOrEqualTo(80));
    });

    test('Enhanced tier incorporates sleep hours sync', () {
      const checkIn =
          MorningCheckIn(energyLevel: 6, muscleSoreness: 4, moodRating: 6);
      final result =
          engine.calculateReadiness(checkIn: checkIn, sleepHours: 8.0);

      expect(result.tier, equals(ReadinessTier.enhanced));
    });

    test('Premium tier incorporates HRV ratio', () {
      const checkIn =
          MorningCheckIn(energyLevel: 8, muscleSoreness: 2, moodRating: 8);
      final result = engine.calculateReadiness(
        checkIn: checkIn,
        sleepHours: 8.0,
        hrvRatio: 1.1,
      );

      expect(result.tier, equals(ReadinessTier.premium));
      expect(result.confidenceLabel, contains('Very high confidence'));
    });

    test(
        'Decision Hierarchy enforces Safety Alarm priority over workout progression',
        () {
      final actions = hierarchy.resolveActions(
        readinessScore: 90,
        illnessAlarmTriggered: true,
      );

      expect(actions.length, equals(1));
      expect(actions.first.priority, equals(ActionPriority.medicalSafety));
      expect(actions.first.isMandatoryRest, isTrue);
    });

    test(
        'Decision Hierarchy resolves Rest Prescription for low readiness score',
        () {
      final actions = hierarchy.resolveActions(
        readinessScore: 40,
        illnessAlarmTriggered: false,
      );

      expect(
          actions.any((a) => a.priority == ActionPriority.recoveryPrescription),
          isTrue);
      expect(actions.first.isMandatoryRest, isTrue);
    });

    group('ReadinessScoreCalculator (§P2-A Pure Dart Score Formula)', () {
      test('Perfect inputs yield 100 score', () {
        final result = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 480, // 8h
          sorenessLevel: 1,
          stressLevel: 1,
        );

        expect(result.score, equals(100));
        expect(result.tier, equals(ReadinessTier.basic));
        expect(result.confidenceLabel, equals('Medium confidence'));
        expect(result.zone, equals(ReadinessZone.high));
        expect(
            result.displayString, equals('Readiness 100 · Medium confidence'));
      });

      test('Applies sleep duration penalty for <6h and cumulative for <5h', () {
        final result6h = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 330, // 5.5h (<6h)
          sorenessLevel: 1,
          stressLevel: 1,
        );
        expect(result6h.score, equals(90));

        final result4h = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 270, // 4.5h (<5h)
          sorenessLevel: 1,
          stressLevel: 1,
        );
        expect(result4h.score, equals(80)); // -10 for <6h, -10 for <5h
      });

      test(
          'Applies resting HR and HRV deviation penalties and sets Premium tier',
          () {
        final result = calculator.calculate(
          sleepQuality: 5,
          sleepDurationMin: 480,
          sorenessLevel: 1,
          stressLevel: 1,
          restingHR: 75,
          baselineHR: 60, // +25% delta (>0.2) -> -15 pts
          hrv: 30,
          baselineHRV: 50, // -40% delta (>0.15) -> -10 pts
        );

        expect(result.score, equals(75));
        expect(result.tier, equals(ReadinessTier.premium));
        expect(result.zone, equals(ReadinessZone.moderate));
        expect(result.adviceSummary, contains('Normal intensity'));
      });
    });

    group('DailyTargetAdjuster (§P2-A Target Adjustments)', () {
      const baseTargets = UserTargets(
        calories: 2000,
        hydrationL: 2.5,
        protein: 140,
      );

      test('High readiness (>=80) keeps full intensity and adds +10g protein',
          () {
        final adjusted = targetAdjuster.adjust(85, baseTargets);
        expect(adjusted.workoutIntensityFactor, equals(1.0));
        expect(adjusted.calorieTarget, equals(2000));
        expect(adjusted.proteinTarget, equals(150));
        expect(adjusted.hydrationL, equals(2.5));
      });

      test(
          'Moderate readiness (65-79) applies slight intensity reduction (0.85)',
          () {
        final adjusted = targetAdjuster.adjust(70, baseTargets);
        expect(adjusted.workoutIntensityFactor, equals(0.85));
        expect(adjusted.calorieTarget, equals(2015)); // 2000 + 100 * 0.15
        expect(adjusted.proteinTarget, equals(150));
      });

      test('Low readiness (50-64) applies 0.70 factor and extra hydration', () {
        final adjusted = targetAdjuster.adjust(55, baseTargets);
        expect(adjusted.workoutIntensityFactor, equals(0.70));
        expect(adjusted.calorieTarget, equals(2030)); // 2000 + 100 * 0.30
        expect(adjusted.hydrationL, equals(2.8)); // +0.3L
        expect(adjusted.proteinTarget, equals(140));
      });

      test(
          'Critical readiness (<50) sets rest day factor 0.0 with recovery calories',
          () {
        final adjusted = targetAdjuster.adjust(40, baseTargets);
        expect(adjusted.workoutIntensityFactor, equals(0.0));
        expect(adjusted.calorieTarget, equals(2200)); // +200 for recovery
        expect(adjusted.hydrationL, equals(2.8));
      });
    });
  });
}
