class DailyAdherenceSample {
  final String dayName;
  final int targetCalories;
  final int consumedCalories;
  final int targetProtein;
  final int consumedProtein;
  final bool isShieldApplied;

  const DailyAdherenceSample({
    required this.dayName,
    required this.targetCalories,
    required this.consumedCalories,
    required this.targetProtein,
    required this.consumedProtein,
    this.isShieldApplied = false,
  });

  int get calorieVariance => consumedCalories - targetCalories;
  bool get isWithinCaloricTolerance => (calorieVariance.abs() / targetCalories) <= 0.10;
  bool get isProteinGoalMet => consumedProtein >= (targetProtein * 0.90);
}

class AdherenceReport {
  final int weeklyAdherenceScore; // 0 to 100
  final int currentStreakDays;
  final int availableShieldsCount;
  final List<DailyAdherenceSample> weekHistory;
  final String compassionateFeedback;
  final double weeklyCaloricDeficitOrSurplus;

  const AdherenceReport({
    required this.weeklyAdherenceScore,
    required this.currentStreakDays,
    required this.availableShieldsCount,
    required this.weekHistory,
    required this.compassionateFeedback,
    required this.weeklyCaloricDeficitOrSurplus,
  });
}

class NutritionAdherenceEngine {
  /// Pure Dart deterministic calculation of weekly nutrition consistency & streak resilience
  static AdherenceReport evaluateWeeklyAdherence(List<DailyAdherenceSample> samples) {
    if (samples.isEmpty) {
      return const AdherenceReport(
        weeklyAdherenceScore: 100,
        currentStreakDays: 1,
        availableShieldsCount: 1,
        weekHistory: [],
        compassionateFeedback: 'Start logging daily meals to activate nutritional adherence tracking.',
        weeklyCaloricDeficitOrSurplus: 0.0,
      );
    }

    double totalCalScore = 0;
    double totalProtScore = 0;
    int streak = 0;
    int netVariance = 0;

    for (final sample in samples) {
      netVariance += sample.calorieVariance;

      if (sample.isShieldApplied) {
        totalCalScore += 100;
        totalProtScore += 100;
        streak++;
        continue;
      }

      // 1. Calorie variance scoring (40% weight)
      final calVariancePct = (sample.calorieVariance.abs() / sample.targetCalories);
      if (calVariancePct <= 0.10) {
        totalCalScore += 100;
      } else if (calVariancePct <= 0.20) {
        totalCalScore += 70;
      } else {
        totalCalScore += 40;
      }

      // 2. Protein goal scoring (40% weight)
      if (sample.isProteinGoalMet) {
        totalProtScore += 100;
      } else if (sample.consumedProtein >= (sample.targetProtein * 0.75)) {
        totalProtScore += 70;
      } else {
        totalProtScore += 40;
      }

      // Streak logic
      if (calVariancePct <= 0.15 || sample.isProteinGoalMet) {
        streak++;
      }
    }

    final avgCal = totalCalScore / samples.length;
    final avgProt = totalProtScore / samples.length;
    const logConsistencyScore = 100.0; // 20% weight

    final compositeScore = ((avgCal * 0.40) + (avgProt * 0.40) + (logConsistencyScore * 0.20)).round().clamp(0, 100);

    final String feedback;
    if (compositeScore >= 85) {
      feedback = 'Outstanding adherence! Your consistent protein delivery and balanced caloric variance keep your metabolism primed for body recomposition.';
    } else if (compositeScore >= 70) {
      feedback = 'Solid consistency across the week. Focus on narrowing evening caloric swings to maximize fat loss.';
    } else {
      feedback = 'Compassionate reminder: A single heavy meal or family dinner never derails progress. Your weekly average matters far more than daily perfection.';
    }

    return AdherenceReport(
      weeklyAdherenceScore: compositeScore,
      currentStreakDays: streak,
      availableShieldsCount: 1,
      weekHistory: samples,
      compassionateFeedback: feedback,
      weeklyCaloricDeficitOrSurplus: netVariance.toDouble(),
    );
  }
}
