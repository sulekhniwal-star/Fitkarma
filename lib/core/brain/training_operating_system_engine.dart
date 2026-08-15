import 'dart:math';

// ── Models & Reports ──────────────────────────────────────────────────────────

class MobilityReport {
  final List<String> identifiedIssues;
  final List<String> prescribedDrills;
  final int mobilityIndex; // 0 to 100

  const MobilityReport({
    required this.identifiedIssues,
    required this.prescribedDrills,
    required this.mobilityIndex,
  });

  factory MobilityReport.empty() => const MobilityReport(
        identifiedIssues: [],
        prescribedDrills: [],
        mobilityIndex: 100,
      );
}

class FormAnalysisResult {
  final bool kneeValgusDetected;
  final bool heelLiftDetected;
  final double squatDepthAngle; // < 80.0 is shallow

  const FormAnalysisResult({
    required this.kneeValgusDetected,
    required this.heelLiftDetected,
    required this.squatDepthAngle,
  });
}

class AsymmetryReport {
  final double asymmetryDeltaPct;
  final bool isImbalanced;
  final String recommendedAdjustment;

  const AsymmetryReport({
    required this.asymmetryDeltaPct,
    required this.isImbalanced,
    required this.recommendedAdjustment,
  });

  factory AsymmetryReport.empty() => const AsymmetryReport(
        asymmetryDeltaPct: 0.0,
        isImbalanced: false,
        recommendedAdjustment: 'No data',
      );
}

class ProjectedPerformance {
  final double projected8WeekWeight;
  final double projected12WeekWeight;
  final String forecastSummary;

  const ProjectedPerformance({
    required this.projected8WeekWeight,
    required this.projected12WeekWeight,
    required this.forecastSummary,
  });

  factory ProjectedPerformance.empty(String msg) => ProjectedPerformance(
        projected8WeekWeight: 0.0,
        projected12WeekWeight: 0.0,
        forecastSummary: msg,
      );
}

class LocalSegmentReadiness {
  final double upperBodyReadiness; // 0.0 to 100.0
  final double lowerBodyReadiness; // 0.0 to 100.0
  final String recommendation;

  const LocalSegmentReadiness({
    required this.upperBodyReadiness,
    required this.lowerBodyReadiness,
    required this.recommendation,
  });
}

class MovementAgeProfile {
  final int movementAge;
  final int movementHealthScore; // 0 to 100
  final String athleticTier; // 'Novice', 'Intermediate', 'Advanced', 'Expert'

  const MovementAgeProfile({
    required this.movementAge,
    required this.movementHealthScore,
    required this.athleticTier,
  });
}

// ── Pure-Dart Training Operating System Engine ───────────────────────────────

/// Pure-Dart Training Operating System Engine per §P6-E spec
class TrainingOperatingSystemEngine {
  const TrainingOperatingSystemEngine();

  /// Level 3 — Mobility Diagnosis & Correctives
  MobilityReport diagnoseSquatPattern({
    required List<FormAnalysisResult> setLogs,
  }) {
    final totalReps = setLogs.length;
    if (totalReps == 0) return MobilityReport.empty();

    int valgusReps = 0;
    int heelLiftReps = 0;
    int shallowReps = 0;

    for (final log in setLogs) {
      if (log.kneeValgusDetected) valgusReps++;
      if (log.heelLiftDetected) heelLiftReps++;
      if (log.squatDepthAngle < 80.0) shallowReps++;
    }

    final valgusRatio = valgusReps / totalReps.toDouble();
    final heelLiftRatio = heelLiftReps / totalReps.toDouble();
    final shallowRatio = shallowReps / totalReps.toDouble();

    final diagnostics = <String>[];
    final drills = <String>[];

    if (heelLiftRatio > 0.40 || (shallowRatio > 0.40 && heelLiftRatio > 0.20)) {
      diagnostics.add('Limited Ankle Dorsiflexion');
      drills.addAll([
        'Perform 10 ankle rocker stretches per side before squatting.',
        'Squat with heels elevated on 2.5kg plates to bypass range limit.'
      ]);
    }

    if (valgusRatio > 0.30) {
      diagnostics.add('Glute Medius Instability');
      drills.addAll([
        'Wrap a loop resistance band around knees during warm-up sets.',
        'Add 15 lateral band walks per side to activate lateral hip stabilizers.'
      ]);
    }

    final mobilityIdx =
        (100 - ((valgusRatio + heelLiftRatio + shallowRatio) * 33.3))
            .clamp(0.0, 100.0)
            .round();

    return MobilityReport(
      identifiedIssues: diagnostics,
      prescribedDrills: drills,
      mobilityIndex: mobilityIdx,
    );
  }

