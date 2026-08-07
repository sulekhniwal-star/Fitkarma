class IndianSatietyItem {
  final String id;
  final String name;
  final double calories;
  final double proteinG;
  final double fiberG;
  final double weightGrams;
  final double volumeMl;
  final int novaProcessingTier; // 0 (Whole) to 3 (Ultra-Processed)
  final String fullnessFactorNote;

  const IndianSatietyItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.fiberG,
    required this.weightGrams,
    required this.volumeMl,
    required this.novaProcessingTier,
    required this.fullnessFactorNote,
  });

  double get weightVolumeFraction => volumeMl > 0 ? (weightGrams / volumeMl) * 50.0 : 50.0;
}

class SeededIndianSatietyTable {
  static const List<IndianSatietyItem> items = [
    IndianSatietyItem(
      id: 'sat_1',
      name: 'Paneer Bhurji (200g)',
      calories: 320.0,
      proteinG: 24.0,
      fiberG: 2.0,
      weightGrams: 200.0,
      volumeMl: 250.0,
      novaProcessingTier: 0,
      fullnessFactorNote: 'High Protein density & slow digesting casein protein',
    ),
    IndianSatietyItem(
      id: 'sat_2',
      name: 'Rajma Chawal + Salad (350g)',
      calories: 480.0,
      proteinG: 28.0,
      fiberG: 12.0,
      weightGrams: 350.0,
      volumeMl: 400.0,
      novaProcessingTier: 0,
      fullnessFactorNote: 'High soluble fiber + high gastric volume expansion',
    ),
    IndianSatietyItem(
      id: 'sat_3',
      name: 'Air-Fried Samosa (1 pc)',
      calories: 160.0,
      proteinG: 4.5,
      fiberG: 3.5,
      weightGrams: 90.0,
      volumeMl: 100.0,
      novaProcessingTier: 1,
      fullnessFactorNote: 'Fiber substitute + moderate oil reduction',
    ),
    IndianSatietyItem(
      id: 'sat_4',
      name: 'Deep-Fried Samosa (1 pc)',
      calories: 310.0,
      proteinG: 4.0,
      fiberG: 1.0,
      weightGrams: 90.0,
      volumeMl: 100.0,
      novaProcessingTier: 3,
      fullnessFactorNote: 'Ultra-processed, high trans fat, zero fiber',
    ),
    IndianSatietyItem(
      id: 'sat_5',
      name: 'Indian Chai + 2 Biscuits',
      calories: 220.0,
      proteinG: 2.0,
      fiberG: 0.5,
      weightGrams: 150.0,
      volumeMl: 150.0,
      novaProcessingTier: 3,
      fullnessFactorNote: 'Rapid sugar absorption, high glycemic crash risk',
    ),
  ];
}

class SatietyPredictionResult {
  final double satietyScore; // 0 to 100
  final double proteinContribution;
  final double fiberContribution;
  final double volumeContribution;
  final double processingPenalty;
  final String fullnessNote;

  const SatietyPredictionResult({
    required this.satietyScore,
    required this.proteinContribution,
    required this.fiberContribution,
    required this.volumeContribution,
    required this.processingPenalty,
    required this.fullnessNote,
  });
}

/// Pure-Dart Satiety Prediction Engine per §P5-P spec
class SatietyPredictionEngine {
  const SatietyPredictionEngine();

  /// Calculates Satiety Index Score (0 to 100):
  /// Formula: Satiety Score = min(100, (2.8 * ProteinG) + (4 * FiberG) + (1.2 * WeightVolumeFraction) - (12 * NOVAProcessingTier))
  SatietyPredictionResult computeSatietyScore({
    required double proteinG,
    required double fiberG,
    required double weightGrams,
    required double volumeMl,
    required int novaProcessingTier,
    String note = '',
  }) {
    final weightVolumeFraction = volumeMl > 0 ? (weightGrams / volumeMl) * 50.0 : 50.0;

    final proteinContrib = 2.8 * proteinG;
    final fiberContrib = 4.0 * fiberG;
    final volumeContrib = 1.2 * weightVolumeFraction;
    final penalty = 12.0 * novaProcessingTier.clamp(0, 3);

    final rawScore = proteinContrib + fiberContrib + volumeContrib - penalty;
    final clampedScore = rawScore.clamp(0.0, 100.0);

    return SatietyPredictionResult(
      satietyScore: double.parse(clampedScore.toStringAsFixed(1)),
      proteinContribution: double.parse(proteinContrib.toStringAsFixed(1)),
      fiberContribution: double.parse(fiberContrib.toStringAsFixed(1)),
      volumeContribution: double.parse(volumeContrib.toStringAsFixed(1)),
      processingPenalty: double.parse(penalty.toStringAsFixed(1)),
      fullnessNote: note.isNotEmpty
          ? note
          : (clampedScore >= 75.0
              ? 'High Satiety: Keeps you full for 4+ hours.'
              : (clampedScore >= 45.0
                  ? 'Moderate Satiety: Pair with protein/water for extended fullness.'
                  : 'Low Satiety: High hunger rebound risk.')),
    );
  }

  /// Convenience predictor using seeded Indian food items
  SatietyPredictionResult computeForSeededItem(IndianSatietyItem item) {
    return computeSatietyScore(
      proteinG: item.proteinG,
      fiberG: item.fiberG,
      weightGrams: item.weightGrams,
      volumeMl: item.volumeMl,
      novaProcessingTier: item.novaProcessingTier,
      note: item.fullnessFactorNote,
    );
  }
}
