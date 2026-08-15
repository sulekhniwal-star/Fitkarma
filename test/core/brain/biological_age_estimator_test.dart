import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/biological_age_estimator.dart';

void main() {
  group('§P10-B Biological Age Estimator Tests', () {
    const estimator = BiologicalAgeEstimator();

    test('estimate computes younger biological age for optimal health inputs',
        () {
      const inputs = BiologicalAgeInputs(
        chronologicalAge: 32,
        restingHeartRateBpm: 56.0,
        hrvMs: 70.0,
        sleepQualityScore: 85.0,
        bmi: 22.5,
        monthlyAverageDailySteps: 10200,
        fastingGlucoseMgDl: 88.0,
      );

      final result = estimator.estimate(inputs);

      expect(result.chronologicalAge, equals(32));
      expect(result.biologicalAge, lessThan(32.0));
      expect(result.ageDeltaYears, lessThan(0.0));
      expect(result.positiveContributors, contains('High HRV (≥65 ms)'));
      expect(result.positiveContributors,
          contains('Low Resting Heart Rate (<60 bpm)'));
    });

    test('estimate computes older biological age for sub-optimal inputs', () {
      const inputs = BiologicalAgeInputs(
        chronologicalAge: 40,
        restingHeartRateBpm: 78.0,
        hrvMs: 35.0,
        sleepQualityScore: 55.0,
        bmi: 28.5,
        monthlyAverageDailySteps: 4200,
        fastingGlucoseMgDl: 110.0,
      );

      final result = estimator.estimate(inputs);

      expect(result.chronologicalAge, equals(40));
      expect(result.biologicalAge, greaterThan(40.0));
      expect(result.ageDeltaYears, greaterThan(0.0));
      expect(result.riskFactors,
          contains('Elevated Resting Heart Rate (>75 bpm)'));
      expect(result.riskFactors, contains('Elevated BMI (≥27.0)'));
    });
  });
}
