/// §P6-E Training Operating System — Movement Screening Engine
///
/// Implements:
///  - FormAnalysisResult: per-rep kinematic input record
///  - MobilityDiagnosisEngine: Level 3 squat pattern diagnosis (§P6-E spec)
///  - AdaptiveExerciseSelector: limitation-aware exercise substitution (§P6-E spec)
///  - LocalReadinessScorer: upper/lower body readiness 0–100
library;

// ─────────────────────────────────────────────────────────────────────────────
// Input: Per-Rep Form Analysis Record
// ─────────────────────────────────────────────────────────────────────────────

/// Kinematic data for a single rep (normally populated from MediaPipe pipeline).
class FormAnalysisResult {
  const FormAnalysisResult({
    required this.kneeValgusDetected,
    required this.heelLiftDetected,
    required this.squatDepthAngle,
    this.leftAngleDeg = 0.0,
    this.rightAngleDeg = 0.0,
  });

  /// Knee collapses inward during the rep.
  final bool kneeValgusDetected;

  /// Heel leaves floor during the rep.
  final bool heelLiftDetected;

  /// Depth angle in degrees (≥ 90° = parallel; < 80° = shallow).
  final double squatDepthAngle;

  /// Left-side joint angle for asymmetry calculation.
  final double leftAngleDeg;

  /// Right-side joint angle for asymmetry calculation.
  final double rightAngleDeg;
}

// ─────────────────────────────────────────────────────────────────────────────
// MobilityDiagnosisEngine (§P6-E Level 3 Specification)
// ─────────────────────────────────────────────────────────────────────────────

/// Mobility diagnostic report for a given exercise pattern.
class MobilityReport {
  const MobilityReport({
    required this.identifiedIssues,
    required this.prescribedDrills,
    required this.mobilityIndex,
  });

  const MobilityReport.empty()
      : identifiedIssues = const [],
        prescribedDrills = const [],
        mobilityIndex = 100;

  final List<String> identifiedIssues;
  final List<String> prescribedDrills;

  /// 0 (severe limitations) to 100 (perfect mobility).
  final int mobilityIndex;

  bool get hasIssues => identifiedIssues.isNotEmpty;
}

class MobilityDiagnosisEngine {
  const MobilityDiagnosisEngine();

