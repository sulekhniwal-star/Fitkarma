import 'package:flutter/foundation.dart';

/// Clinical injury risk level
enum InjuryRiskTier {
  optimal(
    label: 'Optimal / Sweet Spot (Surakshit)',
    regionalLabel: 'सुरक्षित (अनुकूल कार्यभार)',
    colorCode: 0xFF00E676,
    description:
        'Workload progression is well-matched to muscular and connective tissue adaptation.',
    regionalDescription:
        'कार्यभार मांसपेशियों व जोड़ों की सहनक्षमता के अनुकूल है।',
  ),
  moderate(
    label: 'Moderate / Caution (Satark)',
    regionalLabel: 'सतर्क (मध्यम जोखिम)',
    colorCode: 0xFFFFB300,
    description:
        'Workload approaching upper thresholds or minor recovery deficits detected.',
    regionalDescription: 'कार्यभार या थकान का स्तर बढ़ रहा है, सावधानी आवश्यक।',
  ),
  high(
    label: 'High Risk / Danger Zone (Chintajanak)',
    regionalLabel: 'चिंताजनक (उच्च चोट जोखिम)',
    colorCode: 0xFFFF5252,
    description:
        'Acute workload spike or compounded fatigue significantly elevates injury vulnerability.',
    regionalDescription:
        'तीव्र भार वृद्धि अथवा गंभीर थकान के कारण चोट की संभावना अत्यधिक है।',
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final String description;
  final String regionalDescription;

  const InjuryRiskTier({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.description,
    required this.regionalDescription,
  });
}

/// Anatomical joint/body area assessed for musculoskeletal risk
enum AnatomicalJointArea {
  lumbarSpine(
    name: 'Lower Back & Lumbar Spine',
    regionalName: 'कमर व रीढ़ का निचला हिस्सा',
    iconName: 'accessibility_new',
  ),
  knees(
    name: 'Knee Joints & Patellofemoral',
    regionalName: 'घुटने के जोड़ व पटेला',
    iconName: 'directions_walk',
  ),
  shoulders(
    name: 'Shoulders & Rotator Cuff',
    regionalName: 'कंधे व रोटेटर कफ',
    iconName: 'fitness_center',
  ),
  hips(
    name: 'Hips & Adductor Complex',
    regionalName: 'कूल्हे व जांघ की मांसपेशियां',
    iconName: 'transfer_within_a_station',
  ),
  anklesAchilles(
    name: 'Ankles & Achilles Tendon',
    regionalName: 'टखने व अकिलीज टेंडन',
    iconName: 'do_not_step',
  );

  final String name;
  final String regionalName;
  final String iconName;

  const AnatomicalJointArea({
    required this.name,
    required this.regionalName,
    required this.iconName,
  });
}

/// Evaluated risk for a specific anatomical region
@immutable
class JointRiskAssessment {
  final AnatomicalJointArea area;
  final double riskScore; // 0 to 100
  final InjuryRiskTier tier;
  final double cumulativeLoadTonnage; // kg load in last 7 days
  final int sorenessLevel; // 0 to 10
  final String primaryRiskFactor;
  final String regionalPrimaryRiskFactor;
  final String recommendedPrehab;
  final String regionalRecommendedPrehab;

  const JointRiskAssessment({
    required this.area,
    required this.riskScore,
    required this.tier,
    required this.cumulativeLoadTonnage,
    required this.sorenessLevel,
    required this.primaryRiskFactor,
    required this.regionalPrimaryRiskFactor,
    required this.recommendedPrehab,
    required this.regionalRecommendedPrehab,
  });
}

/// Corrective prehab / load mitigation protocol
@immutable
class InjuryPreventionProtocol {
  final String id;
  final AnatomicalJointArea targetArea;
  final String title;
  final String regionalTitle;
  final String prescription;
  final String regionalPrescription;
  final String targetSetsReps;
  final int karmaReward;

  const InjuryPreventionProtocol({
    required this.id,
    required this.targetArea,
    required this.title,
    required this.regionalTitle,
    required this.prescription,
    required this.regionalPrescription,
    required this.targetSetsReps,
    required this.karmaReward,
  });
}

/// Comprehensive Injury Risk Evaluation Report
@immutable
class InjuryRiskReport {
  final double compositeRiskScore; // 0 to 100 (lower is safer)
  final InjuryRiskTier overallRiskTier;
  final double
      acuteChronicWorkloadRatio; // e.g. 1.15 (0.80 - 1.30 is sweet spot)
  final double acuteLoad7Days; // AU (Arbitrary Units / Strain-tonnage)
  final double chronicLoad28Days; // AU (4-week rolling avg)
  final double
      recoveryDeficitMultiplier; // e.g. 1.20x from sleep/HRV suppression
  final List<JointRiskAssessment> jointAssessments;
  final List<InjuryPreventionProtocol> activeProtocols;
  final bool shouldDeload;
  final String clinicalWorkloadSummary;
  final String regionalClinicalWorkloadSummary;
  final DateTime assessedAt;

  const InjuryRiskReport({
    required this.compositeRiskScore,
    required this.overallRiskTier,
    required this.acuteChronicWorkloadRatio,
    required this.acuteLoad7Days,
    required this.chronicLoad28Days,
    required this.recoveryDeficitMultiplier,
    required this.jointAssessments,
    required this.activeProtocols,
    required this.shouldDeload,
    required this.clinicalWorkloadSummary,
    required this.regionalClinicalWorkloadSummary,
    required this.assessedAt,
  });
}
