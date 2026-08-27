import 'package:flutter/foundation.dart';

enum ReadinessZone {
  optimal,    // 80-100: Green / Prime capacity
  moderate,   // 60-79: Blue / Normal training capacity
  recovery,   // 40-59: Amber / Active recovery recommended
  rest,       // 0-39: Red / Rest & stress management priority
}

@immutable
class DailyIntelligencePackage {
  final String date; // YYYY-MM-DD
  final int healthScore; // 0-100 deterministic unified score
  final int readinessScore; // 0-100 deterministic readiness score
  final ReadinessZone readinessZone;
  final int targetCalories;
  final int targetProteinGrams;
  final int targetSteps;
  final String workoutRecommendation; // e.g. "Hypertrophy Push" or "Low-Intensity Zone 2"
  final String aiBriefing; // Groq generated personalized morning narrative
  final List<String> safetyAlerts; // Deterministic safety overrides (e.g. "High Heatwave Index", "Elevated Resting HR")
  final DateTime generatedAt;

  const DailyIntelligencePackage({
    required this.date,
    required this.healthScore,
    required this.readinessScore,
    required this.readinessZone,
    required this.targetCalories,
    required this.targetProteinGrams,
    required this.targetSteps,
    required this.workoutRecommendation,
    required this.aiBriefing,
    this.safetyAlerts = const [],
    required this.generatedAt,
  });

  factory DailyIntelligencePackage.fromMap(Map<String, dynamic> map, String docDate) {
    final readiness = (map['readinessScore'] as num?)?.toInt() ?? 70;
    ReadinessZone zone;
    if (readiness >= 80) {
      zone = ReadinessZone.optimal;
    } else if (readiness >= 60) {
      zone = ReadinessZone.moderate;
    } else if (readiness >= 40) {
      zone = ReadinessZone.recovery;
    } else {
      zone = ReadinessZone.rest;
    }

    return DailyIntelligencePackage(
      date: docDate,
      healthScore: (map['healthScore'] as num?)?.toInt() ?? 75,
      readinessScore: readiness,
      readinessZone: zone,
      targetCalories: (map['targetCalories'] as num?)?.toInt() ?? 2000,
      targetProteinGrams: (map['targetProteinGrams'] as num?)?.toInt() ?? 120,
      targetSteps: (map['targetSteps'] as num?)?.toInt() ?? 8000,
      workoutRecommendation: map['workoutRecommendation'] as String? ?? 'Moderate Full Body',
      aiBriefing: map['aiBriefing'] as String? ?? 'Welcome to FitKarma. Ready to conquer the day!',
      safetyAlerts: List<String>.from(map['safetyAlerts'] ?? []),
      generatedAt: map['generatedAt'] != null
          ? DateTime.tryParse(map['generatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'healthScore': healthScore,
      'readinessScore': readinessScore,
      'readinessZone': readinessZone.name,
      'targetCalories': targetCalories,
      'targetProteinGrams': targetProteinGrams,
      'targetSteps': targetSteps,
      'workoutRecommendation': workoutRecommendation,
      'aiBriefing': aiBriefing,
      'safetyAlerts': safetyAlerts,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}
