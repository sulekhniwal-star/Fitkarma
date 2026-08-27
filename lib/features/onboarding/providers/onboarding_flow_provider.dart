import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/onboarding_flow_step.dart';
import '../domain/onboarding_state.dart';
import '../../metabolism/domain/adaptive_metabolism_engine.dart';

class OnboardingFlowNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void nextStep() {
    final currentIndex = state.currentStep.index;
    
    // Auto-skip Women's Health if male
    if (state.currentStep == OnboardingFlowStep.doshaQuiz && state.sex == BiologicalSex.male) {
      state = state.copyWith(currentStep: OnboardingFlowStep.aiDietResults);
      return;
    }

    if (currentIndex < OnboardingFlowStep.values.length - 1) {
      final next = OnboardingFlowStep.values[currentIndex + 1];
      state = state.copyWith(currentStep: next);
    } else {
      state = state.copyWith(isCompleted: true);
    }
  }

  void previousStep() {
    final currentIndex = state.currentStep.index;
    
    // Auto-skip Women's Health backwards if male
    if (state.currentStep == OnboardingFlowStep.aiDietResults && state.sex == BiologicalSex.male) {
      state = state.copyWith(currentStep: OnboardingFlowStep.doshaQuiz);
      return;
    }

    if (currentIndex > 0) {
      final prev = OnboardingFlowStep.values[currentIndex - 1];
      state = state.copyWith(currentStep: prev);
    }
  }

  void skipStep() {
    if (state.currentStep.canSkip) {
      nextStep();
    }
  }

  void updateGoals(List<String> goals) {
    state = state.copyWith(selectedGoals: goals);
  }

  void updateDemographics({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
    required NutritionGoal goal,
  }) {
    state = state.copyWith(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      sex: sex,
      nutritionGoal: goal,
    );
  }

  void updateDosha(String dosha) {
    state = state.copyWith(primaryDosha: dosha);
  }

  void updateWomensHealth({required bool isPcosAware}) {
    state = state.copyWith(isPcosAware: isPcosAware);
  }

  void selectBlueprint(String blueprintId) {
    state = state.copyWith(selectedBlueprintId: blueprintId);
  }
}

final onboardingFlowProvider = NotifierProvider<OnboardingFlowNotifier, OnboardingState>(() {
  return OnboardingFlowNotifier();
});
