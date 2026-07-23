/// §P7-C Habit Automation System — Habit Streak Engine
///
/// Pure Dart deterministic streak calculation & contextual smart trigger evaluator.
/// Implements §P7-C specifications.
library;

import 'package:fitkarma/features/karma/habit_models.dart';

class HabitStreakEngine {
  const HabitStreakEngine();

  /// Calculates current and longest streak for a given [habitType] from [logs].
  HabitStreakInfo calculateStreak({
    required HabitType habitType,
    required List<HabitLogEntry> logs,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Filter successful logs for this habit and map to normalized dates
    final habitLogs = logs
        .where((l) => l.habitType == habitType && l.isGoalMet)
        .map((l) => DateTime(l.date.year, l.date.month, l.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Descending order (newest first)

    if (habitLogs.isEmpty) {
      return HabitStreakInfo(
        habitType: habitType,
        currentStreakDays: 0,
        longestStreakDays: 0,
        lastCompletedDate: null,
        isActiveToday: false,
      );
    }

    final latestDate = habitLogs.first;
    final isActiveToday = latestDate.isAtSameMomentAs(today);

    // 1. Calculate Current Streak
    int currentStreak = 0;
    // Streak is active if logged today or yesterday
    final isStreakActive = latestDate.isAtSameMomentAs(today) || latestDate.isAtSameMomentAs(yesterday);

    if (isStreakActive) {
      DateTime checkDate = latestDate;
      for (final date in habitLogs) {
        if (date.isAtSameMomentAs(checkDate)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }

    // 2. Calculate Longest Streak
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? prevDate;

    // Process in ascending order (oldest first) to find max consecutive sequence
    final ascendingLogs = List<DateTime>.from(habitLogs.reversed);
    for (final date in ascendingLogs) {
      if (prevDate == null) {
        tempStreak = 1;
      } else {
        final expected = prevDate.add(const Duration(days: 1));
        if (date.isAtSameMomentAs(expected)) {
          tempStreak++;
        } else {
          tempStreak = 1;
        }
      }
      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }
      prevDate = date;
    }

    return HabitStreakInfo(
      habitType: habitType,
      currentStreakDays: currentStreak,
      longestStreakDays: longestStreak,
      lastCompletedDate: latestDate,
      isActiveToday: isActiveToday,
    );
  }

  /// Generates contextual smart triggers (§P7-C specification).
  ///
  /// Triggers:
  /// - Post-meal walk: 20 min after food logged.
  /// - Protein reminder: 30 min after workout logged.
  /// - Water adjustment: when temperature is high or workout logged.
  /// - Breathing exercise: when resting HR is above baseline.
  List<HabitSmartTrigger> evaluateContextualTriggers({
    required bool workoutCompletedRecently,
    required bool foodLoggedRecently,
    required bool elevatedHeartRateDetected,
    required double currentTemperatureCelsius,
  }) {
    final triggers = <HabitSmartTrigger>[];

    if (foodLoggedRecently) {
      triggers.add(
        const HabitSmartTrigger(
          id: 'post_meal_walk_trigger',
          habitType: HabitType.postMealWalk,
          title: 'Post-Meal Walk Nudge',
          message: 'A 10-minute walk after eating helps blunt postprandial glucose spikes.',
          suggestedOffsetMinutes: 20,
          reason: 'Food logged 20 min ago',
        ),
      );
    }

    if (workoutCompletedRecently) {
      triggers.add(
        const HabitSmartTrigger(
          id: 'protein_post_workout_trigger',
          habitType: HabitType.proteinGoal,
          title: 'Anabolic Recovery Nudge',
          message: 'Consume 25-35g protein within 30-45 minutes post-workout for optimal muscle protein synthesis.',
          suggestedOffsetMinutes: 30,
          reason: 'Workout completed 30 min ago',
        ),
      );
    }

    if (currentTemperatureCelsius >= 32.0 || workoutCompletedRecently) {
      triggers.add(
        HabitSmartTrigger(
          id: 'water_hydration_trigger',
          habitType: HabitType.waterHydration,
          title: 'Hydration Adjustment',
          message: currentTemperatureCelsius >= 32.0
              ? 'Ambient temperature is high (${currentTemperatureCelsius.round()}°C). Drink 500ml water to maintain hydration.'
              : 'Replenish fluid loss post-workout.',
          suggestedOffsetMinutes: 0,
          reason: 'High ambient temperature or workout activity',
        ),
      );
    }

    if (elevatedHeartRateDetected) {
      triggers.add(
        const HabitSmartTrigger(
          id: 'breathing_hr_trigger',
          habitType: HabitType.mindfulnessBreathing,
          title: 'Parasympathetic Reset',
          message: 'Resting HR is elevated above your 7-day baseline. Perform a 3-min box breathing session.',
          suggestedOffsetMinutes: 0,
          reason: 'Elevated resting HR detected',
        ),
      );
    }

    return triggers;
  }
}
