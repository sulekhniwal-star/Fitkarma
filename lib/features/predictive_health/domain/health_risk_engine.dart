import 'health_risk_models.dart';

/// Pure Dart Deterministic Engine for South Asian Health Risk Stratification,
/// Indian Diabetes Risk Score (IDRS), Cardiometabolic Index, and Preventive Protocols.
class HealthRiskEngine {
  const HealthRiskEngine._();

  /// Calculates Indian Diabetes Risk Score (IDRS / MDRF)
  static double calculateIdrsScore({
    required int age,
    required double waistCircumferenceCm,
    required String biologicalSex,
    required int dailySteps,
    required bool hasFamilyHistoryDiabetes,
  }) {
    double score = 0.0;

    // 1. Age Factor
    if (age >= 50) {
      score += 30.0;
    } else if (age >= 35) {
      score += 20.0;
    } else {
      score += 0.0;
    }

    // 2. Abdominal Obesity (Waist Circumference)
    final isMale = biologicalSex.toLowerCase() != 'female';
    if (isMale) {
      if (waistCircumferenceCm >= 90.0) {
        score += 20.0;
      } else if (waistCircumferenceCm >= 85.0) {
        score += 10.0;
      }
    } else {
      if (waistCircumferenceCm >= 90.0) {
        score += 20.0;
      } else if (waistCircumferenceCm >= 80.0) {
        score += 10.0;
      }
    }

    // 3. Physical Activity Level (Daily Steps & Exercise)
    if (dailySteps >= 10000) {
      score += 0.0;
    } else if (dailySteps >= 7000) {
      score += 10.0;
    } else if (dailySteps >= 4000) {
      score += 20.0;
    } else {
      score += 30.0;
    }

    // 4. Family History
    if (hasFamilyHistoryDiabetes) {
      score += 20.0;
    }

    return score.clamp(0.0, 100.0);
  }

