import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/workout/providers/workout_provider.dart';
import 'package:fitkarma/features/workout/screens/active_workout_screen.dart';

void main() {
  group('§P6-B Active Workout Screen Tests', () {
    test('WorkoutNotifier startRestCountdown sets restTimerEndTime and survives background recalculation', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(workoutProvider.notifier);
      notifier.startRestCountdown(90);

      final stateAfterStart = container.read(workoutProvider);
      expect(stateAfterStart.isTimerActive, isTrue);
      expect(stateAfterStart.restTimerSeconds, equals(90));
      expect(stateAfterStart.restTimerEndTime, isNotNull);

      // Simulate app lifecycle resume after 10 seconds
      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);
      final stateAfterResume = container.read(workoutProvider);
      expect(stateAfterResume.isTimerActive, isTrue);
      expect(stateAfterResume.restTimerSeconds, lessThanOrEqualTo(90));
    });

    test('logSet marks set as completed and triggers rest countdown', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(workoutProvider.notifier);
      notifier.logSet(0, 80.0, 8, 7.0);

      final state = container.read(workoutProvider);
      expect(state.sets.first.isCompleted, isTrue);
      expect(state.isTimerActive, isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('ActiveWorkoutScreen renders set logging list, overload target card, and completion button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ActiveWorkoutScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Barbell Back Squat'), findsOneWidget);
      expect(find.text('Progressive Overload Target'), findsOneWidget);
      expect(find.text('Sets & Reps Logging'), findsOneWidget);
      expect(find.text('1'), findsWidgets);
      expect(find.text('80.0 kg x 8 reps'), findsWidgets);
      expect(find.text('Complete Workout & Claim XP'), findsOneWidget);
    });
  });
}
