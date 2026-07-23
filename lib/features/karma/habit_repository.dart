/// §P7-C Habit Automation System — Repository
///
/// In-memory repository for persisting HabitLogEntry items per HabitType
/// and retrieving calculated streak info across all habits.
library;

import 'package:fitkarma/features/karma/habit_models.dart';
import 'package:fitkarma/features/karma/habit_streak_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HabitRepository {
  final List<HabitLogEntry> _logs = [];
  final HabitStreakEngine _engine = const HabitStreakEngine();

  /// Logs a habit completion record for a given date.
  void logHabitCompletion({
    required HabitType habitType,
    DateTime? date,
    bool isGoalMet = true,
    double? valueLogged,
  }) {
    final recordDate = date ?? DateTime.now();
    _logs.add(
      HabitLogEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        habitType: habitType,
        date: recordDate,
        isGoalMet: isGoalMet,
        valueLogged: valueLogged,
      ),
    );
  }

  /// Gets current streak info for a specific habit type.
  HabitStreakInfo getStreakInfo(HabitType habitType, {DateTime? referenceDate}) {
    return _engine.calculateStreak(
      habitType: habitType,
      logs: _logs,
      referenceDate: referenceDate,
    );
  }

  /// Gets streak info across all defined habit types.
  Map<HabitType, HabitStreakInfo> getAllHabitStreaks({DateTime? referenceDate}) {
    final Map<HabitType, HabitStreakInfo> map = {};
    for (final habit in HabitType.values) {
      map[habit] = getStreakInfo(habit, referenceDate: referenceDate);
    }
    return map;
  }

  /// Generates smart triggers for current user context.
  List<HabitSmartTrigger> getSmartTriggers({
    required bool workoutCompletedRecently,
    required bool foodLoggedRecently,
    required bool elevatedHeartRateDetected,
    required double currentTemperatureCelsius,
  }) {
    return _engine.evaluateContextualTriggers(
      workoutCompletedRecently: workoutCompletedRecently,
      foodLoggedRecently: foodLoggedRecently,
      elevatedHeartRateDetected: elevatedHeartRateDetected,
      currentTemperatureCelsius: currentTemperatureCelsius,
    );
  }

  /// Unmodifiable view of all habit log entries.
  List<HabitLogEntry> get allLogs => List.unmodifiable(_logs);

  /// Clears in-memory logs (for testing).
  void clear() => _logs.clear();
}

final habitRepositoryProvider = Provider<HabitRepository>((_) {
  return HabitRepository();
});
