import 'package:flutter/foundation.dart';

/// Clinical permission scope for data sharing
enum ClinicalDataScope {
  cardiometabolicBp(
    name: 'Cardiovascular & Blood Pressure',
    regionalName: 'हृदय गति व रक्तचाप आंकड़े',
    description: '30-day RHR, SBP/DBP hemodynamics, and autonomic HRV tone',
  ),
  glycemicCgm(
    name: 'Glycemic & CGM Interstitial Feeds',
    regionalName: 'शर्करा व CGM निरंतर आंकड़े',
    description:
        'Time in Range (TIR), mean glucose, postprandial spike amplitude',
  ),
  labBiomarkers(
    name: 'Diagnostic Laboratory Panels',
    regionalName: 'प्रयोगशाला रक्त परीक्षण रिपोर्ट',
    description:
        'Lipid profile, HbA1c, LFT enzymes, KFT renal markers, Vitamins',
  ),
  medicationRegimens(
    name: 'Medication Regimen & Adherence',
    regionalName: 'दवाओं की सूची व सेवन अनुपालन',
    description:
        'Active allopathic prescriptions, Ayurvedic rasayanas, and compliance rate',
  ),
  sleepRecovery(
    name: 'Sleep Architecture & Recovery',
    regionalName: 'नींद संरचना व जैविक पुनर्जनन',
    description: 'Deep sleep slow-wave delta %, sleep debt, and stress trends',
  );

  final String name;
  final String regionalName;
  final String description;

  const ClinicalDataScope({
    required this.name,
    required this.regionalName,
    required this.description,
  });
}

/// Access duration validity
enum SharingDurationWindow {
  hours24(
      label: '24 Hours (Immediate Consult)',
      regionalLabel: '२४ घंटे (तात्कालिक परामर्श)',
      duration: Duration(hours: 24)),
  days7(
      label: '7 Days (Post-Consult Follow-up)',
      regionalLabel: '७ दिन (परामर्श पश्चात समीक्षा)',
      duration: Duration(days: 7)),
  days30(
      label: '30 Days (Chronic Care Management)',
      regionalLabel: '३० दिन (दीर्घकालिक देखभाल)',
      duration: Duration(days: 30)),
  days90(
      label: '90 Days (Quarterly Specialist Review)',
      regionalLabel: '९० दिन (त्रैमासिक विशेषज्ञ समीक्षा)',
      duration: Duration(days: 90));

  final String label;
  final String regionalLabel;
  final Duration duration;

  const SharingDurationWindow({
    required this.label,
    required this.regionalLabel,
    required this.duration,
  });
}

/// Active Doctor / Specialist Grant Record
@immutable
class DoctorAccessGrant {
  final String grantId;
  final String doctorName;
  final String
      specialization; // e.g. "Cardiologist", "Endocrinologist", "Ayurvedic Physician"
  final String clinicOrHospital;
  final String medicalRegistrationNumber; // e.g. "MCI-48291"
  final DateTime grantedAt;
  final DateTime expiresAt;
  final List<ClinicalDataScope> permittedScopes;
  final String secureAccessToken; // 6-digit access code / link token
  final bool isActive;
  final int totalViewsCount;
  final DateTime? lastAccessedAt;

  const DoctorAccessGrant({
    required this.grantId,
    required this.doctorName,
    required this.specialization,
    required this.clinicOrHospital,
    required this.medicalRegistrationNumber,
    required this.grantedAt,
    required this.expiresAt,
    required this.permittedScopes,
    required this.secureAccessToken,
    required this.isActive,
    required this.totalViewsCount,
    this.lastAccessedAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Clinical Access Audit Log Entry
@immutable
class ClinicalAuditLogEntry {
  final String id;
  final String doctorName;
  final DateTime accessedAt;
  final List<ClinicalDataScope> scopesViewed;
  final String ipAddressOrDevice;

  const ClinicalAuditLogEntry({
    required this.id,
    required this.doctorName,
    required this.accessedAt,
    required this.scopesViewed,
    required this.ipAddressOrDevice,
  });
}

/// Formatted Doctor Clinical Dossier
@immutable
class FormattedDoctorDossier {
  final String patientId;
  final String patientDemographics;
  final String subjectiveObjectiveSummary;
  final String regionalSubjectiveObjectiveSummary;
  final String cardiometabolicSection;
  final String glycemicSection;
  final String medicationsSection;
  final String fullFormattedTextForPdf;
  final DateTime compiledAt;

  const FormattedDoctorDossier({
    required this.patientId,
    required this.patientDemographics,
    required this.subjectiveObjectiveSummary,
    required this.regionalSubjectiveObjectiveSummary,
    required this.cardiometabolicSection,
    required this.glycemicSection,
    required this.medicationsSection,
    required this.fullFormattedTextForPdf,
    required this.compiledAt,
  });
}

/// Comprehensive Doctor Sharing Portal State
@immutable
class DoctorSharingPortalReport {
  final List<DoctorAccessGrant> activeGrants;
  final List<ClinicalAuditLogEntry> auditLogs;
  final FormattedDoctorDossier currentDossier;
  final int totalActiveGrantsCount;
  final bool hasActiveSharingLinks;
  final DateTime lastRefreshed;

  const DoctorSharingPortalReport({
    required this.activeGrants,
    required this.auditLogs,
    required this.currentDossier,
    required this.totalActiveGrantsCount,
    required this.hasActiveSharingLinks,
    required this.lastRefreshed,
  });
}
