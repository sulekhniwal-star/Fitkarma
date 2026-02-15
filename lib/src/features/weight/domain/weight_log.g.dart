// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightLog _$WeightLogFromJson(Map<String, dynamic> json) => _WeightLog(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  date: DateTime.parse(json['date'] as String),
  weight: (json['weight'] as num).toDouble(),
  note: json['note'] as String?,
  photo: json['photo'] as String?,
  bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
  muscleMass: (json['muscle_mass'] as num?)?.toDouble(),
  measurements: json['measurements'] == null
      ? null
      : BodyMeasurements.fromJson(json['measurements'] as Map<String, dynamic>),
  mood: json['mood'] as String?,
  isSynced: json['is_synced'] as bool? ?? false,
);

Map<String, dynamic> _$WeightLogToJson(_WeightLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'date': instance.date.toIso8601String(),
      'weight': instance.weight,
      'note': instance.note,
      'photo': instance.photo,
      'body_fat_percentage': instance.bodyFatPercentage,
      'muscle_mass': instance.muscleMass,
      'measurements': instance.measurements,
      'mood': instance.mood,
      'is_synced': instance.isSynced,
    };

_WeightGoals _$WeightGoalsFromJson(Map<String, dynamic> json) => _WeightGoals(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  startWeight: (json['start_weight'] as num?)?.toDouble(),
  currentWeight: (json['current_weight'] as num?)?.toDouble(),
  goalWeight: (json['goal_weight'] as num?)?.toDouble(),
  goalType: json['goal_type'] as String? ?? 'maintain',
  weeklyGoalKg: (json['weekly_goal_kg'] as num?)?.toDouble() ?? 0.5,
  reminderEnabled: json['reminder_enabled'] as bool? ?? true,
  reminderDay: json['reminder_day'] as String? ?? 'weekly',
  reminderTime: json['reminder_time'] as String? ?? '08:00',
  photoReminders: json['photo_reminders'] as bool? ?? true,
  notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
);

Map<String, dynamic> _$WeightGoalsToJson(_WeightGoals instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'start_weight': instance.startWeight,
      'current_weight': instance.currentWeight,
      'goal_weight': instance.goalWeight,
      'goal_type': instance.goalType,
      'weekly_goal_kg': instance.weeklyGoalKg,
      'reminder_enabled': instance.reminderEnabled,
      'reminder_day': instance.reminderDay,
      'reminder_time': instance.reminderTime,
      'photo_reminders': instance.photoReminders,
      'notifications_enabled': instance.notificationsEnabled,
    };

_BodyMeasurements _$BodyMeasurementsFromJson(Map<String, dynamic> json) =>
    _BodyMeasurements(
      chest: (json['chest'] as num?)?.toDouble(),
      waist: (json['waist'] as num?)?.toDouble(),
      hips: (json['hips'] as num?)?.toDouble(),
      arms: (json['arms'] as num?)?.toDouble(),
      thighs: (json['thighs'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BodyMeasurementsToJson(_BodyMeasurements instance) =>
    <String, dynamic>{
      'chest': instance.chest,
      'waist': instance.waist,
      'hips': instance.hips,
      'arms': instance.arms,
      'thighs': instance.thighs,
    };

_WeightTrend _$WeightTrendFromJson(Map<String, dynamic> json) => _WeightTrend(
  date: DateTime.parse(json['date'] as String),
  weight: (json['weight'] as num).toDouble(),
  movingAverage: (json['moving_average'] as num?)?.toDouble(),
  changeFromPrevious: (json['change_from_previous'] as num?)?.toDouble(),
);

Map<String, dynamic> _$WeightTrendToJson(_WeightTrend instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'weight': instance.weight,
      'moving_average': instance.movingAverage,
      'change_from_previous': instance.changeFromPrevious,
    };
