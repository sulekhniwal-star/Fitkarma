/// §P6-C Progressive Overload Engine (Deterministic)
///
/// Pure-Dart deterministic progression rules:
/// - 3 comfortable sessions → increase weight by next step
/// - 4 weeks at same weight without improvement → deload at 60%
/// - Otherwise → maintain current load
library;

// ─────────────────────────────────────────────────────────────────────────────
// Domain Models
// ─────────────────────────────────────────────────────────────────────────────

/// Input record representing an exercise with its current weight config.
class OverloadExercise {
  const OverloadExercise({
    required this.name,
    required this.currentWeightKg,
    required this.weightStepKg,
  });

  final String name;
  final double currentWeightKg;

  /// Standard increment step (e.g. 2.5 kg for upper, 5.0 kg for lower).
  final double weightStepKg;

  double get nextWeightStep => currentWeightKg + weightStepKg;
  double get deloadWeightKg => (currentWeightKg * 0.6 * 2).round() / 2; // round to nearest 0.5 kg
}

/// Historical record of a single exercise set/session used for progression analysis.
class ExerciseSessionRecord {
  const ExerciseSessionRecord({
    required this.exerciseName,
    required this.weightKg,
    required this.repsCompleted,
    required this.repsTarget,
    required this.rpe,
    required this.sessionDate,
  });

  final String exerciseName;
  final double weightKg;
  final int repsCompleted;
  final int repsTarget;

  /// Rate of Perceived Exertion 1–10. Comfortable = RPE ≤ 7.
  final int rpe;
  final DateTime sessionDate;

  bool get isComfortable => repsCompleted >= repsTarget && rpe <= 7;
}

enum ProgressionType { increaseWeight, deload, maintain }

/// Suggested progression action from the engine.
class ProgressionSuggestion {
  const ProgressionSuggestion({
    required this.type,
    required this.message,
    required this.suggestedWeightKg,
  });

  final ProgressionType type;
  final String message;
  final double suggestedWeightKg;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine
// ─────────────────────────────────────────────────────────────────────────────

class ProgressiveOverloadEngine {
  const ProgressiveOverloadEngine();

  /// Deterministic progression suggestion for [exercise] given [recentRecords].
  ///
  /// Rules (§P6-C Specification):
  /// 1. Last 3 sessions all comfortable (reps ≥ target AND RPE ≤ 7) → increase weight.
  /// 2. Same weight for ≥ 4 sessions with no reps improvement → deload at 60%.
  /// 3. Otherwise → maintain current load.
  ProgressionSuggestion? suggest({
    required OverloadExercise exercise,
    required List<ExerciseSessionRecord> recentRecords,
  }) {
    if (recentRecords.isEmpty) return null;

    // Filter to records for this exercise only, sorted most-recent first.
    final exerciseRecords = recentRecords
        .where((r) => r.exerciseName == exercise.name)
        .toList()
      ..sort((a, b) => b.sessionDate.compareTo(a.sessionDate));

    if (exerciseRecords.isEmpty) return null;

    // ── Rule 1: Last 3 sessions all comfortable → increase weight ──
    if (exerciseRecords.length >= 3) {
      final last3 = exerciseRecords.take(3).toList();
      final allComfortable = last3.every((s) => s.isComfortable);
      if (allComfortable) {
        return ProgressionSuggestion(
          type: ProgressionType.increaseWeight,
          message: 'You completed 3 sessions at ${exercise.currentWeightKg}kg '
              'comfortably. Increase to ${exercise.nextWeightStep}kg.',
          suggestedWeightKg: exercise.nextWeightStep,
        );
      }
    }

    // ── Rule 2: Same weight for ≥ 4 sessions with no improvement → deload ──
    if (_isPlateau(exercise, exerciseRecords)) {
      return ProgressionSuggestion(
        type: ProgressionType.deload,
        message:
            'Same weight for 4 sessions without improvement. Take a deload week at 60% intensity.',
        suggestedWeightKg: exercise.deloadWeightKg,
      );
    }

    // ── Rule 3: Maintain ──
    return ProgressionSuggestion(
      type: ProgressionType.maintain,
      message:
          'Keep working at ${exercise.currentWeightKg}kg. Hit all reps with RPE ≤ 7 for 3 sessions to progress.',
      suggestedWeightKg: exercise.currentWeightKg,
    );
  }

  /// Plateau detection: 4 or more consecutive sessions at the same weight
  /// where reps completed never exceeded reps target.
  bool _isPlateau(OverloadExercise exercise, List<ExerciseSessionRecord> records) {
    if (records.length < 4) return false;

    final last4 = records.take(4).toList();
    final allSameWeight = last4.every((r) => r.weightKg == exercise.currentWeightKg);
    final noImprovement = last4.every((r) => r.repsCompleted <= r.repsTarget);

    return allSameWeight && noImprovement;
  }
}
