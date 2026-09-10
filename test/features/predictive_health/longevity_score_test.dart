import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/predictive_health/domain/longevity_score_engine.dart';
import 'package:fitkarma/features/predictive_health/domain/longevity_score_models.dart';

void main() {
  group('LongevityScoreEngine Tests', () {
    const engine = LongevityScoreEngine();

    test('Computes centenarian trajectory for optimal longevity biometrics',
        () {
      final report = engine.calculateLongevityScore(
        chronologicalAge: 32.0,
        biologicalAge: 27.5,
        restingHeartRate: 54.0,
        systolicBloodPressure: 112.0,
        diastolicBloodPressure: 72.0,
        rmssdHeartRateVariability: 65.0,
        waistToHeightRatio: 0.43,
        fastingGlucoseMgDl: 85.0,
        estimatedHbA1c: 5.0,
        estimatedVo2Max: 48.0,
        dailyStepsAverage: 12000.0,
        weeklyStrengthSessions: 4,
        deepSleepPercentage: 22.5,
        weeklySleepDebtHours: 0.4,
        antiInflammatoryDietScore: 92.0,
        dailyProteinGramsPerKg: 1.5,
        shatpawaliAdherencePercent: 95.0,
        averageStressScore: 18.0,
      );

      expect(report.compositeScore, greaterThanOrEqualTo(90.0));
      expect(report.tier, equals(LongevityTier.centenarian));
      expect(report.projectedHealthspanAge, greaterThan(78.0));
      expect(report.healthspanBonusYears, greaterThan(5.0));
      expect(report.pillarScores.length, equals(6));
      expect(report.topAccelerators.isNotEmpty, isTrue);
    });

    test('Computes compromised tier when multi-pillar risk factors compound',
        () {
      final report = engine.calculateLongevityScore(
        chronologicalAge: 45.0,
        biologicalAge: 52.0,
        restingHeartRate: 82.0,
        systolicBloodPressure: 142.0,
        diastolicBloodPressure: 92.0,
        rmssdHeartRateVariability: 24.0,
        waistToHeightRatio: 0.58,
        fastingGlucoseMgDl: 126.0,
        estimatedHbA1c: 6.8,
        estimatedVo2Max: 26.0,
        dailyStepsAverage: 3800.0,
        weeklyStrengthSessions: 0,
        deepSleepPercentage: 8.5,
        weeklySleepDebtHours: 6.0,
        antiInflammatoryDietScore: 35.0,
        dailyProteinGramsPerKg: 0.7,
        shatpawaliAdherencePercent: 20.0,
        averageStressScore: 78.0,
      );

      expect(report.compositeScore, lessThan(55.0));
      expect(report.tier, equals(LongevityTier.compromised));
      expect(report.healthspanBonusYears, lessThan(0.0));
    });
  });
}
