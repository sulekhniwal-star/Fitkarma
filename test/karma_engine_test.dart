import 'package:fitkarma/features/karma/karma_engine.dart';
import 'package:fitkarma/features/karma/karma_models.dart';
import 'package:fitkarma/features/karma/karma_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = KarmaEngine();

  group('§P7-A Karma System — Outcome XP Values', () {
    test('Verifies exact XP values for all outcome event types', () {
      expect(KarmaEventType.proteinTargetHit.baseXp, 50);
      expect(KarmaEventType.sleepStreak7d.baseXp, 80);
      expect(KarmaEventType.readinessImproved.baseXp, 100);
      expect(KarmaEventType.workoutFullIntensity.baseXp, 60);
      expect(KarmaEventType.stepsGoalHit.baseXp, 30);
      expect(KarmaEventType.waterGoalHit.baseXp, 20);
      expect(KarmaEventType.programWeekCompleted.baseXp, 150);
      expect(KarmaEventType.streakMilestone7d.baseXp, 100);
      expect(KarmaEventType.streakMilestone14d.baseXp, 150);
      expect(KarmaEventType.streakMilestone30d.baseXp, 200);
      expect(KarmaEventType.streakMilestone90d.baseXp, 500);
      expect(KarmaEventType.bmiCategoryImproved.baseXp, 300);
      expect(KarmaEventType.riskAlertResolved.baseXp, 200);
      expect(KarmaEventType.squadChallengeWon.baseXp, 100);
    });
  });

  group('§P7-A Karma System — Level Table & Progression', () {
    test('Resolves correct level names and numbers across XP thresholds', () {
      expect(KarmaLevelTable.getLevelForXp(0).name, 'Beginner');
      expect(KarmaLevelTable.getLevelForXp(0).levelNumber, 1);

      expect(KarmaLevelTable.getLevelForXp(200).name, 'Seeker');
      expect(KarmaLevelTable.getLevelForXp(200).levelNumber, 2);

      expect(KarmaLevelTable.getLevelForXp(500).name, 'Striver');
      expect(KarmaLevelTable.getLevelForXp(500).levelNumber, 3);

      expect(KarmaLevelTable.getLevelForXp(1000).name, 'Builder');
      expect(KarmaLevelTable.getLevelForXp(1000).levelNumber, 4);

      expect(KarmaLevelTable.getLevelForXp(2000).name, 'Achiever');
      expect(KarmaLevelTable.getLevelForXp(2000).levelNumber, 5);

      expect(KarmaLevelTable.getLevelForXp(5000).name, 'Warrior');
      expect(KarmaLevelTable.getLevelForXp(5000).levelNumber, 8);

      expect(KarmaLevelTable.getLevelForXp(10000).name, 'Champion');
      expect(KarmaLevelTable.getLevelForXp(10000).levelNumber, 10);

      expect(KarmaLevelTable.getLevelForXp(25000).name, 'Elite');
      expect(KarmaLevelTable.getLevelForXp(25000).levelNumber, 15);

      expect(KarmaLevelTable.getLevelForXp(60000).name, 'Legend');
      expect(KarmaLevelTable.getLevelForXp(60000).levelNumber, 20);
    });

    test('Calculates level progress percentage correctly', () {
      // 0 XP -> Level 1 Beginner -> next Level 2 (200 XP required)
      final p1 = engine.calculateProfile(0);
      expect(p1.currentLevel.levelNumber, 1);
      expect(p1.progressToNextLevel, 0.0);
      expect(p1.xpNeededForNextLevel, 200);

      // 100 XP -> 50% progress to Level 2
      final p2 = engine.calculateProfile(100);
      expect(p2.progressToNextLevel, 0.5);
      expect(p2.xpInCurrentLevel, 100);
      expect(p2.xpNeededForNextLevel, 100);

      // 60000 XP -> Max Level Legend
      final pMax = engine.calculateProfile(60000);
      expect(pMax.isMaxLevel, true);
      expect(pMax.progressToNextLevel, 1.0);
      expect(pMax.xpNeededForNextLevel, 0);
    });

    test('Detects level-up transition correctly', () {
      expect(engine.isLevelUp(150, 50), true); // 150 -> 200 (L1 -> L2)
      expect(engine.isLevelUp(150, 20), false); // 150 -> 170 (L1 -> L1)
    });
  });

  group('§P7-A Karma System — Repository Tests', () {
    late KarmaRepository repo;

    setUp(() {
      repo = KarmaRepository();
    });

    test('Records outcome events and computes cumulative total XP', () {
      repo.recordOutcomeEvent(KarmaEventType.proteinTargetHit);
      repo.recordOutcomeEvent(KarmaEventType.streakMilestone7d);

      expect(repo.totalXp, 150);
      expect(repo.eventHistory.length, 2);
      expect(repo.profileSummary.currentLevel.levelNumber, 1);

      // Record another event to reach Level 2 Seeker (200 XP)
      repo.recordOutcomeEvent(KarmaEventType.proteinTargetHit);
      expect(repo.totalXp, 200);
      expect(repo.profileSummary.currentLevel.name, 'Seeker');
      expect(repo.profileSummary.currentLevel.levelNumber, 2);
    });
  });
}
