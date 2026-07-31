import '../../features/onboarding/models/user_profile.dart';

/// Lean Mass Estimation Result
class LeanMassResult {
  final double leanMassKg;
  final double fatMassKg;
  final double bodyFatPercentage;

  const LeanMassResult({
    required this.leanMassKg,
    required this.fatMassKg,
    required this.bodyFatPercentage,
  });
}

/// Core Visual Analytics Engine
class AnalyticsEngine {
  const AnalyticsEngine();

  /// Calculate Lean Body Mass using Boer Formula
  LeanMassResult calculateLeanMass({
    required double weightKg,
    required double heightCm,
    required Gender gender,
  }) {
    double lbm;
    if (gender == Gender.male) {
      lbm = (0.407 * weightKg) + (0.267 * heightCm) - 19.2;
    } else {
      lbm = (0.252 * weightKg) + (0.473 * heightCm) - 48.3;
    }

    final lbmClamped = lbm.clamp(30.0, weightKg);
    final fatMass = (weightKg - lbmClamped).clamp(0.0, weightKg);
    final fatPercent = (fatMass / weightKg) * 100.0;

    return LeanMassResult(
      leanMassKg: lbmClamped,
      fatMassKg: fatMass,
      bodyFatPercentage: fatPercent,
    );
  }
}
