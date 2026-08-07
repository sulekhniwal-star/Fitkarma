import '../../features/nutrition/models/indian_food_item.dart';

/// Extended Meal Section Enum per §P5-A
enum MealType { breakfast, lunch, dinner, snacks }

extension MealTypeStyle on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return '🌅 Breakfast';
      case MealType.lunch:
        return '☀️ Lunch';
      case MealType.dinner:
        return '🌙 Dinner';
      case MealType.snacks:
        return '🍎 Snacks';
    }
  }
}

/// Single Logged Meal Entry in a Meal Section
class MealEntry {
  final String id;
  final MealType type;
  final IndianFoodItem foodItem;
  final double quantityServings;
  final DateTime loggedAt;

  const MealEntry({
    required this.id,
    required this.type,
    required this.foodItem,
    this.quantityServings = 1.0,
    required this.loggedAt,
  });

  double get totalCalories => foodItem.calories * quantityServings;
  double get totalProtein => foodItem.proteinGrams * quantityServings;
  double get totalCarbs => foodItem.carbsGrams * quantityServings;
  double get totalFat => foodItem.fatGrams * quantityServings;
}

/// 5-Dimension Meal Quality Result (with Readiness & Goal Impact)
class MealQualityResult {
  final int overallScore; // 0 to 100
  final double macroBalanceScore;
  final double microScore;
  final double glycemicScore;
  final double processingScore;
  final double satietyScore;
  final String readinessImpact; // e.g. "This meal will support recovery (+2% readiness)"
  final String goalImpact;      // e.g. "This meal aligns with your fat-loss goal ✓"

  const MealQualityResult({
    required this.overallScore,
    required this.macroBalanceScore,
    required this.microScore,
    required this.glycemicScore,
    required this.processingScore,
    required this.satietyScore,
    required this.readinessImpact,
    required this.goalImpact,
  });
}

/// Smart Nutrition Engine: 5-Dimension Quality Scoring, Readiness/Goal Impact, & Protein Deficit Alert
class NutritionEngine {
  const NutritionEngine();

  /// Calculate 5-dimension meal quality score:
  /// Macro Balance (30%), Micros (25%), Glycemic Index (20%), Processing (15%), Satiety (10%)
  MealQualityResult calculateMealQuality(IndianFoodItem item) {
    // 1. Macro Balance Score (higher for high protein & balanced carbs)
    final macroScore = item.calories > 0
        ? ((item.proteinGrams * 4 / item.calories) * 200.0).clamp(0.0, 100.0)
        : 50.0;

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

    // Dynamic Readiness & Goal Impact derivation per §P5-A
    String readinessImpact = 'Neutral impact on recovery.';
    if (item.proteinGrams >= 15.0 || item.satietyIndex >= 75.0) {
      readinessImpact = 'This meal will support recovery (+2% readiness)';
    } else if (item.glycemicIndex > 70.0) {
      readinessImpact = 'High glycemic load may induce a energy dip.';
    }

    String goalImpact = 'Fits balanced daily target.';
    if (item.proteinGrams >= 12.0 && item.glycemicIndex <= 55.0) {
      goalImpact = 'This meal aligns with your fat-loss goal ✓';
    } else if (item.calories > 400 && item.proteinGrams < 8.0) {
      goalImpact = 'High calorie density relative to protein.';
    }

    return MealQualityResult(
      overallScore: overall.clamp(0.0, 100.0).round(),
      macroBalanceScore: macroScore,
      microScore: microScore,
      glycemicScore: glycemicScore,
      processingScore: processingScore,
      satietyScore: satietyScore,
      readinessImpact: readinessImpact,
      goalImpact: goalImpact,
    );
  }

  /// Check rule-based protein deficit alert (< 70% of daily target)
  bool isProteinDeficitAlert({required double loggedProtein, required double targetProtein}) {
    return loggedProtein < (0.70 * targetProtein);
  }

  /// Rule-based suggestion for protein low alert
  String generateProteinAlertText() {
    return '⚠️ Protein low — add paneer, dal, or eggs to your next meal';
  }
}
