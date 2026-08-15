// §P3-D Health Coach Escalation Layer (Pure Dart, Elite Tier)

// ── Risk Severity ─────────────────────────────────────────────────────────────

enum RiskSeverity { low, medium, high }

class ActiveRisk {
  final String riskType; // e.g. 'plateau', 'illness', 'psychological'
  final RiskSeverity severity;
  final String description;

  const ActiveRisk({
    required this.riskType,
    required this.severity,
    required this.description,
  });
}

// ── Escalation Reason ─────────────────────────────────────────────────────────

enum EscalationTriggerType {
  highRiskMedical,
  unresolvedPlateau,
  psychologicalDistress,
  userRequested,
}

extension EscalationTriggerTypeLabel on EscalationTriggerType {
  String get label {
    switch (this) {
      case EscalationTriggerType.highRiskMedical:
        return 'High-Risk Medical Complexity';
      case EscalationTriggerType.unresolvedPlateau:
        return 'Unresolved Metabolic Plateau (4+ weeks)';
      case EscalationTriggerType.psychologicalDistress:
        return 'Psychological Distress Signals';
      case EscalationTriggerType.userRequested:
        return 'User Requested Human Review';
    }
  }
}

class EscalationReason {
  final EscalationTriggerType triggerType;
  final String clinicalNote;

  const EscalationReason({
    required this.triggerType,
    required this.clinicalNote,
  });
}

// ── User State for Escalation Evaluation ─────────────────────────────────────

class UserEscalationState {
  final List<ActiveRisk> activeRisks;
  final int plateauWeeks;
  final bool adaptiveCaloriesAlreadyAdjusted;
  final int consecutiveRelapseAttempts;
  final bool userRequestedHumanCoach;

  const UserEscalationState({
    this.activeRisks = const [],
    this.plateauWeeks = 0,
    this.adaptiveCaloriesAlreadyAdjusted = false,
    this.consecutiveRelapseAttempts = 0,
    this.userRequestedHumanCoach = false,
  });
}

// ── Coach Briefing Package ────────────────────────────────────────────────────

class CoachBriefingPackage {
  final String userId;
  final String userName;
  final String goal;
  final int programWeek;
  final int programTotalWeeks;
  final String programName;

  // Current Status
  final double weightChange4wKg;
  final double expectedWeightChange4wKg;
  final int calorieTarget;
  final int adaptiveAdjustmentCount;
  final double nutritionAdherencePct;
  final double trainingAdherencePct;
  final String recoveryDebtLevel; // 'LOW', 'MEDIUM', 'HIGH'
  final int sleepDeficitDays;

  // AI Limitations
  final List<String> aiLimitationsHit;

  // Escalation
  final EscalationReason escalationReason;
  final String aiCoachNotesSummary;

  final DateTime generatedAt;

  const CoachBriefingPackage({
    required this.userId,
    required this.userName,
    required this.goal,
    required this.programWeek,
    required this.programTotalWeeks,
    required this.programName,
    required this.weightChange4wKg,
    required this.expectedWeightChange4wKg,
    required this.calorieTarget,
    required this.adaptiveAdjustmentCount,
    required this.nutritionAdherencePct,
    required this.trainingAdherencePct,
    required this.recoveryDebtLevel,
    required this.sleepDeficitDays,
    required this.aiLimitationsHit,
    required this.escalationReason,
    required this.aiCoachNotesSummary,
    required this.generatedAt,
  });

  /// Formats the §P3-D structured coach briefing text
  String toFormattedBriefing() {
    final sb = StringBuffer();
    sb.writeln('Coach Briefing — $userName');
    sb.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━');
    sb.writeln();
    sb.writeln('Goal:         $goal');
    sb.writeln('Week:         $programWeek of $programTotalWeeks');
    sb.writeln('Program:      $programName');
    sb.writeln();
    sb.writeln('Current Status:');
    sb.writeln(
        '  Weight change (4w):  ${weightChange4wKg >= 0 ? '+' : ''}${weightChange4wKg.toStringAsFixed(1)} kg (expected ${expectedWeightChange4wKg >= 0 ? '+' : ''}${expectedWeightChange4wKg.toStringAsFixed(1)} kg)');
    sb.writeln(
        '  Calorie target:      $calorieTarget (after $adaptiveAdjustmentCount adaptive adjustment${adaptiveAdjustmentCount == 1 ? '' : 's'})');
    sb.writeln(
        '  Adherence:           Nutrition ${nutritionAdherencePct.round()}% / Training ${trainingAdherencePct.round()}%');
    sb.writeln(
        '  Recovery Debt:       $recoveryDebtLevel ($sleepDeficitDays-day sleep deficit)');
    sb.writeln();
    sb.writeln('AI Limitations Hit:');
    for (final limitation in aiLimitationsHit) {
      sb.writeln('  ✗ $limitation');
    }
    sb.writeln();
    sb.writeln('Escalation Reason:');
    sb.writeln('  ${escalationReason.clinicalNote}');
    sb.writeln();
    sb.writeln('AI Coach Notes (last 7 days):');
    sb.writeln('  "$aiCoachNotesSummary"');
    return sb.toString();
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
        'goal': goal,
        'program_week': programWeek,
        'program_total_weeks': programTotalWeeks,
        'program_name': programName,
        'weight_change_4w_kg': weightChange4wKg,
        'expected_weight_change_4w_kg': expectedWeightChange4wKg,
        'calorie_target': calorieTarget,
        'adaptive_adjustment_count': adaptiveAdjustmentCount,
        'nutrition_adherence_pct': nutritionAdherencePct,
        'training_adherence_pct': trainingAdherencePct,
        'recovery_debt_level': recoveryDebtLevel,
        'sleep_deficit_days': sleepDeficitDays,
        'ai_limitations_hit': aiLimitationsHit,
        'escalation_trigger': escalationReason.triggerType.name,
        'escalation_clinical_note': escalationReason.clinicalNote,
        'ai_coach_notes_summary': aiCoachNotesSummary,
        'generated_at': generatedAt.toIso8601String(),
      };
}

