import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/metabolism/services/metabolism_engine.dart';
import 'package:fitkarma/features/environmental/services/environmental_health_engine.dart';
import 'package:fitkarma/features/program_evolution/services/program_evolution_engine.dart';

void main() {
  group('MetabolismEngine (Deterministic Pure Dart)', () {
    const engine = MetabolismEngine();

    test('BMR calculation for male conforms to Mifflin-St Jeor formula', () {
      // BMR = (10 * 70) + (6.25 * 175) - (5 * 25) + 5 = 700 + 1093.75 - 125 + 5 = 1673.75
      final bmr = engine.calculateBMR(
        weightKg: 70.0,
        heightCm: 175.0,
        age: 25,
        gender: Gender.male,
      );
      expect(bmr, equals(1673.75));
    });

    test('BMR calculation for female conforms to Mifflin-St Jeor formula', () {
      // BMR = (10 * 60) + (6.25 * 160) - (5 * 30) - 161 = 600 + 1000 - 150 - 161 = 1289.0
      final bmr = engine.calculateBMR(
        weightKg: 60.0,
        heightCm: 160.0,
        age: 30,
        gender: Gender.female,
      );
      expect(bmr, equals(1289.0));
    });

    test('Metabolic profile calculates macro splits and deficit correctly', () {
      final profile = engine.calculateProfile(
        weightKg: 80.0,
        heightCm: 180.0,
        age: 28,
        gender: Gender.male,
        activityLevel: ActivityLevel.moderate, // multiplier 1.55
        goal: Goal.fatLoss, // -450 kcal
      );

      expect(profile.bmr, greaterThan(1700));
      expect(profile.targetCalories, equals(double.parse((profile.tdee - 450).toStringAsFixed(1))));
      expect(profile.targetProteinGrams, equals(160.0)); // 80kg * 2.0g for fat loss
      expect(profile.targetFatsGrams, greaterThan(0));
      expect(profile.targetCarbsGrams, greaterThan(0));
    });
  });

  group('EnvironmentalHealthEngine (Deterministic)', () {
    const envEngine = EnvironmentalHealthEngine();

    test('AQI classification categorizes accurately', () {
      expect(envEngine.classifyAQI(40), equals(AQICategory.good));
      expect(envEngine.classifyAQI(85), equals(AQICategory.moderate));
      expect(envEngine.classifyAQI(160), equals(AQICategory.poor));
      expect(envEngine.classifyAQI(250), equals(AQICategory.unhealthy));
      expect(envEngine.classifyAQI(450), equals(AQICategory.hazardous));
    });

    test('Assesses outdoor safety modifier accurately when AQI is unhealthy', () {
      final assessment = envEngine.assess(
        aqi: 240,
        uvIndex: 4.0,
        temperatureC: 28.0,
        humidityPercent: 50.0,
      );

      expect(assessment.isOutdoorSafe, isFalse);
      expect(assessment.safetyAdvisory, contains('High pollution detected'));
    });
  });

  group('ProgramEvolutionEngine (Deterministic)', () {
    const evoEngine = ProgramEvolutionEngine();

    test('Recommends deload if readiness is low and soreness is elevated', () {
      final rec = evoEngine.evaluateWeeklyCycle(
        adherenceRate: 0.90,
        averageReadinessScore: 45.0,
        sorenessFlagCount: 5,
      );

      expect(rec.trend, equals(EvolutionTrend.deload));
      expect(rec.volumeAdjustmentPercent, equals(-25.0));
    });

    test('Recommends progressive overload if adherence and recovery are prime', () {
      final rec = evoEngine.evaluateWeeklyCycle(
        adherenceRate: 0.95,
        averageReadinessScore: 82.0,
        sorenessFlagCount: 1,
      );

      expect(rec.trend, equals(EvolutionTrend.progressiveOverload));
      expect(rec.volumeAdjustmentPercent, equals(5.0));
    });
  });
}
