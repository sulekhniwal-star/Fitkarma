import 'ai_roast_mode_engine.dart';

// §P3-A & §P12-D AI Coach Philosophy & Response Guardrails System (Pure Dart)

/// System Prompt & Response Validation Result
class GuardrailValidationResult {
  final bool isValid;
  final List<String> violations;
  final String sanitizedResponse;

  const GuardrailValidationResult({
    required this.isValid,
    required this.violations,
    required this.sanitizedResponse,
  });
}

/// Core AI Coach Philosophy & Guardrails Engine
class AiCoachPhilosophyEngine {
  const AiCoachPhilosophyEngine();

  /// Generic advice phrases that violate §P3-A philosophy
  static const List<String> genericAntiPatterns = [
    'eat more protein',
    'exercise more',
    'drink more water',
    'sleep 8 hours',
    'work out harder',
    'eat healthy',
    'just rest',
  ];

  /// Medical diagnosis disclaimers required for health boundary enforcement
  static const List<String> prohibitedMedicalPhrases = [
    'diagnose',
    'prescribe medication',
    'medical treatment',
    'cure your condition',
  ];

  /// Generates system prompt with §P3-A & §P12-D Guardrail directives
  String generateSystemPrompt({
    required String userName,
    required String userGoal,
    required String dietType, // e.g. "Vegetarian"
    required int readinessScore,
    required int sleepDebtMin,
    required int currentProteinG,
    required int targetProteinG,
    required String sorenessSummary,
    CoachTone tone = CoachTone.motivational,
    bool isDistressDetected = false,
  }) {
    const toneEngine = AiRoastModeEngine();
    final toneInstruction = toneEngine.getInstruction(
      selectedTone: tone,
      isDistressDetected: isDistressDetected,
    );

    return '''
You are FitKarma's Intelligent Health & Fitness Coach for $userName.

CRITICAL §P3-A AI COACH PHILOSOPHY GUARDRAILS:
1. NEVER give generic, vague advice (e.g. NEVER say "Eat more protein" or "Drink more water").
2. EVERY recommendation MUST explicitly reference specific numbers from $userName's Health Snapshot:
   - Readiness Score: $readinessScore/100
   - Sleep Debt: $sleepDebtMin mins
   - Daily Protein: ${currentProteinG}g achieved vs ${targetProteinG}g target
   - Muscle Soreness: $sorenessSummary
   - Dietary Preference: $dietType
3. Always suggest authentic Indian food items (e.g. paneer bhurji, moong dal, chana, sprouts, curd) matching their $dietType diet.
4. ${toneInstruction.systemPromptDirective}
5. Never diagnose medical conditions or give clinical prescriptions.
''';
  }

  /// Validates AI response against §P3-A guardrails and replaces generic responses with data-grounded guidance
  GuardrailValidationResult validateResponse({
    required String responseText,
    required int currentProteinG,
    required int targetProteinG,
    required int sleepDebtMin,
    required int readinessScore,
  }) {
    final violations = <String>[];
    final lower = responseText.toLowerCase();

    // 1. Check for generic anti-patterns
    for (final pattern in genericAntiPatterns) {
      if (lower.contains(pattern)) {
        violations.add('Generic response detected: "$pattern"');
      }
    }

    // 2. Check for prohibited medical claims
    for (final phrase in prohibitedMedicalPhrases) {
      if (lower.contains(phrase)) {
        violations.add('Medical scope boundary violation: "$phrase"');
      }
    }

    // 3. Check if response references user data metrics
    final hasMetricsReference = lower.contains('g') ||
        lower.contains('min') ||
        lower.contains('readiness') ||
        lower.contains('%') ||
        lower.contains('kcal') ||
        lower.contains('score');

    if (!hasMetricsReference) {
      violations.add('Response lacks quantitative health metric references');
    }

    final isValid = violations.isEmpty;
    String sanitized = responseText;

    // If generic anti-pattern is found, enforce §P3-A transformation:
    // Bad: "Eat more protein." -> Good: "Your protein intake has averaged 58g for 6 days while your goal requires ~110g. Add paneer or eggs to breakfast to improve recovery."
    if (!isValid) {
      sanitized = _enrichGenericResponse(
        originalText: responseText,
        currentProteinG: currentProteinG,
        targetProteinG: targetProteinG,
        sleepDebtMin: sleepDebtMin,
        readinessScore: readinessScore,
      );
    }

    return GuardrailValidationResult(
      isValid: isValid,
      violations: violations,
      sanitizedResponse: sanitized,
    );
  }

  String _enrichGenericResponse({
    required String originalText,
    required int currentProteinG,
    required int targetProteinG,
    required int sleepDebtMin,
    required int readinessScore,
  }) {
    final deltaProtein = (targetProteinG - currentProteinG).clamp(0, 200);

    if (originalText.toLowerCase().contains('protein')) {
      return 'Your protein intake is currently ${currentProteinG}g against your ${targetProteinG}g target (deficit: ${deltaProtein}g). Add paneer, moong dal, or eggs to your next meal to optimize recovery capacity.';
    }

    if (originalText.toLowerCase().contains('sleep') || originalText.toLowerCase().contains('rest')) {
      return 'Your sleep debt is currently at ${sleepDebtMin.abs()} mins with a readiness score of $readinessScore/100. Aim to sleep 30 mins earlier tonight to clear recovery debt.';
    }

    return '$originalText (Readiness: $readinessScore/100, Protein: ${currentProteinG}g/${targetProteinG}g, Sleep Debt: ${sleepDebtMin}m).';
  }
}
