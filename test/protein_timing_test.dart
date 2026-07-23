import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/protein_timing_evaluator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProteinTimingEvaluator Unit Tests', () {
    const evaluator = ProteinTimingEvaluator();

    test('3 main meals meeting 25g MPS threshold receive a 100.0 score', () {
      final items = [
        const FoodItem(
          id: '1',
          name: 'Eggs & Toast',
          calories: 400,
          protein: 28,
          carbs: 40,
          fat: 12,
          mealType: 'Breakfast',
        ),
        const FoodItem(
          id: '2',
          name: 'Chicken Bowl',
          calories: 550,
          protein: 35,
          carbs: 50,
          fat: 15,
          mealType: 'Lunch',
        ),
        const FoodItem(
          id: '3',
          name: 'Paneer Curry',
          calories: 600,
          protein: 30,
          carbs: 45,
          fat: 20,
          mealType: 'Dinner',
        ),
      ];

      final result = evaluator.evaluateDistribution(items);

      expect(result.score, 100.0);
      expect(result.mealsMeetingMps.length, 3);
      expect(result.mealsMissingMps, isEmpty);
      expect(result.timingNudge, contains('Excellent protein timing'));
    });

    test('2 main meals meeting 25g MPS threshold receive a 70.0 score', () {
      final items = [
        const FoodItem(
          id: '1',
          name: 'Fruit Bowl',
          calories: 200,
          protein: 5,
          carbs: 40,
          fat: 2,
          mealType: 'Breakfast',
        ),
        const FoodItem(
          id: '2',
          name: 'Chicken Bowl',
          calories: 550,
          protein: 35,
          carbs: 50,
          fat: 15,
          mealType: 'Lunch',
        ),
        const FoodItem(
          id: '3',
          name: 'Paneer Curry',
          calories: 600,
          protein: 30,
          carbs: 45,
          fat: 20,
          mealType: 'Dinner',
        ),
      ];

      final result = evaluator.evaluateDistribution(items);

      expect(result.score, 70.0);
      expect(result.mealsMeetingMps.length, 2);
      expect(result.mealsMissingMps, contains(MpsMealType.breakfast));
      expect(
        result.suggestedFoodAdditions.any((s) => s.contains('Breakfast')),
        isTrue,
      );
    });

    test('1 main meal meeting 25g MPS threshold receives a 40.0 score', () {
      final items = [
        const FoodItem(
          id: '1',
          name: 'Toast',
          calories: 150,
          protein: 4,
          carbs: 25,
          fat: 3,
          mealType: 'Breakfast',
        ),
        const FoodItem(
          id: '2',
          name: 'Salad',
          calories: 180,
          protein: 6,
          carbs: 15,
          fat: 5,
          mealType: 'Lunch',
        ),
        const FoodItem(
          id: '3',
          name: 'Heavy Dinner',
          calories: 900,
          protein: 75,
          carbs: 80,
          fat: 30,
          mealType: 'Dinner',
        ),
      ];

      final result = evaluator.evaluateDistribution(items);

      expect(result.score, 40.0);
      expect(result.mealsMeetingMps.length, 1);
      expect(result.timingNudge, contains('75g was eaten at Dinner'));
      expect(result.timingNudge, contains('recommend moving'));
    });

    test(
      '0 main meals meeting 25g threshold receive a 10.0 score when meals logged',
      () {
        final items = [
          const FoodItem(
            id: '1',
            name: 'Tea & Biscuit',
            calories: 100,
            protein: 2,
            carbs: 15,
            fat: 3,
            mealType: 'Breakfast',
          ),
          const FoodItem(
            id: '2',
            name: 'Maggi',
            calories: 300,
            protein: 6,
            carbs: 45,
            fat: 10,
            mealType: 'Lunch',
          ),
        ];

        final result = evaluator.evaluateDistribution(items);

        expect(result.score, 10.0);
        expect(result.mealsMeetingMps, isEmpty);
      },
    );

    test('empty logged items returns 0.0 score', () {
      final result = evaluator.evaluateDistribution([]);
      expect(result.score, 0.0);
      expect(result.totalProteinG, 0.0);
    });
  });

  group('proteinTimingProvider Integration Tests', () {
    test(
      'proteinTimingProvider reactively evaluates logged items from foodProvider',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final initialResult = container.read(proteinTimingProvider);
        expect(
          initialResult.score,
          10.0,
        ); // Initial seed item (Masala Dosa 6g) has 0 main meals >= 25g

        // Add high protein meals to hit MPS threshold on all 3 main meals
        container
            .read(foodProvider.notifier)
            .addFood(
              const FoodItem(
                id: 'test_1',
                name: 'Sattu Shake & Eggs',
                calories: 350,
                protein: 26,
                carbs: 20,
                fat: 10,
                mealType: 'Breakfast',
              ),
            );
        container
            .read(foodProvider.notifier)
            .addFood(
              const FoodItem(
                id: 'test_2',
                name: 'Grilled Chicken Bowl',
                calories: 500,
                protein: 35,
                carbs: 40,
                fat: 12,
                mealType: 'Lunch',
              ),
            );
        container
            .read(foodProvider.notifier)
            .addFood(
              const FoodItem(
                id: 'test_3',
                name: 'Paneer Bhurji',
                calories: 400,
                protein: 28,
                carbs: 10,
                fat: 20,
                mealType: 'Dinner',
              ),
            );

        final updatedResult = container.read(proteinTimingProvider);
        expect(updatedResult.score, 100.0);
        expect(
          updatedResult.totalProteinG,
          greaterThan(initialResult.totalProteinG),
        );
      },
    );
  });
}
