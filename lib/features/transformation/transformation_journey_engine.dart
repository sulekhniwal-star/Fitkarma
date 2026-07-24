/// §P8-A Transformation Journey Engine
///
/// Implements journey-stage detection logic, consistency tracking, relapse intervention rules,
/// 90-day forecast ranges, and TransformationMemory models matching §P8-A specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Models (§P8-A Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum JourneyStage {
  /// Days 0 to 7: Initial onboarding & foundation setting
  onboarding('Onboarding & Foundation', 1, 7),

  /// Days 8 to 30: Building initial habits & momentum
  momentum('Habit Momentum', 8, 30),

  /// Days 31 to 60: Physiological adaptation phase
  adaptation('Physiological Adaptation', 31, 60),

  /// Days 61 to 90: Deep transformation phase
  transformation('Active Transformation', 61, 90),

  /// Days 91+: Long-term mastery & lifestyle maintenance
  mastery('Lifestyle Mastery', 91, 9999);

  const JourneyStage(this.displayName, this.minDays, this.maxDays);

  final String displayName;
  final int minDays;
  final int maxDays;
}

enum ConsistencyStatus {
  /// Low relapse risk score (0-1)
  strong('Strong Consistency', '🔥 You are in the zone! Keeping up great momentum.'),

  /// Moderate relapse risk score (2-3)
  moderate('Moderate Consistency', '⚠️ Minor friction detected. Focus on small daily wins.'),

  /// High relapse risk score (>= 4)
  highRelapse('High Relapse Risk', '🚨 Consistency drop detected. Activating Anti-Quit protocol.');

  const ConsistencyStatus(this.displayName, this.coachingSummary);

  final String displayName;
  final String coachingSummary;
}

class UserBehaviorSignals {
  const UserBehaviorSignals({
    required this.appOpenFrequencyDropping,
    required this.workoutsMissedInARow,
    required this.junkFoodLoggedDaysInARow,
    required this.sleepDecliningDaysInARow,
    required this.daysSinceLastAppOpen,
    required this.motivationRating, // 1 to 5
  });

  factory UserBehaviorSignals.healthy() => const UserBehaviorSignals(
        appOpenFrequencyDropping: false,
        workoutsMissedInARow: 0,
        junkFoodLoggedDaysInARow: 0,
        sleepDecliningDaysInARow: 0,
        daysSinceLastAppOpen: 0,
        motivationRating: 5,
      );

  final bool appOpenFrequencyDropping;
  final int workoutsMissedInARow;
  final int junkFoodLoggedDaysInARow;
  final int sleepDecliningDaysInARow;
  final int daysSinceLastAppOpen;
  final int motivationRating;
}

class RelapseIntervention {
  const RelapseIntervention({
    required this.daysInactive,
    required this.title,
    required this.message,
    required this.actionPlan,
  });

  final int daysInactive;
  final String title;
  final String message;
  final String actionPlan;
}

class WeightCheckpoint {
  const WeightCheckpoint({
    required this.date,
    required this.weightKg,
  });

  final DateTime date;
  final double weightKg;
}

class TransformationMemory {
  const TransformationMemory({
    required this.weightHistory,
    required this.majorStruggles,
    required this.injuries,
    required this.successPatterns,
    required this.motivationTriggers,
    required this.quitAttempts,
    required this.primaryPersonality,
  });

  factory TransformationMemory.initial() => const TransformationMemory(
        weightHistory: [],
        majorStruggles: ['Evening snacking in initial 3 weeks'],
        injuries: [],
        successPatterns: ['Tuesdays & Thursdays: Highest workout compliance'],
        motivationTriggers: ['Health milestone goal'],
        quitAttempts: [],
        primaryPersonality: 'Data-driven',
      );

  final List<WeightCheckpoint> weightHistory;
  final List<String> majorStruggles;
  final List<String> injuries;
  final List<String> successPatterns;
  final List<String> motivationTriggers;
  final List<String> quitAttempts;
  final String primaryPersonality;
}

class TransformationForecast {
  const TransformationForecast({
    required this.currentWeightKg,
    required this.projectedMinKg,
    required this.projectedMaxKg,
    required this.adherenceFactorPercent,
  });

  final double currentWeightKg;
  final double projectedMinKg;
  final double projectedMaxKg;
  final double adherenceFactorPercent;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementations
// ─────────────────────────────────────────────────────────────────────────────

class ConsistencyTracker {
  const ConsistencyTracker();

