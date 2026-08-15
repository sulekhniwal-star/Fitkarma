import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';
import 'package:fitkarma/features/nutrition/models/indian_food_item.dart';

void main() {
  group('NutritionEngine 5-Dimension Quality Score & Protein Alert Tests', () {
    const engine = NutritionEngine();

    test('High protein Indian dish (Paneer Tikka) yields high quality score',
        () {
      final item = SeededIndianFoodDatabase.items[0]; // Paneer Tikka
      final quality = engine.calculateMealQuality(item);

      expect(quality.overallScore, greaterThanOrEqualTo(70));
    });

    test(
        'Protein deficit alert triggers when logged protein is under 70% of target',
        () {
      final hasDeficit = engine.isProteinDeficitAlert(
        loggedProtein: 50.0,
        targetProtein: 120.0, // 50 / 120 = 41% (< 70%)
      );

      expect(hasDeficit, isTrue);
    });

    test(
        'Protein deficit alert does not trigger when logged protein exceeds 70%',
        () {
      final hasDeficit = engine.isProteinDeficitAlert(
        loggedProtein: 95.0,
        targetProtein: 120.0, // 95 / 120 = 79% (> 70%)
      );

      expect(hasDeficit, isFalse);
    });
  });
}
