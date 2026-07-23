import 'package:fitkarma/features/karma/adherence_score_calculator.dart';
import 'package:fitkarma/features/karma/karma_hub_screen.dart';
import 'package:fitkarma/features/karma/karma_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = AdherenceScoreCalculator();
  final now = DateTime(2026, 7, 23);

  const defaultTargets = UserTargets(
    proteinG: 150.0,
    calories: 2000.0,
    workoutsPerWeek: 4,
  );

  group('§P7-D AdherenceScoreCalculator Unit Tests', () {
    test('100% perfect execution yields 100% overall score', () {
      final foodLogs = List.generate(
        7,
        (i) => FoodLogSimple(
          date: now.subtract(Duration(days: i)),
          proteinG: 160.0, // ≥ 80% of 150g (120g)
          calories: 2000.0, // within 1700-2300 kcal (85-115%)
        ),
      );

      final workoutLogs = List.generate(
        4,
        (i) => WorkoutLogSimple(
          date: now.subtract(Duration(days: i)),
          completionPercent: 100.0, // ≥ 80%
        ),
      );

      final recoveryLogs = List.generate(
        7,
        (i) => RecoveryLogSimple(
          date: now.subtract(Duration(days: i)),
          sleepDurationMin: 450, // ≥ 420 min (7h)
          checkedIn: true,
        ),
      );

      final result = calculator.calculate(
        foodLogs: foodLogs,
        workoutLogs: workoutLogs,
        recoveryLogs: recoveryLogs,
        targets: defaultTargets,
        previousWeekOverallScore: 90,
      );

      expect(result.nutritionScore, 100);
      expect(result.trainingScore, 100);
      expect(result.recoveryScore, 100);
      expect(result.overallScore, 100);
      expect(result.trend, AdherenceTrend.improving);
    });

    test('Partial compliance computes exact weighted scores (40/40/20)', () {
      // 3 of 7 days nutrition met -> (3/7)*100 = 43%
      final foodLogs = List.generate(
        3,
        (i) => FoodLogSimple(
          date: now.subtract(Duration(days: i)),
          proteinG: 150.0,
          calories: 2000.0,
        ),
      );

      // 2 of 4 planned workouts completed -> 50%
      final workoutLogs = List.generate(
        2,
        (i) => WorkoutLogSimple(
          date: now.subtract(Duration(days: i)),
          completionPercent: 90.0,
        ),
      );

      // 7 of 7 recovery days met -> 100%
      final recoveryLogs = List.generate(
        7,
        (i) => RecoveryLogSimple(
          date: now.subtract(Duration(days: i)),
          sleepDurationMin: 480,
          checkedIn: true,
        ),
      );

      final result = calculator.calculate(
        foodLogs: foodLogs,
        workoutLogs: workoutLogs,
        recoveryLogs: recoveryLogs,
        targets: defaultTargets,
      );

      expect(result.nutritionScore, 43);
      expect(result.trainingScore, 50);
      expect(result.recoveryScore, 100);
      // Overall: 43*0.4 + 50*0.4 + 100*0.2 = 17.2 + 20 + 20 = 57
      expect(result.overallScore, 57);
    });
  });

  group('§P7-D KarmaHubScreen Adherence Score UI Tests', () {
    testWidgets('Renders Adherence Score section and sub-score bars', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            karmaRepositoryProvider.overrideWithValue(KarmaRepository()),
          ],
          child: const MaterialApp(
            home: KarmaHubScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('📊 Adherence Score'), findsOneWidget);
      expect(find.text('Plan Execution Baseline'), findsOneWidget);
      expect(find.text('Nutrition (40%)'), findsOneWidget);
      expect(find.text('Training (40%)'), findsOneWidget);
      expect(find.text('Recovery (20%)'), findsOneWidget);
      expect(find.textContaining('Improving'), findsOneWidget);
    });
  });
}
