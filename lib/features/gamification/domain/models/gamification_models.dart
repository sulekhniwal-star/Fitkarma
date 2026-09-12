enum KarmaActionType {
  workoutCompleted,
  mealLogged,
  stepsTargetHit,
  sleepTargetMet,
  dailyBriefingDone,
  sorenessLogged,
  fastingGoalCompleted,
}

enum KarmaTier {
  novice, // 0 - 499 pts
  sadhak, // 500 - 1,499 pts (Practitioner)
  abhyasi, // 1,500 - 3,499 pts (Dedicated)
  yogi, // 3,500 - 6,999 pts (Mastery)
  guru, // 7,000+ pts (Enlightened Master)
}

class KarmaTierInfo {
  final KarmaTier tier;
  final String title;
  final String titleHindi;
  final int minPoints;
  final int maxPoints;
  final double multiplier;

  const KarmaTierInfo({
    required this.tier,
    required this.title,
    required this.titleHindi,
    required this.minPoints,
    required this.maxPoints,
    required this.multiplier,
  });
}

class KarmaTransaction {
  final String id;
  final String userId;
  final int points;
  final KarmaActionType actionType;
  final String description;
  final String descriptionHindi;
  final DateTime earnedAt;

  const KarmaTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.actionType,
    required this.description,
    required this.descriptionHindi,
    required this.earnedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'points': points,
        'action_type': actionType.name,
        'description': description,
        'description_hindi': descriptionHindi,
        'earned_at': earnedAt.toIso8601String(),
      };
}

class HabitStreak {
  final String id;
  final String userId;
  final String habitType; // 'daily_log', 'workout', 'steps', 'sleep'
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActiveDate;

  const HabitStreak({
    required this.id,
    required this.userId,
    required this.habitType,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActiveDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'habit_type': habitType,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_active_date': lastActiveDate.toIso8601String(),
      };
}

class AdherenceBreakdown {
  final int overallScore; // 0 to 100
  final int nutritionScore; // 0 to 100 (25% weight)
  final int workoutScore; // 0 to 100 (35% weight)
  final int stepsScore; // 0 to 100 (20% weight)
  final int sleepScore; // 0 to 100 (20% weight)
  final String summary;
  final String summaryHindi;

  const AdherenceBreakdown({
    required this.overallScore,
    required this.nutritionScore,
    required this.workoutScore,
    required this.stepsScore,
    required this.sleepScore,
    required this.summary,
    required this.summaryHindi,
  });
}

class CohortBenchmarkResult {
  final String cohortName; // e.g. "Indian Males 25-34"
  final double volumePercentile; // e.g. Top 15% (85.0)
  final double stepsPercentile;
  final double adherencePercentile;
  final String insight;
  final String insightHindi;

  const CohortBenchmarkResult({
    required this.cohortName,
    required this.volumePercentile,
    required this.stepsPercentile,
    required this.adherencePercentile,
    required this.insight,
    required this.insightHindi,
  });
}
