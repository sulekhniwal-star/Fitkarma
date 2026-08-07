import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/workout/screens/workout_home_screen.dart';

void main() {
  group('§P6-A Workout Screen Home Tests', () {
    testWidgets('WorkoutHomeScreen renders active program card, today session glass card, and recent history', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WorkoutHomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Workout Home'), findsOneWidget);
      expect(find.text('ACTIVE PROGRAM'), findsOneWidget);
      expect(find.text('Corporate Fat Loss'), findsOneWidget);
      expect(find.text("Today's Session"), findsOneWidget);
      expect(find.text('Upper Body Power & Hypertrophy'), findsOneWidget);
      expect(find.text('Suggesting +2.5kg on Bench Press today based on last week RPE 7.0'), findsOneWidget);
      expect(find.text('Start Workout'), findsOneWidget);
      expect(find.text('Recent History'), findsOneWidget);
      expect(find.text('Lower Body Core'), findsOneWidget);
    });
  });
}
