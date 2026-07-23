import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/meal_quality_display_card.dart';
import 'package:fitkarma/features/food/multi_dimensional_meal_quality_controller.dart';
import 'package:fitkarma/features/food/multi_dimensional_meal_quality_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
  container: container,
  child: const MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(child: MealQualityDisplayCard()),
    ),
  ),
);

void main() {
  group('MultiDimensionalMealQualityEngine Unit Tests', () {
    const engine = MultiDimensionalMealQualityEngine();

    test(
      '600 kcal Rajma Rice + Curd + Salad (Tier 0, 28g Pro, 12g Fiber, Satiety 4.5) yields ~85/100 Grade S',
      () {
        final result = engine.calculateCompositeQualityScore(
          calories: 600,
          proteinG: 28,
          fiberG: 12,
          satietyIndex1To5: 4.5,
          processingTier: ProcessingTier.wholeFood,
        );

        // Formula: (2.5 * (28*100/600=4.67=11.67)) + (3 * 12=36) + (20 * 4.5=90) - 0 = 137.67 -> clamped 100.0 (or ~85+ depending on inputs)
        expect(result.score, greaterThanOrEqualTo(85.0));
        expect(result.grade, contains('S - Superfood'));
        expect(result.breakdownSummary, contains('Flawless nutrient density'));
      },
    );

    test(
      '600 kcal Fast Food Pizza (Tier 3, 18g Pro, 1.5g Fiber, Satiety 1.5) yields ~35/100 Grade C/D',
      () {
        final result = engine.calculateCompositeQualityScore(
          calories: 600,
          proteinG: 18,
          fiberG: 1.5,
          satietyIndex1To5: 1.5,
          processingTier: ProcessingTier.ultraProcessed,
        );

        // Formula: (2.5 * 3.0 = 7.5) + (3 * 1.5 = 4.5) + (20 * 1.5 = 30) - (15 * 3 = 45) = -3.0 -> clamped to 0.0 or <= 35.0
        expect(result.score, lessThanOrEqualTo(35.0));
        expect(result.processingTier, ProcessingTier.ultraProcessed);
        expect(
          result.breakdownSummary,
          contains('Ultra-processed food penalty'),
        );
      },
    );

    test('Score is clamped within range [0.0, 100.0]', () {
      final zero = engine.calculateCompositeQualityScore(
        calories: 500,
        proteinG: 0,
        fiberG: 0,
        satietyIndex1To5: 1.0,
        processingTier: ProcessingTier.ultraProcessed,
      );
      expect(zero.score, 0.0);

      final max = engine.calculateCompositeQualityScore(
        calories: 400,
        proteinG: 40,
        fiberG: 20,
        satietyIndex1To5: 5.0,
        processingTier: ProcessingTier.wholeFood,
      );
      expect(max.score, 100.0);
    });
  });

  group('MealQualityDisplayCard UI & Controller Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets(
      'renders MealQualityDisplayCard with 100-point gauge and grade badge',
      (tester) async {
        await tester.pumpWidget(_buildApp(container));
        await tester.pump();

        expect(
          find.byKey(const Key('meal_quality_display_card')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('meal_quality_score_text')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('meal_quality_grade_badge')),
          findsOneWidget,
        );
        expect(find.text('Protein Density (2.5x)'), findsOneWidget);
      },
    );

    testWidgets(
      'adding logged foods updates meal quality score and grade badge',
      (tester) async {
        await tester.pumpWidget(_buildApp(container));
        await tester.pump();

        // Add high quality Rajma Chana Bowl
        container
            .read(foodProvider.notifier)
            .addFood(
              const FoodItem(
                id: 'test_q1',
                name: 'Rajma Chana Bowl',
                calories: 400,
                protein: 25,
                carbs: 45,
                fat: 8,
                mealType: 'Lunch',
              ),
            );
        await tester.pump();

        final state = container.read(multiDimensionalMealQualityProvider);
        expect(state.dailyCompositeScore, greaterThan(0.0));
        expect(state.dailyGrade, isNotEmpty);
      },
    );
  });
}
