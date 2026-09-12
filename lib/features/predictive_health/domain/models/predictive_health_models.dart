enum CardioRiskLevel {
  low,
  moderate,
  elevated,
  high,
}

enum AcwrStatus {
  underloading, // < 0.8
  sweetSpot, // 0.8 - 1.3 (optimal fitness stimulus, lowest injury risk)
  warning, // 1.3 - 1.5
  dangerZone, // > 1.5 (injury hazard)
}

enum StressLevel {
  restored,
  mild,
  moderate,
  high,
}

enum LabMarkerStatus {
  optimal,
  borderline,
  abnormal,
  critical,
}

class BiologicalAgeEstimate {
  final String id;
  final String userId;
  final int chronologicalAge;
  final double biologicalAge;
  final double ageDelta; // biologicalAge - chronologicalAge
  final double confidenceScore;
  final List<BiomarkerContributor> contributors;
  final String topImprovementAction;
  final String topImprovementActionHindi;
  final DateTime calculatedAt;

  const BiologicalAgeEstimate({
    required this.id,
    required this.userId,
    required this.chronologicalAge,
    required this.biologicalAge,
    required this.ageDelta,
    required this.confidenceScore,
    required this.contributors,
    required this.topImprovementAction,
    required this.topImprovementActionHindi,
    required this.calculatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'chronological_age': chronologicalAge,
        'biological_age': biologicalAge,
        'age_delta': ageDelta,
        'confidence_score': confidenceScore,
        'top_improvement_action': topImprovementAction,
        'top_improvement_action_hindi': topImprovementActionHindi,
        'calculated_at': calculatedAt.toIso8601String(),
      };
}

class BiomarkerContributor {
  final String markerName;
  final String markerNameHindi;
  final double impactYears; // +2.1 years or -1.5 years
  final String status;
  final bool isProtective;

  const BiomarkerContributor({
    required this.markerName,
    required this.markerNameHindi,
    required this.impactYears,
    required this.status,
    required this.isProtective,
  });
}

class HealthRiskProfile {
  final CardioRiskLevel cardioRisk;
  final double tenYearCardioRiskPercent;
  final bool metabolicSyndromeFlag;
  final int metSynCriteriaMetCount; // Out of 5
  final double prediabetesRiskScore; // 0-100
  final List<String> primaryRiskFactors;
  final List<String> primaryRiskFactorsHindi;

  const HealthRiskProfile({
    required this.cardioRisk,
    required this.tenYearCardioRiskPercent,
    required this.metabolicSyndromeFlag,
    required this.metSynCriteriaMetCount,
    required this.prediabetesRiskScore,
    required this.primaryRiskFactors,
    required this.primaryRiskFactorsHindi,
  });
}

class InjuryRiskAssessment {
  final double acwr; // Acute to Chronic Workload Ratio
  final AcwrStatus status;
  final double acuteLoadKg;
  final double chronicLoadKg;
  final String recommendation;
  final String recommendationHindi;

  const InjuryRiskAssessment({
    required this.acwr,
    required this.status,
    required this.acuteLoadKg,
    required this.chronicLoadKg,
    required this.recommendation,
    required this.recommendationHindi,
  });
}

class StressIndex {
  final double score; // 0-100
  final StressLevel level;
  final double nocturnalHrvMs;
  final double restingHrBpm;
  final double baselineHrvMs;
  final String recoveryGuidance;
  final String recoveryGuidanceHindi;

  const StressIndex({
    required this.score,
    required this.level,
    required this.nocturnalHrvMs,
    required this.restingHrBpm,
    required this.baselineHrvMs,
    required this.recoveryGuidance,
    required this.recoveryGuidanceHindi,
  });
}

class LabBiomarkerResult {
  final String markerKey;
  final String name;
  final String nameHindi;
  final double value;
  final String unit;
  final double referenceMin;
  final double referenceMax;
  final LabMarkerStatus status;
  final String interpretation;
  final String interpretationHindi;

  const LabBiomarkerResult({
    required this.markerKey,
    required this.name,
    required this.nameHindi,
    required this.value,
    required this.unit,
    required this.referenceMin,
    required this.referenceMax,
    required this.status,
    required this.interpretation,
    required this.interpretationHindi,
  });

  Map<String, dynamic> toJson() => {
        'marker_key': markerKey,
        'name': name,
        'name_hindi': nameHindi,
        'value': value,
        'unit': unit,
        'reference_min': referenceMin,
        'reference_max': referenceMax,
        'status': status.name,
        'interpretation': interpretation,
        'interpretation_hindi': interpretationHindi,
      };
}

class ClinicalLabReport {
  final String id;
  final String userId;
  final String labName;
  final DateTime testDate;
  final List<LabBiomarkerResult> results;
  final String executiveSummary;
  final String executiveSummaryHindi;
  final DateTime uploadedAt;

  const ClinicalLabReport({
    required this.id,
    required this.userId,
    required this.labName,
    required this.testDate,
    required this.results,
    required this.executiveSummary,
    required this.executiveSummaryHindi,
    required this.uploadedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'lab_name': labName,
        'test_date': testDate.toIso8601String(),
        'results': results.map((r) => r.toJson()).toList(),
        'executive_summary': executiveSummary,
        'executive_summary_hindi': executiveSummaryHindi,
        'uploaded_at': uploadedAt.toIso8601String(),
      };
}

class MedicationSchedule {
  final String id;
  final String userId;
  final String medicationName;
  final String dosage;
  final String frequency; // e.g. "Once daily", "Twice daily with meals"
  final String timingCategory; // Morning, Lunch, Dinner, Bedtime
  final String? foodInteractionWarning;
  final String? foodInteractionWarningHindi;
  final bool isTakenToday;

  const MedicationSchedule({
    required this.id,
    required this.userId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.timingCategory,
    this.foodInteractionWarning,
    this.foodInteractionWarningHindi,
    this.isTakenToday = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'medication_name': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'timing_category': timingCategory,
        'food_interaction_warning': foodInteractionWarning,
        'food_interaction_warning_hindi': foodInteractionWarningHindi,
        'is_taken_today': isTakenToday,
      };
}

class DoctorAccessGrant {
  final String id;
  final String userId;
  final String doctorName;
  final String clinicHospital;
  final String accessPin;
  final DateTime expiresAt;
  final bool isActive;

  const DoctorAccessGrant({
    required this.id,
    required this.userId,
    required this.doctorName,
    required this.clinicHospital,
    required this.accessPin,
    required this.expiresAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'doctor_name': doctorName,
        'clinic_hospital': clinicHospital,
        'access_pin': accessPin,
        'expires_at': expiresAt.toIso8601String(),
        'is_active': isActive,
      };
}

class LongevityScore {
  final int overallScore; // 0-100
  final int cardiovascularPillar; // 0-100
  final int metabolicPillar; // 0-100
  final int sleepCircadianPillar; // 0-100
  final int physicalCapacityPillar; // 0-100
  final int autonomicRecoveryPillar; // 0-100
  final String tierTitle;
  final String tierTitleHindi;

  const LongevityScore({
    required this.overallScore,
    required this.cardiovascularPillar,
    required this.metabolicPillar,
    required this.sleepCircadianPillar,
    required this.physicalCapacityPillar,
    required this.autonomicRecoveryPillar,
    required this.tierTitle,
    required this.tierTitleHindi,
  });
}
