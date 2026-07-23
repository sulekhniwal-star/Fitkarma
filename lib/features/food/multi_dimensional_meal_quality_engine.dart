/// §P5-N Multi-Dimensional Meal Quality Score
///
/// Pure-Dart multi-dimensional meal quality engine implementing the exact formula:
/// Score = (2.5 * ProteinDensity) + (3 * FiberG) + (20 * SatietyIndex) - (15 * ProcessingTier)
/// with NOVA processing tier penalties and 100-point letter grade scoring (S/A/B/C/D).
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// NOVA food processing classification tiers (§P5-N Specification).
enum ProcessingTier {
  /// Tier 0: Unprocessed / Whole Foods (Fresh vegetables, fruits, raw nuts, eggs, raw grains)
  wholeFood(0),

  /// Tier 1: Minimally Processed (Whole curd, paneer, rolled oats, boiled dal)
  minimallyProcessed(1),

  /// Tier 2: Moderately Processed (Brown bread, pasteurized cheese, cooked sauces)
  moderatelyProcessed(2),

  /// Tier 3 / NOVA Tier 4: Ultra-Processed (Fast food pizza, chips, instant noodles, sugary sodas)
  ultraProcessed(3);

  const ProcessingTier(this.penaltyValue);
  final int penaltyValue;
}

/// Composite result produced by [MultiDimensionalMealQualityEngine].
class MultiDimensionalMealQualityResult {
  const MultiDimensionalMealQualityResult({
    required this.score,
    required this.proteinDensity,
    required this.fiberG,
    required this.satietyIndex,
    required this.processingTier,
    required this.grade,
    required this.breakdownSummary,
  });

  /// 0.0 to 100.0 Composite Quality Score
  final double score;

  /// Protein (g) * 100 / Calories
  final double proteinDensity;

  final double fiberG;

  /// 1.0 to 5.0 Satiety Index
  final double satietyIndex;

  final ProcessingTier processingTier;

  /// Letter Grade: "S - Superfood", "A - High Quality", "B - Balanced", "C - Sub-optimal", "D - Ultra-Processed"
  final String grade;

  final String breakdownSummary;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class MultiDimensionalMealQualityEngine {
  const MultiDimensionalMealQualityEngine();

  /// Calculates composite Meal Quality Score out of 100 using §P5-N formula.
  MultiDimensionalMealQualityResult calculateCompositeQualityScore({
    required double calories,
    required double proteinG,
    required double fiberG,
    required double satietyIndex1To5,
    required ProcessingTier processingTier,
  }) {
    if (calories <= 0) {
      return const MultiDimensionalMealQualityResult(
        score: 0.0,
        proteinDensity: 0.0,
        fiberG: 0.0,
        satietyIndex: 1.0,
        processingTier: ProcessingTier.wholeFood,
        grade: 'D - Ultra-Processed',
        breakdownSummary: 'No food logged.',
      );
    }

    // 1. Protein Density = Protein (g) * 100 / Calories
    final proteinDensity = (proteinG * 100.0) / calories;

    // 2. Exact Formula:
    // Score = (2.5 * ProteinDensity) + (3 * FiberG) + (20 * SatietyIndex) - (15 * ProcessingTier)
    final rawScore = (2.5 * proteinDensity) +
        (3.0 * fiberG) +
        (20.0 * satietyIndex1To5) -
        (15.0 * processingTier.penaltyValue);

    final score = double.parse(rawScore.clamp(0.0, 100.0).toStringAsFixed(1));

    // Assign Letter Grade
    String grade = 'D - Ultra-Processed';
    if (score >= 85.0) {
      grade = 'S - Superfood';
    } else if (score >= 70.0) {
      grade = 'A - High Quality';
    } else if (score >= 50.0) {
      grade = 'B - Balanced';
    } else if (score >= 35.0) {
      grade = 'C - Sub-optimal';
    }

    String summary = '';
    if (processingTier == ProcessingTier.ultraProcessed) {
      summary = 'Ultra-processed food penalty (-45 pts) applied. Swap with whole food alternatives to boost quality score.';
    } else if (score >= 85.0) {
      summary = 'Flawless nutrient density! High in protein, fiber, and satiety with minimal processing.';
    } else if (score >= 70.0) {
      summary = 'High quality meal! Excellent satiety and protein density.';
    } else {
      summary = 'Moderate quality meal. Add high-fiber vegetables or lean protein to improve score.';
    }

    return MultiDimensionalMealQualityResult(
      score: score,
      proteinDensity: double.parse(proteinDensity.toStringAsFixed(2)),
      fiberG: fiberG,
      satietyIndex: satietyIndex1To5,
      processingTier: processingTier,
      grade: grade,
      breakdownSummary: summary,
    );
  }
}
