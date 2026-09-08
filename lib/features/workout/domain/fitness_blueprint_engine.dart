import '../data/exercise_database.dart';
import 'workout_models.dart';

enum FitnessGoal {
  hypertrophy(
    label: 'Muscle Hypertrophy',
    regionalLabel: 'मांसपेशी निर्माण (हाइपरट्रॉफी)',
    repsMin: 8,
    repsMax: 12,
    restSeconds: 90,
  ),
  fatLossConditioning(
    label: 'Fat Loss & Conditioning',
    regionalLabel: 'वसा कटौती एवं सहनशक्ति',
    repsMin: 12,
    repsMax: 16,
    restSeconds: 60,
  ),
  akharaStrength(
    label: 'Traditional Akhara Power',
    regionalLabel: 'अखाड़ा शक्ति एवं कुश्ती कंडीशनिंग',
    repsMin: 15,
    repsMax: 25,
    restSeconds: 75,
  ),
  strengthLongevity(
    label: 'Strength & Joint Longevity',
    regionalLabel: 'शक्ति एवं दीर्घायु लचीलापन',
    repsMin: 5,
    repsMax: 8,
    restSeconds: 120,
  );

  final String label;
  final String regionalLabel;
  final int repsMin;
  final int repsMax;
  final int restSeconds;

  const FitnessGoal({
    required this.label,
    required this.regionalLabel,
    required this.repsMin,
    required this.repsMax,
    required this.restSeconds,
  });
}

enum TrainingExperience {
  beginner(label: 'Beginner (<1 year)', regionalLabel: 'शुरुआती स्तर', setsPerExercise: 3),
  intermediate(label: 'Intermediate (1–3 years)', regionalLabel: 'मध्यम स्तर', setsPerExercise: 4),
  advanced(label: 'Advanced (3+ years)', regionalLabel: 'उन्नत स्तर', setsPerExercise: 4);

  final String label;
  final String regionalLabel;
  final int setsPerExercise;

  const TrainingExperience({
    required this.label,
    required this.regionalLabel,
    required this.setsPerExercise,
  });
}

enum EquipmentEnvironment {
  commercialGym(label: 'Full Commercial Gym', regionalLabel: 'पूर्ण सुसज्जित जिम'),
  homeGymDumbbells(label: 'Home Gym (Dumbbells & Pull-up Bar)', regionalLabel: 'घरेलू डंबल जिम'),
  akharaCalisthenics(label: 'Akhara / Calisthenics / Mudgar', regionalLabel: 'अखाड़ा एवं पारंपरिक व्यायाम');

  final String label;
  final String regionalLabel;

  const EquipmentEnvironment({
    required this.label,
    required this.regionalLabel,
  });
}

class FitnessBlueprint {
  final String id;
  final String title;
  final String regionalTitle;
  final FitnessGoal goal;
  final TrainingExperience experience;
  final EquipmentEnvironment equipment;
  final int frequencyDaysPerWeek;
  final int cycleDurationWeeks;
  final List<WorkoutSession> weeklySessions;
  final Map<MuscleGroup, int> weeklyVolumeDistribution;
  final String periodizationFramework;
  final String biomechanicalRationale;

  const FitnessBlueprint({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.goal,
    required this.experience,
    required this.equipment,
    required this.frequencyDaysPerWeek,
    required this.cycleDurationWeeks,
    required this.weeklySessions,
    required this.weeklyVolumeDistribution,
    required this.periodizationFramework,
    required this.biomechanicalRationale,
  });

  int get totalWeeklySets =>
      weeklyVolumeDistribution.values.fold<int>(0, (sum, sets) => sum + sets);
}

