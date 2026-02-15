// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StepLog _$StepLogFromJson(Map<String, dynamic> json) => _StepLog(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  date: DateTime.parse(json['date'] as String),
  steps: (json['steps'] as num?)?.toInt() ?? 0,
  goal: (json['goal'] as num?)?.toInt() ?? 8000,
  distanceKm: (json['distance_km'] as num?)?.toDouble(),
  calories: (json['calories'] as num?)?.toDouble(),
  hourlyData:
      (json['hourly_data'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  source: json['source'] as String? ?? 'pedometer',
  isSynced: json['is_synced'] as bool? ?? false,
);

Map<String, dynamic> _$StepLogToJson(_StepLog instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'date': instance.date.toIso8601String(),
  'steps': instance.steps,
  'goal': instance.goal,
  'distance_km': instance.distanceKm,
  'calories': instance.calories,
  'hourly_data': instance.hourlyData,
  'source': instance.source,
  'is_synced': instance.isSynced,
};

_StepSettings _$StepSettingsFromJson(Map<String, dynamic> json) =>
    _StepSettings(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      dailyGoal: (json['daily_goal'] as num?)?.toInt() ?? 8000,
      reminderEnabled: json['reminder_enabled'] as bool? ?? true,
      reminderTime: json['reminder_time'] as String? ?? '18:00',
      cricketMode: json['cricket_mode'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$StepSettingsToJson(_StepSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'daily_goal': instance.dailyGoal,
      'reminder_enabled': instance.reminderEnabled,
      'reminder_time': instance.reminderTime,
      'cricket_mode': instance.cricketMode,
      'notifications_enabled': instance.notificationsEnabled,
    };

_StepEntry _$StepEntryFromJson(Map<String, dynamic> json) => _StepEntry(
  timestamp: DateTime.parse(json['timestamp'] as String),
  steps: (json['steps'] as num).toInt(),
  source: json['source'] as String?,
);

Map<String, dynamic> _$StepEntryToJson(_StepEntry instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'steps': instance.steps,
      'source': instance.source,
    };
