import '../models/indian_food_item.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';

// ── End-to-End Meal Analysis Pipeline Output Result ───────────────────────────

class FullMealAnalysisResult {
  final IndianFoodItem foodItem;
  final double servings;
  final double totalCalories;
  final double totalProteinGrams;
  final double totalCarbsGrams;
  final double totalFatGrams;
  final MealQualityResult quality;
  final String readinessImpact;
  final String goalImpact;
  final List<String> fixSuggestions;
  final bool isAiFallbackUsed;

  const FullMealAnalysisResult({
    required this.foodItem,
    this.servings = 1.0,
    required this.totalCalories,
    required this.totalProteinGrams,
    required this.totalCarbsGrams,
    required this.totalFatGrams,
    required this.quality,
    required this.readinessImpact,
    required this.goalImpact,
    required this.fixSuggestions,
    this.isAiFallbackUsed = false,
  });
}

// ── Meal Analysis Pipeline (Pure Dart End-to-End Execution) ──────────────────

class MealAnalysisPipeline {
  final NutritionEngine _nutritionEngine;

  const MealAnalysisPipeline(
      {NutritionEngine nutritionEngine = const NutritionEngine()})
      : _nutritionEngine = nutritionEngine;

  /// Executes the 5-stage end-to-end Meal Analysis Pipeline:
  /// Stage 1: Ingest food log entry or photo match
  /// Stage 2: Calculate Macros (calories, protein, carbs, fat)
  /// Stage 3: Compute 5-Dimension Meal Quality Score locally
  /// Stage 4: Derive Readiness & Goal Impact (rule-based)
  /// Stage 5: Generate template-based Fix Suggestions for nutrition gaps
  FullMealAnalysisResult processMealEntry({
    required IndianFoodItem foodItem,
    double servings = 1.0,
    String userGoal = 'Fat Loss',
  }) {
    // Stage 2: Calculate Macros
    final cals = foodItem.calories * servings;
    final protein = foodItem.proteinGrams * servings;
    final carbs = foodItem.carbsGrams * servings;
    final fat = foodItem.fatGrams * servings;

    // Stage 3: Compute 5-Dimension Meal Quality Score
    final quality = _nutritionEngine.calculateMealQuality(foodItem);

    // Stage 4: Derive Readiness & Goal Impact
    final readiness = quality.readinessImpact;
    final goal = quality.goalImpact;

    // Stage 5: Template-Based Fix Suggestions for Common Gaps (AI only for edge cases)
    final suggestions = <String>[];

    if (protein < 12.0) {
      suggestions.add(
          'Add 100g Paneer or 2 boiled eggs (+14g protein) to meet meal protein target.');
    }
    if (foodItem.glycemicIndex > 60.0) {
      suggestions.add(
          'Pair with a green salad or cucumber slices (+4g fiber) to blunt glucose spike.');
    }
    if (fat > 18.0 && userGoal == 'Fat Loss') {
      suggestions
          .add('Reduce added ghee/butter topping by half to save ~80 kcal.');
    }
    if (foodItem.satietyIndex < 60.0) {
      suggestions.add(
          'Include a bowl of curd or buttermilk (chhaach) to boost satiety duration.');
    }

    if (suggestions.isEmpty) {
      suggestions.add(
          'Great meal balance! No immediate adjustments needed for your $userGoal goal.');
    }

    return FullMealAnalysisResult(
      foodItem: foodItem,
      servings: servings,
      totalCalories: cals,
      totalProteinGrams: protein,
      totalCarbsGrams: carbs,
      totalFatGrams: fat,
      quality: quality,
      readinessImpact: readiness,
      goalImpact: goal,
      fixSuggestions: suggestions,
      isAiFallbackUsed: false,
    );
  }
}
