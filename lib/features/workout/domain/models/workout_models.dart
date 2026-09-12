enum MovementPattern { push, pull, squat, hinge, lunge, carry, core }

enum MuscleGroup { chest, back, quadriceps, hamstrings, shoulders, biceps, triceps, core, fullBody }

enum EquipmentType { barbell, dumbbell, cable, machine, bodyweight, resistanceBand }

class Exercise {
  final String id;
  final String name;
  final String nameHindi;
  final MovementPattern pattern;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final EquipmentType equipment;
  final int defaultSets;
  final int defaultMinReps;
  final int defaultMaxReps;
  final int defaultRestSeconds;
  final List<String> formCues;
  final List<String> formCuesHindi;

  const Exercise({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.pattern,
    required this.primaryMuscle,
    this.secondaryMuscles = const [],
    required this.equipment,
    this.defaultSets = 3,
    this.defaultMinReps = 8,
    this.defaultMaxReps = 12,
    this.defaultRestSeconds = 90,
    required this.formCues,
    required this.formCuesHindi,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_hindi': nameHindi,
        'pattern': pattern.name,
        'primary_muscle': primaryMuscle.name,
        'equipment': equipment.name,
        'default_sets': defaultSets,
        'default_min_reps': defaultMinReps,
        'default_max_reps': defaultMaxReps,
        'default_rest_seconds': defaultRestSeconds,
        'form_cues': formCues,
      };
}

class WorkoutSet {
  final int setNumber;
  final double weightKg;
  final int reps;
  final int rpe; // 1 to 10 (Rating of Perceived Exertion)
  final bool isCompleted;

  const WorkoutSet({
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    this.rpe = 8,
    this.isCompleted = false,
  });

  WorkoutSet copyWith({
    int? setNumber,
    double? weightKg,
    int? reps,
    int? rpe,
    bool? isCompleted,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'set_number': setNumber,
        'weight_kg': weightKg,
        'reps': reps,
        'rpe': rpe,
        'is_completed': isCompleted,
      };
}

class SessionExercise {
  final Exercise exercise;
  final List<WorkoutSet> sets;

  const SessionExercise({
    required this.exercise,
    required this.sets,
  });

  double get totalVolumeKg {
    double vol = 0;
    for (final s in sets) {
      if (s.isCompleted) {
        vol += s.weightKg * s.reps;
      }
    }
    return vol;
  }
}

class OverloadRecommendation {
  final String exerciseId;
  final double suggestedWeightKg;
  final int suggestedMinReps;
  final int suggestedMaxReps;
  final String action; // 'increase_weight', 'increase_reps', 'maintain', 'micro_deload'
  final String reasoning;
  final String reasoningHindi;

  const OverloadRecommendation({
    required this.exerciseId,
    required this.suggestedWeightKg,
    required this.suggestedMinReps,
    required this.suggestedMaxReps,
    required this.action,
    required this.reasoning,
    required this.reasoningHindi,
  });
}

class FormCheckResult {
  final bool isValid;
  final double scorePercent; // 0 to 100
  final String feedback;
  final String feedbackHindi;
  final List<String> correctionCues;

  const FormCheckResult({
    required this.isValid,
    required this.scorePercent,
    required this.feedback,
    required this.feedbackHindi,
    required this.correctionCues,
  });
}
