/// Biological Age Result
class BiologicalAgeResult {
  final double biologicalAge;
  final double chronologicalAge;
  final double ageDeltaYears; // Positive means younger, negative means older
  final String primaryContributor;

  const BiologicalAgeResult({
    required this.biologicalAge,
    required this.chronologicalAge,
    required this.ageDeltaYears,
    required this.primaryContributor,
  });
}

/// CGM Spike Detection Result
class CgmSpikeResult {
  final bool isSpikeDetected;
  final double glucoseDeltaMgDl;
  final String severity;
  final String recommendation;

  const CgmSpikeResult({
    required this.isSpikeDetected,
    required this.glucoseDeltaMgDl,
    required this.severity,
    required this.recommendation,
  });
}

/// Core Predictive Health Engine
class PredictiveHealthEngine {
  const PredictiveHealthEngine();

  /// Calculate Biological Age algorithmically based on Resting Heart Rate, Sleep Score, and BMI
  BiologicalAgeResult calculateBiologicalAge({
    required double chronologicalAge,
    required int restingHeartRateBpm,
    required int averageSleepScore,
    required double bmi,
  }) {
    double delta = 0.0;

    // RHR Contributor
    if (restingHeartRateBpm <= 58) {
      delta -= 2.0;
    } else if (restingHeartRateBpm >= 72) {
      delta += 2.0;
    }

    // Sleep Contributor
    if (averageSleepScore >= 85) {
      delta -= 1.5;
    } else if (averageSleepScore <= 60) {
      delta += 1.5;
    }

    // BMI Contributor
    if (bmi >= 18.5 && bmi <= 24.9) {
      delta -= 1.5;
    } else if (bmi >= 28.0) {
      delta += 2.0;
    }

    final bioAge = (chronologicalAge + delta).clamp(18.0, 100.0);

    return BiologicalAgeResult(
      biologicalAge: bioAge,
      chronologicalAge: chronologicalAge,
      ageDeltaYears: -delta, // Positive delta means younger
      primaryContributor: delta <= 0 ? 'Optimal Cardiovascular & Sleep Quality' : 'Elevated Resting HR & Sleep Debt',
    );
  }

  /// Detect CGM Glucose Spike: Delta > +35 mg/dL within 45 minutes
  CgmSpikeResult detectCgmSpike({
    required double startGlucoseMgDl,
    required double peakGlucoseMgDl,
    required int windowMinutes,
  }) {
    final delta = peakGlucoseMgDl - startGlucoseMgDl;
    final isSpike = delta >= 35.0 && windowMinutes <= 45;

    return CgmSpikeResult(
      isSpikeDetected: isSpike,
      glucoseDeltaMgDl: delta,
      severity: isSpike ? (delta >= 50.0 ? 'High Spike' : 'Moderate Spike') : 'Normal Variation',
      recommendation: isSpike ? 'Take a 10-minute post-meal walk to accelerate glucose clearance.' : 'Glucose response within target range.',
    );
  }

  /// Check Drug-Nutrient & Workout Interactions
  String? checkDrugInteraction({required String medicationName, required String nutrientCategory}) {
    if (medicationName.toLowerCase().contains('metformin') && nutrientCategory.toLowerCase().contains('high carbs')) {
      return 'Drug-Nutrient Warning: High-carb meals may delay Metformin absorption. Pair with fiber.';
    }
    return null;
  }
}