  /// Evaluates the complete health risk report
  static HealthRiskPreventionReport evaluateRiskProfile({
    required int age,
    required String biologicalSex,
    required double bodyweightKg,
    required double waistCircumferenceCm,
    required double heightCm,
    required int systolicBp,
    required int diastolicBp,
    required double estimatedFastingGlucoseMgDl,
    required double restingHeartRateBpm,
    required int dailySteps,
    required bool completedShatpawaliPercent,
    required double relativeStrengthXBW,
    required double proteinGramsPerKg,
    required bool hasFamilyHistoryDiabetes,
  }) {
    final whtr = heightCm > 0 ? waistCircumferenceCm / heightCm : 0.50;

    // 1. Cardiometabolic Domain Risk Score
    double cmrScore = 0.0;
    if (whtr >= 0.53) {
      cmrScore += 45.0;
    } else if (whtr >= 0.49) {
      cmrScore += 25.0;
    } else {
      cmrScore += 5.0;
    }

    if (systolicBp >= 140 || diastolicBp >= 90) {
      cmrScore += 45.0;
    } else if (systolicBp >= 125 || diastolicBp >= 82) {
      cmrScore += 25.0;
    } else {
      cmrScore += 5.0;
    }
    final finalCmrScore = cmrScore.clamp(0.0, 100.0);

    // 2. IDRS Diabetes Risk Score
    final idrsScore = calculateIdrsScore(
      age: age,
      waistCircumferenceCm: waistCircumferenceCm,
      biologicalSex: biologicalSex,
      dailySteps: dailySteps,
      hasFamilyHistoryDiabetes: hasFamilyHistoryDiabetes,
    );

    // 3. Autonomic Vagal Risk Score
    double autonomicScore = 0.0;
    if (restingHeartRateBpm >= 82.0) {
      autonomicScore += 65.0;
    } else if (restingHeartRateBpm >= 72.0) {
      autonomicScore += 35.0;
    } else {
      autonomicScore += 10.0;
    }

    // 4. Sarcopenic Strength Deficit Risk Score
    double sarcopeniaScore = 0.0;
    if (relativeStrengthXBW < 0.90 || proteinGramsPerKg < 0.80) {
      sarcopeniaScore += 60.0;
    } else if (relativeStrengthXBW < 1.30 || proteinGramsPerKg < 1.20) {
      sarcopeniaScore += 30.0;
    } else {
      sarcopeniaScore += 10.0;
    }

    // 5. Circadian & Digestive Strain Score
    double circadianScore = 0.0;
    if (!completedShatpawaliPercent) {
      circadianScore += 45.0;
    } else {
      circadianScore += 10.0;
    }
    if (dailySteps < 6000) {
      circadianScore += 35.0;
    }

    // Composite Weighted Risk Calculation
    final compositeRisk = (finalCmrScore * 0.30) +
        (idrsScore * 0.25) +
        (autonomicScore * 0.20) +
        (sarcopeniaScore * 0.15) +
        (circadianScore * 0.10);

    final overallTier = compositeRisk >= 60.0
        ? ClinicalRiskTier.elevated
        : compositeRisk >= 25.0
            ? ClinicalRiskTier.moderate
            : ClinicalRiskTier.low;

    // Evaluate Risk Factors
    final factors = [
      ClinicalRiskFactor(
        id: 'factor_whtr',
        domain: RiskDomainType.cardiometabolic,
        name: 'Waist-to-Height Ratio (WHtR)',
        regionalName: 'कमर-ऊंचाई अनुपात (WHtR)',
        measuredValue: whtr,
        unit: 'ratio',
        optimalThreshold: 0.48,
        clinicalRiskThreshold: 0.50,
        riskScore: finalCmrScore,
        tier: whtr >= 0.50 ? ClinicalRiskTier.moderate : ClinicalRiskTier.low,
        clinicalRationale: 'South Asian cardiometabolic consensus designates WHtR >= 0.50 as the critical threshold for visceral adiposity.',
        regionalClinicalRationale: 'भारतीय स्वास्थ्य मानकों के अनुसार ०.५० से अधिक WHtR आंतरिक चर्बी के जोखिम को दर्शाता है।',
      ),
      ClinicalRiskFactor(
        id: 'factor_idrs',
        domain: RiskDomainType.glycemicDiabetes,
        name: 'Indian Diabetes Risk Score (IDRS)',
        regionalName: 'भारतीय मधुमेह जोखिम सूचकांक (IDRS)',
        measuredValue: idrsScore,
        unit: '/100',
        optimalThreshold: 30.0,
        clinicalRiskThreshold: 60.0,
        riskScore: idrsScore,
        tier: idrsScore >= 60.0
            ? ClinicalRiskTier.elevated
            : idrsScore >= 30.0
                ? ClinicalRiskTier.moderate
                : ClinicalRiskTier.low,
        clinicalRationale: 'MDRF validated scoring combining age, abdominal girth, family history, and physical movement.',
        regionalClinicalRationale: 'आयु, कमर घेरा और पारिवारिक इतिहास पर आधारित प्रमाणीकृत मधुमेह जोखिम स्कोर।',
      ),
      ClinicalRiskFactor(
        id: 'factor_rhr',
        domain: RiskDomainType.autonomicVagal,
        name: 'Resting Heart Rate (RHR)',
        regionalName: 'विश्राम हृदय गति (RHR)',
        measuredValue: restingHeartRateBpm,
        unit: 'bpm',
        optimalThreshold: 60.0,
        clinicalRiskThreshold: 78.0,
        riskScore: autonomicScore,
        tier: restingHeartRateBpm >= 78.0 ? ClinicalRiskTier.moderate : ClinicalRiskTier.low,
        clinicalRationale: 'Lower RHR reflects strong parasympathetic vagal tone and optimal cardiovascular recovery.',
        regionalClinicalRationale: 'कम विश्राम हृदय गति सुदृढ़ हृदय स्वास्थ्य और स्वायत्त तंत्रिका संतुलन का प्रतीक है।',
      ),
      ClinicalRiskFactor(
        id: 'factor_sarcopenia',
        domain: RiskDomainType.sarcopenicStrength,
        name: 'Relative Strength & Protein Ratio',
        regionalName: 'सापेक्ष शक्ति व प्रोटीन स्तर',
        measuredValue: relativeStrengthXBW,
        unit: 'xBW',
        optimalThreshold: 1.40,
        clinicalRiskThreshold: 1.00,
        riskScore: sarcopeniaScore,
        tier: relativeStrengthXBW < 1.00 ? ClinicalRiskTier.moderate : ClinicalRiskTier.low,
        clinicalRationale: 'Preserving lean skeletal muscle protects against glucose intolerance and metabolic deceleration.',
        regionalClinicalRationale: 'मांसपेशी शक्ति का संरक्षण इंसुलिन संवेदनशीलता और मेटाबॉलिज्म की रक्षा करता है।',
      ),
    ];

    // Generate Targeted Protocols
    final protocols = <PreventiveProtocol>[
      const PreventiveProtocol(
        id: 'prot_shatpawali',
        targetedDomain: RiskDomainType.circadianDigestive,
        title: 'Post-Meal 100-Step Shatpawali Stroll',
        regionalTitle: 'भोजनोपरांत १०० कदम शतपावली अनुष्ठान',
        protocolDescription: 'Perform a slow 10-15 minute walk immediately after dinner. Blunts postprandial glucose excursion and aids Jatharagni.',
        regionalProtocolDescription: 'रात्रि भोजनोपरांत १०-१५ मिनट की धीमी चहलकदमी। ग्लूकोज वृद्धि को रोकती है व पाचन को सुगम बनाती है।',
        frequency: 'Twice daily after lunch & dinner',
        expectedBiometricImpact: 'Reduces postprandial glucose spike by 24-28%',
        karmaReward: 25,
      ),
      const PreventiveProtocol(
        id: 'prot_resistance',
        targetedDomain: RiskDomainType.sarcopenicStrength,
        title: 'Progressive Resistance Overload (Baithak / Barbell)',
        regionalTitle: 'देसी बैठक व शक्ति संवर्धन अभ्यास',
        protocolDescription: 'Engage major muscle groups with bodyweight squats, Baithak, and progressive resistance 3 times per week.',
        regionalProtocolDescription: 'सप्ताह में ३ दिन देसी बैठक व शक्ति व्यायाम। मांसपेशियों को ग्लूकोज अवशोषण हेतु सक्रिय करता है।',
        frequency: '3x weekly (Mon / Wed / Fri)',
        expectedBiometricImpact: 'Elevates insulin-independent glucose clearance',
        karmaReward: 40,
      ),
      const PreventiveProtocol(
        id: 'prot_pranayama',
        targetedDomain: RiskDomainType.autonomicVagal,
        title: 'Evening Nadi Shodhana & 4-7-8 Breathing',
        regionalTitle: 'संध्याकालीन नाड़ी शोधन प्राणायाम',
        protocolDescription: '10 minutes of slow alternate nostril breathing before sleep. Stimulates the vagus nerve and reduces nocturnal cortisol.',
        regionalProtocolDescription: 'सोने से पूर्व १० मिनट नाड़ी शोधन प्राणायाम। स्वायत्त तंत्रिका तंत्र को शांत कर कोर्टिसोल घटाता है।',
        frequency: 'Daily before bed',
        expectedBiometricImpact: 'Lowers resting heart rate by 4-6 BPM',
        karmaReward: 20,
      ),
    ];

    // Doctor Consultation Safeguard
    bool needsDoctor = false;
    String consultReason = '';
    String regionalConsultReason = '';

    if (systolicBp >= 140 || diastolicBp >= 90) {
      needsDoctor = true;
      consultReason = 'Blood pressure reading ($systolicBp/$diastolicBp mmHg) is in the Stage 2 Hypertension range. Please schedule an in-person clinical checkup.';
      regionalConsultReason = 'रक्तचाप ($systolicBp/$diastolicBp mmHg) उच्च सीमा में है। कृपया चिकित्सक से परामर्श लें।';
    } else if (estimatedFastingGlucoseMgDl >= 126.0) {
      needsDoctor = true;
      consultReason = 'Fasting glucose reading (${estimatedFastingGlucoseMgDl.toInt()} mg/dL) exceeds clinical fasting targets. Diagnostic lab verification is recommended.';
      regionalConsultReason = 'फास्टिंग ग्लूकोज स्तर अधिक है। प्रयोगशाला परीक्षण व डॉक्टर परामर्श आवश्यक है।';
    }

    return HealthRiskPreventionReport(
      compositeRiskScore: compositeRisk,
      overallRiskTier: overallTier,
      cardiometabolicDomainScore: finalCmrScore,
      idrsDiabetesDomainScore: idrsScore,
      autonomicDomainScore: autonomicScore,
      sarcopeniaDomainScore: sarcopeniaScore,
      circadianDomainScore: circadianScore,
      riskFactors: factors,
      activeProtocols: protocols,
      requiresDoctorConsultation: needsDoctor,
      consultationReason: consultReason,
      regionalConsultationReason: regionalConsultReason,
    );
  }
}
