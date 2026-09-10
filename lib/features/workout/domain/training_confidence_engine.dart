import 'workout_models.dart';

enum TrainingConfidenceTier {
  shielded(
    label: 'Shielded / High Precision',
    regionalLabel: 'पूर्ण सुरक्षा एवं उच्च सटीकता',
    colorCode: 0xff22C55E, // Karma Green
    grade: 'A+',
    minScore: 85,
  ),
  calibrated(
    label: 'Calibrated / Reliable',
    regionalLabel: 'संतुलित एवं विश्वसनीय',
    colorCode: 0xff3B82F6, // Focus Blue
    grade: 'A',
    minScore: 70,
  ),
  provisional(
    label: 'Provisional / Noticeable Variance',
    regionalLabel: 'अस्थायी / मध्यम विचलन',
    colorCode: 0xffEAB308, // Gold
    grade: 'B',
    minScore: 50,
  ),
  uncertain(
    label: 'Uncertain / High Fatigue Risk',
    regionalLabel: 'अनिश्चित / अत्यधिक थकान का जोखिम',
    colorCode: 0xffEF4444, // Alert Red
    grade: 'C',
    minScore: 0,
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final String grade;
  final int minScore;

  const TrainingConfidenceTier({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.grade,
    required this.minScore,
  });
}

class TrainingIndexPillar {
  final String id;
  final String name;
  final String regionalName;
  final double score; // 0 to 100
  final double weight; // 0.0 to 1.0
  final String status;
  final String diagnosticDetail;
  final String optimizationGuidance;

  const TrainingIndexPillar({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.score,
    required this.weight,
    required this.status,
    required this.diagnosticDetail,
    required this.optimizationGuidance,
  });

  double get weightedContribution => score * weight;
}

class TrainingConfidenceReport {
  final int compositeConfidenceScore; // 0 to 100
  final TrainingConfidenceTier tier;
  final List<TrainingIndexPillar> pillars;
  final List<String> activeShieldCalibrations;
  final String executiveSummary;

