import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/bio_age_engine.dart';
import '../../domain/bio_age_models.dart';

final biologicalAgeProvider =
    StateNotifierProvider<BiologicalAgeNotifier, BiologicalAgeReport>((ref) {
  return BiologicalAgeNotifier();
});

class BiologicalAgeNotifier extends StateNotifier<BiologicalAgeReport> {
  BiologicalAgeNotifier() : super(_buildInitialReport());

  static final BiologicalAgeEngine _engine = const BiologicalAgeEngine();

  static BiologicalAgeReport _buildInitialReport() {
    return _engine.estimateBiologicalAge(
      chronologicalAge: 31.5,
      restingHeartRate: 59.0,
      rmssdHeartRateVariability: 54.0,
      systolicBloodPressure: 116.0,
      diastolicBloodPressure: 74.0,
      waistToHeightRatio: 0.46,
      fastingGlucoseMgDl: 89.0,
      estimatedHbA1c: 5.2,
      estimatedVo2Max: 44.5,
      dailyStepsAverage: 10850.0,
      weeklyStrengthSessions: 3,
      deepSleepPercentage: 20.5,
      weeklySleepDebtHours: 0.9,
      antiInflammatoryDietScore: 84.0,
    );
  }

  void recalculateWithCustomBiometrics({
    required double chronologicalAge,
    required double restingHeartRate,
    required double rmssdHeartRateVariability,
    required double systolicBloodPressure,
    required double diastolicBloodPressure,
    required double waistToHeightRatio,
    required double fastingGlucoseMgDl,
    required double estimatedHbA1c,
    required double estimatedVo2Max,
    required double dailyStepsAverage,
    required int weeklyStrengthSessions,
    required double deepSleepPercentage,
    required double weeklySleepDebtHours,
    required double antiInflammatoryDietScore,
  }) {
    state = _engine.estimateBiologicalAge(
      chronologicalAge: chronologicalAge,
      restingHeartRate: restingHeartRate,
      rmssdHeartRateVariability: rmssdHeartRateVariability,
      systolicBloodPressure: systolicBloodPressure,
      diastolicBloodPressure: diastolicBloodPressure,
      waistToHeightRatio: waistToHeightRatio,
      fastingGlucoseMgDl: fastingGlucoseMgDl,
      estimatedHbA1c: estimatedHbA1c,
      estimatedVo2Max: estimatedVo2Max,
      dailyStepsAverage: dailyStepsAverage,
      weeklyStrengthSessions: weeklyStrengthSessions,
      deepSleepPercentage: deepSleepPercentage,
      weeklySleepDebtHours: weeklySleepDebtHours,
      antiInflammatoryDietScore: antiInflammatoryDietScore,
    );
  }
}