  /// Exercise Confidence Score (ECS) = 100 - (Tempo Variance% * 0.4 + Asymmetry Rate% * 0.3 + Joint Jitter Index * 0.3)
  double calculateExerciseConfidenceScore({
    required double tempoVariancePct,
    required double asymmetryRatePct,
    required double jointJitterIndex,
  }) {
    final penalty = (tempoVariancePct * 0.4) +
        (asymmetryRatePct * 0.3) +
        (jointJitterIndex * 0.3);
    return (100.0 - penalty).clamp(0.0, 100.0);
  }

  /// Movement Health Score (MHS) = 0.25*Mobility + 0.25*Stability + 0.15*Balance + 0.15*Coordination + 0.20*FormAccuracy
  double calculateMovementHealthScore({
    required double mobility,
    required double stability,
    required double balance,
    required double coordination,
    required double formAccuracy,
  }) {
    final score = (0.25 * mobility) +
        (0.25 * stability) +
        (0.15 * balance) +
        (0.15 * coordination) +
        (0.20 * formAccuracy);
    return score.clamp(0.0, 100.0);
  }

  /// Camera-Based Fitness Onboarding & Movement Age
  MovementAgeProfile calculateMovementAge({
    required int actualAge,
    required double mhsScore,
  }) {
    int ageDelta = 0;
    String tier = 'Intermediate';

    if (mhsScore >= 85) {
      ageDelta = -5;
      tier = 'Advanced';
    } else if (mhsScore >= 70) {
      ageDelta = -2;
      tier = 'Intermediate';
    } else if (mhsScore >= 50) {
      ageDelta = 2;
      tier = 'Novice';
    } else {
      ageDelta = 5;
      tier = 'Novice';
    }

    return MovementAgeProfile(
      movementAge: max(18, actualAge + ageDelta),
      movementHealthScore: mhsScore.round(),
      athleticTier: tier,
    );
  }

  /// Adaptive Exercise Selection: Replaces movements dynamically when joint limitations exist
  String selectAlternativeExercise({
    required String primaryExerciseId,
    required List<String> identifiedLimitations,
  }) {
    const substitutions = {
      'barbell_overhead_press': ['landmine_press', 'dumbbell_arnold_press'],
      'barbell_back_squat': ['goblet_box_squat', 'trap_bar_deadlift'],
      'conventional_deadlift': ['romanian_deadlift', 'kettlebell_swing'],
    };

    if (primaryExerciseId == 'barbell_overhead_press' &&
        identifiedLimitations.contains('Poor Shoulder Mobility')) {
      return 'landmine_press';
    }
    if (primaryExerciseId == 'barbell_back_squat' &&
        (identifiedLimitations.contains('Limited Ankle Dorsiflexion') ||
            identifiedLimitations.contains('Glute Medius Instability'))) {
      return 'goblet_box_squat';
    }

    return substitutions[primaryExerciseId]?.first ?? primaryExerciseId;
  }

  /// Local Muscle Readiness: Splits systemic readiness into Upper and Lower body segments
  LocalSegmentReadiness calculateLocalSegmentReadiness({
    required double overallReadiness,
    required double upperSoreness, // 0 to 10 scale
    required double lowerSoreness, // 0 to 10 scale
  }) {
    final upper = (overallReadiness - (upperSoreness * 4.0)).clamp(0.0, 100.0);
    final lower = (overallReadiness - (lowerSoreness * 4.0)).clamp(0.0, 100.0);

    String rec = 'All segments ready for high intensity.';
    if ((upper - lower).abs() > 20.0) {
      if (lower < upper) {
        rec =
            'Readiness overall is high, but your legs need recovery. Swap Leg Day with Upper Body Day to maximize training capacity.';
      } else {
        rec =
            'Legs are fresh, but upper body is fatigued. Prioritize Lower Body Day today.';
      }
    }

    return LocalSegmentReadiness(
      upperBodyReadiness: upper,
      lowerBodyReadiness: lower,
      recommendation: rec,
    );
  }

