import 'package:fitkarma/features/food/meal_analysis_pipeline.dart';
import 'package:fitkarma/features/food/meal_parser.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared test catalog (mirrors the 15-item FoodReferences seed)
// ─────────────────────────────────────────────────────────────────────────────

final List<FoodCatalogEntry> _catalog = const [
  FoodCatalogEntry(
    id: 'roti_1', foodName: 'Whole Wheat Roti',
    calories: 85, proteinG: 3.0, carbsG: 18, fatG: 0.5,
    fiberG: 2.5, glycemicIndex: 62, satietyIndex: 65,
    searchTerms: ['roti', 'chapati', 'wheat roti', 'fulka', 'phulka'],
  ),
  FoodCatalogEntry(
    id: 'rice_1', foodName: 'Steamed Basmati Rice',
    calories: 200, proteinG: 4.2, carbsG: 44, fatG: 0.4,
    fiberG: 1.0, glycemicIndex: 72, satietyIndex: 50,
    searchTerms: ['rice', 'basmati', 'steamed rice', 'white rice', 'chawal'],
  ),
  FoodCatalogEntry(
    id: 'dal_1', foodName: 'Dal Tadka (Yellow)',
    calories: 150, proteinG: 8.5, carbsG: 22, fatG: 3.5,
    fiberG: 6.0, glycemicIndex: 45, satietyIndex: 75,
    searchTerms: ['dal', 'dal tadka', 'tadka dal', 'yellow dal', 'lentil', 'dhal'],
  ),
  FoodCatalogEntry(
    id: 'paneer_1', foodName: 'Paneer Bhurji',
    calories: 280, proteinG: 18.0, carbsG: 8, fatG: 20,
    fiberG: 2.0, glycemicIndex: 30, satietyIndex: 85,
    searchTerms: ['paneer', 'paneer bhurji', 'bhurji', 'cottage cheese'],
  ),
  FoodCatalogEntry(
    id: 'chick_1', foodName: 'Tandoori Chicken',
    calories: 260, proteinG: 32.0, carbsG: 3, fatG: 12,
    fiberG: 0.5, glycemicIndex: 15, satietyIndex: 90,
    searchTerms: ['chicken', 'tandoori chicken', 'grilled chicken', 'chicken tikka', 'murgh'],
  ),
  FoodCatalogEntry(
    id: 'poha_1', foodName: 'Onion Poha',
    calories: 220, proteinG: 3.5, carbsG: 42, fatG: 4.0,
    fiberG: 2.8, glycemicIndex: 68, satietyIndex: 60,
    searchTerms: ['poha', 'onion poha', 'beaten rice', 'chivda'],
  ),
  FoodCatalogEntry(
    id: 'egg_1', foodName: 'Boiled Egg',
    calories: 78, proteinG: 6.3, carbsG: 0.6, fatG: 5.3,
    fiberG: 0.0, glycemicIndex: 0, satietyIndex: 85,
    searchTerms: ['egg', 'boiled egg', 'hard boiled egg', 'anda', 'ande'],
  ),
  FoodCatalogEntry(
    id: 'curd_1', foodName: 'Whole Milk Curd',
    calories: 98, proteinG: 5.2, carbsG: 6, fatG: 6.0,
    fiberG: 0.0, glycemicIndex: 28, satietyIndex: 72,
    searchTerms: ['curd', 'dahi', 'yogurt', 'yoghurt', 'raita'],
  ),
  FoodCatalogEntry(
    id: 'idli_1', foodName: 'Steamed Idli',
    calories: 120, proteinG: 3.0, carbsG: 26, fatG: 0.2,
    fiberG: 1.5, glycemicIndex: 70, satietyIndex: 58,
    searchTerms: ['idli', 'steamed idli', 'idly', 'idlis'],
  ),
];

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // MealParser tests
  // ─────────────────────────────────────────────────────────────────────────

  group('MealParser', () {
    test('matches single food by search term', () {
      final result = MealParser.parse('roti', _catalog);
      expect(result.items, hasLength(1));
      expect(result.items.first.referenceId, 'roti_1');
      expect(result.items.first.servingMultiplier, 1.0);
      expect(result.unknownTokens, isEmpty);
    });

    test('multiplies serving when numeric quantity is given', () {
      final result = MealParser.parse('2 rotis', _catalog);
      expect(result.items, hasLength(1));
      expect(result.items.first.referenceId, 'roti_1');
      expect(result.items.first.servingMultiplier, 2.0);
    });

    test('handles word quantity "two"', () {
      final result = MealParser.parse('two rotis', _catalog);
      expect(result.items.first.servingMultiplier, 2.0);
    });

    test('handles multi-food input separated by "and"', () {
      final result = MealParser.parse('dal and rice', _catalog);
      final ids = result.items.map((i) => i.referenceId).toList();
      expect(ids, containsAll(['dal_1', 'rice_1']));
      expect(result.unknownTokens, isEmpty);
    });

    test('handles 2-gram search term match "dal tadka"', () {
      final result = MealParser.parse('dal tadka', _catalog);
      expect(result.items, hasLength(1));
      expect(result.items.first.referenceId, 'dal_1');
    });

    test('collects unknownTokens for unrecognised words', () {
      final result = MealParser.parse('pizza', _catalog);
      expect(result.items, isEmpty);
      expect(result.unknownTokens, contains('pizza'));
    });

    test('handles mixed known and unknown tokens', () {
      final result = MealParser.parse('roti and pizza', _catalog);
      expect(result.items.map((i) => i.referenceId), contains('roti_1'));
      expect(result.unknownTokens, contains('pizza'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // LocalMealQualityCalculator tests
  // ─────────────────────────────────────────────────────────────────────────

  group('LocalMealQualityCalculator', () {
    const calc = LocalMealQualityCalculator();

    test('returns 0 when calories is 0', () {
      final score = calc.calculateMealQualityScore(
        calories: 0, proteinG: 0, carbsG: 0, fatG: 0, fiberG: 0, glycemicIndex: 0,
      );
      expect(score, 0.0);
    });

    test('high-protein meal (Tandoori Chicken) scores ≥ 7.0', () {
      // Tandoori Chicken: 260 kcal, 32g protein, 3g carbs, 12g fat, 0.5g fiber, GI 15
      final score = calc.calculateMealQualityScore(
        calories: 260, proteinG: 32, carbsG: 3, fatG: 12, fiberG: 0.5, glycemicIndex: 15,
      );
      expect(score, greaterThanOrEqualTo(7.0));
    });

    test('high-GI rice-only meal scores ≤ 5.0', () {
      // 2 cups rice: 400 kcal, 8.4g protein, 88g carbs, 0.8g fat, 2g fiber, GI 72
      final score = calc.calculateMealQualityScore(
        calories: 400, proteinG: 8.4, carbsG: 88, fatG: 0.8, fiberG: 2.0, glycemicIndex: 72,
      );
      expect(score, lessThanOrEqualTo(5.0));
    });

    test('readiness impact: protein≥20g gives +2', () {
      final impact = calc.calculateReadinessImpact(32, 15, 3);
      expect(impact, 2);
    });

    test('readiness impact: high glycemic load (>25) gives −3', () {
      // carbsG=100, GI=80 → GL=80 > 25
      final impact = calc.calculateReadinessImpact(5, 80, 100);
      expect(impact, -3);
    });

    test('readiness impact: high protein AND high GL gives −1 net', () {
      // protein=30 (+2), carbsG=100, GI=80 → GL=80 (-3) → net -1
      final impact = calc.calculateReadinessImpact(30, 80, 100);
      expect(impact, -1);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // MealAnalysisPipeline tests
  // ─────────────────────────────────────────────────────────────────────────

  group('MealAnalysisPipeline', () {
    const pipeline = MealAnalysisPipeline();

    test('fat-loss aligned: paneer bhurji is <600 kcal with ≥15g protein', () {
      final result = pipeline.analyze(
        rawText: 'paneer bhurji',
        userGoal: UserGoal.fatLoss,
        catalog: _catalog,
      );
      expect(result.goalImpact, GoalImpact.aligned);
    });

    test('muscle-gain misaligned: roti + rice is low protein', () {
      final result = pipeline.analyze(
        rawText: 'roti and rice',
        userGoal: UserGoal.muscleGain,
        catalog: _catalog,
      );
      // roti: 3g + rice: 4.2g = 7.2g < 10g → misaligned
      expect(result.goalImpact, GoalImpact.misaligned);
    });

    test('fix suggestion triggered for low-protein meal (poha)', () {
      final result = pipeline.analyze(
        rawText: 'poha',
        userGoal: UserGoal.generalHealth,
        catalog: _catalog,
      );
      // poha has 3.5g protein < 15g → suggestion expected
      expect(
        result.fixSuggestions,
        anyElement(contains('Add curd, paneer, or an egg')),
      );
    });

    test('full end-to-end: "2 rotis dal tadka" produces correct macros', () {
      final result = pipeline.analyze(
        rawText: '2 rotis dal tadka',
        userGoal: UserGoal.generalHealth,
        catalog: _catalog,
      );
      // 2 × roti(85 kcal) + dal(150 kcal) = 320 kcal
      expect(result.totalCalories, closeTo(320, 5));
      // 2 × roti(3g protein) + dal(8.5g) = 14.5g protein
      expect(result.totalProteinG, closeTo(14.5, 1));
      expect(result.mealQualityScore, greaterThan(0));
      expect(result.parsedItems, hasLength(2));
    });
  });
}
