enum BiologicalSex { male, female }
enum NutritionGoal { fatLoss, maintenance, muscleGain }
enum MetabolicState { suppressed, normal, elevated }

class AdaptiveMetabolismProfile {
  final double bmr; // Basal Metabolic Rate (kcal)
  final double staticTdee; // Standard formula TDEE (kcal)
  final double dynamicTdee; // True expenditure from energy balance (kcal)
  final double adaptationFactor; // dynamicTdee / staticTdee (e.g. 0.95 = -5% metabolic rate)
  final MetabolicState metabolicState;
  final int targetCalories;
  final int targetProteinGrams;
  final int targetCarbsGrams;
  final int targetFatsGrams;
  final DateTime calculatedAt;

  const AdaptiveMetabolismProfile({
    required this.bmr,
    required this.staticTdee,
    required this.dynamicTdee,
    required this.adaptationFactor,
    required this.metabolicState,
    required this.targetCalories,
    required this.targetProteinGrams,
    required this.targetCarbsGrams,
    required this.targetFatsGrams,
    required this.calculatedAt,
  });

  factory AdaptiveMetabolismProfile.fromMap(Map<String, dynamic> map) {
    final stateName = map['metabolicState'] as String? ?? 'normal';
    final state = MetabolicState.values.firstWhere(
      (e) => e.name == stateName,
      orElse: () => MetabolicState.normal,
    );

    return AdaptiveMetabolismProfile(
      bmr: (map['bmr'] as num?)?.toDouble() ?? 1600.0,
      staticTdee: (map['staticTdee'] as num?)?.toDouble() ?? 2200.0,
      dynamicTdee: (map['dynamicTdee'] as num?)?.toDouble() ?? 2200.0,
      adaptationFactor: (map['adaptationFactor'] as num?)?.toDouble() ?? 1.0,
      metabolicState: state,
      targetCalories: (map['targetCalories'] as num?)?.toInt() ?? 2000,
      targetProteinGrams: (map['targetProteinGrams'] as num?)?.toInt() ?? 130,
      targetCarbsGrams: (map['targetCarbsGrams'] as num?)?.toInt() ?? 220,
      targetFatsGrams: (map['targetFatsGrams'] as num?)?.toInt() ?? 60,
      calculatedAt: map['calculatedAt'] != null
          ? DateTime.tryParse(map['calculatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bmr': bmr,
      'staticTdee': staticTdee,
      'dynamicTdee': dynamicTdee,
      'adaptationFactor': adaptationFactor,
      'metabolicState': metabolicState.name,
      'targetCalories': targetCalories,
      'targetProteinGrams': targetProteinGrams,
      'targetCarbsGrams': targetCarbsGrams,
      'targetFatsGrams': targetFatsGrams,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }
}

class AdaptiveMetabolismEngine {
  /// Pure Dart deterministic calculation of Basal Metabolic Rate (Mifflin-St Jeor)
  static double calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
  }) {
    if (sex == BiologicalSex.male) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// Calculates dynamic TDEE based on 14-day energy balance and weight delta
  static AdaptiveMetabolismProfile computeMetabolism({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
    required NutritionGoal goal,
    double activityMultiplier = 1.375, // Moderate active baseline
    double? avgDailyIntake14Days,
    double? weightDelta14DaysKg, // positive = gained weight, negative = lost
  }) {
    final bmr = calculateBmr(weightKg: weightKg, heightCm: heightCm, age: age, sex: sex);
    final staticTdee = bmr * activityMultiplier;

    double dynamicTdee = staticTdee;
    if (avgDailyIntake14Days != null && weightDelta14DaysKg != null) {
      // 1 kg body tissue ~= 7700 kcal
      final dailyEnergyImbalance = (weightDelta14DaysKg * 7700.0) / 14.0;
      final calculatedExpenditure = avgDailyIntake14Days - dailyEnergyImbalance;
      // Clamp within physiological bounds (0.7 to 1.4 of static TDEE)
      dynamicTdee = calculatedExpenditure.clamp(staticTdee * 0.70, staticTdee * 1.40);
    }

    final adaptationFactor = dynamicTdee / staticTdee;
    final MetabolicState metabolicState;
    if (adaptationFactor < 0.92) {
      metabolicState = MetabolicState.suppressed; // Metabolic adaptation to restriction
    } else if (adaptationFactor > 1.08) {
      metabolicState = MetabolicState.elevated; // High NEAT / thermic effect
    } else {
      metabolicState = MetabolicState.normal;
    }

    // Goal Calorie Target
    int targetCalories;
    switch (goal) {
      case NutritionGoal.fatLoss:
        targetCalories = (dynamicTdee - 400).round();
        // Safe minimum floors
        final minSafeFloor = sex == BiologicalSex.male ? 1500 : 1200;
        if (targetCalories < minSafeFloor) targetCalories = minSafeFloor;
        break;
      case NutritionGoal.maintenance:
        targetCalories = dynamicTdee.round();
        break;
      case NutritionGoal.muscleGain:
        targetCalories = (dynamicTdee + 250).round();
        break;
    }

    // Macro distribution (Indian context: 1.8g/kg protein, 25-30% fats, remainder carbs)
    final proteinGrams = (weightKg * 1.8).round().clamp(60, 220);
    final proteinCalories = proteinGrams * 4;
    final fatCalories = (targetCalories * 0.25).round();
    final fatGrams = (fatCalories / 9).round();
    final carbCalories = targetCalories - proteinCalories - fatCalories;
    final carbGrams = (carbCalories / 4).round().clamp(50, 600);

    return AdaptiveMetabolismProfile(
      bmr: bmr,
      staticTdee: staticTdee,
      dynamicTdee: dynamicTdee,
      adaptationFactor: adaptationFactor,
      metabolicState: metabolicState,
      targetCalories: targetCalories,
      targetProteinGrams: proteinGrams,
      targetCarbsGrams: carbGrams,
      targetFatsGrams: fatGrams,
      calculatedAt: DateTime.now(),
    );
  }
}
