import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/adherence_score_calculator.dart';
import 'package:fitkarma/shared/widgets/adherence_score_widget.dart';

void main() {
  group('§P7-D Adherence Score Calculator & Widget Tests', () {
    const calculator = AdherenceScoreCalculator();

    const targets = UserTargets(
      proteinG: 120.0,
      calories: 2000.0,
      workoutsPerWeek: 4,
    );

    final now = DateTime.now();

    final foodLogs = List.generate(
      6,
      (i) => FoodLogItem(proteinG: 100.0, calories: 1950.0, date: now.subtract(Duration(days: i))),
    );

    final workoutLogs = List.generate(
      3,
      (i) => WorkoutLogItem(completionPercent: 90.0, date: now.subtract(Duration(days: i))),
    );

    final recoveryLogs = List.generate(
      6,
      (i) => RecoveryLogItem(sleepDurationMin: 450, checkedIn: true, date: now.subtract(Duration(days: i))),
    );

    test('calculate computes 40% Nutrition + 40% Training + 20% Recovery adherence score per §P7-D formula', () {
      final res = calculator.calculate(
        foodLogs: foodLogs,
        workoutLogs: workoutLogs,
        recoveryLogs: recoveryLogs,
        targets: targets,
        previousOverallScore: 78,
      );

      // Nutrition: 6/7 = 86%
      // Training: 3/4 = 75%
      // Recovery: 6/7 = 86%
      // Overall: (86*0.4) + (75*0.4) + (86*0.2) = 34.4 + 30 + 17.2 = 81.6 -> 82%
      expect(res.nutritionScore, equals(86));
      expect(res.trainingScore, equals(75));
      expect(res.recoveryScore, equals(86));
      expect(res.overallScore, equals(82));
      expect(res.weakestArea, equals('Training'));
      expect(res.trend, equals(AdherenceTrend.improving));
      expect(res.xpMultiplier, equals(1.0));
      expect(res.triggersCoachCheckIn, isFalse);
    });

    test('Adherence >= 90% unlocks +50% XP multiplier (1.5x)', () {
      final perfectFood = List.generate(
        7,
        (i) => FoodLogItem(proteinG: 120.0, calories: 2000.0, date: now.subtract(Duration(days: i))),
      );
      final perfectWorkout = List.generate(
        4,
        (i) => WorkoutLogItem(completionPercent: 100.0, date: now.subtract(Duration(days: i))),
      );
      final perfectRecovery = List.generate(
        7,
        (i) => RecoveryLogItem(sleepDurationMin: 480, checkedIn: true, date: now.subtract(Duration(days: i))),
      );

      final res = calculator.calculate(
        foodLogs: perfectFood,
        workoutLogs: perfectWorkout,
        recoveryLogs: perfectRecovery,
        targets: targets,
      );

      expect(res.overallScore, equals(100));
      expect(res.xpMultiplier, equals(1.5));
      expect(res.triggersCoachCheckIn, isFalse);
    });

    test('Adherence < 70% triggers AI Coach proactive check-in', () {
      final res = calculator.calculate(
        foodLogs: const [],
        workoutLogs: const [],
        recoveryLogs: const [],
        targets: targets,
      );

      expect(res.overallScore, equals(0));
      expect(res.triggersCoachCheckIn, isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('AdherenceScoreWidget renders breakdown bars, weakest area, and boost badges', (tester) async {
      final res = calculator.calculate(
        foodLogs: foodLogs,
        workoutLogs: workoutLogs,
        recoveryLogs: recoveryLogs,
        targets: targets,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AdherenceScoreWidget(result: res)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('📊 Adherence Score'), findsOneWidget);
      expect(find.text('82%'), findsOneWidget);
      expect(find.text('Nutrition'), findsOneWidget);
      expect(find.text('Training'), findsOneWidget);
      expect(find.text('Recovery'), findsOneWidget);
      expect(find.text('Your weakest area: Training'), findsOneWidget);
    });
  });
}