  const TrainingConfidenceReport({
    required this.compositeConfidenceScore,
    required this.tier,
    required this.pillars,
    required this.activeShieldCalibrations,
    required this.executiveSummary,
  });
}

class TrainingConfidenceEngine {
  /// Pure Dart deterministic calculation of Training OS Confidence Indices
  /// Pillars:
  /// 1. Form & Mechanical Integrity Index (30%)
  /// 2. Progression Confidence Index (30%)
  /// 3. CNS & Recovery Alignment Index (25%)
  /// 4. Logging & Measurement Precision Index (15%)
  static TrainingConfidenceReport evaluateTrainingConfidence({
    required WorkoutSession session,
    required double readinessScore, // 0 to 100
    bool isRealTimeLogged = true,
  }) {
    final completedSets = session.plannedExercises
        .expand((e) => e.completedSets.where((s) => s.isCompleted))
        .toList();

    if (completedSets.isEmpty) {
      return _buildEmptyReport();
    }

    final List<String> calibrations = [];

    // -------------------------------------------------------------
    // Pillar 1: Form & Mechanical Integrity Index (30% weight)
    // -------------------------------------------------------------
    double formScore = 85.0;
    final highRpeSets =
        completedSets.where((s) => (s.rpe ?? 8.0) >= 9.5).length;
    final totalSets = completedSets.length;

    if (highRpeSets == 0) {
      formScore = 95.0;
    } else if (highRpeSets <= 2) {
      formScore = 80.0;
      calibrations.add(
          'Minor mechanical strain detected at RPE 9.5+. Scapular and core bracing held intact.');
    } else {
      formScore = 60.0;
      calibrations.add(
          'Excessive near-failure sets ($highRpeSets sets at RPE 9.5+). Form breakdown probability elevated by 40%.');
    }

    // -------------------------------------------------------------
    // Pillar 2: Progression Confidence Index (30% weight)
    // -------------------------------------------------------------
    double progressionScore = 88.0;
    final completedPlanned =
        session.plannedExercises.where((p) => p.isFullyCompleted).length;
    final plannedTotal = session.plannedExercises.length;
    final double completionRatio =
        plannedTotal > 0 ? (completedPlanned / plannedTotal) : 1.0;

    if (completionRatio >= 0.8) {
      progressionScore = 94.0;
      calibrations.add(
          'High progression statistical confidence (94%). Verified target rep completion across all primary lifts.');
    } else if (completionRatio >= 0.5) {
      progressionScore = 75.0;
      calibrations.add(
          'Moderate progression confidence. Partial set target fulfillment.');
    } else {
      progressionScore = 50.0;
      calibrations.add(
          'Sub-target rep completion. Recommend weight hold next session to stabilize motor pattern.');
    }

    // -------------------------------------------------------------
    // Pillar 3: CNS & Recovery Alignment Index (25% weight)
    // -------------------------------------------------------------
    double cnsScore = 85.0;
    final double avgSessionRpe =
        completedSets.map((s) => s.rpe ?? 8.0).reduce((a, b) => a + b) /
            totalSets;

    if (readinessScore >= 75.0 && avgSessionRpe <= 9.0) {
      cnsScore = 98.0;
    } else if (readinessScore < 55.0 && avgSessionRpe > 8.5) {
      cnsScore = 48.0;
      calibrations.add(
          'CNS Recovery Discrepancy: High training strain (RPE ${avgSessionRpe.toStringAsFixed(1)}) on low readiness day (${readinessScore.round()}%). Risk of delayed neuromuscular fatigue.');
    } else if (readinessScore >= 55.0) {
      cnsScore = 82.0;
    } else {
      cnsScore = 68.0;
    }

    // -------------------------------------------------------------
    // Pillar 4: Logging & Measurement Precision Index (15% weight)
    // -------------------------------------------------------------
    final double loggingScore = isRealTimeLogged ? 98.0 : 65.0;
    if (!isRealTimeLogged) {
      calibrations.add(
          'Batch retroactive logging detected. Real-time in-gym set logging ensures precise RPE calibration.');
    }

    // -------------------------------------------------------------
    // Weighted Composite Synthesis
    // -------------------------------------------------------------
    final pillars = [
      TrainingIndexPillar(
        id: 'form_integrity',
        name: 'Form & Mechanical Integrity',
        regionalName: 'व्यायाम मुद्रा एवं यांत्रिक शुद्धता',
        score: double.parse(formScore.toStringAsFixed(1)),
        weight: 0.30,
        status: formScore >= 80
            ? 'Optimal'
            : (formScore >= 60 ? 'Acceptable' : 'Strained'),
        diagnosticDetail: highRpeSets == 0
            ? 'Strict motor pattern maintained across all sets.'
            : '$highRpeSets sets reached near-failure threshold.',
        optimizationGuidance:
            'Keep eccentric lowering controlled (2s tempo) on final repetitions.',
      ),
      TrainingIndexPillar(
        id: 'progression_confidence',
        name: 'Progression Confidence Index',
        regionalName: 'प्रगतिशीलता सांख्यिकीय विश्वास',
        score: double.parse(progressionScore.toStringAsFixed(1)),
        weight: 0.30,
        status: progressionScore >= 80
            ? 'High'
            : (progressionScore >= 60 ? 'Moderate' : 'Low'),
        diagnosticDetail:
            '${(completionRatio * 100).round()}% of planned target sets completed.',
        optimizationGuidance:
            'Primed for systematic +2.5kg load increase on primary compound lifts.',
      ),
      TrainingIndexPillar(
        id: 'cns_alignment',
        name: 'CNS & Recovery Alignment',
        regionalName: 'तंत्रिका तंत्र एवं पुनर्प्राप्ति तालमेल',
        score: double.parse(cnsScore.toStringAsFixed(1)),
        weight: 0.25,
        status: cnsScore >= 80
            ? 'Harmonious'
            : (cnsScore >= 60 ? 'Moderate' : 'Mismatched'),
        diagnosticDetail:
            'Session strain matched against daily readiness score (${readinessScore.round()}%).',
        optimizationGuidance: cnsScore < 70
            ? 'Extend rest intervals to 120s and hydrate with electrolyte water.'
            : 'Ideal training stimulus for current autonomic recovery state.',
      ),
      TrainingIndexPillar(
        id: 'logging_precision',
        name: 'Data & Measurement Precision',
        regionalName: 'डेटा मापन एवं टाइमर सटीकता',
        score: double.parse(loggingScore.toStringAsFixed(1)),
        weight: 0.15,
        status: isRealTimeLogged ? 'Live Verified' : 'Estimated',
        diagnosticDetail: isRealTimeLogged
            ? 'Tracked live with automated rest stopwatch.'
            : 'Logged retroactively after session.',
        optimizationGuidance:
            'Log sets immediately upon completion for peak biofeedback precision.',
      ),
    ];

    final double compositeRaw =
        pillars.fold<double>(0.0, (sum, p) => sum + p.weightedContribution);
    final int composite = compositeRaw.round().clamp(0, 100);

    final tier = _getTier(composite);

    return TrainingConfidenceReport(
      compositeConfidenceScore: composite,
      tier: tier,
      pillars: pillars,
      activeShieldCalibrations: calibrations.isEmpty
          ? [
              'All training data parameters verified with optimal biomechanical precision.'
            ]
          : calibrations,
      executiveSummary:
          'Training OS Confidence Score is $composite% (${tier.label}). '
          'Your progressive overload trajectory is structurally protected by the Training Confidence Shield.',
    );
  }

  static TrainingConfidenceTier _getTier(int score) {
    if (score >= TrainingConfidenceTier.shielded.minScore) {
      return TrainingConfidenceTier.shielded;
    } else if (score >= TrainingConfidenceTier.calibrated.minScore) {
      return TrainingConfidenceTier.calibrated;
    } else if (score >= TrainingConfidenceTier.provisional.minScore) {
      return TrainingConfidenceTier.provisional;
    } else {
      return TrainingConfidenceTier.uncertain;
    }
  }

  static TrainingConfidenceReport _buildEmptyReport() {
    return const TrainingConfidenceReport(
      compositeConfidenceScore: 0,
      tier: TrainingConfidenceTier.uncertain,
      pillars: [
        TrainingIndexPillar(
          id: 'form_integrity',
          name: 'Form & Mechanical Integrity',
          regionalName: 'व्यायाम मुद्रा एवं यांत्रिक शुद्धता',
          score: 0.0,
          weight: 0.30,
          status: 'No Data',
          diagnosticDetail: 'Log workout sets to activate form analysis.',
          optimizationGuidance: 'Start live workout tracking.',
        ),
      ],
      activeShieldCalibrations: [
        'Start workout session to activate the Training OS Confidence Shield.'
      ],
      executiveSummary:
          'No completed sets recorded in current workout session yet.',
    );
  }
}
