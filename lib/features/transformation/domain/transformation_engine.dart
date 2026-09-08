import 'transformation_models.dart';

/// Pure Dart Deterministic Engine for Longitudinal Transformation Journey,
/// Multi-Pillar Biometric Scoring, Stage Progression, and Milestone Projections.
class TransformationJourneyEngine {
  const TransformationJourneyEngine._();

  /// Calculates the progress contribution score (0.0 to 100.0) for a metric delta
  static double _calculateMetricProgress({
    required double baseline,
    required double current,
    required double target,
    bool lowerIsBetter = false,
  }) {
    if (lowerIsBetter) {
      if (baseline <= target) return 100.0;
      final totalRequiredReduction = baseline - target;
      final actualReduction = baseline - current;
      if (totalRequiredReduction <= 0) return 100.0;
      return ((actualReduction / totalRequiredReduction) * 100.0).clamp(0.0, 100.0);
    } else {
      if (baseline >= target) return 100.0;
      final totalRequiredGain = target - baseline;
      final actualGain = current - baseline;
      if (totalRequiredGain <= 0) return 100.0;
      return ((actualGain / totalRequiredGain) * 100.0).clamp(0.0, 100.0);
    }
  }

  /// Evaluates all Biometric Pillar Deltas between baseline and current snapshots
  static List<BiometricPillarDelta> evaluatePillarDeltas({
    required TransformationSnapshot baseline,
    required TransformationSnapshot current,
  }) {
    // 1. WHtR Delta (Target: 0.46)
    final whtrProgress = _calculateMetricProgress(
      baseline: baseline.waistToHeightRatio,
      current: current.waistToHeightRatio,
      target: 0.46,
      lowerIsBetter: true,
    );

    // 2. Resting Heart Rate (Target: 58 BPM)
    final rhrProgress = _calculateMetricProgress(
      baseline: baseline.restingHeartRateBpm,
      current: current.restingHeartRateBpm,
      target: 58.0,
      lowerIsBetter: true,
    );

    // 3. Systolic Blood Pressure (Target: 118 mmHg)
    final sbpProgress = _calculateMetricProgress(
      baseline: baseline.systolicBp.toDouble(),
      current: current.systolicBp.toDouble(),
      target: 118.0,
      lowerIsBetter: true,
    );

    // 4. Estimated HbA1c (Target: 5.3%)
    final hba1cProgress = _calculateMetricProgress(
      baseline: baseline.estimatedHbA1c,
      current: current.estimatedHbA1c,
      target: 5.3,
      lowerIsBetter: true,
    );

    // 5. VO2 Max (Target: 48 ml/kg/min)
    final vo2Progress = _calculateMetricProgress(
      baseline: baseline.vo2MaxEstimate,
      current: current.vo2MaxEstimate,
      target: 48.0,
      lowerIsBetter: false,
    );

    // 6. Daily Steps (Target: 10,000 steps)
    final stepProgress = _calculateMetricProgress(
      baseline: baseline.averageDailySteps.toDouble(),
      current: current.averageDailySteps.toDouble(),
      target: 10000.0,
      lowerIsBetter: false,
    );

    // 7. Weekly Strength Volume (Target: 20,000 kg)
    final strengthProgress = _calculateMetricProgress(
      baseline: baseline.weeklyStrengthVolumeKg,
      current: current.weeklyStrengthVolumeKg,
      target: 20000.0,
      lowerIsBetter: false,
    );

    // 8. Dosha Equilibrium (Target: 90.0)
    final doshaProgress = _calculateMetricProgress(
      baseline: baseline.doshaEquilibriumScore,
      current: current.doshaEquilibriumScore,
      target: 90.0,
      lowerIsBetter: false,
    );

    // 9. Cumulative Karma (Target: 5,000 pts)
    final karmaProgress = _calculateMetricProgress(
      baseline: baseline.cumulativeKarmaPoints.toDouble(),
      current: current.cumulativeKarmaPoints.toDouble(),
      target: 5000.0,
      lowerIsBetter: false,
    );

    return [
      BiometricPillarDelta(
        pillar: TransformationPillar.bodyComposition,
        metricName: 'Waist-to-Height Ratio (WHtR)',
        regionalMetricName: 'कमर-ऊंचाई अनुपात (WHtR)',
        baselineValue: baseline.waistToHeightRatio,
        currentValue: current.waistToHeightRatio,
        unit: 'ratio',
        lowerIsBetter: true,
        scoreProgressContribution: whtrProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.bodyComposition,
        metricName: 'Bodyweight',
        regionalMetricName: 'शारीरिक भार',
        baselineValue: baseline.bodyweightKg,
        currentValue: current.bodyweightKg,
        unit: 'kg',
        lowerIsBetter: baseline.bodyweightKg > 70,
        scoreProgressContribution: _calculateMetricProgress(
          baseline: baseline.bodyweightKg,
          current: current.bodyweightKg,
          target: 70.0,
          lowerIsBetter: baseline.bodyweightKg > 70,
        ),
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.cardiometabolic,
        metricName: 'Resting Heart Rate',
        regionalMetricName: 'विश्राम हृदय गति (RHR)',
        baselineValue: baseline.restingHeartRateBpm,
        currentValue: current.restingHeartRateBpm,
        unit: 'bpm',
        lowerIsBetter: true,
        scoreProgressContribution: rhrProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.cardiometabolic,
        metricName: 'Systolic Blood Pressure',
        regionalMetricName: 'सिस्टोलिक रक्तचाप',
        baselineValue: baseline.systolicBp.toDouble(),
        currentValue: current.systolicBp.toDouble(),
        unit: 'mmHg',
        lowerIsBetter: true,
        scoreProgressContribution: sbpProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.cardiometabolic,
        metricName: 'Estimated HbA1c',
        regionalMetricName: 'अनुमानित HbA1c स्तर',
        baselineValue: baseline.estimatedHbA1c,
        currentValue: current.estimatedHbA1c,
        unit: '%',
        lowerIsBetter: true,
        scoreProgressContribution: hba1cProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.workCapacity,
        metricName: 'VO2 Max Fitness',
        regionalMetricName: 'हृदय-श्वसन क्षमता (VO2 Max)',
        baselineValue: baseline.vo2MaxEstimate,
        currentValue: current.vo2MaxEstimate,
        unit: 'ml/kg/min',
        lowerIsBetter: false,
        scoreProgressContribution: vo2Progress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.workCapacity,
        metricName: 'Daily Step Volume',
        regionalMetricName: 'दैनिक कदम संख्या',
        baselineValue: baseline.averageDailySteps.toDouble(),
        currentValue: current.averageDailySteps.toDouble(),
        unit: 'steps/day',
        lowerIsBetter: false,
        scoreProgressContribution: stepProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.workCapacity,
        metricName: 'Weekly Strength Tonnage',
        regionalMetricName: 'साप्ताहिक शक्ति भार क्षमता',
        baselineValue: baseline.weeklyStrengthVolumeKg,
        currentValue: current.weeklyStrengthVolumeKg,
        unit: 'kg/wk',
        lowerIsBetter: false,
        scoreProgressContribution: strengthProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.ayurvedicEquilibrium,
        metricName: 'Ayurvedic Dosha Equilibrium',
        regionalMetricName: 'आयुर्वेदिक त्रिदोष संतुलन',
        baselineValue: baseline.doshaEquilibriumScore,
        currentValue: current.doshaEquilibriumScore,
        unit: '% harmony',
        lowerIsBetter: false,
        scoreProgressContribution: doshaProgress,
      ),
      BiometricPillarDelta(
        pillar: TransformationPillar.mindsetKarma,
        metricName: 'Cumulative Karma Capital',
        regionalMetricName: 'संचित कर्म पूंजी',
        baselineValue: baseline.cumulativeKarmaPoints.toDouble(),
        currentValue: current.cumulativeKarmaPoints.toDouble(),
        unit: 'pts',
        lowerIsBetter: false,
        scoreProgressContribution: karmaProgress,
      ),
    ];
  }

