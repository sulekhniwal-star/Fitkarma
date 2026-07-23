/// §P5-L Adaptive Hunger & Cravings Engine
///
/// Pure-Dart subjective hunger score evaluator (1 = Stuffed to 5 = Starving),
/// craving type classifier, high-stress late-night craving pattern detector,
/// and 7 PM proactive pre-emptive snacking intervention engine.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Domain Enums & Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Subjective craving categories (§P5-L Specification).
enum CravingType {
  sweet,
  salty,
  fatty,
  spicy,
  lateNightBinge,
}

/// Subjective hunger & craving log entry.
class HungerCravingLog {
  const HungerCravingLog({
    required this.id,
    required this.loggedAt,
    required this.hungerScore,
    this.cravingType,
    this.stressLevel = 1.0,
    this.notes,
  });

  final String id;
  final DateTime loggedAt;

  /// 1 = Stuffed, 2 = Satisfied, 3 = Neutral, 4 = Hungry, 5 = Starving
  final int hungerScore;

  final CravingType? cravingType;

  /// 1.0 (Calm) to 5.0 (High Stress)
  final double stressLevel;

  final String? notes;
}

/// Proactive intervention nudge payload output from [AdaptiveHungerEngine].
class HungerIntervention {
  const HungerIntervention({
    required this.shouldTriggerNudge,
    this.nudgeTitle = '',
    this.nudgeBody = '',
    this.recommendedSnacks = const [],
    this.predictedCraving,
  });

  final bool shouldTriggerNudge;
  final String nudgeTitle;
  final String nudgeBody;
  final List<String> recommendedSnacks;
  final CravingType? predictedCraving;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class AdaptiveHungerEngine {
  const AdaptiveHungerEngine();

  /// Default high-yield Indian protein snacks for blunting insulin spikes & cravings.
  static const List<String> defaultIndianProteinSnacks = [
    '1 Cup Curd + 4 Walnuts (+12g pro)',
    '1 Glass Chilled Sattu Drink (+18g pro)',
    '1 Bowl Roasted Chana (+10g pro)',
    '100g Grilled Paneer Cubes (+18g pro)',
    '1 Scoop Whey Protein Shake (+24g pro)',
  ];

  /// Evaluates craving risk and returns proactive intervention nudges.
  HungerIntervention evaluateCravingRisk({
    required List<HungerCravingLog> cravingLogs,
    required double currentStressLevel,
    required DateTime currentTime,
  }) {
    // Check if user has high stress (>= 3.5) or hunger score >= 4
    final isHighStress = currentStressLevel >= 3.5;

    // Check historical logs for late-night (>= 21:00) sweet or binge cravings on high-stress days
    bool hasBingePattern = false;
    CravingType? predominantCraving;

    final lateNightLogs = cravingLogs.where((l) =>
        l.loggedAt.hour >= 21 ||
        l.cravingType == CravingType.lateNightBinge ||
        l.cravingType == CravingType.sweet);

    if (lateNightLogs.isNotEmpty) {
      hasBingePattern = lateNightLogs.any((l) => l.stressLevel >= 3.0 || l.hungerScore >= 4);
      predominantCraving = lateNightLogs.last.cravingType ?? CravingType.sweet;
    }

    final isPreEmptiveWindow = currentTime.hour >= 18 && currentTime.hour <= 20;

    if ((hasBingePattern && isHighStress && isPreEmptiveWindow) ||
        (isHighStress && currentTime.hour >= 19 && currentTime.hour <= 21)) {
      return HungerIntervention(
        shouldTriggerNudge: true,
        nudgeTitle: 'Pre-Emptive Snacking Alert 🍫',
        nudgeBody: 'Stress is elevated. We notice you tend to crave sweet snacks at 9 PM on stressful days. Add a 20g protein snack now to stabilize insulin and prevent late-night binging.',
        recommendedSnacks: defaultIndianProteinSnacks,
        predictedCraving: predominantCraving ?? CravingType.sweet,
      );
    }

    // High hunger score intervention (score == 5)
    final latestLog = cravingLogs.isNotEmpty ? cravingLogs.last : null;
    if (latestLog != null && latestLog.hungerScore == 5) {
      return HungerIntervention(
        shouldTriggerNudge: true,
        nudgeTitle: 'High Hunger Warning ⚠️',
        nudgeBody: 'You logged Starving (5/5). Eat a balanced high-protein snack now to prevent rapid overeating at dinner.',
        recommendedSnacks: defaultIndianProteinSnacks,
        predictedCraving: latestLog.cravingType,
      );
    }

    return const HungerIntervention(shouldTriggerNudge: false);
  }
}
