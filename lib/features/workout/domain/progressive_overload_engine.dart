import 'workout_models.dart';

enum OverloadAction {
  increaseLoad(
    label: 'Increase Load (+Weight)',
    regionalLabel: 'वजन बढ़ाएं (लोड वृद्धि)',
    colorCode: 0xff22C55E, // Karma Green
  ),
  increaseReps(
    label: 'Add Repetitions (+Reps)',
    regionalLabel: 'रेप्स बढ़ाएं (वॉल्यूम निर्माण)',
    colorCode: 0xff3B82F6, // Focus Blue
  ),
  maintainAndConsolidate(
    label: 'Maintain & Master Tempo',
    regionalLabel: 'वर्तमान वजन स्थिर रखें',
    colorCode: 0xffFF9100, // Energy Orange
  ),
  deload(
    label: 'Deload & Active Recovery',
    regionalLabel: 'डीलोड एवं सक्रिय पुनर्प्राप्ति',
    colorCode: 0xff7C4DFF, // AI Purple
  );

  final String label;
  final String regionalLabel;
  final int colorCode;

  const OverloadAction({
    required this.label,
    required this.regionalLabel,
    required this.colorCode,
  });
}

class ExerciseOverloadPrescription {
  final Exercise exercise;
  final double currentWorkingWeightKg;
  final int currentReps;
  final double estimated1RmKg;
  final OverloadAction recommendedAction;
  final double nextTargetWeightKg;
  final int nextTargetRepsMin;
  final int nextTargetRepsMax;
  final String overloadRationale;
  final String techniqueFocusCue;

  const ExerciseOverloadPrescription({
    required this.exercise,
    required this.currentWorkingWeightKg,
    required this.currentReps,
    required this.estimated1RmKg,
    required this.recommendedAction,
    required this.nextTargetWeightKg,
    required this.nextTargetRepsMin,
    required this.nextTargetRepsMax,
    required this.overloadRationale,
    required this.techniqueFocusCue,
  });
}

class ProgressiveOverloadEngine {
  /// Pure Dart deterministic calculation of 1-Rep Max (1RM) using Epley & Brzycki composite
  static double calculateEstimated1Rm({
    required double weightKg,
    required int reps,
  }) {
    if (weightKg <= 0 || reps <= 0) return 0.0;
    if (reps == 1) return weightKg;

    // Epley Formula: 1RM = Weight * (1 + Reps / 30)
    final double epley = weightKg * (1.0 + (reps / 30.0));

    // Brzycki Formula: 1RM = Weight * (36 / (37 - Reps)) (valid for reps <= 12)
    final double brzycki = reps < 36 ? weightKg * (36.0 / (37.0 - reps)) : epley;

    final double composite = (epley + brzycki) / 2.0;
    return double.parse(composite.toStringAsFixed(1));
  }