  /// Computes composite Transformation Score (0.0 to 100.0)
  static double calculateTransformationScore(List<BiometricPillarDelta> deltas) {
    if (deltas.isEmpty) return 0.0;
    
    // Group progress scores by pillar
    double bodyCompScore = 0.0;
    int bodyCompCount = 0;
    double cardioScore = 0.0;
    int cardioCount = 0;
    double workScore = 0.0;
    int workCount = 0;
    double doshaScore = 0.0;
    double karmaScore = 0.0;

    for (final d in deltas) {
      switch (d.pillar) {
        case TransformationPillar.bodyComposition:
          bodyCompScore += d.scoreProgressContribution;
          bodyCompCount++;
          break;
        case TransformationPillar.cardiometabolic:
          cardioScore += d.scoreProgressContribution;
          cardioCount++;
          break;
        case TransformationPillar.workCapacity:
          workScore += d.scoreProgressContribution;
          workCount++;
          break;
        case TransformationPillar.ayurvedicEquilibrium:
          doshaScore += d.scoreProgressContribution;
          break;
        case TransformationPillar.mindsetKarma:
          karmaScore += d.scoreProgressContribution;
          break;
      }
    }

    final avgBodyComp = bodyCompCount > 0 ? bodyCompScore / bodyCompCount : 0.0;
    final avgCardio = cardioCount > 0 ? cardioScore / cardioCount : 0.0;
    final avgWork = workCount > 0 ? workScore / workCount : 0.0;

    final composite = (avgBodyComp * 0.25) +
        (avgCardio * 0.25) +
        (avgWork * 0.20) +
        (doshaScore * 0.15) +
        (karmaScore * 0.15);

    return composite.clamp(0.0, 100.0);
  }

