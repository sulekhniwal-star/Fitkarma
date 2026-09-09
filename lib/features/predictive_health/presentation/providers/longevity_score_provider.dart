import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/longevity_score_engine.dart';
import '../../domain/longevity_score_models.dart';

final longevityScoreProvider =
    StateNotifierProvider<LongevityScoreNotifier, LongevityReport>((ref) {
  return LongevityScoreNotifier();
});

class LongevityScoreNotifier extends StateNotifier<LongevityReport> {
  LongevityScoreNotifier() : super(_buildInitialReport());

  static final LongevityScoreEngine _engine = const LongevityScoreEngine();

  static LongevityReport _buildInitialReport() {
    return _engine.calculateLongevityScore(
      chronologicalAge: 32.0,
      biologicalAge: 28.5,
      restingHeartRate: 59.0,
      systolicBloodPressure: 116.0,
      diastolicBloodPressure: 74.0,
      rmssdHeartRateVariability: 54.0,
      waistToHeightRatio: 0.46,
      fastingGlucoseMgDl: 89.0,
      estimatedHbA1c: 5.2,
      estimatedVo2Max: 44.5,
      dailyStepsAverage: 10850.0,
      weeklyStrengthSessions: 3,
      deepSleepPercentage: 20.5,
      weeklySleepDebtHours: 0.8,
      antiInflammatoryDietScore: 86.0,
      dailyProteinGramsPerKg: 1.42,
      shatpawaliAdherencePercent: 88.0,
      averageStressScore: 22.0,
    );
  }

  void recalculateWithBiometrics({
    required double chronologicalAge,
    required double biologicalAge,
    required double restingHeartRate,
    required double systolicBloodPressure,
    required double diastolicBloodPressure,
    required double rmssdHeartRateVariability,
    required double waistToHeightRatio,
    required double fastingGlucoseMgDl,
    required double estimatedHbA1c,
    required double estimatedVo2Max,
    required double dailyStepsAverage,
    required int weeklyStrengthSessions,
    required double deepSleepPercentage,
    required double weeklySleepDebtHours,
    required double antiInflammatoryDietScore,
    required double dailyProteinGramsPerKg,
    required double shatpawaliAdherencePercent,
    required double averageStressScore,
  }) {
    state = _engine.calculateLongevityScore(
      chronologicalAge: chronologicalAge,
      biologicalAge: biologicalAge,
      restingHeartRate: restingHeartRate,
      systolicBloodPressure: systolicBloodPressure,
      diastolicBloodPressure: diastolicBloodPressure,
      rmssdHeartRateVariability: rmssdHeartRateVariability,
      waistToHeightRatio: waistToHeightRatio,
      fastingGlucoseMgDl: fastingGlucoseMgDl,
      estimatedHbA1c: estimatedHbA1c,
      estimatedVo2Max: estimatedVo2Max,
      dailyStepsAverage: dailyStepsAverage,
      weeklyStrengthSessions: weeklyStrengthSessions,
      deepSleepPercentage: deepSleepPercentage,
      weeklySleepDebtHours: weeklySleepDebtHours,
      antiInflammatoryDietScore: antiInflammatoryDietScore,
      dailyProteinGramsPerKg: dailyProteinGramsPerKg,
      shatpawaliAdherencePercent: shatpawaliAdherencePercent,
      averageStressScore: averageStressScore,
    );
  }
}
