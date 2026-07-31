import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/daily_strain_calculator.dart';

void main() {
  group('DailyStrainCalculator Unit Tests', () {
    const calculator = DailyStrainCalculator();

    test('calculateStrain computes rest/light strain for low step count and no workouts', () {
      final strain = calculator.calculateStrain(
        dailySteps: 3000,
        heatIndexCelsius: 28.0,
      );

      expect(strain, greaterThanOrEqualTo(0.0));
      expect(strain, lessThan(6.0));
    });

    test('calculateStrain computes strain score for 10k steps and aerobic activity', () {
      final strain = calculator.calculateStrain(
        zoneDurationsMinutes: {
          1: 20,
          2: 40,
        },
        dailySteps: 10000,
        heatIndexCelsius: 30.0,
      );

      expect(strain, greaterThan(2.0));
      expect(strain, lessThanOrEqualTo(21.0));
    });

    test('calculateStrain applies heat factor multiplier when heat index exceeds 32C', () {
      final normalStrain = calculator.calculateStrain(
        zoneDurationsMinutes: {
          3: 30,
          4: 15,
        },
        dailySteps: 8000,
        heatIndexCelsius: 30.0,
      );

      final heatStrain = calculator.calculateStrain(
        zoneDurationsMinutes: {
          3: 30,
          4: 15,
        },
        dailySteps: 8000,
        heatIndexCelsius: 40.0,
      );

      expect(heatStrain, greaterThan(normalStrain));
    });

    test('calculateStrain bounds result to 0.0-21.0 max scale', () {
      final extremeStrain = calculator.calculateStrain(
        zoneDurationsMinutes: {
          4: 120,
          5: 60,
        },
        dailySteps: 35000,
        heatIndexCelsius: 42.0,
      );

      expect(extremeStrain, lessThanOrEqualTo(21.0));
    });
  });
}
