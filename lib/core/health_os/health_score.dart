// lib/core/health_os/health_score.dart
// §P0-E Unified Health Score Calculator
// A single 0–100 score synthesizing all health dimensions.
// Replaces cognitive overload of tracking readiness + karma + sleep + protein + hydration separately.

/// Weighted inputs to the unified health score.
class HealthScoreInputs {
  const HealthScoreInputs({
    required this.nutritionScore,
    required this.recoveryScore,
    required this.trainingScore,
    required this.consistencyScore,
  });

  /// 0–100: Protein hit rate, calorie consistency over 7 days.
  final double nutritionScore;

  /// 0–100: Sleep quality, HRV trend, readiness score average.
  final double recoveryScore;

  /// 0–100: Workout consistency, progressive overload completion.
  final double trainingScore;

  /// 0–100: Streak, habit completion rate, app engagement.
  final double consistencyScore;
}

/// §P0-E Unified Health Score — 4-dimension weighted aggregate.
///
/// Weights are tunable per user goal (default: equal 25% each).
/// Score drives the daily mission hierarchy and dashboard hero metric.
class HealthScoreCalculator {
  const HealthScoreCalculator({Map<String, double>? weights})
      : _weights = weights ?? defaultWeights;

  final Map<String, double> _weights;

  /// Default equal-weight configuration (25% each dimension).
  static const Map<String, double> defaultWeights = {
    'nutrition': 0.25,   // Protein hit rate, calorie consistency
    'recovery': 0.25,    // Sleep quality, HRV, readiness
    'training': 0.25,    // Workout consistency, progressive overload
    'consistency': 0.25, // Streak, habit completion, app engagement
  };

  /// Weight preset tuned for weight-loss goals.
  static const Map<String, double> weightLossWeights = {
    'nutrition': 0.40,
    'recovery': 0.20,
    'training': 0.25,
    'consistency': 0.15,
  };

  /// Weight preset tuned for muscle-gain goals.
  static const Map<String, double> muscleGainWeights = {
    'nutrition': 0.30,
    'recovery': 0.30,
    'training': 0.30,
    'consistency': 0.10,
  };

  /// Calculates the unified health score (0–100).
  int calculate(HealthScoreInputs inputs) {
    final nutrition    = inputs.nutritionScore.clamp(0, 100);
    final recovery     = inputs.recoveryScore.clamp(0, 100);
    final training     = inputs.trainingScore.clamp(0, 100);
    final consistency  = inputs.consistencyScore.clamp(0, 100);

    final score = nutrition    * (_weights['nutrition'] ?? 0.25) +
                  recovery     * (_weights['recovery'] ?? 0.25) +
                  training     * (_weights['training'] ?? 0.25) +
                  consistency  * (_weights['consistency'] ?? 0.25);

    return score.round().clamp(0, 100);
  }

  /// Returns a human-readable label for a given health score.
  static String scoreLabel(int score) {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 55) return 'Fair';
    if (score >= 35) return 'Low';
    return 'Critical';
  }

  /// Returns the recommended primary action given a score.
  static String primaryAction(int score) {
    if (score >= 90) return 'Push for a new personal best today.';
    if (score >= 75) return 'Keep up the consistency — you\'re on track.';
    if (score >= 55) return 'Focus on your weakest dimension today.';
    if (score >= 35) return 'Prioritize recovery and nutrition basics.';
    return 'Rest, hydrate, and consult your coach.';
  }
}

/// Score hierarchy — drives daily mission display order.
///
/// ```
/// Health Score 0–100
///       ↓
/// Daily Mission (derived)
///       ↓
/// Readiness Score (subset)
///       ↓
/// All other metrics
/// ```
class HealthScoreHierarchy {
  static const List<String> dimensionOrder = [
    'nutrition',
    'recovery',
    'training',
    'consistency',
  ];
}
