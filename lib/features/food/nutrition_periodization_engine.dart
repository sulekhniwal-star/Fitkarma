/// §P5-G Nutrition Periodization Engine
///
/// Pure-Dart phase-based macro cycling engine, plateau detection rules,
/// diet break auto-triggers, and periodized macro calculation models.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Enums & Data Models
// ─────────────────────────────────────────────────────────────────────────────

/// Periodization phase cycle types (§P5-G Specification).
enum PeriodizationPhase {
  /// Fat Loss: -20% Energy Deficit, 2.0g/kg Protein. Max 8-12 weeks.
  fatLoss,

  /// Diet Break: 100% Maintenance TDEE for 1-2 weeks. Resets leptin & T3.
  dietBreak,

  /// Maintenance: 100% TDEE net zero energy balance, 1.8g/kg Protein.
  maintenance,

  /// Recomposition: 100% TDEE, 2.2g/kg High Protein for hypertrophy + fat loss.
  recomposition,

  /// Lean Gain: +10% Mild Energy Surplus, 2.0g/kg Protein for muscle gain.
  leanGain,
}

/// Calculated phase-specific macro targets.
class PeriodizedMacroTargets {
  const PeriodizedMacroTargets({
    required this.phase,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.description,
  });

  final PeriodizationPhase phase;
  final int targetCalories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String description;
}

/// Phase progression status output from [NutritionPeriodizationEngine].
class PeriodizationStatus {
  const PeriodizationStatus({
    required this.currentPhase,
    required this.nextPhase,
    required this.actionRequired,
    required this.weeksInCurrentPhase,
    this.reason,
  });

  final PeriodizationPhase currentPhase;
  final PeriodizationPhase nextPhase;
  final bool actionRequired;
  final double weeksInCurrentPhase;
  final String? reason;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class NutritionPeriodizationEngine {
  const NutritionPeriodizationEngine();

  /// Calculates phase-specific macro targets based on phase config, TDEE, and weight.
  PeriodizedMacroTargets calculateMacroTargets({
    required PeriodizationPhase phase,
    required double tdee,
    required double weightKg,
  }) {
    double calorieMultiplier = 1.0;
    double proteinPerKg = 1.8;
    String description = '';

    switch (phase) {
      case PeriodizationPhase.fatLoss:
        calorieMultiplier = 0.80; // 20% deficit
        proteinPerKg = 2.0;
        description = 'Fat Loss Phase (-20% Deficit, High Protein)';
        break;

      case PeriodizationPhase.dietBreak:
        calorieMultiplier = 1.00; // Maintenance
        proteinPerKg = 1.8;
        description = 'Diet Break Phase (Full TDEE Maintenance to reset leptin & T3)';
        break;

      case PeriodizationPhase.maintenance:
        calorieMultiplier = 1.00; // Maintenance
        proteinPerKg = 1.8;
        description = 'Maintenance Phase (Stable weight checkpoint)';
        break;

      case PeriodizationPhase.recomposition:
        calorieMultiplier = 1.00; // Maintenance TDEE
        proteinPerKg = 2.2; // High protein requirement for muscle synthesis
        description = 'Body Recomposition Phase (High Protein 2.2g/kg @ Maintenance)';
        break;

      case PeriodizationPhase.leanGain:
        calorieMultiplier = 1.10; // 10% surplus
        proteinPerKg = 2.0;
        description = 'Lean Gain Phase (+10% Mild Surplus for Hypertrophy)';
        break;
    }

    final targetCalories = (tdee * calorieMultiplier).round();
    final proteinGrams = (weightKg * proteinPerKg).round();
    final proteinCal = proteinGrams * 4;

    // Allocate remaining calories: 25% Fat, remainder Carbs
    final fatCal = targetCalories * 0.25;
    final fatGrams = (fatCal / 9.0).round();

    final remainingCal = targetCalories - proteinCal - fatCal;
    final carbsGrams = (remainingCal / 4.0).clamp(50.0, 800.0).round();

    return PeriodizedMacroTargets(
      phase: phase,
      targetCalories: targetCalories,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatGrams: fatGrams,
      description: description,
    );
  }

  /// Evaluates phase progression rules against phase duration and weight log history.
  PeriodizationStatus checkPhaseProgression({
    required PeriodizationPhase currentPhase,
    required DateTime? phaseStartedAt,
    required List<double> recentWeightLogsKg,
  }) {
    final now = DateTime.now();
    final startDate = phaseStartedAt ?? now;
    final weeksInPhase = now.difference(startDate).inDays / 7.0;

    // Rule 1: Auto-trigger Diet Break after 8 consecutive weeks in Fat Loss deficit
    if (currentPhase == PeriodizationPhase.fatLoss && weeksInPhase >= 8.0) {
      return PeriodizationStatus(
        currentPhase: currentPhase,
        nextPhase: PeriodizationPhase.dietBreak,
        actionRequired: true,
        weeksInCurrentPhase: weeksInPhase,
        reason: 'Deficit active for 8+ weeks. Triggering a 10-day Diet Break to restore leptin & T3 hormones.',
      );
    }

    // Rule 2: If weight plateau detected during Fat Loss (variance < 0.2kg over 3 weeks)
    if (currentPhase == PeriodizationPhase.fatLoss &&
        weeksInPhase >= 3.0 &&
        isPlateaued(recentWeightLogsKg, durationWeeks: 3)) {
      return PeriodizationStatus(
        currentPhase: currentPhase,
        nextPhase: PeriodizationPhase.dietBreak,
        actionRequired: true,
        weeksInCurrentPhase: weeksInPhase,
        reason: 'Plateau detected (<0.2kg variance over 3 weeks). Exiting deficit to maintenance for 7-10 days to reset metabolism.',
      );
    }

    // Rule 3: Auto-expire Diet Break back to Fat Loss / Maintenance after 2 weeks
    if (currentPhase == PeriodizationPhase.dietBreak && weeksInPhase >= 2.0) {
      return PeriodizationStatus(
        currentPhase: currentPhase,
        nextPhase: PeriodizationPhase.fatLoss,
        actionRequired: true,
        weeksInCurrentPhase: weeksInPhase,
        reason: '2-week Diet Break completed! Metabolism restored. Returning to Fat Loss deficit.',
      );
    }

    return PeriodizationStatus(
      currentPhase: currentPhase,
      nextPhase: currentPhase,
      actionRequired: false,
      weeksInCurrentPhase: weeksInPhase,
    );
  }

  /// Checks if weight logs over a duration window show a plateau (< 0.2kg variance).
  bool isPlateaued(List<double> weightLogs, {int durationWeeks = 3}) {
    final minRequiredLogs = durationWeeks * 3; // ~3 logs per week
    if (weightLogs.length < minRequiredLogs) return false;

    final recent = weightLogs.take(minRequiredLogs).toList();
    final maxW = recent.reduce((a, b) => a > b ? a : b);
    final minW = recent.reduce((a, b) => a < b ? a : b);

    return (maxW - minW).abs() < 0.2;
  }
}
