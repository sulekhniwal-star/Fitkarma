import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/nutrition_adherence_controller.dart';
import 'package:fitkarma/features/food/nutrition_adherence_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NutritionAdherenceEngine Unit Tests', () {
    const engine = NutritionAdherenceEngine();

    test(
      '100-Point Perfect Day calculates full scores for all 4 components',
      () {
        final now = DateTime.now();
        final records = [
          MealLogRecord(
            mealType: 'Breakfast',
            loggedAt: DateTime(now.year, now.month, now.day, 8, 30),
          ),
          MealLogRecord(
            mealType: 'Lunch',
            loggedAt: DateTime(now.year, now.month, now.day, 13, 30),
          ),
          MealLogRecord(
            mealType: 'Dinner',
            loggedAt: DateTime(now.year, now.month, now.day, 20, 30),
          ),
        ];

        final result = engine.calculateDailyScore(
          loggedCalories: 2000,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 3,
          mealRecords: records,
        );

        expect(result.calorieScore, 30.0);
        expect(result.proteinScore, 35.0);
        expect(result.loggingScore, 20.0);
        expect(result.timingScore, 15.0);
        expect(result.totalScore, 100.0);
        expect(result.summaryFeedback, contains('Flawless adherence'));
      },
    );

    test(
      'Calorie tolerance bounds award full pts within 10% and scale down to 0 at 25%',
      () {
        // 2000 target. 2180 (+9%) -> 30 pts
        final inBounds = engine.calculateDailyScore(
          loggedCalories: 2180,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 3,
          mealRecords: [],
        );
        expect(inBounds.calorieScore, 30.0);

        // 2400 (+20%) -> partial credit
        final partial = engine.calculateDailyScore(
          loggedCalories: 2400,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 3,
          mealRecords: [],
        );
        expect(partial.calorieScore, greaterThan(0.0));
        expect(partial.calorieScore, lessThan(30.0));

        // 2600 (+30%) -> 0 pts
        final outOfBounds = engine.calculateDailyScore(
          loggedCalories: 2600,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 3,
          mealRecords: [],
        );
        expect(outOfBounds.calorieScore, 0.0);
      },
    );

    test('Protein tolerance bounds award full pts within 15%', () {
      // 100g target. 112g (+12%) -> 35 pts
      final inBounds = engine.calculateDailyScore(
        loggedCalories: 2000,
        targetCalories: 2000,
        loggedProteinG: 112,
        targetProteinG: 100,
        mealsLoggedCount: 3,
        mealRecords: [],
      );
      expect(inBounds.proteinScore, 35.0);

      // 140g (+40%) -> 0 pts
      final outOfBounds = engine.calculateDailyScore(
        loggedCalories: 2000,
        targetCalories: 2000,
        loggedProteinG: 140,
        targetProteinG: 100,
        mealsLoggedCount: 3,
        mealRecords: [],
      );
      expect(outOfBounds.proteinScore, 0.0);
    });

    test(
      'Logging completeness awards 20 pts for 3+ meals, 12 for 2 meals, 6 for 1 meal',
      () {
        final three = engine.calculateDailyScore(
          loggedCalories: 2000,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 3,
          mealRecords: [],
        );
        expect(three.loggingScore, 20.0);

        final two = engine.calculateDailyScore(
          loggedCalories: 2000,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 2,
          mealRecords: [],
        );
        expect(two.loggingScore, 12.0);

        final one = engine.calculateDailyScore(
          loggedCalories: 2000,
          targetCalories: 2000,
          loggedProteinG: 100,
          targetProteinG: 100,
          mealsLoggedCount: 1,
          mealRecords: [],
        );
        expect(one.loggingScore, 6.0);
      },
    );

    test('calculateKarmaAward applies tier base points and streak multipliers', () {
      // Mastery day (>= 90 score) with 7-day streak (1.5x) -> 50 * 1.5 = 75 Karma Points
      final mastery7Day = engine.calculateKarmaAward(95.0, 7);
      expect(mastery7Day.tierName, 'Mastery Day');
      expect(mastery7Day.basePoints, 50);
      expect(mastery7Day.streakMultiplier, 1.5);
      expect(mastery7Day.totalKarmaAwarded, 75);

      // Consistency Hero (75-89 score) with 3-day streak (1.2x) -> 35 * 1.2 = 42 Karma Points
      final hero3Day = engine.calculateKarmaAward(80.0, 3);
      expect(hero3Day.tierName, 'Consistency Hero');
      expect(hero3Day.basePoints, 35);
      expect(hero3Day.totalKarmaAwarded, 42);

      // Effort Logged (< 50 score) with no streak (1.0x) -> 5 Karma Points
      final effort = engine.calculateKarmaAward(40.0, 1);
      expect(effort.tierName, 'Effort Logged');
      expect(effort.totalKarmaAwarded, 5);
    });
  });

  group('adherenceProvider Integration Tests', () {
    test(
      'adherenceProvider reactively computes adherence score & Karma award from foodProvider',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final initialAdherence = container.read(adherenceProvider);
        expect(
          initialAdherence.breakdown.totalScore,
          greaterThanOrEqualTo(0.0),
        );

        // Add high quality meals matching calorie & protein targets
        container
            .read(foodProvider.notifier)
            .addFood(
              const FoodItem(
                id: 'add_1',
                name: 'Chicken Breast & Rice',
                calories: 600,
                protein: 50,
                carbs: 60,
                fat: 10,
                mealType: 'Lunch',
              ),
            );
        container
            .read(foodProvider.notifier)
            .addFood(
              const FoodItem(
                id: 'add_2',
                name: 'Paneer Bowl',
                calories: 500,
                protein: 40,
                carbs: 20,
                fat: 20,
                mealType: 'Dinner',
              ),
            );

        final updatedAdherence = container.read(adherenceProvider);
        expect(updatedAdherence.karmaAward.totalKarmaAwarded, greaterThan(0));
      },
    );
  });
}
