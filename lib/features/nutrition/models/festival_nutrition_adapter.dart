enum FestivalType { diwali, navratri, ramadan, holi, general }

enum FestivalDayRelative { pre3Days, festivalDay, post1Day, normal }

class FestivalNutritionTargets {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double waterLers;
  final String alertMessage;
  final String recoveryWalkRecommendation;

  const FestivalNutritionTargets({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.waterLers,
    required this.alertMessage,
    required this.recoveryWalkRecommendation,
  });
}

/// Pure-Dart Smart Festival Nutrition Adaptation Engine per §P5-K spec
class FestivalNutritionAdapter {
  const FestivalNutritionAdapter();

  /// Adjusts baseline targets based on festival type and relative day phase
  FestivalNutritionTargets adjustTargets({
    required double baseCalories,
    required double baseProteinG,
    required double baseCarbsG,
    required double baseWaterLers,
    required FestivalType festivalType,
    required FestivalDayRelative relativeDay,
  }) {
    if (festivalType == FestivalType.diwali) {
      switch (relativeDay) {
        case FestivalDayRelative.pre3Days:
          return FestivalNutritionTargets(
            calories: baseCalories - 150.0, // Bank a caloric buffer
            proteinG: baseProteinG + 5.0,
            carbsG: baseCarbsG - 30.0,
            waterLers: baseWaterLers,
            alertMessage:
                'Diwali Pre-Compensation: Calorie target lowered by 150 kcal/day for 3 days to bank a buffer for celebrations.',
            recoveryWalkRecommendation: 'Standard daily activity',
          );
        case FestivalDayRelative.festivalDay:
          return FestivalNutritionTargets(
            calories: baseCalories + 400.0, // Accommodate sweets
            proteinG: baseProteinG + 15.0, // Early satiety trigger
            carbsG: baseCarbsG + 60.0,
            waterLers: baseWaterLers + 0.5,
            alertMessage:
                'Diwali sweets are expected today! Eat your high-protein sources (whey/paneer) first before indulging to blunt blood sugar spikes.',
            recoveryWalkRecommendation: '30-minute evening celebratory walk',
          );
        case FestivalDayRelative.post1Day:
          return FestivalNutritionTargets(
            calories: baseCalories - 100.0,
            proteinG: baseProteinG + 10.0,
            carbsG: baseCarbsG - 50.0,
            waterLers: baseWaterLers + 1.0, // High hydration target
            alertMessage:
                'Post-Diwali Recovery: High hydration (+1L water) and carb moderation activated.',
            recoveryWalkRecommendation:
                '45-minute steady-state recovery walk recommended',
          );
        case FestivalDayRelative.normal:
          break;
      }
    }

    return FestivalNutritionTargets(
      calories: baseCalories,
      proteinG: baseProteinG,
      carbsG: baseCarbsG,
      waterLers: baseWaterLers,
      alertMessage: 'Standard baseline nutrition targets active.',
      recoveryWalkRecommendation: 'Standard workout routine',
    );
  }
}
