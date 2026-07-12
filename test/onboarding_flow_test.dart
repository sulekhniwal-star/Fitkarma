import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer makeContainer() => ProviderContainer();

  group('OnboardingFlowController navigation', () {
    test('starts at welcome step', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      expect(
        container.read(currentOnboardingStepProvider),
        OnboardingStep.welcome,
      );
    });

    test('advance() walks through all steps in order', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingFlowProvider.notifier);
      final expectedOrder = [
        OnboardingStep.goals,
        OnboardingStep.demographics,
        OnboardingStep.dietPlan,
        OnboardingStep.dosha,
        OnboardingStep.programSelect,
        OnboardingStep.permissions,
      ];

      for (final expected in expectedOrder) {
        final result = notifier.advance();
        expect(result, expected);
        expect(container.read(currentOnboardingStepProvider), expected);
      }

      // One more advance should complete onboarding
      final done = notifier.advance();
      expect(done, isNull);
      expect(container.read(onboardingFlowProvider).isComplete, isTrue);
    });

    test('back() navigates to previous step', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingFlowProvider.notifier);

      // Advance to demographics
      notifier.advance(); // → goals
      notifier.advance(); // → demographics

      expect(container.read(currentOnboardingStepProvider), OnboardingStep.demographics);

      final prev = notifier.back();
      expect(prev, OnboardingStep.goals);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.goals);
    });

    test('back() on welcome returns null', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingFlowProvider.notifier);
      final result = notifier.back();
      expect(result, isNull);
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.welcome);
    });

    test('skip() advances when allowed, returns null for demographics', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(onboardingFlowProvider.notifier);

      // welcome → goals (skip not allowed on welcome, so advance manually)
      notifier.advance(); // → goals

      // goals is skippable
      expect(container.read(onboardingCanSkipProvider), isTrue);
      final skipped = notifier.skip();
      expect(skipped, OnboardingStep.demographics);

      // demographics is NOT skippable
      expect(container.read(onboardingCanSkipProvider), isFalse);
      final skipDenied = notifier.skip();
      expect(skipDenied, isNull);
      // should still be on demographics
      expect(container.read(currentOnboardingStepProvider), OnboardingStep.demographics);
    });
  });

  group('Navigation rules helpers', () {
    test('canGoBack returns false only for welcome', () {
      expect(canGoBack(OnboardingStep.welcome), isFalse);
      for (final step in OnboardingStep.values.where((s) => s != OnboardingStep.welcome)) {
        expect(canGoBack(step), isTrue);
      }
    });

    test('canSkip returns false for demographics and programSelect', () {
      expect(canSkip(OnboardingStep.demographics), isFalse);
      expect(canSkip(OnboardingStep.programSelect), isFalse);
    });

    test('stepNumber returns null for welcome and 1-5 for rest', () {
      expect(stepNumber(OnboardingStep.welcome), isNull);
      expect(stepNumber(OnboardingStep.goals), 1);
      expect(stepNumber(OnboardingStep.demographics), 2);
      expect(stepNumber(OnboardingStep.permissions), 5);
    });
  });
}
