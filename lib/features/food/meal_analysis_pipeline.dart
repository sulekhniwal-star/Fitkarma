/// §P5-B Meal Analysis Pipeline
///
/// Orchestrates MealParser → LocalMealQualityCalculator → readiness/goal
/// impact rules → fix suggestions.  Fully offline — no network calls.
library;

import 'meal_parser.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Domain types
// ─────────────────────────────────────────────────────────────────────────────

/// User's primary fitness goal, used for [GoalImpact] calculation.
enum UserGoal {
  fatLoss,
  muscleGain,
  generalHealth,
}

/// Whether a meal aligns with, is neutral to, or conflicts with the user's goal.
enum GoalImpact {
  aligned,
  neutral,
  misaligned,
}

/// Complete result produced by [MealAnalysisPipeline.analyze].
class MealAnalysisResult {
  const MealAnalysisResult({
    required this.parsedItems,
    required this.unknownTokens,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.totalFiberG,
    required this.weightedGI,
    required this.mealQualityScore,
    required this.readinessImpact,
    required this.goalImpact,
    required this.fixSuggestions,
  });

  final List<ParsedMealItem> parsedItems;
  final List<String> unknownTokens;

  // Aggregated macros
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final double totalFiberG;

  /// Carb-weighted average glycemic index across all items.
  final int weightedGI;

  /// Composite Meal Quality Score (0.0–10.0) per §P5-D.
  final double mealQualityScore;

  /// Signed integer readiness impact (e.g. +2, -3, 0).
  final int readinessImpact;

  /// Whether the meal aligns with the user's goal.
  final GoalImpact goalImpact;

  /// Template-based fix suggestions (empty when meal is optimal).
  final List<String> fixSuggestions;
}

// ─────────────────────────────────────────────────────────────────────────────
// Local Meal Quality Calculator (§P5-D)
// ─────────────────────────────────────────────────────────────────────────────

/// Pure-Dart, offline meal quality scorer — implements the exact formula from
/// §P5-D of the FitKarma documentation.
class LocalMealQualityCalculator {
  const LocalMealQualityCalculator();

  /// Returns a composite Meal Quality Score in [0.0, 10.0].
  double calculateMealQualityScore({
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required double fiberG,
    required int glycemicIndex,
  }) {
    if (calories <= 0) return 0.0;

    // 1. Protein Density Score (≤ 3.0 pts)
    final double proteinCal = proteinG * 4.0;
    final double proteinPct = proteinCal / calories;
    final double proteinScore = (proteinPct * 10.0).clamp(0.0, 3.0);

    // 2. Fiber Density Score (≤ 2.5 pts) — target: 14 g per 1000 kcal
    final double targetFiber = (calories / 1000.0) * 14.0;
    final double fiberScore = targetFiber > 0
        ? ((fiberG / targetFiber) * 2.5).clamp(0.0, 2.5)
        : 0.0;

    // 3. Glycemic Load Impact Score (≤ 2.5 pts)
    final double glycemicLoad = (carbsG * glycemicIndex) / 100.0;
    final double glScore = glycemicLoad > 20
        ? 0.5
        : glycemicLoad > 10
            ? 1.5
            : 2.5;

    // 4. Satiety Index Score (≤ 2.0 pts)
    final double satietyIndex = calculateSatietyIndex(proteinG, fiberG, fatG, carbsG);
    final double satietyScore = (satietyIndex / 100.0) * 2.0;

    final raw = proteinScore + fiberScore + glScore + satietyScore;
    return double.parse(raw.clamp(0.0, 10.0).toStringAsFixed(1));
  }

  /// Returns a Satiety Index in [10.0, 100.0].
  double calculateSatietyIndex(
      double protein, double fiber, double fat, double carbs) {
    final double base =
        (protein * 2.5) + (fiber * 3.0) + (fat * 1.0) + (carbs * 0.5);
    return base.clamp(10.0, 100.0);
  }

