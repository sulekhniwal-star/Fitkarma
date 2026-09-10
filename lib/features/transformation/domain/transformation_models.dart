import 'package:flutter/foundation.dart';

/// Stage / Epoch of the athlete's long-term transformation journey
enum TransformationStage {
  arambha(
    phaseNumber: 1,
    title: 'Foundation & Reset (Arambha)',
    regionalTitle: 'आरंभ: आधारशिला एवं संतुलन',
    weekRange: 'Weeks 1–4',
    focusArea:
        'Circadian alignment, Shatpawali habit formation & baseline recovery',
    regionalFocusArea:
        'दिनचर्या संतुलन, शतपावली आदत व प्राथमिक स्वास्थ्य सुधार',
    minTransformationScore: 0.0,
  ),
  abhyasa(
    phaseNumber: 2,
    title: 'Metabolic Adaptation & Overload (Abhyasa)',
    regionalTitle: 'अभ्यास: उपापचयी अनुकूलन व शक्ति',
    weekRange: 'Weeks 5–12',
    focusArea:
        'Insulin sensitivity, visceral fat reduction & progressive overload',
    regionalFocusArea:
        'इंसुलिन संवेदनशीलता, चर्बी निवारण व निरंतर शक्ति संवर्धन',
    minTransformationScore: 35.0,
  ),
  koushalya(
    phaseNumber: 3,
    title: 'Athletic Optimization (Koushalya)',
    regionalTitle: 'कौशल: शारीरिक पुनर्गठन व क्षमता',
    weekRange: 'Weeks 13–24',
    focusArea: 'Lean muscle hypertrophy, VO2 Max elevation & Dosha equilibrium',
    regionalFocusArea: 'मांसपेशी विकास, हृदय क्षमता विस्तार व दोष संतुलन',
    minTransformationScore: 65.0,
  ),
  sthirata(
    phaseNumber: 4,
    title: 'Autonomous Mastery (Sthirata)',
    regionalTitle: 'स्थिरता: सहज जीवनशैली व आत्म-नियंत्रण',
    weekRange: 'Weeks 25+',
    focusArea:
        'Habit automaticity, biomarker stabilization & community mentorship',
    regionalFocusArea:
        'स्थायी आदतें, दीर्घकालिक बायोमार्कर स्थिरता व मार्गदर्शक भूमिका',
    minTransformationScore: 85.0,
  );

  final int phaseNumber;
  final String title;
  final String regionalTitle;
  final String weekRange;
  final String focusArea;
  final String regionalFocusArea;
  final double minTransformationScore;

  const TransformationStage({
    required this.phaseNumber,
    required this.title,
    required this.regionalTitle,
    required this.weekRange,
    required this.focusArea,
    required this.regionalFocusArea,
    required this.minTransformationScore,
  });
}

/// Individual health domain pillar within transformation
enum TransformationPillar {
  bodyComposition(
    label: 'Body Composition & WHtR',
    regionalLabel: 'शारीरिक गठन व कमर अनुपात',
    iconName: 'accessibility_new',
  ),
  cardiometabolic(
    label: 'Cardiometabolic & Vitals',
    regionalLabel: 'हृदय व चयापचय बायोमार्कर्स',
    iconName: 'favorite',
  ),
  workCapacity(
    label: 'Movement & Athletic Output',
    regionalLabel: 'गतिशीलता व व्यायाम क्षमता',
    iconName: 'fitness_center',
  ),
  ayurvedicEquilibrium(
    label: 'Dosha & Circadian Harmony',
    regionalLabel: 'दोष संतुलन व दिनचर्या',
    iconName: 'spa',
  ),
  mindsetKarma(
    label: 'Karma Velocity & Habit Identity',
    regionalLabel: 'कर्म संचय व आदत आत्मसात',
    iconName: 'psychology',
  );

  final String label;
  final String regionalLabel;
  final String iconName;

  const TransformationPillar({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
  });
}

/// Single quantitative measurement snapshot in time
@immutable
class TransformationSnapshot {
  final String id;
  final DateTime recordedAt;
  final int journeyDayNumber;

  // Anthropometrics
  final double bodyweightKg;
  final double waistCircumferenceCm;
  final double heightCm;

  // Cardiometabolic
  final double restingHeartRateBpm;
  final int systolicBp;
  final int diastolicBp;
  final double estimatedHbA1c;
  final double vo2MaxEstimate;

