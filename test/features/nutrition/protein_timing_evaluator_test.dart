import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/models/indian_food_item.dart';
import 'package:fitkarma/features/nutrition/models/protein_timing_evaluator.dart';
import 'package:fitkarma/shared/widgets/protein_timing_intelligence_card.dart';

void main() {
  group('§P5-H Protein Distribution & Timing Intelligence Tests', () {
    const evaluator = ProteinTimingEvaluator();
    final now = DateTime.now();

    final highProteinItem = SeededIndianFoodDatabase.items.firstWhere((i) => i.id == 'f8'); // Chicken Curry (28g)
    final lowProteinItem = SeededIndianFoodDatabase.items.firstWhere((i) => i.id == 'f3');  // Roti (3.5g)

    test('evaluateDistribution awards 100 timing score when all 3 main meals meet 25g MPS threshold', () {
      final meals = [
        MealEntry(id: 'm1', type: MealType.breakfast, foodItem: highProteinItem, loggedAt: now),
        MealEntry(id: 'm2', type: MealType.lunch, foodItem: highProteinItem, loggedAt: now),
        MealEntry(id: 'm3', type: MealType.dinner, foodItem: highProteinItem, loggedAt: now),
      ];

      final result = evaluator.evaluateDistribution(meals);

      expect(result.score, equals(100.0));
      expect(result.mpsMealsMetCount, equals(3));
      expect(result.feedback, contains('Optimal Muscle Protein Synthesis'));
    });

    test('evaluateDistribution awards 70 timing score for 2 meals met and 40 for 1 meal met', () {
      final mealsTwoMet = [
        MealEntry(id: 'm1', type: MealType.breakfast, foodItem: highProteinItem, loggedAt: now),
        MealEntry(id: 'm2', type: MealType.lunch, foodItem: highProteinItem, loggedAt: now),
        MealEntry(id: 'm3', type: MealType.dinner, foodItem: lowProteinItem, loggedAt: now),
      ];

      final resultTwo = evaluator.evaluateDistribution(mealsTwoMet);
      expect(resultTwo.score, equals(70.0));
      expect(resultTwo.mpsMealsMetCount, equals(2));

      final mealsOneMet = [
        MealEntry(id: 'm1', type: MealType.breakfast, foodItem: lowProteinItem, loggedAt: now),
        MealEntry(id: 'm2', type: MealType.lunch, foodItem: lowProteinItem, loggedAt: now),
        MealEntry(id: 'm3', type: MealType.dinner, foodItem: highProteinItem, loggedAt: now),
      ];

      final resultOne = evaluator.evaluateDistribution(mealsOneMet);
      expect(resultOne.score, equals(40.0));
      expect(resultOne.mpsMealsMetCount, equals(1));
    });

    test('generateTimingNudge suggests shifting protein from dinner to breakfast when dinner is skewed', () {
      final skewedMeals = [
        MealEntry(id: 'm1', type: MealType.breakfast, foodItem: lowProteinItem, loggedAt: now), // 3.5g
        MealEntry(id: 'm2', type: MealType.lunch, foodItem: lowProteinItem, loggedAt: now),     // 3.5g
        MealEntry(id: 'm3', type: MealType.dinner, foodItem: highProteinItem, quantityServings: 2.5, loggedAt: now), // 70g
      ];

      final result = evaluator.evaluateDistribution(skewedMeals);
      expect(result.feedback, contains('moving'));
      expect(result.feedback, contains('from dinner to breakfast'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('ProteinTimingIntelligenceCard renders MPS pills and timing score', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ProteinTimingIntelligenceCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MPS Protein Timing'), findsOneWidget);
      expect(find.textContaining('Timing Score:'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
    });
  });
}
