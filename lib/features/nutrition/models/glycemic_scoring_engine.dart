class CgmReading {
  final DateTime timestamp;
  final double glucoseMgDl;

  const CgmReading({required this.timestamp, required this.glucoseMgDl});
}

class FoodGlycemicScore {
  final double score; // 1.0 to 10.0
  final double glucoseDelta; // Peak (90 min post-meal) - Baseline (pre-meal)
  final String recommendation;

  const FoodGlycemicScore({
    required this.score,
    required this.glucoseDelta,
    required this.recommendation,
  });
}

/// Pure-Dart Glycemic Response & Personal Food Scoring Engine per §P5-M spec
class GlycemicScoringEngine {
  const GlycemicScoringEngine();

  /// Calculates Personal Food Score (1 to 10) based on CGM post-meal glucose curve:
  /// - Delta < 25 mg/dL: 10/10 (Optimal energy stability)
  /// - Delta 25..45 mg/dL: 7/10 (Moderate glycemic variance)
  /// - Delta > 45 mg/dL: 3/10 (Poor glycemic response; triggers crash risk)
  FoodGlycemicScore computeScore({
    required List<CgmReading> postMealReadings,
    required double baselineGlucose,
    String foodItemName = 'This food',
  }) {
    if (postMealReadings.isEmpty) {
      return FoodGlycemicScore(
        score: 10.0,
        glucoseDelta: 0.0,
        recommendation:
            'No post-meal CGM readings available to compute spike delta.',
      );
    }

    final peakReading = postMealReadings
        .map((r) => r.glucoseMgDl)
        .reduce((a, b) => a > b ? a : b);

    final spikeDelta = peakReading - baselineGlucose;

    double rating = 10.0;
    String recommendation =
        'Great glycemic response. Enjoy this food with optimal energy stability.';

    if (spikeDelta > 45.0) {
      rating = 3.0;
      recommendation =
          '$foodItemName spikes your glucose by +${spikeDelta.round()} mg/dL. Try pairing it with 10 almonds, healthy fats, or half a scoop of protein to blunt the insulin spike.';
    } else if (spikeDelta >= 25.0) {
      rating = 7.0;
      recommendation =
          'Moderate glucose spike (+${spikeDelta.round()} mg/dL). Keep portion size in check or eat protein/fiber first.';
    }

    return FoodGlycemicScore(
      score: rating,
      glucoseDelta: double.parse(spikeDelta.toStringAsFixed(1)),
      recommendation: recommendation,
    );
  }
}