  // Lifestyle & Athletic
  final int averageDailySteps;
  final double weeklyStrengthVolumeKg;
  final double proteinGramsPerKg;
  final double doshaEquilibriumScore; // 0.0 to 100.0
  final int cumulativeKarmaPoints;

  // Optional Photo URL (stored securely in Firebase Storage)
  final String? frontPhotoUrl;
  final String? sidePhotoUrl;

  const TransformationSnapshot({
    required this.id,
    required this.recordedAt,
    required this.journeyDayNumber,
    required this.bodyweightKg,
    required this.waistCircumferenceCm,
    required this.heightCm,
    required this.restingHeartRateBpm,
    required this.systolicBp,
    required this.diastolicBp,
    required this.estimatedHbA1c,
    required this.vo2MaxEstimate,
    required this.averageDailySteps,
    required this.weeklyStrengthVolumeKg,
    required this.proteinGramsPerKg,
    required this.doshaEquilibriumScore,
    required this.cumulativeKarmaPoints,
    this.frontPhotoUrl,
    this.sidePhotoUrl,
  });

  /// Waist-to-Height Ratio (South Asian visceral adiposity index)
  double get waistToHeightRatio =>
      heightCm > 0 ? waistCircumferenceCm / heightCm : 0.50;

  /// Body Mass Index
  double get bmi => heightCm > 0
      ? bodyweightKg / ((heightCm / 100) * (heightCm / 100))
      : 22.0;
}

/// Comparison delta across two snapshots
@immutable
class BiometricPillarDelta {
  final TransformationPillar pillar;
  final String metricName;
  final String regionalMetricName;
  final double baselineValue;
  final double currentValue;
  final String unit;
  final bool lowerIsBetter;
  final double scoreProgressContribution; // 0 to 100 contribution

  const BiometricPillarDelta({
    required this.pillar,
    required this.metricName,
    required this.regionalMetricName,
    required this.baselineValue,
    required this.currentValue,
    required this.unit,
    this.lowerIsBetter = false,
    required this.scoreProgressContribution,
  });

  double get absoluteDelta => currentValue - baselineValue;
  double get percentageDelta =>
      baselineValue != 0 ? (absoluteDelta / baselineValue) * 100 : 0.0;
  bool get isPositiveProgress => lowerIsBetter
      ? currentValue < baselineValue
      : currentValue > baselineValue;
}

/// Milestone achieved along the transformation continuum
@immutable
class TransformationMilestone {
  final String id;
  final String title;
  final String regionalTitle;
  final String description;
  final String regionalDescription;
  final DateTime achievedAt;
  final TransformationPillar pillar;
  final int karmaBonus;
  final String badgeIcon;

  const TransformationMilestone({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.description,
    required this.regionalDescription,
    required this.achievedAt,
    required this.pillar,
    required this.karmaBonus,
    required this.badgeIcon,
  });
}

/// Projected Milestone Velocity
@immutable
class TransformationProjection {
  final String targetGoal;
  final String regionalTargetGoal;
  final double targetValue;
  final double currentValue;
  final String unit;
  final int estimatedDaysToAchievement;
  final double weeklyVelocity;
  final String confidenceRating; // "High", "Optimal", "Calibrating"

  const TransformationProjection({
    required this.targetGoal,
    required this.regionalTargetGoal,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.estimatedDaysToAchievement,
    required this.weeklyVelocity,
    required this.confidenceRating,
  });

  double get progressFraction =>
      ((currentValue) / (targetValue == 0 ? 1 : targetValue)).clamp(0.0, 1.0);
}

/// Comprehensive Transformation Journey Summary Report
@immutable
class TransformationJourneyReport {
  final TransformationStage currentStage;
  final double
      overallTransformationScore; // 0.0 to 100.0 (composite transformation index)
  final int totalJourneyDays;
  final TransformationSnapshot baselineSnapshot;
  final TransformationSnapshot currentSnapshot;
  final List<BiometricPillarDelta> pillarDeltas;
  final List<TransformationMilestone> unlockedMilestones;
  final List<TransformationProjection> activeProjections;
  final String motivationalInsight;
  final String regionalMotivationalInsight;

  const TransformationJourneyReport({
    required this.currentStage,
    required this.overallTransformationScore,
    required this.totalJourneyDays,
    required this.baselineSnapshot,
    required this.currentSnapshot,
    required this.pillarDeltas,
    required this.unlockedMilestones,
    required this.activeProjections,
    required this.motivationalInsight,
    required this.regionalMotivationalInsight,
  });
}
