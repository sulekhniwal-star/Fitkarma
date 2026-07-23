/// §P6-A Workout System Domain Models
///
/// Data structures for WorkoutProgram, WorkoutSession, ExerciseSummary, and WorkoutHistoryItem.
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
