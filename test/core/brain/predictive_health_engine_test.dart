import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/predictive_health_engine.dart';

void main() {
  group('PredictiveHealthEngine Biological Age & CGM Spike Tests', () {
    const engine = PredictiveHealthEngine();

    test('Biological age calculation computes younger age for optimal biometrics', () {
      final res = engine.calculateBiologicalAge(
        chronologicalAge: 30.0,
        restingHeartRateBpm: 54, // -2 yrs
        averageSleepScore: 88, // -1.5 yrs
        bmi: 22.0, // -1.5 yrs
      );

      expect(res.biologicalAge, equals(25.0)); // 30 - 5 = 25
      expect(res.ageDeltaYears, equals(5.0));
    });

    test('CGM spike detector triggers alert for +35 mg/dL spike within 45 minutes', () {
      final res = engine.detectCgmSpike(
        startGlucoseMgDl: 95.0,
        peakGlucoseMgDl: 140.0, // +45 mg/dL
        windowMinutes: 35,
      );

      expect(res.isSpikeDetected, isTrue);
      expect(res.severity, contains('Spike'));
    });

    test('Drug-Nutrient interaction check produces warning for Metformin & High Carbs', () {
      final warning = engine.checkDrugInteraction(
        medicationName: 'Metformin 500mg',
        nutrientCategory: 'High Carbs',
      );

      expect(warning, isNotNull);
      expect(warning, contains('High-carb meals may delay Metformin'));
    });
  });
}
