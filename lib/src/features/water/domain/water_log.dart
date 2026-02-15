import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_log.freezed.dart';
part 'water_log.g.dart';

@freezed
abstract class WaterLog with _$WaterLog {
  const factory WaterLog({
    required String id,
    required String userId,
    required DateTime date,
    @Default(0) int glasses,
    @Default(8) int goal,
    @Default(0) int mlTotal,
    @Default([]) List<WaterEntry> entries,
    @Default(0) int streakDays,
    DateTime? lastEntryTime,
    @Default(false) bool isSynced,
  }) = _WaterLog;

  const WaterLog._();

  factory WaterLog.fromJson(Map<String, dynamic> json) =>
      _$WaterLogFromJson(json);

  // Calculate progress percentage
  double get progressPercentage {
    if (goal == 0) return 0;
    return (glasses / goal).clamp(0.0, 1.0);
  }

  // Check if goal is achieved
  bool get isGoalAchieved => glasses >= goal;

  // Calculate remaining glasses
  int get remainingGlasses => (goal - glasses).clamp(0, goal);

  // Get formatted progress (e.g., "5/8")
  String get progressText => '$glasses/$goal';

  // Get hydration status message
  String get hydrationStatus {
    final percentage = progressPercentage;
    if (percentage >= 1.0) return 'Goal achieved! 💧';
    if (percentage >= 0.75) return 'Almost there! 🚰';
    if (percentage >= 0.5) return 'Good progress! 💦';
    if (percentage >= 0.25) return 'Keep drinking! 🥤';
    return 'Start hydrating! 🌊';
  }

  // Create empty log for today
  factory WaterLog.empty(String userId, DateTime date) {
    return WaterLog(
      id: '',
      userId: userId,
      date: date,
      glasses: 0,
      goal: 8,
      mlTotal: 0,
      entries: [],
    );
  }
}

@freezed
abstract class WaterSettings with _$WaterSettings {
  const factory WaterSettings({
    required String id,
    required String userId,
    @Default(8) int dailyGoal,
    @Default(250) int glassSizeMl,
    @Default(500) int? bottleSizeMl,
    @Default(150) int? chaiSizeMl,
    @Default(true) bool reminderEnabled,
    @Default(2) int reminderIntervalHours,
    @Default('08:00') String reminderStartTime,
    @Default('20:00') String reminderEndTime,
    @Default(true) bool smartReminders,
    @Default(true) bool notificationsEnabled,
  }) = _WaterSettings;

  factory WaterSettings.fromJson(Map<String, dynamic> json) =>
      _$WaterSettingsFromJson(json);
}

@freezed
abstract class WaterEntry with _$WaterEntry {
  const factory WaterEntry({
    required DateTime time,
    required int amountMl,
    @Default('glass') String type, // glass, bottle, chai, custom
    String? note,
  }) = _WaterEntry;

  const WaterEntry._();

  factory WaterEntry.fromJson(Map<String, dynamic> json) =>
      _$WaterEntryFromJson(json);


  // Get icon based on type
  String get icon {
    return switch (type.toLowerCase()) {
      'glass' => '💧',
      'bottle' => '🍶',
      'chai' => '☕',
      'custom' => '🥤',
      _ => '💧',
    };
  }

  // Get display text
  String get displayText {
    return switch (type.toLowerCase()) {
      'glass' => 'Glass ($amountMl ml)',
      'bottle' => 'Bottle ($amountMl ml)',
      'chai' => 'Chai ($amountMl ml)',
      'custom' => '$amountMl ml',
      _ => '$amountMl ml',
    };
  }
}
