import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/habit_identity_engine.dart';
import 'package:fitkarma/shared/widgets/you_are_becoming_card.dart';

void main() {
  group('§P8-C Habit Identity Layer Tests', () {
    const engine = HabitIdentityEngine();

    test(
        'checkEvolution unlocks Athlete persona when workouts >= 30 and training adherence >= 85%',
        () {
      const progress = UserProgressData(
        workoutsCompletedTotal: 32,
        consecutiveCompliantWeeks: 5,
        benchPressIncreaseKg: 8.0,
        trainingAdherencePct: 88.0,
        activeProgramName: 'Athletic Build',
        currentProgramWeek: 8,
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        overallAdherenceScore: 88.0,
        workStyle: 'office',
      );

      expect(evolution.isUnlocked, isTrue);
      expect(evolution.persona, equals(IdentityPersona.athlete));
      expect(evolution.title, equals('Athlete'));
      expect(evolution.statement, equals('You are becoming an Athlete'));
      expect(evolution.xpBonus, equals(500));
    });

    test(
        'checkEvolution unlocks Strength Builder when bench press increase >= 10kg & adherence >= 80%',
        () {
      const progress = UserProgressData(
        workoutsCompletedTotal: 28,
        consecutiveCompliantWeeks: 4,
        benchPressIncreaseKg: 12.0,
        trainingAdherencePct: 88.0,
        activeProgramName: 'Athletic Lean Build',
        currentProgramWeek: 6,
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        overallAdherenceScore: 82.0,
        workStyle: 'remote',
      );

      expect(evolution.isUnlocked, isTrue);
      expect(evolution.persona, equals(IdentityPersona.strengthBuilder));
      expect(evolution.title, equals('Strength Builder'));
      expect(evolution.evidenceList.length, equals(3));
      expect(evolution.evidenceList.first, contains('28 workouts completed'));
    });

    test(
        'buildAiCoachSystemPrompt incorporates unlocked identity quote for coaching reinforcement',
        () {
      const progress = UserProgressData(
        workoutsCompletedTotal: 35,
        consecutiveCompliantWeeks: 6,
        benchPressIncreaseKg: 15.0,
        trainingAdherencePct: 90.0,
        activeProgramName: 'Strength OS',
        currentProgramWeek: 10,
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        overallAdherenceScore: 90.0,
        workStyle: 'office',
      );

      final prompt = engine.buildAiCoachSystemPrompt(evolution);
      expect(
          prompt,
          contains(
              'Identity Context: User identity is "You are becoming an Athlete"'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'YouAreBecomingCard renders identity title, evidence, quote, and bonus badge',
        (tester) async {
      const progress = UserProgressData(
        workoutsCompletedTotal: 28,
        consecutiveCompliantWeeks: 4,
        benchPressIncreaseKg: 12.0,
        trainingAdherencePct: 88.0,
        activeProgramName: 'Athletic Lean Build',
        currentProgramWeek: 6,
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        overallAdherenceScore: 82.0,
        workStyle: 'remote',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: YouAreBecomingCard(evolution: evolution)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🏆 Identity Evolution'), findsOneWidget);
      expect(find.text('You are becoming:'), findsOneWidget);
      expect(find.text('🏋️ Strength Builder'), findsOneWidget);
      expect(find.text('Evidence:'), findsOneWidget);
      expect(find.textContaining('28 workouts completed'), findsOneWidget);
      expect(
          find.textContaining('Bench press +12kg since Week 1'), findsWidgets);
      expect(find.textContaining('Strength isn\'t given'), findsOneWidget);
    });
  });
}