  /// Identifies current Transformation Stage
  static TransformationStage determineStage({
    required double transformationScore,
    required int totalJourneyDays,
  }) {
    if (transformationScore >= 85.0 || totalJourneyDays >= 180) {
      return TransformationStage.sthirata;
    } else if (transformationScore >= 65.0 || totalJourneyDays >= 90) {
      return TransformationStage.koushalya;
    } else if (transformationScore >= 35.0 || totalJourneyDays >= 30) {
      return TransformationStage.abhyasa;
    }
    return TransformationStage.arambha;
  }

  /// Detects unlocked milestones
  static List<TransformationMilestone> detectUnlockedMilestones({
    required TransformationSnapshot baseline,
    required TransformationSnapshot current,
    required int totalJourneyDays,
  }) {
    final milestones = <TransformationMilestone>[];

    // 1. Initial Step
    milestones.add(
      TransformationMilestone(
        id: 'ms_first_step',
        title: 'The Journey Begins (Sankalpa)',
        regionalTitle: 'साधना संकल्प',
        description: 'Completed onboarding baseline calibration and initiated daily discipline.',
        regionalDescription: 'प्रारंभिक स्वास्थ्य मूल्यांकन पूर्ण कर दैनिक साधना का संकल्प लिया।',
        achievedAt: baseline.recordedAt,
        pillar: TransformationPillar.mindsetKarma,
        karmaBonus: 100,
        badgeIcon: 'flag',
      ),
    );

    // 2. WHtR Sub-0.50 Milestone
    if (current.waistToHeightRatio <= 0.50 && baseline.waistToHeightRatio > 0.50) {
      milestones.add(
        TransformationMilestone(
          id: 'ms_whtr_optimal',
          title: 'Visceral Risk Reversal',
          regionalTitle: 'उपापचयी सुरक्षा सीमा पार',
          description: 'Waist-to-height ratio entered the optimal <0.50 cardiovascular safety zone.',
          regionalDescription: 'कमर-ऊंचाई अनुपात सुरक्षित सीमा (<०.५०) के भीतर पहुंचा।',
          achievedAt: current.recordedAt.subtract(const Duration(days: 12)),
          pillar: TransformationPillar.bodyComposition,
          karmaBonus: 250,
          badgeIcon: 'shield',
        ),
      );
    }

    // 3. Sub-60 RHR Milestone
    if (current.restingHeartRateBpm < 65.0) {
      milestones.add(
        TransformationMilestone(
          id: 'ms_rhr_athlete',
          title: 'Athletic Vagal Tone',
          regionalTitle: 'मजबूत हृदय स्वास्थ्य (उत्कृष्ट RHR)',
          description: 'Resting heart rate dropped below 65 BPM demonstrating parasympathetic adaptation.',
          regionalDescription: 'विश्राम हृदय गति ६५ से कम होकर उत्कृष्ट हृदय सहनशक्ति का प्रमाण बनी।',
          achievedAt: current.recordedAt.subtract(const Duration(days: 5)),
          pillar: TransformationPillar.cardiometabolic,
          karmaBonus: 200,
          badgeIcon: 'favorite',
        ),
      );
    }

    // 4. Step Consistency
    if (current.averageDailySteps >= 10000) {
      milestones.add(
        TransformationMilestone(
          id: 'ms_10k_steps',
          title: '10,000 Step Daily Standard',
          regionalTitle: '१०,००० दैनिक कदम मानदंड',
          description: 'Consistently hitting 10k daily steps with post-meal Shatpawali routines.',
          regionalDescription: 'शतपावली व दैनिक सक्रियता से १०,००० कदमों का स्तर निरंतर बनाए रखा।',
          achievedAt: current.recordedAt.subtract(const Duration(days: 2)),
          pillar: TransformationPillar.workCapacity,
          karmaBonus: 150,
          badgeIcon: 'directions_walk',
        ),
      );
    }

    return milestones;
  }

