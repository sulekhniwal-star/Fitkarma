enum DayTrainingIntensity {
  heavyCompound(name: 'Heavy Compound / Leg Day', regionalName: 'भारी कसरत (लेग डे)', calorieOffset: 250, carbFactor: 4.0, fatFactor: 0.65),
  moderateUpper(name: 'Moderate Upper Body / Hypertrophy', regionalName: 'मध्यम अपर बॉडी', calorieOffset: 0, carbFactor: 3.2, fatFactor: 0.8),
  lightConditioning(name: 'Light Zone 2 / Active Recovery', regionalName: 'हल्का कार्डियो / रिकवरी', calorieOffset: -150, carbFactor: 2.4, fatFactor: 0.9),
  fullRest(name: 'Full Rest Day', regionalName: 'पूर्ण विश्राम दिवस', calorieOffset: -250, carbFactor: 1.8, fatFactor: 1.05);

  final String name;
  final String regionalName;
  final int calorieOffset;
  final double carbFactor;
  final double fatFactor;

  const DayTrainingIntensity({
    required this.name,
    required this.regionalName,
    required this.calorieOffset,
    required this.carbFactor,
    required this.fatFactor,
  });
}

class PeriodizedDayTarget {
  final String dayName; // 'Monday', 'Tuesday', etc.
  final DayTrainingIntensity intensity;
  final int targetCalories;
  final int targetProteinGrams;
  final int targetCarbsGrams;
  final int targetFatsGrams;
  final bool isRefeedDay;

  const PeriodizedDayTarget({
    required this.dayName,
    required this.intensity,
    required this.targetCalories,
    required this.targetProteinGrams,
    required this.targetCarbsGrams,
    required this.targetFatsGrams,
    this.isRefeedDay = false,
  });
}

class NutritionPeriodizationPlan {
  final List<PeriodizedDayTarget> weeklySchedule;
  final int averageWeeklyCalories;
  final double weeklyProteinAverage;
  final String strategicRationale;

  const NutritionPeriodizationPlan({
    required this.weeklySchedule,
    required this.averageWeeklyCalories,
    required this.weeklyProteinAverage,
    required this.strategicRationale,
  });
}

class NutritionPeriodizationEngine {
  /// Pure Dart deterministic calculation of 7-day carb and caloric wave periodization
  static NutritionPeriodizationPlan generateWeeklyPlan({
    required double weightKg,
    required int baseMaintenanceCalories,
    bool isRefeedEnabled = false,
    bool isVratFastingDay = false,
  }) {
    final proteinPerKg = 2.0;
    final baseProtein = (weightKg * proteinPerKg).round();

    final List<PeriodizedDayTarget> schedule = [
      _calculateDay('Monday', DayTrainingIntensity.heavyCompound, baseMaintenanceCalories, baseProtein, weightKg),
      _calculateDay('Tuesday', DayTrainingIntensity.moderateUpper, baseMaintenanceCalories, baseProtein, weightKg),
      _calculateDay('Wednesday', DayTrainingIntensity.lightConditioning, baseMaintenanceCalories, baseProtein, weightKg),
      _calculateDay('Thursday', DayTrainingIntensity.heavyCompound, baseMaintenanceCalories, baseProtein, weightKg),
      _calculateDay('Friday', DayTrainingIntensity.moderateUpper, baseMaintenanceCalories, baseProtein, weightKg),
      _calculateDay('Saturday', isRefeedEnabled ? DayTrainingIntensity.heavyCompound : DayTrainingIntensity.lightConditioning, baseMaintenanceCalories, baseProtein, weightKg, isRefeed: isRefeedEnabled),
      _calculateDay('Sunday', DayTrainingIntensity.fullRest, baseMaintenanceCalories, baseProtein, weightKg),
    ];

    final totalCals = schedule.fold<int>(0, (sum, d) => sum + d.targetCalories);
    final avgCals = (totalCals / 7.0).round();

    return NutritionPeriodizationPlan(
      weeklySchedule: schedule,
      averageWeeklyCalories: avgCals,
      weeklyProteinAverage: baseProtein.toDouble(),
      strategicRationale: 'Synchronizes high carbohydrate availability with heavy compound leg and push days for glycogen replenishment, while dropping carbs and calories on rest days to maintain peak insulin sensitivity.',
    );
  }

  static PeriodizedDayTarget _calculateDay(
    String dayName,
    DayTrainingIntensity intensity,
    int baseMaintenance,
    int baseProtein,
    double weightKg, {
    bool isRefeed = false,
  }) {
    final int dayCals = baseMaintenance + intensity.calorieOffset + (isRefeed ? 200 : 0);
    final int dayCarbs = ((weightKg * intensity.carbFactor) + (isRefeed ? 50 : 0)).round();
    final int dayFats = (weightKg * intensity.fatFactor).round();

    return PeriodizedDayTarget(
      dayName: dayName,
      intensity: intensity,
      targetCalories: dayCals,
      targetProteinGrams: baseProtein,
      targetCarbsGrams: dayCarbs,
      targetFatsGrams: dayFats,
      isRefeedDay: isRefeed,
    );
  }
}
