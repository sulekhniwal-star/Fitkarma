/// §P9-D Family Health Hub — Models
///
/// Defines family member roles, privacy consent settings, risk alert severity tiers,
/// and permission-gated household data models matching §P9-D specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Privacy Consent
// ─────────────────────────────────────────────────────────────────────────────

enum FamilyMemberRole {
  primaryAccount('Primary Account Holder', '🧑'),
  spouse('Spouse', '👩'),
  parent('Parent', '👨'),
  child('Child', '👧');

  const FamilyMemberRole(this.displayName, this.iconSymbol);

  final String displayName;
  final String iconSymbol;
}

enum FamilyAlertSeverity {
  critical('Critical Notice', '🔴'),
  warning('Warning Nudge', '🟡'),
  info('Family Update', '🔵');

  const FamilyAlertSeverity(this.displayName, this.indicatorEmoji);

  final String displayName;
  final String indicatorEmoji;
}

class FamilyPrivacyConsent {
  const FamilyPrivacyConsent({
    this.shareHealthScore = true,
    this.shareSteps = true,
    this.shareSleep = true,
    this.shareWeight = false, // Default: off to protect privacy
    this.shareMedicalRiskAlerts = true,
  });

  final bool shareHealthScore;
  final bool shareSteps;
  final bool shareSleep;
  final bool shareWeight;
  final bool shareMedicalRiskAlerts;

  FamilyPrivacyConsent copyWith({
    bool? shareHealthScore,
    bool? shareSteps,
    bool? shareSleep,
    bool? shareWeight,
    bool? shareMedicalRiskAlerts,
  }) {
    return FamilyPrivacyConsent(
      shareHealthScore: shareHealthScore ?? this.shareHealthScore,
      shareSteps: shareSteps ?? this.shareSteps,
      shareSleep: shareSleep ?? this.shareSleep,
      shareWeight: shareWeight ?? this.shareWeight,
      shareMedicalRiskAlerts: shareMedicalRiskAlerts ?? this.shareMedicalRiskAlerts,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Member & Alert Models
// ─────────────────────────────────────────────────────────────────────────────

class FamilyAlert {
  const FamilyAlert({
    required this.id,
    required this.severity,
    required this.memberId,
    required this.memberName,
    required this.message,
    required this.suggestedAction,
  });

  final String id;
  final FamilyAlertSeverity severity;
  final String memberId;
  final String memberName;
  final String message;
  final String suggestedAction;
}

class FamilyMemberProfile {
  const FamilyMemberProfile({
    required this.memberId,
    required this.familyUnitId,
    required this.name,
    required this.age,
    required this.role,
    required this.healthScore,
    required this.bpStatus,
    required this.stepsToday,
    required this.sleepHours,
    this.programName,
    this.weightKg,
    this.riskWatch,
    this.consentSettings = const FamilyPrivacyConsent(),
    this.isCurrentUser = false,
  });

  final String memberId;
  final String familyUnitId;
  final String name;
  final int age;
  final FamilyMemberRole role;
  final int? healthScore;
  final String bpStatus;
  final int? stepsToday;
  final double? sleepHours;
  final String? programName;
  final double? weightKg;
  final String? riskWatch;
  final FamilyPrivacyConsent consentSettings;
  final bool isCurrentUser;

  FamilyMemberProfile copyWith({
    int? healthScore,
    bool clearHealthScore = false,
    int? stepsToday,
    bool clearStepsToday = false,
    double? sleepHours,
    bool clearSleepHours = false,
    double? weightKg,
    bool clearWeightKg = false,
    FamilyPrivacyConsent? consentSettings,
  }) {
    return FamilyMemberProfile(
      memberId: memberId,
      familyUnitId: familyUnitId,
      name: name,
      age: age,
      role: role,
      healthScore: clearHealthScore ? null : (healthScore ?? this.healthScore),
      bpStatus: bpStatus,
      stepsToday: clearStepsToday ? null : (stepsToday ?? this.stepsToday),
      sleepHours: clearSleepHours ? null : (sleepHours ?? this.sleepHours),
      programName: programName,
      weightKg: clearWeightKg ? null : (weightKg ?? this.weightKg),
      riskWatch: riskWatch,
      consentSettings: consentSettings ?? this.consentSettings,
      isCurrentUser: isCurrentUser,
    );
  }
}

class FamilyHubData {
  const FamilyHubData({
    required this.familyUnitId,
    required this.familyName,
    required this.primaryUserId,
    required this.members,
    required this.familyAlerts,
  });

  final String familyUnitId;
  final String familyName;
  final String primaryUserId;
  final List<FamilyMemberProfile> members;
  final List<FamilyAlert> familyAlerts;
}
