import 'injury_risk_models.dart';

/// Pure Dart Deterministic Engine for Musculoskeletal Injury Risk & ACWR Workload Dynamics
class InjuryRiskEngine {
  const InjuryRiskEngine();

  /// Calculate comprehensive injury risk report
  InjuryRiskReport evaluateInjuryRisk({
    required double acuteLoad7Days, // e.g. 3850.0 AU
    required double chronicLoad28Days, // e.g. 3400.0 AU
    required double sleepDebtHours, // e.g. 1.2 hrs
    required double
        hrvSuppressionPercent, // e.g. 6.0% (positive means suppressed)
    required double formBreakdownRatePercent, // e.g. 8.0%
    required Map<AnatomicalJointArea, int> jointSorenessScores, // 0 to 10
    required Map<AnatomicalJointArea, double> jointLoadTonnages, // kg in 7 days
    DateTime? assessmentDate,
  }) {
    final now = assessmentDate ?? DateTime.now();

    // 1. Calculate Acute:Chronic Workload Ratio (ACWR)
    final safeChronic = chronicLoad28Days <= 0 ? 1.0 : chronicLoad28Days;
    final acwr = _round(acuteLoad7Days / safeChronic);

    // 2. Base ACWR Risk Score
    double baseAcwrScore;
    if (acwr >= 0.85 && acwr <= 1.25) {
      // Sweet spot (Optimal)
      baseAcwrScore = 15.0 + (acwr - 0.85) * 20.0;
    } else if (acwr > 1.25 && acwr <= 1.45) {
      // Moderate caution zone
      baseAcwrScore = 35.0 + (acwr - 1.25) * 125.0;
    } else if (acwr > 1.45) {
      // High-risk danger zone (Workload spike)
      baseAcwrScore = 60.0 + (acwr - 1.45) * 100.0;
    } else {
      // Under-training / deconditioning zone (< 0.85)
      baseAcwrScore = 25.0 + (0.85 - acwr) * 50.0;
    }

    // 3. Recovery Deficit & Biomechanical Multiplier
    double recoveryMultiplier = 1.0;
    if (sleepDebtHours > 5.0) {
      recoveryMultiplier += 0.30;
    } else if (sleepDebtHours > 2.5) {
      recoveryMultiplier += 0.15;
    }

    if (hrvSuppressionPercent > 20.0) {
      recoveryMultiplier += 0.25;
    } else if (hrvSuppressionPercent > 10.0) {
      recoveryMultiplier += 0.12;
    }

    if (formBreakdownRatePercent > 15.0) {
      recoveryMultiplier += 0.18;
    } else if (formBreakdownRatePercent > 8.0) {
      recoveryMultiplier += 0.08;
    }

    final safeRecoveryMultiplier = _round(recoveryMultiplier.clamp(1.0, 1.75));

    // 4. Joint-Specific Risk Assessments
    final jointAssessments = <JointRiskAssessment>[];
    double maxJointRisk = 0.0;

    for (final area in AnatomicalJointArea.values) {
      final soreness = jointSorenessScores[area] ?? 0;
      final tonnage = jointLoadTonnages[area] ?? 0.0;

      final jointRisk = _calculateJointRiskScore(
        area: area,
        soreness: soreness,
        tonnage: tonnage,
        acwr: acwr,
        recoveryMultiplier: safeRecoveryMultiplier,
      );

      if (jointRisk > maxJointRisk) {
        maxJointRisk = jointRisk;
      }

      final tier = _tierForScore(jointRisk);
      final prehab = _getPrehabForArea(area);

      jointAssessments.add(
        JointRiskAssessment(
          area: area,
          riskScore: jointRisk,
          tier: tier,
          cumulativeLoadTonnage: tonnage,
          sorenessLevel: soreness,
          primaryRiskFactor:
              _getPrimaryRiskFactor(area, soreness, tonnage, acwr),
          regionalPrimaryRiskFactor:
              _getRegionalPrimaryRiskFactor(area, soreness, tonnage, acwr),
          recommendedPrehab: prehab.$1,
          regionalRecommendedPrehab: prehab.$2,
        ),
      );
    }

    // 5. Composite Injury Risk Score
    final compositeRiskScore = _round(
      ((baseAcwrScore * safeRecoveryMultiplier * 0.65) + (maxJointRisk * 0.35))
          .clamp(5.0, 99.0),
    );

    final overallTier = _tierForScore(compositeRiskScore);
    final shouldDeload = compositeRiskScore >= 60.0 || acwr >= 1.50;

    // 6. Actionable Prehab / Load Mitigation Protocols
    final activeProtocols = _generateMitigationProtocols(
      jointAssessments: jointAssessments,
      shouldDeload: shouldDeload,
      acwr: acwr,
    );

    // 7. Clinical Workload Summaries
    final summary = _generateSummary(
      acwr: acwr,
      compositeScore: compositeRiskScore,
      tier: overallTier,
      shouldDeload: shouldDeload,
      maxJoint:
          jointAssessments.reduce((a, b) => a.riskScore > b.riskScore ? a : b),
    );

    final regionalSummary = _generateRegionalSummary(
      acwr: acwr,
      compositeScore: compositeRiskScore,
      tier: overallTier,
      shouldDeload: shouldDeload,
      maxJoint:
          jointAssessments.reduce((a, b) => a.riskScore > b.riskScore ? a : b),
    );

    return InjuryRiskReport(
      compositeRiskScore: compositeRiskScore,
      overallRiskTier: overallTier,
      acuteChronicWorkloadRatio: acwr,
      acuteLoad7Days: acuteLoad7Days,
      chronicLoad28Days: chronicLoad28Days,
      recoveryDeficitMultiplier: safeRecoveryMultiplier,
      jointAssessments: jointAssessments,
      activeProtocols: activeProtocols,
      shouldDeload: shouldDeload,
      clinicalWorkloadSummary: summary,
      regionalClinicalWorkloadSummary: regionalSummary,
      assessedAt: now,
    );
  }