  /// Calculates Future Projections & Velocity
  static List<TransformationProjection> calculateProjections({
    required TransformationSnapshot baseline,
    required TransformationSnapshot current,
    required int totalJourneyDays,
  }) {
    final weeksPassed = (totalJourneyDays / 7.0).clamp(1.0, 52.0);

    // WHtR Projection
    final whtrTotalDelta = baseline.waistToHeightRatio - current.waistToHeightRatio;
    final whtrWeeklyVelocity = whtrTotalDelta / weeksPassed;
    final whtrTarget = 0.46;
    final whtrRemaining = (current.waistToHeightRatio - whtrTarget).clamp(0.0, 1.0);
    final whtrDaysRemaining = whtrWeeklyVelocity > 0.001
        ? ((whtrRemaining / whtrWeeklyVelocity) * 7).round().clamp(7, 180)
        : 45;

    // RHR Projection
    final rhrTotalDelta = baseline.restingHeartRateBpm - current.restingHeartRateBpm;
    final rhrWeeklyVelocity = rhrTotalDelta / weeksPassed;
    final rhrTarget = 56.0;
    final rhrRemaining = (current.restingHeartRateBpm - rhrTarget).clamp(0.0, 50.0);
    final rhrDaysRemaining = rhrWeeklyVelocity > 0.1
        ? ((rhrRemaining / rhrWeeklyVelocity) * 7).round().clamp(7, 120)
        : 30;

    // Strength Tonnage Projection
    final strengthTotalGain = current.weeklyStrengthVolumeKg - baseline.weeklyStrengthVolumeKg;
    final strengthWeeklyVelocity = strengthTotalGain / weeksPassed;
    final strengthTarget = 20000.0;
    final strengthRemaining = (strengthTarget - current.weeklyStrengthVolumeKg).clamp(0.0, 20000.0);
    final strengthDaysRemaining = strengthWeeklyVelocity > 100
        ? ((strengthRemaining / strengthWeeklyVelocity) * 7).round().clamp(7, 150)
        : 60;

    return [
      TransformationProjection(
        targetGoal: 'Sub-0.46 WHtR (South Asian Gold Standard)',
        regionalTargetGoal: '०.४६ कमर-ऊंचाई अनुपात (उत्कृष्ट स्तर)',
        targetValue: whtrTarget,
        currentValue: current.waistToHeightRatio,
        unit: 'ratio',
        estimatedDaysToAchievement: whtrDaysRemaining,
        weeklyVelocity: whtrWeeklyVelocity,
        confidenceRating: 'High',
      ),
      TransformationProjection(
        targetGoal: '56 BPM Rest Heart Rate (Zone 1 Efficiency)',
        regionalTargetGoal: '५६ BPM विश्राम हृदय गति',
        targetValue: rhrTarget,
        currentValue: current.restingHeartRateBpm,
        unit: 'bpm',
        estimatedDaysToAchievement: rhrDaysRemaining,
        weeklyVelocity: rhrWeeklyVelocity,
        confidenceRating: 'Optimal',
      ),
      TransformationProjection(
        targetGoal: '20,000 kg Weekly Training Volume',
        regionalTargetGoal: '२०,००० किग्रा साप्ताहिक व्यायाम भार',
        targetValue: strengthTarget,
        currentValue: current.weeklyStrengthVolumeKg,
        unit: 'kg/wk',
        estimatedDaysToAchievement: strengthDaysRemaining,
        weeklyVelocity: strengthWeeklyVelocity,
        confidenceRating: 'Optimal',
      ),
    ];
  }

