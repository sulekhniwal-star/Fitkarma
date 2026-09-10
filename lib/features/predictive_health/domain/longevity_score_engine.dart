import 'longevity_score_models.dart';

/// Pure Dart Deterministic Engine for Longevity Scoring & Healthspan Forecasting
class LongevityScoreEngine {
  const LongevityScoreEngine();

  /// Calculate multi-pillar longevity score and projected healthspan report
  LongevityReport calculateLongevityScore({
    required double chronologicalAge,
    required double biologicalAge,
    required double restingHeartRate, // e.g. 59.0
    required double systolicBloodPressure, // e.g. 116.0
    required double diastolicBloodPressure, // e.g. 74.0
    required double rmssdHeartRateVariability, // e.g. 54.0
    required double waistToHeightRatio, // e.g. 0.46
    required double fastingGlucoseMgDl, // e.g. 89.0
    required double estimatedHbA1c, // e.g. 5.2
    required double estimatedVo2Max, // e.g. 44.5
    required double dailyStepsAverage, // e.g. 10500.0
    required int weeklyStrengthSessions, // e.g. 3
    required double deepSleepPercentage, // e.g. 20.0
    required double weeklySleepDebtHours, // e.g. 0.8
    required double antiInflammatoryDietScore, // e.g. 85.0
    required double dailyProteinGramsPerKg, // e.g. 1.4
    required double shatpawaliAdherencePercent, // e.g. 88.0
    required double averageStressScore, // e.g. 22.0
    DateTime? calculationDate,
  }) {
    final now = calculationDate ?? DateTime.now();

    // 1. Evaluate 6 Longevity Pillars
    // Pillar A: Cardiovascular Elasticity (20%)
    final cardioScore = _evaluateCardioScore(
      restingHeartRate,
      systolicBloodPressure,
      diastolicBloodPressure,
      rmssdHeartRateVariability,
    );
    final cardioPillar = LongevityPillarScore(
      pillar: LongevityPillarType.cardiovascular,
      score: cardioScore,
      primaryStrength:
          'Normotensive arterial compliance (${systolicBloodPressure.toInt()}/${diastolicBloodPressure.toInt()} mmHg) & high HRV (${rmssdHeartRateVariability.toInt()} ms).',
      regionalPrimaryStrength:
          'धमनियों में उत्तम लचीलापन (${systolicBloodPressure.toInt()}/${diastolicBloodPressure.toInt()} BP) व मजबूत वेगल टोन (${rmssdHeartRateVariability.toInt()} ms)।',
      optimizationOpportunity:
          'Target resting heart rate below 56 bpm with progressive aerobic sessions.',
      regionalOptimizationOpportunity:
          'नियमित एरोबिक अभ्यास से विश्राम हृदय गति को ५६ से नीचे लाएं।',
    );

    // Pillar B: Metabolic & Glycemic Reserve (20%)
    final metabolicScore = _evaluateMetabolicScore(
      waistToHeightRatio,
      fastingGlucoseMgDl,
      estimatedHbA1c,
    );
    final metabolicPillar = LongevityPillarScore(
      pillar: LongevityPillarType.metabolic,
      score: metabolicScore,
      primaryStrength:
          'Optimal waist-to-height ratio (${waistToHeightRatio.toStringAsFixed(2)}) minimizing visceral adipose inflammation.',
      regionalPrimaryStrength:
          'कमर-ऊंचाई अनुपात (${waistToHeightRatio.toStringAsFixed(2)}) आदर्श स्तर पर है जिससे आंतरिक चर्बी का जोखिम न्यूनतम है।',
      optimizationOpportunity:
          'Maintain 35g+ daily dietary fiber to preserve superior insulin sensitivity.',
      regionalOptimizationOpportunity:
          'इंसुलिन संवेदनशीलता बनाए रखने के लिए ३५ ग्राम फाइबर प्रतिदिन लें।',
    );

    // Pillar C: Cardiorespiratory & Musculoskeletal Reserve (20%)
    final fitnessScore = _evaluateFitnessScore(
      estimatedVo2Max,
      dailyStepsAverage,
      weeklyStrengthSessions,
      chronologicalAge,
    );
    final fitnessPillar = LongevityPillarScore(
      pillar: LongevityPillarType.cardiorespiratory,
      score: fitnessScore,
      primaryStrength:
          'High aerobic reserve (VO2 Max ${estimatedVo2Max.toStringAsFixed(1)}) and sarcopenic lean mass preservation.',
      regionalPrimaryStrength:
          'उत्कृष्ट एरोबिक क्षमता (VO2 Max ${estimatedVo2Max.toStringAsFixed(1)}) व मजबूत मांसपेशी भंडार।',
      optimizationOpportunity:
          'Progressive overload on compound multi-joint resistance lifts.',
      regionalOptimizationOpportunity:
          'शक्ति प्रशिक्षण में भार की क्रमिक वृद्धि जारी रखें।',
    );

    // Pillar D: Cellular Recovery & Circadian Architecture (15%)
    final sleepScore = _evaluateSleepScore(
      deepSleepPercentage,
      weeklySleepDebtHours,
    );
    final sleepPillar = LongevityPillarScore(
      pillar: LongevityPillarType.cellularRecovery,
      score: sleepScore,
      primaryStrength:
          'Restorative slow-wave deep sleep (${deepSleepPercentage.toStringAsFixed(1)}%) supporting glymphatic neuro-repair.',
      regionalPrimaryStrength:
          'गहरी नींद (${deepSleepPercentage.toStringAsFixed(1)}%) से मस्तिष्क व कोशिकाओं की प्राकृतिक मरम्मत।',
      optimizationOpportunity:
          'Lock in a 10:30 PM bedtime to harmonize nocturnal melatonin release.',
      regionalOptimizationOpportunity:
          'मेलाटोनिन संतुलन हेतु १०:३० बजे सोने का नियम बनाएं।',
    );

    // Pillar E: Nutritional Anti-Inflammatory Index (15%)
    final nutritionScore = _evaluateNutritionScore(
      antiInflammatoryDietScore,
      dailyProteinGramsPerKg,
    );
    final nutritionPillar = LongevityPillarScore(
      pillar: LongevityPillarType.antiInflammatory,
      score: nutritionScore,
      primaryStrength:
          'High polyphenol antioxidant density and adequate protein intake (${dailyProteinGramsPerKg.toStringAsFixed(2)} g/kg).',
      regionalPrimaryStrength:
          'एंटीऑक्सीडेंट्स से भरपूर आहार व पर्याप्त प्रोटीन (${dailyProteinGramsPerKg.toStringAsFixed(2)} g/kg)।',
      optimizationOpportunity:
          'Incorporate rich sources of Omega-3s (flaxseeds, walnuts) daily.',
      regionalOptimizationOpportunity:
          'दैनिक आहार में ओमेगा-३ (अलसी, अखरोट) को प्राथमिकता दें।',
    );

    // Pillar F: Ayurvedic & Mind-Body Homeostasis (10%)
    final ayurvedicScore = _evaluateAyurvedicScore(
      shatpawaliAdherencePercent,
      averageStressScore,
    );
    final ayurvedicPillar = LongevityPillarScore(
      pillar: LongevityPillarType.ayurvedicVagal,
      score: ayurvedicScore,
      primaryStrength:
          'Strong Shatpawali post-meal habit (${shatpawaliAdherencePercent.toInt()}%) and balanced autonomic tone.',
      regionalPrimaryStrength:
          'भोजनोपरांत शतपावली (${shatpawaliAdherencePercent.toInt()}%) व शांत मनोदशा का संतुलन।',
      optimizationOpportunity:
          'Add 10 minutes of morning Anulom-Vilom pranayama.',
      regionalOptimizationOpportunity:
          'प्रातःकाल १० मिनट अनुलोम-विलोम प्राणायाम जोड़ें।',
    );

    final allPillars = [
      cardioPillar,
      metabolicPillar,
      fitnessPillar,
      sleepPillar,
      nutritionPillar,
      ayurvedicPillar,
    ];

    // 2. Composite Longevity Score Calculation
    final compositeScore = _round(
      (cardioScore * LongevityPillarType.cardiovascular.weight) +
          (metabolicScore * LongevityPillarType.metabolic.weight) +
          (fitnessScore * LongevityPillarType.cardiorespiratory.weight) +
          (sleepScore * LongevityPillarType.cellularRecovery.weight) +
          (nutritionScore * LongevityPillarType.antiInflammatory.weight) +
          (ayurvedicScore * LongevityPillarType.ayurvedicVagal.weight),
    );

    final tier = _determineTier(compositeScore);

    // 3. Healthspan & Projected Healthy Lifespan Calculations
    // Baseline Indian life expectancy ~ 71.0 years
    const baselineLifeExpectancy = 71.0;
    final ageRejuvenationBonus = (chronologicalAge - biologicalAge) * 0.75;
    final scoreBonus = ((compositeScore - 50.0) / 50.0) * 8.5;
    final healthspanBonusYears = _round(ageRejuvenationBonus + scoreBonus);
    final projectedHealthspanAge =
        _round(baselineLifeExpectancy + healthspanBonusYears);

    // 4. Actionable Longevity Accelerators
    final accelerators = _generateAccelerators(
      vo2Max: estimatedVo2Max,
      whtr: waistToHeightRatio,
      deepSleep: deepSleepPercentage,
      strengthSessions: weeklyStrengthSessions,
      protein: dailyProteinGramsPerKg,
    );

    // 5. Assets & Vulnerabilities
    final sortedPillars = List<LongevityPillarScore>.from(allPillars)
      ..sort((a, b) => b.score.compareTo(a.score));

    final bestPillar = sortedPillars.first;
    final weakestPillar = sortedPillars.last;

    final primaryAsset =
        '${bestPillar.pillar.name} (${bestPillar.score.toInt()}/100)';
    final regionalPrimaryAsset =
        '${bestPillar.pillar.regionalName} (${bestPillar.score.toInt()}/100)';

    final primaryVulnerability =
        '${weakestPillar.pillar.name} (${weakestPillar.score.toInt()}/100)';
    final regionalPrimaryVulnerability =
        '${weakestPillar.pillar.regionalName} (${weakestPillar.score.toInt()}/100)';

    return LongevityReport(
      compositeScore: compositeScore,
      tier: tier,
      chronologicalAge: chronologicalAge,
      biologicalAge: biologicalAge,
      projectedHealthspanAge: projectedHealthspanAge,
      healthspanBonusYears: healthspanBonusYears,
      pillarScores: allPillars,
      topAccelerators: accelerators,
      primaryLongevityAsset: primaryAsset,
      regionalPrimaryLongevityAsset: regionalPrimaryAsset,
      primaryVulnerability: primaryVulnerability,
      regionalPrimaryVulnerability: regionalPrimaryVulnerability,
      calculatedAt: now,
    );
  }