  /// Returns a signed readiness impact integer per §P5-D rules.
  int calculateReadinessImpact(double proteinG, int glycemicIndex, double carbsG) {
    int impact = 0;
    if (proteinG >= 20.0) impact += 2; // muscle recovery boost
    final double glycemicLoad = (carbsG * glycemicIndex) / 100.0;
    if (glycemicLoad > 25.0) impact -= 3; // energy crash penalty
    return impact;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Meal Analysis Pipeline
// ─────────────────────────────────────────────────────────────────────────────

/// Orchestrates the full §P5-B analysis pipeline:
///   text → MealParser → quality score → readiness/goal impact → suggestions.
class MealAnalysisPipeline {
  const MealAnalysisPipeline({
    LocalMealQualityCalculator? calculator,
  }) : _calculator = calculator ?? const LocalMealQualityCalculator();

  final LocalMealQualityCalculator _calculator;

  /// Analyses [rawText] against [catalog] for the given [userGoal].
  MealAnalysisResult analyze({
    required String rawText,
    required UserGoal userGoal,
    required List<FoodCatalogEntry> catalog,
  }) {
    // 1. Parse
    final parseResult = MealParser.parse(rawText, catalog);
    final items = parseResult.items;

    // 2. Aggregate macros
    double totalCalories = 0;
    double totalProteinG = 0;
    double totalCarbsG = 0;
    double totalFatG = 0;
    double totalFiberG = 0;
    double carbWeightedGISum = 0;

    for (final item in items) {
      totalCalories += item.scaledCalories;
      totalProteinG += item.scaledProteinG;
      totalCarbsG += item.scaledCarbsG;
      totalFatG += item.scaledFatG;
      totalFiberG += item.scaledFiberG;
      carbWeightedGISum += item.scaledCarbsG * item.glycemicIndex;
    }

    // Carb-weighted average GI
    final int weightedGI = totalCarbsG > 0
        ? (carbWeightedGISum / totalCarbsG).round()
        : 0;

    // 3. Quality score
    final double qualityScore = _calculator.calculateMealQualityScore(
      calories: totalCalories,
      proteinG: totalProteinG,
      carbsG: totalCarbsG,
      fatG: totalFatG,
      fiberG: totalFiberG,
      glycemicIndex: weightedGI,
    );

    // 4. Readiness impact
    final int readinessImpact = _calculator.calculateReadinessImpact(
      totalProteinG,
      weightedGI,
      totalCarbsG,
    );

    // 5. Goal impact
    final GoalImpact goalImpact =
        _computeGoalImpact(userGoal, totalCalories, totalProteinG, qualityScore);

    // 6. Fix suggestions
    final List<String> suggestions = _buildSuggestions(
      totalProteinG: totalProteinG,
      totalFiberG: totalFiberG,
      totalCarbsG: totalCarbsG,
      weightedGI: weightedGI,
    );

    return MealAnalysisResult(
      parsedItems: items,
      unknownTokens: parseResult.unknownTokens,
      totalCalories: double.parse(totalCalories.toStringAsFixed(1)),
      totalProteinG: double.parse(totalProteinG.toStringAsFixed(1)),
      totalCarbsG: double.parse(totalCarbsG.toStringAsFixed(1)),
      totalFatG: double.parse(totalFatG.toStringAsFixed(1)),
      totalFiberG: double.parse(totalFiberG.toStringAsFixed(1)),
      weightedGI: weightedGI,
      mealQualityScore: qualityScore,
      readinessImpact: readinessImpact,
      goalImpact: goalImpact,
      fixSuggestions: suggestions,
    );
  }

  // ── Internal helpers ─────────────────────────────────────────────────────

  GoalImpact _computeGoalImpact(
    UserGoal goal,
    double calories,
    double proteinG,
    double qualityScore,
  ) {
    switch (goal) {
      case UserGoal.fatLoss:
        if (calories < 600 && proteinG >= 15) return GoalImpact.aligned;
        if (calories > 750) return GoalImpact.misaligned;
        return GoalImpact.neutral;

      case UserGoal.muscleGain:
        if (proteinG >= 25) return GoalImpact.aligned;
        if (proteinG < 10) return GoalImpact.misaligned;
        return GoalImpact.neutral;

      case UserGoal.generalHealth:
        if (qualityScore >= 6.0) return GoalImpact.aligned;
        if (qualityScore < 4.0) return GoalImpact.misaligned;
        return GoalImpact.neutral;
    }
  }

  List<String> _buildSuggestions({
    required double totalProteinG,
    required double totalFiberG,
    required double totalCarbsG,
    required int weightedGI,
  }) {
    final suggestions = <String>[];

    if (totalProteinG < 15) {
      suggestions.add('Add curd, paneer, or an egg for protein');
    }
    if (totalFiberG < 3) {
      suggestions.add('Add a side salad or dal for fiber');
    }
    final double gl = (totalCarbsG * weightedGI) / 100.0;
    if (gl > 20) {
      suggestions
          .add('Replace 1 roti with a bowl of sabzi to reduce glycemic load');
    }

    return suggestions;
  }
}
