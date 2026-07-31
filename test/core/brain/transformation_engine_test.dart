import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/transformation_engine.dart';

void main() {
  group('TransformationEngine 90-Day Forecast & Relapse Intervention Tests', () {
    const engine = TransformationEngine();

    test('90-day forecast produces realistic weight loss range based on energy deficit', () {
      final forecast = engine.calculate90DayForecast(
        currentWeightKg: 75.0,
        dailyCalorieDeficit: 400.0,
        daysAhead: 90,
      );

      // (400 * 90) / 7700 = 4.67 kg expected loss -> 70.33 kg expected
      expect(forecast.expectedKg, closeTo(70.33, 0.1));
      expect(forecast.minKg, lessThan(forecast.expectedKg));
      expect(forecast.maxKg, greaterThan(forecast.expectedKg));
    });

    test('Relapse Intervention triggers Tier 1 support for 3-5 missed days', () {
      final res = engine.evaluateRelapseTier(4);

      expect(res.tier, equals(RelapseTier.tier1Support));
      expect(res.title, contains('Supportive Check-in'));
    });

    test('Relapse Intervention triggers Tier 2 recalibration for 6-10 missed days', () {
      final res = engine.evaluateRelapseTier(7);

      expect(res.tier, equals(RelapseTier.tier2Recalibrate));
      expect(res.title, contains('Program Recalibration'));
    });

    test('Relapse Intervention triggers Tier 3 squad nudge for 11+ missed days', () {
      final res = engine.evaluateRelapseTier(14);

      expect(res.tier, equals(RelapseTier.tier3SquadNudge));
      expect(res.title, contains('Squad Support Alert'));
    });
  });
}