class FitnessBlueprintEngine {
  /// Pure Dart deterministic generator of personalized, periodized fitness training blueprints
  static FitnessBlueprint generateBlueprint({
    required FitnessGoal goal,
    required TrainingExperience experience,
    required EquipmentEnvironment equipment,
    required int frequencyDaysPerWeek,
  }) {
    final freq = frequencyDaysPerWeek.clamp(3, 6);
    final setsCount = experience.setsPerExercise;
    final List<WorkoutSession> sessions = [];

    final isAkhara = equipment == EquipmentEnvironment.akharaCalisthenics;
    final isHome = equipment == EquipmentEnvironment.homeGymDumbbells;

    if (freq == 3) {
      // 3-Day Full Body Periodization
      sessions.add(_buildFullBodySession('Session A: Quad & Horizontal Push Focus', 'सत्र ए: क्वाड्स एवं चेस्ट', 1, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildFullBodySession('Session B: Posterior Chain & Vertical Pull Focus', 'सत्र बी: हैमस्ट्रिंग्स एवं बैक', 3, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildFullBodySession('Session C: Akhara Gada & Conditioning Focus', 'सत्र सी: अखाड़ा गदा एवं कंडीशनिंग', 5, goal, setsCount, isAkhara, isHome));
    } else if (freq == 4) {
      // 4-Day Upper / Lower Split
      sessions.add(_buildUpperSession('Upper Body Power A', 'अपर बॉडी पावर ए', 1, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildLowerSession('Lower Body Strength A', 'लोअर बॉडी स्ट्रेंथ ए', 2, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildUpperSession('Upper Body Hypertrophy B', 'अपर बॉडी हाइपरट्रॉफी बी', 4, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildLowerSession('Lower Body & Core B', 'लोअर बॉडी एवं कोर बी', 5, goal, setsCount, isAkhara, isHome));
    } else if (freq == 5) {
      // 5-Day Push / Pull / Legs / Upper / Lower
      sessions.add(_buildPushSession('Push Day: Chest & Shoulders', 'पुश डे: चेस्ट एवं शोल्डर्स', 1, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildPullSession('Pull Day: Lats & Upper Back', 'पुल डे: लैट्स एवं बैक', 2, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildLowerSession('Legs Day: Quads & Hamstrings', 'लेग्स डे: क्वाड्स एवं हैमस्ट्रिंग्स', 3, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildUpperSession('Upper Body Density', 'अपर बॉडी डेंसिटी', 5, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildLowerSession('Lower Body & Akhara Baithak', 'लोअर बॉडी एवं देसी बैठक', 6, goal, setsCount, isAkhara, isHome));
    } else {
      // 6-Day Push / Pull / Legs x 2
      sessions.add(_buildPushSession('Push Hypertrophy 1', 'पुश हाइपरट्रॉफी १', 1, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildPullSession('Pull Density 1', 'पुल डेंसिटी १', 2, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildLowerSession('Legs & Akhara 1', 'लेग्स एवं अखाड़ा १', 3, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildPushSession('Push Power 2', 'पुश पावर २', 4, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildPullSession('Pull Strength 2', 'पुल स्ट्रेंथ २', 5, goal, setsCount, isAkhara, isHome));
      sessions.add(_buildLowerSession('Legs & Posterior 2', 'लेग्स एवं पोस्टीरियर २', 6, goal, setsCount, isAkhara, isHome));
    }

    // Calculate weekly volume distribution across muscle groups
    final Map<MuscleGroup, int> volumeMap = {};
    for (final session in sessions) {
      for (final planned in session.plannedExercises) {
        final muscle = planned.exercise.targetMuscle;
        volumeMap[muscle] = (volumeMap[muscle] ?? 0) + planned.targetSets;
      }
    }

    final blueprintTitle = '${experience.label.split(' ')[0]} ${goal.label} ($freq-Day Split)';
    final regionalTitle = '${goal.regionalLabel} ($freq दिवसीय योजना)';

    return FitnessBlueprint(
      id: 'blueprint_${goal.name}_${freq}d',
      title: blueprintTitle,
      regionalTitle: regionalTitle,
      goal: goal,
      experience: experience,
      equipment: equipment,
      frequencyDaysPerWeek: freq,
      cycleDurationWeeks: 4,
      weeklySessions: sessions,
      weeklyVolumeDistribution: volumeMap,
      periodizationFramework: '4-Week Mesocycle: 3 Weeks Progressive Overload Accumulation + 1 Week Active Recovery Deload.',
      biomechanicalRationale: 'Optimized for ${equipment.label} with $freq training days per week. '
          'Delivers an optimal 12-18 weekly direct sets per muscle group for maximum mechanical tension.',
    );
  }

  static WorkoutSession _buildPushSession(String title, String regionalTitle, int dayOffset, FitnessGoal goal, int sets, bool isAkhara, bool isHome) {
    final List<PlannedExercise> exercises = [];

    if (isAkhara) {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[2], sets, goal, 0.0)); // Desi Dand
      exercises.add(_createPlanned(ExerciseDatabase.exercises[10], sets, goal, 0.0)); // Mudgar Swing
      exercises.add(_createPlanned(ExerciseDatabase.exercises[12], sets, goal, 0.0)); // Tricep rope or pushdowns
    } else if (isHome) {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[1], sets, goal, 20.0)); // Incline DB Press
      exercises.add(_createPlanned(ExerciseDatabase.exercises[2], sets, goal, 0.0)); // Desi Dand
      exercises.add(_createPlanned(ExerciseDatabase.exercises[9], sets, goal, 7.5)); // Lateral Raise
      exercises.add(_createPlanned(ExerciseDatabase.exercises[12], sets, goal, 12.5)); // Triceps
    } else {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[0], sets, goal, 70.0)); // Flat BB Bench
      exercises.add(_createPlanned(ExerciseDatabase.exercises[1], sets, goal, 24.0)); // Incline DB
      exercises.add(_createPlanned(ExerciseDatabase.exercises[8], sets, goal, 45.0)); // OHP
      exercises.add(_createPlanned(ExerciseDatabase.exercises[9], sets, goal, 7.5)); // Lateral raise
    }

    return WorkoutSession(
      id: 'sess_push_$dayOffset',
      title: title,
      regionalTitle: regionalTitle,
      splitCategory: 'Push Focus',
      estimatedDurationMinutes: 45 + (exercises.length * 2),
      scheduledDate: DateTime.now().add(Duration(days: dayOffset)),
      plannedExercises: exercises,
    );
  }

  static WorkoutSession _buildPullSession(String title, String regionalTitle, int dayOffset, FitnessGoal goal, int sets, bool isAkhara, bool isHome) {
    final List<PlannedExercise> exercises = [];

    if (isAkhara) {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[10], sets, goal, 0.0)); // Mudgar Swing
      exercises.add(_createPlanned(ExerciseDatabase.exercises[13], sets, goal, 0.0)); // Hanging Leg Raise
      exercises.add(_createPlanned(ExerciseDatabase.exercises[4], sets, goal, 40.0)); // Row
    } else {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[3], sets, goal, 55.0)); // Lat Pulldown
      exercises.add(_createPlanned(ExerciseDatabase.exercises[4], sets, goal, 50.0)); // Barbell Row
      exercises.add(_createPlanned(ExerciseDatabase.exercises[11], sets, goal, 14.0)); // Incline DB Curl
      exercises.add(_createPlanned(ExerciseDatabase.exercises[13], sets, goal, 0.0)); // Hanging Leg Raise
    }

    return WorkoutSession(
      id: 'sess_pull_$dayOffset',
      title: title,
      regionalTitle: regionalTitle,
      splitCategory: 'Pull Focus',
      estimatedDurationMinutes: 45 + (exercises.length * 2),
      scheduledDate: DateTime.now().add(Duration(days: dayOffset)),
      plannedExercises: exercises,
    );
  }

  static WorkoutSession _buildLowerSession(String title, String regionalTitle, int dayOffset, FitnessGoal goal, int sets, bool isAkhara, bool isHome) {
    final List<PlannedExercise> exercises = [];

    if (isAkhara) {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[6], sets, goal, 0.0)); // Desi Baithak
      exercises.add(_createPlanned(ExerciseDatabase.exercises[7], sets, goal, 40.0)); // RDL
      exercises.add(_createPlanned(ExerciseDatabase.exercises[13], sets, goal, 0.0)); // Core
    } else {
      exercises.add(_createPlanned(ExerciseDatabase.exercises[5], sets, goal, 80.0)); // BB Squat
      exercises.add(_createPlanned(ExerciseDatabase.exercises[7], sets, goal, 70.0)); // RDL
      exercises.add(_createPlanned(ExerciseDatabase.exercises[6], sets, goal, 0.0)); // Desi Baithak finisher
      exercises.add(_createPlanned(ExerciseDatabase.exercises[13], sets, goal, 0.0)); // Core
    }

    return WorkoutSession(
      id: 'sess_lower_$dayOffset',
      title: title,
      regionalTitle: regionalTitle,
      splitCategory: 'Legs & Core',
      estimatedDurationMinutes: 50 + (exercises.length * 2),
      scheduledDate: DateTime.now().add(Duration(days: dayOffset)),
      plannedExercises: exercises,
    );
  }

  static WorkoutSession _buildUpperSession(String title, String regionalTitle, int dayOffset, FitnessGoal goal, int sets, bool isAkhara, bool isHome) {
    final List<PlannedExercise> exercises = [
      _createPlanned(ExerciseDatabase.exercises[0], sets, goal, 65.0),
      _createPlanned(ExerciseDatabase.exercises[3], sets, goal, 50.0),
      _createPlanned(ExerciseDatabase.exercises[9], sets, goal, 7.5),
      _createPlanned(ExerciseDatabase.exercises[11], sets, goal, 12.5),
    ];

    return WorkoutSession(
      id: 'sess_upper_$dayOffset',
      title: title,
      regionalTitle: regionalTitle,
      splitCategory: 'Upper Body',
      estimatedDurationMinutes: 48,
      scheduledDate: DateTime.now().add(Duration(days: dayOffset)),
      plannedExercises: exercises,
    );
  }

  static WorkoutSession _buildFullBodySession(String title, String regionalTitle, int dayOffset, FitnessGoal goal, int sets, bool isAkhara, bool isHome) {
    final List<PlannedExercise> exercises = [
      _createPlanned(ExerciseDatabase.exercises[5], sets, goal, 70.0), // Squat
      _createPlanned(ExerciseDatabase.exercises[0], sets, goal, 60.0), // Bench
      _createPlanned(ExerciseDatabase.exercises[4], sets, goal, 45.0), // Row
      _createPlanned(ExerciseDatabase.exercises[10], sets, goal, 0.0), // Mudgar / Gada
    ];

    return WorkoutSession(
      id: 'sess_fb_$dayOffset',
      title: title,
      regionalTitle: regionalTitle,
      splitCategory: 'Full Body',
      estimatedDurationMinutes: 52,
      scheduledDate: DateTime.now().add(Duration(days: dayOffset)),
      plannedExercises: exercises,
    );
  }

  static PlannedExercise _createPlanned(Exercise ex, int sets, FitnessGoal goal, double baseWeight) {
    return PlannedExercise(
      exercise: ex,
      targetSets: sets,
      targetRepsMin: goal.repsMin,
      targetRepsMax: goal.repsMax,
      suggestedWeightKg: baseWeight,
      completedSets: List.generate(
        sets,
        (idx) => WorkoutSet(
          setNumber: idx + 1,
          weightKg: baseWeight,
          reps: goal.repsMin,
          rpe: 8.0,
          isCompleted: false,
        ),
      ),
    );
  }
}
