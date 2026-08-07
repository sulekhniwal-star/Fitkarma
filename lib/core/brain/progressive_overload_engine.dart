enum ProgressionType {
  increaseWeight,
  maintain,
  deload,
}

class ExerciseTarget {
  final String name;
  final double currentWeight;
  final double nextWeightStep; // e.g. +2.5kg for lower, +1.25kg for upper

  const ExerciseTarget({
    required this.name,
    required this.currentWeight,
    this.nextWeightStep = 2.5,
  });
}

class WorkoutSessionRecord {
  final DateTime date;
  final int repsTarget;
  final int repsCompleted;
  final double rpe; // 1 to 10 scale
  final double weightKg;

  const WorkoutSessionRecord({
    required this.date,
    required this.repsTarget,
    required this.repsCompleted,
    required this.rpe,
    required this.weightKg,
  });
}

class OverloadTarget {
  final double weightKg;
  final int reps;
  final String recommendationReason;
  final ProgressionType progressionType;

  const OverloadTarget({
    required this.weightKg,
    required this.reps,
    required this.recommendationReason,
    required this.progressionType,
  });
}

/// Fully Deterministic Progressive Overload Engine per §P6-C spec (Zero AI dependency)
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
    ProgressionType type;

    if (rpe <= 7.0 && readinessScore >= 75) {
      newWeight += 2.5;
      type = ProgressionType.increaseWeight;
      reason = 'Peak Readiness (75+) & Low RPE (<= 7) — Increment weight +2.5kg.';
    } else if (rpe >= 9.5 || readinessScore < 50) {
      newWeight = (previousWeightKg - 2.5).clamp(0.0, 500.0);
      type = ProgressionType.deload;
      reason = 'Low Readiness / High RPE — Deload -2.5kg for recovery.';
    } else {
      type = ProgressionType.maintain;
      reason = 'Moderate Readiness & Controlled RPE — Maintain weight and target +1 rep.';
      newReps += 1;
    }

    return OverloadTarget(
      weightKg: newWeight,
      reps: newReps,
      recommendationReason: reason,
      progressionType: type,
    );
  }

  /// Evaluates multi-session history to suggest weight increases, maintenance, or deload weeks (Fully Deterministic)
  OverloadTarget suggestMultiSessionProgression({
    required ExerciseTarget exercise,
    required List<WorkoutSessionRecord> recentSessions,
  }) {
    if (recentSessions.isEmpty) {
      return OverloadTarget(
        weightKg: exercise.currentWeight,
        reps: 8,
        recommendationReason: 'Initial baseline set at ${exercise.currentWeight}kg.',
        progressionType: ProgressionType.maintain,
      );
    }

    final last3 = recentSessions.length >= 3
        ? recentSessions.sublist(recentSessions.length - 3)
        : recentSessions;

    final allComfortable = last3.every(
      (s) => s.repsCompleted >= s.repsTarget && s.rpe <= 7.0,
    );

    if (allComfortable && last3.length >= 3) {
      final nextWeight = exercise.currentWeight + exercise.nextWeightStep;
      return OverloadTarget(
        weightKg: nextWeight,
        reps: last3.last.repsTarget,
        recommendationReason: 'You completed 3 sessions at ${exercise.currentWeight}kg comfortably (RPE <= 7). Increase to ${nextWeight}kg.',
        progressionType: ProgressionType.increaseWeight,
      );
    }

    if (_isPlateau(recentSessions)) {
      final deloadWeight = double.parse((exercise.currentWeight * 0.60).toStringAsFixed(1));
      return OverloadTarget(
        weightKg: deloadWeight,
        reps: last3.last.repsTarget,
        recommendationReason: 'Same weight plateau for 4 weeks. Take a deload week at 60% intensity (${deloadWeight}kg).',
        progressionType: ProgressionType.deload,
      );
    }

    final last = recentSessions.last;
    return OverloadTarget(
      weightKg: exercise.currentWeight,
      reps: last.repsCompleted < last.repsTarget ? last.repsTarget : last.repsTarget + 1,
      recommendationReason: 'Maintain ${exercise.currentWeight}kg and focus on hitting clean form reps.',
      progressionType: ProgressionType.maintain,
    );
  }

  bool _isPlateau(List<WorkoutSessionRecord> sessions) {
    if (sessions.length < 4) return false;
    final last4 = sessions.sublist(sessions.length - 4);
    final firstWeight = last4.first.weightKg;
    final sameWeight = last4.every((s) => s.weightKg == firstWeight);
    final noRepIncrease = last4.last.repsCompleted <= last4.first.repsCompleted;

    return sameWeight && noRepIncrease;
  }
}