  /// Pure Dart deterministic Double Progression Model calculation
  static ExerciseOverloadPrescription computeOverloadPrescription({
    required Exercise exercise,
    required List<WorkoutSet> recentCompletedSets,
    required int targetRepsMin,
    required int targetRepsMax,
    required double readinessScore, // 0 to 100
  }) {
    final completedSets = recentCompletedSets.where((s) => s.isCompleted && !s.isWarmup).toList();

    if (completedSets.isEmpty) {
      return ExerciseOverloadPrescription(
        exercise: exercise,
        currentWorkingWeightKg: 0.0,
        currentReps: targetRepsMin,
        estimated1RmKg: 0.0,
        recommendedAction: OverloadAction.increaseReps,
        nextTargetWeightKg: 0.0,
        nextTargetRepsMin: targetRepsMin,
        nextTargetRepsMax: targetRepsMax,
        overloadRationale: 'Start with baseline suggested load and focus on controlled 2-second eccentric tempo.',
        techniqueFocusCue: exercise.instructions,
      );
    }

    final double topWeight = completedSets.map((s) => s.weightKg).reduce((a, b) => a > b ? a : b);
    final int minRepsAchieved = completedSets.map((s) => s.reps).reduce((a, b) => a < b ? a : b);
    final int maxRepsAchieved = completedSets.map((s) => s.reps).reduce((a, b) => a > b ? a : b);
    final double avgRpe = completedSets.map((s) => s.rpe ?? 8.0).reduce((a, b) => a + b) / completedSets.length;

    final double estimated1Rm = calculateEstimated1Rm(weightKg: topWeight, reps: maxRepsAchieved);

    // Deload Check: High systemic fatigue or readiness < 50%
    if (readinessScore < 50.0) {
      final double deloadWeight = double.parse((topWeight * 0.80).toStringAsFixed(1));
      return ExerciseOverloadPrescription(
        exercise: exercise,
        currentWorkingWeightKg: topWeight,
        currentReps: maxRepsAchieved,
        estimated1RmKg: estimated1Rm,
        recommendedAction: OverloadAction.deload,
        nextTargetWeightKg: deloadWeight,
        nextTargetRepsMin: targetRepsMin,
        nextTargetRepsMax: targetRepsMax,
        overloadRationale: 'Readiness (${readinessScore.round()}%) indicates systemic or neural fatigue. '
            'Deload intensity by 20% to allow connective tissue remodeling.',
        techniqueFocusCue: 'Focus on explosive concentric velocity and joint mobility.',
      );
    }

    // Double Progression Check: Did user hit the top of the rep target in all working sets?
    final bool hitTopRepsAcrossAllSets = minRepsAchieved >= targetRepsMax;
    final bool rpeUnderThreshold = avgRpe <= 9.0;

    if (hitTopRepsAcrossAllSets && rpeUnderThreshold) {
      // Step 1 Complete: Increment Load!
      final double loadIncrement = _getStandardIncrement(exercise);
      final double nextWeight = topWeight + loadIncrement;

      return ExerciseOverloadPrescription(
        exercise: exercise,
        currentWorkingWeightKg: topWeight,
        currentReps: minRepsAchieved,
        estimated1RmKg: estimated1Rm,
        recommendedAction: OverloadAction.increaseLoad,
        nextTargetWeightKg: nextWeight,
        nextTargetRepsMin: targetRepsMin,
        nextTargetRepsMax: targetRepsMax,
        overloadRationale: 'Double Progression Target Achieved ($minRepsAchieved reps in all sets). '
            'Increase working load by +$loadIncrement kg next session.',
        techniqueFocusCue: 'Maintain strict scapular brace under new load.',
      );
    } else if (minRepsAchieved >= targetRepsMin) {
      // Step 2: Build Repetitions toward target max
      return ExerciseOverloadPrescription(
        exercise: exercise,
        currentWorkingWeightKg: topWeight,
        currentReps: minRepsAchieved,
        estimated1RmKg: estimated1Rm,
        recommendedAction: OverloadAction.increaseReps,
        nextTargetWeightKg: topWeight,
        nextTargetRepsMin: targetRepsMin,
        nextTargetRepsMax: targetRepsMax,
        overloadRationale: 'Solid performance ($minRepsAchieved reps at $topWeight kg). '
            'Keep weight fixed and aim for +1 rep on earlier sets next workout.',
        techniqueFocusCue: 'Control the eccentric descent to maximize mechanical tension.',
      );
    } else {
      // Struggling to hit minimum reps
      return ExerciseOverloadPrescription(
        exercise: exercise,
        currentWorkingWeightKg: topWeight,
        currentReps: minRepsAchieved,
        estimated1RmKg: estimated1Rm,
        recommendedAction: OverloadAction.maintainAndConsolidate,
        nextTargetWeightKg: topWeight,
        nextTargetRepsMin: targetRepsMin,
        nextTargetRepsMax: targetRepsMax,
        overloadRationale: 'Current load is challenging ($minRepsAchieved reps vs $targetRepsMin target). '
            'Consolidate form, optimize rest intervals, and maintain load.',
        techniqueFocusCue: 'Ensure complete 90-120s rest periods between heavy sets.',
      );
    }
  }

  static double _getStandardIncrement(Exercise exercise) {
    switch (exercise.targetMuscle) {
      case MuscleGroup.quads:
      case MuscleGroup.hamstrings:
        return 5.0; // Legs compound +5kg
      case MuscleGroup.chest:
      case MuscleGroup.back:
        return 2.5; // Upper body compound +2.5kg
      case MuscleGroup.shoulders:
      case MuscleGroup.arms:
      case MuscleGroup.core:
      case MuscleGroup.fullBody:
        return exercise.equipment == EquipmentType.traditionalIndian ? 0.0 : 1.25;
    }
  }
}
