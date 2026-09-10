import 'dart:math';
import 'habit_models.dart';

class HabitAutomationEngine {
  /// Pure Dart deterministic calculation of Habit Strength Index (0.0 to 100.0)
  /// Uses exponential recency weighting so recent consistency has higher impact.
  static double calculateHabitStrengthIndex(List<bool> history) {
    if (history.isEmpty) return 0.0;

    const double lambda = 0.05; // Recency decay factor
    double weightedSum = 0.0;
    double maxWeight = 0.0;

    for (int i = 0; i < history.length; i++) {
      final double weight = exp(-lambda * (history.length - 1 - i));
      maxWeight += weight;
      if (history[i]) {
        weightedSum += weight;
      }
    }

    if (maxWeight == 0.0) return 0.0;
    final double hsi = (weightedSum / maxWeight) * 100.0;
    return double.parse(hsi.clamp(0.0, 100.0).toStringAsFixed(1));
  }

  /// Determines behavioral automaticity tier based on Habit Strength Index
  static HabitAutomaticityTier determineAutomaticityTier(double hsi) {
    if (hsi < 40.0) {
      return HabitAutomaticityTier.formation;
    } else if (hsi < 75.0) {
      return HabitAutomaticityTier.reinforcement;
    } else {
      return HabitAutomaticityTier.automatic;
    }
  }

  /// Toggles or sets habit completion state and deterministically recalculates metrics
  static Habit toggleHabitState(Habit habit, {bool? forceCompleted}) {
    final bool willBeCompleted = forceCompleted ?? !habit.isCompletedToday;

    final updatedHistory = List<bool>.from(habit.history30Days);
    int updatedStreak = habit.streakDays;
    int updatedCompletions = habit.totalCompletions;

    if (willBeCompleted && !habit.isCompletedToday) {
      // Completed action
      updatedStreak += 1;
      updatedCompletions += 1;
      if (updatedHistory.length >= 30) {
        updatedHistory.removeAt(0);
      }
      updatedHistory.add(true);
    } else if (!willBeCompleted && habit.isCompletedToday) {
      // Uncompleted action
      updatedStreak = max(0, updatedStreak - 1);
      updatedCompletions = max(0, updatedCompletions - 1);
      if (updatedHistory.isNotEmpty) {
        updatedHistory[updatedHistory.length - 1] = false;
      }
    }

    final double newHsi = calculateHabitStrengthIndex(updatedHistory);
    final HabitAutomaticityTier newTier = determineAutomaticityTier(newHsi);

    return habit.copyWith(
      isCompletedToday: willBeCompleted,
      lastCompletedAt: willBeCompleted ? DateTime.now() : habit.lastCompletedAt,
      streakDays: updatedStreak,
      totalCompletions: updatedCompletions,
      habitStrengthIndex: newHsi,
      automaticityTier: newTier,
      history30Days: updatedHistory,
    );
  }

  /// Computes overall daily habit adherence and summary
  static HabitDailySummary computeDailySummary(List<Habit> habits) {
    if (habits.isEmpty) {
      return const HabitDailySummary(
        totalHabitsCount: 0,
        completedTodayCount: 0,
        adherencePercent: 0.0,
        averageHabitStrengthIndex: 0.0,
        totalEarnedKarmaPointsToday: 0,
        habits: [],
      );
    }

    final int completedCount = habits.where((h) => h.isCompletedToday).length;
    final double adherence = (completedCount / habits.length) * 100.0;

    final double totalHsi =
        habits.fold(0.0, (sum, h) => sum + h.habitStrengthIndex);
    final double avgHsi =
        double.parse((totalHsi / habits.length).toStringAsFixed(1));

    final int earnedKarma = habits
        .where((h) => h.isCompletedToday)
        .fold(0, (sum, h) => sum + h.rewardKarmaPoints);

    return HabitDailySummary(
      totalHabitsCount: habits.length,
      completedTodayCount: completedCount,
      adherencePercent: double.parse(adherence.toStringAsFixed(1)),
      averageHabitStrengthIndex: avgHsi,
      totalEarnedKarmaPointsToday: earnedKarma,
      habits: habits,
    );
  }
}
