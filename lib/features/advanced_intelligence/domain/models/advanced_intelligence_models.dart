enum PlateauStatus {
  progressing,
  stalling,
  plateaued,
}

enum RefeedType {
  none,
  moderateCarbRefeed,
  fullCaloricReset,
}

class AdaptiveMetabolismReport {
  final String id;
  final String userId;
  final double baselineBmr;
  final double estimatedTdee;
  final double currentCalorieTarget;
  final double metabolicAdaptationFactor; // e.g. 0.92 = 8% metabolic slowdown
  final PlateauStatus plateauStatus;
  final int weeksStalled;
  final RefeedType recommendedRefeed;
  final String strategyDescription;
  final String strategyDescriptionHindi;
  final DateTime calculatedAt;

  const AdaptiveMetabolismReport({
    required this.id,
    required this.userId,
    required this.baselineBmr,
    required this.estimatedTdee,
    required this.currentCalorieTarget,
    required this.metabolicAdaptationFactor,
    required this.plateauStatus,
    required this.weeksStalled,
    required this.recommendedRefeed,
    required this.strategyDescription,
    required this.strategyDescriptionHindi,
    required this.calculatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'baseline_bmr': baselineBmr,
        'estimated_tdee': estimatedTdee,
        'current_calorie_target': currentCalorieTarget,
        'metabolic_adaptation_factor': metabolicAdaptationFactor,
        'plateau_status': plateauStatus.name,
        'weeks_stalled': weeksStalled,
        'recommended_refeed': recommendedRefeed.name,
        'strategy_description': strategyDescription,
        'strategy_description_hindi': strategyDescriptionHindi,
        'calculated_at': calculatedAt.toIso8601String(),
      };
}

class LongevityPillars {
  final double cardiometabolic; // 0-100
  final double cellularRecovery; // 0-100
  final double functionalStrength; // 0-100
  final double lifestyleHabits; // 0-100

  const LongevityPillars({
    required this.cardiometabolic,
    required this.cellularRecovery,
    required this.functionalStrength,
    required this.lifestyleHabits,
  });

  Map<String, dynamic> toJson() => {
        'cardiometabolic': cardiometabolic,
        'cellular_recovery': cellularRecovery,
        'functional_strength': functionalStrength,
        'lifestyle_habits': lifestyleHabits,
      };
}

class LongevityAssessment {
  final String id;
  final String userId;
  final int overallLongevityScore; // 0-100
  final LongevityPillars pillars;
  final double projectedLifespanGainYears;
  final String primaryLongevityLever;
  final String primaryLongevityLeverHindi;
  final DateTime assessedAt;

  const LongevityAssessment({
    required this.id,
    required this.userId,
    required this.overallLongevityScore,
    required this.pillars,
    required this.projectedLifespanGainYears,
    required this.primaryLongevityLever,
    required this.primaryLongevityLeverHindi,
    required this.assessedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'overall_longevity_score': overallLongevityScore,
        'pillars': pillars.toJson(),
        'projected_lifespan_gain_years': projectedLifespanGainYears,
        'primary_longevity_lever': primaryLongevityLever,
        'primary_longevity_lever_hindi': primaryLongevityLeverHindi,
        'assessed_at': assessedAt.toIso8601String(),
      };
}

class EnvironmentalShieldPlan {
  final String city;
  final int aqi;
  final String aqiCategory;
  final double heatIndexC;
  final bool canExerciseOutdoors;
  final String indoorSubstitutionWorkout;
  final String indoorSubstitutionWorkoutHindi;
  final String hydrationModifier;

  const EnvironmentalShieldPlan({
    required this.city,
    required this.aqi,
    required this.aqiCategory,
    required this.heatIndexC,
    required this.canExerciseOutdoors,
    required this.indoorSubstitutionWorkout,
    required this.indoorSubstitutionWorkoutHindi,
    required this.hydrationModifier,
  });
}
