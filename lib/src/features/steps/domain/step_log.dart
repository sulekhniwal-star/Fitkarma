import 'package:freezed_annotation/freezed_annotation.dart';

part 'step_log.freezed.dart';
part 'step_log.g.dart';

@freezed
abstract class StepLog with _$StepLog {
  const factory StepLog({
    required String id,
    required String userId,
    required DateTime date,
    @Default(0) int steps,
    @Default(8000) int goal,
    double? distanceKm,
    double? calories,
    @Default([]) List<int> hourlyData, // Steps per hour (24 hours)
    @Default('pedometer') String source,
    @Default(false) bool isSynced,
  }) = _StepLog;

  const StepLog._();

  factory StepLog.fromJson(Map<String, dynamic> json) =>
      _$StepLogFromJson(json);

  // Calculate progress percentage
  double get progressPercentage {
    if (goal == 0) return 0;
    return (steps / goal).clamp(0.0, 1.0);
  }

  // Check if goal is achieved
  bool get isGoalAchieved => steps >= goal;

  // Calculate remaining steps to goal
  int get remainingSteps => (goal - steps).clamp(0, goal);

  // Convert steps to cricket overs (120 steps = 1 over)
  double get cricketOvers => steps / 120;

  // Get formatted cricket overs string
  String get cricketOversFormatted {
    final overs = cricketOvers;
    final fullOvers = overs.floor();
    final balls = ((overs - fullOvers) * 6).round();
    return '$fullOvers.$balls';
  }

  // Calculate calories if not set (approximate: 0.04 kcal per step)
  double get calculatedCalories => calories ?? (steps * 0.04);

  // Calculate distance if not set (approximate: 0.000762 km per step)
  double get calculatedDistanceKm => distanceKm ?? (steps * 0.000762);

  // Get most active hour
  int? get mostActiveHour {
    if (hourlyData.isEmpty) return null;
    int maxIndex = 0;
    int maxSteps = hourlyData[0];
    for (int i = 1; i < hourlyData.length; i++) {
      if (hourlyData[i] > maxSteps) {
        maxSteps = hourlyData[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  // Create empty log for today
  factory StepLog.empty(String userId, DateTime date) {
    return StepLog(
      id: '',
      userId: userId,
      date: date,
      steps: 0,
      goal: 8000,
      hourlyData: List.filled(24, 0),
    );
  }
}

@freezed
abstract class StepSettings with _$StepSettings {
  const factory StepSettings({
    required String id,
    required String userId,
    @Default(8000) int dailyGoal,
    @Default(true) bool reminderEnabled,
    @Default('18:00') String reminderTime,
    @Default(false) bool cricketMode,
    @Default(true) bool notificationsEnabled,
  }) = _StepSettings;

  factory StepSettings.fromJson(Map<String, dynamic> json) =>
      _$StepSettingsFromJson(json);
}

// Step entry for detailed logging
@freezed
abstract class StepEntry with _$StepEntry {
  const factory StepEntry({
    required DateTime timestamp,
    required int steps,
    String? source,
  }) = _StepEntry;

  factory StepEntry.fromJson(Map<String, dynamic> json) =>
      _$StepEntryFromJson(json);
}
