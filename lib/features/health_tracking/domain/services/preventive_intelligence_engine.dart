import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum BPCategory {
  normal,
  elevated,
  stage1Hypertension,
  stage2Hypertension,
  crisis,
}

class BPStagingResult {
  final BPCategory category;
  final String label;
  final String labelHindi;
  final Color color;
  final int pulsePressure;
  final String clinicalInsight;

  const BPStagingResult({
    required this.category,
    required this.label,
    required this.labelHindi,
    required this.color,
    required this.pulsePressure,
    required this.clinicalInsight,
  });
}

class HbA1cEstimate {
  final double estimatedHbA1c;
  final String glycemicCategory; // 'Normal (<5.7%)', 'Prediabetic (5.7-6.4%)', 'Diabetic (>=6.5%)'
  final Color color;
  final String insight;

  const HbA1cEstimate({
    required this.estimatedHbA1c,
    required this.glycemicCategory,
    required this.color,
    required this.insight,
  });
}

class ThinFatRiskAssessment {
  final bool isAtRisk;
  final double riskScore; // 0 - 100
  final String summary;
  final String summaryHindi;
  final List<String> mitigationActions;

  const ThinFatRiskAssessment({
    required this.isAtRisk,
    required this.riskScore,
    required this.summary,
    required this.summaryHindi,
    required this.mitigationActions,
  });
}

/// PreventiveIntelligenceEngine — Pure Dart / Deterministic Clinical Risk Evaluator
class PreventiveIntelligenceEngine {
  const PreventiveIntelligenceEngine();

  /// Estimate HbA1c percentage from average blood glucose using the ADAG formula
  HbA1cEstimate estimateHbA1c(double meanGlucoseMgDl) {
    // ADAG: HbA1c (%) = (mean glucose in mg/dL + 46.7) / 28.7
    final hba1c = (meanGlucoseMgDl + 46.7) / 28.7;
    final rounded = double.parse(hba1c.toStringAsFixed(1));

    String category;
    Color color;
    String insight;

    if (rounded < 5.7) {
      category = 'Optimal (<5.7%)';
      color = AppColors.primaryEmerald;
      insight = 'Healthy glycemic control. Low risk of diabetic retinopathy or nephropathy.';
    } else if (rounded <= 6.4) {
      category = 'Prediabetes Range (5.7%–6.4%)';
      color = AppColors.accentAmber;
      insight = 'Elevated insulin resistance. Prioritize post-meal 15-min walks and low-GI Indian grains (Ragi, Jowar).';
    } else {
      category = 'Elevated Risk (≥6.5%)';
      color = AppColors.accentCoral;
      insight = 'Sustained hyperglycemia indicated. Consult a physician and monitor glycemic excursions.';
    }

    return HbA1cEstimate(
      estimatedHbA1c: rounded,
      glycemicCategory: category,
      color: color,
      insight: insight,
    );
  }

  /// Classify Blood Pressure using AHA & Indian Consensus Guidelines
  BPStagingResult classifyBloodPressure({
    required int systolicMmHg,
    required int diastolicMmHg,
  }) {
    final pulsePressure = systolicMmHg - diastolicMmHg;

    if (systolicMmHg > 180 || diastolicMmHg > 120) {
      return BPStagingResult(
        category: BPCategory.crisis,
        label: 'Hypertensive Crisis',
        labelHindi: 'अत्यधिक उच्च रक्तचाप (आपातकालीन)',
        color: AppColors.accentCoral,
        pulsePressure: pulsePressure,
        clinicalInsight: 'Immediate clinical evaluation recommended. Rest quietly and recheck.',
      );
    }

    if (systolicMmHg >= 140 || diastolicMmHg >= 90) {
      return BPStagingResult(
        category: BPCategory.stage2Hypertension,
        label: 'Stage 2 Hypertension',
        labelHindi: 'उच्च रक्तचाप (श्रेणी २)',
        color: AppColors.accentCoral,
        pulsePressure: pulsePressure,
        clinicalInsight: 'Arterial resistance is high. Limit sodium, practice Pranayama, and consult a doctor.',
      );
    }

    if ((systolicMmHg >= 130 && systolicMmHg <= 139) || (diastolicMmHg >= 80 && diastolicMmHg <= 89)) {
      return BPStagingResult(
        category: BPCategory.stage1Hypertension,
        label: 'Stage 1 Hypertension',
        labelHindi: 'उच्च रक्तचाप (श्रेणी १)',
        color: AppColors.accentAmber,
        pulsePressure: pulsePressure,
        clinicalInsight: 'Early vascular tension. Focus on potassium-rich foods (coconut water, spinach) and Zone 2 cardio.',
      );
    }

    if (systolicMmHg >= 120 && systolicMmHg <= 129 && diastolicMmHg < 80) {
      return BPStagingResult(
        category: BPCategory.elevated,
        label: 'Elevated BP',
        labelHindi: 'हल्का बढ़ा हुआ रक्तचाप',
        color: AppColors.accentAmber,
        pulsePressure: pulsePressure,
        clinicalInsight: 'Borderline elevation. Stress reduction and sleep hygiene advised.',
      );
    }

    return BPStagingResult(
      category: BPCategory.normal,
      label: 'Optimal Blood Pressure',
      labelHindi: 'आदर्श रक्तचाप',
      color: AppColors.primaryEmerald,
      pulsePressure: pulsePressure,
      clinicalInsight: 'Healthy cardiovascular pressure and arterial compliance.',
    );
  }

  /// Assess Asian-Indian Thin-Fat Phenotype Risk (normal BMI + elevated metabolic markers)
  ThinFatRiskAssessment evaluateThinFatPhenotype({
    required double bmi,
    required double? fastingGlucoseMgDl,
    required int? systolicBp,
    required int? restingHeartRate,
  }) {
    // Thin-Fat phenotype occurs in BMI 18.5 - 22.9 with hidden visceral fat
    bool isNormalBmi = (bmi >= 18.5 && bmi <= 22.9);
    int riskFlags = 0;

    if (fastingGlucoseMgDl != null && fastingGlucoseMgDl >= 100.0) riskFlags += 2;
    if (systolicBp != null && systolicBp >= 125) riskFlags += 1;
    if (restingHeartRate != null && restingHeartRate >= 75) riskFlags += 1;

    final double riskScore = (riskFlags / 4.0 * 100.0).clamp(0.0, 100.0);
    final bool atRisk = isNormalBmi && riskFlags >= 2;

    String summary = 'Low visceral adiposity risk. Metabolic indicators are optimal.';
    String summaryHindi = 'मेटाबॉलिक स्वास्थ्य आदर्श स्तर पर है।';
    List<String> actions = ['Maintain regular resistance training.', 'Keep refined sugar intake minimal.'];

    if (atRisk) {
      summary = 'Thin-Fat Phenotype Risk Detected: Normal body weight but elevated glycemic/vascular tension.';
      summaryHindi = 'थिन-फैट फेनोटाइप का जोखिम: सामान्य वज़न के बावजूद आंतरिक चर्बी और इंसुलिन प्रतिरोध के संकेत।';
      actions = [
        'Prioritize progressive overload resistance training to build active skeletal muscle mass.',
        'Replace white rice and refined wheat with whole millets (Ragi, Bajra, Jowar).',
        'Incorporate 15 minutes of post-meal brisk walking (Shatapadi).',
      ];
    }

    return ThinFatRiskAssessment(
      isAtRisk: atRisk,
      riskScore: riskScore,
      summary: summary,
      summaryHindi: summaryHindi,
      mitigationActions: actions,
    );
  }
}
