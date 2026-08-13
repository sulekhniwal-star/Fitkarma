import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/ai_roast_engine.dart';
import 'package:fitkarma/features/coach/screens/ai_roast_screen.dart';

void main() {
  group('§P12-D AI Roast Mode Tests', () {
    const engine = AiRoastEngine();

    test('generateNudge triggers calorie overshoot roast when calories exceed target by 400', () {
      final nudge = engine.generateNudge(
        tone: CoachTone.roast,
        caloriesConsumed: 2900,
        calorieTarget: 2000,
        loggedMealsCount: 3,
        daysUnlogged: 0,
        isDistressOrHighStressDetected: false,
      );

      expect(nudge.category, equals('Calorie Overshoot Roast'));
      expect(nudge.roastMessage, contains('burned 400 calories and then attacked'));
      expect(nudge.roastMessage, contains('Respect the hustle. Your goals don\'t.'));
    });

    test('generateNudge triggers missing logs roast when 2+ days unlogged', () {
      final nudge = engine.generateNudge(
        tone: CoachTone.roast,
        caloriesConsumed: 0,
        calorieTarget: 2000,
        loggedMealsCount: 0,
        daysUnlogged: 3,
        isDistressOrHighStressDetected: false,
      );

      expect(nudge.category, equals('Missing Logs Roast'));
      expect(nudge.roastMessage, contains('3 days of not logging meals'));
      expect(nudge.roastMessage, contains('missing persons report'));
    });

    test('generateNudge safety protocol auto-disables roast when distress/high stress detected', () {
      final nudge = engine.generateNudge(
        tone: CoachTone.roast,
        caloriesConsumed: 2900,
        calorieTarget: 2000,
        loggedMealsCount: 3,
        daysUnlogged: 0,
        isDistressOrHighStressDetected: true,
      );

      expect(nudge.category, equals('Supportive Nudge'));
      expect(nudge.roastMessage, contains('Your body needs recovery and care today'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('AiRoastScreen renders current AI nudge and personality selector options', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AiRoastScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('AI Coach Tone & Roast Mode'), findsOneWidget);
      expect(find.text('Current AI Nudge'), findsOneWidget);
      expect(find.text('Select AI Coach Personality'), findsOneWidget);
      expect(find.textContaining('Gentle & Supportive'), findsOneWidget);
      expect(find.textContaining('AI Roast Mode'), findsOneWidget);

      await tester.tap(find.textContaining('Gentle & Supportive'));
      await tester.pumpAndSettle();
    });
  });
}