  // --- Internal Math & Clinical Helpers ---

  double _calculateJointRiskScore({
    required AnatomicalJointArea area,
    required int soreness,
    required double tonnage,
    required double acwr,
    required double recoveryMultiplier,
  }) {
    // Soreness contribution (0-10 scale -> 0 to 45 pts)
    final sorenessPts = soreness * 4.5;

    // Tonnage load density contribution (e.g. > 4000kg adds risk)
    double tonnagePts = 0.0;
    if (tonnage > 6000) {
      tonnagePts = 25.0;
    } else if (tonnage > 3500) {
      tonnagePts = 14.0;
    } else if (tonnage > 1500) {
      tonnagePts = 6.0;
    }

    // ACWR modifier
    double acwrMod = 1.0;
    if (acwr > 1.35) {
      acwrMod = 1.25;
    }

    final rawScore = (sorenessPts + tonnagePts + 10.0) *
        acwrMod *
        (recoveryMultiplier * 0.85);
    return _round(rawScore.clamp(5.0, 99.0));
  }

  InjuryRiskTier _tierForScore(double score) {
    if (score < 35.0) {
      return InjuryRiskTier.optimal;
    }
    if (score < 60.0) {
      return InjuryRiskTier.moderate;
    }
    return InjuryRiskTier.high;
  }

  (String, String) _getPrehabForArea(AnatomicalJointArea area) {
    switch (area) {
      case AnatomicalJointArea.lumbarSpine:
        return (
          'McGill Big 3 (Bird-Dog, Side Plank, Curl-Up) + Cat-Camel',
          'मैकगिल बिग ३ (बर्ड-डॉग, साइड प्लैंक, कर्ल-अप) व मार्जरी आसन',
        );
      case AnatomicalJointArea.knees:
        return (
          'Poliquin Step-Ups & Terminal Knee Extensions (TKE)',
          'पॉलीक्विन स्टेप-अप व टर्मिनल नी एक्सटेंशन',
        );
      case AnatomicalJointArea.shoulders:
        return (
          'Banded Face Pulls & Prone Y-T-W Scapular Retractions',
          'बैंडेड फेस पुल व प्रोन वाई-टी-डब्लू स्केपुलर अभ्यास',
        );
      case AnatomicalJointArea.hips:
        return (
          '90/90 Hip Mobility Flow & Copenhagen Adductor Plank',
          '९०/९० हिप मोबिलिटी व कोपेनहेगन एडक्टर प्लैंक',
        );
      case AnatomicalJointArea.anklesAchilles:
        return (
          'Tibialis Wall Raises & Eccentric Calf Heel Drops',
          'टिबियालिस वॉल रेज व एक्सेंट्रिक काफ ड्रॉप्स',
        );
    }
  }

  String _getPrimaryRiskFactor(
    AnatomicalJointArea area,
    int soreness,
    double tonnage,
    double acwr,
  ) {
    if (soreness >= 6) {
      return 'Elevated localized muscle damage (Soreness $soreness/10)';
    }
    if (tonnage > 5000) {
      return 'High cumulative 7-day tonnage (${(tonnage / 1000).toStringAsFixed(1)} tonnes)';
    }
    if (acwr > 1.35) {
      return 'Acute training spike outrunning joint adaptation';
    }
    return 'Balanced tissue recovery & optimal mechanical loading';
  }