  /// Diagnoses squat pattern issues from [setLogs] rep records.
  ///
  /// Thresholds (§P6-E Level 3 exact spec):
  /// - Heel lift > 40% OR (shallow > 40% AND heel lift > 20%) → Limited Ankle Dorsiflexion
  /// - Valgus > 30% → Glute Medius Instability
  /// - mobilityIndex = (100 − ((valgusRatio + heelLiftRatio + shallowRatio) × 33.3)).clamp(0,100).round()
  MobilityReport diagnoseSquatPattern({
    required List<FormAnalysisResult> setLogs,
  }) {
    final totalReps = setLogs.length;
    if (totalReps == 0) return const MobilityReport.empty();

    int valgusReps = 0;
    int heelLiftReps = 0;
    int shallowReps = 0;

    for (final log in setLogs) {
      if (log.kneeValgusDetected) valgusReps++;
      if (log.heelLiftDetected) heelLiftReps++;
      if (log.squatDepthAngle < 80.0) shallowReps++;
    }

    final valgusRatio = valgusReps / totalReps;
    final heelLiftRatio = heelLiftReps / totalReps;
    final shallowRatio = shallowReps / totalReps;

    final diagnostics = <String>[];
    final drills = <String>[];

    // Ankle dorsiflexion limitation check
    if (heelLiftRatio > 0.40 ||
        (shallowRatio > 0.40 && heelLiftRatio > 0.20)) {
      diagnostics.add('Limited Ankle Dorsiflexion');
      drills.addAll([
        'Perform 10 ankle rocker stretches per side before squatting.',
        'Squat with heels elevated on 2.5kg plates to bypass range limit.',
      ]);
    }

    // Glute medius instability check
    if (valgusRatio > 0.30) {
      diagnostics.add('Glute Medius Instability');
      drills.addAll([
        'Wrap a loop resistance band around knees during warm-up sets.',
        'Add 15 lateral band walks per side to activate lateral hip stabilizers.',
      ]);
    }

    final mobilityIndex =
        (100 - ((valgusRatio + heelLiftRatio + shallowRatio) * 33.3))
            .clamp(0.0, 100.0)
            .round();

    return MobilityReport(
      identifiedIssues: diagnostics,
      prescribedDrills: drills,
      mobilityIndex: mobilityIndex,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AdaptiveExerciseSelector (§P6-E Adaptive Exercise Selection spec)
// ─────────────────────────────────────────────────────────────────────────────

class AdaptiveExerciseSelector {
  const AdaptiveExerciseSelector();

  static const Map<String, List<String>> substitutions = {
    'barbell_overhead_press': ['landmine_press', 'dumbbell_arnold_press'],
    'barbell_back_squat': ['goblet_box_squat', 'trap_bar_deadlift'],
    'conventional_deadlift': ['romanian_deadlift', 'kettlebell_swing'],
  };

  /// Returns the most appropriate alternative for [primaryExerciseId] given
  /// the user's [identifiedLimitations].
  String selectAlternative(
    String primaryExerciseId,
    List<String> identifiedLimitations,
  ) {
    // Shoulder impingement override
    if (primaryExerciseId == 'barbell_overhead_press' &&
        identifiedLimitations.contains('Poor Shoulder Mobility')) {
      return 'landmine_press';
    }

    // Ankle dorsiflexion override
    if (primaryExerciseId == 'barbell_back_squat' &&
        identifiedLimitations.contains('Limited Ankle Dorsiflexion')) {
      return 'goblet_box_squat';
    }

    // Lumbar constraint override
    if (primaryExerciseId == 'conventional_deadlift' &&
        identifiedLimitations.contains('Lumbar Flexion')) {
      return 'romanian_deadlift';
    }

    // Default: return first substitute from registry, or primary if none found
    return substitutions[primaryExerciseId]?.first ?? primaryExerciseId;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LocalReadinessScorer (§P6-E Local Muscle Readiness spec)
// ─────────────────────────────────────────────────────────────────────────────

/// Upper/lower body local readiness output.
class LocalReadinessScore {
  const LocalReadinessScore({
    required this.upperBodyReadiness,
    required this.lowerBodyReadiness,
    required this.overallReadiness,
    this.daySwapSuggestion,
  });

  /// 0–100 shoulder/chest/back readiness.
  final double upperBodyReadiness;

  /// 0–100 quad/hamstring/hip/ankle readiness.
  final double lowerBodyReadiness;

  /// Weighted mean of upper and lower scores.
  final double overallReadiness;

  /// Non-null when an upper/lower swap is advisable.
  final String? daySwapSuggestion;
}

class LocalReadinessScorer {
  const LocalReadinessScorer();

  /// Computes upper/lower body readiness from perceived soreness (1–5 scale,
  /// where 1 = no soreness, 5 = severe) and an overall [mobilityIndex] 0–100.
  ///
  /// [upperSoreness] & [lowerSoreness]: 1 (fresh) – 5 (very sore).
  /// Readiness formula: 100 − ((soreness − 1) / 4) × 60 (maps 1→100, 5→40).
  /// Mobility bonus: +0.2 × mobilityIndex applied to upper (shoulder/form quality).
  LocalReadinessScore evaluate({
    required double upperSoreness,
    required double lowerSoreness,
    required int mobilityIndex,
  }) {
    final upperBase = 100.0 - ((upperSoreness - 1.0) / 4.0) * 60.0;
    final lowerBase = 100.0 - ((lowerSoreness - 1.0) / 4.0) * 60.0;

    final upperReadiness =
        (upperBase + 0.2 * mobilityIndex).clamp(0.0, 100.0);
    final lowerReadiness = lowerBase.clamp(0.0, 100.0);

    final overallReadiness =
        ((upperReadiness * 0.5) + (lowerReadiness * 0.5)).clamp(0.0, 100.0);

    String? swapSuggestion;
    final readinessDelta = upperReadiness - lowerReadiness;

    if (readinessDelta >= 25.0 && lowerReadiness < 60.0) {
      // Upper body is significantly fresher — suggest swapping leg day
      swapSuggestion =
          'Readiness overall is high, but your legs need recovery. '
          'Swap Leg Day with Upper Body Day to maximize training capacity.';
    } else if (readinessDelta <= -25.0 && upperReadiness < 60.0) {
      // Lower body is significantly fresher — suggest swapping upper day
      swapSuggestion =
          'Readiness overall is high, but your upper body needs recovery. '
          'Swap Upper Day with Leg Day to maximize training capacity.';
    }

    return LocalReadinessScore(
      upperBodyReadiness: upperReadiness,
      lowerBodyReadiness: lowerReadiness,
      overallReadiness: overallReadiness,
      daySwapSuggestion: swapSuggestion,
    );
  }
}
