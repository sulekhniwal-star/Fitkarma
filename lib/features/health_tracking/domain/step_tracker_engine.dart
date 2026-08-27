class HourlyStepBlock {
  final int hour; // 0 to 23
  final int steps;

  const HourlyStepBlock({required this.hour, required this.steps});
}

class StepMetricsResult {
  final int totalSteps;
  final int targetSteps;
  final double distanceKm;
  final int activeCaloriesBurned;
  final double progressPercent;
  final List<HourlyStepBlock> hourlyCadence;
  final bool isGoalAchieved;
  final String metabolicInsight;

  const StepMetricsResult({
    required this.totalSteps,
    required this.targetSteps,
    required this.distanceKm,
    required this.activeCaloriesBurned,
    required this.progressPercent,
    required this.hourlyCadence,
    required this.isGoalAchieved,
    required this.metabolicInsight,
  });
}

class StepTrackerEngine {
  /// Pure Dart deterministic calculation of step metrics, stride distance, and active calorie expenditure
  static StepMetricsResult calculateMetrics({
    required int totalSteps,
    int targetSteps = 10000,
    double heightCm = 175.0,
    double weightKg = 70.0,
    List<HourlyStepBlock>? hourlyCadence,
  }) {
    // 1. Distance Calculation (Stride length formula: Height * 0.415)
    final strideLengthMeters = (heightCm * 0.415) / 100.0;
    final distanceMeters = totalSteps * strideLengthMeters;
    final distanceKm = distanceMeters / 1000.0;

    // 2. Active Walking Calorie Burn (Weight adjusted)
    final calorieMultiplier = (weightKg / 70.0).clamp(0.6, 1.8);
    final activeCalories = (totalSteps * 0.04 * calorieMultiplier).round();

    // 3. Progress
    final progress = (totalSteps / targetSteps.clamp(1, 100000)).clamp(0.0, 1.5);
    final isGoal = totalSteps >= targetSteps;

    // 4. Default Mock Hourly Cadence if none provided
    final cadence = hourlyCadence ?? _generateCadence(totalSteps);

    // 5. Actionable Metabolic Insight
    final String insight;
    if (isGoal) {
      insight = 'Daily step target achieved! Excellent insulin sensitivity and non-exercise activity thermogenesis (NEAT).';
    } else if (totalSteps >= 7500) {
      insight = 'You are in the optimal cardiovascular zone. A 15-minute evening stroll will easily complete your target.';
    } else if (totalSteps >= 4000) {
      insight = 'Moderate activity logged. Schedule a 10-minute post-meal walk (शतपावली) to boost glucose clearance.';
    } else {
      insight = 'Sedentary pattern detected. Take a 5-minute movement break to stimulate venous blood flow.';
    }

    return StepMetricsResult(
      totalSteps: totalSteps,
      targetSteps: targetSteps,
      distanceKm: double.parse(distanceKm.toStringAsFixed(2)),
      activeCaloriesBurned: activeCalories,
      progressPercent: progress,
      hourlyCadence: cadence,
      isGoalAchieved: isGoal,
      metabolicInsight: insight,
    );
  }

  static List<HourlyStepBlock> _generateCadence(int totalSteps) {
    return [
      const HourlyStepBlock(hour: 7, steps: 1200),
      const HourlyStepBlock(hour: 8, steps: 850),
      const HourlyStepBlock(hour: 10, steps: 400),
      const HourlyStepBlock(hour: 12, steps: 950),
      const HourlyStepBlock(hour: 14, steps: 600),
      const HourlyStepBlock(hour: 17, steps: 1800),
      const HourlyStepBlock(hour: 19, steps: 1500),
      const HourlyStepBlock(hour: 21, steps: 940),
    ];
  }
}
