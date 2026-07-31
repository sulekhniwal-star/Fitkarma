import 'dart:math';

class ActivityLog {
  final String activityType; // "running" | "walking" | "strength" | "cycling"
  final int durationMinutes;
  final String intensity; // "low" | "medium" | "high"

  ActivityLog({
    required this.activityType,
    required this.durationMinutes,
    required this.intensity,
  });
}

/// DailyStrainCalculator (Pure Dart, No AI, 0-21 scale)
class DailyStrainCalculator {
  const DailyStrainCalculator();

  /// Calculates the 0-21 daily strain score based on heart rate zone durations,
  /// step count, and environmental heat index, with fallback estimation.
  double calculateStrain({
    Map<int, int>? zoneDurationsMinutes, // Key: Zone 1-5, Value: Minutes
    required int dailySteps,
    required double heatIndexCelsius,
    // Fallback parameters (used if zoneDurationsMinutes is null/empty)
    int? activeMinutes,
    int? restingHeartRate,
    int? averageHeartRate,
    List<ActivityLog>? dailyActivities,
  }) {
    final Map<int, int> resolvedZones = Map<int, int>.from(zoneDurationsMinutes ?? {});

    // 1. If detailed zones are missing, estimate them using fallback parameters
    if (resolvedZones.isEmpty) {
      final estimated = estimateZonesFromTelemetry(
        dailySteps: dailySteps,
        activeMinutes: activeMinutes ?? 0,
        restingHeartRate: restingHeartRate,
        averageHeartRate: averageHeartRate,
        dailyActivities: dailyActivities ?? [],
      );
      resolvedZones.addAll(estimated);
    }

    // 2. Compute cardiac impulse from resolved zones
    final zoneWeights = {
      1: 0.05, // Active Recovery
      2: 0.15, // Aerobic
      3: 0.35, // Tempo
      4: 0.70, // Threshold
      5: 1.50, // Anaerobic
    };

    double cardiacImpulse = 0.0;
    resolvedZones.forEach((zone, minutes) {
      final weight = zoneWeights[zone] ?? 0.0;
      cardiacImpulse += minutes * weight;
    });

    // 3. Compute step-based impulse (additional physical strain)
    final double stepsImpulse = (dailySteps / 10000.0) * 2.25;

    // 4. Factor in environmental heat strain
    double heatFactor = 1.0;
    if (heatIndexCelsius > 32.0) {
      heatFactor += (heatIndexCelsius - 32.0) * 0.02; // +2% strain per degree Celsius above 32C
    }

    final totalImpulse = (cardiacImpulse + stepsImpulse) * heatFactor;
    final strain = 21.0 * (1.0 - exp(-0.015 * totalImpulse));

    return double.parse(strain.toStringAsFixed(1));
  }

  /// Reconstructs heart rate zone durations when detailed tracker data is missing.
  Map<int, int> estimateZonesFromTelemetry({
    required int dailySteps,
    required int activeMinutes,
    int? restingHeartRate,
    int? averageHeartRate,
    required List<ActivityLog> dailyActivities,
  }) {
    final Map<int, int> estimatedZones = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    // 1. Process activity logs (highly specific mapping based on exercise type)
    if (dailyActivities.isNotEmpty) {
      for (final activity in dailyActivities) {
        final duration = activity.durationMinutes;
        switch (activity.activityType.toLowerCase()) {
          case 'running':
            if (activity.intensity.toLowerCase() == 'high') {
              estimatedZones[3] = (estimatedZones[3]! + duration * 0.4).round();
              estimatedZones[4] = (estimatedZones[4]! + duration * 0.4).round();
              estimatedZones[5] = (estimatedZones[5]! + duration * 0.2).round();
            } else {
              estimatedZones[2] = (estimatedZones[2]! + duration * 0.3).round();
              estimatedZones[3] = (estimatedZones[3]! + duration * 0.5).round();
              estimatedZones[4] = (estimatedZones[4]! + duration * 0.2).round();
            }
            break;
          case 'strength':
            estimatedZones[1] = (estimatedZones[1]! + duration * 0.5).round();
            estimatedZones[2] = (estimatedZones[2]! + duration * 0.3).round();
            estimatedZones[3] = (estimatedZones[3]! + duration * 0.2).round();
            break;
          case 'walking':
            estimatedZones[1] = estimatedZones[1]! + duration;
            break;
          case 'cycling':
            estimatedZones[2] = (estimatedZones[2]! + duration * 0.6).round();
            estimatedZones[3] = (estimatedZones[3]! + duration * 0.4).round();
            break;
          default:
            estimatedZones[2] = estimatedZones[2]! + duration;
        }
      }
      return estimatedZones;
    }

    // 2. If no activities are logged, use step cadence & active minutes to estimate cardiorespiratory zones
    if (activeMinutes > 0) {
      final averageCadenceSpm = dailySteps / activeMinutes.toDouble();

      if (averageCadenceSpm >= 110.0) {
        estimatedZones[2] = (activeMinutes * 0.7).round();
        estimatedZones[3] = (activeMinutes * 0.3).round();
      } else if (averageCadenceSpm >= 85.0) {
        estimatedZones[1] = (activeMinutes * 0.8).round();
        estimatedZones[2] = (activeMinutes * 0.2).round();
      } else {
        estimatedZones[1] = activeMinutes;
      }
      return estimatedZones;
    }

    // 3. Fallback: If we only have steps, derive standard active recovery zone durations
    if (dailySteps > 0) {
      final estimatedActiveMinutes = (dailySteps / 100).round();
      estimatedZones[1] = estimatedActiveMinutes;
    }

    return estimatedZones;
  }
}
