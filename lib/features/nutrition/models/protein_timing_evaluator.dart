import 'package:fitkarma/core/brain/nutrition_engine.dart';

class ProteinTimingResult {
  final double score; // 0 to 100
  final int mpsMealsMetCount; // 0 to 3 main meals meeting 25g+ threshold
  final double breakfastProteinG;
  final double lunchProteinG;
  final double dinnerProteinG;
  final String feedback;

  const ProteinTimingResult({
    required this.score,
    required this.mpsMealsMetCount,
    required this.breakfastProteinG,
    required this.lunchProteinG,
    required this.dinnerProteinG,
    required this.feedback,
  });
}

/// Pure-Dart Protein Distribution & Timing Intelligence Evaluator per §P5-H spec
class ProteinTimingEvaluator {
  static const double mpsThresholdGrams =
      25.0; // Minimum protein required per main meal to trigger MPS

  const ProteinTimingEvaluator();

  /// Evaluates protein distribution across Breakfast, Lunch, and Dinner
  ProteinTimingResult evaluateDistribution(List<MealEntry> meals) {
    final breakfastProtein = _getMealTypeProtein(meals, MealType.breakfast);
    final lunchProtein = _getMealTypeProtein(meals, MealType.lunch);
    final dinnerProtein = _getMealTypeProtein(meals, MealType.dinner);

    int mpsMealsMetCount = 0;
    if (breakfastProtein >= mpsThresholdGrams) mpsMealsMetCount++;
    if (lunchProtein >= mpsThresholdGrams) mpsMealsMetCount++;
    if (dinnerProtein >= mpsThresholdGrams) mpsMealsMetCount++;

    double timingScore = 10.0;
    switch (mpsMealsMetCount) {
      case 3:
        timingScore = 100.0; // Optimal MPS signaling
        break;
      case 2:
        timingScore = 70.0; // Sub-optimal MPS distribution
        break;
      case 1:
        timingScore = 40.0; // Poor recovery efficiency
        break;
      default:
        timingScore = 10.0; // Critical deficit across main meals
        break;
    }

    final feedback = _generateTimingNudge(
      score: timingScore,
      breakfastG: breakfastProtein,
      lunchG: lunchProtein,
      dinnerG: dinnerProtein,
    );

    return ProteinTimingResult(
      score: timingScore,
      mpsMealsMetCount: mpsMealsMetCount,
      breakfastProteinG: breakfastProtein,
      lunchProteinG: lunchProtein,
      dinnerProteinG: dinnerProtein,
      feedback: feedback,
    );
  }

  double _getMealTypeProtein(List<MealEntry> meals, MealType type) {
    return meals
        .where((m) => m.type == type)
        .fold(0.0, (sum, meal) => sum + meal.totalProtein);
  }

  String _generateTimingNudge({
    required double score,
    required double breakfastG,
    required double lunchG,
    required double dinnerG,
  }) {
    if (score == 100.0) {
      return 'Excellent protein distribution across all 3 main meals! Optimal Muscle Protein Synthesis (MPS) triggered.';
    }

    final total = breakfastG + lunchG + dinnerG;
    if (dinnerG > (total * 0.6) && breakfastG < mpsThresholdGrams) {
      final shiftAmount = ((dinnerG - 25.0) / 2.0).clamp(10.0, 25.0).round();
      return 'Your total protein was ${total.round()}g, but ${dinnerG.round()}g was eaten at dinner. Breakfast had only ${breakfastG.round()}g. We recommend moving ${shiftAmount}g of protein from dinner to breakfast (e.g. add eggs or sattu) to optimize muscle recovery.';
    }

    return 'Shift protein sources from high-density meals to low-density meals (reach ≥25g at Breakfast, Lunch & Dinner) to achieve balanced MPS triggers.';
  }
}
