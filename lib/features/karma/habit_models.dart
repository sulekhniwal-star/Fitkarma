/// §P7-C Habit Automation System — Models
///
/// Defines habit types, streak info structures, log entries,
/// and contextual smart triggers.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Habit Enums
// ─────────────────────────────────────────────────────────────────────────────

enum HabitType {
  proteinGoal('Daily Protein Target', 'Hit daily protein requirement'),
  sleepRecovery('Sleep Recovery', '≥7 hours of sleep recovery'),
  waterHydration('Water Hydration', 'Hit daily hydration target'),
  postMealWalk('Post-Meal Walk', '10-min walk after main meal'),
  mindfulnessBreathing('Breathing Exercise', 'HR-triggered recovery breathing');

  const HabitType(this.title, this.description);

  final String title;
  final String description;
}

// ─────────────────────────────────────────────────────────────────────────────
// Habit Log Entry
// ─────────────────────────────────────────────────────────────────────────────

class HabitLogEntry {
  const HabitLogEntry({
    required this.id,
    required this.habitType,
    required this.date,
    this.isGoalMet = true,
    this.valueLogged,
  });

  final String id;
  final HabitType habitType;
  final DateTime date;
  final bool isGoalMet;
  final double? valueLogged;
}

// ─────────────────────────────────────────────────────────────────────────────
// Habit Streak Info
// ─────────────────────────────────────────────────────────────────────────────

class HabitStreakInfo {
  const HabitStreakInfo({
    required this.habitType,
    required this.currentStreakDays,
    required this.longestStreakDays,
    this.lastCompletedDate,
    required this.isActiveToday,
  });

  final HabitType habitType;
  final int currentStreakDays;
  final int longestStreakDays;
  final DateTime? lastCompletedDate;
  final bool isActiveToday;
}

// ─────────────────────────────────────────────────────────────────────────────
// Contextual Smart Trigger (§P7-C Specification)
// ─────────────────────────────────────────────────────────────────────────────

class HabitSmartTrigger {
  const HabitSmartTrigger({
    required this.id,
    required this.habitType,
    required this.title,
    required this.message,
    required this.suggestedOffsetMinutes,
    required this.reason,
  });

  final String id;
  final HabitType habitType;
  final String title;
  final String message;
  final int suggestedOffsetMinutes;
  final String reason;
}
