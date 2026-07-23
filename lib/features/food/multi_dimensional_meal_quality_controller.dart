/// §P5-N Multi-Dimensional Meal Quality Controller
///
/// Riverpod Notifier deriving daily composite meal quality scores, grades, and breakdowns
/// reactively from `foodProvider`.
library;

import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/multi_dimensional_meal_quality_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class MultiDimensionalMealQualityState {
  const MultiDimensionalMealQualityState({
    required this.dailyCompositeScore,
    required this.dailyGrade,
    required this.summary,
  });

  final double dailyCompositeScore;
  final String dailyGrade;
  final MultiDimensionalMealQualityResult summary;
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final multiDimensionalMealQualityEngineProvider = Provider<MultiDimensionalMealQualityEngine>((ref) {
  return const MultiDimensionalMealQualityEngine();
});

class MealQualityNotifier extends Notifier<MultiDimensionalMealQualityState> {
  @override
  MultiDimensionalMealQualityState build() {
    final engine = ref.watch(multiDimensionalMealQualityEngineProvider);
    final foodState = ref.watch(foodProvider);

    double totalCalories = 0.0;
    double totalProtein = 0.0;

    for (final item in foodState.loggedItems) {
      totalCalories += item.calories;
      totalProtein += item.protein;
    }

    // Heuristic estimations from logged food names
    final fiberG = _estimateFiber(foodState.loggedItems);
    final satietyIndex = _estimateSatiety(totalProtein, fiberG, totalCalories);
    final processingTier = _estimateProcessingTier(foodState.loggedItems);

    final summary = engine.calculateCompositeQualityScore(
      calories: totalCalories,
      proteinG: totalProtein,
      fiberG: fiberG,
      satietyIndex1To5: satietyIndex,
      processingTier: processingTier,
    );

    return MultiDimensionalMealQualityState(
      dailyCompositeScore: summary.score,
      dailyGrade: summary.grade,
      summary: summary,
    );
  }

  double _estimateFiber(List<FoodItem> items) {
    if (items.isEmpty) return 0.0;
    double total = 0.0;
    for (final item in items) {
      final name = item.name.toLowerCase();
      if (name.contains('rajma') || name.contains('chana') || name.contains('dal')) {
        total += 10.0;
      } else if (name.contains('roti') || name.contains('oats') || name.contains('salad') || name.contains('palak')) {
        total += 4.0;
      } else {
        total += 1.0;
      }
    }
    return total;
  }

  double _estimateSatiety(double protein, double fiber, double calories) {
    if (calories <= 0) return 1.0;
    final proteinRatio = protein / 50.0; // 50g = 1.0
    final fiberRatio = fiber / 15.0;     // 15g = 1.0
    final raw = 1.0 + (proteinRatio * 2.0) + (fiberRatio * 2.0);
    return raw.clamp(1.0, 5.0);
  }

  ProcessingTier _estimateProcessingTier(List<FoodItem> items) {
    if (items.isEmpty) return ProcessingTier.wholeFood;
    for (final item in items) {
      final name = item.name.toLowerCase();
      if (name.contains('pizza') || name.contains('burger') || name.contains('chips') || name.contains('noodle')) {
        return ProcessingTier.ultraProcessed;
      }
    }
    return ProcessingTier.wholeFood;
  }
}

final multiDimensionalMealQualityProvider =
    NotifierProvider<MealQualityNotifier, MultiDimensionalMealQualityState>(
  MealQualityNotifier.new,
);
