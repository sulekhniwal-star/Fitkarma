class LongevityInputData {
  final int age;
  final String gender; // 'male', 'female'
  final double estimatedVO2Max; // e.g. 44.0
  final double bodyFatPct; // e.g. 18.5
  final double avgSleepH; // e.g. 7.5
  final double sleepQuality7dAvg; // 1.0 to 5.0 scale
  final int avgSteps7d; // e.g. 8500
  final int workoutsPerWeek; // e.g. 4
  final double restingHR; // e.g. 62.0
  final double hrv; // e.g. 65.0
  final double baselineHRV; // e.g. 60.0
  final bool hasClinicalData;
  final double hbA1c; // e.g. 5.4
  final double ldl; // e.g. 98.0
  final double hdl; // e.g. 55.0
  final double vitD; // e.g. 42.0

  const LongevityInputData({
    required this.age,
    required this.gender,
    required this.estimatedVO2Max,
    required this.bodyFatPct,
    required this.avgSleepH,
    required this.sleepQuality7dAvg,
    required this.avgSteps7d,
    required this.workoutsPerWeek,
    required this.restingHR,
    required this.hrv,
    required this.baselineHRV,
    this.hasClinicalData = false,
    this.hbA1c = 5.4,
    this.ldl = 98.0,
    this.hdl = 55.0,
    this.vitD = 42.0,
  });
}

class LongevityResult {
  final int longevityScore; // 0 to 100
  final int biologicalAge;
  final int chronologicalAge;
  final int ageDelta; // Positive = younger than actual age
  final double vo2maxScore;
  final double bodyFatScore;
  final double sleepScore;
  final double activityScore;
  final double biomarkerScore;
  final double cardioScore;
  final String biggestOpportunity;
  final DateTime updatedAt;

  const LongevityResult({
    required this.longevityScore,
    required this.biologicalAge,
    required this.chronologicalAge,
    required this.ageDelta,
    required this.vo2maxScore,
    required this.bodyFatScore,
    required this.sleepScore,
    required this.activityScore,
    required this.biomarkerScore,
    required this.cardioScore,
    required this.biggestOpportunity,
    required this.updatedAt,
  });
}

/// Pure-Dart Longevity Score + Biological Age Calculator per §P10-G spec (No AI)
class LongevityScoreCalculator {
  const LongevityScoreCalculator();

  LongevityResult calculate(LongevityInputData data) {
    // 1. VO2Max Score (25% weight)
    final vo2maxScore =
        _scoreVO2Max(data.estimatedVO2Max, data.age, data.gender);

    // 2. Body Composition Score (15% weight)
    final bodyFatScore = _scoreBodyFat(data.bodyFatPct, data.gender);

    // 3. Sleep Score (20% weight)
    final sleepScore = _scoreSleep(data.avgSleepH, data.sleepQuality7dAvg);

    // 4. Activity Level Score (15% weight)
    final activityScore = _scoreActivity(data.avgSteps7d, data.workoutsPerWeek);

    // 5. Biomarkers Score (15% weight)
    final biomarkerScore = data.hasClinicalData
        ? _scoreBiomarkers(data.hbA1c, data.ldl, data.hdl, data.vitD)
        : 75.0;

    // 6. Cardiovascular Efficiency Score (10% weight)
    final cardioScore =
        _scoreCardio(data.restingHR, data.hrv, data.baselineHRV);

    final rawLongevityScore = (vo2maxScore * 0.25 +
        bodyFatScore * 0.15 +
        sleepScore * 0.20 +
        activityScore * 0.15 +
        biomarkerScore * 0.15 +
        cardioScore * 0.10);

    final longevityScore = rawLongevityScore.round().clamp(0, 100);

    // Estimate Biological Age: 80 score = exact actual age. Higher score = younger bio age.
    final ageAdjustment = ((80.0 - rawLongevityScore) * 0.2).round();
    final bioAge = (data.age + ageAdjustment).clamp(18, 100);
    final ageDelta = data.age - bioAge;

    final opportunity = _resolveOpportunity(
      vo2maxScore: vo2maxScore,
      bodyFatScore: bodyFatScore,
      sleepScore: sleepScore,
      activityScore: activityScore,
      biomarkerScore: biomarkerScore,
    );

    return LongevityResult(
      longevityScore: longevityScore,
      biologicalAge: bioAge,
      chronologicalAge: data.age,
      ageDelta: ageDelta,
      vo2maxScore: vo2maxScore,
      bodyFatScore: bodyFatScore,
      sleepScore: sleepScore,
      activityScore: activityScore,
      biomarkerScore: biomarkerScore,
      cardioScore: cardioScore,
      biggestOpportunity: opportunity,
      updatedAt: DateTime.now(),
    );
  }

  double _scoreVO2Max(double vo2max, int age, String gender) {
    double baseline = gender == 'male' ? 42.0 : 36.0;
    if (age > 40) baseline -= (age - 40) * 0.3;
    final ratio = vo2max / baseline;
    return (ratio * 80.0).clamp(40.0, 100.0);
  }

  double _scoreBodyFat(double bodyFatPct, String gender) {
    final isMale = gender == 'male';
    final idealMin = isMale ? 10.0 : 18.0;
    final idealMax = isMale ? 20.0 : 28.0;

    if (bodyFatPct >= idealMin && bodyFatPct <= idealMax) return 90.0;
    if (bodyFatPct < idealMin) return 80.0;
    final excess = bodyFatPct - idealMax;
    return (90.0 - excess * 3.0).clamp(30.0, 100.0);
  }

  double _scoreSleep(double sleepHours, double sleepQuality) {
    double score = 70.0;
    if (sleepHours >= 7.0 && sleepHours <= 9.0) score += 15.0;
    score += (sleepQuality / 5.0) * 15.0;
    return score.clamp(30.0, 100.0);
  }

  double _scoreActivity(int steps, int workouts) {
    double stepScore = (steps / 10000.0) * 50.0;
    double workoutScore = (workouts / 4.0) * 50.0;
    return (stepScore + workoutScore).clamp(30.0, 100.0);
  }

  double _scoreBiomarkers(double hbA1c, double ldl, double hdl, double vitD) {
    double score = 100.0;
    if (hbA1c > 5.7) score -= 15.0;
    if (ldl > 100.0) score -= 10.0;
    if (hdl < 40.0) score -= 10.0;
    if (vitD < 30.0) score -= 15.0;
    return score.clamp(40.0, 100.0);
  }

  double _scoreCardio(double rhr, double hrv, double baselineHrv) {
    double score = 80.0;
    if (rhr < 60) score += 10.0;
    if (rhr > 75) score -= 10.0;
    if (hrv >= baselineHrv) score += 10.0;
    return score.clamp(30.0, 100.0);
  }

  String _resolveOpportunity({
    required double vo2maxScore,
    required double bodyFatScore,
    required double sleepScore,
    required double activityScore,
    required double biomarkerScore,
  }) {
    final scores = {
      'Body Composition': bodyFatScore,
      'VO2 Max': vo2maxScore,
      'Sleep Quality': sleepScore,
      'Activity Level': activityScore,
      'Biomarkers': biomarkerScore,
    };

    final lowestEntry =
        scores.entries.reduce((a, b) => a.value < b.value ? a : b);
    return '${lowestEntry.key}: Improving this metric would add +3 points and improve your biological age by ~1 year.';
  }
}
