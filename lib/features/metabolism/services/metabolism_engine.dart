enum Gender { male, female, other }
enum Goal { fatLoss, muscleGain, maintenance, athleticPerformance }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

class MetabolicProfile {
  final double bmr;
  final double tdee;
  final double targetCalories;
  final double targetProteinGrams;
  final double targetCarbsGrams;
  final double targetFatsGrams;

  const MetabolicProfile({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.targetProteinGrams,
    required this.targetCarbsGrams,
    required this.targetFatsGrams,
  });
}

/// AdaptiveMetabolismEngine (Base Version — Pure Dart / Deterministic / Offline-First)
/// Calculates BMR using Mifflin-St Jeor formula, applies activity multipliers, and balances macronutrients.
class MetabolismEngine {
  const MetabolismEngine();

  /// Calculate Basal Metabolic Rate (BMR) via Mifflin-St Jeor
  double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    if (gender == Gender.female) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    }
  }

  /// Get TDEE activity multiplier
  double _getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.active:
        return 1.725;
      case ActivityLevel.veryActive:
        return 1.9;
    }
  }

  /// Calculate total daily metabolic profile and macronutrient breakdown
  MetabolicProfile calculateProfile({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required Goal goal,
    double? bodyFatPercentage,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );

    final tdee = bmr * _getActivityMultiplier(activityLevel);

    // Goal Calorie Target Adjustment
    double targetCalories = tdee;
    switch (goal) {
      case Goal.fatLoss:
        targetCalories = tdee - 450; // Moderate 20-25% deficit
        break;
      case Goal.muscleGain:
        targetCalories = tdee + 300; // Lean surplus
        break;
      case Goal.maintenance:
      case Goal.athleticPerformance:
        targetCalories = tdee;
        break;
    }

    // Protein Target (1.6g - 2.2g per kg depending on goal)
    final proteinPerKg = (goal == Goal.muscleGain || goal == Goal.fatLoss) ? 2.0 : 1.6;
    final targetProteinGrams = (weightKg * proteinPerKg).clamp(60.0, 240.0);

    // Fats Target (25% of total calories)
    final targetFatCalories = targetCalories * 0.25;
    final targetFatsGrams = targetFatCalories / 9.0;

    // Carbs Target (Remaining calories)
    final proteinCalories = targetProteinGrams * 4.0;
    final remainingCarbCalories = targetCalories - proteinCalories - targetFatCalories;
    final targetCarbsGrams = (remainingCarbCalories / 4.0).clamp(50.0, 600.0);

    return MetabolicProfile(
      bmr: double.parse(bmr.toStringAsFixed(1)),
      tdee: double.parse(tdee.toStringAsFixed(1)),
      targetCalories: double.parse(targetCalories.toStringAsFixed(1)),
      targetProteinGrams: double.parse(targetProteinGrams.toStringAsFixed(1)),
      targetCarbsGrams: double.parse(targetCarbsGrams.toStringAsFixed(1)),
      targetFatsGrams: double.parse(targetFatsGrams.toStringAsFixed(1)),
    );
  }
}
