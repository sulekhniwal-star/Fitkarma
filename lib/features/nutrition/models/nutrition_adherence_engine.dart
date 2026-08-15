import 'package:flutter/material.dart';
import 'package:fitkarma/core/brain/nutrition_engine.dart';

class NutritionAdherenceScoreResult {
  final double totalScore; // 0 to 100
  final double caloriePoints; // max 30
  final double proteinPoints; // max 35
  final double loggingCompletenessPoints; // max 20
  final double timingStabilityPoints; // max 15
  final String feedback;

  const NutritionAdherenceScoreResult({
    required this.totalScore,
    required this.caloriePoints,
    required this.proteinPoints,
    required this.loggingCompletenessPoints,
    required this.timingStabilityPoints,
    required this.feedback,
  });
}

class MealTimeMedian {
  final MealType type;
  final TimeOfDay time;

  const MealTimeMedian({required this.type, required this.time});
}

class DailyAdherenceLog {
  final double totalCalories;
  final double totalProtein;
  final List<MealEntry> loggedMeals;

  const DailyAdherenceLog({
    required this.totalCalories,
    required this.totalProtein,
    required this.loggedMeals,
  });

  int get distinctMealsCount {
    final types = loggedMeals.map((m) => m.type).toSet();
    return types.length;
  }
}

/// Pure-Dart Nutrition Adherence Engine per §P5-J spec
class NutritionAdherenceEngine {
  const NutritionAdherenceEngine();

  /// Calculates Daily Nutrition Adherence Score on 0-100 scale:
  /// 1. Calorie Adherence (30 pts): ±10% target
  /// 2. Protein Adherence (35 pts): ±15% target
  /// 3. Logging Completion (20 pts): ≥3 distinct meals
  /// 4. Meal Timing Consistency (15 pts): Main meals within ±60 minutes of historical median
  NutritionAdherenceScoreResult calculateDailyScore({
    required DailyAdherenceLog log,
    required double targetCalories,
    required double targetProtein,
    List<MealTimeMedian> historicalMedians = const [
      MealTimeMedian(
          type: MealType.breakfast, time: TimeOfDay(hour: 8, minute: 30)),
      MealTimeMedian(
          type: MealType.lunch, time: TimeOfDay(hour: 13, minute: 0)),
      MealTimeMedian(
          type: MealType.dinner, time: TimeOfDay(hour: 20, minute: 30)),
    ],
  }) {
    double caloriePts = 0.0;
    double proteinPts = 0.0;
    double completenessPts = 0.0;
    double timingPts = 0.0;

    // 1. Calorie Check (±10%)
    final calorieDelta = (log.totalCalories - targetCalories).abs();
    if (calorieDelta <= (targetCalories * 0.10)) {
      caloriePts = 30.0;
    } else if (calorieDelta <= (targetCalories * 0.20)) {
      caloriePts = 15.0; // Partial points
    }

    // 2. Protein Check (±15%)
    final proteinDelta = (log.totalProtein - targetProtein).abs();
    if (proteinDelta <= (targetProtein * 0.15)) {
      proteinPts = 35.0;
    } else if (proteinDelta <= (targetProtein * 0.25)) {
      proteinPts = 18.0; // Partial points
    }

    // 3. Logging Completeness (≥3 distinct meals)
    if (log.distinctMealsCount >= 3) {
      completenessPts = 20.0;
    } else if (log.distinctMealsCount >= 2) {
      completenessPts = 10.0;
    }

    // 4. Timing Stability
    if (checkTimingStability(log.loggedMeals, historicalMedians)) {
      timingPts = 15.0;
    }

    final totalScore = caloriePts + proteinPts + completenessPts + timingPts;

    String feedback =
        'Excellent consistency! Your nutrition adherence is on track.';
    if (totalScore < 70) {
      if (proteinPts < 35) {
        feedback =
            'Protein intake was outside your ±15% target range. Aim to distribute protein evenly across main meals.';
      } else if (completenessPts < 20) {
        feedback =
            'Log at least 3 main meals to maintain full tracking completeness.';
      } else {
        feedback =
            'Keep your calories within ±10% of target to maintain metabolic momentum.';
      }
    }

    return NutritionAdherenceScoreResult(
      totalScore: double.parse(totalScore.toStringAsFixed(1)),
      caloriePoints: caloriePts,
      proteinPoints: proteinPts,
      loggingCompletenessPoints: completenessPts,
      timingStabilityPoints: timingPts,
      feedback: feedback,
    );
  }

  /// Verifies main meals are logged close (within ±60 min) to customary median meal times
  bool checkTimingStability(
      List<MealEntry> meals, List<MealTimeMedian> medians) {
    int onTimeCount = 0;

    for (final meal in meals) {
      final median = medians.firstWhere(
        (m) => m.type == meal.type,
        orElse: () => MealTimeMedian(
            type: meal.type, time: const TimeOfDay(hour: 12, minute: 0)),
      );

      final mealMinutes = meal.loggedAt.hour * 60 + meal.loggedAt.minute;
      final medianMinutes = median.time.hour * 60 + median.time.minute;

      if ((mealMinutes - medianMinutes).abs() <= 60) {
        onTimeCount++;
      }
    }

    return onTimeCount >= 2;
  }
}
