import 'nutrition_models.dart';

class FoodComparisonResult {
  final FoodItem itemA;
  final FoodItem itemB;
  final int calorieDelta;
  final double proteinDelta;
  final double carbsDelta;
  final double fatsDelta;
  final double fiberDelta;
  final String recommendation;

  const FoodComparisonResult({
    required this.itemA,
    required this.itemB,
    required this.calorieDelta,
    required this.proteinDelta,
    required this.carbsDelta,
    required this.fatsDelta,
    required this.fiberDelta,
    required this.recommendation,
  });
}

class MealIntelligenceEngine {
  /// Pure Dart deterministic scoring of individual food items or meal combinations (0 to 100)
  static int calculateLocalMealScore(FoodItem food) {
    // 1. Protein points (max 40)
    final proteinPts = ((food.proteinGrams / 25.0) * 40.0).clamp(5.0, 40.0);

    // 2. Fiber points (max 30)
    final fiberPts = ((food.fiberGrams / 6.0) * 30.0).clamp(5.0, 30.0);

    // 3. Fat penalty / balance (max 20)
    final double fatPts;
    if (food.fatsGrams > 20.0) {
      fatPts = 5.0;
    } else if (food.fatsGrams > 10.0) {
      fatPts = 12.0;
    } else {
      fatPts = 20.0;
    }

    // 4. Whole food base points (10)
    const basePts = 10.0;

    return (proteinPts + fiberPts + fatPts + basePts).round().clamp(0, 100);
  }

  /// Side-by-side comparative analysis of two Indian food items
  static FoodComparisonResult compareFoods(FoodItem itemA, FoodItem itemB) {
    final calDelta = itemB.calories - itemA.calories;
    final proteinDelta = itemB.proteinGrams - itemA.proteinGrams;
    final carbsDelta = itemB.carbsGrams - itemA.carbsGrams;
    final fatsDelta = itemB.fatsGrams - itemA.fatsGrams;
    final fiberDelta = itemB.fiberGrams - itemA.fiberGrams;

    final String rec;
    if (proteinDelta > 5.0 && calDelta <= 50) {
      rec = 'Swapping to ${itemB.name} adds +${proteinDelta.toStringAsFixed(1)}g Protein with negligible calorie surplus.';
    } else if (calDelta < -75) {
      rec = 'Swapping to ${itemB.name} saves ${calDelta.abs()} calories, ideal for caloric deficit phases.';
    } else {
      rec = '${itemB.name} provides ${proteinDelta >= 0 ? "+${proteinDelta.toStringAsFixed(1)}g Protein" : "${proteinDelta.toStringAsFixed(1)}g Protein"} and ${fiberDelta >= 0 ? "+${fiberDelta.toStringAsFixed(1)}g Fiber" : "${fiberDelta.toStringAsFixed(1)}g Fiber"}.';
    }

    return FoodComparisonResult(
      itemA: itemA,
      itemB: itemB,
      calorieDelta: calDelta,
      proteinDelta: double.parse(proteinDelta.toStringAsFixed(1)),
      carbsDelta: double.parse(carbsDelta.toStringAsFixed(1)),
      fatsDelta: double.parse(fatsDelta.toStringAsFixed(1)),
      fiberDelta: double.parse(fiberDelta.toStringAsFixed(1)),
      recommendation: rec,
    );
  }
}
