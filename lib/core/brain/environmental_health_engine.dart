/// Environmental Health Metric Result
class EnvironmentalHealthResult {
  final int aqi;
  final double uvIndex;
  final double humidityPercent;
  final bool shouldShiftToIndoor;
  final String workoutRecommendation;

  const EnvironmentalHealthResult({
    required this.aqi,
    required this.uvIndex,
    required this.humidityPercent,
    required this.shouldShiftToIndoor,
    required this.workoutRecommendation,
  });
}

/// Environmental Health Adaptation Engine
class EnvironmentalHealthEngine {
  const EnvironmentalHealthEngine();

  /// Evaluate Environmental Health hazards (AQI, UV Index, Humidity)
  EnvironmentalHealthResult evaluateEnvironmentalSafety({
    required int aqi,
    required double uvIndex,
    required double humidityPercent,
  }) {
    final shiftIndoor = aqi > 150;
    String rec;

    if (shiftIndoor) {
      rec =
          'Unhealthy Air Quality (AQI $aqi). Automatically shifted outdoor runs to indoor strength/treadmill.';
    } else if (uvIndex > 8.0) {
      rec =
          'Very High UV Index ($uvIndex). Recommend sun protection or early morning outdoor workout.';
    } else {
      rec = 'Optimal Environmental Conditions for Outdoor Training.';
    }

    return EnvironmentalHealthResult(
      aqi: aqi,
      uvIndex: uvIndex,
      humidityPercent: humidityPercent,
      shouldShiftToIndoor: shiftIndoor,
      workoutRecommendation: rec,
    );
  }
}
