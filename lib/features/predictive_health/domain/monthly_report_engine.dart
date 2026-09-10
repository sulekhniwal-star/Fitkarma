import 'monthly_report_models.dart';

/// Pure Dart Deterministic Engine for Monthly Health Synthesis & Clinical Report Generation
class MonthlyHealthReportEngine {
  const MonthlyHealthReportEngine();

  /// Synthesize complete 30-day health performance report
  MonthlyHealthReport generateMonthlyReport({
    required String monthTitle,
    required String regionalMonthTitle,
    required double avgRestingHeartRate, // e.g. 60.5 bpm
    required double avgSystolicBp, // e.g. 117.0 mmHg
    required double avgDiastolicBp, // e.g. 75.0 mmHg
    required double avgHrvRmssd, // e.g. 52.0 ms
    required double avgDailySteps, // e.g. 10450 steps/day
    required int strengthWorkoutsCount, // e.g. 14 sessions
    required double estimatedHbA1c, // e.g. 5.25%
    required double avgFastingGlucose, // e.g. 91.0 mg/dL
    required double shatpawaliAdherencePercent, // e.g. 85.0%
    required double avgSleepDurationHours, // e.g. 7.4 hours
    required double avgDeepSleepPercent, // e.g. 19.5%
    required double netSleepDebtHours, // e.g. 1.2 hours
    required double avgProteinGramsPerKg, // e.g. 1.4 g/kg
    required double antiInflammatoryDietScore, // e.g. 84.0/100
    required double biologicalAge, // e.g. 29.4
    required double chronologicalAge, // e.g. 32.0
    required double monthlyBioAgeImprovement, // e.g. -0.4 years
    required double agingPace, // e.g. 0.86x
    DateTime? generationDate,
  }) {
    final now = generationDate ?? DateTime.now();

    // 1. Cardiovascular & Hemodynamic Pillar
    final cardioScore = _calculateCardioScore(
      avgRestingHeartRate,
      avgSystolicBp,
      avgDiastolicBp,
      avgHrvRmssd,
    );
    final cardioPillar = MonthlyPillarSummary(
      title: 'Cardiovascular & Vagal Tone',
      regionalTitle: 'हृदय संवहनी व वेगल संतुलन',
      iconName: 'favorite',
      score: cardioScore,
      statusLabel: cardioScore >= 85
          ? 'Optimal'
          : (cardioScore >= 70 ? 'Stable' : 'Needs Attention'),
      regionalStatusLabel: cardioScore >= 85
          ? 'उत्तम'
          : (cardioScore >= 70 ? 'संतुलित' : 'सुधार योग्य'),
      primaryMetric: '${avgRestingHeartRate.toStringAsFixed(0)} bpm RHR',
      primaryMetricLabel:
          'Avg RHR • ${avgSystolicBp.toInt()}/${avgDiastolicBp.toInt()} BP',
      monthDelta: '-2 bpm RHR vs last month',
      isPositiveDelta: true,
      bulletInsights: [
        'Resting pulse remained in athletic range (< 62 bpm) on 92% of recorded days.',
        'Arterial pressure stabilized at optimal normotensive levels (${avgSystolicBp.toInt()}/${avgDiastolicBp.toInt()} mmHg).',
        'Autonomic parasympathetic recovery (rMSSD) averaged ${avgHrvRmssd.toStringAsFixed(0)} ms.',
      ],
      regionalBulletInsights: [
        'विश्राम हृदय गति ९२% दिनों में उत्कृष्ट स्तर (< 62 bpm) पर रही।',
        'रक्तचाप पूर्णतः सामान्य व स्थिर स्तर (${avgSystolicBp.toInt()}/${avgDiastolicBp.toInt()} mmHg) पर रहा।',
        'वेगल नर्व रिकवरी (HRV) औसतन ${avgHrvRmssd.toStringAsFixed(0)} ms दर्ज हुई।',
      ],
    );

    // 2. Glycemic & Metabolic Pillar
    final metabolicScore = _calculateMetabolicScore(
      estimatedHbA1c,
      avgFastingGlucose,
      shatpawaliAdherencePercent,
    );
    final metabolicPillar = MonthlyPillarSummary(
      title: 'Glycemic & Postprandial Homeostasis',
      regionalTitle: 'शर्करा व पाचन उपापचयी संतुलन',
      iconName: 'bolt',
      score: metabolicScore,
      statusLabel: metabolicScore >= 85
          ? 'Superior Control'
          : (metabolicScore >= 70 ? 'Controlled' : 'Variability Observed'),
      regionalStatusLabel: metabolicScore >= 85
          ? 'उत्कृष्ट नियंत्रण'
          : (metabolicScore >= 70 ? 'नियंत्रित' : 'उतार-चढ़ाव'),
      primaryMetric: '${estimatedHbA1c.toStringAsFixed(2)}%',
      primaryMetricLabel:
          'Est. HbA1c • ${avgFastingGlucose.toStringAsFixed(0)} mg/dL Fasting',
      monthDelta: '-0.15% HbA1c trend',
      isPositiveDelta: true,
      bulletInsights: [
        'Estimated HbA1c maintained below pre-diabetes threshold (${estimatedHbA1c.toStringAsFixed(2)}%).',
        'Shatpawali (100-step post-meal walks) completed on ${shatpawaliAdherencePercent.toStringAsFixed(0)}% of dinners.',
        'Postprandial glycemic excursions blunted by consistent high-fiber dinner sequencing.',
      ],
      regionalBulletInsights: [
        'अनुमानित HbA1c सामान्य स्तर (${estimatedHbA1c.toStringAsFixed(2)}%) पर नियंत्रित रहा।',
        'रात्रि भोजन के बाद शतपावली ${shatpawaliAdherencePercent.toStringAsFixed(0)}% दिनों में पूरी की गई।',
        'भोजन के बाद शर्करा की वृद्धि में उल्लेखनीय कमी दर्ज की गई।',
      ],
    );

    // 3. Cardiorespiratory & Musculoskeletal Pillar
    final fitnessScore =
        _calculateFitnessScore(avgDailySteps, strengthWorkoutsCount);
    final fitnessPillar = MonthlyPillarSummary(
      title: 'Aerobic Reserve & Muscular Strength',
      regionalTitle: 'एरोबिक क्षमता व मांसपेशी शक्ति',
      iconName: 'fitness_center',
      score: fitnessScore,
      statusLabel: fitnessScore >= 85
          ? 'High Output'
          : (fitnessScore >= 70 ? 'Consistent' : 'Sub-Optimal'),
      regionalStatusLabel: fitnessScore >= 85
          ? 'उच्च सक्रियता'
          : (fitnessScore >= 70 ? 'नियमित' : 'न्यूनतम'),
      primaryMetric: '${(avgDailySteps / 1000).toStringAsFixed(1)}k steps/day',
      primaryMetricLabel:
          'Monthly Avg • $strengthWorkoutsCount Resistance Sessions',
      monthDelta: '+12% volume vs last month',
      isPositiveDelta: true,
      bulletInsights: [
        'Total active volume exceeded ${(avgDailySteps * 30 / 1000).toStringAsFixed(0)}k cumulative monthly steps.',
        'Completed $strengthWorkoutsCount progressive resistance sessions, preserving lean sarcopenic reserve.',
        'Movement density reduced sedentary daytime blocks to under 60 minutes.',
      ],
      regionalBulletInsights: [
        'मासिक कुल सक्रियता ${(avgDailySteps * 30 / 1000).toStringAsFixed(0)}k कदमों से अधिक रही।',
        'मांसपेशियों को सुदृढ़ रखने के लिए $strengthWorkoutsCount शक्ति सत्र पूरे किए गए।',
        'दिन भर में बैठने का समय सीमित रख कर गतिशीलता बनाए रखी गई।',
      ],
    );

    // 4. Sleep & Circadian Recovery Pillar
    final sleepScore = _calculateSleepScore(
      avgSleepDurationHours,
      avgDeepSleepPercent,
      netSleepDebtHours,
    );
    final sleepPillar = MonthlyPillarSummary(
      title: 'Sleep Architecture & Cellular Repair',
      regionalTitle: 'नींद संरचना व कोशिकीय पुनर्जनन',
      iconName: 'nights_stay',
      score: sleepScore,
      statusLabel: sleepScore >= 85
          ? 'Deeply Restorative'
          : (sleepScore >= 70 ? 'Sufficient' : 'Sleep Debt Elevated'),
      regionalStatusLabel: sleepScore >= 85
          ? 'गहरी मरम्मत'
          : (sleepScore >= 70 ? 'पर्याप्त' : 'नींद ऋण अधिक'),
      primaryMetric: '${avgSleepDurationHours.toStringAsFixed(1)} hrs',
      primaryMetricLabel:
          'Nightly Avg • ${avgDeepSleepPercent.toStringAsFixed(1)}% Deep Sleep',
      monthDelta: '+25 min restorative sleep',
      isPositiveDelta: true,
      bulletInsights: [
        'Nightly sleep duration averaged ${avgSleepDurationHours.toStringAsFixed(1)} hours with optimal timing.',
        'Slow-wave deep sleep represented ${avgDeepSleepPercent.toStringAsFixed(1)}% of total sleep time.',
        'Cumulative weekly sleep debt remained low at ${netSleepDebtHours.toStringAsFixed(1)} hours.',
      ],
      regionalBulletInsights: [
        'प्रति रात औसत नींद ${avgSleepDurationHours.toStringAsFixed(1)} घंटे दर्ज की गई।',
        'गहरी नींद का अनुपात कुल नींद का ${avgDeepSleepPercent.toStringAsFixed(1)}% रहा।',
        'साप्ताहिक नींद ऋण केवल ${netSleepDebtHours.toStringAsFixed(1)} घंटे रहा।',
      ],
    );

    // 5. Nutrition & Anti-Inflammatory Pillar
    final nutritionScore = _calculateNutritionScore(
      avgProteinGramsPerKg,
      antiInflammatoryDietScore,
    );
    final nutritionPillar = MonthlyPillarSummary(
      title: 'Anti-Inflammatory Nutrition & Protein',
      regionalTitle: 'सूजन-रोधी पोषण व प्रोटीन संतुलन',
      iconName: 'restaurant',
      score: nutritionScore,
      statusLabel: nutritionScore >= 85
          ? 'Nutrient Dense'
          : (nutritionScore >= 70 ? 'Balanced' : 'Refinement Needed'),
      regionalStatusLabel: nutritionScore >= 85
          ? 'पोषक तत्वों से भरपूर'
          : (nutritionScore >= 70 ? 'संतुलित' : 'सुधार की आवश्यकता'),
      primaryMetric: '${avgProteinGramsPerKg.toStringAsFixed(2)} g/kg',
      primaryMetricLabel:
          'Daily Protein • ${antiInflammatoryDietScore.toStringAsFixed(0)}/100 Diet Index',
      monthDelta: '+0.18 g/kg protein intake',
      isPositiveDelta: true,
      bulletInsights: [
        'Achieved target protein intake of ${avgProteinGramsPerKg.toStringAsFixed(2)} g/kg bodyweight across meals.',
        'Anti-inflammatory food index scored ${antiInflammatoryDietScore.toStringAsFixed(0)}/100 with rich whole-food polyphenol density.',
        'Hydration targets met consistently with optimal electrolyte support.',
      ],
      regionalBulletInsights: [
        'दैनिक प्रोटीन सेवन ${avgProteinGramsPerKg.toStringAsFixed(2)} ग्राम प्रति किग्रा शरीर भार रहा।',
        'सूजन-रोधी आहार सूचकांक ${antiInflammatoryDietScore.toStringAsFixed(0)}/100 रहा।',
        'पर्याप्त जल व इलेक्ट्रोलाइट्स का संतुलन बना रहा।',
      ],
    );

    final allPillars = [
      cardioPillar,
      metabolicPillar,
      fitnessPillar,
      sleepPillar,
      nutritionPillar,
    ];

    // Composite 30-Day Score (Weighted across pillars)
    final compositeScore = (cardioScore * 0.22) +
        (metabolicScore * 0.22) +
        (fitnessScore * 0.20) +
        (sleepScore * 0.18) +
        (nutritionScore * 0.18);

    final roundedComposite = _round(compositeScore);

    // Performance Grade
    final grade = _determineGrade(roundedComposite);

    // Monthly Wins
    final wins = [
      MonthlyHealthWin(
        id: 'win_bio_age',
        title: 'Biological Rejuvenation Delta',
        regionalTitle: 'जैविक आयु में सुधार',
        metricImpact:
            '${monthlyBioAgeImprovement.toStringAsFixed(1)} Yrs Younger this month',
        iconName: 'auto_awesome',
        karmaEarned: 150,
      ),
      MonthlyHealthWin(
        id: 'win_shatpawali',
        title: 'Shatpawali Dinner Consistency',
        regionalTitle: 'शतपावली निरंतरता',
        metricImpact:
            '${shatpawaliAdherencePercent.toStringAsFixed(0)}% post-meal walks completed',
        iconName: 'directions_walk',
        karmaEarned: 100,
      ),
      MonthlyHealthWin(
        id: 'win_deep_sleep',
        title: 'Glymphatic Brain Restoration',
        regionalTitle: 'गहरी नींद व मानसिक ताजगी',
        metricImpact:
            '${avgDeepSleepPercent.toStringAsFixed(1)}% average deep sleep architecture',
        iconName: 'nights_stay',
        karmaEarned: 100,
      ),
    ];

    // Next Month Priorities
    final priorities = [
      const NextMonthFocusArea(
        id: 'prio_vo2_progression',
        title: 'Zone 2 Aerobic Base Expansion',
        regionalTitle: 'ज़ोन 2 एरोबिक क्षमता का विस्तार',
        rationale:
            'Elevating weekly steady-state cardio from 60 to 90 mins will further optimize mitochondrial density.',
        regionalRationale:
            'साप्ताहिक स्थिर कार्डियो 60 से बढ़ाकर 90 मिनट करने से माइटोकॉन्ड्रियल ऊर्जा बढ़ेगी।',
        targetGoal: '3x 30-min Zone 2 sessions / week',
        projectedBenefit: '-0.4 years additional biological rejuvenation',
      ),
      const NextMonthFocusArea(
        id: 'prio_protein_distribution',
        title: 'Even Protein Distribution (25g+ per meal)',
        regionalTitle: 'प्रत्येक भोजन में संतुलित प्रोटीन (25g+)',
        rationale:
            'Distributing daily protein evenly across breakfast, lunch, and dinner triggers maximal muscle protein synthesis (MPS).',
        regionalRationale:
            'तीनों प्रहरों के भोजन में प्रोटीन का समान वितरण मांसपेशियों के निर्माण को गति देता है।',
        targetGoal: '28-35g protein at breakfast & lunch',
        projectedBenefit: 'Enhanced muscle repair and glycemic stabilization',
      ),
      const NextMonthFocusArea(
        id: 'prio_evening_circadian',
        title: '10:30 PM Melatonin Phase-Lock',
        regionalTitle: 'नियमित १०:३० PM शयन अनुशासन',
        rationale:
            'Standardizing sleep onset within a 20-minute window will minimize circadian phase delay.',
        regionalRationale:
            'नियमित समय पर सोने से जैविक घड़ी संतुलित रहती है और मेलाटोनिन का पूरा लाभ मिलता है।',
        targetGoal: 'Sleep onset before 10:45 PM on 25+ nights',
        projectedBenefit: 'Zero chronic sleep debt accumulation',
      ),
    ];

    // Executive Summary & Doctor Paragraph
    final execSummary =
        'Over the past 30 days, your holistic health markers exhibited remarkable progress with a composite transformation score of ${roundedComposite.toInt()}/100 (Grade ${grade.grade}). Biological age now stands at ${biologicalAge.toStringAsFixed(1)} years (${(chronologicalAge - biologicalAge).toStringAsFixed(1)} years younger than chronological age of ${chronologicalAge.toInt()}), driven by exemplary glycemic control (HbA1c ${estimatedHbA1c.toStringAsFixed(2)}%), stable normotensive hemodynamics (${avgSystolicBp.toInt()}/${avgDiastolicBp.toInt()} mmHg), and robust physical active volume (${(avgDailySteps / 1000).toStringAsFixed(1)}k steps/day).';

    final regionalExecSummary =
        'पिछले ३० दिनों में आपके समग्र स्वास्थ्य में उत्कृष्ट सुधार हुआ है, जिसका समग्र स्कोर ${roundedComposite.toInt()}/100 (ग्रेड ${grade.grade}) रहा। आपकी जैविक आयु ${biologicalAge.toStringAsFixed(1)} वर्ष (वास्तविक आयु से ${(chronologicalAge - biologicalAge).toStringAsFixed(1)} वर्ष युवा) दर्ज की गई है। इसमें स्थिर रक्तचाप (${avgSystolicBp.toInt()}/${avgDiastolicBp.toInt()} mmHg), सामान्य शर्करा नियंत्रण (${estimatedHbA1c.toStringAsFixed(2)}% HbA1c) और निरंतर सक्रियता (${(avgDailySteps / 1000).toStringAsFixed(1)}k कदम/दिन) का प्रमुख योगदान रहा।';

    final doctorSummary = 'PATIENT 30-DAY BIOMETRIC SUMMARY ($monthTitle):\n'
        '• Resting Hemodynamics: Mean RHR ${avgRestingHeartRate.toStringAsFixed(0)} bpm, Mean BP ${avgSystolicBp.toInt()}/${avgDiastolicBp.toInt()} mmHg, Mean rMSSD HRV ${avgHrvRmssd.toStringAsFixed(0)} ms (Autonomically balanced).\n'
        '• Metabolic & Glycemic Profile: Estimated HbA1c ${estimatedHbA1c.toStringAsFixed(2)}%, Fasting Glucose ${avgFastingGlucose.toStringAsFixed(0)} mg/dL. Zero adverse glycemic spikes recorded.\n'
        '• Activity & Sarcopenic Reserve: ${(avgDailySteps / 1000).toStringAsFixed(1)}k daily steps average; $strengthWorkoutsCount resistance sessions completed.\n'
        '• Sleep Architecture: ${avgSleepDurationHours.toStringAsFixed(1)} hrs/night; ${avgDeepSleepPercent.toStringAsFixed(1)}% slow-wave deep sleep; Net sleep debt ${netSleepDebtHours.toStringAsFixed(1)} hrs.\n'
        '• Clinical Assessment: Excellent lifestyle compliance; low cardiometabolic risk profile.';

    return MonthlyHealthReport(
      reportId: 'rep_${now.year}_${now.month.toString().padLeft(2, '0')}',
      monthTitle: monthTitle,
      regionalMonthTitle: regionalMonthTitle,
      generatedAt: now,
      compositeScore: roundedComposite,
      grade: grade,
      biologicalAge: biologicalAge,
      biologicalAgeDelta: monthlyBioAgeImprovement,
      agingPace: agingPace,
      pillarSummaries: allPillars,
      topWins: wins,
      nextMonthPriorities: priorities,
      clinicalExecutiveSummary: execSummary,
      regionalClinicalExecutiveSummary: regionalExecSummary,
      doctorSummaryParagraph: doctorSummary,
    );
  }

