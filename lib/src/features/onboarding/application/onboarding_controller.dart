import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/onboarding_state.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void updateBasicInfo({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      age: age ?? state.age,
      gender: gender ?? state.gender,
      height: height ?? state.height,
      weight: weight ?? state.weight,
    );
  }

  void updateGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void updateActivityLevel(String level) {
    state = state.copyWith(activityLevel: level);
  }

  void updateDietaryPreference(String pref) {
    state = state.copyWith(dietaryPreference: pref);
  }

  void updateLanguage(String lang) {
    state = state.copyWith(language: lang);
  }

  void updateDosha(String dosha) {
    state = state.copyWith(dosha: dosha);
  }

  void updateWorkoutPreferences(List<String> prefs) {
    state = state.copyWith(workoutPreferences: prefs);
  }

  void updateHealthConditions(List<String> conditions) {
    state = state.copyWith(healthConditions: conditions);
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> completeOnboarding() async {
    final authState = ref.read(authControllerProvider);
    final user = authState.value;

    if (user != null) {
      final dietaryPref = switch (state.dietaryPreference) {
        'Veg (Satvik)' => 'veg_satvik',
        'Veg (Onion/Garlic)' => 'veg_onion_garlic',
        'Vegetarian (Jain)' => 'veg_jain',
        'Non-Vegetarian' => 'non_veg',
        'Eggetarian' => 'eggetarian',
        'Vegan' => 'vegan',
        _ => state.dietaryPreference.toLowerCase().replaceAll(' ', '_'),
      };

      final updatedProfile = user.copyWith(
        fullName: state.name,
        age: state.age,
        gender: state.gender.toLowerCase(),
        height: state.height,
        currentWeight: state.weight,
        goalType: state.goal.toLowerCase().replaceAll(' ', '_'),
        activityLevel: state.activityLevel.toLowerCase().replaceAll(' ', '_'),
        dietaryPreference: dietaryPref,
        language: state.language,
        dosha: state.dosha,
        healthConditions: state.healthConditions,
        workoutPreferences: state.workoutPreferences,
        onboardingCompleted: true,
      );

      await ref.read(authRepositoryProvider).updateProfile(updatedProfile);
      // Refresh auth controller to reflect new profile
      ref.invalidate(authControllerProvider);
    }
  }
}
