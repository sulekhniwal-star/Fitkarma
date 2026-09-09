import 'package:flutter/foundation.dart';

/// Clinical severity tier for health risk domains
enum ClinicalRiskTier {
  low(
    label: 'Low / Optimal (Surakshit)',
    regionalLabel: 'सुरक्षित (सामान्य स्तर)',
    colorCode: 0xFF00E676,
    riskScoreRange: '0 - 24',
  ),
  moderate(
    label: 'Moderate / Pre-Clinical (Satark)',
    regionalLabel: 'सतर्क (प्रारंभिक जोखिम)',
    colorCode: 0xFFFF9100,
    riskScoreRange: '25 - 59',
  ),
  elevated(
    label: 'Elevated / Action Required (Chintajanak)',
    regionalLabel: 'चिंताजनक (सक्रिय निवारण आवश्यक)',
    colorCode: 0xFFFF5252,
    riskScoreRange: '60 - 100',
  );

  final String label;
  final String regionalLabel;
  final int colorCode;
  final String riskScoreRange;

  const ClinicalRiskTier({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
    required this.riskScoreRange,
  });
}

/// The 5 core clinical domains evaluated in South Asian preventive health
enum RiskDomainType {
  cardiometabolic(
    label: 'Cardiometabolic & Visceral Adiposity (WHtR)',
    regionalLabel: 'हृदय-उपापचयी व आंतरिक चर्बी जोखिम',
    iconName: 'monitor_weight',
  ),
  glycemicDiabetes(
    label: 'Indian Diabetes Risk Score (IDRS / Glucose)',
    regionalLabel: 'मधुमेह विकास जोखिम (IDRS)',
    iconName: 'bloodtype',
  ),
  autonomicVagal(
    label: 'Autonomic Vagal & Stress Dysregulation',
    regionalLabel: 'स्वायत्त तंत्रिका व तनाव असंतुलन',
    iconName: 'favorite',
  ),
  sarcopenicStrength(
    label: 'Sarcopenic Deficit & Muscle Quality',
    regionalLabel: 'मांसपेशी गुणवत्ता व शक्ति क्षय',
    iconName: 'fitness_center',
  ),
  circadianDigestive(
    label: 'Circadian & Postprandial Digestive Strain',
    regionalLabel: 'दिनचर्या व पाचन अग्नि असंतुलन',
    iconName: 'nights_stay',
  );

  final String label;
  final String regionalLabel;
  final String iconName;

  const RiskDomainType({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
  });
}

/// Individual evaluated clinical risk factor
@immutable
class ClinicalRiskFactor {
  final String id;
  final RiskDomainType domain;
  final String name;
  final String regionalName;
  final double measuredValue;
  final String unit;
  final double optimalThreshold;
  final double clinicalRiskThreshold;
  final double riskScore; // 0.0 to 100.0
  final ClinicalRiskTier tier;
  final String clinicalRationale;
  final String regionalClinicalRationale;

  const ClinicalRiskFactor({
    required this.id,
    required this.domain,
    required this.name,
    required this.regionalName,
    required this.measuredValue,
    required this.unit,
    required this.optimalThreshold,
    required this.clinicalRiskThreshold,
    required this.riskScore,
    required this.tier,
    required this.clinicalRationale,
    required this.regionalClinicalRationale,
  });
}

/// Actionable non-pharmaceutical preventive lifestyle protocol
@immutable
class PreventiveProtocol {
  final String id;
  final RiskDomainType targetedDomain;
  final String title;
  final String regionalTitle;
  final String protocolDescription;
  final String regionalProtocolDescription;
  final String frequency; // e.g. "Daily after dinner", "3x per week"
  final String expectedBiometricImpact; // e.g. "Reduces postprandial glucose spike by 24%"
  final int karmaReward;

  const PreventiveProtocol({
    required this.id,
    required this.targetedDomain,
    required this.title,
    required this.regionalTitle,
    required this.protocolDescription,
    required this.regionalProtocolDescription,
    required this.frequency,
    required this.expectedBiometricImpact,
    required this.karmaReward,
  });
}

/// Comprehensive Health Risk Prevention Report
@immutable
class HealthRiskPreventionReport {
  final double compositeRiskScore; // 0.0 to 100.0 (lower is better/healthier)
  final ClinicalRiskTier overallRiskTier;
  final double cardiometabolicDomainScore;
  final double idrsDiabetesDomainScore;
  final double autonomicDomainScore;
  final double sarcopeniaDomainScore;
  final double circadianDomainScore;
  final List<ClinicalRiskFactor> riskFactors;
  final List<PreventiveProtocol> activeProtocols;
  final bool requiresDoctorConsultation;
  final String consultationReason;
  final String regionalConsultationReason;

  const HealthRiskPreventionReport({
    required this.compositeRiskScore,
    required this.overallRiskTier,
    required this.cardiometabolicDomainScore,
    required this.idrsDiabetesDomainScore,
    required this.autonomicDomainScore,
    required this.sarcopeniaDomainScore,
    required this.circadianDomainScore,
    required this.riskFactors,
    required this.activeProtocols,
    required this.requiresDoctorConsultation,
    required this.consultationReason,
    required this.regionalConsultationReason,
  });
}
