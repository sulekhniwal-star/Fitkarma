import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/progressive_overload_engine.dart';
import 'package:fitkarma/core/brain/gamification_engine.dart';

void main() {
  group(
      '§P14-C Integration: Workout Logging -> Progressive Overload -> XP & Level Up',
      () {
    const overloadEngine = ProgressiveOverloadEngine();
    const gamificationEngine = GamificationEngine();

    test(
        'Completed workout sets compute progressive overload targets for next session',
        () {
      final target = overloadEngine.calculateNextTarget(
        previousWeightKg: 80.0,
        previousReps: 10,
        rpe: 6.5, // Solid form, top of rep range (<= 7.0)
        readinessScore: 85, // High readiness (>= 75)
      );

      // Hit top of rep range with good RPE -> weight increase to 82.5kg
      expect(target.weightKg, equals(82.5));
      expect(target.progressionType, equals(ProgressionType.increaseWeight));
      expect(target.recommendationReason, contains('Increment weight'));
    });

    test('Logging outcome milestone awards Karma XP and triggers Level Up', () {
      const initialXp = 950;
      const initialLevel = 3;

      // Award XP for full intensity workout completion and program milestone
      final workoutXp = gamificationEngine
          .getOutcomeXpReward('workout_completed_full_intensity');
      final programMilestoneXp =
          gamificationEngine.getOutcomeXpReward('program_week_completed');

      final totalNewXp = initialXp +
          workoutXp +
          programMilestoneXp; // 950 + 60 + 150 = 1160 XP

      final levelResult = gamificationEngine.calculateLevel(
        totalNewXp,
        previousLevel: initialLevel,
      );

      // Level 4 threshold is 1000 XP (Builder)
      expect(levelResult.totalXp, equals(1160));
      expect(levelResult.currentLevel, equals(4));
      expect(levelResult.levelName, equals('Builder'));
      expect(levelResult.didLevelUp, isTrue);
    });
  });
}