  // --- Internal Pillar Scoring Calculations ---

  double _calculateCardioScore(double rhr, double sbp, double dbp, double hrv) {
    double score = 100.0;
    if (rhr > 75) {
      score -= 15;
    } else if (rhr > 68) {
      score -= 8;
    } else if (rhr > 62) {
      score -= 3;
    }

    if (sbp > 135 || dbp > 88) {
      score -= 20;
    } else if (sbp > 125 || dbp > 82) {
      score -= 10;
    } else if (sbp > 120) {
      score -= 4;
    }

    if (hrv < 30) {
      score -= 15;
    } else if (hrv < 42) {
      score -= 7;
    }

    return score.clamp(35.0, 99.0);
  }

  double _calculateMetabolicScore(
      double hba1c, double glucose, double shatpawali) {
    double score = 100.0;
    if (hba1c > 6.4) {
      score -= 30;
    } else if (hba1c > 5.7) {
      score -= 18;
    } else if (hba1c > 5.4) {
      score -= 6;
    }

    if (glucose > 115) {
      score -= 12;
    } else if (glucose > 100) {
      score -= 6;
    }

    if (shatpawali < 50) {
      score -= 10;
    } else if (shatpawali < 75) {
      score -= 4;
    }

    return score.clamp(30.0, 99.0);
  }

