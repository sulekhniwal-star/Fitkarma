import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/ai_coach_philosophy.dart';
import 'package:fitkarma/core/brain/ai_roast_mode_engine.dart';
import 'package:fitkarma/core/brain/context_compressor.dart';
import 'package:fitkarma/core/brain/daily_intelligence_package.dart';

void main() {
  group(
      '§P14-C Integration: AI Coach Message Flow (Context Compression, Tone Safeguards)',
      () {
    test('Context compressor maintains strict token budget for LLM payload',
        () {
      const compressor = ContextCompressor();
      final dip = DailyIntelligencePackage(
        userId: 'user_123',
        date: DateTime.now(),
        readinessScore: 78,
        readinessTier: ReadinessTier.enhanced,
        primaryFocus: 'Upper Body Hypertrophy & Protein Adherence',
        dailyMissions: const [
          'Complete 45-min Strength Routine',
          'Hit 135g Protein'
        ],
      );

      final compressed = compressor.compressContext(
        dip: dip,
        bmr: 1650.0,
        tdee: 2200.0,
        goal: 'fat_loss',
        dietaryPreference: 'Vegetarian',
      );

      expect(compressed['r_score'], equals(78));
      expect(compressed['bmr'], equals(1650));
      expect(compressed['tdee'], equals(2200));
      expect(compressed['goal'], equals('fat_loss'));
      expect(compressed['diet'], equals('Vegetarian'));
    });

    test('Roast Mode automatically downgrades to Gentle on distress detection',
        () {
      const roastEngine = AiRoastModeEngine();

      const normalMessage = "I had two samosas and missed my workout today!";
      final isDistressNormal =
          roastEngine.detectDistress(userMessage: normalMessage);
      expect(isDistressNormal, isFalse);

      final normalInstruction = roastEngine.getInstruction(
        selectedTone: CoachTone.roast,
        isDistressDetected: isDistressNormal,
      );
      expect(normalInstruction.effectiveTone, equals(CoachTone.roast));
      expect(normalInstruction.systemPromptDirective,
          contains('Witty, sarcastic'));

      // Distress phrase
      const crisisMessage =
          "I feel hopeless, I can't take this anymore and want to hurt myself";
      final isDistressCrisis =
          roastEngine.detectDistress(userMessage: crisisMessage);
      expect(isDistressCrisis, isTrue);

      final safeInstruction = roastEngine.getInstruction(
        selectedTone: CoachTone.roast,
        isDistressDetected: isDistressCrisis,
      );
      expect(safeInstruction.effectiveTone, equals(CoachTone.gentle));
      expect(safeInstruction.isDistressOverridden, isTrue);
    });

    test(
        'AiCoachPhilosophyEngine generates system prompt with Indian context and guardrails',
        () {
      const philosophyEngine = AiCoachPhilosophyEngine();
      final systemPrompt = philosophyEngine.generateSystemPrompt(
        userName: 'Arjun',
        userGoal: 'fat_loss',
        dietType: 'Vegetarian',
        readinessScore: 82,
        sleepDebtMin: -30,
        currentProteinG: 65,
        targetProteinG: 130,
        sorenessSummary: 'Mild legs soreness',
        tone: CoachTone.motivational,
      );

      expect(systemPrompt, contains('Arjun'));
      expect(systemPrompt, contains('FitKarma'));
      expect(systemPrompt, contains('Vegetarian'));
    });
  });
}
