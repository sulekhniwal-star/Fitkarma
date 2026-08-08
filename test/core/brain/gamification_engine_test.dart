import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/gamification_engine.dart';

void main() {
  group('GamificationEngine Outcome-Based XP & Level Tests', () {
    const engine = GamificationEngine();

    test('Level calculation matches Karma Levels hierarchy per §P7-A spec', () {
      expect(engine.calculateLevel(0).currentLevel, equals(1));
      expect(engine.calculateLevel(250).currentLevel, equals(2));
      expect(engine.calculateLevel(1450).currentLevel, equals(4));
    });

    test('Logging actions strictly yield ZERO XP (anti-spam rule)', () {
      expect(engine.getOutcomeXpReward('log_meal'), equals(0));
      expect(engine.getOutcomeXpReward('log_vitals'), equals(0));
      expect(engine.getOutcomeXpReward('log_sleep'), equals(0));
    });

    test('Outcome completion actions yield valid XP rewards', () {
      expect(engine.getOutcomeXpReward('protein_target_met'), equals(50));
      expect(engine.getOutcomeXpReward('sleep_streak_7d'), equals(80));
      expect(engine.getOutcomeXpReward('program_week_completed'), equals(150));
    });
  });
}
