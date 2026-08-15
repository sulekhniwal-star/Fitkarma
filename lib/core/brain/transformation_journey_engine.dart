enum ConsistencyStatus { strong, moderate, highRelapse }

enum RelapseTier {
  day1GentleNudge,
  day2PlanAdjustment,
  day3EmergencyReframe,
  day5SquadConnection,
  none,
}

class WeightCheckpoint {
  final double weightKg;
  final DateTime date;

  const WeightCheckpoint({
    required this.weightKg,
    required this.date,
  });
}

class InjuryRecord {
  final String bodyPart; // e.g. "Lower Back"
  final String severity; // "Mild", "Moderate"
  final DateTime reportedDate;

  const InjuryRecord({
    required this.bodyPart,
    required this.severity,
    required this.reportedDate,
  });
}

class TransformationMemory {
  final List<WeightCheckpoint> weightHistory;
  final List<String> majorStruggles; // e.g. ["Evening snacking, 3 weeks"]
  final List<InjuryRecord> injuries;
  final List<String> successPatterns; // e.g. ["Tuesdays: highest compliance"]
  final List<String>
      motivationTriggers; // e.g. ["Wedding countdown", "squad fire"]
  final List<String> quitAttempts; // For relapse pattern modeling
  final String
      primaryPersonality; // Competitive / Routine / Social / Data-driven

  const TransformationMemory({
    required this.weightHistory,
    required this.majorStruggles,
    required this.injuries,
    required this.successPatterns,
    required this.motivationTriggers,
    required this.quitAttempts,
    required this.primaryPersonality,
  });

  factory TransformationMemory.initial() {
    final now = DateTime.now();
    return TransformationMemory(
      weightHistory: [
        WeightCheckpoint(
            weightKg: 82.0, date: now.subtract(const Duration(days: 90))),
        WeightCheckpoint(
            weightKg: 78.5, date: now.subtract(const Duration(days: 60))),
        WeightCheckpoint(
            weightKg: 75.0, date: now.subtract(const Duration(days: 30))),
        WeightCheckpoint(weightKg: 72.0, date: now),
      ],
      majorStruggles: const ['Evening snacking', 'Weekend travel routines'],
      injuries: [
        InjuryRecord(
            bodyPart: 'Lower Back',
            severity: 'Mild',
            reportedDate: now.subtract(const Duration(days: 45))),
      ],
      successPatterns: const [
        'Morning 7 AM workouts: highest compliance',
        'High protein breakfast prevents cravings'
      ],
      motivationTriggers: const ['Wedding countdown', 'Squad fire streak'],
      quitAttempts: const ['Quit in Week 3 last summer due to travel fatigue'],
      primaryPersonality: 'Routine',
    );
  }
}

class UserBehaviorData {
  final bool appOpenFrequencyDropping;
  final int workoutsMissedInARow;
  final int junkFoodLoggedDaysInARow;
  final bool sleepDecliningFor5Days;
  final int daysSinceLastAppOpen;
  final int motivationRating; // 1 to 5

  const UserBehaviorData({
    required this.appOpenFrequencyDropping,
    required this.workoutsMissedInARow,
    required this.junkFoodLoggedDaysInARow,
    required this.sleepDecliningFor5Days,
    required this.daysSinceLastAppOpen,
    required this.motivationRating,
  });
}

class RelapseIntervention {
  final RelapseTier tier;
  final String title;
  final String message;
  final String recommendedAction;

  const RelapseIntervention({
    required this.tier,
    required this.title,
    required this.message,
    required this.recommendedAction,
  });
}

/// Pure-Dart Transformation Journey Engine per §P8-A spec
class TransformationJourneyEngine {
  const TransformationJourneyEngine();

  /// Consistency Tracker: calculates relapse risk score from 6 behavioural signals
  ConsistencyStatus analyzeConsistency(UserBehaviorData data) {
    final signals = [
      data.appOpenFrequencyDropping,
      data.workoutsMissedInARow >= 3,
      data.junkFoodLoggedDaysInARow >= 4,
      data.sleepDecliningFor5Days,
      data.daysSinceLastAppOpen >= 2,
      data.motivationRating < 3,
    ];

    final riskScore = signals.where((s) => s).length;
    if (riskScore >= 4) return ConsistencyStatus.highRelapse;
    if (riskScore >= 2) return ConsistencyStatus.moderate;
    return ConsistencyStatus.strong;
  }

  /// Relapse Intervention System: returns tailored intervention for all 4 tiers based on missed days
  RelapseIntervention getRelapseIntervention({
    required int consecutiveMissedDays,
    String squadMemberName = 'Priya',
    int previousStreakDays = 12,
  }) {
    if (consecutiveMissedDays >= 5) {
      return RelapseIntervention(
        tier: RelapseTier.day5SquadConnection,
        title: '👥 Squad Connection Nudge',
        message:
            'Your squad member $squadMemberName logged a workout today — want to send her a 🔥?',
        recommendedAction: 'Send 🔥 Squad Cheer',
      );
    } else if (consecutiveMissedDays >= 3) {
      return RelapseIntervention(
        tier: RelapseTier.day3EmergencyReframe,
        title: '🔥 Emergency Mindset Reframe',
        message:
            'Missing workouts doesn\'t erase your $previousStreakDays-day streak last month. That version of you still exists.',
        recommendedAction: 'View Past Achievements',
      );
    } else if (consecutiveMissedDays >= 2) {
      return RelapseIntervention(
        tier: RelapseTier.day2PlanAdjustment,
        title: '⚡ 3-Day Lite Plan Switch',
        message:
            'I\'ve switched you to the Lite Plan for 3 days — 20-min workouts, no calorie counting. Just show up.',
        recommendedAction: 'Start 20-Min Lite Workout',
      );
    } else if (consecutiveMissedDays >= 1) {
      return RelapseIntervention(
        tier: RelapseTier.day1GentleNudge,
        title: '🌱 Gentle Restart Nudge',
        message:
            'You\'ve been quieter than usual this week. No pressure — let\'s restart with something small. A 10-minute walk today counts as a win.',
        recommendedAction: 'Log 10-Minute Walk',
      );
    }

    return const RelapseIntervention(
      tier: RelapseTier.none,
      title: 'Strong Momentum',
      message: 'Keep going! Your consistency is strong.',
      recommendedAction: 'Continue Program',
    );
  }
}
