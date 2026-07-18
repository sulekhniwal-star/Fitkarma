enum ConfidenceTier {
  basic('Medium'),
  enhanced('High'),
  premium('Very High');

  final String confidenceLabel;
  const ConfidenceTier(this.confidenceLabel);
}

class ReadinessResult {
  final int score;
  final ConfidenceTier tier;
  final String confidence;

  const ReadinessResult({
    required this.score,
    required this.tier,
    required this.confidence,
  });
}

class ReadinessScoreCalculator {
  // All weights are configurable
  ReadinessResult calculate({
    required int sleepQuality,        // 1–5
    required int sleepDurationMin,
    required int sorenessLevel,       // 1–5
    required int stressLevel,         // 1–5
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    double score = 100.0;

    // Sleep quality (max 35 pts)
    score -= (5 - sleepQuality) * 7.0;
    if (sleepDurationMin < 360) score -= 10;  // < 6h
    if (sleepDurationMin < 300) score -= 10;  // < 5h

    // Soreness (max 20 pts)
    score -= (sorenessLevel - 1) * 5.0;

    // Stress (max 20 pts)
    score -= (stressLevel - 1) * 5.0;

    // HR deviation (max 15 pts) — only if available
    if (restingHR != null && baselineHR != null && baselineHR > 0) {
      final hrDelta = (restingHR - baselineHR) / baselineHR;
      if (hrDelta > 0.1) score -= 10;
      if (hrDelta > 0.2) score -= 5;
    }

    // HRV deviation (max 10 pts) — only if available
    if (hrv != null && baselineHRV != null && baselineHRV > 0) {
      final hrvDelta = (baselineHRV - hrv) / baselineHRV;
      if (hrvDelta > 0.15) score -= 10;
    }

    final tier = _determineTier(restingHR, hrv);
    return ReadinessResult(
      score: score.clamp(0, 100).round(),
      tier: tier,
      confidence: tier.confidenceLabel,
    );
  }

  ConfidenceTier _determineTier(double? restingHR, double? hrv) {
    if (restingHR != null && hrv != null) {
      return ConfidenceTier.premium;
    } else if (restingHR != null) {
      return ConfidenceTier.enhanced;
    } else {
      return ConfidenceTier.basic;
    }
  }
}