  String _getRegionalPrimaryRiskFactor(
    AnatomicalJointArea area,
    int soreness,
    double tonnage,
    double acwr,
  ) {
    if (soreness >= 6) {
      return 'मांसपेशियों में तीव्र थकान व खिंचाव (दर्द $soreness/१०)';
    }
    if (tonnage > 5000) {
      return 'साप्ताहिक अत्यधिक कार्यभार (${(tonnage / 1000).toStringAsFixed(1)} टन)';
    }
    if (acwr > 1.35) {
      return 'तीव्र भार वृद्धि जो जोड़ों की अनुकूलन क्षमता से अधिक है';
    }
    return 'संतुलित रिकवरी व अनुकूल शारीरिक कार्यभार';
  }

  List<InjuryPreventionProtocol> _generateMitigationProtocols({
    required List<JointRiskAssessment> jointAssessments,
    required bool shouldDeload,
    required double acwr,
  }) {
    final protocols = <InjuryPreventionProtocol>[];

    if (shouldDeload) {
      protocols.add(
        const InjuryPreventionProtocol(
          id: 'prot_deload_volume',
          targetArea: AnatomicalJointArea.lumbarSpine,
          title: 'Strategic 30% Workload Volume Deload',
          regionalTitle: 'रणनीतिक ३०% कार्यभार कटौती (डीलोड)',
          prescription:
              'Cap heavy compound lifts at 65% 1RM and eliminate forced failure sets for 5-7 days.',
          regionalPrescription:
              'अगले ५-७ दिनों के लिए वजन ६५% पर सीमित रखें व पूर्ण थकान से बचें।',
          targetSetsReps: '2 sets @ RPE 6-7',
          karmaReward: 75,
        ),
      );
    }

    // Add top 2 joint-specific prehab protocols with highest risk scores
    final sortedJoints = List<JointRiskAssessment>.from(jointAssessments)
      ..sort((a, b) => b.riskScore.compareTo(a.riskScore));

    for (final joint in sortedJoints.take(2)) {
      protocols.add(
        InjuryPreventionProtocol(
          id: 'prot_prehab_${joint.area.name}',
          targetArea: joint.area,
          title: '${joint.area.name} Prehab & Mobility Reset',
          regionalTitle: '${joint.area.regionalName} सुधार व मोबिलिटी व्यायाम',
          prescription: joint.recommendedPrehab,
          regionalPrescription: joint.regionalRecommendedPrehab,
          targetSetsReps: '3 sets x 12 reps before training',
          karmaReward: 50,
        ),
      );
    }

    return protocols;
  }

  String _generateSummary({
    required double acwr,
    required double compositeScore,
    required InjuryRiskTier tier,
    required bool shouldDeload,
    required JointRiskAssessment maxJoint,
  }) {
    if (tier == InjuryRiskTier.optimal) {
      return 'Workload progression is well-calibrated (ACWR ${acwr.toStringAsFixed(2)}). Musculoskeletal fatigue is within normal adaptive physiological parameters with low systemic injury probability.';
    }
    if (tier == InjuryRiskTier.moderate) {
      return 'ACWR stands at ${acwr.toStringAsFixed(2)} with localized strain primarily detected in ${maxJoint.area.name} (Risk ${maxJoint.riskScore.toInt()}/100). Implement prescribed prehab and prioritize sleep restoration.';
    }
    return 'CRITICAL LOAD WARNING: ACWR reached ${acwr.toStringAsFixed(2)} (High Spike) with compounded fatigue in ${maxJoint.area.name}. Immediate volume deload is strongly recommended to prevent soft-tissue sprain or tendinopathy.';
  }

  String _generateRegionalSummary({
    required double acwr,
    required double compositeScore,
    required InjuryRiskTier tier,
    required bool shouldDeload,
    required JointRiskAssessment maxJoint,
  }) {
    if (tier == InjuryRiskTier.optimal) {
      return 'कार्यभार अनुपात (ACWR ${acwr.toStringAsFixed(2)}) पूर्णतः संतुलित है। मांसपेशियों व जोड़ों पर कोई असामान्य दबाव नहीं है।';
    }
    if (tier == InjuryRiskTier.moderate) {
      return 'कार्यभार अनुपात ${acwr.toStringAsFixed(2)} पर है। मुख्य थकान ${maxJoint.area.regionalName} में दर्ज की गई है। सुझाई गई मोबिलिटी करें व पर्याप्त विश्राम लें।';
    }
    return 'सावधानी: कार्यभार अनुपात ${acwr.toStringAsFixed(2)} के साथ उच्च जोखिम स्तर पर है। चोट से बचाव हेतु तुरंत ३०% कार्यभार कम (डीलोड) करने की सलाह दी जाती है।';
  }

  double _round(double val) {
    return (val * 100).round() / 100.0;
  }
}
