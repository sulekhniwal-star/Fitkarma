import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/satiety_prediction_controller.dart';
import 'package:fitkarma/features/food/satiety_prediction_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SatietyPredictionEngine Unit Tests', () {
    const engine = SatietyPredictionEngine();

    test('Paneer Bhurji yields 90/100 (Ultra-Satisfying 🟢, 4.5 hrs fullness)', () {
      final eval = engine.computeSatietyScore(
        foodName: 'Paneer Bhurji',
        calories: 320,
        proteinG: 24,
        fiberG: 2,
        weightG: 200,
      );

      expect(eval.score, 90.0);
      expect(eval.satietyTier, contains('Ultra-Satisfying'));
      expect(eval.fullnessDurationHours, 4.5);
    });

    test('Rajma Chawal yields 85/100 (Ultra-Satisfying 🟢, 4.0 hrs fullness)', () {
      final eval = engine.computeSatietyScore(
        foodName: 'Rajma Chawal',
        calories: 480,
        proteinG: 22,
        fiberG: 12,
        weightG: 350,
      );

      expect(eval.score, 85.0);
      expect(eval.satietyTier, contains('Ultra-Satisfying'));
      expect(eval.fullnessDurationHours, 4.0);
    });

    test('Deep-Fried Samosa yields 30/100 & recommends high-satiety swap', () {
      final eval = engine.computeSatietyScore(
        foodName: 'Deep-Fried Samosa',
        calories: 310,
        proteinG: 5,
        fiberG: 1,
        weightG: 100,
        processingTier: 3,
      );

      expect(eval.score, 30.0);
      expect(eval.satietyTier, contains('Rapid Crash'));
      expect(eval.recommendedHighSatietySwap, isNotNull);
      expect(eval.recommendedHighSatietySwap, contains('Air-Fried Samosa'));
    });

    test('Indian Chai + Biscuits yields 20/100 & recommends Sattu Drink swap', () {
      final eval = engine.computeSatietyScore(
        foodName: 'Chai + Biscuits',
        calories: 220,
        proteinG: 3,
        fiberG: 0.5,
        weightG: 150,
        processingTier: 3,
      );

      expect(eval.score, 20.0);
      expect(eval.satietyTier, contains('Rapid Crash'));
      expect(eval.recommendedHighSatietySwap, contains('Sattu Drink'));
    });

    test('Computed score is clamped within range [0.0, 100.0]', () {
      final minEval = engine.computeSatietyScore(
        foodName: 'Sugary Soda',
        calories: 300,
        proteinG: 0,
        fiberG: 0,
        weightG: 30,
        processingTier: 3,
      );

      expect(minEval.score, 0.0);
    });
  });

  group('satietyPredictionProvider Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('satietyPredictionProvider computes evaluations reactively from foodProvider', () {
      final initial = container.read(satietyPredictionProvider);
      expect(initial.evaluations, isNotEmpty);

      // Add Chai + Biscuits to foodProvider
      container.read(foodProvider.notifier).addFood(
        const FoodItem(id: 's_chai', name: 'Indian Chai + Biscuits', calories: 220, protein: 3, carbs: 32, fat: 8, mealType: 'Snacks'),
      );

      final updated = container.read(satietyPredictionProvider);
      expect(updated.evaluations.length, greaterThan(initial.evaluations.length));
      expect(updated.highSatietySwapRecommendations, isNotEmpty);
    });
  });
}
