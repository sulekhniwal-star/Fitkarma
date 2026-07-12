class UserProgress {
  UserProgress({
    required this.weightLostKg,
    required this.consistencyScore,
    required this.bodyFatPct,
    required this.leanMassGainedKg,
    required this.weeksCompleted,
    required this.targetDatePassed,
  });

  final double weightLostKg;
  final double consistencyScore;
  final double bodyFatPct;
  final double leanMassGainedKg;
  final int weeksCompleted;
  final bool targetDatePassed;
}

class ProgramEvolutionEngine {
  /// Defines program-phase transition rules and determines if a user should evolve.
  String? checkEvolution({
    required String currentProgram,
    required UserProgress progress,
  }) {
    // 1. Corporate Fat Loss ──► Corporate Recomposition
    if (currentProgram == 'Corporate Fat Loss' &&
        progress.weightLostKg >= 5.0 &&
        progress.consistencyScore >= 80.0) {
      return 'Corporate Recomposition';
    }

    // 2. Corporate Recomposition ──► Athletic Lean Build
    if (currentProgram == 'Corporate Recomposition' &&
        progress.bodyFatPct <= 20.0 &&
        progress.leanMassGainedKg >= 1.0) {
      return 'Athletic Lean Build';
    }

    // 3. Student Hostel Fitness ──► Intermediate Strength
    if (currentProgram == 'Student Hostel Fitness' &&
        progress.consistencyScore >= 85.0 &&
        progress.weeksCompleted >= 4) {
      return 'Intermediate Strength';
    }

    // 4. Intermediate Strength ──► Athletic Performance
    if (currentProgram == 'Intermediate Strength' &&
        progress.leanMassGainedKg >= 2.0 &&
        progress.weeksCompleted >= 8) {
      return 'Athletic Performance';
    }

    // 5. PCOS Fat Loss ──► PCOS Maintenance
    if (currentProgram == 'PCOS Fat Loss' &&
        progress.weightLostKg >= 4.0 &&
        progress.consistencyScore >= 75.0) {
      return 'PCOS Maintenance';
    }

    // 6. PCOS Maintenance ──► PCOS Recomposition
    if (currentProgram == 'PCOS Maintenance' &&
        progress.bodyFatPct <= 22.0 &&
        progress.consistencyScore >= 80.0) {
      return 'PCOS Recomposition';
    }

    // 7. Wedding Transformation ──► Post-Wedding Maintenance
    if (currentProgram == 'Wedding Transformation' &&
        (progress.weeksCompleted >= 12 || progress.targetDatePassed)) {
      return 'Post-Wedding Maintenance';
    }

    // 8. Post-Wedding Maintenance ──► Lifestyle Fitness
    if (currentProgram == 'Post-Wedding Maintenance' &&
        progress.consistencyScore >= 80.0 &&
        progress.weeksCompleted >= 6) {
      return 'Lifestyle Fitness';
    }

    return null;
  }
}