  // --- Internal Pillar Calculations ---

  double _evaluateCardioScore(double rhr, double sbp, double dbp, double hrv) {
    double score = 100.0;
    if (rhr > 72) {
      score -= 18;
    } else if (rhr > 64) {
      score -= 8;
    } else if (rhr > 58) {
      score -= 3;
    }

    if (sbp > 130 || dbp > 85) {
      score -= 20;
    } else if (sbp > 120 || dbp > 80) {
      score -= 8;
    }

    if (hrv < 35) {
      score -= 16;
    } else if (hrv < 48) {
      score -= 6;
    }

    return score.clamp(35.0, 99.0);
  }

  double _evaluateMetabolicScore(double whtr, double glucose, double hba1c) {
    double score = 100.0;
    if (whtr > 0.52) {
      score -= 25;
    } else if (whtr > 0.48) {
      score -= 12;
    } else if (whtr > 0.46) {
      score -= 4;
    }

    if (hba1c > 6.0) {
      score -= 25;
    } else if (hba1c > 5.6) {
      score -= 12;
    } else if (hba1c > 5.3) {
      score -= 4;
    }

    if (glucose > 105) {
      score -= 10;
    }

    return score.clamp(30.0, 99.0);
  }

  double _evaluateFitnessScore(
      double vo2, double steps, int lifts, double chronoAge) {
    double score = 100.0;
    final targetVo2 = 45.0 - (chronoAge - 20) * 0.3;
    final vo2Diff = vo2 - targetVo2;

    if (vo2Diff < -6.0) {
      score -= 25;
    } else if (vo2Diff < 0.0) {
      score -= 12;
    }

    if (steps < 6000) {
      score -= 18;
    } else if (steps < 9000) {
      score -= 6;
    }

    if (lifts < 2) {
      score -= 15;
    } else if (lifts < 3) {
      score -= 5;
    }

    return score.clamp(35.0, 99.0);
  }

