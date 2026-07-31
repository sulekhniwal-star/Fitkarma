import 'daily_intelligence_package.dart';
import 'readiness_engine.dart';
import 'decision_hierarchy.dart';

/// Health OS Brain — The central decision engine for FitKarma.
/// Orchestrates inputs from wearables, sleep, readiness, and nutrition
/// to generate a single Daily Intelligence Package (DIP) each morning.
class HealthOsBrain {
  final ReadinessEngine readinessEngine;
  final DecisionHierarchy decisionHierarchy;

  const HealthOsBrain({
    this.readinessEngine = const ReadinessEngine(),
    this.decisionHierarchy = const DecisionHierarchy(),
  });

  /// Orchestrates all sub-engines to compute the Daily Intelligence Package (DIP)
  DailyIntelligencePackage generateDailyPackage({
    required String userId,
    required DateTime date,
    required MorningCheckIn checkIn,
    double? sleepHours,
    double? hrvRatio,
    bool illnessAlarmTriggered = false,
    required List<String> availableMissions,
  }) {
    // 1. Compute Readiness Score and Tier
    final readinessResult = readinessEngine.calculateReadiness(
      checkIn: checkIn,
      sleepHours: sleepHours,
      hrvRatio: hrvRatio,
    );

    // 2. Evaluate Decision Hierarchy for Primary Focus & Safety Alerts
    final actions = decisionHierarchy.resolveActions(
      readinessScore: readinessResult.score,
      illnessAlarmTriggered: illnessAlarmTriggered,
    );

    final primaryFocus = actions.isNotEmpty ? actions.first.title : 'Maintain Baseline Habits';

    // 3. Formulate Daily Missions tailored to primary focus
    final activeMissions = availableMissions.take(3).toList();

    return DailyIntelligencePackage(
      userId: userId,
      date: date,
      readinessScore: readinessResult.score,
      readinessTier: readinessResult.tier,
      primaryFocus: primaryFocus,
      dailyMissions: activeMissions,
    );
  }
}
