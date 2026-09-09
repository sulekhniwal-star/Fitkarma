import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/health_risk_engine.dart';
import '../../domain/health_risk_models.dart';

final healthRiskProvider =
    StateNotifierProvider<HealthRiskNotifier, HealthRiskPreventionReport>((ref) {
  return HealthRiskNotifier();
});

class HealthRiskNotifier extends StateNotifier<HealthRiskPreventionReport> {
  HealthRiskNotifier() : super(_buildInitialReport());

  static HealthRiskPreventionReport _buildInitialReport() {
    return HealthRiskEngine.evaluateRiskProfile(
      age: 29,
      biologicalSex: 'Male',
      bodyweightKg: 72.8,
      waistCircumferenceCm: 81.5,
      heightCm: 174.0,
      systolicBp: 120,
      diastolicBp: 78,
      estimatedFastingGlucoseMgDl: 94.0,
      restingHeartRateBpm: 61.0,
      dailySteps: 10450,
      completedShatpawaliPercent: true,
      relativeStrengthXBW: 1.53,
      proteinGramsPerKg: 1.35,
      hasFamilyHistoryDiabetes: true,
    );
  }

  void refreshWithBiometrics({
    required double waistCm,
    required int systolic,
    required int diastolic,
    required double fastingGlucose,
    required double rhr,
    required int steps,
    required bool shatpawali,
  }) {
    state = HealthRiskEngine.evaluateRiskProfile(
      age: 29,
      biologicalSex: 'Male',
      bodyweightKg: 72.8,
      waistCircumferenceCm: waistCm,
      heightCm: 174.0,
      systolicBp: systolic,
      diastolicBp: diastolic,
      estimatedFastingGlucoseMgDl: fastingGlucose,
      restingHeartRateBpm: rhr,
      dailySteps: steps,
      completedShatpawaliPercent: shatpawali,
      relativeStrengthXBW: 1.53,
      proteinGramsPerKg: 1.35,
      hasFamilyHistoryDiabetes: true,
    );
  }
}
