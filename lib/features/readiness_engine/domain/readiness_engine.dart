import '../../../core/models/daily_intelligence_package.dart';

enum ReadinessConfidenceTier {
  tier1Wearable(name: 'Tier 1 (HRV & Sleep Stages)', regionalName: 'स्मार्ट वॉच बायोमेट्रिक्स'),
  tier2Basic(name: 'Tier 2 (Sleep & Step Strain)', regionalName: 'बुनियादी स्लीप एवं स्टेप्स'),
  tier3Subjective(name: 'Tier 3 (Subjective Check-in)', regionalName: 'सुबह का स्व-मूल्यांकन');

  final String name;
  final String regionalName;

  const ReadinessConfidenceTier({
    required this.name,
    required this.regionalName,
  });
}

class ReadinessEvaluationResult {
  final int score; // 0 to 100
  final ReadinessZone zone;
  final ReadinessConfidenceTier tier;
  final double hrvScoreContribution;
  final double sleepScoreContribution;
  final double recoveryContribution;
  final double strainContribution;
  final String recommendation;
  final List<String> safetyAlerts;
  final DateTime evaluatedAt;

  const ReadinessEvaluationResult({
    required this.score,
    required this.zone,
    required this.tier,
    required this.hrvScoreContribution,
    required this.sleepScoreContribution,
    required this.recoveryContribution,
    required this.strainContribution,
    required this.recommendation,
    required this.safetyAlerts,
    required this.evaluatedAt,
  });

