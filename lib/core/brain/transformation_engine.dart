enum RelapseTier { none, tier1Support, tier2Recalibrate, tier3SquadNudge }

/// 90-Day Weight Trajectory Forecast Result (Range, not exact)
class WeightForecastRange {
  final double expectedKg;
  final double minKg;
  final double maxKg;
  final int daysAhead;

  const WeightForecastRange({
    required this.expectedKg,
    required this.minKg,
    required this.maxKg,
    required this.daysAhead,
  });
}

/// Relapse Intervention Result
class RelapseInterventionResult {
  final RelapseTier tier;
  final String title;
  final String message;
  final String actionButtonText;

  const RelapseInterventionResult({
    required this.tier,
    required this.title,
    required this.message,
    required this.actionButtonText,
  });
}

/// Core Transformation Engine
class TransformationEngine {
  const TransformationEngine();

  /// Calculate 90-day weight trajectory range based on daily calorie deficit
  WeightForecastRange calculate90DayForecast({
    required double currentWeightKg,
    required double dailyCalorieDeficit,
    int daysAhead = 90,
  }) {
    // 7700 kcal deficit = 1 kg fat loss
    final totalLossKg = (dailyCalorieDeficit * daysAhead) / 7700.0;
    final expected = (currentWeightKg - totalLossKg).clamp(40.0, 300.0);
    // Probabilistic range (+/- 2% margin)
    final margin = daysAhead * 0.025;

    return WeightForecastRange(
      expectedKg: expected,
      minKg: (expected - margin).clamp(40.0, 300.0),
      maxKg: (expected + margin).clamp(40.0, 300.0),
      daysAhead: daysAhead,
    );
  }

  /// Evaluate 3-tier relapse intervention system based on consecutive missed days
  RelapseInterventionResult evaluateRelapseTier(int missedDays) {
    if (missedDays >= 11) {
      return RelapseInterventionResult(
        tier: RelapseTier.tier3SquadNudge,
        title: 'Squad Support Alert',
        message:
            'You have been away for $missedDays days. We have sent a gentle nudge to your Squad!',
        actionButtonText: 'Rejoin Squad Challenge',
      );
    } else if (missedDays >= 6) {
      return const RelapseInterventionResult(
        tier: RelapseTier.tier2Recalibrate,
        title: 'Program Recalibration',
        message:
            'Life gets busy! Let us recalibrate your daily goals to lower stress.',
        actionButtonText: 'Recalibrate Goals',
      );
    } else if (missedDays >= 3) {
      return const RelapseInterventionResult(
        tier: RelapseTier.tier1Support,
        title: 'Supportive Check-in',
        message:
            'Missing a few days is completely normal. Resume with a gentle 5min mobility session today!',
        actionButtonText: 'Start 5min Mobility',
      );
    } else {
      return const RelapseInterventionResult(
        tier: RelapseTier.none,
        title: 'On Track',
        message: 'Consistency is strong!',
        actionButtonText: 'Keep Going',
      );
    }
  }
}
