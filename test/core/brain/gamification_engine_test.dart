import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/gamification_engine.dart';

void main() {
  group('GamificationEngine Outcome-Based XP & Level Tests', () {
    const engine = GamificationEngine();

    test('Level calculation matches formula floor(sqrt(XP / 100)) + 1', () {
      // 0 XP -> Level 1
      expect(engine.calculateLevel(0).currentLevel, equals(1));
      // 400 XP -> Level 3
      expect(engine.calculateLevel(400).currentLevel, equals(3));
      // 900 XP -> Level 4
      expect(engine.calculateLevel(900).currentLevel, equals(4));
    });

    test('Logging actions strictly yield ZERO XP (anti-spam rule)', () {
      expect(engine.getOutcomeXpReward('log_meal'), equals(0));
      expect(engine.getOutcomeXpReward('log_vitals'), equals(0));
      expect(engine.getOutcomeXpReward('log_sleep'), equals(0));
    });

    test('Outcome completion actions yield valid XP rewards', () {
      expect(engine.getOutcomeXpReward('workout_completed'), equals(150));
      expect(engine.getOutcomeXpReward('protein_target_met'), equals(100));
      expect(engine.getOutcomeXpReward('readiness_streak_7d'), equals(300));
    });
  });
}
