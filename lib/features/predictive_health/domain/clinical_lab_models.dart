import 'package:flutter/foundation.dart';

/// Clinical biomarker category
enum LabBiomarkerCategory {
  lipidMetabolic(
    name: 'Lipid & Glycemic Profile',
    regionalName: 'लिपिड व शर्करा संतुलन',
    iconName: 'bloodtype',
  ),
  hepaticLiver(
    name: 'Hepatic Function (Liver / LFT)',
    regionalName: 'यकृत कार्यप्रणाली (LFT)',
    iconName: 'health_and_safety',
  ),
  renalKidney(
    name: 'Renal Function & Electrolytes (KFT)',
    regionalName: 'गुर्दा कार्यप्रणाली (KFT)',
    iconName: 'opacity',
  ),
  micronutrientsEndocrine(
    name: 'Micronutrients & Endocrine (Vitamins/Thyroid)',
    regionalName: 'विटामिन्स व थायरॉयड स्तर',
    iconName: 'wb_sunny',
  ),
  hematologyCbc(
    name: 'Hematology (CBC & Inflammation)',
    regionalName: 'रक्त कणिकाएं व सूजन स्तर',
    iconName: 'biotech',
  );

  final String name;
  final String regionalName;
  final String iconName;

  const LabBiomarkerCategory({
    required this.name,
    required this.regionalName,
    required this.iconName,
  });
}

/// Clinical status of an individual parsed biomarker
enum LabBiomarkerStatus {
  optimal(
    label: 'Optimal (Surakshit)',
    regionalLabel: 'उत्कृष्ट (सुरक्षित सीमा)',
    colorCode: 0xFF00E676,
  ),
  borderline(
    label: 'Borderline (Satark)',
    regionalLabel: 'सीमांत (सावधानी आवश्यक)',
    colorCode: 0xFFFFB300,
  ),
  abnormal(
    label: 'Abnormal / Action Required',
    regionalLabel: 'असंतुलित (सक्रिय सुधार आवश्यक)',
    colorCode: 0xFFFF5252,
  ),
  critical(
    label: 'Critical Alert (Chintajanak)',
    regionalLabel: 'चिंताजनक (चिकित्सक परामर्श अनिवार्य)',
    colorCode: 0xFFD50000,
  );

  final String label;
  final String regionalLabel;
  final int colorCode;

  const LabBiomarkerStatus({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
  });
}

/// Parsed individual laboratory biomarker result
@immutable
class ParsedLabBiomarker {
  final String code; // e.g. "HBA1C", "LIPID_TG", "VIT_D3"
  final String name;
  final String regionalName;
  final LabBiomarkerCategory category;
  final double measuredValue;
  final String unit;
  final double referenceMin;
  final double referenceMax;
  final double optimalMin;
  final double optimalMax;
  final LabBiomarkerStatus status;
  final String clinicalInterpretation;
  final String regionalClinicalInterpretation;
  final String lifestylePrescription;
  final String regionalLifestylePrescription;

  const ParsedLabBiomarker({
    required this.code,
    required this.name,
    required this.regionalName,
    required this.category,
    required this.measuredValue,
    required this.unit,
    required this.referenceMin,
    required this.referenceMax,
    required this.optimalMin,
    required this.optimalMax,
    required this.status,
    required this.clinicalInterpretation,
    required this.regionalClinicalInterpretation,
    required this.lifestylePrescription,
    required this.regionalLifestylePrescription,
  });
}

/// Category summary of evaluated clinical panel
@immutable
class LabPanelSummary {
  final LabBiomarkerCategory category;
  final double healthScore; // 0 to 100
  final int totalBiomarkers;
  final int optimalCount;
  final int abnormalCount;
  final String keyObservation;
  final String regionalKeyObservation;

  const LabPanelSummary({
    required this.category,
    required this.healthScore,
    required this.totalBiomarkers,
    required this.optimalCount,
    required this.abnormalCount,
    required this.keyObservation,
    required this.regionalKeyObservation,
  });
}

/// Actionable non-pharmaceutical lab improvement protocol
@immutable
class LabOptimizationProtocol {
  final String id;
  final String title;
  final String regionalTitle;
  final String targetBiomarker;
  final String actionPlan;
  final String regionalActionPlan;
  final String expectedChange;
  final int karmaReward;

  const LabOptimizationProtocol({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.targetBiomarker,
    required this.actionPlan,
    required this.regionalActionPlan,
    required this.expectedChange,
    required this.karmaReward,
  });
}

/// Comprehensive Parsed Lab Report Intelligence Model
@immutable
class ClinicalReportIntelligence {
  final String reportId;
  final String labProviderName; // e.g. "Dr. Lal PathLabs", "Thyrocare"
  final DateTime testDate;
  final double overallMetabolicGradeScore; // 0 to 100
  final List<ParsedLabBiomarker> parsedBiomarkers;
  final List<LabPanelSummary> panelSummaries;
  final List<LabOptimizationProtocol> optimizationProtocols;
  final bool requiresPhysicianConsult;
  final String physicianEscalationRationale;
  final String regionalPhysicianEscalationRationale;
  final String executiveSynthesis;
  final String regionalExecutiveSynthesis;

  const ClinicalReportIntelligence({
    required this.reportId,
    required this.labProviderName,
    required this.testDate,
    required this.overallMetabolicGradeScore,
    required this.parsedBiomarkers,
    required this.panelSummaries,
    required this.optimizationProtocols,
    required this.requiresPhysicianConsult,
    required this.physicianEscalationRationale,
    required this.regionalPhysicianEscalationRationale,
    required this.executiveSynthesis,
    required this.regionalExecutiveSynthesis,
  });
}
