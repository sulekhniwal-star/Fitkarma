enum FamilyRole { parent, spouse, child, self }

enum HealthRiskType { hypertension, glycemicInstability, lowProtein, sedentary }

class FamilyPrivacyConsent {
  final bool shareHealthScore; // Default: true
  final bool shareSteps; // Default: true
  final bool shareWeight; // Default: false
  final bool shareClinicalData; // Default: false (always)

  const FamilyPrivacyConsent({
    this.shareHealthScore = true,
    this.shareSteps = true,
    this.shareWeight = false,
    this.shareClinicalData = false,
  });
}

class FamilyMemberProfile {
  final String id;
  final String firstName;
  final String relationship; // e.g. "Dad", "Mom", "Son", "Daughter"
  final int age;
  final FamilyRole role;
  final int healthScore;
  final String bpStatus; // "Normal", "Moderate", "Elevated"
  final int stepsToday;
  final double sleepHours;
  final String activeProgramOrRisk;
  final List<HealthRiskType> activeRisks;
  final int bpCheckDaysAgo;
  final int lowProteinDays;
  final FamilyPrivacyConsent consent;

  const FamilyMemberProfile({
    required this.id,
    required this.firstName,
    required this.relationship,
    required this.age,
    required this.role,
    required this.healthScore,
    required this.bpStatus,
    required this.stepsToday,
    required this.sleepHours,
    required this.activeProgramOrRisk,
    required this.activeRisks,
    required this.bpCheckDaysAgo,
    required this.lowProteinDays,
    this.consent = const FamilyPrivacyConsent(),
  });
}

enum FamilyNudgeSeverity { high, moderate, info }

class FamilyNudge {
  final String targetMemberId;
  final String targetMemberName;
  final String message;
  final String actionText;
  final FamilyNudgeSeverity severity;

  const FamilyNudge({
    required this.targetMemberId,
    required this.targetMemberName,
    required this.message,
    required this.actionText,
    required this.severity,
  });
}

class FamilyHubEvaluation {
  final String familyId;
  final String familyName;
  final List<FamilyMemberProfile> members;
  final List<FamilyNudge> activeAlerts;

  const FamilyHubEvaluation({
    required this.familyId,
    required this.familyName,
    required this.members,
    required this.activeAlerts,
  });
}

/// Pure-Dart Family Health Hub Engine per §P9-D spec
class FamilyHealthHubEngine {
  const FamilyHealthHubEngine();

  /// Enforces maximum 6 household members per family hub subscription
  bool validateFamilyCapacity(int currentCount) {
    return currentCount <= 6;
  }

  /// Generates smart Family Nudges based on member health risks, BP checks, and protein deficit
  List<FamilyNudge> generateFamilyNudges(List<FamilyMemberProfile> members) {
    final nudges = <FamilyNudge>[];

    for (final member in members) {
      // 1. High-risk hypertension BP check reminder (> 2 days ago)
      if (member.activeRisks.contains(HealthRiskType.hypertension) &&
          member.bpCheckDaysAgo > 2) {
        nudges.add(FamilyNudge(
          targetMemberId: member.id,
          targetMemberName: member.firstName,
          message:
              '🔴 ${member.firstName} (Dad): BP elevated ${member.bpCheckDaysAgo} days — remind him to check tomorrow',
          actionText: 'Send BP Reminder',
          severity: FamilyNudgeSeverity.high,
        ));
      }

      // 2. Low protein alert (4+ days deficit)
      if (member.activeRisks.contains(HealthRiskType.lowProtein) &&
          member.lowProteinDays >= 4) {
        nudges.add(FamilyNudge(
          targetMemberId: member.id,
          targetMemberName: member.firstName,
          message:
              '🟡 ${member.firstName}: Protein low ${member.lowProteinDays} days — suggest adding eggs or paneer',
          actionText: 'Suggest Protein Snack',
          severity: FamilyNudgeSeverity.moderate,
        ));
      }
    }

    return nudges;
  }

  /// Applies Privacy Model & ADR-039 Minor Privacy Guard
  /// Children (<18): Parent is guardian; weight/body composition is strictly hidden
  Map<String, dynamic> filterPrivacyForDisplay(FamilyMemberProfile member) {
    final isMinor = member.age < 18;

    return {
      'firstName': member.firstName,
      'age': member.age,
      'healthScore':
          member.consent.shareHealthScore ? member.healthScore : null,
      'stepsToday': member.consent.shareSteps ? member.stepsToday : null,
      'isWeightHidden': isMinor || !member.consent.shareWeight,
      'isClinicalHidden': !member.consent.shareClinicalData,
    };
  }

  /// Evaluates full Family Health Hub
  FamilyHubEvaluation evaluateFamilyHub({
    required String familyId,
    required String familyName,
    required List<FamilyMemberProfile> rawMembers,
  }) {
    // Capacity check
    final cappedMembers = rawMembers.take(6).toList();
    final alerts = generateFamilyNudges(cappedMembers);

    return FamilyHubEvaluation(
      familyId: familyId,
      familyName: familyName,
      members: cappedMembers,
      activeAlerts: alerts,
    );
  }
}
