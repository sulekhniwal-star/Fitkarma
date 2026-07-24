import 'package:fitkarma/features/karma/adherence_score_calculator.dart';
import 'package:fitkarma/features/transformation/habit_identity_engine.dart';
import 'package:fitkarma/features/transformation/transformation_journey_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = HabitIdentityEngine();

  const highAdherence = AdherenceResult(
    nutritionScore: 90,
    trainingScore: 90,
    recoveryScore: 85,
    overallScore: 88,
    trend: AdherenceTrend.improving,
    period: 'Last 7 days',
  );

  const memory = TransformationMemory(
    weightHistory: [],
    majorStruggles: [],
    injuries: [],
    successPatterns: [],
    motivationTriggers: [],
    quitAttempts: [],
    primaryPersonality: 'Data-driven',
  );

  group('§P8-C Habit Identity Engine Tests', () {
    test('Unlocks Athlete Identity for training adherence >= 85% & workouts >= 30', () {
      const progress = UserProgressSnapshot(
        workoutsCompletedTotal: 32,
        consecutiveCompliantWeeks: 5,
        proteinTargetHitCount: 15,
        isOfficeProfessional: false,
        isParent: false,
        strengthIncreaseKg: 5.0,
        isIndianDiet: false,
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        adherence: highAdherence,
        memory: memory,
      );

      expect(evolution.persona, IdentityPersona.athlete);
      expect(evolution.hasEvolved, true);
      expect(evolution.badgeTitle, 'Athlete Identity Unlocked');
      expect(evolution.xpBonus, 500);
      expect(evolution.quote, contains('Athletes don\'t ask'));
    });

    test('Unlocks Disciplined Professional for office worker with >= 80% adherence', () {
      const progress = UserProgressSnapshot(
        workoutsCompletedTotal: 15, // Below 30 so doesn't trigger Athlete
        consecutiveCompliantWeeks: 4,
        proteinTargetHitCount: 10,
        isOfficeProfessional: true,
        isParent: false,
        strengthIncreaseKg: 3.0,
        isIndianDiet: false,
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        adherence: highAdherence,
        memory: memory,
      );

      expect(evolution.persona, IdentityPersona.disciplinedPro);
      expect(evolution.badgeTitle, 'Disciplined Professional');
      expect(evolution.xpBonus, 400);
    });

    test('Unlocks Healthy Indian Foodie for Indian diet & protein targets hit >= 20', () {
      const progress = UserProgressSnapshot(
        workoutsCompletedTotal: 12,
        consecutiveCompliantWeeks: 2,
        proteinTargetHitCount: 22,
        isOfficeProfessional: false,
        isParent: false,
        strengthIncreaseKg: 2.0,
        isIndianDiet: true,
      );

      const lowAdherence = AdherenceResult(
        nutritionScore: 70,
        trainingScore: 60,
        recoveryScore: 70,
        overallScore: 65,
        trend: AdherenceTrend.stable,
        period: 'Last 7 days',
      );

      final evolution = engine.checkEvolution(
        progress: progress,
        adherence: lowAdherence,
        memory: memory,
      );

      expect(evolution.persona, IdentityPersona.healthyIndian);
      expect(evolution.badgeTitle, 'Healthy Indian Pioneer');
      expect(evolution.xpBonus, 350);
    });

    test('Formats AI Coach prompt with identity-reinforcement framing', () {
      final coachPrompt = IdentityPromptFormatter.formatForAiCoach(
        IdentityPersona.athlete,
        'Priya',
      );

      expect(coachPrompt, contains('Priya has achieved the "Athlete Identity"'));
      expect(coachPrompt, contains('I am becoming an athlete'));
      expect(coachPrompt, contains('behavior science identity framing'));
    });

    test('Formats Daily Mission header quote', () {
      final header = IdentityPromptFormatter.formatForDailyMission(
        IdentityPersona.disciplinedPro,
      );

      expect(header, contains('💼'));
      expect(header, contains('I am a disciplined professional'));
      expect(header, contains('High performers prioritize recovery'));
    });
  });
}
