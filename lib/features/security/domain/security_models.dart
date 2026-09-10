import 'package:flutter/foundation.dart';

/// Firebase App Check provider attestation types
enum AppCheckProviderType {
  playIntegrity(
    name: 'Google Play Integrity (Android)',
    regionalName: 'गूगल प्ले इंटीग्रिटी (एंड्रॉइड)',
  ),
  deviceCheck(
    name: 'Apple DeviceCheck (iOS)',
    regionalName: 'एप्पल डिवाइस चेक (आईओएस)',
  ),
  appAttest(
    name: 'Apple App Attest (iOS 14+)',
    regionalName: 'एप्पल ऐप अटेस्ट (आईओएस)',
  ),
  debugProvider(
    name: 'Firebase Debug Token (Offline / Sandbox)',
    regionalName: 'डिबग टोकन (ऑफलाइन / सैंडबॉक्स)',
  );

  final String name;
  final String regionalName;

  const AppCheckProviderType({
    required this.name,
    required this.regionalName,
  });
}

/// Core security and enterprise hardening pillars
enum SecurityPillar {
  appCheckIntegrity(
    name: 'App Check Attestation',
    regionalName: 'ऐप चेक व क्लाइंट प्रामाणिकता',
  ),
  zeroClientSecrets(
    name: 'Zero Client-Side Secrets',
    regionalName: 'शून्य क्लाइंट-साइड गुप्त कुंजियाँ',
  ),
  biometricHealthVault(
    name: 'Biometric Re-Auth Vault',
    regionalName: 'बायोमेट्रिक स्वास्थ्य डेटा सुरक्षा',
  ),
  firestoreDataIsolation(
    name: 'Firestore UID Isolation',
    regionalName: 'फायरस्टोर डेटा पृथक्करण',
  ),
  storagePathIsolation(
    name: 'Storage Path Protection',
    regionalName: 'स्टोरेज पथ सुरक्षा व अनुमति',
  ),
  dpdpCompliance(
    name: 'DPDP & ABDM Compliance',
    regionalName: 'डीपीडीपी व एबीडीएम विधिक अनुपालन',
  );

  final String name;
  final String regionalName;

  const SecurityPillar({
    required this.name,
    required this.regionalName,
  });
}

/// Status of an individual security check
enum SecurityCheckStatus {
  passed(name: 'Verified', regionalName: 'प्रमाणित व सुरक्षित'),
  warning(name: 'Needs Attention', regionalName: 'ध्यान देने योग्य'),
  critical(name: 'Vulnerability Detected', regionalName: 'सुरक्षा जोखिम');

  final String name;
  final String regionalName;

  const SecurityCheckStatus({
    required this.name,
    required this.regionalName,
  });
}

/// Individual audited security checkpoint
@immutable
class SecurityCheckItem {
  final SecurityPillar pillar;
  final String title;
  final String regionalTitle;
  final SecurityCheckStatus status;
  final String details;
  final String regionalDetails;

  const SecurityCheckItem({
    required this.pillar,
    required this.title,
    required this.regionalTitle,
    required this.status,
    required this.details,
    required this.regionalDetails,
  });

  bool get isPassed => status == SecurityCheckStatus.passed;
}

/// Biometric authentication configuration for sensitive health telemetry
@immutable
class BiometricLockSettings {
  final bool isBiometricLockEnabled;
  final bool requireOnClinicalReports;
  final bool requireOnDoctorSharing;
  final bool requireOnAffiliatePayouts;
  final int autoLockTimeoutMinutes;

  const BiometricLockSettings({
    this.isBiometricLockEnabled = true,
    this.requireOnClinicalReports = true,
    this.requireOnDoctorSharing = true,
    this.requireOnAffiliatePayouts = true,
    this.autoLockTimeoutMinutes = 5,
  });

  BiometricLockSettings copyWith({
    bool? isBiometricLockEnabled,
    bool? requireOnClinicalReports,
    bool? requireOnDoctorSharing,
    bool? requireOnAffiliatePayouts,
    int? autoLockTimeoutMinutes,
  }) {
    return BiometricLockSettings(
      isBiometricLockEnabled:
          isBiometricLockEnabled ?? this.isBiometricLockEnabled,
      requireOnClinicalReports:
          requireOnClinicalReports ?? this.requireOnClinicalReports,
      requireOnDoctorSharing:
          requireOnDoctorSharing ?? this.requireOnDoctorSharing,
      requireOnAffiliatePayouts:
          requireOnAffiliatePayouts ?? this.requireOnAffiliatePayouts,
      autoLockTimeoutMinutes:
          autoLockTimeoutMinutes ?? this.autoLockTimeoutMinutes,
    );
  }
}

/// Complete Enterprise Security & Hardening Audit Report
@immutable
class SecurityAuditReport {
  final int overallSecurityScore; // 0 to 100
  final bool isEnterpriseHardened;
  final bool isAppCheckActive;
  final AppCheckProviderType activeProvider;
  final BiometricLockSettings biometricSettings;
  final List<SecurityCheckItem> checkItems;
  final DateTime auditedAt;

  const SecurityAuditReport({
    required this.overallSecurityScore,
    required this.isEnterpriseHardened,
    required this.isAppCheckActive,
    required this.activeProvider,
    required this.biometricSettings,
    required this.checkItems,
    required this.auditedAt,
  });
}
