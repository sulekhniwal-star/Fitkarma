import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/bio_age_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/bio_age_models.dart';

void main() {
  group('BiologicalAgeEngine Tests', () {
    const engine = BiologicalAgeEngine();

    test('Computes rejuvenating biological age for optimal biometric inputs', () {
      final report = engine.estimateBiologicalAge(
        chronologicalAge: 32.0,
        restingHeartRate: 52.0,
        rmssdHeartRateVariability: 68.0,
        systolicBloodPressure: 112.0,
        diastolicBloodPressure: 72.0,
        waistToHeightRatio: 0.42,
        fastingGlucoseMgDl: 84.0,
        estimatedHbA1c: 5.0,
        estimatedVo2Max: 48.0,
        dailyStepsAverage: 12500.0,
        weeklyStrengthSessions: 4,
        deepSleepPercentage: 23.0,
        weeklySleepDebtHours: 0.5,
        antiInflammatoryDietScore: 90.0,
      );

      expect(report.biologicalAge, lessThan(32.0));
      expect(report.ageDelta, lessThan(0.0));
      expect(report.agingPace, lessThan(1.0));
      expect(report.paceStatus, equals(AgingPaceStatus.rejuvenating));
      expect(report.systemAges.length, equals(4));
      expect(report.biomarkerContributions.length, equals(9));
      expect(report.trajectory12Months.length, equals(12));
    });

    test('Computes accelerated biological age for compromised metabolic markers', () {
      final report = engine.estimateBiologicalAge(
        chronologicalAge: 40.0,
        restingHeartRate: 84.0,
        rmssdHeartRateVariability: 22.0,
        systolicBloodPressure: 142.0,
        diastolicBloodPressure: 92.0,
        waistToHeightRatio: 0.56,
        fastingGlucoseMgDl: 128.0,
        estimatedHbA1c: 6.6,
        estimatedVo2Max: 28.0,
        dailyStepsAverage: 3500.0,
        weeklyStrengthSessions: 0,
        deepSleepPercentage: 9.0,
        weeklySleepDebtHours: 6.5,
        antiInflammatoryDietScore: 30.0,
      );

      expect(report.biologicalAge, greaterThan(40.0));
      expect(report.ageDelta, greaterThan(0.0));
      expect(report.agingPace, greaterThan(1.0));
      expect(report.paceStatus, equals(AgingPaceStatus.accelerated));
      expect(report.topRejuvenationLevers.isNotEmpty, isTrue);
    });

    test('Generates complete 12-month trailing trajectory', () {
      final report = engine.estimateBiologicalAge(
        chronologicalAge: 28.0,
        restingHeartRate: 60.0,
        rmssdHeartRateVariability: 50.0,
        systolicBloodPressure: 118.0,
        diastolicBloodPressure: 76.0,
        waistToHeightRatio: 0.46,
        fastingGlucoseMgDl: 90.0,
        estimatedHbA1c: 5.3,
        estimatedVo2Max: 43.0,
        dailyStepsAverage: 9000.0,
        weeklyStrengthSessions: 3,
        deepSleepPercentage: 19.0,
        weeklySleepDebtHours: 1.5,
        antiInflammatoryDietScore: 80.0,
      );

      expect(report.trajectory12Months.length, equals(12));
      for (final snapshot in report.trajectory12Months) {
        expect(snapshot.biologicalAge, isPositive);
        expect(snapshot.chronologicalAge, isPositive);
        expect(snapshot.agingPace, isPositive);
      }
    });
  });
}
