/// Adaptive Metabolism Engine Result
class AdaptiveMetabolismResult {
  final double dynamicTdee;
  final double weightTrendKg;
  final String metabolicAdaptationState;

  const AdaptiveMetabolismResult({
    required this.dynamicTdee,
    required this.weightTrendKg,
    required this.metabolicAdaptationState,
  });
}

/// Longevity Score Result (0 to 100)
class LongevityScoreResult {
  final int longevityScore;
  final String primaryDriver;

  const LongevityScoreResult({
    required this.longevityScore,
    required this.primaryDriver,
  });
}

/// Adaptive Metabolism & Longevity Score Engine
class AdaptiveMetabolismEngine {
  const AdaptiveMetabolismEngine();

  /// Calculate real-time dynamic TDEE based on daily caloric intake and 7-day weight trend delta
  AdaptiveMetabolismResult calculateDynamicTdee({
    required double baseTdee,
    required double averageCaloricIntake,
    required double weightDelta7DaysKg,
  }) {
    // 7700 kcal = 1 kg fat
    final dailyWeightEnergyOffset = (weightDelta7DaysKg * 7700.0) / 7.0;
    final dynamicTdee =
        (averageCaloricIntake - dailyWeightEnergyOffset).clamp(1200.0, 4500.0);

    String state;
    if (dynamicTdee > baseTdee + 150.0) {
      state = 'Metabolic Acceleration (High Energy Output)';
    } else if (dynamicTdee < baseTdee - 150.0) {
      state = 'Metabolic Adaptation (Caloric Conservation)';
    } else {
      state = 'Metabolic Equilibrium';
    }

    return AdaptiveMetabolismResult(
      dynamicTdee: dynamicTdee,
      weightTrendKg: weightDelta7DaysKg,
      metabolicAdaptationState: state,
    );
  }

  /// Calculate unified Longevity Score (0–100)
  LongevityScoreResult calculateLongevityScore({
    required int readinessScore,
    required int sleepScore,
    required double vo2MaxEstimate,
    required int aqi,
  }) {
    double score = (0.35 * readinessScore) +
        (0.35 * sleepScore) +
        (0.30 * (vo2MaxEstimate / 50.0 * 100.0));
    if (aqi > 150) {
      score -= 10.0; // Penalty for poor environmental AQI exposure
    }

    final finalScore = score.clamp(0.0, 100.0).round();

    return LongevityScoreResult(
      longevityScore: finalScore,
      primaryDriver: finalScore >= 80
          ? 'Optimal VO2Max & Recovery'
          : 'Requires Better Sleep & AQI Protection',
    );
  }
}
