import 'family_models.dart';

/// Pure Dart Deterministic Engine for Intergenerational Family Care,
/// Household Health Scores, and Senior Vitals Risk Classification.
class FamilyHealthEngine {
  const FamilyHealthEngine._();

  /// Evaluates Family Member Vitals & Activity Status
  static FamilyVitalsStatus evaluateMemberStatus({
    required int todaySteps,
    required int dailyTarget,
    required bool completedShatpawali,
    int? systolicBp,
    int? diastolicBp,
    double? fastingGlucose,
  }) {
    // Check critical BP alert thresholds
    if (systolicBp != null && diastolicBp != null) {
      if (systolicBp >= 140 || diastolicBp >= 90) {
        return FamilyVitalsStatus.alert;
      }
    }

    // Check glucose alert
    if (fastingGlucose != null && fastingGlucose >= 130.0) {
      return FamilyVitalsStatus.alert;
    }

    // Check evening activity / Shatpawali attention
    if (!completedShatpawali && todaySteps < (dailyTarget * 0.60)) {
      return FamilyVitalsStatus.attention;
    }

    return FamilyVitalsStatus.optimal;
  }

  /// Calculates Household Family Health Score (0.0 to 100.0)
  static double calculateHouseholdHealthScore(
      List<FamilyMemberProfile> members) {
    if (members.isEmpty) return 100.0;

    double stepSum = 0.0;
    double shatpawaliSum = 0.0;
    double vitalsSum = 0.0;

    for (final m in members) {
      // Step fraction (max 100)
      final stepFrac =
          (m.todaySteps / (m.dailyStepTarget == 0 ? 1 : m.dailyStepTarget))
                  .clamp(0.0, 1.0) *
              100.0;
      stepSum += stepFrac;

      // Shatpawali completion
      shatpawaliSum += m.completedShatpawaliToday ? 100.0 : (stepFrac * 0.5);

      // Vitals score
      if (m.status == FamilyVitalsStatus.optimal) {
        vitalsSum += 100.0;
      } else if (m.status == FamilyVitalsStatus.attention) {
        vitalsSum += 70.0;
      } else {
        vitalsSum += 40.0;
      }
    }

    final avgSteps = stepSum / members.length;
    final avgShatpawali = shatpawaliSum / members.length;
    final avgVitals = vitalsSum / members.length;

    final composite =
        (avgSteps * 0.35) + (avgShatpawali * 0.30) + (avgVitals * 0.35);
    return composite.clamp(10.0, 100.0);
  }

  /// Total steps walked today across all family members
  static int calculateTotalFamilySteps(List<FamilyMemberProfile> members) {
    return members.fold<int>(0, (sum, m) => sum + m.todaySteps);
  }
}
