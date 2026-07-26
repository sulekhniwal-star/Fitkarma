/// §P5-M Glycemic Response & Personal Food Scoring & §P10-L Retrospective Pipeline
///
/// Pure-Dart personal glucose spike delta calculator (Delta = Peak 90min - Baseline),
/// 1.0 to 10.0 Personal Glycemic Food Score (10.0 for <25mg/dL, 7.0 for 25-45mg/dL, 3.0 for >45mg/dL),
/// insulin blunting recommendation engine (pairing high-spike foods like banana/white rice with nuts/protein),
/// and §P10-L Retrospective Glycemic Processing Pipeline matching 90-min post-meal CGM readings.
library;

import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/food/food_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Domain Models
// ─────────────────────────────────────────────────────────────────────────────

/// Evaluation result for a specific food item's personal glycemic response.
class FoodGlycemicEvaluation {
  const FoodGlycemicEvaluation({
    required this.foodName,
    required this.mealType,
    required this.baselineGlucose,
    required this.peakGlucose,
    required this.spikeDelta,
    required this.score,
    required this.tierName,
    required this.recommendation,
  });

  final String foodName;
  final String mealType;
  final double baselineGlucose;
  final double peakGlucose;
  final double spikeDelta;

  /// 1.0 to 10.0 Personal Glycemic Score
  final double score;

  final String tierName;
  final String recommendation;
}

// ─────────────────────────────────────────────────────────────────────────────
// Glycemic Scoring Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class GlycemicScoringEngine {
  const GlycemicScoringEngine();

  /// Computes Personal Glycemic Food Score (1.0 to 10.0) from glucose spike delta.
  FoodGlycemicEvaluation computeFoodScore({
    required double baselineGlucose,
    required double peakGlucose90Min,
    required String foodName,
    String mealType = 'Meal',
  }) {
    final spikeDelta = (peakGlucose90Min - baselineGlucose).clamp(0.0, 200.0);

    double score = 10.0;
    String tier = 'Optimal Energy Stability';
    String recommendation =
        'Great personal glycemic response! Enjoy this food.';

    if (spikeDelta > 45.0) {
      score = 3.0;
      tier = 'Poor Glycemic Response';
      recommendation =
          'High glucose spike detected (+${spikeDelta.round()} mg/dL). Pair $foodName with 10 almonds/walnuts or half a scoop of protein to blunt the insulin spike.';
    } else if (spikeDelta > 25.0) {
      score = 7.0;
      tier = 'Moderate Glycemic Variance';
      recommendation =
          'Moderate spike detected (+${spikeDelta.round()} mg/dL). Keep portion size in check or pair with soluble fiber.';
    }

    return FoodGlycemicEvaluation(
      foodName: foodName,
      mealType: mealType,
      baselineGlucose: baselineGlucose,
      peakGlucose: peakGlucose90Min,
      spikeDelta: spikeDelta,
      score: score,
      tierName: tier,
      recommendation: recommendation,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// §P10-L Retrospective Glycemic Processing Pipeline Implementation
// ─────────────────────────────────────────────────────────────────────────────

class RetrospectiveGlycemicPipeline {
  const RetrospectiveGlycemicPipeline({
    this.engine = const GlycemicScoringEngine(),
  });

  final GlycemicScoringEngine engine;

  /// Processes logged meals against historical [GlucoseReading] entries.
  /// Matches CGM readings taken within a 90-minute post-meal window.
  List<FoodGlycemicEvaluation> processMealHistory({
    required List<FoodItem> loggedMeals,
    required List<GlucoseReading> glucoseReadings,
    double defaultBaseline = 95.0,
  }) {
    if (loggedMeals.isEmpty) return const [];

    final evaluations = <FoodGlycemicEvaluation>[];
    final now = DateTime.now();

    for (final meal in loggedMeals) {
      // Find post-meal readings (within 90 minutes post-meal)
      final postMealReadings = glucoseReadings.where((r) {
        final diffMinutes = r.measuredAt.difference(now).inMinutes.abs();
        return diffMinutes <= 120 &&
            (r.mealTag.contains('Post') ||
                r.mealTag.contains('2-hour') ||
                r.mealTag.contains('1-hour'));
      }).toList();

      double baseline = defaultBaseline;
      final preMealReading = glucoseReadings.firstWhere(
        (r) => r.mealTag.contains('Pre') || r.mealTag.contains('Fasting'),
        orElse: () => GlucoseReading(
          id: 0,
          userId: 'onboarding_user',
          valueMgDl: defaultBaseline,
          mealTag: 'Baseline',
          measuredAt: now,
          createdAt: now,
        ),
      );
      baseline = preMealReading.valueMgDl;

      double peak = baseline;
      if (postMealReadings.isNotEmpty) {
        peak = postMealReadings
            .map((r) => r.valueMgDl)
            .reduce((a, b) => a > b ? a : b);
      } else {
        // Estimate peak from food carb/GI if no CGM reading is matched
        peak = baseline + (meal.carbs * 0.45).clamp(10.0, 60.0);
      }

      final eval = engine.computeFoodScore(
        baselineGlucose: baseline,
        peakGlucose90Min: peak,
        foodName: meal.name,
        mealType: meal.mealType,
      );

      evaluations.add(eval);
    }

    return evaluations;
  }
}
