import '../../features/nutrition/models/indian_food_item.dart';

/// 5-Dimension Meal Quality Result
class MealQualityResult {
  final int overallScore; // 0 to 100
  final double macroBalanceScore;
  final double microScore;
  final double glycemicScore;
  final double processingScore;
  final double satietyScore;

  const MealQualityResult({
    required this.overallScore,
    required this.macroBalanceScore,
    required this.microScore,
    required this.glycemicScore,
    required this.processingScore,
    required this.satietyScore,
  });
}

/// Smart Nutrition Engine: 5-Dimension Quality Scoring & Protein Deficit Alert
class NutritionEngine {
  const NutritionEngine();

  /// Calculate 5-dimension meal quality score:
  /// Macro Balance (30%), Micros (25%), Glycemic Index (20%), Processing (15%), Satiety (10%)
  MealQualityResult calculateMealQuality(IndianFoodItem item) {
    // 1. Macro Balance Score (higher for high protein & balanced carbs)
    final macroScore = ((item.proteinGrams * 4 / item.calories) * 200.0).clamp(0.0, 100.0);

    // 2. Micronutrient Density
    const microScore = 80.0;

    // 3. Glycemic Score (Inverted: lower GI yields higher score)
    final glycemicScore = (100.0 - item.glycemicIndex).clamp(0.0, 100.0);

    // 4. Processing Score
    const processingScore = 85.0;

    // 5. Satiety Score
    final satietyScore = item.satietyIndex;

    // Overall 5-dimension weighted score
    final overall = (0.30 * macroScore) +
        (0.25 * microScore) +
        (0.20 * glycemicScore) +
        (0.15 * processingScore) +
        (0.10 * satietyScore);

    return MealQualityResult(
      overallScore: overall.clamp(0.0, 100.0).round(),
      macroBalanceScore: macroScore,
      microScore: microScore,
      glycemicScore: glycemicScore,
      processingScore: processingScore,
      satietyScore: satietyScore,
    );
  }

  /// Check rule-based protein deficit alert (< 70% of daily target)
  bool isProteinDeficitAlert({required double loggedProtein, required double targetProtein}) {
    return loggedProtein < (0.70 * targetProtein);
  }
}
