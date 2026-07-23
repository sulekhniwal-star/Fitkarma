/// §P6-D Dynamic Fitness Blueprint Generator
///
/// Deterministic program generation from user goal + equipment + experience level.
/// Produces a [FitnessBlueprint] with phases, deload weeks, focus areas,
/// and suggested exercises — matching the §P6-D JSON schema specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Input Enums
// ─────────────────────────────────────────────────────────────────────────────

enum UserGoal {
  fatLoss,
  muscleGain,
  recomposition,
  strength,
  generalFitness,
}

enum EquipmentLevel {
  bodyweightOnly,
  dumbbellsOnly,
  homeGym,       // Dumbbells + barbell + bench + pull-up bar
  fullGym,       // Full commercial gym access
}

enum ExperienceLevel {
  beginner,      // < 6 months training
  intermediate,  // 6 months – 2 years
  advanced,      // 2+ years
}

// ─────────────────────────────────────────────────────────────────────────────
// Output Models
// ─────────────────────────────────────────────────────────────────────────────

/// A single mesocycle phase inside the fitness blueprint.
class FitnessBlueprintPhase {
  const FitnessBlueprintPhase({
    required this.name,
    required this.weekStart,
    required this.weekEnd,
    required this.intensityRpe,
  });

  final String name;
  final int weekStart;
  final int weekEnd;
  final String intensityRpe;

  String get weekRange => '$weekStart-$weekEnd';
}

/// Generated fitness program blueprint (§P6-D Specification).
class FitnessBlueprint {
  const FitnessBlueprint({
    required this.programName,
    required this.durationWeeks,
    required this.daysPerWeek,
    required this.sessionDurationMinutes,
    required this.phases,
    required this.deloadWeeks,
    required this.focusAreas,
    required this.suggestedExercises,
  });

  final String programName;
  final int durationWeeks;
  final int daysPerWeek;
  final int sessionDurationMinutes;
  final List<FitnessBlueprintPhase> phases;
  final List<int> deloadWeeks;
  final List<String> focusAreas;
  final List<String> suggestedExercises;
}

// ─────────────────────────────────────────────────────────────────────────────
// Generator
// ─────────────────────────────────────────────────────────────────────────────

class FitnessBlueprintGenerator {
  const FitnessBlueprintGenerator();

  /// Generates a [FitnessBlueprint] deterministically from goals, equipment, and experience.
  FitnessBlueprint generate({
    required UserGoal goal,
    required EquipmentLevel equipment,
    required ExperienceLevel experience,
  }) {
    switch (goal) {
      case UserGoal.fatLoss:
        return _buildFatLossBlueprint(equipment, experience);
      case UserGoal.muscleGain:
        return _buildMuscleGainBlueprint(equipment, experience);
      case UserGoal.recomposition:
        return _buildRecompBlueprint(equipment, experience);
      case UserGoal.strength:
        return _buildStrengthBlueprint(equipment, experience);
      case UserGoal.generalFitness:
        return _buildGeneralFitnessBlueprint(equipment, experience);
    }
  }

  // ── Fat Loss ──────────────────────────────────────────────────────────────

  FitnessBlueprint _buildFatLossBlueprint(EquipmentLevel equipment, ExperienceLevel experience) {
    final daysPerWeek = experience == ExperienceLevel.beginner ? 3 : 4;
    final duration = 12;
    return FitnessBlueprint(
      programName: _fatLossName(equipment),
      durationWeeks: duration,
      daysPerWeek: daysPerWeek,
      sessionDurationMinutes: 45,
      phases: const [
        FitnessBlueprintPhase(name: 'Foundation', weekStart: 1, weekEnd: 3, intensityRpe: 'RPE 6-7'),
        FitnessBlueprintPhase(name: 'Build', weekStart: 4, weekEnd: 8, intensityRpe: 'RPE 7-8'),
        FitnessBlueprintPhase(name: 'Peak', weekStart: 9, weekEnd: 12, intensityRpe: 'RPE 8-9'),
      ],
      deloadWeeks: const [4, 8, 12],
      focusAreas: const ['Full Body Circuits', 'HIIT Finishers', 'Calorie Deficit Support'],
      suggestedExercises: _fatLossExercises(equipment),
    );
  }

