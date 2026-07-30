import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

class OnboardingState {
  final int currentStep;
  final UserProfile profile;
  final bool isComplete;

  const OnboardingState({
    this.currentStep = 0,
    this.profile = const UserProfile(),
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    UserProfile? profile,
    bool? isComplete,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      profile: profile ?? this.profile,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void updateProfile(UserProfile updatedProfile) {
    state = state.copyWith(profile: updatedProfile);
  }

  void nextStep() {
    if (state.currentStep < 6) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    } else {
      state = state.copyWith(isComplete: true);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setStep(int step) {
    if (step >= 0 && step <= 6) {
      state = state.copyWith(currentStep: step);
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