// ── Escalation Service (Pure Dart) ────────────────────────────────────────────

class EscalationTicket {
  final String userId;
  final CoachBriefingPackage briefing;
  final DateTime createdAt;
  final String status; // 'pending' | 'in_review' | 'resolved'

  const EscalationTicket({
    required this.userId,
    required this.briefing,
    required this.createdAt,
    this.status = 'pending',
  });
}

class EscalationResult {
  final bool escalated;
  final EscalationTriggerType? reason;
  final String userNotificationTitle;
  final String userNotificationBody;

  const EscalationResult({
    required this.escalated,
    this.reason,
    this.userNotificationTitle = '',
    this.userNotificationBody = '',
  });

  static const EscalationResult noEscalation =
      EscalationResult(escalated: false);
}

class CoachEscalationService {
  const CoachEscalationService();

  /// §P3-D Escalation Trigger Logic — Pure Dart deterministic evaluation
  bool shouldEscalate(UserEscalationState state) {
    // 1. Medical complexity beyond AI coaching scope
    if (state.activeRisks.any((r) => r.severity == RiskSeverity.high)) {
      return true;
    }
    // 2. Plateau unresolved after Adaptive Metabolism correction for 4+ weeks
    if (state.plateauWeeks >= 4 && state.adaptiveCaloriesAlreadyAdjusted) {
      return true;
    }
    // 3. Psychological distress signals (3+ consecutive relapse attempts)
    if (state.consecutiveRelapseAttempts >= 3) {
      return true;
    }
    // 4. User explicitly requests human review
    if (state.userRequestedHumanCoach) {
      return true;
    }
    return false;
  }

  /// Identify the primary escalation reason (highest priority first)
  EscalationReason identifyReason(UserEscalationState state) {
    if (state.activeRisks.any((r) => r.severity == RiskSeverity.high)) {
      final risk =
          state.activeRisks.firstWhere((r) => r.severity == RiskSeverity.high);
      return EscalationReason(
        triggerType: EscalationTriggerType.highRiskMedical,
        clinicalNote:
            'High-risk biometric signal: ${risk.description}. Possible ${risk.riskType} involvement requiring clinical review.',
      );
    }
    if (state.plateauWeeks >= 4 && state.adaptiveCaloriesAlreadyAdjusted) {
      return EscalationReason(
        triggerType: EscalationTriggerType.unresolvedPlateau,
        clinicalNote:
            'Metabolic plateau for ${state.plateauWeeks} consecutive weeks post-recalibration. Possible thyroid/cortisol involvement.',
      );
    }
    if (state.consecutiveRelapseAttempts >= 3) {
      return EscalationReason(
        triggerType: EscalationTriggerType.psychologicalDistress,
        clinicalNote:
            '${state.consecutiveRelapseAttempts} consecutive relapse attempts detected. Behavioural support beyond AI scope.',
      );
    }
    return const EscalationReason(
      triggerType: EscalationTriggerType.userRequested,
      clinicalNote: 'User requested a human health coach review.',
    );
  }

  /// Build the §P3-D structured Coach Briefing Package
  CoachBriefingPackage buildBriefing({
    required String userId,
    required String userName,
    required String goal,
    required int programWeek,
    required int programTotalWeeks,
    required String programName,
    required double weightChange4wKg,
    required double expectedWeightChange4wKg,
    required int calorieTarget,
    required int adaptiveAdjustmentCount,
    required double nutritionAdherencePct,
    required double trainingAdherencePct,
    required int sleepDeficitDays,
    required List<String> aiLimitationsHit,
    required EscalationReason escalationReason,
    required String aiCoachNotesSummary,
  }) {
    String recoveryDebtLevel;
    if (sleepDeficitDays >= 5) {
      recoveryDebtLevel = 'HIGH';
    } else if (sleepDeficitDays >= 2) {
      recoveryDebtLevel = 'MEDIUM';
    } else {
      recoveryDebtLevel = 'LOW';
    }

    return CoachBriefingPackage(
      userId: userId,
      userName: userName,
      goal: goal,
      programWeek: programWeek,
      programTotalWeeks: programTotalWeeks,
      programName: programName,
      weightChange4wKg: weightChange4wKg,
      expectedWeightChange4wKg: expectedWeightChange4wKg,
      calorieTarget: calorieTarget,
      adaptiveAdjustmentCount: adaptiveAdjustmentCount,
      nutritionAdherencePct: nutritionAdherencePct,
      trainingAdherencePct: trainingAdherencePct,
      recoveryDebtLevel: recoveryDebtLevel,
      sleepDeficitDays: sleepDeficitDays,
      aiLimitationsHit: aiLimitationsHit,
      escalationReason: escalationReason,
      aiCoachNotesSummary: aiCoachNotesSummary,
      generatedAt: DateTime.now(),
    );
  }

  /// Trigger escalation — builds briefing, creates ticket, returns user notification
  EscalationResult escalate({
    required UserEscalationState state,
    required CoachBriefingPackage briefing,
  }) {
    // Would call coach dashboard API & notification service in production
    final reason = identifyReason(state);
    return EscalationResult(
      escalated: true,
      reason: reason.triggerType,
      userNotificationTitle: 'Your health coach will review your plan',
      userNotificationBody:
          'A certified coach is reviewing your data and will respond within 24 hours.',
    );
  }
}
