import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/adaptive_metabolism_engine.dart';
import 'package:fitkarma/core/brain/environmental_health_engine.dart';
import 'package:fitkarma/core/brain/womens_health_engine.dart';

void main() {
  group('Phase 15 Advanced Intelligence Layer Tests', () {
    const metabolismEngine = AdaptiveMetabolismEngine();
    const envEngine = EnvironmentalHealthEngine();
    const womensEngine = WomensHealthEngine();

    test('Adaptive Metabolism Engine calculates dynamic TDEE correctly', () {
      final res = metabolismEngine.calculateDynamicTdee(
        baseTdee: 2200.0,
        averageCaloricIntake: 2100.0,
        weightDelta7DaysKg: -0.3, // Weight loss offset
      );

      // Energy offset = (-0.3 * 7700) / 7 = -330 kcal/day
      // Dynamic TDEE = 2100 - (-330) = 2430 kcal/day
      expect(res.dynamicTdee, closeTo(2430.0, 5.0));
      expect(res.metabolicAdaptationState, contains('Metabolic Acceleration'));
    });

    test(
        'Environmental Health Engine shifts outdoor workouts to indoor when AQI > 150',
        () {
      final res = envEngine.evaluateEnvironmentalSafety(
        aqi: 165,
        uvIndex: 5.0,
        humidityPercent: 60.0,
      );

      expect(res.shouldShiftToIndoor, isTrue);
      expect(res.workoutRecommendation, contains('Unhealthy Air Quality'));
    });

    test(
        'Women\'s Health Engine adjusts strength target and nutrition per phase',
        () {
      final follicular =
          womensEngine.calculatePrescription(phase: MenstrualPhase.follicular);
      final luteal =
          womensEngine.calculatePrescription(phase: MenstrualPhase.luteal);

      expect(follicular.strengthTargetMultiplier, equals(1.05));
      expect(luteal.strengthTargetMultiplier, equals(0.95));
      expect(luteal.nutritionAdvice, contains('magnesium'));
    });
  });
}
