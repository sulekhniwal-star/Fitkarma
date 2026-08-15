/// 4-Pillar Sleep Score Calculation Result
class SleepPerformanceResult {
  final int overallScore; // 0 to 100
  final double durationScore;
  final double efficiencyScore;
  final double restfulnessScore;
  final double circadianScore;
  final double sleepNeedHours;
  final double actualSleepHours;
  final double circadianMidpointShiftMinutes;

  const SleepPerformanceResult({
    required this.overallScore,
    required this.durationScore,
    required this.efficiencyScore,
    required this.restfulnessScore,
    required this.circadianScore,
    required this.sleepNeedHours,
    required this.actualSleepHours,
    required this.circadianMidpointShiftMinutes,
  });
}

/// Core Sleep Engine: 4 Pillars, Sleep Need, Bedtime Coach & Circadian Rules
class SleepEngine {
  const SleepEngine();

  /// Calculate Sleep Performance Score using 4 pillars:
  /// Duration (35%), Efficiency (25%), Restfulness (25%), Circadian Alignment (15%)
  SleepPerformanceResult calculateSleepPerformance({
    required double actualSleepHours,
    required double sleepNeedHours,
    double efficiencyRatio = 0.88, // 88% efficiency
    double deepSleepRatio = 0.20, // 20% deep sleep
    double midpointShiftMinutes = 15.0, // 15 mins shift from baseline
  }) {
    // Pillar 1: Duration Ratio
    final durationScore =
        ((actualSleepHours / sleepNeedHours) * 100.0).clamp(0.0, 100.0);

    // Pillar 2: Efficiency Ratio
    final efficiencyScore = (efficiencyRatio * 100.0).clamp(0.0, 100.0);

    // Pillar 3: Restfulness Ratio (Deep + REM sleep quality)
    final restfulnessScore =
        ((deepSleepRatio / 0.22) * 100.0).clamp(0.0, 100.0);

    // Pillar 4: Circadian Timing Penalty (Penalize shifts > 45 minutes)
    double circadianScore = 100.0;
    if (midpointShiftMinutes > 45.0) {
      final excessShift = midpointShiftMinutes - 45.0;
      circadianScore = (100.0 - (excessShift * 0.8)).clamp(0.0, 100.0);
    }

    // Overall 4-pillar weighted score
    final overall = (0.35 * durationScore) +
        (0.25 * efficiencyScore) +
        (0.25 * restfulnessScore) +
        (0.15 * circadianScore);

    return SleepPerformanceResult(
      overallScore: overall.clamp(0.0, 100.0).round(),
      durationScore: durationScore,
      efficiencyScore: efficiencyScore,
      restfulnessScore: restfulnessScore,
      circadianScore: circadianScore,
      sleepNeedHours: sleepNeedHours,
      actualSleepHours: actualSleepHours,
      circadianMidpointShiftMinutes: midpointShiftMinutes,
    );
  }
}
