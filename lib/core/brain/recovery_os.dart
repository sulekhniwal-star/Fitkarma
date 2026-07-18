import 'dart:math';

// ──────────────────────────────────────────────────────────────────────────────
// 1. Sleep Intelligence Layer
// ──────────────────────────────────────────────────────────────────────────────

class SleepNeedCalculator {
  /// Calculates the dynamic Sleep Need in minutes.
  int calculateSleepNeed({
    int baselineNeedMins = 480, // Default 8 hours
    double sleepDebtMins = 0.0,  // Deficit over the last 7 days (max addition: 90 mins)
    double yesterdayStrain = 0.0, // Yesterday's training load strain score (0–21)
    int stressLevel = 1,          // Daily inferred stress level (1–5)
    bool isSick = false,          // Active illness flag
  }) {
    // 1. Baseline
    double total = baselineNeedMins.toDouble();

    // 2. Sleep Debt (100% of accumulated debt, capped at 90 mins)
    total += sleepDebtMins.clamp(0.0, 90.0);

    // 3. Training Load Additive (up to 60 mins)
    final double trainingAdditive = (yesterdayStrain / 21.0) * 60.0;
    total += trainingAdditive.clamp(0.0, 60.0);

    // 4. Stress Additive (up to 30 mins)
    final double stressAdditive = (stressLevel - 1) * 7.5;
    total += stressAdditive.clamp(0.0, 30.0);

    // 5. Illness Additive (adds 60 mins if sick)
    if (isSick) {
      total += 60.0;
    }

    // 6. Safety Bounds: Hard cap at 600 mins (10 hours)
    return total.clamp(180.0, 600.0).round();
  }
}

class SleepPerformanceScore {
  /// Evaluates sleep quality out of 100 based on four pillars.
  int calculateScore({
    required int actualSleepMins,
    required int sleepNeedMins,
    required double efficiency,          // timeAsleep / totalTimeInBed (0.0 to 1.0)
    required double consistencyScore,    // 0.0 to 1.0
    required int opportunityMins,        // dedicated time in bed
  }) {
    if (sleepNeedMins <= 0) return 0;

    // Duration (40%)
    final double durationScore = (actualSleepMins / sleepNeedMins).clamp(0.0, 1.0) * 40.0;

    // Efficiency (30%)
    final double efficiencyScore = efficiency.clamp(0.0, 1.0) * 30.0;

    // Consistency (20%)
    final double consistencyWeighted = consistencyScore.clamp(0.0, 1.0) * 20.0;

    // Opportunity (10%) - Capped relative to 510 mins (8.5h window)
    final double opportunityScore = (opportunityMins / 510.0).clamp(0.0, 1.0) * 10.0;

    final double total = durationScore + efficiencyScore + consistencyWeighted + opportunityScore;
    return total.clamp(0.0, 100.0).round();
  }
}

class BedtimeCoach {
  /// Calculates bedtime based on target wake time and sleep need, incorporating a 15 min wind-down buffer.
  DateTime calculateBedtime({
    required int sleepNeedMins,
    required DateTime targetWakeTime,
    int windDownBufferMins = 15,
  }) {
    return targetWakeTime.subtract(Duration(minutes: sleepNeedMins + windDownBufferMins));
  }

  /// Generates a bedtime nudge message.
  String generateNudge({
    required int sleepNeedMins,
    required DateTime bedtime,
  }) {
    final hours = sleepNeedMins ~/ 60;
    final mins = sleepNeedMins % 60;
    final String targetLabel = mins > 0 ? '${hours}h ${mins}m' : '${hours}h';

    final String bedtimeStr = _formatTime(bedtime);

    return "Bedtime Coach: Wind down now to meet your $targetLabel sleep target. Aim to sleep by $bedtimeStr to maintain recovery capacity.";
  }

