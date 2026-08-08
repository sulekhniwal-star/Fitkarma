import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/gamification_engine.dart';

void main() {
  group('§P7-A Karma System Design & Outcome XP Tests', () {
    const engine = GamificationEngine();

    test('getOutcomeXpReward awards XP ONLY for health outcomes and milestones per §P7-A spec', () {
      expect(engine.getOutcomeXpReward('protein_target_met'), equals(50));
      expect(engine.getOutcomeXpReward('sleep_streak_7d'), equals(80));
      expect(engine.getOutcomeXpReward('readiness_improved_weekly'), equals(100));
      expect(engine.getOutcomeXpReward('workout_completed_full_intensity'), equals(60));
      expect(engine.getOutcomeXpReward('steps_goal_hit'), equals(30));
      expect(engine.getOutcomeXpReward('water_goal_achieved'), equals(20));
      expect(engine.getOutcomeXpReward('program_week_completed'), equals(150));
      expect(engine.getOutcomeXpReward('streak_milestone_7d'), equals(100));
      expect(engine.getOutcomeXpReward('streak_milestone_90d'), equals(500));
      expect(engine.getOutcomeXpReward('bmi_category_improved'), equals(300));
      expect(engine.getOutcomeXpReward('risk_alert_resolved'), equals(200));
      expect(engine.getOutcomeXpReward('squad_challenge_won'), equals(100));
    });

    test('getOutcomeXpReward strictly returns ZERO XP for logging inputs (anti-perverse incentive rule)', () {
      expect(engine.getOutcomeXpReward('log_food'), equals(0));
      expect(engine.getOutcomeXpReward('log_meal'), equals(0));
      expect(engine.getOutcomeXpReward('log_water'), equals(0));
      expect(engine.getOutcomeXpReward('log_vitals'), equals(0));
      expect(engine.getOutcomeXpReward('log_sleep'), equals(0));
      expect(engine.getOutcomeXpReward('log_workout'), equals(0));
    });

    test('calculateLevel correctly maps Karma Levels and titles per §P7-A spec table', () {
      final lvl1 = engine.calculateLevel(0);
      expect(lvl1.currentLevel, equals(1));
      expect(lvl1.levelName, equals('Beginner'));

      final lvl2 = engine.calculateLevel(250);
      expect(lvl2.currentLevel, equals(2));
      expect(lvl2.levelName, equals('Seeker'));
      expect(lvl2.xpInCurrentLevel, equals(50));

      final lvl4 = engine.calculateLevel(1450);
      expect(lvl4.currentLevel, equals(4));
      expect(lvl4.levelName, equals('Builder'));
      expect(lvl4.xpInCurrentLevel, equals(450));
      expect(lvl4.xpNeededForNextLevel, equals(1000));
      expect(lvl4.levelProgressRatio, equals(0.45));

      final lvl10 = engine.calculateLevel(12000);
      expect(lvl10.currentLevel, equals(10));
      expect(lvl10.levelName, equals('Champion'));

      final lvl20 = engine.calculateLevel(65000);
      expect(lvl20.currentLevel, equals(20));
      expect(lvl20.levelName, equals('Legend'));
    });
  });
}
