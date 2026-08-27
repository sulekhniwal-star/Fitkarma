enum AqiCategory { good, satisfactory, moderate, poor, veryPoor, severe }
enum UvCategory { low, moderate, high, veryHigh, extreme }
enum HeatRiskLevel { low, caution, high, extreme }

class EnvironmentalHealthSnapshot {
  final int aqi; // Indian CPCB AQI (0 - 500)
  final AqiCategory aqiCategory;
  final double uvIndex; // 0 - 15+
  final UvCategory uvCategory;
  final double temperatureC;
  final double humidityPercent;
  final double heatIndexC;
  final HeatRiskLevel heatRisk;
  final bool outdoorWorkoutAllowed;
  final int extraHydrationMl; // Recommended extra water intake in ml
  final String recommendation;
  final DateTime capturedAt;

  const EnvironmentalHealthSnapshot({
    required this.aqi,
    required this.aqiCategory,
    required this.uvIndex,
    required this.uvCategory,
    required this.temperatureC,
    required this.humidityPercent,
    required this.heatIndexC,
    required this.heatRisk,
    required this.outdoorWorkoutAllowed,
    required this.extraHydrationMl,
    required this.recommendation,
    required this.capturedAt,
  });

  factory EnvironmentalHealthSnapshot.fromMap(Map<String, dynamic> map) {
    final aqiName = map['aqiCategory'] as String? ?? 'moderate';
    final uvName = map['uvCategory'] as String? ?? 'low';
    final heatName = map['heatRisk'] as String? ?? 'low';

    return EnvironmentalHealthSnapshot(
      aqi: (map['aqi'] as num?)?.toInt() ?? 120,
      aqiCategory: AqiCategory.values.firstWhere((e) => e.name == aqiName, orElse: () => AqiCategory.moderate),
      uvIndex: (map['uvIndex'] as num?)?.toDouble() ?? 4.0,
      uvCategory: UvCategory.values.firstWhere((e) => e.name == uvName, orElse: () => UvCategory.low),
      temperatureC: (map['temperatureC'] as num?)?.toDouble() ?? 28.0,
      humidityPercent: (map['humidityPercent'] as num?)?.toDouble() ?? 55.0,
      heatIndexC: (map['heatIndexC'] as num?)?.toDouble() ?? 30.0,
      heatRisk: HeatRiskLevel.values.firstWhere((e) => e.name == heatName, orElse: () => HeatRiskLevel.low),
      outdoorWorkoutAllowed: map['outdoorWorkoutAllowed'] as bool? ?? true,
      extraHydrationMl: (map['extraHydrationMl'] as num?)?.toInt() ?? 0,
      recommendation: map['recommendation'] as String? ?? 'Environment is suitable for regular training.',
      capturedAt: map['capturedAt'] != null
          ? DateTime.tryParse(map['capturedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aqi': aqi,
      'aqiCategory': aqiCategory.name,
      'uvIndex': uvIndex,
      'uvCategory': uvCategory.name,
      'temperatureC': temperatureC,
      'humidityPercent': humidityPercent,
      'heatIndexC': heatIndexC,
      'heatRisk': heatRisk.name,
      'outdoorWorkoutAllowed': outdoorWorkoutAllowed,
      'extraHydrationMl': extraHydrationMl,
      'recommendation': recommendation,
      'capturedAt': capturedAt.toIso8601String(),
    };
  }
}

class EnvironmentalHealthEngine {
  /// Evaluates AQI using Indian CPCB standards
  static AqiCategory categorizeAqi(int aqi) {
    if (aqi <= 50) return AqiCategory.good;
    if (aqi <= 100) return AqiCategory.satisfactory;
    if (aqi <= 200) return AqiCategory.moderate;
    if (aqi <= 300) return AqiCategory.poor;
    if (aqi <= 400) return AqiCategory.veryPoor;
    return AqiCategory.severe;
  }

  /// Evaluates UV index category
  static UvCategory categorizeUv(double uvi) {
    if (uvi < 3.0) return UvCategory.low;
    if (uvi < 6.0) return UvCategory.moderate;
    if (uvi < 8.0) return UvCategory.high;
    if (uvi < 11.0) return UvCategory.veryHigh;
    return UvCategory.extreme;
  }

  /// Calculates simplified Heat Index (°C) based on temperature and humidity
  static double calculateHeatIndex({required double tempC, required double humidity}) {
    if (tempC < 27.0) return tempC;
    // Rothfusz simplified regression approximation for Celsius
    final t = tempC;
    final r = humidity;
    final hi = -8.78469475556 +
        (1.61139411 * t) +
        (2.33854883889 * r) -
        (0.14611605 * t * r) -
        (0.012308094 * t * t) -
        (0.0164248277778 * r * r) +
        (0.002211732 * t * t * r) +
        (0.00072546 * t * r * r) -
        (0.000003582 * t * t * r * r);
    return hi.clamp(tempC, 65.0);
  }

  /// Pure Dart deterministic evaluation of environmental safety
  static EnvironmentalHealthSnapshot evaluate({
    required int aqi,
    required double uvIndex,
    required double temperatureC,
    required double humidityPercent,
  }) {
    final aqiCategory = categorizeAqi(aqi);
    final uvCategory = categorizeUv(uvIndex);
    final heatIndexC = calculateHeatIndex(tempC: temperatureC, humidity: humidityPercent);

    final HeatRiskLevel heatRisk;
    if (heatIndexC >= 41.0) {
      heatRisk = HeatRiskLevel.extreme;
    } else if (heatIndexC >= 35.0) {
      heatRisk = HeatRiskLevel.high;
    } else if (heatIndexC >= 30.0) {
      heatRisk = HeatRiskLevel.caution;
    } else {
      heatRisk = HeatRiskLevel.low;
    }

    // Determine extra hydration requirement
    int extraHydration = 0;
    if (heatRisk == HeatRiskLevel.extreme) {
      extraHydration += 1000;
    } else if (heatRisk == HeatRiskLevel.high) {
      extraHydration += 600;
    } else if (heatRisk == HeatRiskLevel.caution) {
      extraHydration += 300;
    }

    // Outdoor safety clearance
    bool outdoorAllowed = true;
    final List<String> notices = [];

    if (aqi > 250) {
      outdoorAllowed = false;
      notices.add('AQI is hazardous ($aqi). Shift all training indoors.');
    } else if (aqi > 150) {
      notices.add('AQI is poor ($aqi). Avoid high-intensity outdoor cardio.');
    }

    if (heatRisk == HeatRiskLevel.extreme || heatRisk == HeatRiskLevel.high) {
      outdoorAllowed = false;
      notices.add('Extreme heat index (${heatIndexC.round()}°C). Train indoors or before 7:00 AM.');
    }

    if (uvCategory == UvCategory.veryHigh || uvCategory == UvCategory.extreme) {
      notices.add('Peak UV index ($uvIndex). Apply SPF 50+ and wear protective headwear.');
    }

    final recommendation = notices.isNotEmpty
        ? notices.join(' ')
        : 'Weather conditions are optimal for outdoor running and training.';

    return EnvironmentalHealthSnapshot(
      aqi: aqi,
      aqiCategory: aqiCategory,
      uvIndex: uvIndex,
      uvCategory: uvCategory,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      heatIndexC: heatIndexC,
      heatRisk: heatRisk,
      outdoorWorkoutAllowed: outdoorAllowed,
      extraHydrationMl: extraHydration,
      recommendation: recommendation,
      capturedAt: DateTime.now(),
    );
  }
}