  /// Recovery-Aware Overload Progression: Adapts overload weight step based on recovery capacity
  double calculateRecoveryAwareOverloadStep({
    required double baseTargetWeight,
    required double recoveryCapacity,
    required double sleepDebtHours,
  }) {
    double progressionFactor = 1.0;

    if (recoveryCapacity < 50) {
      progressionFactor = 0.0; // Maintenance / Deload
    } else if (recoveryCapacity < 70 || sleepDebtHours > 2.0) {
      progressionFactor = 0.5; // Half-step progression
    }

    return 2.5 * progressionFactor;
  }

  /// Training Reliability Score (0 to 100)
  double calculateTrainingReliabilityScore({
    required int completedWorkouts,
    required int scheduledWorkouts,
    required int skippedSetsCount,
    required int rescheduledDaysCount,
  }) {
    if (scheduledWorkouts <= 0) return 100.0;

    final ratio =
        (completedWorkouts / scheduledWorkouts.toDouble()).clamp(0.0, 1.0);
    final base = ratio * 100.0;
    final penalties = (skippedSetsCount * 2.0) + (rescheduledDaysCount * 3.0);

    return (base - penalties).clamp(0.0, 100.0);
  }

  /// Advanced Biomechanics — Movement Asymmetry Detection
  AsymmetryReport analyzeUnilateralRep({
    required double leftAngleDeg,
    required double rightAngleDeg,
    required String exerciseKey,
  }) {
    if (leftAngleDeg <= 0 || rightAngleDeg <= 0) return AsymmetryReport.empty();

    final maxVal = leftAngleDeg > rightAngleDeg ? leftAngleDeg : rightAngleDeg;
    final deltaPct = ((leftAngleDeg - rightAngleDeg).abs() / maxVal) * 100.0;

    final isImbalanced = deltaPct > 10.0;
    String feedback =
        'Excellent symmetry detected (${deltaPct.toStringAsFixed(1)}% delta).';

    if (isImbalanced) {
      final weakerSide = leftAngleDeg < rightAngleDeg ? 'left' : 'right';
      feedback =
          'Imbalance detected: Your $weakerSide side is compensating (${deltaPct.toStringAsFixed(1)}% delta). Focus on stability.';
    }

    return AsymmetryReport(
      asymmetryDeltaPct: double.parse(deltaPct.toStringAsFixed(1)),
      isImbalanced: isImbalanced,
      recommendedAdjustment: feedback,
    );
  }

  /// Performance Forecasting Engine: Autoregressive prediction with progress decay
  ProjectedPerformance forecastStrength({
    required List<double> historicWeights,
    required double reliabilityScore, // 0 to 100
  }) {
    if (historicWeights.length < 3) {
      return ProjectedPerformance.empty(
          'Insufficient data history to project strength trajectory.');
    }

    final recentAvg = historicWeights
            .sublist(historicWeights.length - 3)
            .reduce((a, b) => a + b) /
        3.0;
    final adherenceFactor = (reliabilityScore / 100.0).clamp(0.0, 1.0);

    final projectedGain8Weeks = 5.0 * adherenceFactor;
    final projectedGain12Weeks = 8.5 * adherenceFactor;

    final weight8W =
        double.parse((recentAvg + projectedGain8Weeks).toStringAsFixed(1));
    final weight12W =
        double.parse((recentAvg + projectedGain12Weeks).toStringAsFixed(1));

    return ProjectedPerformance(
      projected8WeekWeight: weight8W,
      projected12WeekWeight: weight12W,
      forecastSummary:
          'Maintaining a ${reliabilityScore.round()}% Reliability Score will progress your load to $weight8W kg in 8 weeks and $weight12W kg in 12 weeks.',
    );
  }
}
