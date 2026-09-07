enum MuscleGroup {
  chest(name: 'Chest', regionalName: 'छाती'),
  back(name: 'Back & Lats', regionalName: 'पीठ'),
  quads(name: 'Quadriceps', regionalName: 'जांघ (क्वाड्स)'),
  hamstrings(name: 'Hamstrings & Glutes', regionalName: 'कूल्हे व हैमस्ट्रिंग्स'),
  shoulders(name: 'Shoulders & Delts', regionalName: 'कंधे'),
  arms(name: 'Biceps & Triceps', regionalName: 'भुजाएँ (बाइसेप्स/ट्राइसेप्स)'),
  core(name: 'Core & Abs', regionalName: 'पेट (कोर)'),
  fullBody(name: 'Full Body / Conditioning', regionalName: 'संपूर्ण शरीर');

  final String name;
  final String regionalName;

  const MuscleGroup({
    required this.name,
    required this.regionalName,
  });
}

enum EquipmentType {
  barbell(name: 'Barbell'),
  dumbbell(name: 'Dumbbell'),
  cable(name: 'Cable Machine'),
  bodyweight(name: 'Bodyweight / Calisthenics'),
  machine(name: 'Selectorized Machine'),
  traditionalIndian(name: 'Indian Gada / Mudgar / Desi Dand');

  final String name;
  const EquipmentType({required this.name});
}

class Exercise {
  final String id;
  final String name;
  final String regionalName;
  final MuscleGroup targetMuscle;
  final EquipmentType equipment;
  final String instructions;
  final String thumbnailAsset;

  const Exercise({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.targetMuscle,
    required this.equipment,
    required this.instructions,
    this.thumbnailAsset = 'assets/icons/workout.png',
  });
}

class WorkoutSet {
  final int setNumber;
  final double weightKg;
  final int reps;
  final double? rpe; // Rate of Perceived Exertion (1 to 10)
  final bool isCompleted;
  final bool isWarmup;

  const WorkoutSet({
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    this.rpe,
    this.isCompleted = false,
    this.isWarmup = false,
  });

  double get volumeTonnageKg => weightKg * reps;

  WorkoutSet copyWith({
    int? setNumber,
    double? weightKg,
    int? reps,
    double? rpe,
    bool? isCompleted,
    bool? isWarmup,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      isCompleted: isCompleted ?? this.isCompleted,
      isWarmup: isWarmup ?? this.isWarmup,
    );
  }
}

class PlannedExercise {
  final Exercise exercise;
  final int targetSets;
  final int targetRepsMin;
  final int targetRepsMax;
  final double suggestedWeightKg;
  final List<WorkoutSet> completedSets;

  const PlannedExercise({
    required this.exercise,
    required this.targetSets,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.suggestedWeightKg,
    this.completedSets = const [],
  });

  bool get isFullyCompleted =>
      completedSets.where((s) => s.isCompleted && !s.isWarmup).length >= targetSets;

  double get totalVolumeTonnage => completedSets
      .where((s) => s.isCompleted)
      .fold<double>(0.0, (sum, s) => sum + s.volumeTonnageKg);
}

class WorkoutSession {
  final String id;
  final String title;
  final String regionalTitle;
  final String splitCategory; // e.g. "Push Day", "Pull Day", "Legs", "Upper Power"
  final int estimatedDurationMinutes;
  final List<PlannedExercise> plannedExercises;
  final DateTime scheduledDate;
  final bool isCompleted;
  final int? actualDurationMinutes;
  final double? strainRating; // 0.0 to 21.0

  const WorkoutSession({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.splitCategory,
    required this.estimatedDurationMinutes,
    required this.plannedExercises,
    required this.scheduledDate,
    this.isCompleted = false,
    this.actualDurationMinutes,
    this.strainRating,
  });

  int get totalSets => plannedExercises.fold<int>(0, (sum, e) => sum + e.targetSets);
  double get totalVolumeTonnage => plannedExercises.fold<double>(0.0, (sum, e) => sum + e.totalVolumeTonnage);
}
