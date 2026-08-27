import 'dart:math';

class ProjectedDayForecast {
  final String dayLabel; // e.g. 'Tomorrow', 'Day +2'
  final int projectedReadiness; // 0 to 100
  final String optimalFocus;
  final bool isPrWindow;

  const ProjectedDayForecast({
    required this.dayLabel,
    required this.projectedReadiness,
    required this.optimalFocus,
    this.isPrWindow = false,
  });
}

class RecoveryAgeReport {
  final int chronologicalAge;
  final double biologicalRecoveryAge;
  final double ageDelta; // negative is younger/better
  final int hrvContributionPoints;
  final int rhrContributionPoints;
  final int sleepContributionPoints;
  final List<ProjectedDayForecast> forecasts;
  final String recoveryLongevityInsight;

  const RecoveryAgeReport({
    required this.chronologicalAge,
    required this.biologicalRecoveryAge,
    required this.ageDelta,
    required this.hrvContributionPoints,
    required this.rhrContributionPoints,
    required this.sleepContributionPoints,
    required this.forecasts,
    required this.recoveryLongevityInsight,
  });
}

class RecoveryForecastingEngine {
  /// Pure Dart deterministic calculation of Biological Recovery Age and 48-Hour Forecasting
  static RecoveryAgeReport calculateRecoveryAge({
    required int chronologicalAge,
    double rolling14DayHrvMs = 58.0,
    double restingHrBpm = 56.0,
    double deepSleepPercent = 0.18,
    double currentDayStrain = 13.5,
    int currentReadiness = 76,
  }) {
    // 1. HRV Age Baseline Offset (Population average at age 30 is ~45-55ms)
    // Every 10ms above expected adds ~ -1.5 years of biological recovery vitality
    final expectedHrvForAge = (70.0 - (chronologicalAge * 0.55)).clamp(20.0, 75.0);
    final hrvDelta = rolling14DayHrvMs - expectedHrvForAge;
    final hrvAgeShift = -(hrvDelta / 7.0).clamp(-5.0, 5.0);

    // 2. Resting Heart Rate Offset (Baseline 65 bpm)
    final rhrDelta = restingHrBpm - 65.0;
    final rhrAgeShift = (rhrDelta / 5.0).clamp(-4.0, 4.0);

    // 3. Sleep Architecture Offset (Deep Sleep target >= 18%)
    final deepDelta = deepSleepPercent - 0.18;
    final sleepAgeShift = -(deepDelta * 30.0).clamp(-3.0, 3.0);

    final totalDelta = hrvAgeShift + rhrAgeShift + sleepAgeShift;
    final biologicalAge = (chronologicalAge + totalDelta).clamp(18.0, 85.0);

    // 4. 48-72 Hour Predictive Readiness Forecast
    final List<ProjectedDayForecast> forecasts = [];

    // Tomorrow: impacted by today's strain
    final int tomorrowReadiness;
    final String tomorrowFocus;
    final bool tomorrowPr;

    if (currentDayStrain > 16.0) {
      tomorrowReadiness = (currentReadiness * 0.85).round().clamp(45, 75);
      tomorrowFocus = 'Active Recovery & Zone 2 Light Flush';
      tomorrowPr = false;
    } else if (currentDayStrain > 12.0) {
      tomorrowReadiness = (currentReadiness * 0.95).round().clamp(60, 85);
      tomorrowFocus = 'Standard Hypertrophy & Technique Focus';
      tomorrowPr = false;
    } else {
      tomorrowReadiness = min(95, currentReadiness + 8);
      tomorrowFocus = 'Prime Nervous System: High Intensity PR Window';
      tomorrowPr = true;
    }

    forecasts.add(
      ProjectedDayForecast(
        dayLabel: 'Tomorrow',
        projectedReadiness: tomorrowReadiness,
        optimalFocus: tomorrowFocus,
        isPrWindow: tomorrowPr,
      ),
    );

    // Day +2 (Supercompensation wave)
    final int dayAfterTomorrowReadiness = min(95, tomorrowReadiness + 12);
    final isDay2Pr = dayAfterTomorrowReadiness >= 85;

    forecasts.add(
      ProjectedDayForecast(
        dayLabel: 'Day +2',
        projectedReadiness: dayAfterTomorrowReadiness,
        optimalFocus: isDay2Pr
            ? 'Supercompensation Peak: Schedule Heaviest Compound Lift'
            : 'Balanced Training Capacity',
        isPrWindow: isDay2Pr,
      ),
    );

    // 5. Longevity Insight
    final String longevityInsight;
    if (totalDelta <= -2.0) {
      longevityInsight = 'Your autonomic recovery efficiency is operating ${totalDelta.abs().toStringAsFixed(1)} years younger than your chronological age.';
    } else if (totalDelta >= 2.0) {
      longevityInsight = 'Autonomic fatigue is elevating biological strain by +${totalDelta.toStringAsFixed(1)} years. Focus on deep sleep and breathwork.';
    } else {
      longevityInsight = 'Biological recovery is perfectly aligned with your chronological baseline.';
    }

    return RecoveryAgeReport(
      chronologicalAge: chronologicalAge,
      biologicalRecoveryAge: double.parse(biologicalAge.toStringAsFixed(1)),
      ageDelta: double.parse(totalDelta.toStringAsFixed(1)),
      hrvContributionPoints: (hrvAgeShift * 10).round().abs(),
      rhrContributionPoints: (rhrAgeShift * 10).round().abs(),
      sleepContributionPoints: (sleepAgeShift * 10).round().abs(),
      forecasts: forecasts,
      recoveryLongevityInsight: longevityInsight,
    );
  }
}
