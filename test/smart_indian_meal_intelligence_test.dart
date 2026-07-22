import 'package:fitkarma/features/food/smart_indian_meal_intelligence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegionalOilProfile', () {
    test('returns correct primary oil names for each region', () {
      expect(RegionalOilProfile.getOilNameForRegion(IndianRegion.north), contains('Ghee'));
      expect(RegionalOilProfile.getOilNameForRegion(IndianRegion.south), contains('Coconut'));
      expect(RegionalOilProfile.getOilNameForRegion(IndianRegion.east), contains('Mustard'));
      expect(RegionalOilProfile.getOilNameForRegion(IndianRegion.west), contains('Groundnut'));
    });

    test('returns correct fat multipliers by cooking style', () {
      expect(RegionalOilProfile.getFatMultiplier(CookingStyle.lowOil), 0.70);
      expect(RegionalOilProfile.getFatMultiplier(CookingStyle.homeCooked), 1.00);
      expect(RegionalOilProfile.getFatMultiplier(CookingStyle.restaurantStyle), 1.30);
      expect(RegionalOilProfile.getFatMultiplier(CookingStyle.dhabaStyle), 1.55);
    });
  });

  group('FastingValidator', () {
    const validator = FastingValidator();

    test('Navratri validation flags grains and legumes in North Indian Thali', () {
      final res = validator.validate(
        components: RegionalThaliDataset.northIndianThali.components,
        mode: FastingMode.navratri,
      );

      expect(res.isCompliant, isFalse);
      expect(res.violations, anyElement(contains('Whole Wheat Roti')));
      expect(res.violations, anyElement(contains('Dal Tadka')));
      expect(res.recommendations, anyElement(contains('Sabudana')));
    });

    test('Navratri validation passes Navratri Fasting Thali', () {
      final res = validator.validate(
        components: RegionalThaliDataset.navratriFastingThali.components,
        mode: FastingMode.navratri,
      );

      expect(res.isCompliant, isTrue);
      expect(res.violations, isEmpty);
    });

    test('Ekadashi validation prohibits grains and legumes', () {
      final res = validator.validate(
        components: RegionalThaliDataset.southIndianThali.components,
        mode: FastingMode.ekadashi,
      );

      expect(res.isCompliant, isFalse);
      expect(res.violations, anyElement(contains('Steamed Rice')));
      expect(res.violations, anyElement(contains('Veg Sambar')));
    });
  });

  group('MixedDishMacroEstimator', () {
    const estimator = MixedDishMacroEstimator();

    test('estimates North Indian Thali home-cooked macros accurately', () {
      final res = estimator.estimateTemplate(
        template: RegionalThaliDataset.northIndianThali,
        cookingStyle: CookingStyle.homeCooked,
      );

      expect(res.dishName, 'North Indian Thali');
      expect(res.region, IndianRegion.north);
      expect(res.primaryOilName, contains('Ghee'));
      // Component calories sum: 170 + 150 + 220 + 200 + 65 = 805
      expect(res.totalCalories, closeTo(805, 2));
      // Protein sum: 6 + 8.5 + 14 + 4.2 + 3.5 = 36.2
      expect(res.totalProteinG, closeTo(36.2, 0.5));
    });

    test('Dhaba style cooking increases fat and total calories', () {
      final homeRes = estimator.estimateTemplate(
        template: RegionalThaliDataset.northIndianThali,
        cookingStyle: CookingStyle.homeCooked,
      );

      final dhabaRes = estimator.estimateTemplate(
        template: RegionalThaliDataset.northIndianThali,
        cookingStyle: CookingStyle.dhabaStyle,
      );

      expect(dhabaRes.totalFatG, greaterThan(homeRes.totalFatG));
      expect(dhabaRes.totalCalories, greaterThan(homeRes.totalCalories));
    });

    test('Low oil cooking reduces fat below home cooked baseline', () {
      final homeRes = estimator.estimateTemplate(
        template: RegionalThaliDataset.southIndianThali,
        cookingStyle: CookingStyle.homeCooked,
      );

      final lowOilRes = estimator.estimateTemplate(
        template: RegionalThaliDataset.southIndianThali,
        cookingStyle: CookingStyle.lowOil,
      );

      expect(lowOilRes.totalFatG, lessThan(homeRes.totalFatG));
      expect(lowOilRes.totalCalories, lessThan(homeRes.totalCalories));
    });

    test('Portion multiplier scales macros proportionally', () {
      final res1x = estimator.estimateTemplate(
        template: RegionalThaliDataset.gujaratiThali,
        portionMultiplier: 1.0,
      );

      final res2x = estimator.estimateTemplate(
        template: RegionalThaliDataset.gujaratiThali,
        portionMultiplier: 2.0,
      );

      expect(res2x.totalCalories, closeTo(res1x.totalCalories * 2, 2));
      expect(res2x.totalProteinG, closeTo(res1x.totalProteinG * 2, 1));
    });
  });
}