  /// Analyzes behavioral signals and calculates a risk score (0 to 6).
  ConsistencyStatus analyze(UserBehaviorSignals data) {
    final signals = [
      data.appOpenFrequencyDropping,
      data.workoutsMissedInARow >= 3,
      data.junkFoodLoggedDaysInARow >= 4,
      data.sleepDecliningDaysInARow >= 5,
      data.daysSinceLastAppOpen >= 2,
      data.motivationRating < 3,
    ];

    final riskScore = signals.where((s) => s).length;
    if (riskScore >= 4) return ConsistencyStatus.highRelapse;
    if (riskScore >= 2) return ConsistencyStatus.moderate;
    return ConsistencyStatus.strong;
  }
}

class RelapseInterventionEngine {
  const RelapseInterventionEngine();

  /// Selects the appropriate anti-quit intervention message based on days inactive.
  ///
  /// §P8-A Specification:
  /// - Day 1: Gentle Nudge ("A 10-minute walk today counts as a win.")
  /// - Day 2: Plan Adjustment ("Switched to Lite Plan for 3 days — 20-min workouts.")
  /// - Day 3: Emergency Reframe ("Missing workouts doesn't erase your streak.")
  /// - Day 5+: Squad Connection ("Your squad member logged a workout today!")
  RelapseIntervention getIntervention(int daysInactive) {
    if (daysInactive <= 1) {
      return const RelapseIntervention(
        daysInactive: 1,
        title: 'Day 1 — Gentle Nudge',
        message: "You've been quieter than usual this week. No pressure — let's restart with something small.",
        actionPlan: 'A 10-minute walk today counts as a win.',
      );
    } else if (daysInactive == 2) {
      return const RelapseIntervention(
        daysInactive: 2,
        title: 'Day 2 — Plan Adjustment',
        message: "I've switched you to the Lite Plan for 3 days — 20-min workouts, no calorie counting.",
        actionPlan: 'Just show up.',
      );
    } else if (daysInactive <= 4) {
      return const RelapseIntervention(
        daysInactive: 3,
        title: 'Day 3 — Emergency Reframe',
        message: "Missing workouts doesn't erase your progress last month.",
        actionPlan: 'That version of you still exists.',
      );
    } else {
      return const RelapseIntervention(
        daysInactive: 5,
        title: 'Day 5 — Squad Connection',
        message: 'Your squad member logged a workout today!',
        actionPlan: 'Tap to connect with your squad for accountability.',
      );
    }
  }
}

class TransformationJourneyEngine {
  const TransformationJourneyEngine();

  static const tracker = ConsistencyTracker();
  static const interventionEngine = RelapseInterventionEngine();

  /// Resolves the user's journey stage based on days active in the program.
  JourneyStage detectStage(int daysActive) {
    if (daysActive <= 7) return JourneyStage.onboarding;
    if (daysActive <= 30) return JourneyStage.momentum;
    if (daysActive <= 60) return JourneyStage.adaptation;
    if (daysActive <= 90) return JourneyStage.transformation;
    return JourneyStage.mastery;
  }

  /// Calculates the 90-day weight forecast range bounds (min & max shaded channel).
  ///
  /// Formula (§P8-A spec):
  /// Ideal loss in 90 days = 6.43 kg (0.5 kg/week)
  /// Actual loss = 6.43 * (adherence / 100)
  /// Min = currentWeight - actualLoss - 1.5 kg
  /// Max = currentWeight - actualLoss + 1.5 kg
  TransformationForecast calculateForecast({
    required double currentWeightKg,
    required double adherenceScorePercent,
  }) {
    final adherenceFactor = (adherenceScorePercent / 100.0).clamp(0.0, 1.0);
    const idealLossIn90Days = 6.43; // (0.5kg / 7 days) * 90 days
    final actualLossProjection = idealLossIn90Days * adherenceFactor;

    final minKg = currentWeightKg - actualLossProjection - 1.5;
    final maxKg = currentWeightKg - actualLossProjection + 1.5;

    return TransformationForecast(
      currentWeightKg: currentWeightKg,
      projectedMinKg: double.parse(minKg.toStringAsFixed(1)),
      projectedMaxKg: double.parse(maxKg.toStringAsFixed(1)),
      adherenceFactorPercent: adherenceScorePercent,
    );
  }
}
