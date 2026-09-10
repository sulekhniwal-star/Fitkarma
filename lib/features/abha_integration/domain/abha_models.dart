import 'package:flutter/foundation.dart';

/// ABDM KYC & ABHA Verification Status
enum AbhaVerificationStatus {
  unlinked(label: 'Not Linked', regionalLabel: 'लिंक नहीं है'),
  pendingOtp(
      label: 'Aadhaar / Mobile OTP Pending',
      regionalLabel: 'ओटीपी सत्यापन लंबित'),
  verifiedAadhaar(
      label: 'Aadhaar Verified (ABDM Official)',
      regionalLabel: 'आधार सत्यापित (आधिकारिक)'),
  verifiedMobile(label: 'Mobile Verified', regionalLabel: 'मोबाइल सत्यापित');

  final String label;
  final String regionalLabel;

  const AbhaVerificationStatus({
    required this.label,
    required this.regionalLabel,
  });
}

/// ABDM Purpose Codes for Consent Management (NHA / ABDM v0.5)
enum AbdmPurposeCode {
  careManagement(
      code: 'CARETREE',
      label: 'Care Management & Preventive Health',
      regionalLabel: 'स्वास्थ्य प्रबंधन व निवारक देखभाल'),
  selfSharing(
      code: 'BTG',
      label: 'Self Health Tracking & Analytics',
      regionalLabel: 'स्व-स्वास्थ्य विश्लेषण'),
  clinicalConsult(
      code: 'PUBHLTH',
      label: 'Doctor & Hospital Sharing',
      regionalLabel: 'चिकित्सक व अस्पताल परामर्श');

  final String code;
  final String label;
  final String regionalLabel;

  const AbdmPurposeCode({
    required this.code,
    required this.label,
    required this.regionalLabel,
  });
}

/// ABDM Consent Artifact Status
enum AbhaConsentStatus { requested, granted, denied, expired, revoked }

/// Official ABHA Digital Health Account Profile
@immutable
class AbhaProfile {
  final String abhaNumber; // 14-digit formatted: "14-8822-4912-8734"
  final String abhaAddress; // PHR Handle e.g. "rahul.sharma@abdm"
  final String fullName;
  final String gender; // M, F, O
  final String dateOfBirth; // YYYY-MM-DD
  final String mobileNumber;
  final String pincode;
  final String stateName;
  final String districtName;
  final AbhaVerificationStatus verificationStatus;
  final String qrCodePayload;
  final DateTime? linkedAt;

  const AbhaProfile({
    required this.abhaNumber,
    required this.abhaAddress,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.mobileNumber,
    required this.pincode,
    required this.stateName,
    required this.districtName,
    required this.verificationStatus,
    required this.qrCodePayload,
    this.linkedAt,
  });

  bool get isLinked =>
      verificationStatus == AbhaVerificationStatus.verifiedAadhaar ||
      verificationStatus == AbhaVerificationStatus.verifiedMobile;

  AbhaProfile copyWith({
    String? abhaNumber,
    String? abhaAddress,
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? mobileNumber,
    String? pincode,
    String? stateName,
    String? districtName,
    AbhaVerificationStatus? verificationStatus,
    String? qrCodePayload,
    DateTime? linkedAt,
  }) {
    return AbhaProfile(
      abhaNumber: abhaNumber ?? this.abhaNumber,
      abhaAddress: abhaAddress ?? this.abhaAddress,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      pincode: pincode ?? this.pincode,
      stateName: stateName ?? this.stateName,
      districtName: districtName ?? this.districtName,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      qrCodePayload: qrCodePayload ?? this.qrCodePayload,
      linkedAt: linkedAt ?? this.linkedAt,
    );
  }
}

/// ABDM Consent Request & Grant Record
@immutable
class AbhaConsentGrant {
  final String consentRequestId;
  final String
      requesterEntityName; // e.g. "Apollo Hospitals", "Max Healthcare", "AIIMS New Delhi"
  final AbdmPurposeCode purpose;
  final List<String>
      hiTypes; // ["DiagnosticReport", "Observation", "WellnessRecord"]
  final AbhaConsentStatus status;
  final DateTime requestedAt;
  final DateTime validUntil;

  const AbhaConsentGrant({
    required this.consentRequestId,
    required this.requesterEntityName,
    required this.purpose,
    required this.hiTypes,
    required this.status,
    required this.requestedAt,
    required this.validUntil,
  });

  bool get isActive =>
      status == AbhaConsentStatus.granted && validUntil.isAfter(DateTime.now());

  AbhaConsentGrant copyWith({
    String? consentRequestId,
    String? requesterEntityName,
    AbdmPurposeCode? purpose,
    List<String>? hiTypes,
    AbhaConsentStatus? status,
    DateTime? requestedAt,
    DateTime? validUntil,
  }) {
    return AbhaConsentGrant(
      consentRequestId: consentRequestId ?? this.consentRequestId,
      requesterEntityName: requesterEntityName ?? this.requesterEntityName,
      purpose: purpose ?? this.purpose,
      hiTypes: hiTypes ?? this.hiTypes,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      validUntil: validUntil ?? this.validUntil,
    );
  }
}

/// FHIR R4 Bundle Data for ABDM Health Record Sharing (HIP/HIU)
@immutable
class AbhaFhirRecordBundle {
  final String bundleId;
  final String abhaAddress;
  final int observationCount;
  final double latestBiologicalAge;
  final double latestLongevityScore;
  final String prakritiConstitution;
  final double averageVo2Max;
  final int weeklyStepsAverage;
  final DateTime generatedAt;

  const AbhaFhirRecordBundle({
    required this.bundleId,
    required this.abhaAddress,
    required this.observationCount,
    required this.latestBiologicalAge,
    required this.latestLongevityScore,
    required this.prakritiConstitution,
    required this.averageVo2Max,
    required this.weeklyStepsAverage,
    required this.generatedAt,
  });
}
