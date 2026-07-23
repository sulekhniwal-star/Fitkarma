import 'package:fitkarma/features/workout/active_workout_controller.dart';
import 'package:fitkarma/features/workout/active_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: ActiveWorkoutScreen(),
      ),
    );

void main() {
  group('ActiveWorkoutScreen UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders exercise progress header and set logging table', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.byKey(const Key('exercise_progress_header')), findsOneWidget);
      expect(find.text('Flat Barbell Bench Press'), findsOneWidget);
      expect(find.byKey(const Key('set_logging_table')), findsOneWidget);
      // 4 sets for first exercise
      expect(find.byKey(const Key('set_row_0_0')), findsOneWidget);
      expect(find.byKey(const Key('set_row_0_1')), findsOneWidget);
      expect(find.byKey(const Key('set_row_0_2')), findsOneWidget);
      expect(find.byKey(const Key('set_row_0_3')), findsOneWidget);
    });

    test('completeSet marks set done and accumulates WorkoutLogEntry', () {
      final notifier = container.read(activeWorkoutProvider.notifier);
      final initialState = container.read(activeWorkoutProvider);

      expect(initialState.setStates[0][0].isCompleted, isFalse);

      notifier.completeSet(0, 0);

      final updatedState = container.read(activeWorkoutProvider);
      expect(updatedState.setStates[0][0].isCompleted, isTrue);
      expect(updatedState.workoutLogs, isNotEmpty);
      expect(updatedState.workoutLogs.first.exerciseName, 'Flat Barbell Bench Press');
      // Rest timer should auto-start
      expect(updatedState.isTimerRunning, isTrue);
      expect(updatedState.restTimerSeconds, 90);
    });

    test('addThirtySeconds increases restTimerSeconds by 30', () {
      final notifier = container.read(activeWorkoutProvider.notifier);
      notifier.completeSet(0, 0); // starts timer at 90s
      notifier.addThirtySeconds();

      final state = container.read(activeWorkoutProvider);
      expect(state.restTimerSeconds, 120);
    });

    test('skipRest stops the timer and zeroes seconds', () {
      final notifier = container.read(activeWorkoutProvider.notifier);
      notifier.completeSet(0, 0); // starts timer
      notifier.skipRest();

      final state = container.read(activeWorkoutProvider);
      expect(state.restTimerSeconds, 0);
      expect(state.isTimerRunning, isFalse);
    });

    test('completing all sets sets isWorkoutComplete to true', () {
      final notifier = container.read(activeWorkoutProvider.notifier);
      final state = container.read(activeWorkoutProvider);

      // Mark every set of every exercise as done
      for (int ex = 0; ex < state.session.exercises.length; ex++) {
        for (int s = 0; s < state.session.exercises[ex].targetSets; s++) {
          notifier.completeSet(ex, s);
        }
      }

      final finalState = container.read(activeWorkoutProvider);
      expect(finalState.isWorkoutComplete, isTrue);
    });

    testWidgets('XP burst overlay appears when isWorkoutComplete is true', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      // Complete all sets
      final notifier = container.read(activeWorkoutProvider.notifier);
      final session = container.read(activeWorkoutProvider).session;
      for (int ex = 0; ex < session.exercises.length; ex++) {
        for (int s = 0; s < session.exercises[ex].targetSets; s++) {
          notifier.completeSet(ex, s);
          // Skip rest timer immediately to avoid pending timers
          notifier.skipRest();
        }
      }

      await tester.pump();
      expect(find.byKey(const Key('xp_burst_overlay')), findsOneWidget);
      expect(find.text('Workout Complete!'), findsOneWidget);
      expect(find.text('+250 XP Earned'), findsOneWidget);
    });
  });
}
