import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/models/indian_food_item.dart';
import 'package:fitkarma/features/nutrition/models/nutrition_adherence_engine.dart';
import 'package:fitkarma/shared/widgets/nutrition_adherence_score_card.dart';

void main() {
  group('§P5-J Nutrition Adherence Engine Tests', () {
    const engine = NutritionAdherenceEngine();

    final item = SeededIndianFoodDatabase.items
        .firstWhere((i) => i.id == 'f1'); // Paneer Tikka

    test(
        'calculateDailyScore awards full 100 points when calories, protein, distinct meals, and timing are on target',
        () {
      final now = DateTime(2026, 8, 7, 8, 30); // 8:30 AM
      final meals = [
        MealEntry(
            id: 'm1', type: MealType.breakfast, foodItem: item, loggedAt: now),
        MealEntry(
            id: 'm2',
            type: MealType.lunch,
            foodItem: item,
            loggedAt: DateTime(2026, 8, 7, 13, 0)),
        MealEntry(
            id: 'm3',
            type: MealType.dinner,
            foodItem: item,
            loggedAt: DateTime(2026, 8, 7, 20, 30)),
      ];

      final log = DailyAdherenceLog(
        totalCalories: 2200.0, // Exact target
        totalProtein: 110.0, // Exact target
        loggedMeals: meals,
      );

      final result = engine.calculateDailyScore(
        log: log,
        targetCalories: 2200.0,
        targetProtein: 110.0,
      );

      expect(result.totalScore, equals(100.0));
      expect(result.caloriePoints, equals(30.0));
      expect(result.proteinPoints, equals(35.0));
      expect(result.loggingCompletenessPoints, equals(20.0));
      expect(result.timingStabilityPoints, equals(15.0));
    });

    test(
        'checkTimingStability returns true when at least 2 meals match customary median times within ±60 minutes',
        () {
      final meals = [
        MealEntry(
            id: 'm1',
            type: MealType.breakfast,
            foodItem: item,
            loggedAt: DateTime(2026, 8, 7, 8, 30)), // 0 min diff
        MealEntry(
            id: 'm2',
            type: MealType.lunch,
            foodItem: item,
            loggedAt: DateTime(2026, 8, 7, 13, 35)), // +35 min diff
      ];

      expect(
          engine.checkTimingStability(meals, const [
            MealTimeMedian(
                type: MealType.breakfast, time: TimeOfDay(hour: 8, minute: 30)),
            MealTimeMedian(
                type: MealType.lunch, time: TimeOfDay(hour: 13, minute: 0)),
          ]),
          isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'NutritionAdherenceScoreCard renders 0-100 badge and 4 matrix breakdown rows',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: NutritionAdherenceScoreCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nutrition Adherence Score'), findsOneWidget);
      expect(find.textContaining('/100'), findsWidgets);
      expect(find.textContaining('Calorie Target'), findsOneWidget);
      expect(find.textContaining('Protein Target'), findsOneWidget);
      expect(find.textContaining('Logging Completeness'), findsOneWidget);
      expect(find.textContaining('Meal Timing Stability'), findsOneWidget);
    });
  });
}
