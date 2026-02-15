// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['full_name'] as String?,
  age: (json['age'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  height: (json['height'] as num?)?.toDouble(),
  currentWeight: (json['current_weight'] as num?)?.toDouble(),
  goalWeight: (json['goal_weight'] as num?)?.toDouble(),
  activityLevel: json['activity_level'] as String?,
  goalType: json['goal_type'] as String?,
  dietaryPreference: json['dietary_preference'] as String?,
  language: json['language'] as String?,
  dosha: json['dosha'] as String?,
  healthConditions:
      (json['health_conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  workoutPreferences:
      (json['workout_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  karmaPoints: (json['karma_points'] as num?)?.toInt() ?? 0,
  karmaTier: json['karma_tier'] as String? ?? 'Bronze',
  streakDays: (json['streak_days'] as num?)?.toInt() ?? 0,
  lastActiveDate: json['last_active_date'] == null
      ? null
      : DateTime.parse(json['last_active_date'] as String),
  subscriptionStatus: json['subscription_status'] as String? ?? 'free',
  subscriptionExpires: json['subscription_expires'] == null
      ? null
      : DateTime.parse(json['subscription_expires'] as String),
  profilePhoto: json['profile_photo'] as String?,
  onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'age': instance.age,
      'gender': instance.gender,
      'height': instance.height,
      'current_weight': instance.currentWeight,
      'goal_weight': instance.goalWeight,
      'activity_level': instance.activityLevel,
      'goal_type': instance.goalType,
      'dietary_preference': instance.dietaryPreference,
      'language': instance.language,
      'dosha': instance.dosha,
      'health_conditions': instance.healthConditions,
      'workout_preferences': instance.workoutPreferences,
      'karma_points': instance.karmaPoints,
      'karma_tier': instance.karmaTier,
      'streak_days': instance.streakDays,
      'last_active_date': instance.lastActiveDate?.toIso8601String(),
      'subscription_status': instance.subscriptionStatus,
      'subscription_expires': instance.subscriptionExpires?.toIso8601String(),
      'profile_photo': instance.profilePhoto,
      'onboarding_completed': instance.onboardingCompleted,
    };