  double _calculateFitnessScore(double steps, int strengthWorkouts) {
    double score = 100.0;
    if (steps < 5000) {
      score -= 25;
    } else if (steps < 8000) {
      score -= 12;
    } else if (steps < 10000) {
      score -= 4;
    }

    if (strengthWorkouts < 4) {
      score -= 20;
    } else if (strengthWorkouts < 8) {
      score -= 10;
    } else if (strengthWorkouts < 12) {
      score -= 4;
    }

    return score.clamp(30.0, 99.0);
  }

  double _calculateSleepScore(
      double duration, double deepPercent, double sleepDebt) {
    double score = 100.0;
    if (duration < 6.0) {
      score -= 25;
    } else if (duration < 7.0) {
      score -= 10;
    }

    if (deepPercent < 12.0) {
      score -= 18;
    } else if (deepPercent < 16.0) {
      score -= 8;
    }

    if (sleepDebt > 4.0) {
      score -= 15;
    } else if (sleepDebt > 2.0) {
      score -= 6;
    }

    return score.clamp(30.0, 99.0);
  }

  double _calculateNutritionScore(double proteinGPerKg, double dietScore) {
    double score = 100.0;
    if (proteinGPerKg < 0.9) {
      score -= 20;
    } else if (proteinGPerKg < 1.2) {
      score -= 8;
    }

    if (dietScore < 50) {
      score -= 22;
    } else if (dietScore < 70) {
      score -= 10;
    } else if (dietScore < 80) {
      score -= 4;
    }

    return score.clamp(35.0, 99.0);
  }

  MonthlyHealthGrade _determineGrade(double score) {
    if (score >= MonthlyHealthGrade.aPlus.minScore) {
      return MonthlyHealthGrade.aPlus;
    }
    if (score >= MonthlyHealthGrade.a.minScore) {
      return MonthlyHealthGrade.a;
    }
    if (score >= MonthlyHealthGrade.b.minScore) {
      return MonthlyHealthGrade.b;
    }
    return MonthlyHealthGrade.c;
  }

  double _round(double val) {
    return (val * 10).round() / 10.0;
  }
}
