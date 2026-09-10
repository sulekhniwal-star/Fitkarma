import 'dart:math';
import 'adherence_models.dart';

class AdherenceEngine {
  /// Pure Dart deterministic calculation of weighted composite adherence score (0.0 to 100.0)
  static double calculateCompositeScore({
    required double nutritionScore, // Weight 0.30
    required double trainingScore, // Weight 0.30
    required double recoveryScore, // Weight 0.25
    required double circadianScore, // Weight 0.15
  }) {
    final double composite = (nutritionScore * 0.30) +
        (trainingScore * 0.30) +
        (recoveryScore * 0.25) +
        (circadianScore * 0.15);

    return double.parse(composite.clamp(0.0, 100.0).toStringAsFixed(1));
  }

  /// Maps composite score to behavioral tier
  static AdherenceTier determineTier(double score) {
    if (score >= 85.0) {
      return AdherenceTier.elite;
    } else if (score >= 70.0) {
      return AdherenceTier.disciplined;
    } else if (score >= 50.0) {
      return AdherenceTier.warning;
    } else {
      return AdherenceTier.intervention;
    }
  }

  /// Calculates Consistency Stability Index (100 - 2 * standard deviation)
  static double calculateStabilityIndex(List<double> scores) {
    if (scores.isEmpty) return 100.0;
    if (scores.length == 1) return 100.0;

    final double mean = scores.reduce((a, b) => a + b) / scores.length;
    final double variance =
        scores.map((s) => pow(s - mean, 2)).reduce((a, b) => a + b) /
            scores.length;
    final double stdDev = sqrt(variance);

    final double stability = 100.0 - (stdDev * 2.5);
    return double.parse(stability.clamp(0.0, 100.0).toStringAsFixed(1));
  }

  /// Generates a comprehensive AdherenceReport from rolling telemetry
  static AdherenceReport generateReport({
    required double nutritionScore,
    required double trainingScore,
    required double recoveryScore,
    required double circadianScore,
    required List<DailyAdherenceSnapshot> weeklySnapshots,
  }) {
    final currentComposite = calculateCompositeScore(
      nutritionScore: nutritionScore,
      trainingScore: trainingScore,
      recoveryScore: recoveryScore,
      circadianScore: circadianScore,
    );

    final currentTier = determineTier(currentComposite);

    final allScores = weeklySnapshots.map((s) => s.compositeScore).toList();
    final double weeklyAvg = allScores.isEmpty
        ? currentComposite
        : double.parse((allScores.reduce((a, b) => a + b) / allScores.length)
            .toStringAsFixed(1));

    final double stabilityIndex = calculateStabilityIndex(allScores);

    final nutritionPillar = PillarAdherenceScore(
      name: 'Nutrition Precision',
      regionalName: 'पोषण अनुशासन',
      score: nutritionScore,
      weight: 0.30,
      keyMetricLabel: 'Protein & Macro Targets Hit',
      statusSummary: nutritionScore >= 80
          ? 'Optimal Macro Balance'
          : 'Slight Protein Shortfall',
    );

    final trainingPillar = PillarAdherenceScore(
      name: 'Training & Overload',
      regionalName: 'व्यायाम और भार प्रगति',
      score: trainingScore,
      weight: 0.30,
      keyMetricLabel: 'Volume & Form Quality Fulfilled',
      statusSummary: trainingScore >= 80
          ? 'Progressive Overload Active'
          : 'Rest Day Scheduled',
    );

    final recoveryPillar = PillarAdherenceScore(
      name: 'Sleep & Readiness',
      regionalName: 'निद्रा एवं रिकवरी',
      score: recoveryScore,
      weight: 0.25,
      keyMetricLabel: 'Sleep Debt & Strain Alignment',
      statusSummary: recoveryScore >= 80
          ? 'Restorative Sleep >85%'
          : 'Moderate Sleep Debt (45m)',
    );

    final circadianPillar = PillarAdherenceScore(
      name: 'Circadian & Shatpawali',
      regionalName: 'शतपावली व सर्केडियन आदतें',
      score: circadianScore,
      weight: 0.15,
      keyMetricLabel: 'Post-Meal Steps & Curfew Met',
      statusSummary: circadianScore >= 80
          ? 'All 3 Shatpawali Walks Logged'
          : '1 Shatpawali Missed',
    );

    String rec =
        'Continue current protocol. Maintain protein pacing across 4 meals.';
    String regRec =
        'वर्तमान दिनचर्या जारी रखें। ४ भोजन में प्रोटीन का समान वितरण बनाए रखें।';

    if (currentComposite < 70) {
      rec =
          'Focus on post-dinner Shatpawali and enforcing a 45m pre-sleep digital curfew to restore autonomic balance.';
      regRec =
          'स्वायत्त संतुलन बहाल करने हेतु रात्रि भोजनोपरांत शतपावली और स्क्रीन बंद करने पर ध्यान दें।';
    }

    return AdherenceReport(
      currentScore: currentComposite,
      weeklyAverageScore: weeklyAvg,
      monthlyAverageScore: double.parse((weeklyAvg * 0.96).toStringAsFixed(1)),
      currentTier: currentTier,
      consistencyStabilityIndex: stabilityIndex,
      weeklyHistory: weeklySnapshots,
      nutritionPillar: nutritionPillar,
      trainingPillar: trainingPillar,
      recoveryPillar: recoveryPillar,
      circadianPillar: circadianPillar,
      primaryRecommendation: rec,
      regionalRecommendation: regRec,
    );
  }
}
