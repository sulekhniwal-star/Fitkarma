import 'package:flutter/foundation.dart';

/// Regulatory framework standard
enum ComplianceStandard {
  abdmIndia(
    name: 'ABDM (Ayushman Bharat Digital Mission)',
    regionalName: 'आयुष्मान भारत डिजिटल मिशन (ABDM)',
    jurisdiction: 'India (National Health Authority)',
    description: 'Consent manager integration, health data encryption, and FHIR interoperability.',
  ),
  dpdpActIndia(
    name: 'DPDP Act 2023 (Digital Data Protection)',
    regionalName: 'डिजिटल व्यक्तिगत डेटा संरक्षण अधिनियम २०२३',
    jurisdiction: 'India',
    description: 'Explicit informed consent, purpose limitation, and user right to erasure.',
  ),
  hipaaSecurity(
    name: 'HIPAA Privacy & Security Rules',
    regionalName: 'HIPAA डेटा गोपनीयता व सुरक्षा मानक',
    jurisdiction: 'United States / Global Healthcare',
    description: 'End-to-end telemetry encryption, audit trail integrity, and minimum necessary rule.',
  ),
  ayushGuidelines(
    name: 'AYUSH Ministry Practice Guidelines',
    regionalName: 'आयुष मंत्रालय पारंपरिक स्वास्थ्य दिशानिर्देश',
    jurisdiction: 'India (Ministry of AYUSH)',
    description: 'Standardized terminology for Dosha, Dinacharya, and Rasayana lifestyle guidance.',
  );

  final String name;
  final String regionalName;
  final String jurisdiction;
  final String description;

  const ComplianceStandard({
    required this.name,
    required this.regionalName,
    required this.jurisdiction,
    required this.description,
  });
}

/// Clinical Consent Artifact
@immutable
class ClinicalConsentArtifact {
  final String consentId;
  final String purpose;
  final String regionalPurpose;
  final List<String> dataCategories;
  final DateTime grantedAt;
  final DateTime expiresAt;
  final bool isExplicitlyGranted;
  final bool isRevocable;

  const ClinicalConsentArtifact({
    required this.consentId,
    required this.purpose,
    required this.regionalPurpose,
    required this.dataCategories,
    required this.grantedAt,
    required this.expiresAt,
    required this.isExplicitlyGranted,
    required this.isRevocable,
  });
}

/// Clinical & SaMD Disclaimer Record
@immutable
class ClinicalDisclaimer {
  final String title;
  final String regionalTitle;
  final String legalText;
  final String regionalLegalText;
  final String emergencyHelpline;

  const ClinicalDisclaimer({
    required this.title,
    required this.regionalTitle,
    required this.legalText,
    required this.regionalLegalText,
    required this.emergencyHelpline,
  });
}

/// Comprehensive Regulatory & Compliance Status Report
@immutable
class ComplianceFrameworkReport {
  final double complianceAuditScore; // 0 to 100%
  final bool isFullyCompliant;
  final List<ComplianceStandard> activeStandards;
  final List<ClinicalConsentArtifact> activeConsents;
  final ClinicalDisclaimer clinicalDisclaimer;
  final bool encryptionAtRestVerified;
  final bool auditLoggingActive;
  final bool dataErasureSupported;
  final DateTime lastComplianceAudit;

  const ComplianceFrameworkReport({
    required this.complianceAuditScore,
    required this.isFullyCompliant,
    required this.activeStandards,
    required this.activeConsents,
    required this.clinicalDisclaimer,
    required this.encryptionAtRestVerified,
    required this.auditLoggingActive,
    required this.dataErasureSupported,
    required this.lastComplianceAudit,
  });
}