  factory ReadinessEvaluationResult.fromMap(Map<String, dynamic> map) {
    final score = (map['score'] as num?)?.toInt() ?? 70;
    final zoneName = map['zone'] as String? ?? 'moderate';
    final zone = ReadinessZone.values.firstWhere(
      (e) => e.name == zoneName,
      orElse: () => ReadinessZone.moderate,
    );

    final tierName = map['tier'] as String? ?? 'tier3Subjective';
    final tier = ReadinessConfidenceTier.values.firstWhere(
      (e) => e.name == tierName,
      orElse: () => ReadinessConfidenceTier.tier3Subjective,
    );

    return ReadinessEvaluationResult(
      score: score,
      zone: zone,
      tier: tier,
      hrvScoreContribution: (map['hrvScoreContribution'] as num?)?.toDouble() ?? 0.0,
      sleepScoreContribution: (map['sleepScoreContribution'] as num?)?.toDouble() ?? 0.0,
      recoveryContribution: (map['recoveryContribution'] as num?)?.toDouble() ?? 0.0,
      strainContribution: (map['strainContribution'] as num?)?.toDouble() ?? 0.0,
      recommendation: map['recommendation'] as String? ?? 'Moderate intensity training recommended.',
      safetyAlerts: List<String>.from(map['safetyAlerts'] ?? []),
      evaluatedAt: map['evaluatedAt'] != null
          ? DateTime.tryParse(map['evaluatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'zone': zone.name,
      'tier': tier.name,
      'hrvScoreContribution': hrvScoreContribution,
      'sleepScoreContribution': sleepScoreContribution,
      'recoveryContribution': recoveryContribution,
      'strainContribution': strainContribution,
      'recommendation': recommendation,
      'safetyAlerts': safetyAlerts,
      'evaluatedAt': evaluatedAt.toIso8601String(),
    };
  }
}

class ReadinessEngine {
  /// Pure Dart deterministic scoring engine implementing the Three-Tier Confidence Model
  static ReadinessEvaluationResult calculateReadiness({
    // Wearable Inputs (Tier 1)
    double? currentHrvRmssd,
    double? baselineHrv14Day,
    double? currentRestingHr,
    double? baselineRestingHr14Day,
    double? deepSleepMinutes,
    double? remSleepMinutes,
    // Basic Tracking Inputs (Tier 2)
    double? totalSleepHours,
    int? yesterdaySteps,
    int? yesterdayWorkoutLoadScore, // 0 - 100
    // Subjective Check-in Inputs (Tier 3)
    int? subjectiveSleepRating, // 1 to 5
    int? somaticSorenessScore,  // 0 to 100 (higher = more sore)
    int? subjectiveEnergyRating, // 1 to 5
    bool isIll = false,
  }) {
    int finalScore = 70;
    ReadinessConfidenceTier tier = ReadinessConfidenceTier.tier3Subjective;
    double hrvContribution = 0.0;
    double sleepContribution = 0.0;
    double recoveryContribution = 0.0;
    double strainContribution = 0.0;
    final List<String> alerts = [];

    if (isIll) {
      alerts.add('Illness/Fever flag active: Training restricted to rest.');
    }

    // --- TIER 1: Wearable Biometrics (Highest Confidence) ---
    if (currentHrvRmssd != null && baselineHrv14Day != null && baselineHrv14Day > 0) {
      tier = ReadinessConfidenceTier.tier1Wearable;

      // 1. HRV Deviation Score (0 - 100)
      final hrvRatio = currentHrvRmssd / baselineHrv14Day;
      final double hrvPoints;
      if (hrvRatio >= 1.05) {
        hrvPoints = 95.0; // High parasympathetic recovery
      } else if (hrvRatio >= 0.95) {
        hrvPoints = 85.0; // Balanced normal
      } else if (hrvRatio >= 0.85) {
        hrvPoints = 60.0; // Moderate suppression
      } else {
        hrvPoints = 35.0; // Significant autonomic strain
      }
      hrvContribution = hrvPoints * 0.35;

      // 2. Sleep Architecture Score (0 - 100)
      final restorativeSleep = (deepSleepMinutes ?? 60.0) + (remSleepMinutes ?? 90.0);
      final sleepArchPoints = ((restorativeSleep / 150.0).clamp(0.0, 1.2) * 85.0).clamp(0.0, 100.0);
      sleepContribution = sleepArchPoints * 0.25;

      // 3. Resting HR Deviation Score (0 - 100)
      double rhrPoints = 80.0;
      if (currentRestingHr != null && baselineRestingHr14Day != null) {
        final rhrDelta = currentRestingHr - baselineRestingHr14Day;
        if (rhrDelta <= -2) {
          rhrPoints = 95.0;
        } else if (rhrDelta <= 2) {
          rhrPoints = 85.0;
        } else if (rhrDelta <= 5) {
          rhrPoints = 60.0;
        } else {
          rhrPoints = 35.0;
          alerts.add('Resting heart rate is elevated (+${rhrDelta.round()} bpm above baseline).');
        }
      }
      final rhrContribution = rhrPoints * 0.20;

      // 4. Somatic Recovery Contribution (0 - 100)
      final soreness = (somaticSorenessScore ?? 20).clamp(0, 100);
      final recPoints = (100.0 - soreness).clamp(0.0, 100.0);
      recoveryContribution = recPoints * 0.20;

      finalScore = (hrvContribution + sleepContribution + rhrContribution + recoveryContribution).round();
    }
    // --- TIER 2: Basic Tracking (Medium Confidence) ---
    else if (totalSleepHours != null || yesterdaySteps != null) {
      tier = ReadinessConfidenceTier.tier2Basic;

      // 1. Sleep Duration Score (0 - 100)
      final sleepHours = totalSleepHours ?? 7.0;
      final sleepPoints = ((sleepHours / 8.0).clamp(0.0, 1.0) * 100.0);
      sleepContribution = sleepPoints * 0.45;

      // 2. Somatic Soreness Score (0 - 100)
      final soreness = (somaticSorenessScore ?? 20).clamp(0, 100);
      final recPoints = (100.0 - soreness).clamp(0.0, 100.0);
      recoveryContribution = recPoints * 0.30;

      // 3. Previous Day Strain (0 - 100)
      final steps = yesterdaySteps ?? 7500;
      final double strainPoints;
      if (steps > 16000) {
        strainPoints = 65.0;
      } else if (steps > 10000) {
        strainPoints = 85.0;
      } else {
        strainPoints = 90.0;
      }
      strainContribution = strainPoints * 0.25;

      finalScore = (sleepContribution + recoveryContribution + strainContribution).round();
    }
    // --- TIER 3: Subjective Check-in (Fallback Baseline) ---
    else {
      tier = ReadinessConfidenceTier.tier3Subjective;

      final sleepRating = (subjectiveSleepRating ?? 4).clamp(1, 5);
      final energyRating = (subjectiveEnergyRating ?? 4).clamp(1, 5);
      final soreness = (somaticSorenessScore ?? 20).clamp(0, 100);

      sleepContribution = (sleepRating / 5.0 * 100.0) * 0.40;
      recoveryContribution = ((100.0 - soreness).clamp(0.0, 100.0)) * 0.35;
      strainContribution = (energyRating / 5.0 * 100.0) * 0.25;

      finalScore = (sleepContribution + recoveryContribution + strainContribution).round();
    }

    if (isIll) finalScore = finalScore.clamp(0, 30);
    finalScore = finalScore.clamp(0, 100);

    // Determine Zone
    final ReadinessZone zone;
    final String recommendation;

    if (finalScore >= 80) {
      zone = ReadinessZone.optimal;
      recommendation = 'Autonomic nervous system is primed. Excellent day for heavy compound lifts or high-intensity intervals.';
    } else if (finalScore >= 60) {
      zone = ReadinessZone.moderate;
      recommendation = 'Capacity is stable. Follow scheduled progressive overload training with standard rest periods.';
    } else if (finalScore >= 40) {
      zone = ReadinessZone.recovery;
      recommendation = 'Elevated systemic fatigue detected. Shift to active recovery, mobility, or light Zone 2 cardio.';
    } else {
      zone = ReadinessZone.rest;
      recommendation = 'High strain or recovery deficit. Rest, hydration, and restorative sleep are your top priorities today.';
    }

    return ReadinessEvaluationResult(
      score: finalScore,
      zone: zone,
      tier: tier,
      hrvScoreContribution: hrvContribution,
      sleepScoreContribution: sleepContribution,
      recoveryContribution: recoveryContribution,
      strainContribution: strainContribution,
      recommendation: recommendation,
      safetyAlerts: alerts,
      evaluatedAt: DateTime.now(),
    );
  }
}
