import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? fullName,
    int? age,
    String? gender,
    double? height,
    double? currentWeight,
    double? goalWeight,
    String? activityLevel,
    String? goalType,
    String? dietaryPreference,
    String? language,
    String? dosha,
    @Default([]) List<String> healthConditions,
    @Default([]) List<String> workoutPreferences,
    @Default(0) int karmaPoints,
    @Default('Bronze') String karmaTier,
    @Default(0) int streakDays,
    DateTime? lastActiveDate,
    @Default('free') String subscriptionStatus,
    DateTime? subscriptionExpires,
    String? profilePhoto,
    @Default(false) bool onboardingCompleted,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  double get bmi {
    if (height == null || currentWeight == null || height == 0) return 0;
    final hm = height! / 100;
    return currentWeight! / (hm * hm);
  }

  double get bmr {
    if (currentWeight == null || height == null || age == null) return 0;
    // Mifflin-St Jeor Equation
    final s = gender?.toLowerCase() == 'male' ? 5 : -161;
    return (10 * currentWeight!) + (6.25 * height!) - (5 * age!) + s;
  }

  double get maintenanceCalories {
    final baseBmr = bmr;
    if (baseBmr == 0) return 0;

    final multiplier = switch (activityLevel?.toLowerCase()) {
      'sedentary' => 1.2,
      'lightly active' => 1.375,
      'moderately active' => 1.55,
      'very active' => 1.725,
      'extra active' => 1.9,
      _ => 1.2,
    };

    return baseBmr * multiplier;
  }

  double get targetCalories {
    final maintenance = maintenanceCalories;
    if (maintenance == 0) return 0;

    return switch (goalType?.toLowerCase()) {
      'weight loss' => maintenance - 500,
      'muscle gain' => maintenance + 300,
      _ => maintenance,
    };
  }
}
