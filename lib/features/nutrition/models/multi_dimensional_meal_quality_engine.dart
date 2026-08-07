class MultiDimensionalMealQualityResult {
  final double score; // 0.0 to 100.0 scale
  final double proteinDensity; // (Protein g * 100) / Calories
  final double fiberG;
  final double satietyIndex; // 1.0 to 5.0
  final int processingTier; // 0 (Whole Foods) to 3 (Ultra-Processed)
  final String gradeLabel; // e.g. "A+ Premium Quality", "C- Low Quality", etc.

  const MultiDimensionalMealQualityResult({
    required this.score,
    required this.proteinDensity,
    required this.fiberG,
    required this.satietyIndex,
    required this.processingTier,
    required this.gradeLabel,
  });
}

/// Pure-Dart Multi-Dimensional Meal Quality Scoring Engine per §P5-N spec
class MultiDimensionalMealQualityEngine {
  const MultiDimensionalMealQualityEngine();

  /// Calculates Meal Quality Score (0 to 100):
  /// Formula: Score = (2.5 * ProteinDensity) + (3 * FiberG) + (20 * SatietyIndex) - (15 * ProcessingTier)
  /// Where:
  /// - ProteinDensity = (Protein g * 100) / Calories
  /// - FiberG = total dietary fiber in grams
  /// - SatietyIndex = 1.0 to 5.0
  /// - ProcessingTier = 0 (Whole Foods) to 3 (Ultra-Processed NOVA 4)
  MultiDimensionalMealQualityResult calculateScore({
    required double calories,
    required double proteinG,
    required double fiberG,
    required double satietyIndex, // 1.0 to 5.0
    required int processingTier, // 0 to 3
  }) {
    final proteinDensity = calories > 0 ? (proteinG * 100.0) / calories : 0.0;
    final clampedSatiety = satietyIndex.clamp(1.0, 5.0);
    final clampedProcessing = processingTier.clamp(0, 3);

    final rawScore = (2.5 * proteinDensity) +
        (3.0 * fiberG) +
        (20.0 * clampedSatiety) -
        (15.0 * clampedProcessing);

    final finalScore = rawScore.clamp(0.0, 100.0);

    String grade = 'A+ Optimal Nutrient Density';
    if (finalScore < 40.0) {
      grade = 'F Low Quality / Ultra-Processed';
    } else if (finalScore < 60.0) {
      grade = 'C Moderate Quality';
    } else if (finalScore < 80.0) {
      grade = 'B High Quality';
    }

    return MultiDimensionalMealQualityResult(
      score: double.parse(finalScore.toStringAsFixed(1)),
      proteinDensity: double.parse(proteinDensity.toStringAsFixed(2)),
      fiberG: fiberG,
      satietyIndex: clampedSatiety,
      processingTier: clampedProcessing,
      gradeLabel: grade,
    );
  }
}
