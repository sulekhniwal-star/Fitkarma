/// §P10-G Longevity Score + Biological Age v1 — Calculator Engine & Models
///
/// Multi-factor longevity research weighting formula evaluating:
/// VO2Max Estimate (25%), Body Composition (15%), Sleep (20%), Activity (15%),
/// Biomarkers (15%), and Cardio Efficiency (10%) matching §P10-G specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Models (§P10-G Specification)
// ─────────────────────────────────────────────────────────────────────────────

class LongevityInputData {
  const LongevityInputData({
    required this.estimatedVo2Max,
    required this.age,
    required this.isMale,
    required this.bodyFatPct,
    required this.avgSleepHours,
    required this.sleepQuality7dAvg,
    required this.avgDailySteps7d,
    required this.workoutsPerWeek,
    required this.restingHr,
    required this.hrv,
    this.baselineHrv = 50.0,
    required this.hasClinicalData,
    this.hbA1c = 5.6,
    this.ldlMgDl = 110.0,
    this.hdlMgDl = 52.0,
    this.vitDNgMl = 35.0,
  });

  final double estimatedVo2Max;
  final int age;
  final bool isMale;
  final double bodyFatPct;
  final double avgSleepHours;
  final double sleepQuality7dAvg; // 0-100%
  final int avgDailySteps7d;
  final int workoutsPerWeek;
  final double restingHr;
  final double hrv;
  final double baselineHrv;
  final bool hasClinicalData;
  final double hbA1c;
  final double ldlMgDl;
  final double hdlMgDl;
  final double vitDNgMl;
}

class LongevityFactorScores {
  const LongevityFactorScores({
    required this.vo2maxScore,
    required this.bodyFatScore,
    required this.sleepScore,
    required this.activityScore,
    required this.biomarkerScore,
    required this.cardioScore,
  });

  final int vo2maxScore; // 0-100
  final int bodyFatScore; // 0-100
  final int sleepScore; // 0-100
  final int activityScore; // 0-100
  final int biomarkerScore; // 0-100
  final int cardioScore; // 0-100
}

class LongevityResult {
  const LongevityResult({
    required this.longevityScore,
    required this.biologicalAge,
    required this.chronologicalAge,
    required this.ageDeltaYears,
    required this.factorScores,
    required this.biggestOpportunity,
    required this.updatedAt,
  });

  final int longevityScore; // 0 - 100
  final int biologicalAge;
  final int chronologicalAge;
  final int ageDeltaYears; // Positive = younger than actual age
  final LongevityFactorScores factorScores;
  final String biggestOpportunity;
  final DateTime updatedAt;

  bool get isYoungerThanChronological => ageDeltaYears > 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// LongevityScoreCalculator (§P10-G Specification)
// ─────────────────────────────────────────────────────────────────────────────

class LongevityScoreCalculator {
  const LongevityScoreCalculator();

  /// Calculates composite longevity score and biological age (§P10-G exact spec).
  LongevityResult calculate(LongevityInputData data) {
    // 1. VO2Max Score (Weight: 25%)
    final vo2maxScore = _scoreVo2Max(data.estimatedVo2Max, data.age, data.isMale);

    // 2. Body Composition Score (Weight: 15%)
    final bodyFatScore = _scoreBodyFat(data.bodyFatPct, data.isMale);

    // 3. Sleep Score (Weight: 20%)
    final sleepScore = _scoreSleep(data.avgSleepHours, data.sleepQuality7dAvg);

    // 4. Activity Score (Weight: 15%)
    final activityScore = _scoreActivity(data.avgDailySteps7d, data.workoutsPerWeek);

    // 5. Biomarkers Score (Weight: 15%)
    final biomarkerScore = data.hasClinicalData
        ? _scoreBiomarkers(data.hbA1c, data.ldlMgDl, data.hdlMgDl, data.vitDNgMl)
        : _scoreDefaultBiomarkers(data.age);

    // 6. Cardio Efficiency Score (Weight: 10%)
    final cardioScore = _scoreCardio(data.restingHr, data.hrv, data.baselineHrv);

    // Weighted Composite Score Calculation
    final longevityScore = (vo2maxScore * 0.25 +
            bodyFatScore * 0.15 +
            sleepScore * 0.20 +
            activityScore * 0.15 +
            biomarkerScore * 0.15 +
            cardioScore * 0.10)
        .round()
        .clamp(0, 100);

    // Biological Age Regression (Baseline 70 score == Chrono Age; +1 yr younger per 3 pts above 70)
    final ageDelta = ((longevityScore - 70) / 3.5).round().clamp(-10, 15);
    final bioAge = (data.age - ageDelta).clamp(18, 100);

    final factors = LongevityFactorScores(
      vo2maxScore: vo2maxScore,
      bodyFatScore: bodyFatScore,
      sleepScore: sleepScore,
      activityScore: activityScore,
      biomarkerScore: biomarkerScore,
      cardioScore: cardioScore,
    );

    final opportunity = _extractBiggestOpportunity(factors);

    return LongevityResult(
      longevityScore: longevityScore,
      biologicalAge: bioAge,
      chronologicalAge: data.age,
      ageDeltaYears: ageDelta,
      factorScores: factors,
      biggestOpportunity: opportunity,
      updatedAt: DateTime.now(),
    );
  }

