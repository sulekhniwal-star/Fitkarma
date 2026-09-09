import 'package:flutter/foundation.dart';

/// Body composition classification zone
enum BodyCompositionZone {
  athleticLean(
    name: 'Athletic Lean (Optimal)',
    regionalName: 'सुदृढ़ एवं चुस्त शारीरिक गठन',
    description: 'High muscle mass, optimal visceral fat, excellent metabolic flexibility.',
  ),
  fitHealthy(
    name: 'Fit & Healthy (Balanced)',
    regionalName: 'संतुलित एवं स्वस्थ गठन (समधातु)',
    description: 'Balanced body fat percentage within ideal cardiometabolic thresholds.',
  ),
  elevatedAdiposity(
    name: 'Elevated Adiposity (Meda Excess)',
    regionalName: 'मेद धातु आधिक्य (अतिरिक्त वसा)',
    description: 'Higher waist-to-height ratio; benefit from progressive caloric deficit & resistance training.',
  ),
  sarcopenicRisk(
    name: 'Low Muscle Mass (Sarcopenic Tendency)',
    regionalName: 'मांस धातु क्षय (कम मांसपेशी घनत्व)',
    description: 'Sub-optimal lean mass; prioritizing protein intake and progressive overload.',
  );

  final String name;
  final String regionalName;
  final String description;

  const BodyCompositionZone({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// Biological Sex for anthropometric calibration
enum AnthropometricSex { male, female }

/// Circumference Measurements (cm)
@immutable
class BodyCircumferences {
  final double neckCm;
  final double chestCm;
  final double waistCm; // measured at navel
  final double hipsCm;
  final double bicepLeftCm;
  final double bicepRightCm;
  final double thighLeftCm;
  final double thighRightCm;
  final double calfLeftCm;
  final double calfRightCm;

  const BodyCircumferences({
    required this.neckCm,
    required this.chestCm,
    required this.waistCm,
    required this.hipsCm,
    required this.bicepLeftCm,
    required this.bicepRightCm,
    required this.thighLeftCm,
    required this.thighRightCm,
    required this.calfLeftCm,
    required this.calfRightCm,
  });
}

/// Ayurvedic 7 Dhatu Tissue Quality Record
@immutable
class AyurvedicDhatuProfile {
  final double rasaQualityScore; // 0-100 (Lymph / Plasma hydration)
  final double raktaQualityScore; // 0-100 (Blood vitality / Oxygenation)
  final double mamsaQualityScore; // 0-100 (Muscle density / Tone)
  final double medaQualityScore; // 0-100 (Adipose lipid balance)
  final double asthiQualityScore; // 0-100 (Bone mineral structure)
  final double majjaQualityScore; // 0-100 (Nervous system / Marrow)
  final double shukraQualityScore; // 0-100 (Vital reproductive Ojas)
  final String dominantDhatuObservation;
  final String regionalDhatuObservation;

  const AyurvedicDhatuProfile({
    required this.rasaQualityScore,
    required this.raktaQualityScore,
    required this.mamsaQualityScore,
    required this.medaQualityScore,
    required this.asthiQualityScore,
    required this.majjaQualityScore,
    required this.shukraQualityScore,
    required this.dominantDhatuObservation,
    required this.regionalDhatuObservation,
  });
}

/// Comprehensive Body Analytics Snapshot Report
@immutable
class BodyAnalyticsReport {
  final double weightKg;
  final double heightCm;
  final AnthropometricSex sex;
  final double bodyFatPercent;
  final double leanMuscleMassKg;
  final double fatMassKg;
  final double boneMassKg;
  final double totalBodyWaterPercent;
  final double basalMetabolicRateKcal;
  final int metabolicAge;
  final double visceralFatIndex; // 1 to 20
  final double waistToHipRatio;
  final double waistToHeightRatio;
  final BodyCompositionZone zone;
  final BodyCircumferences circumferences;
  final AyurvedicDhatuProfile dhatuProfile;
  final double symmetryIndexScore; // 0-100% left-to-right balance
  final String actionableBodyRecommendation;
  final String regionalBodyRecommendation;
  final DateTime recordedAt;

  const BodyAnalyticsReport({
    required this.weightKg,
    required this.heightCm,
    required this.sex,
    required this.bodyFatPercent,
    required this.leanMuscleMassKg,
    required this.fatMassKg,
    required this.boneMassKg,
    required this.totalBodyWaterPercent,
    required this.basalMetabolicRateKcal,
    required this.metabolicAge,
    required this.visceralFatIndex,
    required this.waistToHipRatio,
    required this.waistToHeightRatio,
    required this.zone,
    required this.circumferences,
    required this.dhatuProfile,
    required this.symmetryIndexScore,
    required this.actionableBodyRecommendation,
    required this.regionalBodyRecommendation,
    required this.recordedAt,
  });
}
