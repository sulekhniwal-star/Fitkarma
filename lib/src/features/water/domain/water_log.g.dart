// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterLog _$WaterLogFromJson(Map<String, dynamic> json) => _WaterLog(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  date: DateTime.parse(json['date'] as String),
  glasses: (json['glasses'] as num?)?.toInt() ?? 0,
  goal: (json['goal'] as num?)?.toInt() ?? 8,
  mlTotal: (json['ml_total'] as num?)?.toInt() ?? 0,
  entries:
      (json['entries'] as List<dynamic>?)
          ?.map((e) => WaterEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  streakDays: (json['streak_days'] as num?)?.toInt() ?? 0,
  lastEntryTime: json['last_entry_time'] == null
      ? null
      : DateTime.parse(json['last_entry_time'] as String),
  isSynced: json['is_synced'] as bool? ?? false,
);

Map<String, dynamic> _$WaterLogToJson(_WaterLog instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'date': instance.date.toIso8601String(),
  'glasses': instance.glasses,
  'goal': instance.goal,
  'ml_total': instance.mlTotal,
  'entries': instance.entries,
  'streak_days': instance.streakDays,
  'last_entry_time': instance.lastEntryTime?.toIso8601String(),
  'is_synced': instance.isSynced,
};

_WaterSettings _$WaterSettingsFromJson(Map<String, dynamic> json) =>
    _WaterSettings(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      dailyGoal: (json['daily_goal'] as num?)?.toInt() ?? 8,
      glassSizeMl: (json['glass_size_ml'] as num?)?.toInt() ?? 250,
      bottleSizeMl: (json['bottle_size_ml'] as num?)?.toInt() ?? 500,
      chaiSizeMl: (json['chai_size_ml'] as num?)?.toInt() ?? 150,
      reminderEnabled: json['reminder_enabled'] as bool? ?? true,
      reminderIntervalHours:
          (json['reminder_interval_hours'] as num?)?.toInt() ?? 2,
      reminderStartTime: json['reminder_start_time'] as String? ?? '08:00',
      reminderEndTime: json['reminder_end_time'] as String? ?? '20:00',
      smartReminders: json['smart_reminders'] as bool? ?? true,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$WaterSettingsToJson(_WaterSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'daily_goal': instance.dailyGoal,
      'glass_size_ml': instance.glassSizeMl,
      'bottle_size_ml': instance.bottleSizeMl,
      'chai_size_ml': instance.chaiSizeMl,
      'reminder_enabled': instance.reminderEnabled,
      'reminder_interval_hours': instance.reminderIntervalHours,
      'reminder_start_time': instance.reminderStartTime,
      'reminder_end_time': instance.reminderEndTime,
      'smart_reminders': instance.smartReminders,
      'notifications_enabled': instance.notificationsEnabled,
    };

_WaterEntry _$WaterEntryFromJson(Map<String, dynamic> json) => _WaterEntry(
  time: DateTime.parse(json['time'] as String),
  amountMl: (json['amount_ml'] as num).toInt(),
  type: json['type'] as String? ?? 'glass',
  note: json['note'] as String?,
);

Map<String, dynamic> _$WaterEntryToJson(_WaterEntry instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'amount_ml': instance.amountMl,
      'type': instance.type,
      'note': instance.note,
    };
