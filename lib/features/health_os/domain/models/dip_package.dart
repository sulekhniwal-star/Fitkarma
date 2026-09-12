/// Daily Intelligence Package (DIP) Domain Model
/// Centralized health synthesis package generated each morning
class DipPackage {
  final String date;
  final int readinessScore;
  final String readinessTier; // 'prime', 'steady', 'recovery'
  final String morningBriefing;
  final String morningBriefingHindi;
  final double metabolicBudgetKcal;
  final double targetProteinGrams;
  final double targetCarbsGrams;
  final double targetFatsGrams;
  final String environmentalAdvisory;
  final String trainingRecommendation;
  final DateTime expiresAt;

  const DipPackage({
    required this.date,
    required this.readinessScore,
    required this.readinessTier,
    required this.morningBriefing,
    required this.morningBriefingHindi,
    required this.metabolicBudgetKcal,
    required this.targetProteinGrams,
    required this.targetCarbsGrams,
    required this.targetFatsGrams,
    required this.environmentalAdvisory,
    required this.trainingRecommendation,
    required this.expiresAt,
  });

  factory DipPackage.fromJson(Map<String, dynamic> json) {
    return DipPackage(
      date: json['date'] as String? ?? '',
      readinessScore: json['readiness_score'] as int? ?? 75,
      readinessTier: json['readiness_tier'] as String? ?? 'steady',
      morningBriefing: json['morning_briefing'] as String? ?? 'Your body is primed for standard activity today.',
      morningBriefingHindi: json['morning_briefing_hindi'] as String? ?? 'आज आपका शरीर सामान्य गतिविधि के लिए तैयार है।',
      metabolicBudgetKcal: (json['metabolic_budget_kcal'] as num?)?.toDouble() ?? 2000.0,
      targetProteinGrams: (json['target_protein_grams'] as num?)?.toDouble() ?? 120.0,
      targetCarbsGrams: (json['target_carbs_grams'] as num?)?.toDouble() ?? 220.0,
      targetFatsGrams: (json['target_fats_grams'] as num?)?.toDouble() ?? 65.0,
      environmentalAdvisory: json['environmental_advisory'] as String? ?? 'AQI is moderate. Indoor cardio recommended.',
      trainingRecommendation: json['training_recommendation'] as String? ?? 'Moderate hypertrophy or 45-min zone 2 cardio.',
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : DateTime.now().add(const Duration(hours: 24)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'readiness_score': readinessScore,
      'readiness_tier': readinessTier,
      'morning_briefing': morningBriefing,
      'morning_briefing_hindi': morningBriefingHindi,
      'metabolic_budget_kcal': metabolicBudgetKcal,
      'target_protein_grams': targetProteinGrams,
      'target_carbs_grams': targetCarbsGrams,
      'target_fats_grams': targetFatsGrams,
      'environmental_advisory': environmentalAdvisory,
      'training_recommendation': trainingRecommendation,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
