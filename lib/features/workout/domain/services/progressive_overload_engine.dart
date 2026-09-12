import '../models/workout_models.dart';

class ProgressiveOverloadEngine {
  const ProgressiveOverloadEngine();

  /// Computes progressive overload recommendation based on previous session performance
  OverloadRecommendation calculateNextTarget({
    required Exercise exercise,
    required double lastWeightKg,
    required List<int> lastRepsAchieved,
    required List<int> lastRpeScores,
    int consecutiveFailures = 0,
  }) {
    if (lastRepsAchieved.isEmpty) {
      return OverloadRecommendation(
        exerciseId: exercise.id,
        suggestedWeightKg: lastWeightKg,
        suggestedMinReps: exercise.defaultMinReps,
        suggestedMaxReps: exercise.defaultMaxReps,
        action: 'maintain',
        reasoning: 'First session baseline calibration.',
        reasoningHindi: 'प्रारंभिक आधारभूत सत्र।',
      );
    }

    // Check if deload needed due to 2+ consecutive failed sessions
    if (consecutiveFailures >= 2) {
      final deloadWeight = double.parse((lastWeightKg * 0.90).toStringAsFixed(1));
      return OverloadRecommendation(
        exerciseId: exercise.id,
        suggestedWeightKg: deloadWeight,
        suggestedMinReps: exercise.defaultMinReps,
        suggestedMaxReps: exercise.defaultMaxReps,
        action: 'micro_deload',
        reasoning: 'Micro-deload applied (-10% load) to reset nervous system and resolve plateau.',
        reasoningHindi: 'प्लेटो को तोड़ने और रिकवरी के लिए १०% वजन घटाया गया है।',
      );
    }

    // Check if user hit upper rep range on all completed sets
    final allHitMaxReps = lastRepsAchieved.every((r) => r >= exercise.defaultMaxReps);
    final avgRpe = lastRpeScores.isNotEmpty
        ? lastRpeScores.reduce((a, b) => a + b) / lastRpeScores.length
        : 8.0;

    if (allHitMaxReps && avgRpe <= 8.5) {
      // User conquered the rep range comfortably -> Increase weight (Double Progression)
      double weightIncrement = 2.5; // Default for upper body / dumbbells
      if (exercise.equipment == EquipmentType.barbell &&
          (exercise.pattern == MovementPattern.squat || exercise.pattern == MovementPattern.hinge)) {
        weightIncrement = 5.0; // Larger increments for Squat/Deadlift
      }

      final nextWeight = lastWeightKg + weightIncrement;
      return OverloadRecommendation(
        exerciseId: exercise.id,
        suggestedWeightKg: nextWeight,
        suggestedMinReps: exercise.defaultMinReps,
        suggestedMaxReps: exercise.defaultMaxReps,
        action: 'increase_weight',
        reasoning: 'Max reps hit across all sets! Increased load by +${weightIncrement}kg for progressive overload.',
        reasoningHindi: 'सभी सेट पूरे हुए! वजन में +${weightIncrement} किलो की वृद्धि की गई।',
      );
    }

    final minRepTargetHit = lastRepsAchieved.every((r) => r >= exercise.defaultMinReps);
    if (minRepTargetHit) {
      // User is within range but hasn't maxed reps yet -> Keep weight, aim for +1 rep
      return OverloadRecommendation(
        exerciseId: exercise.id,
        suggestedWeightKg: lastWeightKg,
        suggestedMinReps: exercise.defaultMinReps,
        suggestedMaxReps: exercise.defaultMaxReps,
        action: 'increase_reps',
        reasoning: 'Maintain ${lastWeightKg}kg. Focus on adding 1 extra rep per set before adding weight.',
        reasoningHindi: 'वजन समान रखें। अगले सत्र में प्रत्येक सेट में १ अतिरिक्त रेप लगाने का लक्ष्य रखें।',
      );
    }

    // Missed lower rep target
    return OverloadRecommendation(
      exerciseId: exercise.id,
      suggestedWeightKg: lastWeightKg,
      suggestedMinReps: exercise.defaultMinReps,
      suggestedMaxReps: exercise.defaultMaxReps,
      action: 'maintain',
      reasoning: 'Repeat ${lastWeightKg}kg with clean form to achieve minimum ${exercise.defaultMinReps} reps.',
      reasoningHindi: 'शुद्ध फॉर्म के साथ पुनः प्रयास करें ताकि न्यूनतम रेप्स पूरे हो सकें।',
    );
  }
}
