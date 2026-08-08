enum AdherenceTrend { improving, steady, declining }

class FoodLogItem {
  final double proteinG;
  final double calories;
  final DateTime date;

  const FoodLogItem({
    required this.proteinG,
    required this.calories,
    required this.date,
  });
}

class WorkoutLogItem {
  final double completionPercent; // 0 to 100
  final DateTime date;

  const WorkoutLogItem({
    required this.completionPercent,
    required this.date,
  });
}

class RecoveryLogItem {
  final int sleepDurationMin;
  final bool checkedIn;
  final DateTime date;

  const RecoveryLogItem({
    required this.sleepDurationMin,
    required this.checkedIn,
    required this.date,
  });
}

class UserTargets {
  final double proteinG;
  final double calories;
  final int workoutsPerWeek;

  const UserTargets({
    required this.proteinG,
    required this.calories,
    required this.workoutsPerWeek,
  });
}

class AdherenceResult {
  final int nutritionScore; // 0-100
  final int trainingScore;  // 0-100
  final int recoveryScore;  // 0-100
  final int overallScore;   // 0-100
  final AdherenceTrend trend;
  final String period;
  final String weakestArea;
  final String coachingTip;
  final double xpMultiplier; // 1.5 for 90-100%, 1.0 for 80-89%, 1.0 for 70-79%, 1.0 for <70%
  final bool triggersCoachCheckIn; // true if < 70%

  const AdherenceResult({
    required this.nutritionScore,
    required this.trainingScore,
    required this.recoveryScore,
    required this.overallScore,
    required this.trend,
    required this.period,
    required this.weakestArea,
    required this.coachingTip,
    required this.xpMultiplier,
    required this.triggersCoachCheckIn,
  });
}

/// Pure-Dart Adherence Score Calculator per §P7-D spec
class AdherenceScoreCalculator {
  const AdherenceScoreCalculator();

  AdherenceResult calculate({
    required List<FoodLogItem> foodLogs,       // last 7 days
    required List<WorkoutLogItem> workoutLogs, // last 7 days
    required List<RecoveryLogItem> recoveryLogs,
    required UserTargets targets,
    int previousOverallScore = 79,
  }) {
    // 1. Nutrition Adherence: days protein >= 80% target & calories within 85%-115% target
    final nutritionDays = foodLogs.where((l) {
      final isProteinMet = l.proteinG >= (targets.proteinG * 0.80);
      final isCalorieBalanced = l.calories >= (targets.calories * 0.85) && l.calories <= (targets.calories * 1.15);
      return isProteinMet && isCalorieBalanced;
    }).length;

    final nutritionScore = ((nutritionDays / 7.0) * 100.0).clamp(0.0, 100.0).round();

    // 2. Training Adherence: workouts completed (completionPercent >= 80) vs. planned
    final plannedWorkouts = targets.workoutsPerWeek > 0 ? targets.workoutsPerWeek : 1;
    final completedWorkouts = workoutLogs.where((l) => l.completionPercent >= 80.0).length;
    final trainingScore = ((completedWorkouts / plannedWorkouts.toDouble()) * 100.0).clamp(0.0, 100.0).round();

    // 3. Recovery Adherence: days sleep >= 7h (420 min) and checked in
    final recoveryDays = recoveryLogs.where((l) => l.sleepDurationMin >= 420 && l.checkedIn).length;
    final recoveryScore = ((recoveryDays / 7.0) * 100.0).clamp(0.0, 100.0).round();

    // 4. Overall Score = 40% Nutrition + 40% Training + 20% Recovery
    final overallScore = ((nutritionScore * 0.40) + (trainingScore * 0.40) + (recoveryScore * 0.20)).round();

    // 5. Weakest Area & Tip Resolution
    String weakest = 'Nutrition';
    String tip = 'Log balanced meals with at least 80% of your protein target.';
    if (trainingScore <= nutritionScore && trainingScore <= recoveryScore) {
      weakest = 'Training';
      tip = 'Add one more workout this week to hit your planned target.';
    } else if (recoveryScore <= nutritionScore && recoveryScore <= trainingScore) {
      weakest = 'Recovery';
      tip = 'Prioritize 7+ hours of sleep and daily morning check-ins.';
    }

    // 6. Trend Resolution
    AdherenceTrend trend = AdherenceTrend.steady;
    if (overallScore > previousOverallScore + 2) {
      trend = AdherenceTrend.improving;
    } else if (overallScore < previousOverallScore - 2) {
      trend = AdherenceTrend.declining;
    }

    // 7. Adherence -> XP Connection Multiplier
    double multiplier = 1.0;
    bool coachCheckIn = false;

    if (overallScore >= 90) {
      multiplier = 1.5; // +50% XP multiplier for the week
    } else if (overallScore >= 80) {
      multiplier = 1.0; // standard XP
    } else if (overallScore >= 70) {
      multiplier = 1.0; // gentle nudge
    } else {
      multiplier = 1.0;
      coachCheckIn = true; // < 70%: AI Coach proactive check-in triggered
    }

    return AdherenceResult(
      nutritionScore: nutritionScore,
      trainingScore: trainingScore,
      recoveryScore: recoveryScore,
      overallScore: overallScore,
      trend: trend,
      period: 'Last 7 days',
      weakestArea: weakest,
      coachingTip: tip,
      xpMultiplier: multiplier,
      triggersCoachCheckIn: coachCheckIn,
    );
  }
}
