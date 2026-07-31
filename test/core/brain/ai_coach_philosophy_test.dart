import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/ai_coach_philosophy.dart';

void main() {
  group('§P3-A AI Coach Philosophy & Guardrails Tests', () {
    const engine = AiCoachPhilosophyEngine();

    test('Generates system prompt containing user metrics and §P3-A directives', () {
      final prompt = engine.generateSystemPrompt(
        userName: 'Arjun',
        userGoal: 'Muscle Gain',
        dietType: 'Vegetarian',
        readinessScore: 82,
        sleepDebtMin: -45,
        currentProteinG: 58,
        targetProteinG: 110,
        sorenessSummary: 'Mild Quads',
      );

      expect(prompt, contains('Arjun'));
      expect(prompt, contains('Readiness Score: 82/100'));
      expect(prompt, contains('58g achieved vs 110g target'));
      expect(prompt, contains('Vegetarian'));
      expect(prompt, contains('NEVER give generic, vague advice'));
    });

    test('Validates data-grounded specific responses as valid', () {
      const goodResponse =
          'Your protein intake has averaged 58g while your muscle-building goal requires 110g. Add paneer or moong dal to breakfast to improve recovery.';

      final result = engine.validateResponse(
        responseText: goodResponse,
        currentProteinG: 58,
        targetProteinG: 110,
        sleepDebtMin: -45,
        readinessScore: 82,
      );

      expect(result.isValid, isTrue);
      expect(result.violations, isEmpty);
      expect(result.sanitizedResponse, equals(goodResponse));
    });

    test('Flags generic advice anti-pattern and enriches response with user metrics', () {
      const genericResponse = 'You should eat more protein and drink more water.';

      final result = engine.validateResponse(
        responseText: genericResponse,
        currentProteinG: 58,
        targetProteinG: 110,
        sleepDebtMin: -45,
        readinessScore: 82,
      );

      expect(result.isValid, isFalse);
      expect(result.violations, isNotEmpty);
      expect(result.violations.any((v) => v.contains('Generic response detected')), isTrue);
      expect(result.sanitizedResponse, contains('58g against your 110g target'));
    });

    test('Flags medical diagnosis terms and enforces boundary rules', () {
      const medicalResponse = 'I will diagnose your joint pain and prescribe medication.';

      final result = engine.validateResponse(
        responseText: medicalResponse,
        currentProteinG: 80,
        targetProteinG: 100,
        sleepDebtMin: 0,
        readinessScore: 75,
      );

      expect(result.isValid, isFalse);
      expect(result.violations.any((v) => v.contains('Medical scope boundary violation')), isTrue);
    });
  });
}
