import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/nutrition/models/seeded_indian_food_database_matrix.dart';
import 'package:fitkarma/features/nutrition/models/local_meal_quality_calculator.dart';

void main() {
  group('§P5-D Smart Indian Meal Intelligence Tests', () {
    const calculator = LocalMealQualityCalculator();

    // ── Seeded Food Matrix Database Tests ────────────────────────────────────

    test(
        'SeededIndianFoodDatabaseMatrix contains full reference items with macro/GI values',
        () {
      expect(SeededIndianFoodDatabaseMatrix.matrix.length, equals(15));

      final roti = SeededIndianFoodDatabaseMatrix.matrix
          .firstWhere((i) => i.id == 'roti_1');
      expect(roti.calories, equals(85));
      expect(roti.proteinGrams, equals(3.0));

      final paneer = SeededIndianFoodDatabaseMatrix.matrix
          .firstWhere((i) => i.id == 'paneer_1');
      expect(paneer.proteinGrams, equals(18.0));
      expect(paneer.satietyIndex, equals(85.0));
    });

    // ── Local Meal Quality Score Calculator Tests ─────────────────────────────

    test(
        'calculateMealQualityScore computes 10.0 scale quality score using 4-component formula',
        () {
      final score = calculator.calculateMealQualityScore(
        calories: 500,
        proteinG: 30.0,
        carbsG: 50.0,
        fatG: 15.0,
        fiberG: 8.0,
        glycemicIndex: 40,
      );

      expect(score, greaterThanOrEqualTo(0.0));
      expect(score, lessThanOrEqualTo(10.0));
    });

    test('calculateSatietyIndex computes weighted satiety between 10 and 100',
        () {
      final index = calculator.calculateSatietyIndex(25.0, 6.0, 10.0, 30.0);
      expect(index, greaterThanOrEqualTo(10.0));
      expect(index, lessThanOrEqualTo(100.0));
    });

    test(
        'calculateReadinessImpact adds +2% for high protein and subtracts -3% for high GL crash',
        () {
      final positiveImpact =
          calculator.calculateReadinessImpact(22.0, 30, 20.0);
      expect(positiveImpact, equals(2));

      final negativeImpact = calculator.calculateReadinessImpact(
          5.0, 75, 40.0); // GL = (40*75)/100 = 30 > 25
      expect(negativeImpact, equals(-3));
    });

    // ── Core Nutrition Adaptations Tests ─────────────────────────────────────

    test(
        'estimateCompositeThali aggregates thali items and incorporates regional oil estimation',
        () {
      final roti = SeededIndianFoodDatabaseMatrix.matrix
          .firstWhere((i) => i.id == 'roti_1');
      final dal = SeededIndianFoodDatabaseMatrix.matrix
          .firstWhere((i) => i.id == 'dal_1');

      final thali = calculator.estimateCompositeThali(
        components: [roti, dal],
        region: IndianRegionOilProfile.northGheeMustard,
      );

      expect(thali.calories, greaterThan(roti.calories + dal.calories));
      expect(thali.fatGrams,
          equals(roti.fatGrams + dal.fatGrams + 12.0)); // +12g ghee
      expect(thali.category, equals('Thali Composite'));
    });

    test(
        'isFoodCompliantWithFasting filters grain foods during Navratri / Ekadashi mode',
        () {
      final roti = SeededIndianFoodDatabaseMatrix.matrix
          .firstWhere((i) => i.id == 'roti_1');
      final curd = SeededIndianFoodDatabaseMatrix.matrix
          .firstWhere((i) => i.id == 'curd_1');

      expect(
          calculator.isFoodCompliantWithFasting(
              roti, FastingProtocolMode.navratriGrainFree),
          isFalse);
      expect(
          calculator.isFoodCompliantWithFasting(
              curd, FastingProtocolMode.navratriGrainFree),
          isTrue);
    });

    test(
        'getFestivalCalorieBufferModifier returns +200 kcal buffer during Diwali week',
        () {
      expect(calculator.getFestivalCalorieBufferModifier(isFestivalWeek: true),
          equals(200.0));
      expect(calculator.getFestivalCalorieBufferModifier(isFestivalWeek: false),
          equals(0.0));
    });
  });
}
