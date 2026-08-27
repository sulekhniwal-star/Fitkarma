import 'dart:math';

enum StrainCategory {
  light(name: 'Light Strain (हल्का तनाव)', minVal: 0.0, maxVal: 9.9),
  moderate(name: 'Moderate Strain (संतुलित तनाव)', minVal: 10.0, maxVal: 13.9),
  high(name: 'High Strain (उच्च परिश्रम)', minVal: 14.0, maxVal: 17.9),
  allOut(name: 'All-Out Strain (अत्यधिक परिश्रम)', minVal: 18.0, maxVal: 21.0);

  final String name;
  final double minVal;
  final double maxVal;

  const StrainCategory({
    required this.name,
    required this.minVal,
    required this.maxVal,
  });
}

class StrainCalculationResult {
  final double currentStrain; // 0.0 to 21.0
  final double targetStrainMin;
  final double targetStrainMax;
  final StrainCategory category;
  final double stepsStrainContribution;
  final double workoutStrainContribution;
  final double heatStrainContribution;
  final String statusGuidance;
  final bool isOverreaching;

  const StrainCalculationResult({
    required this.currentStrain,
    required this.targetStrainMin,
    required this.targetStrainMax,
    required this.category,
    required this.stepsStrainContribution,
    required this.workoutStrainContribution,
    required this.heatStrainContribution,
    required this.statusGuidance,
    required this.isOverreaching,
  });
}

class StrainSystemEngine {
  /// Pure Dart deterministic calculation of 0.0 - 21.0 daily strain scale
  static StrainCalculationResult calculateDailyStrain({
    required int steps,
    int workoutDurationMinutes = 45,
    int workoutRpe = 7, // Rate of Perceived Exertion 1 to 10
    int averageWorkoutHr = 135,
    double heatIndexCelsius = 30.0,
    int readinessScore = 75,
  }) {
    // 1. Step Strain Contribution (logarithmic scaling: 10k steps ~ 7.0 strain)
    final stepRatio = steps / 10000.0;
    final double stepStrain;
    if (stepRatio <= 0) {
      stepStrain = 0.0;
    } else {
      stepStrain = min(8.5, 7.0 * (log(stepRatio + 1) / log(2)));
    }

    // 2. Workout Strain Contribution (Duration * RPE intensity factor)
    final hrIntensityFactor = ((averageWorkoutHr - 60) / 120.0).clamp(0.2, 1.2);
    final workoutLoad = (workoutDurationMinutes / 60.0) * (workoutRpe / 10.0) * hrIntensityFactor;
    final double workoutStrain = min(12.0, 9.5 * (log(workoutLoad + 1) / log(2)));

    // 3. Environmental Heat Strain (Thermal cardiac cost)
    final double heatStrain;
    if (heatIndexCelsius > 38.0) {
      heatStrain = 1.5;
    } else if (heatIndexCelsius > 32.0) {
      heatStrain = 0.8;
    } else {
      heatStrain = 0.0;
    }

    // Combined logarithmic strain synthesis capped at 21.0
    final rawCombined = stepStrain + workoutStrain + heatStrain;
    final double currentStrain = (21.0 * (1.0 - exp(-rawCombined / 10.0))).clamp(0.0, 21.0);

    // Target Strain Range based on Body Readiness Score
    final double targetMin;
    final double targetMax;

    if (readinessScore >= 80) {
      targetMin = 14.0;
      targetMax = 18.5;
    } else if (readinessScore >= 60) {
      targetMin = 10.0;
      targetMax = 14.5;
    } else if (readinessScore >= 40) {
      targetMin = 6.0;
      targetMax = 10.0;
    } else {
      targetMin = 0.0;
      targetMax = 6.0;
    }

    final isOverreaching = currentStrain > (targetMax + 1.5);

    // Category
    final StrainCategory category;
    if (currentStrain >= 18.0) {
      category = StrainCategory.allOut;
    } else if (currentStrain >= 14.0) {
      category = StrainCategory.high;
    } else if (currentStrain >= 10.0) {
      category = StrainCategory.moderate;
    } else {
      category = StrainCategory.light;
    }

    // Guidance
    final String guidance;
    if (isOverreaching) {
      guidance = 'Exertion exceeds optimal recovery capacity. Prioritize hydration, sodium, and early sleep.';
    } else if (currentStrain >= targetMin && currentStrain <= targetMax) {
      guidance = 'Optimal strain achieved for today’s readiness. Excellent progressive stimulus.';
    } else if (currentStrain < targetMin) {
      guidance = 'Low strain accumulated. Capacity remains for scheduled resistance training or brisk walking.';
    } else {
      guidance = 'Solid daily output within safe physiological parameters.';
    }

    return StrainCalculationResult(
      currentStrain: double.parse(currentStrain.toStringAsFixed(1)),
      targetStrainMin: targetMin,
      targetStrainMax: targetMax,
      category: category,
      stepsStrainContribution: double.parse(stepStrain.toStringAsFixed(1)),
      workoutStrainContribution: double.parse(workoutStrain.toStringAsFixed(1)),
      heatStrainContribution: double.parse(heatStrain.toStringAsFixed(1)),
      statusGuidance: guidance,
      isOverreaching: isOverreaching,
    );
  }
}
