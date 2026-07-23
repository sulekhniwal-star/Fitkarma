/// §P5-J Nutrition Adherence Engine & §P7-A Karma System
///
/// Pure-Dart adherence scoring matrix (Calorie 30pts, Protein 35pts, Logging 20pts, Timing 15pts),
/// 0–100 daily score calculation, and Karma Points reward engine with streak multipliers.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Customary median time for a meal type.
class MealTimeMedian {
  const MealTimeMedian({
    required this.mealType,
    required this.hour,
    required this.minute,
  });

  final String mealType;
  final int hour;
  final int minute;
}

/// Logged meal timing record.
class MealLogRecord {
  const MealLogRecord({
    required this.mealType,
    required this.loggedAt,
  });

  final String mealType;
  final DateTime loggedAt;
}

/// Detailed component score breakdown output from [NutritionAdherenceEngine].
class AdherenceScoreBreakdown {
  const AdherenceScoreBreakdown({
    required this.calorieScore,
    required this.proteinScore,
    required this.loggingScore,
    required this.timingScore,
    required this.totalScore,
    required this.summaryFeedback,
  });

  final double calorieScore; // Max 30.0
  final double proteinScore; // Max 35.0
  final double loggingScore; // Max 20.0
  final double timingScore;  // Max 15.0
  final double totalScore;   // Max 100.0
  final String summaryFeedback;
}

/// Karma System (§P7-A) award payload.
class KarmaAwardResult {
  const KarmaAwardResult({
    required this.basePoints,
    required this.streakMultiplier,
    required this.totalKarmaAwarded,
    required this.tierName,
  });

  final int basePoints;
  final double streakMultiplier;
  final int totalKarmaAwarded;
  final String tierName;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class NutritionAdherenceEngine {
  const NutritionAdherenceEngine();

  /// Default customary meal time medians (Breakfast 8:30 AM, Lunch 1:30 PM, Dinner 8:30 PM).
  static const List<MealTimeMedian> defaultMedians = [
    MealTimeMedian(mealType: 'Breakfast', hour: 8, minute: 30),
    MealTimeMedian(mealType: 'Lunch', hour: 13, minute: 30),
    MealTimeMedian(mealType: 'Dinner', hour: 20, minute: 30),
  ];

  /// Calculates 0–100 daily adherence score based on calories, protein, meal count, and timing.
  AdherenceScoreBreakdown calculateDailyScore({
    required int loggedCalories,
    required int targetCalories,
    required int loggedProteinG,
    required int targetProteinG,
    required int mealsLoggedCount,
    required List<MealLogRecord> mealRecords,
    List<MealTimeMedian> historicalMedians = defaultMedians,
  }) {
    // 1. Calorie Adherence (Max 30 points)
    // Award 30 pts within +-10%, scaling down to 0 at +-25%
    double calorieScore = 0.0;
    if (targetCalories > 0) {
      final calDelta = (loggedCalories - targetCalories).abs() / targetCalories;
      if (calDelta <= 0.10) {
        calorieScore = 30.0;
      } else if (calDelta <= 0.25) {
        calorieScore = 30.0 * (1.0 - ((calDelta - 0.10) / 0.15));
      }
    }

    // 2. Protein Adherence (Max 35 points)
    // Award 35 pts within +-15%, scaling down to 0 at +-30%
    double proteinScore = 0.0;
    if (targetProteinG > 0) {
      final proDelta = (loggedProteinG - targetProteinG).abs() / targetProteinG;
      if (proDelta <= 0.15) {
        proteinScore = 35.0;
      } else if (proDelta <= 0.30) {
        proteinScore = 35.0 * (1.0 - ((proDelta - 0.15) / 0.15));
      }
    }

    // 3. Logging Completeness (Max 20 points)
    // 3+ meals = 20 pts, 2 meals = 12 pts, 1 meal = 6 pts
    double loggingScore = 0.0;
    if (mealsLoggedCount >= 3) {
      loggingScore = 20.0;
    } else if (mealsLoggedCount == 2) {
      loggingScore = 12.0;
    } else if (mealsLoggedCount == 1) {
      loggingScore = 6.0;
    }

    // 4. Meal Timing Stability (Max 15 points)
    // Award 15 pts if >= 2 meals logged within +-60 minutes of historical medians
    double timingScore = 0.0;
    int onTimeCount = 0;
    for (final meal in mealRecords) {
      final median = historicalMedians.firstWhere(
        (m) => m.mealType.toLowerCase() == meal.mealType.toLowerCase(),
        orElse: () => MealTimeMedian(mealType: meal.mealType, hour: 12, minute: 0),
      );
      final mealMinuteOfDay = meal.loggedAt.hour * 60 + meal.loggedAt.minute;
      final medianMinuteOfDay = median.hour * 60 + median.minute;
      if ((mealMinuteOfDay - medianMinuteOfDay).abs() <= 60) {
        onTimeCount++;
      }
    }
    if (onTimeCount >= 2 || (mealRecords.length == 1 && onTimeCount == 1)) {
      timingScore = 15.0;
    }

    final totalScore = double.parse(
      (calorieScore + proteinScore + loggingScore + timingScore)
          .clamp(0.0, 100.0)
          .toStringAsFixed(1),
    );

    String feedback = 'Consistency beats perfection! ';
    if (totalScore >= 90.0) {
      feedback += 'Flawless adherence! Calorie & protein targets locked in.';
    } else if (totalScore >= 75.0) {
      feedback += 'Great consistency today! Keep your meal logging complete.';
    } else if (totalScore >= 50.0) {
      feedback += 'Solid effort! Focus on evening protein to boost recovery.';
    } else {
      feedback += 'Keep logging regularly to help calibrate your metabolic model.';
    }

    return AdherenceScoreBreakdown(
      calorieScore: double.parse(calorieScore.toStringAsFixed(1)),
      proteinScore: double.parse(proteinScore.toStringAsFixed(1)),
      loggingScore: double.parse(loggingScore.toStringAsFixed(1)),
      timingScore: double.parse(timingScore.toStringAsFixed(1)),
      totalScore: totalScore,
      summaryFeedback: feedback,
    );
  }

  /// Calculates Karma System (§P7-A) award based on adherence score & streak days.
  KarmaAwardResult calculateKarmaAward(double adherenceScore, int currentStreakDays) {
    int basePoints = 5;
    String tier = 'Effort Logged';

    if (adherenceScore >= 90.0) {
      basePoints = 50;
      tier = 'Mastery Day';
    } else if (adherenceScore >= 75.0) {
      basePoints = 35;
      tier = 'Consistency Hero';
    } else if (adherenceScore >= 50.0) {
      basePoints = 20;
      tier = 'Solid Progress';
    }

    double multiplier = 1.0;
    if (currentStreakDays >= 7) {
      multiplier = 1.5;
    } else if (currentStreakDays >= 3) {
      multiplier = 1.2;
    }

    final totalAward = (basePoints * multiplier).round();

    return KarmaAwardResult(
      basePoints: basePoints,
      streakMultiplier: multiplier,
      totalKarmaAwarded: totalAward,
      tierName: tier,
    );
  }
}
