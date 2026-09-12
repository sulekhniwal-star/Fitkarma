enum AQICategory { good, moderate, poor, unhealthy, hazardous }
enum UVLevel { low, moderate, high, veryHigh, extreme }

class EnvironmentalAssessment {
  final int aqi;
  final AQICategory aqiCategory;
  final double uvIndex;
  final UVLevel uvLevel;
  final double temperatureC;
  final double humidityPercent;
  final double heatIndexC;
  final bool isOutdoorSafe;
  final String safetyAdvisory;
  final String safetyAdvisoryHindi;

  const EnvironmentalAssessment({
    required this.aqi,
    required this.aqiCategory,
    required this.uvIndex,
    required this.uvLevel,
    required this.temperatureC,
    required this.humidityPercent,
    required this.heatIndexC,
    required this.isOutdoorSafe,
    required this.safetyAdvisory,
    required this.safetyAdvisoryHindi,
  });
}

/// EnvironmentalHealthEngine (Base Version — Pure Dart / Deterministic / Offline-First)
/// Analyzes Indian climate conditions (AQI, Heat Index, UV) and generates workout safety modifiers.
class EnvironmentalHealthEngine {
  const EnvironmentalHealthEngine();

  AQICategory classifyAQI(int aqi) {
    if (aqi <= 50) return AQICategory.good;
    if (aqi <= 100) return AQICategory.moderate;
    if (aqi <= 200) return AQICategory.poor;
    if (aqi <= 300) return AQICategory.unhealthy;
    return AQICategory.hazardous;
  }

  UVLevel classifyUV(double uv) {
    if (uv < 3) return UVLevel.low;
    if (uv < 6) return UVLevel.moderate;
    if (uv < 8) return UVLevel.high;
    if (uv < 11) return UVLevel.veryHigh;
    return UVLevel.extreme;
  }

  /// Simplified Rothfusz Heat Index calculation in Celsius
  double calculateHeatIndex({
    required double temperatureC,
    required double humidityPercent,
  }) {
    if (temperatureC < 27.0) return temperatureC;

    // Convert to Fahrenheit for standard NOAA formula
    final tf = (temperatureC * 9 / 5) + 32;
    final rh = humidityPercent;

    double hif = -42.379 +
        (2.04901523 * tf) +
        (10.14333127 * rh) -
        (0.22475541 * tf * rh) -
        (0.00683783 * tf * tf) -
        (0.05481717 * rh * rh) +
        (0.00122874 * tf * tf * rh) +
        (0.00085282 * tf * rh * rh) -
        (0.00000199 * tf * tf * rh * rh);

    // Convert back to Celsius
    return (hif - 32) * 5 / 9;
  }

  EnvironmentalAssessment assess({
    required int aqi,
    required double uvIndex,
    required double temperatureC,
    required double humidityPercent,
  }) {
    final aqiCategory = classifyAQI(aqi);
    final uvLevel = classifyUV(uvIndex);
    final heatIndex = calculateHeatIndex(
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
    );

    bool isOutdoorSafe = true;
    String advisory = 'Ideal conditions for outdoor training.';
    String advisoryHindi = 'बाहरी कसरत के लिए आदर्श मौसम है।';

    if (aqi > 200) {
      isOutdoorSafe = false;
      advisory = 'High pollution detected (AQI $aqi). Switch outdoor workouts to indoor zone 2/strength.';
      advisoryHindi = 'हवा की गुणवत्ता खराब है (AQI $aqi)। कृपया इनडोर व्यायाम करें।';
    } else if (heatIndex > 38.0) {
      isOutdoorSafe = false;
      advisory = 'Extreme heat stress (${heatIndex.toStringAsFixed(1)}°C index). Avoid midday outdoor workouts.';
      advisoryHindi = 'अत्यधिक गर्मी है। दोपहर में बाहर कसरत करने से बचें।';
    } else if (aqi > 100) {
      advisory = 'Moderate AQI ($aqi). Limit high-intensity running near traffic corridors.';
      advisoryHindi = 'मध्यम वायु गुणवत्ता ($aqi)। व्यस्त सड़कों के पास दौड़ने से बचें।';
    }

    return EnvironmentalAssessment(
      aqi: aqi,
      aqiCategory: aqiCategory,
      uvIndex: uvIndex,
      uvLevel: uvLevel,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      heatIndexC: double.parse(heatIndex.toStringAsFixed(1)),
      isOutdoorSafe: isOutdoorSafe,
      safetyAdvisory: advisory,
      safetyAdvisoryHindi: advisoryHindi,
    );
  }
}