  String _fatLossName(EquipmentLevel equipment) {
    switch (equipment) {
      case EquipmentLevel.bodyweightOnly: return 'Bodyweight Fat Burn';
      case EquipmentLevel.dumbbellsOnly: return 'Dumbbell Shred';
      case EquipmentLevel.homeGym: return 'Home Gym Fat Loss';
      case EquipmentLevel.fullGym: return 'Corporate Fat Loss';
    }
  }

  List<String> _fatLossExercises(EquipmentLevel equipment) {
    switch (equipment) {
      case EquipmentLevel.bodyweightOnly:
        return ['Push-Ups', 'Bodyweight Squats', 'Burpees', 'Mountain Climbers', 'Plank'];
      case EquipmentLevel.dumbbellsOnly:
        return ['Dumbbell Goblet Squat', 'DB Romanian Deadlift', 'DB Press', 'DB Row', 'DB Lunge'];
      case EquipmentLevel.homeGym:
        return ['Barbell Squat', 'Pull-Ups', 'Bench Press', 'Romanian Deadlift', 'DB Lateral Raise'];
      case EquipmentLevel.fullGym:
        return ['Barbell Squat', 'Lat Pulldown', 'Bench Press', 'Leg Press', 'Cable Row', 'Treadmill HIIT'];
    }
  }

  // ── Muscle Gain ───────────────────────────────────────────────────────────

  FitnessBlueprint _buildMuscleGainBlueprint(EquipmentLevel equipment, ExperienceLevel experience) {
    final daysPerWeek = switch (experience) {
      ExperienceLevel.beginner => 3,
      ExperienceLevel.intermediate => 4,
      ExperienceLevel.advanced => 5,
    };
    return FitnessBlueprint(
      programName: _muscleGainName(experience),
      durationWeeks: 16,
      daysPerWeek: daysPerWeek,
      sessionDurationMinutes: 60,
      phases: const [
        FitnessBlueprintPhase(name: 'Hypertrophy A', weekStart: 1, weekEnd: 4, intensityRpe: 'RPE 6-7'),
        FitnessBlueprintPhase(name: 'Hypertrophy B', weekStart: 5, weekEnd: 10, intensityRpe: 'RPE 7-8'),
        FitnessBlueprintPhase(name: 'Intensification', weekStart: 11, weekEnd: 14, intensityRpe: 'RPE 8-9'),
        FitnessBlueprintPhase(name: 'Deload & Test', weekStart: 15, weekEnd: 16, intensityRpe: 'RPE 5-6'),
      ],
      deloadWeeks: const [4, 10, 16],
      focusAreas: const ['Upper / Lower Split', 'Progressive Volume', 'Protein Synthesis Windows'],
      suggestedExercises: _muscleGainExercises(equipment),
    );
  }

  String _muscleGainName(ExperienceLevel experience) {
    switch (experience) {
      case ExperienceLevel.beginner: return 'Beginner Muscle Builder';
      case ExperienceLevel.intermediate: return 'Hypertrophy Recomp';
      case ExperienceLevel.advanced: return 'Advanced Push/Pull/Legs';
    }
  }

  List<String> _muscleGainExercises(EquipmentLevel equipment) {
    if (equipment == EquipmentLevel.bodyweightOnly) {
      return ['Diamond Push-Ups', 'Pike Push-Ups', 'Pull-Ups', 'Dips', 'Nordic Curls', 'Pistol Squats'];
    }
    return ['Barbell Bench Press', 'Barbell Row', 'Overhead Press', 'Barbell Squat', 'Deadlift', 'Incline DB Press', 'Seated Cable Row'];
  }

  // ── Recomposition ─────────────────────────────────────────────────────────

