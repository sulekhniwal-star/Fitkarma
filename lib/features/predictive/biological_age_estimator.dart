/// §P10-B Biological Age Estimation — Engine & Models
///
/// Implements monthly biological-age regression algorithm (deterministic, no AI)
/// comparing user monthly metrics against WHO population baselines matching §P10-B specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Models (§P10-B Specification)
// ─────────────────────────────────────────────────────────────────────────────

class UserMonthlyHealthSnapshot {
  const UserMonthlyHealthSnapshot({
    required this.chronologicalAge,
    required this.restingHrBpm,
    required this.hrvMs,
    required this.sleepHoursAvg,
    required this.bmi,
    required this.dailyStepsAvg,
    required this.fastingGlucoseMgDl,
    required this.calculationDate,
  });

  final int chronologicalAge;
  final double restingHrBpm;
  final double hrvMs;
  final double sleepHoursAvg;
  final double bmi;
  final int dailyStepsAvg;
  final double fastingGlucoseMgDl;
  final DateTime calculationDate;
}

class BiologicalAgeResult {
  const BiologicalAgeResult({
    required this.chronologicalAge,
    required this.estimatedBiologicalAge,
    required this.ageDeltaYears,
    required this.primaryDrivers,
    required this.calculationDate,
  });

  final int chronologicalAge;
  final int estimatedBiologicalAge;
  final double ageDeltaYears;
  final List<String> primaryDrivers;
  final DateTime calculationDate;

  bool get isYoungerThanChronological => ageDeltaYears < 0;
}

// ─────────────────────────────────────────────────────────────────────────────
// BiologicalAgeEstimator (§P10-B Specification)
// ─────────────────────────────────────────────────────────────────────────────

class BiologicalAgeEstimator {
  const BiologicalAgeEstimator();

  // WHO Population Baseline Standards
  static const double baselineRestingHr = 65.0; // bpm
  static const double baselineHrv = 50.0; // ms
  static const double baselineSleep = 7.5; // hours
  static const double baselineBmi = 22.5; // kg/m²
  static const int baselineSteps = 8000; // daily steps
  static const double baselineGlucose = 90.0; // mg/dL

  /// Deterministic Multi-Factor Regression vs WHO Baseline (§P10-B spec, ADR-023: no AI, updated monthly):
  ///
  /// - Resting HR delta: `(restingHR - 65.0) * 0.15`
  /// - HRV delta: `(50.0 - hrv) * 0.10`
  /// - Sleep delta: `(7.5 - sleepHours) * 0.80`
  /// - BMI delta: `(bmi - 22.5) * 0.40`
  /// - Steps delta: `(8000 - dailySteps) / 1000.0 * 0.35`
  /// - Glucose delta: `(fastingGlucose - 90.0) * 0.12`
  BiologicalAgeResult estimate(UserMonthlyHealthSnapshot snapshot) {
    double totalDelta = 0.0;
    final drivers = <String>[];

    // 1. Resting HR Impact
    final hrDelta = (snapshot.restingHrBpm - baselineRestingHr) * 0.15;
    totalDelta += hrDelta;
    if (hrDelta.abs() >= 0.3) {
      final sign = hrDelta < 0 ? '-' : '+';
      drivers.add('Resting HR ${snapshot.restingHrBpm.round()} bpm ($sign${hrDelta.abs().toStringAsFixed(1)} yrs)');
    }

    // 2. HRV Impact
    final hrvDelta = (baselineHrv - snapshot.hrvMs) * 0.10;
    totalDelta += hrvDelta;
    if (hrvDelta.abs() >= 0.3) {
      final sign = hrvDelta < 0 ? '-' : '+';
      drivers.add('HRV ${snapshot.hrvMs.round()} ms ($sign${hrvDelta.abs().toStringAsFixed(1)} yrs)');
    }

    // 3. Sleep Impact
    final sleepDelta = (baselineSleep - snapshot.sleepHoursAvg) * 0.80;
    totalDelta += sleepDelta;
    if (sleepDelta.abs() >= 0.3) {
      final sign = sleepDelta < 0 ? '-' : '+';
      drivers.add('Sleep ${snapshot.sleepHoursAvg.toStringAsFixed(1)}h ($sign${sleepDelta.abs().toStringAsFixed(1)} yrs)');
    }

    // 4. BMI Impact
    final bmiDelta = (snapshot.bmi - baselineBmi) * 0.40;
    totalDelta += bmiDelta;
    if (bmiDelta.abs() >= 0.3) {
      final sign = bmiDelta < 0 ? '-' : '+';
      drivers.add('BMI ${snapshot.bmi.toStringAsFixed(1)} ($sign${bmiDelta.abs().toStringAsFixed(1)} yrs)');
    }

    // 5. Daily Steps Impact
    final stepsDelta = (baselineSteps - snapshot.dailyStepsAvg) / 1000.0 * 0.35;
    totalDelta += stepsDelta;
    if (stepsDelta.abs() >= 0.3) {
      final sign = stepsDelta < 0 ? '-' : '+';
      drivers.add('Steps ${snapshot.dailyStepsAvg} ($sign${stepsDelta.abs().toStringAsFixed(1)} yrs)');
    }

    // 6. Fasting Glucose Impact
    final glucoseDelta = (snapshot.fastingGlucoseMgDl - baselineGlucose) * 0.12;
    totalDelta += glucoseDelta;
    if (glucoseDelta.abs() >= 0.3) {
      final sign = glucoseDelta < 0 ? '-' : '+';
      drivers.add('Glucose ${snapshot.fastingGlucoseMgDl.round()} mg/dL ($sign${glucoseDelta.abs().toStringAsFixed(1)} yrs)');
    }

    // Clamp total delta within realistic bounds [-10.0, +15.0] years
    final clampedDelta = double.parse(totalDelta.clamp(-10.0, 15.0).toStringAsFixed(1));
    final estimatedBioAge = (snapshot.chronologicalAge + clampedDelta).round();

    return BiologicalAgeResult(
      chronologicalAge: snapshot.chronologicalAge,
      estimatedBiologicalAge: estimatedBioAge,
      ageDeltaYears: clampedDelta,
      primaryDrivers: drivers.isEmpty ? ['Optimal health parameters across all baselines'] : drivers,
      calculationDate: snapshot.calculationDate,
    );
  }
}
