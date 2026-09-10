import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/festival_life_events/domain/ai_roast_engine.dart';
import 'package:fitkarma/features/festival_life_events/domain/ai_roast_models.dart';

void main() {
  group('AiRoastEngine Deterministic Tests', () {
    const engine = AiRoastEngine();

    test('Generates Desi Gym Bro roast with pushup challenge on missed workout',
        () {
      final roast = engine.generateRoast(
        persona: RoastPersona.desiGymBro,
        intensity: RoastIntensity.desiToughLove,
        trigger: RoastTriggerEvent.missedWorkout,
      );

      expect(roast.persona, equals(RoastPersona.desiGymBro));
      expect(roast.trigger, equals(RoastTriggerEvent.missedWorkout));
      expect(roast.headlinePunchline, contains('Reel Scroll'));
      expect(roast.fullRoastEnglish, contains('Thumb curls'));
      expect(roast.fullRoastHindi, contains('रील्स'));
      expect(roast.actionableActionChallenge, contains('25 pushups'));
    });

    test('Generates Strict Desi Parent roast with Sharma ji references', () {
      final roast = engine.generateRoast(
        persona: RoastPersona.strictDesiParent,
        intensity: RoastIntensity.savageUnfiltered,
        trigger: RoastTriggerEvent.missedWorkout,
      );

      expect(roast.persona, equals(RoastPersona.strictDesiParent));
      expect(roast.headlinePunchline, contains('Sharma Ji'));
      expect(roast.fullRoastHindi, contains('शर्मा जी के बेटे'));
      expect(roast.actionableActionChallenge, contains('15-minute brisk walk'));
    });

    test('Generates Sarcastic Vaidya roast for sedentary screen slump', () {
      final roast = engine.generateRoast(
        persona: RoastPersona.sarcasticVaidya,
        intensity: RoastIntensity.mildSarcasm,
        trigger: RoastTriggerEvent.sedentarySlump,
      );

      expect(roast.headlinePunchline, contains('Permanent Furniture'));
      expect(roast.actionableActionChallenge, contains('15 air squats'));
    });

    test('Builds safe, structured LLM prompt system instruction for Groq', () {
      final prompt = engine.buildSystemInstruction(
        RoastPersona.desiGymBro,
        RoastIntensity.desiToughLove,
      );

      expect(prompt, contains('Desi Gym Bro'));
      expect(prompt, contains('NEVER use abusive slurs'));
      expect(prompt, contains('Bhai form dekh'));
    });

    test(
        'All persona and trigger combinations produce non-empty valid artifacts',
        () {
      for (final persona in RoastPersona.values) {
        for (final trigger in RoastTriggerEvent.values) {
          final roast = engine.generateRoast(
            persona: persona,
            intensity: RoastIntensity.desiToughLove,
            trigger: trigger,
          );

          expect(roast.headlinePunchline, isNotEmpty);
          expect(roast.fullRoastEnglish, isNotEmpty);
          expect(roast.fullRoastHindi, isNotEmpty);
          expect(roast.actionableActionChallenge, isNotEmpty);
          expect(roast.regionalActionChallenge, isNotEmpty);
        }
      }
    });
  });
}
