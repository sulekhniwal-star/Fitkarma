import 'dart:math' as math;
import 'bio_age_models.dart';

/// Pure Dart Deterministic Engine for Biological Age Estimation & Longevity Dynamics
class BiologicalAgeEngine {
  const BiologicalAgeEngine();

  /// Calculate comprehensive biological age report
  BiologicalAgeReport estimateBiologicalAge({
    required double chronologicalAge,
    required double restingHeartRate, // bpm (e.g. 62)
    required double rmssdHeartRateVariability, // ms (e.g. 48)
    required double systolicBloodPressure, // mmHg (e.g. 118)
    required double diastolicBloodPressure, // mmHg (e.g. 76)
    required double waistToHeightRatio, // ratio (e.g. 0.47)
    required double fastingGlucoseMgDl, // mg/dL (e.g. 92)
    required double estimatedHbA1c, // % (e.g. 5.3)
    required double estimatedVo2Max, // ml/kg/min (e.g. 42.0)
    required double dailyStepsAverage, // steps/day (e.g. 9200)
    required int weeklyStrengthSessions, // sessions/wk (e.g. 3)
    required double deepSleepPercentage, // % (e.g. 19.5)
    required double weeklySleepDebtHours, // hours (e.g. 1.8)
    required double antiInflammatoryDietScore, // 0 to 100 (e.g. 82)
    DateTime? calculationDate,
  }) {
    final now = calculationDate ?? DateTime.now();

    // 1. Cardiovascular Biomarker Contributions
    final cardioDeltas = <BiomarkerAgeContribution>[];

    // RHR Delta
    final rhrDelta = _calculateRhrDelta(restingHeartRate);
    cardioDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_rhr',
        system: OrganSystemType.cardiovascular,
        name: 'Resting Heart Rate (RHR)',
        regionalName: 'विश्राम हृदय गति (RHR)',
        measuredValue: restingHeartRate,
        unit: 'bpm',
        optimalReference: 58.0,
        yearsImpact: rhrDelta,
        impactType: _impactTypeForYears(rhrDelta),
        clinicalRationale: rhrDelta <= 0
            ? 'Strong stroke volume and athletic myocardial efficiency.'
            : 'Elevated baseline workload on the vascular tree.',
        regionalClinicalRationale: rhrDelta <= 0
            ? 'मजबूत हृदय पंपिंग क्षमता व उत्कृष्ट कार्डियक स्वास्थ्य।'
            : 'हृदय और रक्त वाहिकाओं पर निरंतर अतिरिक्त तनाव।',
      ),
    );

    // HRV Delta
    final hrvDelta = _calculateHrvDelta(rmssdHeartRateVariability);
    cardioDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_hrv',
        system: OrganSystemType.cardiovascular,
        name: 'Vagal HRV (rMSSD)',
        regionalName: 'स्वायत्त वेगल परिवर्तनशीलता (HRV)',
        measuredValue: rmssdHeartRateVariability,
        unit: 'ms',
        optimalReference: 50.0,
        yearsImpact: hrvDelta,
        impactType: _impactTypeForYears(hrvDelta),
        clinicalRationale: hrvDelta <= 0
            ? 'Robust parasympathetic braking and high stress resilience.'
            : 'Sympathetic tone dominance signaling chronic neuro-strain.',
        regionalClinicalRationale: hrvDelta <= 0
            ? 'उत्कृष्ट पैरासिम्पेथेटिक नियंत्रण व तनाव सहने की क्षमता।'
            : 'सहानुभूति तंत्रिका प्रभुत्व व दीर्घकालिक तनाव का संकेत।',
      ),
    );

    // Blood Pressure Delta
    final bpDelta = _calculateBpDelta(systolicBloodPressure, diastolicBloodPressure);
    cardioDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_bp',
        system: OrganSystemType.cardiovascular,
        name: 'Arterial Pressure (BP)',
        regionalName: 'धमनी रक्तचाप (BP)',
        measuredValue: systolicBloodPressure,
        unit: 'mmHg',
        optimalReference: 115.0,
        yearsImpact: bpDelta,
        impactType: _impactTypeForYears(bpDelta),
        clinicalRationale: bpDelta <= 0
            ? 'Pliable arterial walls with minimal endothelial shear strain.'
            : 'Arterial stiffness and elevated peripheral vascular resistance.',
        regionalClinicalRationale: bpDelta <= 0
            ? 'धमनियों में लचीलापन व अंतःकला पर न्यूनतम दबाव।'
            : 'धमनियों में कठोरता व बढ़ा हुआ संवहनी प्रतिरोध।',
      ),
    );

    final totalCardioDelta = rhrDelta + hrvDelta + bpDelta;

    // 2. Metabolic & Glycemic Biomarker Contributions
    final metabolicDeltas = <BiomarkerAgeContribution>[];

    // WHtR Delta (South Asian Calibrated)
    final whtrDelta = _calculateWhtrDelta(waistToHeightRatio);
    metabolicDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_whtr',
        system: OrganSystemType.metabolic,
        name: 'Waist-to-Height Ratio (WHtR)',
        regionalName: 'कमर-ऊंचाई अनुपात (आंतरिक चर्बी)',
        measuredValue: waistToHeightRatio,
        unit: 'ratio',
        optimalReference: 0.45,
        yearsImpact: whtrDelta,
        impactType: _impactTypeForYears(whtrDelta),
        clinicalRationale: whtrDelta <= 0
            ? 'Minimal visceral adipose deposition protecting hepatic metabolism.'
            : 'Elevated visceral fat triggering subclinical adipokine inflammation.',
        regionalClinicalRationale: whtrDelta <= 0
            ? 'आंतरिक चर्बी का निम्न स्तर, जो यकृत उपापचय को स्वस्थ रखता है।'
            : 'अतिरिक्त विसरल फैट जो शरीर में सूक्ष्म सूजन बढ़ाता है।',
      ),
    );

    // Glycemic / HbA1c Delta
    final glycemicDelta = _calculateGlycemicDelta(fastingGlucoseMgDl, estimatedHbA1c);
    metabolicDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_glycemic',
        system: OrganSystemType.metabolic,
        name: 'Estimated HbA1c & Glycemia',
        regionalName: 'अनुमानित HbA1c व शर्करा संतुलन',
        measuredValue: estimatedHbA1c,
        unit: '%',
        optimalReference: 5.2,
        yearsImpact: glycemicDelta,
        impactType: _impactTypeForYears(glycemicDelta),
        clinicalRationale: glycemicDelta <= 0
            ? 'Superior insulin sensitivity and minimal advanced glycation end-products (AGEs).'
            : 'Insulin resistance accelerating vascular endothelial glycation.',
        regionalClinicalRationale: glycemicDelta <= 0
            ? 'उत्तम इंसुलिन संवेदनशीलता व ग्लाइकेशन क्षति का न्यूनतम स्तर।'
            : 'इंसुलिन प्रतिरोध जो रक्त वाहिकाओं के क्षरण को गति देता है।',
      ),
    );

    final totalMetabolicDelta = whtrDelta + glycemicDelta;

    // 3. Musculoskeletal & Cardiorespiratory Contributions
    final musculoDeltas = <BiomarkerAgeContribution>[];

    // VO2 Max Delta
    final vo2Delta = _calculateVo2Delta(estimatedVo2Max, chronologicalAge);
    musculoDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_vo2',
        system: OrganSystemType.musculoskeletal,
        name: 'Cardiorespiratory VO2 Max',
        regionalName: 'कार्डियोरेस्पिरेटरी VO2 Max क्षमता',
        measuredValue: estimatedVo2Max,
        unit: 'ml/kg/min',
        optimalReference: 44.0,
        yearsImpact: vo2Delta,
        impactType: _impactTypeForYears(vo2Delta),
        clinicalRationale: vo2Delta <= 0
            ? 'Elevated mitochondrial density and powerful cardiorespiratory reserve.'
            : 'Reduced aerobic capacity linked to accelerated cellular senescence.',
        regionalClinicalRationale: vo2Delta <= 0
            ? 'माइटोकॉन्ड्रियल घनत्व व उत्कृष्ट फेफड़े/हृदय की सहनशक्ति।'
            : 'कम एरोबिक क्षमता जो कोशिकीय वृद्धावस्था को गति देती है।',
      ),
    );

    // Movement & Strength Delta
    final movementDelta = _calculateMovementDelta(dailyStepsAverage, weeklyStrengthSessions);
    musculoDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_movement_strength',
        system: OrganSystemType.musculoskeletal,
        name: 'Muscular Density & Activity',
        regionalName: 'मांसपेशी घनत्व व दैनिक सक्रियता',
        measuredValue: dailyStepsAverage,
        unit: 'steps/d',
        optimalReference: 10000.0,
        yearsImpact: movementDelta,
        impactType: _impactTypeForYears(movementDelta),
        clinicalRationale: movementDelta <= 0
            ? 'Protective skeletal muscle reservoir counteracting sarcopenia.'
            : 'Sedentary pattern elevating sarcopenic weakness risk.',
        regionalClinicalRationale: movementDelta <= 0
            ? 'सुरक्षात्मक मांसपेशी भंडार जो उम्र के साथ क्षय को रोकता है।'
            : 'कम गतिशीलता जो मांसपेशियों की दुर्बलता को बढ़ाती है।',
      ),
    );

    final totalMusculoDelta = vo2Delta + movementDelta;

    // 4. Cellular Recovery & Neuro-Circadian Contributions
    final recoveryDeltas = <BiomarkerAgeContribution>[];

    // Deep Sleep & Sleep Debt Delta
    final sleepDelta = _calculateSleepDelta(deepSleepPercentage, weeklySleepDebtHours);
    recoveryDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_sleep',
        system: OrganSystemType.cellularRecovery,
        name: 'Deep Sleep & Circadian Debt',
        regionalName: 'गहरी नींद व जैविक पुनर्जनन',
        measuredValue: deepSleepPercentage,
        unit: '% deep',
        optimalReference: 20.0,
        yearsImpact: sleepDelta,
        impactType: _impactTypeForYears(sleepDelta),
        clinicalRationale: sleepDelta <= 0
            ? 'Efficient glymphatic brain clearance and nocturnal growth hormone release.'
            : 'Insufficient slow-wave sleep impeding neuro-cellular repair.',
        regionalClinicalRationale: sleepDelta <= 0
            ? 'मस्तिष्क की गहरी सफाई (ग्लिम्फैटिक) व रात में प्राकृतिक मरम्मत।'
            : 'गहरी नींद की कमी जो कोशिकीय मरम्मत में बाधा डालती है।',
      ),
    );

    // Nutrition & Inflammatory Score Delta
    final dietDelta = _calculateDietDelta(antiInflammatoryDietScore);
    recoveryDeltas.add(
      BiomarkerAgeContribution(
        id: 'bio_diet',
        system: OrganSystemType.cellularRecovery,
        name: 'Anti-Inflammatory Nutrition Index',
        regionalName: 'सूजन-रोधी भारतीय पोषण सूचकांक',
        measuredValue: antiInflammatoryDietScore,
        unit: '/100',
        optimalReference: 85.0,
        yearsImpact: dietDelta,
        impactType: _impactTypeForYears(dietDelta),
        clinicalRationale: dietDelta <= 0
            ? 'Rich polyphenol and antioxidant intake suppressing systemic oxidants.'
            : 'Elevated ultra-processed and inflammatory dietary exposure.',
        regionalClinicalRationale: dietDelta <= 0
            ? 'पॉलीफेनोल व एंटीऑक्सीडेंट्स से भरपूर आहार जो सूजन रोकता है।'
            : 'प्रसंस्कृत आहार जो शरीर में ऑक्सीडेटिव तनाव बढ़ाता है।',
      ),
    );

    final totalRecoveryDelta = sleepDelta + dietDelta;

    // All Biomarkers combined
    final allBiomarkers = [
      ...cardioDeltas,
      ...metabolicDeltas,
      ...musculoDeltas,
      ...recoveryDeltas,
    ];

    // Calculate Organ System Ages
    final systemAges = [
      OrganSystemAge(
        system: OrganSystemType.cardiovascular,
        estimatedAge: _round((chronologicalAge + totalCardioDelta).clamp(18.0, 90.0)),
        chronologicalAge: chronologicalAge,
        ageDelta: _round(totalCardioDelta),
        performanceScore: _scoreForDelta(totalCardioDelta),
        keyBiomarkerSummary: 'RHR ${restingHeartRate.toInt()} bpm • SBP ${systolicBloodPressure.toInt()} mmHg • HRV ${rmssdHeartRateVariability.toInt()} ms',
        regionalKeyBiomarkerSummary: 'हृदय गति ${restingHeartRate.toInt()} bpm • रक्तचाप ${systolicBloodPressure.toInt()} • HRV ${rmssdHeartRateVariability.toInt()} ms',
      ),
      OrganSystemAge(
        system: OrganSystemType.metabolic,
        estimatedAge: _round((chronologicalAge + totalMetabolicDelta).clamp(18.0, 90.0)),
        chronologicalAge: chronologicalAge,
        ageDelta: _round(totalMetabolicDelta),
        performanceScore: _scoreForDelta(totalMetabolicDelta),
        keyBiomarkerSummary: 'HbA1c ${estimatedHbA1c.toStringAsFixed(1)}% • WHtR ${waistToHeightRatio.toStringAsFixed(2)} • Glucose ${fastingGlucoseMgDl.toInt()} mg/dL',
        regionalKeyBiomarkerSummary: 'HbA1c ${estimatedHbA1c.toStringAsFixed(1)}% • कमर अनुपात ${waistToHeightRatio.toStringAsFixed(2)} • शर्करा ${fastingGlucoseMgDl.toInt()} mg/dL',
      ),
      OrganSystemAge(
        system: OrganSystemType.musculoskeletal,
        estimatedAge: _round((chronologicalAge + totalMusculoDelta).clamp(18.0, 90.0)),
        chronologicalAge: chronologicalAge,
        ageDelta: _round(totalMusculoDelta),
        performanceScore: _scoreForDelta(totalMusculoDelta),
        keyBiomarkerSummary: 'VO2 Max ${estimatedVo2Max.toStringAsFixed(1)} • ${(dailyStepsAverage / 1000).toStringAsFixed(1)}k steps/day • $weeklyStrengthSessions lifts/wk',
        regionalKeyBiomarkerSummary: 'VO2 Max ${estimatedVo2Max.toStringAsFixed(1)} • ${(dailyStepsAverage / 1000).toStringAsFixed(1)}k कदम/दिन • $weeklyStrengthSessions शक्ति व्यायाम/सप्ताह',
      ),
      OrganSystemAge(
        system: OrganSystemType.cellularRecovery,
        estimatedAge: _round((chronologicalAge + totalRecoveryDelta).clamp(18.0, 90.0)),
        chronologicalAge: chronologicalAge,
        ageDelta: _round(totalRecoveryDelta),
        performanceScore: _scoreForDelta(totalRecoveryDelta),
        keyBiomarkerSummary: 'Deep Sleep ${deepSleepPercentage.toStringAsFixed(1)}% • Sleep Debt ${weeklySleepDebtHours.toStringAsFixed(1)}h • Diet ${antiInflammatoryDietScore.toInt()}/100',
        regionalKeyBiomarkerSummary: 'गहरी नींद ${deepSleepPercentage.toStringAsFixed(1)}% • नींद ऋण ${weeklySleepDebtHours.toStringAsFixed(1)}घं • आहार ${antiInflammatoryDietScore.toInt()}/100',
      ),
    ];

    // Weighted Overall Biological Age Delta
    // Weights: Cardio (30%), Metabolic (30%), Musculoskeletal (25%), Recovery (15%)
    final weightedDelta = (totalCardioDelta * 0.30) +
        (totalMetabolicDelta * 0.30) +
        (totalMusculoDelta * 0.25) +
        (totalRecoveryDelta * 0.15);

    // Biological age clamped within sensible physiological limits [chrono - 14, chrono + 18]
    final biologicalAge = _round(
      (chronologicalAge + weightedDelta).clamp(
        math.max(18.0, chronologicalAge - 14.0),
        chronologicalAge + 18.0,
      ),
    );

    final netAgeDelta = _round(biologicalAge - chronologicalAge);

    // Pace of Aging: 1.0 is equal to chronological time
    final agingPace = _round(
      (1.0 + (netAgeDelta / (chronologicalAge * 0.65))).clamp(0.65, 1.45),
    );

    final paceStatus = agingPace < 0.92
        ? AgingPaceStatus.rejuvenating
        : (agingPace <= 1.06
            ? AgingPaceStatus.equilibrium
            : AgingPaceStatus.accelerated);

    // Generate Rejuvenation Levers
    final levers = _generateRejuvenationLevers(
      cardioDelta: totalCardioDelta,
      metabolicDelta: totalMetabolicDelta,
      musculoDelta: totalMusculoDelta,
      recoveryDelta: totalRecoveryDelta,
      whtr: waistToHeightRatio,
      vo2Max: estimatedVo2Max,
      deepSleep: deepSleepPercentage,
      strengthSessions: weeklyStrengthSessions,
    );

    // Generate 12-Month Trajectory
    final trajectory = _generate12MonthTrajectory(
      currentDate: now,
      currentBioAge: biologicalAge,
      chronologicalAge: chronologicalAge,
      currentPace: agingPace,
      totalCardioDelta: totalCardioDelta,
      totalMetabolicDelta: totalMetabolicDelta,
      totalMusculoDelta: totalMusculoDelta,
      totalRecoveryDelta: totalRecoveryDelta,
    );

    // Determine primary assets and drivers
    final sortedBiomarkers = List<BiomarkerAgeContribution>.from(allBiomarkers)
      ..sort((a, b) => a.yearsImpact.compareTo(b.yearsImpact));

    final bestBiomarker = sortedBiomarkers.first;
    final worstBiomarker = sortedBiomarkers.last;

    final topAsset = '${bestBiomarker.name} (${bestBiomarker.yearsImpact <= 0 ? "" : "+"}${bestBiomarker.yearsImpact.toStringAsFixed(1)} yrs)';
    final regionalTopAsset = '${bestBiomarker.regionalName} (${bestBiomarker.yearsImpact <= 0 ? "" : "+"}${bestBiomarker.yearsImpact.toStringAsFixed(1)} वर्ष)';

    final primaryDriver = worstBiomarker.yearsImpact > 0
        ? '${worstBiomarker.name} (+${worstBiomarker.yearsImpact.toStringAsFixed(1)} yrs)'
        : 'All core biomarkers within optimal longevity baseline';
    final regionalPrimaryDriver = worstBiomarker.yearsImpact > 0
        ? '${worstBiomarker.regionalName} (+${worstBiomarker.yearsImpact.toStringAsFixed(1)} वर्ष)'
        : 'सभी प्रमुख बायोमार्कर्स दीर्घायु के लिए अनुकूल सीमा में हैं';

    return BiologicalAgeReport(
      chronologicalAge: chronologicalAge,
      biologicalAge: biologicalAge,
      ageDelta: netAgeDelta,
      agingPace: agingPace,
      paceStatus: paceStatus,
      systemAges: systemAges,
      biomarkerContributions: allBiomarkers,
      topRejuvenationLevers: levers,
      trajectory12Months: trajectory,
      topRejuvenatingAsset: topAsset,
      regionalTopRejuvenatingAsset: regionalTopAsset,
      primaryAgingDriver: primaryDriver,
      regionalPrimaryAgingDriver: regionalPrimaryDriver,
      calculatedAt: now,
    );
  }

  // --- Internal Biomarker Math Helpers ---

  double _calculateRhrDelta(double rhr) {
    if (rhr <= 54) return -1.2;
    if (rhr <= 60) return -0.8;
    if (rhr <= 66) return -0.3;
    if (rhr <= 72) return 0.2;
    if (rhr <= 78) return 0.8;
    if (rhr <= 85) return 1.5;
    return 2.4;
  }

  double _calculateHrvDelta(double rmssd) {
    if (rmssd >= 65) return -1.4;
    if (rmssd >= 50) return -0.9;
    if (rmssd >= 38) return -0.2;
    if (rmssd >= 28) return 0.5;
    if (rmssd >= 20) return 1.2;
    return 2.1;
  }

  double _calculateBpDelta(double sbp, double dbp) {
    double delta = 0.0;
    if (sbp < 115) {
      delta -= 0.6;
    } else if (sbp > 135) {
      delta += 1.6;
    } else if (sbp > 125) {
      delta += 0.8;
    }

    if (dbp < 75) {
      delta -= 0.4;
    } else if (dbp > 88) {
      delta += 1.2;
    } else if (dbp > 82) {
      delta += 0.5;
    }
    return delta;
  }

  double _calculateWhtrDelta(double whtr) {
    if (whtr <= 0.43) return -1.5;
    if (whtr <= 0.47) return -0.6;
    if (whtr <= 0.50) return 0.4;
    if (whtr <= 0.54) return 1.5;
    if (whtr <= 0.58) return 2.6;
    return 3.5;
  }

  double _calculateGlycemicDelta(double glucose, double hba1c) {
    double delta = 0.0;
    if (hba1c < 5.2) {
      delta -= 1.0;
    } else if (hba1c <= 5.5) {
      delta -= 0.4;
    } else if (hba1c <= 5.9) {
      delta += 0.9;
    } else if (hba1c <= 6.4) {
      delta += 2.0;
    } else {
      delta += 3.4;
    }

    if (glucose > 115) delta += 0.6;
    return delta;
  }

  double _calculateVo2Delta(double vo2, double chronoAge) {
    // Expected baseline for 30-year old is ~38-42
    final ageAdjustedBaseline = 45.0 - (chronoAge - 20) * 0.35;
    final diff = vo2 - ageAdjustedBaseline;

    if (diff >= 8.0) return -2.4;
    if (diff >= 4.0) return -1.5;
    if (diff >= 0.0) return -0.5;
    if (diff >= -5.0) return 0.8;
    if (diff >= -10.0) return 1.8;
    return 2.8;
  }

  double _calculateMovementDelta(double steps, int strengthSessions) {
    double delta = 0.0;
    if (steps >= 12000) {
      delta -= 1.2;
    } else if (steps >= 9000) {
      delta -= 0.7;
    } else if (steps >= 6500) {
      delta -= 0.1;
    } else if (steps < 4500) {
      delta += 1.4;
    } else {
      delta += 0.7;
    }

    if (strengthSessions >= 4) {
      delta -= 1.1;
    } else if (strengthSessions >= 2) {
      delta -= 0.6;
    } else if (strengthSessions == 0) {
      delta += 0.9;
    }
    return delta;
  }

  double _calculateSleepDelta(double deepPercent, double sleepDebtHours) {
    double delta = 0.0;
    if (deepPercent >= 22) {
      delta -= 1.0;
    } else if (deepPercent >= 17) {
      delta -= 0.5;
    } else if (deepPercent < 10) {
      delta += 1.4;
    } else if (deepPercent < 14) {
      delta += 0.6;
    }

    if (sleepDebtHours > 5.0) {
      delta += 1.2;
    } else if (sleepDebtHours > 2.5) {
      delta += 0.5;
    } else if (sleepDebtHours <= 1.0) {
      delta -= 0.4;
    }
    return delta;
  }

  double _calculateDietDelta(double dietScore) {
    if (dietScore >= 85) return -1.1;
    if (dietScore >= 70) return -0.5;
    if (dietScore >= 50) return 0.3;
    if (dietScore >= 35) return 1.0;
    return 1.8;
  }

  BiomarkerImpactType _impactTypeForYears(double years) {
    if (years <= -0.2) return BiomarkerImpactType.rejuvenating;
    if (years >= 0.2) return BiomarkerImpactType.accelerating;
    return BiomarkerImpactType.neutral;
  }

  double _scoreForDelta(double delta) {
    // Lower delta is better. If delta == -3.0 => 95%, delta == 0 => 75%, delta == +3.0 => 50%
    final score = 75.0 - (delta * 7.5);
    return score.clamp(20.0, 99.0);
  }

  List<RejuvenationLever> _generateRejuvenationLevers({
    required double cardioDelta,
    required double metabolicDelta,
    required double musculoDelta,
    required double recoveryDelta,
    required double whtr,
    required double vo2Max,
    required double deepSleep,
    required int strengthSessions,
  }) {
    final levers = <RejuvenationLever>[];

    if (vo2Max < 44.0 || musculoDelta > 0) {
      levers.add(
        const RejuvenationLever(
          id: 'lever_zone2',
          targetedSystem: OrganSystemType.musculoskeletal,
          title: '3x 35-min Zone 2 Aerobic Base Progression',
          regionalTitle: 'सप्ताह में 3 बार 35 मिनट ज़ोन 2 कार्डियो',
          description: 'Expands mitochondrial cristae density and boosts cellular bio-energetics.',
          regionalDescription: 'माइटोकॉन्ड्रियल घनत्व बढ़ाता है और एरोबिक शक्ति को सुदृढ़ करता है।',
          potentialYearsSaved: 1.4,
          timeframe: '8-12 weeks',
          difficulty: 'Moderate',
          karmaReward: 75,
        ),
      );
    }

    if (whtr > 0.48 || metabolicDelta > 0) {
      levers.add(
        const RejuvenationLever(
          id: 'lever_shatpawali_fiber',
          targetedSystem: OrganSystemType.metabolic,
          title: 'Shatpawali (100-step walk) & 35g Preload Fiber',
          regionalTitle: 'भोजनोपरांत शतपावली (100 कदम) व फाइबर सेवन',
          description: 'Blunts postprandial glucose excursions and reduces hepatic visceral fat accumulation.',
          regionalDescription: 'भोजन के बाद शर्करा की वृद्धि रोकता है और यकृत की चर्बी कम करता है।',
          potentialYearsSaved: 1.1,
          timeframe: '6-8 weeks',
          difficulty: 'Gentle',
          karmaReward: 60,
        ),
      );
    }

    if (deepSleep < 18.0 || recoveryDelta > 0) {
      levers.add(
        const RejuvenationLever(
          id: 'lever_circadian_window',
          targetedSystem: OrganSystemType.cellularRecovery,
          title: 'Strict 10:30 PM Bedtime & Evening Blue Light Fast',
          regionalTitle: 'नियमित 10:30 PM शयन व नीली रोशनी प्रतिबंध',
          description: 'Synchronizes melatonin pulse and increases restorative slow-wave delta sleep by 25%.',
          regionalDescription: 'मेलाटोनिन स्राव को संतुलित कर गहरी रीस्टोरेटिव नींद 25% बढ़ाता है।',
          potentialYearsSaved: 0.9,
          timeframe: '4-6 weeks',
          difficulty: 'Moderate',
          karmaReward: 50,
        ),
      );
    }

    if (strengthSessions < 3) {
      levers.add(
        const RejuvenationLever(
          id: 'lever_hypertrophy_strength',
          targetedSystem: OrganSystemType.musculoskeletal,
          title: '3x Weekly Progressive Resistance Lifts',
          regionalTitle: 'सप्ताह में 3 बार प्रगतिशील शक्ति प्रशिक्षण',
          description: 'Preserves fast-twitch type II muscle fibers and maintains bone mineral density.',
          regionalDescription: 'मांसपेशियों के क्षय को रोकता है और अस्थि घनत्व को मजबूत रखता है।',
          potentialYearsSaved: 0.8,
          timeframe: '10-14 weeks',
          difficulty: 'Rigorous',
          karmaReward: 80,
        ),
      );
    }

    if (cardioDelta > 0) {
      levers.add(
        const RejuvenationLever(
          id: 'lever_pranayama_bp',
          targetedSystem: OrganSystemType.cardiovascular,
          title: 'Daily 10-Min Anulom Vilom & Resonance Breathing',
          regionalTitle: 'प्रतिदिन 10 मिनट अनुलोम-विलोम व गहरी सांस',
          description: 'Enhances baroreflex sensitivity and reduces baseline systolic blood pressure by 4-6 mmHg.',
          regionalDescription: 'रक्तचाप को 4-6 mmHg कम करता है और वेगल टोन को सक्रिय करता है।',
          potentialYearsSaved: 0.7,
          timeframe: '4 weeks',
          difficulty: 'Gentle',
          karmaReward: 40,
        ),
      );
    }

    return levers;
  }

  List<MonthlyBioAgeSnapshot> _generate12MonthTrajectory({
    required DateTime currentDate,
    required double currentBioAge,
    required double chronologicalAge,
    required double currentPace,
    required double totalCardioDelta,
    required double totalMetabolicDelta,
    required double totalMusculoDelta,
    required double totalRecoveryDelta,
  }) {
    final list = <MonthlyBioAgeSnapshot>[];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // Backtrack 11 months + current month (total 12 months)
    for (int i = 11; i >= 0; i--) {
      final monthDate = DateTime(currentDate.year, currentDate.month - i, 1);
      final monthLabel = '${monthNames[monthDate.month - 1]} ${monthDate.year.toString().substring(2)}';

      // Past chronological age adjusted slightly for the 12 month window
      final pastChrono = chronologicalAge - (i / 12.0);

      // Trajectory curve modeling gradual positive intervention impact
      // 11 months ago, user had slightly higher biological age, improving towards currentBioAge
      final progressFraction = (11 - i) / 11.0;
      final initialBioAgeDelta = 2.2; // Start from +2.2 years older initially
      final currentDelta = currentBioAge - chronologicalAge;
      final interpolatedDelta = initialBioAgeDelta + (currentDelta - initialBioAgeDelta) * progressFraction;

      final histBioAge = _round(pastChrono + interpolatedDelta);
      final histPace = _round(1.0 + (interpolatedDelta / (pastChrono * 0.65)));

      list.add(
        MonthlyBioAgeSnapshot(
          date: monthDate,
          monthLabel: monthLabel,
          chronologicalAge: _round(pastChrono),
          biologicalAge: histBioAge,
          agingPace: histPace,
          metabolicAge: _round(pastChrono + (totalMetabolicDelta * progressFraction) + (1.5 * (1 - progressFraction))),
          cardiovascularAge: _round(pastChrono + (totalCardioDelta * progressFraction) + (1.2 * (1 - progressFraction))),
          musculoskeletalAge: _round(pastChrono + (totalMusculoDelta * progressFraction) + (1.8 * (1 - progressFraction))),
          recoveryAge: _round(pastChrono + (totalRecoveryDelta * progressFraction) + (1.0 * (1 - progressFraction))),
        ),
      );
    }
    return list;
  }

  double _round(double val) {
    return (val * 10).round() / 10.0;
  }
}
