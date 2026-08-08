class BiologicalAgeInputs {
  final int chronologicalAge;
  final double restingHeartRateBpm;
  final double hrvMs;
  final double sleepQualityScore; // 0 - 100
  final double bmi;
  final int monthlyAverageDailySteps;
  final double fastingGlucoseMgDl;

  const BiologicalAgeInputs({
    required this.chronologicalAge,
    required this.restingHeartRateBpm,
    required this.hrvMs,
    required this.sleepQualityScore,
    required this.bmi,
    required this.monthlyAverageDailySteps,
    required this.fastingGlucoseMgDl,
  });
}

class BiologicalAgeEstimationResult {
  final int chronologicalAge;
  final double biologicalAge;
  final double ageDeltaYears; // Negative = younger than chronological age
  final List<String> positiveContributors;
  final List<String> riskFactors;

  const BiologicalAgeEstimationResult({
    required this.chronologicalAge,
    required this.biologicalAge,
    required this.ageDeltaYears,
    required this.positiveContributors,
    required this.riskFactors,
  });
}

/// Pure-Dart Biological Age Estimator per §P10-B & ADR-023 spec
/// Calculates biological age monthly using multi-factor regression vs population baselines (No AI)
class BiologicalAgeEstimator {
  const BiologicalAgeEstimator();

  BiologicalAgeEstimationResult estimate(BiologicalAgeInputs inputs) {
    double ageAdjustment = 0.0;
    final positiveContributors = <String>[];
    final riskFactors = <String>[];

    // 1. Resting Heart Rate (Baseline ~ 65 bpm)
    if (inputs.restingHeartRateBpm < 60) {
      ageAdjustment -= 1.5;
      positiveContributors.add('Low Resting Heart Rate (<60 bpm)');
    } else if (inputs.restingHeartRateBpm > 75) {
      ageAdjustment += 1.5;
      riskFactors.add('Elevated Resting Heart Rate (>75 bpm)');
    }

    // 2. Heart Rate Variability (Baseline ~ 50 ms)
    if (inputs.hrvMs >= 65) {
      ageAdjustment -= 2.0;
      positiveContributors.add('High HRV (≥65 ms)');
    } else if (inputs.hrvMs < 40) {
      ageAdjustment += 2.0;
      riskFactors.add('Low HRV (<40 ms)');
    }

    // 3. Sleep Quality Score (Baseline ~ 75)
    if (inputs.sleepQualityScore >= 80) {
      ageAdjustment -= 1.0;
      positiveContributors.add('Optimal Sleep Quality (≥80 score)');
    } else if (inputs.sleepQualityScore < 60) {
      ageAdjustment += 1.5;
      riskFactors.add('Sub-optimal Sleep Quality (<60 score)');
    }

    // 4. BMI (Optimal ~ 18.5 - 24.9)
    if (inputs.bmi >= 18.5 && inputs.bmi <= 24.9) {
      ageAdjustment -= 1.0;
      positiveContributors.add('Optimal BMI Range (18.5 - 24.9)');
    } else if (inputs.bmi >= 27.0) {
      ageAdjustment += 2.0;
      riskFactors.add('Elevated BMI (≥27.0)');
    }

    // 5. Monthly Average Daily Steps (Target >= 8000)
    if (inputs.monthlyAverageDailySteps >= 9000) {
      ageAdjustment -= 1.5;
      positiveContributors.add('High Daily Step Volume (≥9,000 steps/day)');
    } else if (inputs.monthlyAverageDailySteps < 5000) {
      ageAdjustment += 1.5;
      riskFactors.add('Sedentary Step Volume (<5,000 steps/day)');
    }

    // 6. Fasting Glucose (Optimal < 99 mg/dL)
    if (inputs.fastingGlucoseMgDl < 95) {
      ageAdjustment -= 1.0;
      positiveContributors.add('Normal Fasting Glucose (<95 mg/dL)');
    } else if (inputs.fastingGlucoseMgDl >= 105) {
      ageAdjustment += 1.5;
      riskFactors.add('Elevated Fasting Glucose (≥105 mg/dL)');
    }

    // Clamp total biological age calculation to reasonable limits (-7 to +7 years vs chronological age)
    final clampedAdjustment = ageAdjustment.clamp(-7.0, 7.0);
    final bioAge = (inputs.chronologicalAge + clampedAdjustment).clamp(18.0, 100.0);

    return BiologicalAgeEstimationResult(
      chronologicalAge: inputs.chronologicalAge,
      biologicalAge: bioAge,
      ageDeltaYears: bioAge - inputs.chronologicalAge,
      positiveContributors: positiveContributors,
      riskFactors: riskFactors,
    );
  }
}