  double _evaluateSleepScore(double deepSleep, double sleepDebt) {
    double score = 100.0;
    if (deepSleep < 12.0) {
      score -= 22;
    } else if (deepSleep < 17.0) {
      score -= 10;
    } else if (deepSleep < 20.0) {
      score -= 4;
    }

    if (sleepDebt > 4.0) {
      score -= 18;
    } else if (sleepDebt > 2.0) {
      score -= 8;
    }

    return score.clamp(35.0, 99.0);
  }

  double _evaluateNutritionScore(double dietScore, double protein) {
    double score = 100.0;
    if (dietScore < 60) {
      score -= 22;
    } else if (dietScore < 75) {
      score -= 10;
    }

    if (protein < 1.0) {
      score -= 18;
    } else if (protein < 1.3) {
      score -= 6;
    }

    return score.clamp(35.0, 99.0);
  }

  double _evaluateAyurvedicScore(double shatpawali, double stress) {
    double score = 100.0;
    if (shatpawali < 60) {
      score -= 18;
    } else if (shatpawali < 80) {
      score -= 6;
    }

    if (stress > 65) {
      score -= 20;
    } else if (stress > 45) {
      score -= 8;
    }

    return score.clamp(35.0, 99.0);
  }

  LongevityTier _determineTier(double score) {
    if (score >= 90.0) {
      return LongevityTier.centenarian;
    }
    if (score >= 75.0) {
      return LongevityTier.optimal;
    }
    if (score >= 55.0) {
      return LongevityTier.moderate;
    }
    return LongevityTier.compromised;
  }

