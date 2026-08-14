// §P12-D AI Roast Mode & Tone Selector Engine (Pure Dart, No AI)
// Cross-reference: §P12-D, ADR-024

/// 4-tier Coach Tone Selector per §P12-D & ADR-024
enum CoachTone {
  gentle,
  motivational,
  roast,
  noNonsense;

  String get displayName {
    switch (this) {
      case CoachTone.gentle:
        return 'Gentle';
      case CoachTone.motivational:
        return 'Motivational';
      case CoachTone.roast:
        return 'Roast';
      case CoachTone.noNonsense:
        return 'No Nonsense';
    }
  }

  String get keyName {
    switch (this) {
      case CoachTone.gentle:
        return 'gentle';
      case CoachTone.motivational:
        return 'motivational';
      case CoachTone.roast:
        return 'roast';
      case CoachTone.noNonsense:
        return 'no_nonsense';
    }
  }

  static CoachTone fromString(String val) {
    final cleaned = val.toLowerCase().replaceAll('-', '_').trim();
    switch (cleaned) {
      case 'gentle':
        return CoachTone.gentle;
      case 'motivational':
        return CoachTone.motivational;
      case 'roast':
        return CoachTone.roast;
      case 'no_nonsense':
      case 'nononsense':
      case 'no nonsense':
        return CoachTone.noNonsense;
      default:
        return CoachTone.motivational;
    }
  }
}

/// Tone Resolution & Prompt Instruction Package
class ToneInstruction {
  final CoachTone effectiveTone;
  final bool isDistressOverridden;
  final String systemPromptDirective;
  final String description;

  const ToneInstruction({
    required this.effectiveTone,
    required this.isDistressOverridden,
    required this.systemPromptDirective,
    required this.description,
  });
}

/// AI Roast Mode & Coach Tone Engine (Pure Dart)
class AiRoastModeEngine {
  const AiRoastModeEngine();

  /// Distress and crisis triggers that trigger automatic safety downgrade (§P12-D)
  static const List<String> distressKeywords = [
    'depressed',
    'depression',
    'suicide',
    'self harm',
    'kill myself',
    'hopeless',
    'crying',
    'severe pain',
    'panic attack',
    'mental breakdown',
    'grief',
    'passed away',
    'burnout',
    'overwhelmed',
    'giving up',
    'hate myself',
    'anxiety attack',
  ];

  /// Detects whether user text or current health state exhibits acute distress or crisis
  bool detectDistress({
    String? userMessage,
    bool isIllnessActive = false,
    bool isSleepCrisis = false,
    bool isExtremeStress = false,
  }) {
    if (isIllnessActive || isSleepCrisis || isExtremeStress) {
      return true;
    }

    if (userMessage == null || userMessage.trim().isEmpty) {
      return false;
    }

    final lower = userMessage.toLowerCase();
    for (final kw in distressKeywords) {
      if (lower.contains(kw)) {
        return true;
      }
    }
    return false;
  }

  /// Resolves the effective tone, auto-disabling roast mode to gentle if distress detected (§P12-D)
  CoachTone resolveEffectiveTone({
    required CoachTone selectedTone,
    required bool isDistressDetected,
  }) {
    if (isDistressDetected && selectedTone == CoachTone.roast) {
      // Crisis mode auto-disables roast if distress detected
      return CoachTone.gentle;
    }
    return selectedTone;
  }

  /// Gets the system prompt directive and metadata for the given tone configuration
  ToneInstruction getInstruction({
    required CoachTone selectedTone,
    bool isDistressDetected = false,
  }) {
    final effectiveTone = resolveEffectiveTone(
      selectedTone: selectedTone,
      isDistressDetected: isDistressDetected,
    );

    final isOverridden = isDistressDetected && selectedTone == CoachTone.roast;

    final String directive;
    final String desc;

    switch (effectiveTone) {
      case CoachTone.gentle:
        directive =
            'Tone: Gentle, compassionate, highly empathetic, and non-pressuring. Provide supportive validation with low cognitive friction.';
        desc = 'Compassionate & supportive guidance without pressure.';
        break;
      case CoachTone.motivational:
        directive =
            'Tone: High-energy, encouraging, action-oriented, and uplifting. Celebrate progress and frame challenges as growth opportunities.';
        desc = 'Encouraging, energetic, and goal-focused coaching.';
        break;
      case CoachTone.roast:
        directive =
            'Tone: AI Roast Mode — Witty, sarcastic, dry-humored, and playfully blunt Indian-context humor, while keeping actionable fitness data intact. Never cross into abusive or clinical distress territory.';
        desc = 'Witty, sarcastic, and playfully blunt tough love.';
        break;
      case CoachTone.noNonsense:
        directive =
            'Tone: No Nonsense — Direct, concise, analytical, and strictly data-driven. Zero fluff, zero euphemisms, bulleted action steps only.';
        desc = 'Direct, analytical, and straight to the numbers.';
        break;
    }

    return ToneInstruction(
      effectiveTone: effectiveTone,
      isDistressOverridden: isOverridden,
      systemPromptDirective: directive,
      description: desc,
    );
  }

  /// Deterministic offline contextual roast generator (§P12-D examples + patterns)
  String generateOfflineRoast({
    required int caloriesBurned,
    required int caloriesConsumed,
    required String? highCalorieFood,
    required int missedLoggingDays,
    required int readinessScore,
  }) {
    if (caloriesConsumed > (caloriesBurned + 400) && highCalorieFood != null) {
      return 'You burned $caloriesBurned calories and then attacked $caloriesConsumed calories of $highCalorieFood. Respect the hustle. Your goals don\'t.';
    }

    if (missedLoggingDays >= 3) {
      return 'Day $missedLoggingDays of not logging meals. Either you\'re on a silent diet or FitKarma needs a missing persons report.';
    }

    if (readinessScore > 85 && caloriesBurned == 0) {
      return 'Readiness is sitting at $readinessScore/100, but your active calories are currently zero. Your couch thanks you, but your quads are filing a formal complaint.';
    }

    return 'Tracking progress requires actual tracking. Let\'s get back on the board before your metabolism forgets who you are.';
  }
}