  FitnessBlueprint _buildRecompBlueprint(EquipmentLevel equipment, ExperienceLevel experience) {
    return FitnessBlueprint(
      programName: 'Body Recomposition',
      durationWeeks: 12,
      daysPerWeek: 4,
      sessionDurationMinutes: 55,
      phases: const [
        FitnessBlueprintPhase(name: 'Adaptation', weekStart: 1, weekEnd: 3, intensityRpe: 'RPE 6-7'),
        FitnessBlueprintPhase(name: 'Accumulation', weekStart: 4, weekEnd: 8, intensityRpe: 'RPE 7-8'),
        FitnessBlueprintPhase(name: 'Intensification', weekStart: 9, weekEnd: 12, intensityRpe: 'RPE 8-9'),
      ],
      deloadWeeks: const [4, 8, 12],
      focusAreas: const ['Compound Lifts', 'High Protein Targets', 'Muscle-Fat Concurrent Training'],
      suggestedExercises: _recompExercises(equipment),
    );
  }

  List<String> _recompExercises(EquipmentLevel equipment) {
    if (equipment == EquipmentLevel.bodyweightOnly || equipment == EquipmentLevel.dumbbellsOnly) {
      return ['DB Squat', 'DB Bench Press', 'DB Row', 'Walking Lunges', 'Face Pulls', 'Farmer Carries'];
    }
    return ['Squat', 'Bench Press', 'Deadlift', 'Pull-Ups', 'Cable Row', 'Leg Curl', 'Incline Press'];
  }

  // ── Strength ──────────────────────────────────────────────────────────────

  FitnessBlueprint _buildStrengthBlueprint(EquipmentLevel equipment, ExperienceLevel experience) {
    if (equipment == EquipmentLevel.bodyweightOnly || equipment == EquipmentLevel.dumbbellsOnly) {
      return _buildGeneralFitnessBlueprint(equipment, experience);
    }
    return FitnessBlueprint(
      programName: 'Powerbuilding Strength',
      durationWeeks: 12,
      daysPerWeek: experience == ExperienceLevel.beginner ? 3 : 4,
      sessionDurationMinutes: 75,
      phases: const [
        FitnessBlueprintPhase(name: 'Volume', weekStart: 1, weekEnd: 4, intensityRpe: 'RPE 6-7'),
        FitnessBlueprintPhase(name: 'Intensity', weekStart: 5, weekEnd: 9, intensityRpe: 'RPE 8-9'),
        FitnessBlueprintPhase(name: 'Peak', weekStart: 10, weekEnd: 12, intensityRpe: 'RPE 9-10'),
      ],
      deloadWeeks: const [4, 8, 12],
      focusAreas: const ['Big 3 Compound Lifts', 'Low Rep Heavy Sets (1-5)', 'CNS Adaptation'],
      suggestedExercises: const ['Barbell Back Squat', 'Conventional Deadlift', 'Bench Press', 'Overhead Press', 'Barbell Row'],
    );
  }

  // ── General Fitness ───────────────────────────────────────────────────────

  FitnessBlueprint _buildGeneralFitnessBlueprint(EquipmentLevel equipment, ExperienceLevel experience) {
    return const FitnessBlueprint(
      programName: 'General Fitness Foundation',
      durationWeeks: 8,
      daysPerWeek: 3,
      sessionDurationMinutes: 40,
      phases: [
        FitnessBlueprintPhase(name: 'Foundation', weekStart: 1, weekEnd: 4, intensityRpe: 'RPE 5-7'),
        FitnessBlueprintPhase(name: 'Build', weekStart: 5, weekEnd: 8, intensityRpe: 'RPE 7-8'),
      ],
      deloadWeeks: [4, 8],
      focusAreas: ['Full Body Movement', 'Cardiovascular Base', 'Mobility & Flexibility'],
      suggestedExercises: ['Squats', 'Push-Ups', 'Rows', 'Deadlifts', '20 min Cardio', 'Core Work'],
    );
  }
}