  /// Compiles comprehensive Transformation Report
  static TransformationJourneyReport compileReport({
    required TransformationSnapshot baseline,
    required TransformationSnapshot current,
  }) {
    final totalDays = current.recordedAt.difference(baseline.recordedAt).inDays.clamp(1, 999);
    final pillarDeltas = evaluatePillarDeltas(baseline: baseline, current: current);
    final score = calculateTransformationScore(pillarDeltas);
    final stage = determineStage(transformationScore: score, totalJourneyDays: totalDays);
    final milestones = detectUnlockedMilestones(
      baseline: baseline,
      current: current,
      totalJourneyDays: totalDays,
    );
    final projections = calculateProjections(
      baseline: baseline,
      current: current,
      totalJourneyDays: totalDays,
    );

    String insight;
    String regionalInsight;

    if (stage == TransformationStage.koushalya || stage == TransformationStage.sthirata) {
      insight = 'Outstanding athletic evolution! Your cardiometabolic and muscular indices demonstrate deep systemic adaptation.';
      regionalInsight = 'अद्वितीय शारीरिक पुनर्गठन! आपके बायोमार्कर गहरी आंतरिक शक्ति और उत्कृष्ट स्वास्थ्य दर्शाते हैं।';
    } else if (stage == TransformationStage.abhyasa) {
      insight = 'Metabolic adaptation is accelerating. Consistency in post-meal Shatpawali and progressive volume is yielding tangible biomarker shifts.';
      regionalInsight = 'उपापचयी अनुकूलन तीव्र गति से हो रहा है। शतपावली और नियमित व्यायाम से बायोमार्कर में सकारात्मक परिवर्तन स्पष्ट हैं।';
    } else {
      insight = 'Your foundation is being forged. Daily circadian alignment and sleep hygiene are preparing your physiology for deeper adaptation.';
      regionalInsight = 'आपकी आधारशिला निर्मित हो रही है। दैनिक दिनचर्या और निद्रा अनुशासन से आपका शरीर बड़े परिवर्तनों के लिए तैयार हो रहा है।';
    }

    return TransformationJourneyReport(
      currentStage: stage,
      overallTransformationScore: score,
      totalJourneyDays: totalDays,
      baselineSnapshot: baseline,
      currentSnapshot: current,
      pillarDeltas: pillarDeltas,
      unlockedMilestones: milestones,
      activeProjections: projections,
      motivationalInsight: insight,
      regionalMotivationalInsight: regionalInsight,
    );
  }
}
