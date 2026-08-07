enum CravingType { sweet, salty, fatty, none }

class CravingLog {
  final DateTime timestamp;
  final int hungerScore; // 1 = Stuffed, 5 = Starving
  final CravingType cravingType;
  final bool isUltraProcessed;
  final double stressLevel; // 1.0 to 5.0

  const CravingLog({
    required this.timestamp,
    required this.hungerScore,
    required this.cravingType,
    required this.isUltraProcessed,
    required this.stressLevel,
  });
}

class HungerIntervention {
  final bool shouldTriggerNudge;
  final String nudgeTitle;
  final String nudgeBody;
  final String recommendedSnack;

  const HungerIntervention({
    required this.shouldTriggerNudge,
    this.nudgeTitle = '',
    this.nudgeBody = '',
    this.recommendedSnack = '',
  });
}

/// Pure-Dart Adaptive Hunger & Cravings Engine per §P5-L spec
class HungerCravingEngine {
  const HungerCravingEngine();

  /// Evaluates craving risk by correlating stress levels, time of day, and past late-night binge logs
  HungerIntervention evaluateCravingRisk({
    required List<CravingLog> logs,
    required DateTime currentTime,
    required double currentStressLevel,
  }) {
    if (logs.isEmpty) {
      return const HungerIntervention(shouldTriggerNudge: false);
    }

    // 1. Check for historical late-night sweet/junk food binging on high-stress days (hour >= 21)
    final hasBingePattern = logs.any((log) =>
        log.timestamp.hour >= 21 &&
        (log.isUltraProcessed || log.cravingType == CravingType.sweet) &&
        log.stressLevel >= 3.5);

    // 2. Proactive intervention trigger around 7:00 PM (hour 19) when stress is elevated (>=3.5)
    if (hasBingePattern && currentTime.hour >= 18 && currentTime.hour <= 20 && currentStressLevel >= 3.5) {
      return const HungerIntervention(
        shouldTriggerNudge: true,
        nudgeTitle: 'Pre-Emptive Snacking Alert',
        nudgeBody: 'We notice you tend to crave sweet snacks at 9 PM on stressful days. Add a 25g protein snack (Greek yogurt or sattu drink) now to stabilize insulin and prevent late-night binging.',
        recommendedSnack: '1 cup Greek yogurt with walnuts, or a high-protein sattu drink.',
      );
    }

    // 3. Starving condition prompt (hunger score 5)
    final recentStarving = logs.any((l) => l.hungerScore >= 4 && currentTime.difference(l.timestamp).inHours <= 2);
    if (recentStarving) {
      return const HungerIntervention(
        shouldTriggerNudge: true,
        nudgeTitle: 'High Hunger Warning',
        nudgeBody: 'Your logged hunger score is high. Eat a high-satiety fiber & protein meal to avoid impulsive high-calorie snacking.',
        recommendedSnack: 'Roasted chana or boiled eggs with cucumber slices.',
      );
    }

    return const HungerIntervention(shouldTriggerNudge: false);
  }
}