  List<LongevityAccelerator> _generateAccelerators({
    required double vo2Max,
    required double whtr,
    required double deepSleep,
    required int strengthSessions,
    required double protein,
  }) {
    final accelerators = <LongevityAccelerator>[];

    accelerators.add(
      const LongevityAccelerator(
        id: 'accel_vo2_expansion',
        pillar: LongevityPillarType.cardiorespiratory,
        title: 'Zone 2 Mitochondrial Biogenesis Progression',
        regionalTitle: 'ज़ोन २ माइटोकॉन्ड्रियल एरोबिक विस्तार',
        scientificRationale:
            'Expanding VO2 Max top decile reserve correlates with a 5x reduction in all-cause mortality risk.',
        regionalScientificRationale:
            'VO2 Max बढ़ाने से समग्र जीवन प्रत्याशा में ५ गुना सुधार देखा गया है।',
        projectedHealthspanYearsGained: 3.2,
        implementationEase: 'Moderate',
        karmaReward: 100,
      ),
    );

    if (whtr > 0.46) {
      accelerators.add(
        const LongevityAccelerator(
          id: 'accel_visceral_adipose',
          pillar: LongevityPillarType.metabolic,
          title: 'Waist-to-Height Optimization (< 0.46)',
          regionalTitle: 'कमर-ऊंचाई अनुपात सुधार (< ०.४६)',
          scientificRationale:
              'Eliminating subclinical visceral adiposity halts chronic low-grade cytokine inflammation.',
          regionalScientificRationale:
              'विसरल फैट कम करने से शरीर में आंतरिक सूजन का अंत होता है।',
          projectedHealthspanYearsGained: 2.6,
          implementationEase: 'High Focus',
          karmaReward: 90,
        ),
      );
    }

    accelerators.add(
      const LongevityAccelerator(
        id: 'accel_sarcopenia_resistance',
        pillar: LongevityPillarType.cardiorespiratory,
        title: 'Compound Progressive Hypertrophy Lifts',
        regionalTitle: 'मांसपेशी मजबूती व शक्ति प्रशिक्षण',
        scientificRationale:
            'Preserving lean muscle mass and bone mineral density shields against frailty past age 65.',
        regionalScientificRationale:
            'मजबूत मांसपेशियां ६५ वर्ष की आयु के बाद भी शरीर को सक्रिय रखती हैं।',
        projectedHealthspanYearsGained: 2.1,
        implementationEase: 'Moderate',
        karmaReward: 80,
      ),
    );

    if (deepSleep < 20.0) {
      accelerators.add(
        const LongevityAccelerator(
          id: 'accel_glymphatic_delta',
          pillar: LongevityPillarType.cellularRecovery,
          title: 'Glymphatic Slow-Wave Delta Optimization',
          regionalTitle: 'गहरी नींद व न्यूरो-कोशिकीय सफाई',
          scientificRationale:
              'Deep delta sleep facilitates clearance of amyloid-beta peptides from the cerebral cortex.',
          regionalScientificRationale:
              'गहरी नींद मस्तिष्क से विषाक्त पदार्थों की सफाई करती है।',
          projectedHealthspanYearsGained: 1.8,
          implementationEase: 'Effortless',
          karmaReward: 60,
        ),
      );
    }

    return accelerators;
  }

  double _round(double val) {
    return (val * 10).round() / 10.0;
  }
}
