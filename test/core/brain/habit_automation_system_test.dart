import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/habit_automation_system.dart';
import 'package:fitkarma/features/gamification/screens/habit_automation_screen.dart';

void main() {
  group('§P7-C Habit Automation System Tests', () {
    const system = HabitAutomationSystem();

    test('evaluatePostWorkoutProtein schedules 30m post-workout nudge', () {
      final now = DateTime.now();
      final trigger = system.evaluatePostWorkoutProtein(
        workoutEndTime: now,
        loggedProteinGrams: 20,
        targetProteinGrams: 100,
      );

      expect(trigger.id, equals('habit_protein_30m'));
      expect(
          trigger.scheduledTime, equals(now.add(const Duration(minutes: 30))));
      expect(trigger.message, contains('30 mins post-workout'));
    });

    test(
        'evaluateSleepWindDown schedules bedtime wind-down advance window based on sleep debt',
        () {
      final bedtime = DateTime(2026, 8, 8, 23, 0); // 11:00 PM
      final trigger = system.evaluateSleepWindDown(
        usualBedtime: bedtime,
        sleepDebtHours: 2.0, // 45 + 20 = 65m advance
      );

      expect(trigger.id, equals('habit_sleep_winddown'));
      expect(trigger.scheduledTime,
          equals(bedtime.subtract(const Duration(minutes: 65))));
      expect(trigger.message, contains('Bedtime in 65 mins'));
    });

    test('evaluateAdaptiveWater calculates temp & step bonus target', () {
      final trigger = system.evaluateAdaptiveWater(
        ambientTempCelsius: 35.0, // > 32C -> +0.8L
        stepsCount: 10000, // > 8000 -> +0.5L (Total target 3.8L)
        currentWaterLiters: 1.0,
      );

      expect(trigger.contextualPayload['targetLiters'], equals(3.8));
      expect(trigger.contextualPayload['remainingLiters'], equals(2.8));
      expect(trigger.message, contains('High temp (35°C) & 10000 steps'));
    });

    test(
        'evaluateElevatedHrBreathing triggers box breathing when RHR is elevated >= 5 bpm',
        () {
      final trigger = system.evaluateElevatedHrBreathing(
        currentRhr: 72,
        baselineRhr: 65, // +7 bpm
      );

      expect(trigger.message,
          contains('Resting HR is elevated (+7 bpm above baseline)'));
    });

    test('evaluatePostMealWalk schedules 20m postprandial walk nudge', () {
      final mealTime = DateTime.now();
      final trigger = system.evaluatePostMealWalk(
        mealLoggedTime: mealTime,
        mealCarbsGrams: 50.0,
      );

      expect(trigger.id, equals('habit_post_meal_walk'));
      expect(trigger.scheduledTime,
          equals(mealTime.add(const Duration(minutes: 20))));
      expect(trigger.message, contains('20 mins after your 50g carb meal'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'HabitAutomationScreen renders active contextual triggers and updates on completion',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HabitAutomationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Smart Habit Automation'), findsOneWidget);
      expect(find.text('Contextual Smart Triggers'), findsOneWidget);
      expect(
          find.textContaining('Anabolic Window Protein Nudge'), findsOneWidget);
      expect(find.textContaining('Sleep OS Wind-Down Routine'), findsOneWidget);
      expect(find.textContaining('Smart Hydration Nudge'), findsOneWidget);

      // Checkoff habit
      await tester.tap(find.byIcon(Icons.radio_button_unchecked).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });
  });
}