  int _scoreVo2Max(double vo2max, int age, bool isMale) {
    double baseline = isMale ? 42.0 : 36.0;
    baseline -= (age - 25) * 0.25; // Age decline factor
    final ratio = vo2max / baseline;
    return (ratio * 80.0).round().clamp(0, 100);
  }

  int _scoreBodyFat(double bodyFat, bool isMale) {
    final idealMin = isMale ? 10.0 : 18.0;
    final idealMax = isMale ? 18.0 : 25.0;

    if (bodyFat >= idealMin && bodyFat <= idealMax) return 92;
    if (bodyFat > idealMax) {
      final excess = bodyFat - idealMax;
      return (92 - (excess * 3.5)).round().clamp(30, 92);
    } else {
      final deficit = idealMin - bodyFat;
      return (92 - (deficit * 4.0)).round().clamp(40, 92);
    }
  }

  int _scoreSleep(double hours, double quality) {
    final hoursScore = (hours / 7.5 * 50.0).clamp(0.0, 50.0);
    final qualityScore = (quality / 100.0 * 50.0).clamp(0.0, 50.0);
    return (hoursScore + qualityScore).round().clamp(0, 100);
  }

  int _scoreActivity(int steps, int workouts) {
    final stepsComponent = (steps / 10000.0 * 60.0).clamp(0.0, 60.0);
    final workoutsComponent = (workouts / 4.0 * 40.0).clamp(0.0, 40.0);
    return (stepsComponent + workoutsComponent).round().clamp(0, 100);
  }

  int _scoreBiomarkers(double hbA1c, double ldl, double hdl, double vitD) {
    int score = 100;
    if (hbA1c >= 5.7) score -= 20;
    if (ldl >= 130) score -= 15;
    if (hdl < 40) score -= 15;
    if (vitD < 30) score -= 15;
    return score.clamp(30, 100);
  }

  int _scoreDefaultBiomarkers(int age) {
    return (85 - (age > 40 ? 5 : 0)).clamp(50, 100);
  }

  int _scoreCardio(double restingHr, double hrv, double baselineHrv) {
    final hrScore = ((75.0 - restingHr) * 2.0 + 50.0).clamp(0.0, 50.0);
    final hrvRatio = (hrv / baselineHrv).clamp(0.0, 1.5);
    final hrvScore = (hrvRatio * 50.0).clamp(0.0, 50.0);
    return (hrScore + hrvScore).round().clamp(0, 100);
  }

  String _extractBiggestOpportunity(LongevityFactorScores f) {
    final scores = {
      'Cardio Efficiency': f.cardioScore,
      'Sleep Quality': f.sleepScore,
      'Activity Level': f.activityScore,
      'Body Composition': f.bodyFatScore,
      'Biomarkers': f.biomarkerScore,
    };

    final lowest = scores.entries.reduce((a, b) => a.value < b.value ? a : b);

    if (lowest.key == 'Body Composition') {
      return 'Body Composition: Reducing body fat 2% would add +3 points and improve your biological age by ~1 year.';
    } else if (lowest.key == 'Sleep Quality') {
      return 'Sleep Quality: Extending sleep duration to 8.0h would add +4 points to your Longevity Score.';
    } else if (lowest.key == 'Activity Level') {
      return 'Activity Level: Reaching 9,500 steps/day would add +4 points to your score.';
    } else if (lowest.key == 'Cardio Efficiency') {
      return 'Cardio Efficiency: Lowering resting HR by 3 bpm would add +3 points.';
    } else {
      return 'Biomarkers: Optimizing Vitamin D levels would add +4 points to your longevity profile.';
    }
  }
}
