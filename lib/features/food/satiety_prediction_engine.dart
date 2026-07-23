/// §P5-P Satiety Prediction Engine
///
/// Pure-Dart satiety model computing food satiety scores (0 to 100):
/// Satiety Score = min(100, (2.8 * ProteinG) + (4 * FiberG) + (1.2 * WeightVolumeFraction) - (12 * NOVAProcessingTier))
/// predicting fullness duration (1 to 5 hrs), benchmarking local Indian foods, and generating high-satiety meal recommendations.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Domain Enums & Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Result payload for a food satiety evaluation.
class SatietyEvaluation {
  const SatietyEvaluation({
    required this.foodName,
    required this.score,
    required this.fullnessDurationHours,
    required this.satietyTier,
    required this.primaryFullnessFactor,
    this.recommendedHighSatietySwap,
  });

  final String foodName;

  /// 0.0 to 100.0 Satiety Score
  final double score;

  /// Estimated fullness duration in hours (e.g. 4.5 hrs)
  final double fullnessDurationHours;

  /// "Ultra-Satisfying 🟢", "Moderate Fullness 🟡", "Low Satiety / Rapid Crash 🔴"
  final String satietyTier;

  final String primaryFullnessFactor;

  final String? recommendedHighSatietySwap;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class SatietyPredictionEngine {
  const SatietyPredictionEngine();

  /// Reference Indian Satiety Items (§P5-P Specification).
  static const Map<String, SatietyEvaluation> indianReferenceSatietyTable = {
    'paneer bhurji': SatietyEvaluation(
      foodName: 'Paneer Bhurji (200g)',
      score: 90.0,
      fullnessDurationHours: 4.5,
      satietyTier: 'Ultra-Satisfying 🟢',
      primaryFullnessFactor: 'High Protein density & slow digesting casein',
    ),
    'rajma chawal': SatietyEvaluation(
      foodName: 'Rajma Chawal + Salad (350g)',
      score: 85.0,
      fullnessDurationHours: 4.0,
      satietyTier: 'Ultra-Satisfying 🟢',
      primaryFullnessFactor: 'High soluble fiber + high volume salad',
    ),
    'air-fried samosa': SatietyEvaluation(
      foodName: 'Air-Fried Samosa (1 pc)',
      score: 60.0,
      fullnessDurationHours: 2.5,
      satietyTier: 'Moderate Fullness 🟡',
      primaryFullnessFactor: 'Fiber substitute + moderate fat drop',
      recommendedHighSatietySwap:
          'Pair with 1 cup Curd or Sprouts to reach 85+ score.',
    ),
    'deep-fried samosa': SatietyEvaluation(
      foodName: 'Deep-Fried Samosa (1 pc)',
      score: 30.0,
      fullnessDurationHours: 1.5,
      satietyTier: 'Low Satiety / Rapid Crash 🔴',
      primaryFullnessFactor: 'Ultra-processed, high trans fat, zero fiber',
      recommendedHighSatietySwap:
          'Swap with Air-Fried Samosa or 1 Bowl Roasted Chana (+10g pro).',
    ),
    'chai + biscuits': SatietyEvaluation(
      foodName: 'Indian Chai + 2 Biscuits',
      score: 20.0,
      fullnessDurationHours: 1.0,
      satietyTier: 'Low Satiety / Rapid Crash 🔴',
      primaryFullnessFactor: 'Rapid sugar absorption, high glycemic crash',
      recommendedHighSatietySwap:
          'Swap with 1 Glass Chilled Sattu Drink (+18g pro) or 1 Bowl Curd + Walnuts.',
    ),
  };

  /// Calculates 0-100 Satiety Score using §P5-P formula:
  /// Satiety Score = min(100, (2.8 * ProteinG) + (4 * FiberG) + (1.2 * WeightVolumeFraction) - (12 * ProcessingTier))
  SatietyEvaluation computeSatietyScore({
    required String foodName,
    required double calories,
    required double proteinG,
    required double fiberG,
    required double weightG,
    int processingTier = 0,
  }) {
    // Check direct lookup in reference table
    final key = foodName.trim().toLowerCase();
    for (final refKey in indianReferenceSatietyTable.keys) {
      if (key.contains(refKey)) {
        return indianReferenceSatietyTable[refKey]!;
      }
    }

    if (calories <= 0) {
      return SatietyEvaluation(
        foodName: foodName,
        score: 0.0,
        fullnessDurationHours: 0.0,
        satietyTier: 'Low Satiety / Rapid Crash 🔴',
        primaryFullnessFactor: 'No nutritional volume.',
      );
    }

    // Weight Volume Fraction = Weight (g) * 100 / Calories
    final weightVolumeFraction = (weightG * 100.0) / calories;

    // Formula: min(100, (2.8 * ProteinG) + (4 * FiberG) + (1.2 * WeightVolumeFraction) - (12 * ProcessingTier))
    final rawScore =
        (2.8 * proteinG) +
        (4.0 * fiberG) +
        (1.2 * weightVolumeFraction) -
        (12.0 * processingTier);

    final score = double.parse(rawScore.clamp(0.0, 100.0).toStringAsFixed(1));

    // Fullness duration estimation (1.0 to 5.0 hrs)
    final durationHours = double.parse(
      (1.0 + (score / 100.0) * 4.0).toStringAsFixed(1),
    );

    String tier = 'Low Satiety / Rapid Crash 🔴';
    String factor = 'Low protein & fiber content';
    String? swap;

    if (score >= 80.0) {
      tier = 'Ultra-Satisfying 🟢';
      factor = 'High protein & fiber matrix promoting gastric distension';
    } else if (score >= 60.0) {
      tier = 'Moderate Fullness 🟡';
      factor = 'Moderate protein/fiber balance';
      swap =
          'Add 50g Paneer or 1 Bowl Greek Yogurt to extend fullness past 4 hours.';
    } else {
      tier = 'Low Satiety / Rapid Crash 🔴';
      factor = 'Rapidly digestible simple carbs / processing penalty';
      swap =
          'Swap with 1 Glass Chilled Sattu Drink (+18g pro) or Curd + Roasted Chana.';
    }

    return SatietyEvaluation(
      foodName: foodName,
      score: score,
      fullnessDurationHours: durationHours,
      satietyTier: tier,
      primaryFullnessFactor: factor,
      recommendedHighSatietySwap: swap,
    );
  }
}
