/// §P10-D Injury Risk Engine — Models & Scoring Logic
///
/// Evaluates Acute-to-Chronic Workload Ratio (ACWR), joint soreness ratings,
/// form deviation frequency, and recovery readiness to generate injury risk scores
/// and Training OS (§P6-E) deload/substitution recommendations matching §P10-D spec.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P10-D Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum InjuryRiskLevel {
  low('Low Risk', 1, '🟩'),
  moderate('Moderate Watch', 2, '🟨'),
  high('High Warning', 3, '🟧'),
  critical('Critical Risk', 4, '🟥');

  const InjuryRiskLevel(this.displayName, this.priorityLevel, this.indicatorEmoji);

  final String displayName;
  final int priorityLevel;
  final String indicatorEmoji;
}

enum JointArea {
  shoulders('Shoulders', '🦴'),
  knees('Knees', '🦵'),
  lowerBack('Lower Back', '🩺'),
  ankles('Ankles', '👟'),
  wrists('Wrists', '🖐️'),
  hips('Hips', '🧍');

  const JointArea(this.displayName, this.iconSymbol);

  final String displayName;
  final String iconSymbol;
}

class InjuryRiskInput {
  const InjuryRiskInput({
    required this.weeklyVolumeLoadKg,
    required this.acuteToChronicWorkloadRatio,
    required this.jointSorenessScores,
    required this.formDeviationCount,
    required this.recoveryReadinessScore,
  });

  final double weeklyVolumeLoadKg;
  final double acuteToChronicWorkloadRatio; // ACWR (optimal 0.8–1.3; > 1.5 = high risk spike)
  final Map<JointArea, int> jointSorenessScores; // 0-10 scale
  final int formDeviationCount; // ACVL form errors count
  final double recoveryReadinessScore; // 0-100%
}

class InjuryRiskAssessment {
  const InjuryRiskAssessment({
    required this.overallRiskLevel,
    required this.riskScorePct,
    this.primaryVulnerableJoint,
    required this.acwrStatus,
    required this.recommendedTrainingOsAdjustments,
    required this.timestamp,
  });

  final InjuryRiskLevel overallRiskLevel;
  final double riskScorePct; // 0 - 100%
  final JointArea? primaryVulnerableJoint;
  final String acwrStatus;
  final List<String> recommendedTrainingOsAdjustments;
  final DateTime timestamp;

  bool get isDeloadRecommended =>
      overallRiskLevel == InjuryRiskLevel.high || overallRiskLevel == InjuryRiskLevel.critical;
}

// ─────────────────────────────────────────────────────────────────────────────
// InjuryRiskEngine (§P10-D Specification)
// ─────────────────────────────────────────────────────────────────────────────

class InjuryRiskEngine {
  const InjuryRiskEngine();

  /// Evaluates injury risk inputs and generates risk scores and Training OS adjustments.
  InjuryRiskAssessment assessInjuryRisk(InjuryRiskInput input) {
    double rawScore = 0.0;
    final adjustments = <String>[];

    // 1. ACWR Evaluation (Weight: 35%)
    final acwr = input.acuteToChronicWorkloadRatio;
    String acwrStatusText;

    if (acwr > 1.5) {
      rawScore += 35.0;
      acwrStatusText = 'ACWR Spike (${acwr.toStringAsFixed(2)} > 1.5 High Risk)';
      adjustments.add('Reduce weekly volume load by 30% to stabilize ACWR within 0.8-1.3.');
    } else if (acwr > 1.3) {
      rawScore += 20.0;
      acwrStatusText = 'ACWR Elevated (${acwr.toStringAsFixed(2)} > 1.3 Moderate)';
      adjustments.add('Cap training volume; avoid additional intense sets this week.');
    } else if (acwr < 0.8) {
      rawScore += 10.0;
      acwrStatusText = 'ACWR Low (${acwr.toStringAsFixed(2)} Under-training)';
    } else {
      acwrStatusText = 'ACWR Optimal (${acwr.toStringAsFixed(2)} Sweet Spot)';
    }

    // 2. Joint Soreness Evaluation (Weight: 35%)
    JointArea? mostVulnerableJoint;
    int maxSoreness = 0;

    input.jointSorenessScores.forEach((joint, score) {
      if (score > maxSoreness) {
        maxSoreness = score;
        mostVulnerableJoint = joint;
      }
    });

    if (maxSoreness >= 7) {
      rawScore += 35.0;
      if (mostVulnerableJoint != null) {
        adjustments.add('Swap heavy loading on ${mostVulnerableJoint!.displayName} for joint-sparing mobility work.');
      }
    } else if (maxSoreness >= 4) {
      rawScore += 20.0;
      if (mostVulnerableJoint != null) {
        adjustments.add('Monitor ${mostVulnerableJoint!.displayName} soreness during warm-ups.');
      }
    }

    // 3. Form Deviation Multiplier (Weight: 15%)
    if (input.formDeviationCount >= 5) {
      rawScore += 15.0;
      adjustments.add('ACVL detected ${input.formDeviationCount} form deviations: prioritize strict form over weight.');
    } else if (input.formDeviationCount >= 2) {
      rawScore += 8.0;
    }

    // 4. Low Recovery Readiness Multiplier (Weight: 15%)
    if (input.recoveryReadinessScore < 60.0) {
      rawScore += 15.0;
      adjustments.add('Recovery readiness low (${input.recoveryReadinessScore.round()}%): extend rest intervals by 45 seconds.');
    } else if (input.recoveryReadinessScore < 75.0) {
      rawScore += 8.0;
    }

    final finalRiskPct = rawScore.clamp(0.0, 100.0);

    InjuryRiskLevel level;
    if (finalRiskPct >= 70.0) {
      level = InjuryRiskLevel.critical;
    } else if (finalRiskPct >= 45.0) {
      level = InjuryRiskLevel.high;
    } else if (finalRiskPct >= 25.0) {
      level = InjuryRiskLevel.moderate;
    } else {
      level = InjuryRiskLevel.low;
    }

    if (adjustments.isEmpty) {
      adjustments.add('Optimal injury risk profile: proceed with planned Training OS progression.');
    }

    return InjuryRiskAssessment(
      overallRiskLevel: level,
      riskScorePct: finalRiskPct,
      primaryVulnerableJoint: mostVulnerableJoint,
      acwrStatus: acwrStatusText,
      recommendedTrainingOsAdjustments: adjustments,
      timestamp: DateTime.now(),
    );
  }
}
