import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentStep,
    @Default('') String name,
    @Default(18) int age,
    @Default('Male') String gender,
    @Default(170.0) double height,
    @Default(70.0) double weight,
    @Default('Weight Loss') String goal,
    @Default('Sedentary') String activityLevel,
    @Default('Vegetarian') String dietaryPreference,
    @Default('English') String language,
    @Default([]) List<String> healthConditions,
    @Default([]) List<String> workoutPreferences,
    String? dosha,
  }) = _OnboardingState;
}
