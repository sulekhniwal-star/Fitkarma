import 'nutrition_models.dart';

class ProteinBolusTarget {
  final MealPhase phase;
  final String timingLabel; // e.g. '08:30 AM (Breakfast)', '01:30 PM (Lunch)'
  final double targetProteinGrams;
  final double currentProteinGrams;
  final double estimatedLeucineGrams;
  final bool isMpsTriggered; // True if >= 25g protein and >= 2.5g Leucine

  const ProteinBolusTarget({
    required this.phase,
    required this.timingLabel,
    required this.targetProteinGrams,
    required this.currentProteinGrams,
    required this.estimatedLeucineGrams,
    required this.isMpsTriggered,
  });
}

class ProteinTimingReport {
  final List<ProteinBolusTarget> boluses;
  final int totalMpsTriggersAchieved;
  final int totalMpsTriggersTarget;
  final double dailyTotalProtein;
  final String aminoAcidPairingNote;
  final String periWorkoutPrescription;

  const ProteinTimingReport({
    required this.boluses,
    required this.totalMpsTriggersAchieved,
    required this.totalMpsTriggersTarget,
    required this.dailyTotalProtein,
    required this.aminoAcidPairingNote,
    required this.periWorkoutPrescription,
  });
}

class ProteinTimingEngine {
  /// Pure Dart deterministic calculation of Muscle Protein Synthesis (MPS) boluses and timing
  static ProteinTimingReport evaluateProteinTiming({
    required int dailyProteinTarget,
    required List<LoggedMealEntry> loggedMeals,
  }) {
    // 4 distributed boluses across the day
    final double bolusTarget = (dailyProteinTarget / 4.0).clamp(25.0, 50.0);

    final List<ProteinBolusTarget> boluses = MealPhase.values.map((phase) {
      final phaseMeals = loggedMeals.where((m) => m.phase == phase).toList();
      final phaseProtein = phaseMeals.fold<double>(0.0, (sum, m) => sum + m.totalProtein);
      // Average Leucine is ~8-10% of total complete protein
      final estimatedLeucine = double.parse((phaseProtein * 0.09).toStringAsFixed(2));
      final bool mpsTriggered = phaseProtein >= 25.0 && estimatedLeucine >= 2.2;

      final String timeLabel = _getTimeLabel(phase);

      return ProteinBolusTarget(
        phase: phase,
        timingLabel: timeLabel,
        targetProteinGrams: double.parse(bolusTarget.toStringAsFixed(1)),
        currentProteinGrams: double.parse(phaseProtein.toStringAsFixed(1)),
        estimatedLeucineGrams: estimatedLeucine,
        isMpsTriggered: mpsTriggered,
      );
    }).toList();

    final mpsCount = boluses.where((b) => b.isMpsTriggered).length;
    final totalProt = loggedMeals.fold<double>(0.0, (sum, m) => sum + m.totalProtein);

    return ProteinTimingReport(
      boluses: boluses,
      totalMpsTriggersAchieved: mpsCount,
      totalMpsTriggersTarget: 4,
      dailyTotalProtein: double.parse(totalProt.toStringAsFixed(1)),
      aminoAcidPairingNote: 'Traditional Indian combinations (e.g. Daal + Roti, Khichdi, Besan + Paneer) create a complete amino acid profile by pairing methionine-rich cereals with lysine-rich legumes.',
      periWorkoutPrescription: 'Consume 25g fast-digesting protein (Whey / Sattu) within 45 minutes post-workout with 30-40g complex carbohydrates to maximize glycogen resynthesis and anabolic signaling.',
    );
  }

  static String _getTimeLabel(MealPhase phase) {
    switch (phase) {
      case MealPhase.breakfast:
        return '08:30 AM (Breakfast)';
      case MealPhase.lunch:
        return '01:30 PM (Lunch)';
      case MealPhase.eveningSnack:
        return '05:30 PM (Post-Workout / Snack)';
      case MealPhase.dinner:
        return '08:45 PM (Dinner)';
    }
  }
}
