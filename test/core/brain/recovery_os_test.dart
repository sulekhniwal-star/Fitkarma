import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/recovery_os.dart';

void main() {
  group('§P2-D Recovery Operating System Tests', () {
    test(
        'SleepNeedCalculator incorporates sleep debt, strain, stress, and illness additives with 600m cap',
        () {
      const calculator = SleepNeedCalculator();

      // Normal baseline
      final normal = calculator.calculate();
      expect(normal.totalSleepNeedMin, equals(480)); // 8h
      expect(normal.totalSleepNeedHours, equals(8.0));

      // With debt + heavy strain + high stress + illness
      final heavy = calculator.calculate(
        baselineNeedMin: 480,
        accumulatedSleepDebtMin: 60,
        yesterdayStrain: 17.5, // >16 -> +60 mins
        stressScore: 4, // -> +22.5 -> 23 mins
        isIllnessActive: true, // +60 mins
      );

      expect(heavy.sleepDebtAdditiveMin, equals(60));
      expect(heavy.strainAdditiveMin, equals(60));
      expect(heavy.illnessAdditiveMin, equals(60));
      expect(heavy.totalSleepNeedMin, equals(600)); // Hard capped at 600 min
    });

    test('BedtimeCoach calculates target bedtime with 15min wind-down buffer',
        () {
      const coach = BedtimeCoach();
      final wakeTime = DateTime(2026, 8, 1, 6, 30); // 6:30 AM
      final result = coach.calculateBedtime(
        sleepNeedMin: 502, // 8h 22m
        targetWakeTime: wakeTime,
      );

      // Bedtime = 6:30 AM - 502m - 15m (517m = 8h 37m) -> 9:53 PM previous night
      expect(result.targetBedtime.hour, equals(21));
      expect(result.nudgeMessage, contains('Bedtime Coach'));
    });

    test('RecoveryDecisionEngine calculates capacity score and strain cap', () {
      const engine = RecoveryDecisionEngine();
      final decision = engine.evaluate(
        readinessScore: 85,
        dailyStrain: 10.0,
        sleepDebtHours: 0.5,
      );

      expect(decision.capacityScore, equals(80));
      expect(decision.strainCap, greaterThanOrEqualTo(14.0));
      expect(decision.trainingAdvice, contains('High Capacity'));
    });

    test('RecoveryPrescriptionEngine generates checklist based on readiness',
        () {
      const engine = RecoveryPrescriptionEngine();

      final lowPrescription = engine.generatePrescription(
        readinessScore: 45,
        capacityScore: 40,
        isIllnessActive: false,
      );
      expect(lowPrescription.any((p) => p.title == 'Active Recovery'), isTrue);
      expect(lowPrescription.any((p) => p.title == 'Training Restriction'),
          isTrue);

      final highPrescription = engine.generatePrescription(
        readinessScore: 85,
        capacityScore: 85,
        isIllnessActive: false,
      );
      expect(highPrescription.any((p) => p.title == 'Full Training'), isTrue);
    });

    test(
        'CircadianScoreEngine applies midpoint shift penalty and morning light bonus',
        () {
      const engine = CircadianScoreEngine();

      final scoreNormal = engine.calculateCircadianScore(
        midpointShiftMinutes: 15.0,
        morningLightLogged: true,
      );
      expect(scoreNormal, equals(100.0));

      final scoreShifted = engine.calculateCircadianScore(
        midpointShiftMinutes: 80.0, // excess 20m -> -10 pts
        morningLightLogged: false,
      );
      expect(scoreShifted, equals(90.0));
    });

    test('IllnessRecoveryDetector identifies illness fatigue vs sleep fatigue',
        () {
      const detector = IllnessRecoveryDetector();

      final illness = detector.detect(
        currentRhr: 72,
        baselineRhr: 60, // +12 bpm
        currentHrv: 35,
        baselineHrv: 60, // <70%
        sleepDebtHours: 0.0,
        dailyStrain: 5.0,
        stressScore: 2,
      );
      expect(illness.type, equals(FatigueType.illnessFatigue));
      expect(illness.isIllnessDetected, isTrue);

      final sleepFatigue = detector.detect(
        currentRhr: 60,
        baselineRhr: 60,
        currentHrv: 60,
        baselineHrv: 60,
        sleepDebtHours: 2.0,
        dailyStrain: 8.0,
        stressScore: 2,
      );
      expect(sleepFatigue.type, equals(FatigueType.sleepFatigue));
    });

    test('RecoveryDriversEngine breaks down contributors and detractors', () {
      const engine = RecoveryDriversEngine();
      final result = engine.calculateDrivers(
        sleepQuality: 5,
        proteinG: 120,
        hydrationL: 3.0,
        stressScore: 4,
        aqi: 220,
        heatIndexC: 38.0,
      );

      expect(result.contributors.length, equals(3));
      expect(result.detractors.length, equals(3));
    });

    test('RecoveryForecastingEngine calculates recovery age and 5-day forecast',
        () {
      const engine = RecoveryForecastingEngine();
      final ageResult = engine.calculateRecoveryAge(
        chronologicalAge: 34,
        avgHrv: 75.0,
        restingHr: 52.0,
        sleepEfficiencyRatio: 0.92,
      );

      expect(ageResult.recoveryAge, lessThan(34));

      final forecast = engine.generate5DayForecast(
        currentReadiness: 85,
        sleepDebtHours: 0.0,
        avgStrain: 8.0,
      );
      expect(forecast.length, equals(5));
    });
  });
}
