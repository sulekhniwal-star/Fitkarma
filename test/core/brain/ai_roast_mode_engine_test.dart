import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/ai_roast_mode_engine.dart';
import 'package:fitkarma/core/brain/ai_coach_philosophy.dart';
import 'package:fitkarma/core/brain/ai_context_builder.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';

void main() {
  group('§P12-D AI Roast Mode & Coach Tone Engine Tests', () {
    const engine = AiRoastModeEngine();

    test('CoachTone parses from string properly', () {
      expect(CoachTone.fromString('gentle'), equals(CoachTone.gentle));
      expect(CoachTone.fromString('motivational'), equals(CoachTone.motivational));
      expect(CoachTone.fromString('roast'), equals(CoachTone.roast));
      expect(CoachTone.fromString('no_nonsense'), equals(CoachTone.noNonsense));
      expect(CoachTone.fromString('no nonsense'), equals(CoachTone.noNonsense));
    });

    test('resolveEffectiveTone returns selected tone when no distress is detected', () {
      for (final tone in CoachTone.values) {
        final effective = engine.resolveEffectiveTone(
          selectedTone: tone,
          isDistressDetected: false,
        );
        expect(effective, equals(tone));
      }
    });

    test('resolveEffectiveTone auto-downgrades Roast to Gentle when distress is detected (§P12-D Safeguard)', () {
      final effective = engine.resolveEffectiveTone(
        selectedTone: CoachTone.roast,
        isDistressDetected: true,
      );
      expect(effective, equals(CoachTone.gentle));
    });

    test('resolveEffectiveTone preserves other tones even when distress detected', () {
      expect(
        engine.resolveEffectiveTone(
          selectedTone: CoachTone.motivational,
          isDistressDetected: true,
        ),
        equals(CoachTone.motivational),
      );
      expect(
        engine.resolveEffectiveTone(
          selectedTone: CoachTone.gentle,
          isDistressDetected: true,
        ),
        equals(CoachTone.gentle),
      );
    });

    test('detectDistress flags crisis keywords correctly', () {
      expect(engine.detectDistress(userMessage: "I'm feeling so depressed and overwhelmed today"), isTrue);
      expect(engine.detectDistress(userMessage: "I had a panic attack earlier"), isTrue);
      expect(engine.detectDistress(userMessage: "Giving up on this plan, hate myself"), isTrue);
      expect(engine.detectDistress(userMessage: "What should I eat after workout?"), isFalse);
    });

    test('detectDistress flags acute physiological crisis conditions', () {
      expect(engine.detectDistress(isIllnessActive: true), isTrue);
      expect(engine.detectDistress(isSleepCrisis: true), isTrue);
      expect(engine.detectDistress(isExtremeStress: true), isTrue);
      expect(engine.detectDistress(), isFalse);
    });

    test('getInstruction returns proper system prompt directive for each tone', () {
      final roastInstruction = engine.getInstruction(selectedTone: CoachTone.roast);
      expect(roastInstruction.effectiveTone, equals(CoachTone.roast));
      expect(roastInstruction.isDistressOverridden, isFalse);
      expect(roastInstruction.systemPromptDirective, contains('AI Roast Mode'));

      final gentleInstruction = engine.getInstruction(selectedTone: CoachTone.gentle);
      expect(gentleInstruction.effectiveTone, equals(CoachTone.gentle));
      expect(gentleInstruction.systemPromptDirective, contains('Gentle, compassionate'));

      final noNonsenseInstruction = engine.getInstruction(selectedTone: CoachTone.noNonsense);
      expect(noNonsenseInstruction.effectiveTone, equals(CoachTone.noNonsense));
      expect(noNonsenseInstruction.systemPromptDirective, contains('No Nonsense'));

      // Test distress override instruction
      final overridden = engine.getInstruction(
        selectedTone: CoachTone.roast,
        isDistressDetected: true,
      );
      expect(overridden.effectiveTone, equals(CoachTone.gentle));
      expect(overridden.isDistressOverridden, isTrue);
    });

    test('generateOfflineRoast outputs §P12-D documented humorous responses', () {
      final biryaniRoast = engine.generateOfflineRoast(
        caloriesBurned: 400,
        caloriesConsumed: 900,
        highCalorieFood: 'biryani',
        missedLoggingDays: 0,
        readinessScore: 70,
      );
      expect(biryaniRoast, contains('burned 400 calories'));
      expect(biryaniRoast, contains('900 calories of biryani'));
      expect(biryaniRoast, contains('Respect the hustle. Your goals don\'t.'));

      final missingPersonRoast = engine.generateOfflineRoast(
        caloriesBurned: 200,
        caloriesConsumed: 300,
        highCalorieFood: null,
        missedLoggingDays: 3,
        readinessScore: 80,
      );
      expect(missingPersonRoast, contains('missing persons report'));
    });

    test('AiCoachPhilosophyEngine incorporates CoachTone in generateSystemPrompt', () {
      const philosophy = AiCoachPhilosophyEngine();
      final roastPrompt = philosophy.generateSystemPrompt(
        userName: 'Aarav',
        userGoal: 'Muscle Gain',
        dietType: 'Vegetarian',
        readinessScore: 85,
        sleepDebtMin: 15,
        currentProteinG: 65,
        targetProteinG: 120,
        sorenessSummary: 'Mild shoulder soreness',
        tone: CoachTone.roast,
      );

      expect(roastPrompt, contains('AI Roast Mode'));
      expect(roastPrompt, contains('Aarav'));
      expect(roastPrompt, contains('Readiness Score: 85/100'));
    });

    test('AIContextBuilder preserves and formats CoachTone correctly', () {
      const builder = AIContextBuilder();
      final now = DateTime.now();
      final dip = DailyIntelligencePackage(
        userId: 'u1',
        date: now,
        readinessScore: 84,
        readinessTier: ReadinessTier.enhanced,
        primaryFocus: 'Hypertrophy Training',
        dailyMissions: const ['10k steps', '30g protein breakfast'],
      );

      final context = builder.buildCompressed(
        userId: 'u1',
        name: 'Priya',
        goals: ['Fat Loss'],
        program: 'Lean Fit',
        dietType: 'Non-Vegetarian',
        dip: dip,
        coachTone: CoachTone.roast,
      );

      expect(context.tone, equals('Roast'));
      expect(context.coachTone, equals(CoachTone.roast));
      expect(context.toCompressedPromptString(), contains('Tone: Roast'));
    });
  });
}
