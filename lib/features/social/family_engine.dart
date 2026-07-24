/// §P9-D Family Health Hub — Engine
///
/// Implements permission-gated privacy masking, max 6 household member cap validation,
/// and household alert aggregation matching §P9-D specification.
library;

import 'package:fitkarma/features/social/family_models.dart';

class FamilyCapacityException implements Exception {
  FamilyCapacityException(this.message);
  final String message;

  @override
  String toString() => 'FamilyCapacityException: $message';
}

class FamilyEngine {
  const FamilyEngine();

  /// Maximum members allowed under one family subscription unit (§P9-D spec).
  static const int maxHouseholdMembers = 6;

  /// Applies permission-gated privacy consent switches to mask restricted metrics.
  ///
  /// - `shareHealthScore` == false -> `healthScore` set to null
  /// - `shareSteps` == false -> `stepsToday` set to null
  /// - `shareSleep` == false -> `sleepHours` set to null
  /// - `shareWeight` == false -> `weightKg` set to null (Default: off)
  FamilyMemberProfile filterMemberForView(FamilyMemberProfile member) {
    if (member.isCurrentUser) {
      // Current user sees all their own metrics regardless of sharing toggles
      return member;
    }

    final consent = member.consentSettings;

    return member.copyWith(
      clearHealthScore: !consent.shareHealthScore,
      clearStepsToday: !consent.shareSteps,
      clearSleepHours: !consent.shareSleep,
      clearWeightKg: !consent.shareWeight,
    );
  }

  /// Compiles active household health alerts for family members whose privacy settings allow it.
  List<FamilyAlert> aggregateFamilyAlerts(List<FamilyMemberProfile> members) {
    final alerts = <FamilyAlert>[];

    for (final member in members) {
      if (!member.consentSettings.shareMedicalRiskAlerts && !member.isCurrentUser) {
        continue;
      }

      // Check BP watch / risk watch
      if (member.riskWatch != null && member.riskWatch!.contains('Hypertension')) {
        alerts.add(
          FamilyAlert(
            id: 'alert_bp_${member.memberId}',
            severity: FamilyAlertSeverity.critical,
            memberId: member.memberId,
            memberName: member.name,
            message: '${member.name}: BP elevated 3 days — remind them to check tomorrow',
            suggestedAction: 'Send BP check reminder',
          ),
        );
      }

      // Check sleep or nutrition warning
      if (member.stepsToday != null && member.stepsToday! < 5000) {
        alerts.add(
          FamilyAlert(
            id: 'alert_steps_${member.memberId}',
            severity: FamilyAlertSeverity.warning,
            memberId: member.memberId,
            memberName: member.name,
            message: '${member.name}: Activity low today — suggest an evening family walk',
            suggestedAction: 'Suggest family walk',
          ),
        );
      }
    }

    return alerts;
  }

  /// Validates adding a new member under the max 6 household member cap.
  void validateAddMember(int currentMemberCount) {
    if (currentMemberCount >= maxHouseholdMembers) {
      throw FamilyCapacityException(
        'Maximum household limit reached ($maxHouseholdMembers members max under one family unit).',
      );
    }
  }
}
