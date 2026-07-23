import 'package:fitkarma/core/database/app_database.dart';

enum SubscriptionTier { free, pro, eliteCoach }

enum RiskSeverity { low, medium, high }

class ActiveRisk {
  const ActiveRisk({required this.label, required this.severity});

  final String label;
  final RiskSeverity severity;
}

class UserState {
  const UserState({
    this.activeRisks = const [],
    this.plateauWeeks = 0,
    this.adaptiveCaloriesAlreadyAdjusted = false,
    this.consecutiveRelapseAttempts = 0,
    this.userRequestedHumanCoach = false,
  });

  final List<ActiveRisk> activeRisks;
  final int plateauWeeks;
  final bool adaptiveCaloriesAlreadyAdjusted;
  final int consecutiveRelapseAttempts;
  final bool userRequestedHumanCoach;
}

class CoachEscalationService {
  bool shouldEscalate(UserState state) {
    // 1. Medical complexity beyond AI coaching scope
    if (state.activeRisks.any((r) => r.severity == RiskSeverity.high)) {
      return true;
    }
    // 2. Plateau unresolved after Adaptive Metabolism correction for 4+ weeks
    if (state.plateauWeeks >= 4 && state.adaptiveCaloriesAlreadyAdjusted) {
      return true;
    }
    // 3. Psychological distress signals (consecutive relapse attempts >= 3)
    if (state.consecutiveRelapseAttempts >= 3) {
      return true;
    }
    // 4. User explicitly requests human review
    if (state.userRequestedHumanCoach) {
      return true;
    }
    return false;
  }

  Future<String> buildCoachBriefing(
    String userId,
    String reason,
    AppDatabase db,
  ) async {
    final user = await (db.select(
      db.users,
    )..where((t) => t.id.equals(userId))).getSingleOrNull();
    final name = user?.name ?? "User";
    final goals = user?.goals ?? "[]";
    final program = user?.currentProgram ?? "Corporate Fat Loss";

    // Retrieve latest recovery logs to calculate metrics
    final logs = await db.getRecoveryLogs(userId);
    final double initialWeight = user?.weight ?? 75.0;
    final double currentWeight = initialWeight;
    int recoveryDebtMinutes = 0;
    final int adherenceScore = 60; // default adherence fallback

    if (logs.isNotEmpty) {
      int totalSleepMinutes = 0;
      for (final log in logs.take(7)) {
        totalSleepMinutes += log.sleepPerformanceScore;
      }
      recoveryDebtMinutes = (480 * logs.length) - totalSleepMinutes;
    }

    final recentMessages = await db.select(db.chatMessages).get();
    final recentConversation = recentMessages
        .take(10)
        .map((m) => "${m.senderType.toUpperCase()}: ${m.messageContent}")
        .join("\n");

    final buffer = StringBuffer();
    buffer.writeln("Coach Briefing — $name");
    buffer.writeln("━━━━━━━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln("");
    buffer.writeln("Goal:         $goals");
    buffer.writeln("Program:      $program");
    buffer.writeln("");
    buffer.writeln("Current Status:");
    buffer.writeln(
      "  Weight:              ${currentWeight.toStringAsFixed(1)} kg",
    );
    buffer.writeln("  Adherence:           Avg $adherenceScore%");
    buffer.writeln(
      "  Recovery Debt:       ${recoveryDebtMinutes > 0 ? '$recoveryDebtMinutes min deficit' : 'Healthy'}",
    );
    buffer.writeln("");
    buffer.writeln("Escalation Reason:");
    buffer.writeln("  $reason");
    buffer.writeln("");
    buffer.writeln("AI Coach Notes (recent conversation):");
    buffer.writeln(
      recentConversation.isNotEmpty
          ? recentConversation
          : "No recent chat history.",
    );

    return buffer.toString();
  }

  Future<void> escalate({
    required String userId,
    required String reason,
    required AppDatabase db,
  }) async {
    final briefing = await buildCoachBriefing(userId, reason, db);

    // Save escalation event to DB
    await db.saveEscalationEvent(
      EscalationEventsCompanion.insert(
        userId: userId,
        reason: reason,
        briefing: briefing,
        escalatedAt: DateTime.now(),
      ),
    );
  }
}
