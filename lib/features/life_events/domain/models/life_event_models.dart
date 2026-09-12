enum LifeEventType {
  standard,
  weddingPrep,
  festivalFeast,
  travelMode,
  crunchWeek,
  sicknessRecovery,
}

enum RoastIntensity {
  mild,
  spicy,
  savage,
}

class FestivalProtocol {
  final String id;
  final String name;
  final String nameHindi;
  final String seasonDescription;
  final List<String> nutritionGuidelines;
  final List<String> nutritionGuidelinesHindi;
  final List<String> fastingRules;
  final List<String> workoutAdaptations;
  final String feastBufferAdvice;

  const FestivalProtocol({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.seasonDescription,
    required this.nutritionGuidelines,
    required this.nutritionGuidelinesHindi,
    required this.fastingRules,
    required this.workoutAdaptations,
    required this.feastBufferAdvice,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_hindi': nameHindi,
        'season_description': seasonDescription,
        'nutrition_guidelines': nutritionGuidelines,
        'nutrition_guidelines_hindi': nutritionGuidelinesHindi,
        'fasting_rules': fastingRules,
        'workout_adaptations': workoutAdaptations,
        'feast_buffer_advice': feastBufferAdvice,
      };
}

class WeddingTransformationPlan {
  final String id;
  final String userId;
  final DateTime weddingDate;
  final int daysRemaining;
  final double baselineWeightKg;
  final double targetWeightKg;
  final double baselineWaistCm;
  final double targetWaistCm;
  final String currentPhaseName; // e.g. "Metabolic Foundation", "Lean Definition", "Peak Week Glow"
  final String currentPhaseNameHindi;
  final List<String> weeklyMilestones;

  const WeddingTransformationPlan({
    required this.id,
    required this.userId,
    required this.weddingDate,
    required this.daysRemaining,
    required this.baselineWeightKg,
    required this.targetWeightKg,
    required this.baselineWaistCm,
    required this.targetWaistCm,
    required this.currentPhaseName,
    required this.currentPhaseNameHindi,
    required this.weeklyMilestones,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'wedding_date': weddingDate.toIso8601String(),
        'days_remaining': daysRemaining,
        'baseline_weight_kg': baselineWeightKg,
        'target_weight_kg': targetWeightKg,
        'baseline_waist_cm': baselineWaistCm,
        'target_waist_cm': targetWaistCm,
        'current_phase_name': currentPhaseName,
        'current_phase_name_hindi': currentPhaseNameHindi,
        'weekly_milestones': weeklyMilestones,
      };
}

class AIRoastMessage {
  final String headline;
  final String body;
  final String bodyHindi;
  final RoastIntensity intensity;
  final String punchline;

  const AIRoastMessage({
    required this.headline,
    required this.body,
    required this.bodyHindi,
    required this.intensity,
    required this.punchline,
  });
}

class TravelHealthPlan {
  final String destination;
  final int tripDurationDays;
  final List<String> hotelWorkouts;
  final List<String> digestionChecklist;
  final List<String> regionalDiningTips;
  final String hydrationStrategy;

  const TravelHealthPlan({
    required this.destination,
    required this.tripDurationDays,
    required this.hotelWorkouts,
    required this.digestionChecklist,
    required this.regionalDiningTips,
    required this.hydrationStrategy,
  });
}
