import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/onboarding/demographics_controller.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Onboarding Steps
// ──────────────────────────────────────────────────────────────────────────────

/// All pages in the onboarding funnel in their canonical order.
/// `welcome` has no progress-bar step count (it is the splash).
/// Steps 1-5 are: goals → demographics → dietPlan → dosha → programSelect
/// `permissions` is the final step (also shown as 5 but is the last).
enum OnboardingStep {
  welcome,
  goals,
  demographics,
  dietPlan,
  dosha,
  programSelect,
  womensHealth,
  permissions,
}

// ──────────────────────────────────────────────────────────────────────────────
// Navigation Rules (per documentation §P1-A)
// ──────────────────────────────────────────────────────────────────────────────

/// Returns the label "N of 5" that should be shown in the progress bar.
/// Welcome has no step count (null). Each subsequent step maps 1-5.
int? stepNumber(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.welcome      => null,
    OnboardingStep.goals        => 1,
    OnboardingStep.demographics => 2,
    OnboardingStep.dietPlan     => 3,
    OnboardingStep.dosha        => 3,
    OnboardingStep.programSelect => 4,
    OnboardingStep.womensHealth => 4,
    OnboardingStep.permissions  => 5,
  };
}

/// Returns true when the user is allowed to skip this step.
/// Demographics (step 2) is REQUIRED — no skip allowed.
bool canSkip(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.welcome       => false,  // no progress bar at all
    OnboardingStep.goals         => true,   // can skip to demographics
    OnboardingStep.demographics  => false,  // REQUIRED — no Skip
    OnboardingStep.dietPlan      => true,
    OnboardingStep.dosha         => true,
    OnboardingStep.programSelect => false,  // must choose a blueprint
    OnboardingStep.womensHealth  => true,
    OnboardingStep.permissions   => true,   // can grant later
  };
}

/// Returns true when a Back button should be shown on this step.
bool canGoBack(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.welcome => false,  // first screen, no back
    _                      => true,
  };
}

/// Maps a step to the previous step in the funnel.
OnboardingStep? previousStep(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.welcome       => null,
    OnboardingStep.goals         => OnboardingStep.welcome,
    OnboardingStep.demographics  => OnboardingStep.goals,
    OnboardingStep.dietPlan      => OnboardingStep.demographics,
    OnboardingStep.dosha         => OnboardingStep.dietPlan,
    OnboardingStep.programSelect => OnboardingStep.dosha,
    OnboardingStep.womensHealth  => OnboardingStep.programSelect,
    OnboardingStep.permissions   => OnboardingStep.womensHealth,
  };
}

/// Maps a step to the next step in the funnel.
OnboardingStep? nextStep(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.welcome       => OnboardingStep.goals,
    OnboardingStep.goals         => OnboardingStep.demographics,
    OnboardingStep.demographics  => OnboardingStep.dietPlan,
    OnboardingStep.dietPlan      => OnboardingStep.dosha,
    OnboardingStep.dosha         => OnboardingStep.programSelect,
    OnboardingStep.programSelect => OnboardingStep.womensHealth,
    OnboardingStep.womensHealth  => OnboardingStep.permissions,
    OnboardingStep.permissions   => null,  // end of onboarding
  };
}

// ──────────────────────────────────────────────────────────────────────────────
// Onboarding Controller State
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingFlowState {
  const OnboardingFlowState({
    this.currentStep = OnboardingStep.welcome,
    this.isComplete = false,
  });

  final OnboardingStep currentStep;
  final bool isComplete;

  OnboardingFlowState copyWith({OnboardingStep? currentStep, bool? isComplete}) {
    return OnboardingFlowState(
      currentStep: currentStep ?? this.currentStep,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Onboarding Flow Controller (Riverpod Notifier)
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingFlowNotifier extends Notifier<OnboardingFlowState> {
  @override
  OnboardingFlowState build() => const OnboardingFlowState();

  OnboardingStep? _resolveNext(OnboardingStep current) {
    var next = nextStep(current);
    if (next == OnboardingStep.womensHealth) {
      final gender = ref.read(demographicsProvider).gender;
      if (gender != Gender.female) {
        next = nextStep(next!);
      }
    }
    return next;
  }

  OnboardingStep? _resolvePrev(OnboardingStep current) {
    var prev = previousStep(current);
    if (prev == OnboardingStep.womensHealth) {
      final gender = ref.read(demographicsProvider).gender;
      if (gender != Gender.female) {
        prev = previousStep(prev!);
      }
    }
    return prev;
  }

  /// Navigate forward to the next step.
  /// Returns the new step, or null if onboarding is complete.
  OnboardingStep? advance() {
    final next = _resolveNext(state.currentStep);
    if (next == null) {
      state = state.copyWith(isComplete: true);
      return null;
    }
    state = state.copyWith(currentStep: next);
    return next;
  }

  /// Navigate back to the previous step (only when [canGoBack] is true).
  /// Returns the previous step, or null if already at welcome.
  OnboardingStep? back() {
    if (!canGoBack(state.currentStep)) return null;
    final prev = _resolvePrev(state.currentStep);
    if (prev == null) return null;
    state = state.copyWith(currentStep: prev);
    return prev;
  }

  /// Skip the current step (only when [canSkip] is true).
  /// Behaves identically to [advance] — moves to the next step.
  OnboardingStep? skip() {
    if (!canSkip(state.currentStep)) return null;
    return advance();
  }

  /// Jump directly to a specific step (e.g. for deep-link restoration).
  void jumpTo(OnboardingStep step) {
    state = state.copyWith(currentStep: step);
  }
}

/// Provider for the onboarding flow state machine.
final onboardingFlowProvider =
    NotifierProvider<OnboardingFlowNotifier, OnboardingFlowState>(
  OnboardingFlowNotifier.new,
);

/// Convenience computed provider — the currently active step.
final currentOnboardingStepProvider = Provider<OnboardingStep>(
  (ref) => ref.watch(onboardingFlowProvider).currentStep,
);

/// Convenience computed provider — step number for the progress bar (null for welcome).
final onboardingStepNumberProvider = Provider<int?>(
  (ref) => stepNumber(ref.watch(currentOnboardingStepProvider)),
);

/// Convenience computed provider — whether the current step can be skipped.
final onboardingCanSkipProvider = Provider<bool>(
  (ref) => canSkip(ref.watch(currentOnboardingStepProvider)),
);

/// Convenience computed provider — whether the Back button should be shown.
final onboardingCanGoBackProvider = Provider<bool>(
  (ref) => canGoBack(ref.watch(currentOnboardingStepProvider)),
);
