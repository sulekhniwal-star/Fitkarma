import 'dart:convert';

import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/features/onboarding/goals_controller.dart';
import 'package:fitkarma/features/onboarding/goals_screen.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/shared/widgets/fit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// In-memory AppDatabase for tests.
AppDatabase testDb() => AppDatabase.executor(NativeDatabase.memory());

/// GoRouter that starts on goals and has stubs for adjacent routes.
GoRouter _goalsRouter() => GoRouter(
  initialLocation: AppRoutes.onboardingGoals,
  routes: [
    GoRoute(
      path: AppRoutes.onboardingWelcome,
      builder: (_, __) => const Scaffold(body: Text('Welcome')),
    ),
    GoRoute(
      path: AppRoutes.onboardingGoals,
      builder: (_, __) => const GoalsScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboardingDemographics,
      builder: (_, __) => const Scaffold(body: Text('Demographics')),
    ),
  ],
);

/// Wraps the test subject in an [UncontrolledProviderScope] backed by [container].
Widget buildSubject(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: _goalsRouter()),
  );
}

// ── Unit Tests — GoalsController ─────────────────────────────────────────────

void main() {
  group('OnboardingGoalsNotifier logic', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('initially has empty selections', () {
      final state = container.read(onboardingGoalsProvider);
      expect(state.selectedGoals, isEmpty);
      expect(state.showTargetWeightSlider, isFalse);
    });

    test('toggleGoal adds a goal when under limit', () {
      final notifier = container.read(onboardingGoalsProvider.notifier);
      final result = notifier.toggleGoal('weight_loss');
      expect(result, isTrue);
      expect(container.read(onboardingGoalsProvider).selectedGoals, contains('weight_loss'));
    });

    test('toggleGoal deselects an already-selected goal', () {
      final notifier = container.read(onboardingGoalsProvider.notifier);
      notifier.toggleGoal('weight_loss');
      notifier.toggleGoal('weight_loss');
      expect(container.read(onboardingGoalsProvider).selectedGoals, isEmpty);
    });

    test('toggleGoal returns false and does not add when max 3 is reached', () {
      final notifier = container.read(onboardingGoalsProvider.notifier);
      notifier.toggleGoal('weight_loss');
      notifier.toggleGoal('muscle_gain');
      notifier.toggleGoal('heart_health');
      final result = notifier.toggleGoal('general_fitness');
      expect(result, isFalse);
      expect(container.read(onboardingGoalsProvider).selectedGoals.length, 3);
    });

    test('showTargetWeightSlider is true when weight_loss selected', () {
      container.read(onboardingGoalsProvider.notifier).toggleGoal('weight_loss');
      expect(container.read(onboardingGoalsProvider).showTargetWeightSlider, isTrue);
    });

    test('showTargetWeightSlider is true when muscle_gain selected', () {
      container.read(onboardingGoalsProvider.notifier).toggleGoal('muscle_gain');
      expect(container.read(onboardingGoalsProvider).showTargetWeightSlider, isTrue);
    });

    test('showTargetWeightSlider is false for non-weight goals', () {
      container.read(onboardingGoalsProvider.notifier).toggleGoal('heart_health');
      expect(container.read(onboardingGoalsProvider).showTargetWeightSlider, isFalse);
    });

    test('updateTargetWeight updates state', () {
      container.read(onboardingGoalsProvider.notifier).updateTargetWeight(80.5);
      expect(container.read(onboardingGoalsProvider).targetWeight, 80.5);
    });

    test('saveToDb writes goals JSON and targetWeight to database', () async {
      final db = testDb();
      addTearDown(db.close);

      // Seed a user row first
      await db.into(db.users).insert(UsersCompanion.insert(id: 'user1'));

      final notifier = container.read(onboardingGoalsProvider.notifier);
      notifier.toggleGoal('weight_loss');
      notifier.toggleGoal('heart_health');
      notifier.updateTargetWeight(68.0);

      await notifier.saveToDb(db, 'user1');

      final user = await (db.select(db.users)
            ..where((u) => u.id.equals('user1')))
          .getSingle();
      expect(user.goals, isNotNull);

      final decoded = jsonDecode(user.goals!) as List;
      expect(decoded, containsAll(['weight_loss', 'heart_health']));
      expect(user.targetWeight, 68.0);
    });
  });

  // ── Widget Tests — GoalsScreen ─────────────────────────────────────────────

  group('GoalsScreen widget', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });
    tearDown(() => container.dispose());

    testWidgets('renders progress indicator at step 1 of 5', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      expect(find.textContaining('1 of 5'), findsOneWidget);
    });

    testWidgets('renders all 6 goal chips', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();
      for (final goal in GoalOption.all) {
        expect(find.textContaining(goal.label), findsOneWidget);
      }
    });

    testWidgets('Continue button is disabled when nothing selected', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      final btn = tester.widget<FitButton>(find.byKey(const Key('goals_continue_btn')));
      expect(btn.onPressed, isNull);
    });

    testWidgets('tapping a goal chip enables Continue button', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      await tester.tap(find.textContaining('Weight Loss'));
      await tester.pumpAndSettle();

      final btn = tester.widget<FitButton>(find.byKey(const Key('goals_continue_btn')));
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('target weight slider appears when weight_loss is selected', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      // Not visible yet
      expect(find.byKey(const Key('goals_target_weight_slider')), findsNothing);

      await tester.tap(find.textContaining('Weight Loss'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('goals_target_weight_slider')), findsOneWidget);
    });

    testWidgets('target weight slider hidden for non-weight goal', (tester) async {
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      await tester.tap(find.textContaining('Heart Health'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('goals_target_weight_slider')), findsNothing);
    });

    testWidgets('Continue navigates to Demographics', (tester) async {
      // Pre-seed the flow controller to goals step before rendering
      container.read(onboardingFlowProvider.notifier).jumpTo(OnboardingStep.goals);
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      await tester.tap(find.textContaining('Weight Loss'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('goals_continue_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Demographics'), findsOneWidget);
    });

    testWidgets('Skip navigates to Demographics', (tester) async {
      // Pre-seed the flow controller to goals step before rendering
      container.read(onboardingFlowProvider.notifier).jumpTo(OnboardingStep.goals);
      await tester.pumpWidget(buildSubject(container));
      await tester.pump();

      expect(find.byKey(const Key('goals_skip_btn')), findsOneWidget);
      await tester.tap(find.byKey(const Key('goals_skip_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Demographics'), findsOneWidget);
    });
  });
}
