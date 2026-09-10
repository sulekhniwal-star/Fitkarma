import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/deepened_environmental_engine.dart';
import '../domain/deepened_environmental_models.dart';

final deepenedEnvironmentalProvider = StateNotifierProvider<
    DeepenedEnvironmentalNotifier, DeepenedEnvironmentalReport>((ref) {
  return DeepenedEnvironmentalNotifier();
});

class DeepenedEnvironmentalNotifier
    extends StateNotifier<DeepenedEnvironmentalReport> {
  DeepenedEnvironmentalNotifier() : super(_buildInitialReport());

  static const DeepenedEnvironmentalEngine _engine =
      DeepenedEnvironmentalEngine();

  static DeepenedEnvironmentalReport _buildInitialReport() {
    return _engine.synthesizeReport(
      aqi: 135,
      uvIndex: 5.5,
      temperatureC: 28.5,
      humidityPercent: 58.0,
      pm25: 52.0,
      pm10: 88.0,
      no2Ppb: 32.0,
      so2Ppb: 12.0,
      coPpm: 1.4,
      ozonePpb: 45.0,
    );
  }

  void updateAtmosphericReadings({
    required int aqi,
    required double uvIndex,
    required double temperatureC,
    required double humidityPercent,
    double? pm25,
    double? pm10,
    double? no2Ppb,
    double? so2Ppb,
    double? coPpm,
    double? ozonePpb,
    DateTime? timestamp,
  }) {
    state = _engine.synthesizeReport(
      aqi: aqi,
      uvIndex: uvIndex,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      pm25: pm25,
      pm10: pm10,
      no2Ppb: no2Ppb,
      so2Ppb: so2Ppb,
      coPpm: coPpm,
      ozonePpb: ozonePpb,
      timestamp: timestamp,
    );
  }
}
