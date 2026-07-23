import 'package:fitkarma/features/workout/workout_controller.dart';
import 'package:fitkarma/features/workout/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: WorkoutScreen(),
      ),
    );

void main() {
  group('WorkoutScreen UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders WorkoutScreen with active program overview card, weekly progress bar, and today session details', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.byKey(const Key('workout_active_program_card')), findsOneWidget);
      expect(find.text('Active: Corporate Fat Loss'), findsOneWidget);
      expect(find.byKey(const Key('workout_week_day_text')), findsOneWidget);
      expect(find.byKey(const Key('workout_weekly_progress_text')), findsOneWidget);
      expect(find.byKey(const Key('workout_progress_bar')), findsOneWidget);

      expect(find.byKey(const Key('workout_todays_session_card')), findsOneWidget);
      expect(find.text('Upper Body Power & Hypertrophy'), findsOneWidget);
      expect(find.byKey(const Key('workout_progression_badge')), findsOneWidget);
      expect(find.textContaining('Suggesting +2.5kg on Bench Press today'), findsOneWidget);
      expect(find.byKey(const Key('start_workout_btn')), findsOneWidget);
    });

    testWidgets('renders recent workout history items', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      expect(find.text('Recent History:'), findsOneWidget);
      expect(find.byKey(const Key('workout_history_tile_h_1')), findsOneWidget);
      expect(find.text('Lower Body Core'), findsOneWidget);
      expect(find.byKey(const Key('workout_history_tile_h_2')), findsOneWidget);
      expect(find.text('Upper Body Pull'), findsOneWidget);
    });

    testWidgets('tapping Start Workout updates state isWorkoutActive to true', (tester) async {
      await tester.pumpWidget(_buildApp(container));
      await tester.pump();

      await tester.tap(find.byKey(const Key('start_workout_btn')));
      await tester.pump();

      final state = container.read(workoutProvider);
      expect(state.isWorkoutActive, isTrue);
    });
  });
}
