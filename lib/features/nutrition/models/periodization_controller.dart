enum PeriodizationPhase {
  fatLoss,
  dietBreak,
  maintenance,
  recomposition,
  leanGain
}

extension PeriodizationPhaseInfo on PeriodizationPhase {
  String get displayName {
    switch (this) {
      case PeriodizationPhase.fatLoss:
        return 'Fat Loss Phase';
      case PeriodizationPhase.dietBreak:
        return 'Diet Break Phase';
      case PeriodizationPhase.maintenance:
        return 'Maintenance Phase';
      case PeriodizationPhase.recomposition:
        return 'Body Recomposition Phase';
      case PeriodizationPhase.leanGain:
        return 'Lean Gain Phase';
    }
  }

  /// Calorie modifier multiplier relative to TDEE
  double get calorieModifier {
    switch (this) {
      case PeriodizationPhase.fatLoss:
        return 0.80; // -20% TDEE deficit
      case PeriodizationPhase.dietBreak:
      case PeriodizationPhase.maintenance:
      case PeriodizationPhase.recomposition:
        return 1.00; // Maintenance TDEE
      case PeriodizationPhase.leanGain:
        return 1.10; // +10% TDEE surplus
    }
  }

  /// Target protein g/kg body weight
  double get proteinTargetGPerKg {
    switch (this) {
      case PeriodizationPhase.recomposition:
        return 2.2;
      case PeriodizationPhase.fatLoss:
        return 2.0;
      case PeriodizationPhase.dietBreak:
      case PeriodizationPhase.maintenance:
      case PeriodizationPhase.leanGain:
        return 1.8;
    }
  }
}

class WeightLog {
  final DateTime loggedAt;
  final double weightKg;

  const WeightLog({required this.loggedAt, required this.weightKg});
}

class PeriodizationStatus {
  final PeriodizationPhase currentPhase;
  final PeriodizationPhase nextPhase;
  final bool actionRequired;
  final String reason;

  const PeriodizationStatus({
    required this.currentPhase,
    required this.nextPhase,
    required this.actionRequired,
    this.reason = 'Maintaining current periodization phase.',
  });
}

/// Pure-Dart Nutrition Periodization Controller Engine per §P5-G spec
class PeriodizationController {
  const PeriodizationController();

  /// Evaluates current phase, duration, and weight logs to detect plateau/fatigue and auto-trigger transitions
  PeriodizationStatus checkPhaseProgression({
    required PeriodizationPhase currentPhase,
    required DateTime phaseStartAt,
    required List<WeightLog> weightHistory,
  }) {
    final weeksInPhase = DateTime.now().difference(phaseStartAt).inDays / 7.0;

    // Rule 1: Auto-trigger Diet Break after 8 consecutive weeks in Fat Loss deficit
    if (currentPhase == PeriodizationPhase.fatLoss && weeksInPhase >= 8.0) {
      return PeriodizationStatus(
        currentPhase: currentPhase,
        nextPhase: PeriodizationPhase.dietBreak,
        actionRequired: true,
        reason:
            'Deficit active for 8+ weeks. Triggering a 10-day Diet Break to restore leptin and prevent metabolic adaptation.',
      );
    }

    // Rule 2: If weight plateau detected during Fat Loss (variance < 200g over 3 weeks)
    if (currentPhase == PeriodizationPhase.fatLoss &&
        isPlateaued(weightHistory, durationWeeks: 3)) {
      return PeriodizationStatus(
        currentPhase: currentPhase,
        nextPhase: PeriodizationPhase.dietBreak,
        actionRequired: true,
        reason:
            'Plateau detected (no weight change in 3 weeks). Exiting deficit to maintenance for 7 days to reset metabolism.',
      );
    }

    // Rule 3: Auto-transition from Diet Break back to Fat Loss or Maintenance after 2 weeks
    if (currentPhase == PeriodizationPhase.dietBreak && weeksInPhase >= 2.0) {
      return PeriodizationStatus(
        currentPhase: currentPhase,
        nextPhase: PeriodizationPhase.fatLoss,
        actionRequired: true,
        reason:
            'Diet Break completed (2 weeks). Resuming Fat Loss phase with refreshed metabolic rate.',
      );
    }

    return PeriodizationStatus(
      currentPhase: currentPhase,
      nextPhase: currentPhase,
      actionRequired: false,
    );
  }

  /// Detects weight plateau (variance < 0.2 kg across recent logs)
  bool isPlateaued(List<WeightLog> logs, {required int durationWeeks}) {
    if (logs.length < 5) return false;

    // Sort descending by date
    final sorted = List<WeightLog>.from(logs)
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    final cutoff = DateTime.now().subtract(Duration(days: durationWeeks * 7));
    final recentLogs = sorted
        .where((l) => l.loggedAt.isAfter(cutoff))
        .map((l) => l.weightKg)
        .toList();

    if (recentLogs.length < 3) return false;

    final maxWeight = recentLogs.reduce((a, b) => a > b ? a : b);
    final minWeight = recentLogs.reduce((a, b) => a < b ? a : b);

    return (maxWeight - minWeight).abs() < 0.2; // Weight variance < 200g
  }
}
