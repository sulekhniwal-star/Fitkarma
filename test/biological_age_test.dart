import 'package:fitkarma/features/predictive/biological_age_estimator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const estimator = BiologicalAgeEstimator();
  final now = DateTime.now();

  group('§P10-B BiologicalAgeEstimator Unit Tests', () {
    test('WHO baseline parameters result in biological age matching chronological age', () {
      final snapshot = UserMonthlyHealthSnapshot(
        chronologicalAge: 30,
        restingHrBpm: 65.0,
        hrvMs: 50.0,
        sleepHoursAvg: 7.5,
        bmi: 22.5,
        dailyStepsAvg: 8000,
        fastingGlucoseMgDl: 90.0,
        calculationDate: now,
      );

      final result = estimator.estimate(snapshot);

      expect(result.chronologicalAge, 30);
      expect(result.estimatedBiologicalAge, 30);
      expect(result.ageDeltaYears, 0.0);
    });

    test('Athletic parameters yield younger biological age', () {
      final snapshot = UserMonthlyHealthSnapshot(
        chronologicalAge: 32,
        restingHrBpm: 54.0, // -1.65 yrs
        hrvMs: 70.0, // -2.00 yrs
        sleepHoursAvg: 8.0, // -0.40 yrs
        bmi: 21.5, // -0.40 yrs
        dailyStepsAvg: 12000, // -1.40 yrs
        fastingGlucoseMgDl: 82.0, // -0.96 yrs
        calculationDate: now,
      );

      final result = estimator.estimate(snapshot);

      expect(result.chronologicalAge, 32);
      expect(result.estimatedBiologicalAge, lessThan(32));
      expect(result.isYoungerThanChronological, true);
      expect(result.primaryDrivers, isNotEmpty);
    });

    test('Sedentary parameters yield older biological age', () {
      final snapshot = UserMonthlyHealthSnapshot(
        chronologicalAge: 40,
        restingHrBpm: 78.0, // +1.95 yrs
        hrvMs: 32.0, // +1.80 yrs
        sleepHoursAvg: 5.8, // +1.36 yrs
        bmi: 27.5, // +2.00 yrs
        dailyStepsAvg: 3500, // +1.57 yrs
        fastingGlucoseMgDl: 105.0, // +1.80 yrs
        calculationDate: now,
      );

      final result = estimator.estimate(snapshot);

      expect(result.chronologicalAge, 40);
      expect(result.estimatedBiologicalAge, greaterThan(40));
      expect(result.isYoungerThanChronological, false);
    });

    test('Clamps extreme delta within bounds [-10.0, +15.0] years', () {
      final extremeUnhealthy = UserMonthlyHealthSnapshot(
        chronologicalAge: 50,
        restingHrBpm: 105.0,
        hrvMs: 15.0,
        sleepHoursAvg: 4.0,
        bmi: 38.0,
        dailyStepsAvg: 1000,
        fastingGlucoseMgDl: 160.0,
        calculationDate: now,
      );

      final result = estimator.estimate(extremeUnhealthy);

      expect(result.ageDeltaYears, 15.0); // Clamped at +15.0
      expect(result.estimatedBiologicalAge, 65);
    });
  });
}
