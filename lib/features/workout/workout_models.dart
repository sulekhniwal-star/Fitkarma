/// §P6-A / §P6-B Workout System Domain Models
///
/// Data structures for WorkoutProgram, WorkoutSession, ExerciseSummary,
/// WorkoutHistoryItem, SetLogEntry, and WorkoutLogEntry.
library;

/// Active Workout Program Overview (§P6-A Specification).
class WorkoutProgram {
  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.currentWeek,
    required this.currentDay,
    required this.totalWeeks,
    required this.completedDaysThisWeek,
    required this.targetDaysPerWeek,
  });

  final String id;
  final String title;
  final int currentWeek;
  final int currentDay;
  final int totalWeeks;
  final int completedDaysThisWeek;
  final int targetDaysPerWeek;

  double get weeklyProgressFraction =>
      targetDaysPerWeek > 0 ? (completedDaysThisWeek / targetDaysPerWeek).clamp(0.0, 1.0) : 0.0;
}

/// Summary for an individual exercise in a workout session.
class ExerciseSummary {
  const ExerciseSummary({
    required this.name,
    required this.targetSets,
    required this.targetReps,
    required this.suggestedWeightKg,
    this.progressionNudge,
  });

  final String name;
  final int targetSets;
  final String targetReps;
  final double suggestedWeightKg;
  final String? progressionNudge;
}

/// Planned or active workout session (§P6-A Specification).
class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.exercises,
    this.progressionBadgeText,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final List<ExerciseSummary> exercises;
  final String? progressionBadgeText;

  int get totalSets => exercises.fold(0, (s, e) => s + e.targetSets);
}

/// Historical record of a completed workout.
class WorkoutHistoryItem {
  const WorkoutHistoryItem({
    required this.id,
    required this.sessionTitle,
    required this.completedAt,
    required this.durationMinutes,
    required this.totalSets,
    required this.totalVolumeKg,
  });

  final String id;
  final String sessionTitle;
  final DateTime completedAt;
  final int durationMinutes;
  final int totalSets;
  final double totalVolumeKg;
}

// ─────────────────────────────────────────────────────────────────────────────
// §P6-B Active Workout Log Models
// ─────────────────────────────────────────────────────────────────────────────

/// Mutable row state for a single set inside the active workout table.
class SetRowState {
  SetRowState({
    required this.setNumber,
    required this.targetReps,
    required this.weightKg,
    this.actualReps,
    this.isCompleted = false,
    this.completedAt,
  });

  final int setNumber;
  final int targetReps;
  double weightKg;
  int? actualReps;
  bool isCompleted;
  DateTime? completedAt;

  SetRowState copyWith({
    double? weightKg,
    int? actualReps,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return SetRowState(
      setNumber: setNumber,
      targetReps: targetReps,
      weightKg: weightKg ?? this.weightKg,
      actualReps: actualReps ?? this.actualReps,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Logged record of a completed set within a session (§P6-B: persisted in-memory).
class SetLogEntry {
  const SetLogEntry({
    required this.setNumber,
    required this.targetReps,
    required this.actualReps,
    required this.weightKg,
    required this.isCompleted,
    this.completedAt,
  });

  final int setNumber;
  final int targetReps;
  final int actualReps;
  final double weightKg;
  final bool isCompleted;
  final DateTime? completedAt;
}

/// Logged record of all sets for one exercise in a session (§P6-B WorkoutLogs).
class WorkoutLogEntry {
  const WorkoutLogEntry({
    required this.sessionId,
    required this.exerciseName,
    required this.sets,
    required this.loggedAt,
  });

  final String sessionId;
  final String exerciseName;
  final List<SetLogEntry> sets;
  final DateTime loggedAt;

  double get totalVolumeKg =>
      sets.fold(0.0, (v, s) => v + (s.isCompleted ? s.weightKg * s.actualReps : 0.0));
}
