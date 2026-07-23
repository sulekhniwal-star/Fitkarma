/// §P7-D Adherence Score Calculator (Major KPI)
///
/// Pure Dart deterministic calculation of plan execution adherence matching
/// §P7-D specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Input Models
// ─────────────────────────────────────────────────────────────────────────────

class FoodLogSimple {
  const FoodLogSimple({
    required this.date,
    required this.proteinG,
    required this.calories,
  });

  final DateTime date;
  final double proteinG;
  final double calories;
}

class WorkoutLogSimple {
  const WorkoutLogSimple({
    required this.date,
    required this.completionPercent,
  });

  final DateTime date;
  final double completionPercent;
}

class RecoveryLogSimple {
  const RecoveryLogSimple({
    required this.date,
    required this.sleepDurationMin,
    required this.checkedIn,
  });

  final DateTime date;
  final int sleepDurationMin;
  final bool checkedIn;
}

class UserTargets {
  const UserTargets({
    required this.proteinG,
    required this.calories,
    required this.workoutsPerWeek,
  });

  final double proteinG;
  final double calories;
  final int workoutsPerWeek;
}

// ─────────────────────────────────────────────────────────────────────────────
// Output Model (§P7-D Specification)
// ─────────────────────────────────────────────────────────────────────────────

enum AdherenceTrend {
  improving('📈 Improving'),
  stable('➡️ Stable'),
  declining('📉 Declining');

  const AdherenceTrend(this.displayName);

  final String displayName;
}

class AdherenceResult {
  const AdherenceResult({
    required this.nutritionScore,
    required this.trainingScore,
    required this.recoveryScore,
    required this.overallScore,
    required this.trend,
    required this.period,
  });

  factory AdherenceResult.defaultScore() => const AdherenceResult(
        nutritionScore: 85,
        trainingScore: 90,
        recoveryScore: 80,
        overallScore: 86,
        trend: AdherenceTrend.improving,
        period: 'Last 7 days',
      );

  final int nutritionScore;
  final int trainingScore;
  final int recoveryScore;
  final int overallScore;
  final AdherenceTrend trend;
  final String period;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine
// ─────────────────────────────────────────────────────────────────────────────

class AdherenceScoreCalculator {
  const AdherenceScoreCalculator();

  /// Calculates adherence scores from last 7 days of logs.
  ///
  /// §P7-D Specification:
  /// - Nutrition Adherence (40%): Days protein ≥ 80% target & calories within 85-115% target.
  /// - Training Adherence (40%): Workouts completed (completion ≥ 80%) vs planned.
  /// - Recovery Adherence (20%): Days sleep ≥ 7h (420 min) & readiness check-in completed.
  /// - Overall: (Nutrition × 0.40) + (Training × 0.40) + (Recovery × 0.20).
  AdherenceResult calculate({
    required List<FoodLogSimple> foodLogs,
    required List<WorkoutLogSimple> workoutLogs,
    required List<RecoveryLogSimple> recoveryLogs,
    required UserTargets targets,
    int? previousWeekOverallScore,
  }) {
    // 1. Nutrition Adherence
    final minCalories = targets.calories * 0.85;
    final maxCalories = targets.calories * 1.15;
    final minProtein = targets.proteinG * 0.80;

    final nutritionDays = foodLogs.where((l) {
      final isProteinMet = l.proteinG >= minProtein;
      final isCalorieInRange = l.calories >= minCalories && l.calories <= maxCalories;
      return isProteinMet && isCalorieInRange;
    }).length;

    final nutritionScore = foodLogs.isEmpty
        ? 0
        : ((nutritionDays / 7.0) * 100.0).clamp(0.0, 100.0).round();

    // 2. Training Adherence
    final completedWorkouts = workoutLogs.where((l) => l.completionPercent >= 80.0).length;
    final plannedWorkouts = targets.workoutsPerWeek > 0 ? targets.workoutsPerWeek : 1;
    final trainingScore = ((completedWorkouts / plannedWorkouts.toDouble()) * 100.0)
        .clamp(0.0, 100.0)
        .round();

    // 3. Recovery Adherence
    final recoveryDays = recoveryLogs.where((l) => l.sleepDurationMin >= 420 && l.checkedIn).length;
    final recoveryScore = recoveryLogs.isEmpty
        ? 0
        : ((recoveryDays / 7.0) * 100.0).clamp(0.0, 100.0).round();

    // 4. Overall Weighted Score
    final overallScore = ((nutritionScore * 0.40) +
            (trainingScore * 0.40) +
            (recoveryScore * 0.20))
        .clamp(0.0, 100.0)
        .round();

    // 5. Trend Determination
    AdherenceTrend trend = AdherenceTrend.stable;
    if (previousWeekOverallScore != null) {
      if (overallScore > previousWeekOverallScore + 3) {
        trend = AdherenceTrend.improving;
      } else if (overallScore < previousWeekOverallScore - 3) {
        trend = AdherenceTrend.declining;
      }
    }

    return AdherenceResult(
      nutritionScore: nutritionScore,
      trainingScore: trainingScore,
      recoveryScore: recoveryScore,
      overallScore: overallScore,
      trend: trend,
      period: 'Last 7 days',
    );
  }
}
