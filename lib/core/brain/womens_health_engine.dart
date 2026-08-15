/// Menstrual Cycle Phase Enum
enum MenstrualPhase { follicular, ovulatory, luteal, menstrual }

/// Women's Health Prescription Result
class WomensHealthPrescription {
  final MenstrualPhase phase;
  final double strengthTargetMultiplier;
  final String nutritionAdvice;

  const WomensHealthPrescription({
    required this.phase,
    required this.strengthTargetMultiplier,
    required this.nutritionAdvice,
  });
}

/// Women's Advanced Health Layer Engine
class WomensHealthEngine {
  const WomensHealthEngine();

  /// Calculate hormone-aware workout and nutrition prescription
  WomensHealthPrescription calculatePrescription(
      {required MenstrualPhase phase}) {
    switch (phase) {
      case MenstrualPhase.follicular:
      case MenstrualPhase.ovulatory:
        return const WomensHealthPrescription(
          phase: MenstrualPhase.follicular,
          strengthTargetMultiplier: 1.05, // Boost strength target +5%
          nutritionAdvice:
              'High energy phase. Optimize protein intake and complex carbohydrates.',
        );
      case MenstrualPhase.luteal:
        return const WomensHealthPrescription(
          phase: MenstrualPhase.luteal,
          strengthTargetMultiplier: 0.95, // Reduce target -5%
          nutritionAdvice:
              'Fluid retention & higher metabolic rate. Increase magnesium & hydrating fluids.',
        );
      case MenstrualPhase.menstrual:
        return const WomensHealthPrescription(
          phase: MenstrualPhase.menstrual,
          strengthTargetMultiplier: 0.90, // Reduce target -10%
          nutritionAdvice:
              'Active recovery focus. Prioritize iron-rich foods and gentle mobility.',
        );
    }
  }
}
