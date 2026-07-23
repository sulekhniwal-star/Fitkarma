import 'package:fitkarma/features/karma/habit_models.dart';
import 'package:fitkarma/features/karma/habit_repository.dart';
import 'package:fitkarma/features/karma/habit_streak_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = HabitStreakEngine();

  final today = DateTime(2026, 7, 23);
  final yesterday = today.subtract(const Duration(days: 1));
  final day2 = today.subtract(const Duration(days: 2));
  final day3 = today.subtract(const Duration(days: 3));
  final day4 = today.subtract(const Duration(days: 4));
  final day5 = today.subtract(const Duration(days: 5));
  final day6 = today.subtract(const Duration(days: 6));

  group('§P7-C Habit Automation — Streak Calculation Tests', () {
    test('Calculates 7-day active consecutive streak correctly', () {
      final logs = [
        HabitLogEntry(id: '1', habitType: HabitType.proteinGoal, date: today),
        HabitLogEntry(id: '2', habitType: HabitType.proteinGoal, date: yesterday),
        HabitLogEntry(id: '3', habitType: HabitType.proteinGoal, date: day2),
        HabitLogEntry(id: '4', habitType: HabitType.proteinGoal, date: day3),
        HabitLogEntry(id: '5', habitType: HabitType.proteinGoal, date: day4),
        HabitLogEntry(id: '6', habitType: HabitType.proteinGoal, date: day5),
        HabitLogEntry(id: '7', habitType: HabitType.proteinGoal, date: day6),
      ];

      final info = engine.calculateStreak(
        habitType: HabitType.proteinGoal,
        logs: logs,
        referenceDate: today,
      );

      expect(info.currentStreakDays, 7);
      expect(info.longestStreakDays, 7);
      expect(info.isActiveToday, true);
    });

    test('Streak remains active if logged yesterday but not yet today', () {
      final logs = [
        HabitLogEntry(id: '1', habitType: HabitType.proteinGoal, date: yesterday),
        HabitLogEntry(id: '2', habitType: HabitType.proteinGoal, date: day2),
        HabitLogEntry(id: '3', habitType: HabitType.proteinGoal, date: day3),
      ];

      final info = engine.calculateStreak(
        habitType: HabitType.proteinGoal,
        logs: logs,
        referenceDate: today,
      );

      expect(info.currentStreakDays, 3);
      expect(info.isActiveToday, false);
    });

    test('Streak resets to 0 when gap is greater than 1 day', () {
      final logs = [
        HabitLogEntry(id: '1', habitType: HabitType.proteinGoal, date: day3), // 3 days ago
        HabitLogEntry(id: '2', habitType: HabitType.proteinGoal, date: day4),
        HabitLogEntry(id: '3', habitType: HabitType.proteinGoal, date: day5),
      ];

      final info = engine.calculateStreak(
        habitType: HabitType.proteinGoal,
        logs: logs,
        referenceDate: today,
      );

      expect(info.currentStreakDays, 0); // Broken streak
      expect(info.longestStreakDays, 3); // Preserved historical max
    });

    test('Empty logs return zero streak', () {
      final info = engine.calculateStreak(
        habitType: HabitType.proteinGoal,
        logs: [],
        referenceDate: today,
      );

      expect(info.currentStreakDays, 0);
      expect(info.longestStreakDays, 0);
      expect(info.lastCompletedDate, isNull);
    });
  });

  group('§P7-C Habit Automation — Contextual Smart Trigger Tests', () {
    test('Fires post-meal walk trigger when food is logged', () {
      final triggers = engine.evaluateContextualTriggers(
        workoutCompletedRecently: false,
        foodLoggedRecently: true,
        elevatedHeartRateDetected: false,
        currentTemperatureCelsius: 28.0,
      );

      expect(triggers.any((t) => t.habitType == HabitType.postMealWalk), true);
      expect(triggers.firstWhere((t) => t.habitType == HabitType.postMealWalk).suggestedOffsetMinutes, 20);
    });

    test('Fires post-workout protein and hydration triggers when workout completed', () {
      final triggers = engine.evaluateContextualTriggers(
        workoutCompletedRecently: true,
        foodLoggedRecently: false,
        elevatedHeartRateDetected: false,
        currentTemperatureCelsius: 28.0,
      );

      expect(triggers.any((t) => t.habitType == HabitType.proteinGoal), true);
      expect(triggers.any((t) => t.habitType == HabitType.waterHydration), true);
    });

    test('Fires HR breathing trigger when elevated HR detected', () {
      final triggers = engine.evaluateContextualTriggers(
        workoutCompletedRecently: false,
        foodLoggedRecently: false,
        elevatedHeartRateDetected: true,
        currentTemperatureCelsius: 25.0,
      );

      expect(triggers.any((t) => t.habitType == HabitType.mindfulnessBreathing), true);
    });
  });

  group('§P7-C Habit Automation — Repository Tests', () {
    late HabitRepository repo;

    setUp(() {
      repo = HabitRepository();
    });

    test('Logs completions and retrieves streak info', () {
      repo.logHabitCompletion(habitType: HabitType.sleepRecovery, date: today);
      repo.logHabitCompletion(habitType: HabitType.sleepRecovery, date: yesterday);

      final streak = repo.getStreakInfo(HabitType.sleepRecovery, referenceDate: today);
      expect(streak.currentStreakDays, 2);
      expect(streak.isActiveToday, true);

      final allStreaks = repo.getAllHabitStreaks(referenceDate: today);
      expect(allStreaks[HabitType.sleepRecovery]?.currentStreakDays, 2);
      expect(allStreaks[HabitType.waterHydration]?.currentStreakDays, 0);
    });
  });
}
