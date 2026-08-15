class ShieldStatus {
  final bool isLockoutActive;
  final double reliabilityScore; // 0.0 to 1.0 (0% to 100%)
  final String alertMessage;

  const ShieldStatus({
    required this.isLockoutActive,
    required this.reliabilityScore,
    required this.alertMessage,
  });
}

class DailyReliabilityLog {
  final int mealsLogged;
  final bool wasProteinTargetMet;
  final bool wasWaterTargetMet;

  const DailyReliabilityLog({
    required this.mealsLogged,
    required this.wasProteinTargetMet,
    required this.wasWaterTargetMet,
  });
}

/// Pure-Dart Nutrition Reliability Score & Data Confidence Shield Engine per §P5-O spec
class DataConfidenceShield {
  static const double minimumReliabilityThreshold = 0.70; // 70% threshold

  const DataConfidenceShield();

  /// Calculates 7-Day Rolling Nutrition Reliability Score:
  /// Reliability % = (Logged Days (>=3 meals) * 40 + Protein Consistency * 30 + Hydration Logs * 30) / 100
  /// Target Lockout Threshold: If reliability < 70% (0.70), engages target lock
  ShieldStatus evaluateLoggingQuality({
    required List<DailyReliabilityLog> pastWeekLogs,
    required double weightPlateauWeeks,
  }) {
    int validLogDays = 0;
    double proteinComplianceSum = 0.0;
    double hydrationComplianceSum = 0.0;

    for (final log in pastWeekLogs) {
      if (log.mealsLogged >= 3) validLogDays++;
      if (log.wasProteinTargetMet) proteinComplianceSum += 1.0;
      if (log.wasWaterTargetMet) hydrationComplianceSum += 1.0;
    }

    final totalDays =
        pastWeekLogs.isEmpty ? 7.0 : pastWeekLogs.length.toDouble();
    final loggingRatio = (validLogDays / totalDays).clamp(0.0, 1.0);
    final proteinRatio = (proteinComplianceSum / totalDays).clamp(0.0, 1.0);
    final hydrationRatio = (hydrationComplianceSum / totalDays).clamp(0.0, 1.0);

    final reliabilityScore =
        (loggingRatio * 0.40) + (proteinRatio * 0.30) + (hydrationRatio * 0.30);

    if (reliabilityScore < minimumReliabilityThreshold) {
      final percentage = (reliabilityScore * 100.0).round();
      return ShieldStatus(
        isLockoutActive: true,
        reliabilityScore: double.parse(reliabilityScore.toStringAsFixed(2)),
        alertMessage:
            '⚠️ Your weight loss has plateaued, but your log reliability is only $percentage%. We cannot safely lower your calories without stable logging. Focus on logging all meals for 5 consecutive days to re-enable calorie adaptations.',
      );
    }

    return ShieldStatus(
      isLockoutActive: false,
      reliabilityScore: double.parse(reliabilityScore.toStringAsFixed(2)),
      alertMessage:
          'Data confidence high (${(reliabilityScore * 100).round()}%). Metabolic adaptation targets unlocked.',
    );
  }
}
