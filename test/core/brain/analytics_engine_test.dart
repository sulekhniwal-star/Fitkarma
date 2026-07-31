import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/analytics_engine.dart';
import 'package:fitkarma/features/onboarding/models/user_profile.dart';

void main() {
  group('AnalyticsEngine Boer Lean Mass Estimation Tests', () {
    const engine = AnalyticsEngine();

    test('Boer formula calculates Lean Mass correctly for Male', () {
      final res = engine.calculateLeanMass(
        weightKg: 75.0,
        heightCm: 175.0,
        gender: Gender.male,
      );

      // LBM = (0.407 * 75) + (0.267 * 175) - 19.2 = 30.525 + 46.725 - 19.2 = 58.05 kg
      expect(res.leanMassKg, closeTo(58.05, 0.1));
      expect(res.fatMassKg, closeTo(16.95, 0.1));
    });

    test('Boer formula calculates Lean Mass correctly for Female', () {
      final res = engine.calculateLeanMass(
        weightKg: 60.0,
        heightCm: 160.0,
        gender: Gender.female,
      );

      // LBM = (0.252 * 60) + (0.473 * 160) - 48.3 = 15.12 + 75.68 - 48.3 = 42.5 kg
      expect(res.leanMassKg, closeTo(42.5, 0.1));
      expect(res.fatMassKg, closeTo(17.5, 0.1));
    });
  });
}