  String _formatTime(DateTime dt) {
    final int hour = dt.hour;
    final int minute = dt.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final String displayMinute = minute < 10 ? '0$minute' : '$minute';
    return "$displayHour:$displayMinute $period";
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 2. Recovery Capacity & Strain System
// ──────────────────────────────────────────────────────────────────────────────

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

class DailyStrainCalculator {
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
    final Map<int, int> resolvedZones = zoneDurationsMinutes != null ? Map.from(zoneDurationsMinutes) : {};

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
      1: 0.05,  // Active Recovery
      2: 0.15,  // Aerobic
      3: 0.35,  // Tempo
      4: 0.70,  // Threshold
      5: 1.50,  // Anaerobic
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

class RecoveryDecision {
  final int capacityScore;
  final double strainCap;
  final String trainingAdvice;

  RecoveryDecision({
    required this.capacityScore,
    required this.strainCap,
    required this.trainingAdvice,
  });
}

class RecoveryDecisionEngine {
  static const double maxStrainLimit = 21.0;

  RecoveryDecision evaluate({
    required int readinessScore,
    required double dailyStrain,
    required double sleepDebtHours,
  }) {
    // Determine capacity band based on readiness and sleep deficit
    final capacityFactor = (readinessScore / 100.0) - (sleepDebtHours * 0.1);
    final capacityScore = (capacityFactor * 100).clamp(0, 100).round();

    // Recommended Strain limit
    final strainCap = (capacityFactor * 18.0).clamp(4.0, maxStrainLimit);

    String trainingAdvice;
    if (readinessScore >= 80 && dailyStrain < strainCap) {
      trainingAdvice = "High Capacity. Body is fully primed for heavy training load.";
    } else if (readinessScore >= 50 && dailyStrain < strainCap) {
      trainingAdvice = "Standard Capacity. Maintain standard training; avoid extra sets.";
    } else {
      trainingAdvice = "Low Capacity / Overreaching. Limit strain to active recovery or rest.";
    }

    return RecoveryDecision(
      capacityScore: capacityScore,
      strainCap: double.parse(strainCap.toStringAsFixed(1)),
      trainingAdvice: trainingAdvice,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 3. Recovery Behaviors & Actionable Prescriptions
// ──────────────────────────────────────────────────────────────────────────────

class RecoveryPrescriptionGenerator {
  List<String> generate({required int capacityScore}) {
    if (capacityScore < 60) {
      return [
        "Active Recovery: Target 25-minute low-intensity walk",
        "Sleep Extension: Bedtime moved 45 min earlier",
        "Nutrition: Prioritize 120g protein for tissue repair",
        "Hydration: Hydrate with an extra +700ml water",
        "Restriction: No high-intensity HIIT or max-lifts"
      ];
    } else if (capacityScore < 80) {
      return [
        "Active Recovery: Target 15-minute mobility work",
        "Sleep Extension: Bedtime moved 15 min earlier",
        "Nutrition: Meet base protein target",
        "Hydration: Drink standard water amount"
      ];
    } else {
      return [
        "Training: Prime day to push high intensity",
        "Sleep: Maintain regular schedule",
        "Nutrition: Fuel for high performance"
      ];
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 4. Circadian & Environmental Intelligence
// ──────────────────────────────────────────────────────────────────────────────

class CircadianScoreCalculator {
  /// Calculates circadian alignment score out of 100.
  int calculateCircadianScore({
    required double midpointShiftMins, // Deviation of sleep midpoint from rolling average
    required bool morningLightExposure, // True if logged light exposure between 6 AM and 9 AM
  }) {
    double score = 100.0;

    // 1. Midpoint Shift Penalty: Shifts > 60 mins penalize score
    if (midpointShiftMins > 60.0) {
      final double penalty = (midpointShiftMins - 60.0) * 0.1;
      score -= penalty.clamp(0.0, 25.0); // Cap shift penalty at 25 points
    }

    // 2. Light Exposure Sync: positive adjustment of +10 points
    if (morningLightExposure) {
      score += 10.0;
    }

    return score.clamp(0.0, 100.0).round();
  }
}

class IllnessDetectionResult {
  final String illnessRiskStatus; // 'low' | 'high'
  final String? sicknessNudge;

  IllnessDetectionResult({
    required this.illnessRiskStatus,
    this.sicknessNudge,
  });
}

class IllnessDetector {
  /// Automatically flags potential illness based on biometric deviations.
  IllnessDetectionResult detect({
    required double restingHR,
    required double baselineHR,
    required double hrv,
    required double baselineHRV,
    required int sleepDurationMins,
    required int baselineSleepMins,
  }) {
    if (baselineHR <= 0 || baselineHRV <= 0 || baselineSleepMins <= 0) {
      return IllnessDetectionResult(illnessRiskStatus: 'low');
    }

    // resting HR is > 10% above baseline
    final bool hrElevated = (restingHR - baselineHR) / baselineHR > 0.10;

    // HRV is > 15% below baseline
    final bool hrvDepressed = (baselineHRV - hrv) / baselineHRV > 0.15;

    // sleep duration increases by > 20%
    final bool sleepElevated = (sleepDurationMins - baselineSleepMins) / baselineSleepMins > 0.20;

    if (hrElevated && hrvDepressed && sleepElevated) {
      return IllnessDetectionResult(
        illnessRiskStatus: 'high',
        sicknessNudge: "Warning: Elevated biometric signals suggest potential illness. Reducing training target by 50% and locking out high-intensity exercises.",
      );
    }

    return IllnessDetectionResult(illnessRiskStatus: 'low');
  }
}

class RecoveryDriversEngine {
  /// Calculates contributors and detractors to today's readiness score.
  Map<String, dynamic> calculateDrivers({
    required int sleepQuality,           // 1-5
    required int proteinG,
    required int targetProteinG,
    required int hydrationMl,
    required int targetHydrationMl,
    required int stressLevel,            // 1-5
    required int aqi,
    required double heatIndexCelsius,
  }) {
    final List<Map<String, dynamic>> contributors = [];
    final List<Map<String, dynamic>> detractors = [];

    // Sleep Quality
    if (sleepQuality >= 4) {
      contributors.add({'driver': 'Sleep Quality', 'impact': sleepQuality * 4});
    } else if (sleepQuality <= 2) {
      detractors.add({'driver': 'Poor Sleep', 'impact': (3 - sleepQuality) * 8});
    }

    // Protein Intake
    if (proteinG >= targetProteinG && targetProteinG > 0) {
      contributors.add({'driver': 'Protein Intake', 'impact': 12});
    }

    // Hydration Target
    if (hydrationMl >= targetHydrationMl && targetHydrationMl > 0) {
      contributors.add({'driver': 'Hydration Target', 'impact': 8});
    }

    // Stress Level
    if (stressLevel >= 4) {
      detractors.add({'driver': 'Daily Stress', 'impact': (stressLevel - 2) * 5});
    }

    // Ambient AQI
    if (aqi > 150) {
      detractors.add({'driver': 'Poor Ambient AQI', 'impact': 7});
    }

    // Extreme Heat
    if (heatIndexCelsius > 35.0) {
      detractors.add({'driver': 'Extreme Heat', 'impact': 4});
    }

    return {
      'contributors': contributors,
      'detractors': detractors,
    };
  }
}
