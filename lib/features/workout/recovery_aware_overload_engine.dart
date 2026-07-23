/// §P6-E Recovery-Aware Overload Engine (Deterministic)
///
/// Adapts weight progression steps based on daily recovery capacity and sleep debt.
/// Direct implementation of §P6-E Section 3C specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Output Model
// ─────────────────────────────────────────────────────────────────────────────

/// Overload suggestion from the Recovery-Aware engine.
class OverloadSuggestion {
  const OverloadSuggestion({
    required this.targetWeightKg,
    required this.overloadStepKg,
    required this.message,
    required this.progressionFactor,
  });

  /// Recommended target weight for the next session.
  final double targetWeightKg;

  /// Net weight increase applied (0.0, 2.5, or 5.0 kg).
  final double overloadStepKg;

  final String message;

  /// 0.0 = maintenance, 0.5 = half-step, 1.0 = full step.
  final double progressionFactor;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine
// ─────────────────────────────────────────────────────────────────────────────

class RecoveryAwareOverloadEngine {
  const RecoveryAwareOverloadEngine();

  static const double _fullStepKg = 5.0;

  /// Suggests a recovery-adapted overload for the next workout.
  ///
  /// §P6-E Recovery Tiers:
  /// - [recoveryCapacity] < 50 → factor 0.0 → maintenance (0 kg overload).
  /// - [recoveryCapacity] < 70 OR [sleepDebtHours] > 2.0 → factor 0.5 → +2.5 kg.
  /// - Otherwise → factor 1.0 → full +5.0 kg step.
  OverloadSuggestion suggest({
    required String exerciseId,
    required double baseTargetWeightKg,
    required double recoveryCapacity,
    required double sleepDebtHours,
  }) {
    double progressionFactor;

    if (recoveryCapacity < 50) {
      progressionFactor = 0.0; // Maintenance / Deload
    } else if (recoveryCapacity < 70 || sleepDebtHours > 2.0) {
      progressionFactor = 0.5; // Half-step progression
    } else {
      progressionFactor = 1.0; // Full progression
    }

    final overloadStep = _fullStepKg * progressionFactor;
    final targetWeight = baseTargetWeightKg + overloadStep;

    final String message;
    if (progressionFactor == 0.0) {
      message =
          'Recovery capacity is low. Maintain current weight (${baseTargetWeightKg}kg) to prevent overreaching.';
    } else if (progressionFactor == 0.5) {
      message =
          'Overload target adjusted to +${overloadStep}kg (half-step) due to moderate sleep debt or sub-optimal recovery.';
    } else {
      message =
          'Full recovery detected. Progress to ${targetWeight}kg (+${overloadStep}kg) for $exerciseId.';
    }

    return OverloadSuggestion(
      targetWeightKg: targetWeight,
      overloadStepKg: overloadStep,
      message: message,
      progressionFactor: progressionFactor,
    );
  }
}
