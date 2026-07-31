/// Progressive Overload Target Result
class OverloadTarget {
  final double weightKg;
  final int reps;
  final String recommendationReason;

  const OverloadTarget({
    required this.weightKg,
    required this.reps,
    required this.recommendationReason,
  });
}

/// Deterministic Progressive Overload Engine
class ProgressiveOverloadEngine {
  const ProgressiveOverloadEngine();

  /// Calculate next session weight & rep target based on previous weight, RPE (1-10), and readiness score
  OverloadTarget calculateNextTarget({
    required double previousWeightKg,
    required int previousReps,
    required double rpe, // 1 to 10 scale
    required int readinessScore,
  }) {
    double newWeight = previousWeightKg;
    int newReps = previousReps;
    String reason;

    if (rpe <= 7.0 && readinessScore >= 75) {
      newWeight += 2.5;
      reason = 'Peak Readiness (75+) & Low RPE (<= 7) — Increment weight +2.5kg.';
    } else if (rpe >= 9.5 || readinessScore < 50) {
      newWeight = (previousWeightKg - 2.5).clamp(0.0, 500.0);
      reason = 'Low Readiness / High RPE — Deload -2.5kg for recovery.';
    } else {
      reason = 'Moderate Readiness & Controlled RPE — Maintain weight and target +1 rep.';
      newReps += 1;
    }

    return OverloadTarget(
      weightKg: newWeight,
      reps: newReps,
      recommendationReason: reason,
    );
  }
}
