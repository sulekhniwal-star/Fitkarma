enum EvolutionTrend { deload, maintain, progressiveOverload, aggressiveAdvance }

class ProgramEvolutionRecommendation {
  final EvolutionTrend trend;
  final double volumeAdjustmentPercent; // e.g. -20% for deload, +5% for progressive overload
  final String rationale;
  final String rationaleHindi;

  const ProgramEvolutionRecommendation({
    required this.trend,
    required this.volumeAdjustmentPercent,
    required this.rationale,
    required this.rationaleHindi,
  });
}

/// ProgramEvolutionEngine (Pure Dart / Deterministic)
/// Analyzes weekly workout completion rate, recovery score averages, and soreness indicators to adjust training loads.
class ProgramEvolutionEngine {
  const ProgramEvolutionEngine();

  ProgramEvolutionRecommendation evaluateWeeklyCycle({
    required double adherenceRate, // 0.0 to 1.0 (e.g. 0.85 = 85%)
    required double averageReadinessScore, // 0 - 100
    required int sorenessFlagCount, // Soreness flags recorded across the week
  }) {
    if (averageReadinessScore < 50 || sorenessFlagCount >= 4) {
      return const ProgramEvolutionRecommendation(
        trend: EvolutionTrend.deload,
        volumeAdjustmentPercent: -25.0,
        rationale: 'High accumulated fatigue detected. Prescribing a recovery deload week (-25% volume).',
        rationaleHindi: 'अत्यधिक थकान पाई गई। रिकवरी के लिए इस सप्ताह 25% कम भार का सुझाव है।',
      );
    }

    if (adherenceRate >= 0.85 && averageReadinessScore >= 75) {
      return const ProgramEvolutionRecommendation(
        trend: EvolutionTrend.progressiveOverload,
        volumeAdjustmentPercent: 5.0,
        rationale: 'Excellent recovery and high adherence. Incrementing weekly volume by +5%.',
        rationaleHindi: 'उत्कृष्ट रिकवरी और निरंतरता! इस सप्ताह 5% प्रगतिशील भार बढ़ाया गया है।',
      );
    }

    return const ProgramEvolutionRecommendation(
      trend: EvolutionTrend.maintain,
      volumeAdjustmentPercent: 0.0,
      rationale: 'Optimal equilibrium maintained. Continuing current workout programming.',
      rationaleHindi: 'संतुलन बना हुआ है। वर्तमान योजना जारी रखें।',
    );
  }
}
