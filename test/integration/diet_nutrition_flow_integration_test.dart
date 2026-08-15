import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/models/local_meal_quality_calculator.dart';
import 'package:fitkarma/features/nutrition/models/indian_food_item.dart';

void main() {
  group('§P14-C Integration: Diet Plan Generation -> 5-Dimension Quality -> Fasting Protocol Sync', () {
    const nutritionEngine = NutritionEngine();
    const localCalculator = LocalMealQualityCalculator();

    test('5-Dimension meal quality calculator scores high protein low GI meal favorably', () {
      final paneerTikka = SeededIndianFoodDatabase.items.firstWhere((i) => i.name == 'Paneer Tikka');

      final quality = nutritionEngine.calculateMealQuality(paneerTikka);

      expect(quality.overallScore, greaterThanOrEqualTo(65));
      expect(quality.macroBalanceScore, greaterThan(40));
      expect(quality.glycemicScore, greaterThan(70)); // Inverted low GI (25 -> 75)
      expect(quality.readinessImpact, contains('+2% readiness'));
    });

    test('LocalMealQualityCalculator evaluates composite score and fasting compliance', () {
      final score = localCalculator.calculateMealQualityScore(
        calories: 380,
        proteinG: 22.0,
        carbsG: 30.0,
        fatG: 10.0,
        fiberG: 6.0,
        glycemicIndex: 35,
      );

      expect(score, greaterThanOrEqualTo(6.0));

      final paneerTikka = SeededIndianFoodDatabase.items.firstWhere((i) => i.name == 'Paneer Tikka');
      final roti = SeededIndianFoodDatabase.items.firstWhere((i) => i.name == 'Whole Wheat Roti');

      // Navratri fasting: paneer is compliant, wheat roti is non-compliant
      expect(localCalculator.isFoodCompliantWithFasting(paneerTikka, FastingProtocolMode.navratriGrainFree), isTrue);
      expect(localCalculator.isFoodCompliantWithFasting(roti, FastingProtocolMode.navratriGrainFree), isFalse);
    });

    test('Calculates cumulative daily logged nutrition across multiple meal entries', () {
      final entries = [
        MealEntry(
          id: '1',
          type: MealType.breakfast,
          foodItem: SeededIndianFoodDatabase.items.firstWhere((i) => i.name == 'Poha with Peanuts'),
          quantityServings: 1.0,
          loggedAt: DateTime.now(),
        ),
        MealEntry(
          id: '2',
          type: MealType.lunch,
          foodItem: SeededIndianFoodDatabase.items.firstWhere((i) => i.name == 'Dal Tadka'),
          quantityServings: 2.0,
          loggedAt: DateTime.now(),
        ),
      ];

      final totalCalories = entries.fold<double>(0.0, (sum, e) => sum + e.totalCalories);
      final totalProtein = entries.fold<double>(0.0, (sum, e) => sum + e.totalProtein);

      expect(totalCalories, equals(250.0 + 300.0)); // 250 + 150*2
      expect(totalProtein, equals(6.5 + 18.0)); // 6.5 + 9.0*2
    });
  });
}
