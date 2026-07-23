import 'package:fitkarma/features/workout/fitness_blueprint_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const generator = FitnessBlueprintGenerator();

  group('FitnessBlueprintGenerator Unit Tests', () {
    test('Fat Loss + Full Gym → Corporate Fat Loss blueprint (§P6-D JSON spec)', () {
      final bp = generator.generate(
        goal: UserGoal.fatLoss,
        equipment: EquipmentLevel.fullGym,
        experience: ExperienceLevel.intermediate,
      );

      expect(bp.programName, 'Corporate Fat Loss');
      expect(bp.durationWeeks, 12);
      expect(bp.daysPerWeek, 4);
      expect(bp.sessionDurationMinutes, 45);
      expect(bp.phases.length, 3);
      expect(bp.phases[0].name, 'Foundation');
      expect(bp.phases[0].weekRange, '1-3');
      expect(bp.phases[0].intensityRpe, 'RPE 6-7');
      expect(bp.phases[2].name, 'Peak');
      expect(bp.deloadWeeks, [4, 8, 12]);
      expect(bp.suggestedExercises, contains('Treadmill HIIT'));
    });

    test('Fat Loss + Beginner → 3 days/week program', () {
      final bp = generator.generate(
        goal: UserGoal.fatLoss,
        equipment: EquipmentLevel.fullGym,
        experience: ExperienceLevel.beginner,
      );

      expect(bp.daysPerWeek, 3);
    });

    test('Fat Loss + Bodyweight Only → Bodyweight Fat Burn blueprint', () {
      final bp = generator.generate(
        goal: UserGoal.fatLoss,
        equipment: EquipmentLevel.bodyweightOnly,
        experience: ExperienceLevel.beginner,
      );

      expect(bp.programName, 'Bodyweight Fat Burn');
      expect(bp.suggestedExercises, contains('Burpees'));
    });

    test('Muscle Gain + Intermediate → Hypertrophy Recomp, 4 days, 16 weeks, 4 phases', () {
      final bp = generator.generate(
        goal: UserGoal.muscleGain,
        equipment: EquipmentLevel.fullGym,
        experience: ExperienceLevel.intermediate,
      );

      expect(bp.programName, 'Hypertrophy Recomp');
      expect(bp.durationWeeks, 16);
      expect(bp.daysPerWeek, 4);
      expect(bp.sessionDurationMinutes, 60);
      expect(bp.phases.length, 4);
      expect(bp.deloadWeeks, [4, 10, 16]);
      expect(bp.suggestedExercises, contains('Deadlift'));
    });

    test('Muscle Gain + Advanced → 5 days/week Push/Pull/Legs', () {
      final bp = generator.generate(
        goal: UserGoal.muscleGain,
        equipment: EquipmentLevel.fullGym,
        experience: ExperienceLevel.advanced,
      );

      expect(bp.daysPerWeek, 5);
      expect(bp.programName, 'Advanced Push/Pull/Legs');
    });

    test('Strength + Full Gym → Powerbuilding Strength with Big 3 exercises', () {
      final bp = generator.generate(
        goal: UserGoal.strength,
        equipment: EquipmentLevel.fullGym,
        experience: ExperienceLevel.intermediate,
      );

      expect(bp.programName, 'Powerbuilding Strength');
      expect(bp.phases.last.intensityRpe, 'RPE 9-10');
      expect(bp.suggestedExercises, contains('Conventional Deadlift'));
      expect(bp.suggestedExercises, contains('Barbell Back Squat'));
    });

    test('Recomposition generates 12-week 4-day program with compound lifts focus', () {
      final bp = generator.generate(
        goal: UserGoal.recomposition,
        equipment: EquipmentLevel.fullGym,
        experience: ExperienceLevel.intermediate,
      );

      expect(bp.programName, 'Body Recomposition');
      expect(bp.durationWeeks, 12);
      expect(bp.daysPerWeek, 4);
      expect(bp.focusAreas, contains('High Protein Targets'));
    });

    test('General Fitness → 8-week 3-day foundation program', () {
      final bp = generator.generate(
        goal: UserGoal.generalFitness,
        equipment: EquipmentLevel.bodyweightOnly,
        experience: ExperienceLevel.beginner,
      );

      expect(bp.programName, 'General Fitness Foundation');
      expect(bp.durationWeeks, 8);
      expect(bp.daysPerWeek, 3);
      expect(bp.phases.length, 2);
      expect(bp.deloadWeeks, [4, 8]);
    });

    test('FitnessBlueprintPhase weekRange formats correctly', () {
      const phase = FitnessBlueprintPhase(
        name: 'Build',
        weekStart: 4,
        weekEnd: 8,
        intensityRpe: 'RPE 7-8',
      );

      expect(phase.weekRange, '4-8');
    });
  });
}
