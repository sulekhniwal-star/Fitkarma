import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/deepened_longevity_engine.dart';
import '../../domain/deepened_longevity_models.dart';

final deepenedLongevityProvider =
    StateNotifierProvider<DeepenedLongevityNotifier, DeepenedLongevityReport>((ref) {
  return DeepenedLongevityNotifier();
});

class DeepenedLongevityNotifier extends StateNotifier<DeepenedLongevityReport> {
  DeepenedLongevityNotifier() : super(_buildInitialReport());

  static const DeepenedLongevityEngine _engine = DeepenedLongevityEngine();

  static DeepenedLongevityReport _buildInitialReport() {
    return _engine.synthesizeDeepenedLongevity(
      chronologicalAge: 32.0,
      restingHeartRate: 58.0,
      hrvRmssd: 58.0,
      vo2MaxEstimate: 45.2,
      fastingGlucose: 88.0,
      systolicBp: 116.0,
      diastolicBp: 74.0,
      dailySteps: 11200.0,
      deepSleepMinutes: 92.0,
      skeletalMuscleMassKg: 34.5,
      hsCrpMgL: 0.8,
      triglycerideHdlRatio: 1.8,
      hasElevatedLpA: false,
      visceralFatIndex: 5.5,
    );
  }

  void recalculate({
    required double chronologicalAge,
    required double restingHeartRate,
    required double hrvRmssd,
    required double vo2MaxEstimate,
    required double fastingGlucose,
    required double systolicBp,
    required double diastolicBp,
    required double dailySteps,
    required double deepSleepMinutes,
    required double skeletalMuscleMassKg,
    double? hsCrpMgL,
    double? triglycerideHdlRatio,
    bool hasElevatedLpA = false,
    double? visceralFatIndex,
  }) {
    state = _engine.synthesizeDeepenedLongevity(
      chronologicalAge: chronologicalAge,
      restingHeartRate: restingHeartRate,
      hrvRmssd: hrvRmssd,
      vo2MaxEstimate: vo2MaxEstimate,
      fastingGlucose: fastingGlucose,
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      dailySteps: dailySteps,
      deepSleepMinutes: deepSleepMinutes,
      skeletalMuscleMassKg: skeletalMuscleMassKg,
      hsCrpMgL: hsCrpMgL,
      triglycerideHdlRatio: triglycerideHdlRatio,
      hasElevatedLpA: hasElevatedLpA,
      visceralFatIndex: visceralFatIndex,
    );
  }
}
