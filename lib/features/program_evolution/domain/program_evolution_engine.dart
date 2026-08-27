enum EvolutionAction {
  progress,     // Increase volume / intensity / weights
  maintain,     // Keep current program parameters
  deload,       // Trigger 1-week active recovery / lower volume
  recalibrate,  // Adjust calorie/macro targets due to plateau
}

class ProgramEvolutionResult {
  final EvolutionAction action;
  final double volumeMultiplier; // e.g. 1.05 for +5%, 0.70 for deload
  final int recommendedCalorieDelta; // e.g. -100 or +100
  final double adherenceRate; // 0.0 to 1.0
  final double averageReadiness;
  final String reasoning;
  final DateTime evaluatedAt;

  const ProgramEvolutionResult({
    required this.action,
    required this.volumeMultiplier,
    required this.recommendedCalorieDelta,
    required this.adherenceRate,
    required this.averageReadiness,
    required this.reasoning,
    required this.evaluatedAt,
  });

  factory ProgramEvolutionResult.fromMap(Map<String, dynamic> map) {
    final actionName = map['action'] as String? ?? 'maintain';
    final action = EvolutionAction.values.firstWhere(
      (e) => e.name == actionName,
      orElse: () => EvolutionAction.maintain,
    );

    return ProgramEvolutionResult(
      action: action,
      volumeMultiplier: (map['volumeMultiplier'] as num?)?.toDouble() ?? 1.0,
      recommendedCalorieDelta: (map['recommendedCalorieDelta'] as num?)?.toInt() ?? 0,
      adherenceRate: (map['adherenceRate'] as num?)?.toDouble() ?? 0.8,
      averageReadiness: (map['averageReadiness'] as num?)?.toDouble() ?? 75.0,
      reasoning: map['reasoning'] as String? ?? 'Maintaining current program progression.',
      evaluatedAt: map['evaluatedAt'] != null
          ? DateTime.tryParse(map['evaluatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action.name,
      'volumeMultiplier': volumeMultiplier,
      'recommendedCalorieDelta': recommendedCalorieDelta,
      'adherenceRate': adherenceRate,
      'averageReadiness': averageReadiness,
      'reasoning': reasoning,
      'evaluatedAt': evaluatedAt.toIso8601String(),
    };
  }
}

class ProgramEvolutionEngine {
  /// Pure Dart deterministic evaluation of program evolution
  static ProgramEvolutionResult evaluateProgression({
    required int completedWorkouts,
    required int plannedWorkouts,
    required double averageReadiness, // 0 - 100
    required int consecutiveLowReadinessDays,
    required bool weightPlateau14Days,
  }) {
    final adherence = plannedWorkouts > 0
        ? (completedWorkouts / plannedWorkouts).clamp(0.0, 1.0)
        : 1.0;

    // 1. Deload Trigger: High accumulated fatigue
    if (consecutiveLowReadinessDays >= 3 || averageReadiness < 45.0) {
      return ProgramEvolutionResult(
        action: EvolutionAction.deload,
        volumeMultiplier: 0.65,
        recommendedCalorieDelta: 0,
        adherenceRate: adherence,
        averageReadiness: averageReadiness,
        reasoning: 'Systemic fatigue detected across consecutive sessions. Triggering a 1-week active deload cycle to restore recovery capacity.',
        evaluatedAt: DateTime.now(),
      );
    }

    // 2. Recalibrate Trigger: Plateau despite strong adherence
    if (weightPlateau14Days && adherence >= 0.85) {
      return ProgramEvolutionResult(
        action: EvolutionAction.recalibrate,
        volumeMultiplier: 1.0,
        recommendedCalorieDelta: -150,
        adherenceRate: adherence,
        averageReadiness: averageReadiness,
        reasoning: 'Metabolic adaptation detected after 14-day plateau with strong consistency. Adjusting daily intake by -150 kcal to resume progression.',
        evaluatedAt: DateTime.now(),
      );
    }

    // 3. Progress Trigger: High adherence and prime readiness
    if (adherence >= 0.80 && averageReadiness >= 70.0) {
      return ProgramEvolutionResult(
        action: EvolutionAction.progress,
        volumeMultiplier: 1.05,
        recommendedCalorieDelta: 0,
        adherenceRate: adherence,
        averageReadiness: averageReadiness,
        reasoning: 'Exceptional adherence (${(adherence * 100).round()}%) and readiness (${averageReadiness.round()}). Advancing training volume by +5%.',
        evaluatedAt: DateTime.now(),
      );
    }

    // 4. Default: Maintain steady progression
    return ProgramEvolutionResult(
      action: EvolutionAction.maintain,
      volumeMultiplier: 1.0,
      recommendedCalorieDelta: 0,
      adherenceRate: adherence,
      averageReadiness: averageReadiness,
      reasoning: 'Consistency is stabilizing. Maintaining current program blueprint without adjustment.',
      evaluatedAt: DateTime.now(),
    );
  }
}
