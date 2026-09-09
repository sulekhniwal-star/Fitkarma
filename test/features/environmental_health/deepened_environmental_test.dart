import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/environmental_health/domain/deepened_environmental_engine.dart';
import 'package:fitkarma/features/environmental_health/domain/deepened_environmental_models.dart';
import 'package:fitkarma/features/environmental_health/domain/environmental_health_engine.dart';
import 'package:fitkarma/features/environmental_health/providers/deepened_environmental_provider.dart';

void main() {
  group('DeepenedEnvironmentalEngine Tests', () {
    const engine = DeepenedEnvironmentalEngine();

    test('Synthesizes pristine report for optimal mountain/coastal atmospheric conditions', () {
      final report = engine.synthesizeReport(
        aqi: 35,
        uvIndex: 4.0,
        temperatureC: 22.0,
        humidityPercent: 45.0,
        pm25: 12.0,
        pm10: 25.0,
        no2Ppb: 10.0,
        so2Ppb: 4.0,
        coPpm: 0.4,
        ozonePpb: 20.0,
        timestamp: DateTime(2026, 3, 15, 7, 0), // March (Vasanta)
      );

      expect(report.environmentalSafetyIndex, greaterThanOrEqualTo(85.0));
      expect(report.baseSnapshot.aqiCategory, equals(AqiCategory.good));
      expect(report.pulmonaryStress.recommendedMode, equals(TrainingEnvironmentMode.outdoorUnrestricted));
      expect(report.pulmonaryStress.maskTier, equals(ProtectiveMaskTier.none));
      expect(report.pulmonaryStress.hasThermalInversionWarning, isFalse);
      expect(report.rituCharya.season, equals(RituSeason.vasanta));
      expect(report.rituCharya.herbalRespiratoryShield, contains('Sitopaladi'));
      expect(report.thermalStrain.wbgtCelsius, lessThan(24.0));
    });

    test('Identifies winter morning thermal smog inversion and halts outdoor cardio', () {
      final report = engine.synthesizeReport(
        aqi: 340,
        uvIndex: 2.0,
        temperatureC: 12.0,
        humidityPercent: 82.0,
        pm25: 245.0,
        timestamp: DateTime(2026, 12, 10, 6, 30), // Dec early morning (Hemanta)
      );

      expect(report.environmentalSafetyIndex, lessThan(40.0));
      expect(report.baseSnapshot.aqiCategory, equals(AqiCategory.veryPoor));
      expect(report.pulmonaryStress.hasThermalInversionWarning, isTrue);
      expect(report.pulmonaryStress.recommendedMode, equals(TrainingEnvironmentMode.hazardousHalt));
      expect(report.pulmonaryStress.maskTier, equals(ProtectiveMaskTier.n99Mandatory));
      expect(report.pulmonaryStress.inhaledPm25MicrogramsPerHour, greaterThan(400.0));
      expect(report.rituCharya.season, equals(RituSeason.hemanta));
      expect(report.rituCharya.herbalRespiratoryShield, contains('Chyawanprash'));
    });

    test('Computes extreme thermal strain and high sweat/sodium loss during summer heatwave', () {
      final report = engine.synthesizeReport(
        aqi: 95,
        uvIndex: 11.5,
        temperatureC: 42.0,
        humidityPercent: 65.0,
        timestamp: DateTime(2026, 5, 20, 14, 0), // May afternoon (Grishma)
      );

      expect(report.baseSnapshot.uvCategory, equals(UvCategory.extreme));
      expect(report.thermalStrain.wbgtCelsius, greaterThan(32.0));
      expect(report.thermalStrain.estimatedSweatLossPerHourMl, greaterThan(1100.0));
      expect(report.thermalStrain.sodiumLossMg, greaterThan(900));
      expect(report.rituCharya.season, equals(RituSeason.grishma));
      expect(report.rituCharya.hydrationElectrolyteFormula, contains('Tender Coconut'));
    });

    test('Accurately maps all 6 Ayurvedic Indian seasons across calendar months', () {
      expect(
        engine.synthesizeReport(aqi: 50, uvIndex: 5, temperatureC: 25, humidityPercent: 50, timestamp: DateTime(2026, 1, 15)).rituCharya.season,
        equals(RituSeason.shishira),
      );
      expect(
        engine.synthesizeReport(aqi: 50, uvIndex: 5, temperatureC: 25, humidityPercent: 50, timestamp: DateTime(2026, 3, 15)).rituCharya.season,
        equals(RituSeason.vasanta),
      );
      expect(
        engine.synthesizeReport(aqi: 50, uvIndex: 5, temperatureC: 25, humidityPercent: 50, timestamp: DateTime(2026, 5, 15)).rituCharya.season,
        equals(RituSeason.grishma),
      );
      expect(
        engine.synthesizeReport(aqi: 50, uvIndex: 5, temperatureC: 25, humidityPercent: 50, timestamp: DateTime(2026, 7, 15)).rituCharya.season,
        equals(RituSeason.varsha),
      );
      expect(
        engine.synthesizeReport(aqi: 50, uvIndex: 5, temperatureC: 25, humidityPercent: 50, timestamp: DateTime(2026, 9, 15)).rituCharya.season,
        equals(RituSeason.sharad),
      );
      expect(
        engine.synthesizeReport(aqi: 50, uvIndex: 5, temperatureC: 25, humidityPercent: 50, timestamp: DateTime(2026, 11, 15)).rituCharya.season,
        equals(RituSeason.hemanta),
      );
    });
  });

  group('DeepenedEnvironmentalNotifier Tests', () {
    test('Initializes with baseline report and updates on atmospheric telemetry change', () {
      final notifier = DeepenedEnvironmentalNotifier();
      expect(notifier.state.pollutants.pm25, equals(52.0));
      expect(notifier.state.environmentalSafetyIndex, greaterThan(50.0));

      notifier.updateAtmosphericReadings(
        aqi: 40,
        uvIndex: 3.0,
        temperatureC: 24.0,
        humidityPercent: 50.0,
        pm25: 15.0,
      );

      expect(notifier.state.baseSnapshot.aqi, equals(40));
      expect(notifier.state.environmentalSafetyIndex, greaterThan(80.0));
    });
  });
}
