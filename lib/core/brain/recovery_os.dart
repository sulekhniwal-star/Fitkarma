import 'dart:math';

/// §P2-D Recovery Operating System (Pure Dart, No AI)

/// 1. Sleep Need Calculator
class SleepNeedResult {
  final int totalSleepNeedMin;
  final int baselineNeedMin;
  final int sleepDebtAdditiveMin;
  final int strainAdditiveMin;
  final int stressAdditiveMin;
  final int illnessAdditiveMin;

  const SleepNeedResult({
    required this.totalSleepNeedMin,
    required this.baselineNeedMin,
    required this.sleepDebtAdditiveMin,
    required this.strainAdditiveMin,
    required this.stressAdditiveMin,
    required this.illnessAdditiveMin,
  });

  double get totalSleepNeedHours =>
      double.parse((totalSleepNeedMin / 60.0).toStringAsFixed(2));
}

class SleepNeedCalculator {
  const SleepNeedCalculator();

  SleepNeedResult calculate({
    int baselineNeedMin = 480, // Default 8 hours
    int accumulatedSleepDebtMin = 0,
    double yesterdayStrain = 0.0,
    int stressScore = 1, // 1 to 5
    bool isIllnessActive = false,
  }) {
    // 1. Sleep Debt: 100% of accumulated deficit, capped at 90 mins
    final debtAdditive = accumulatedSleepDebtMin.clamp(0, 90);

    // 2. Training Strain Additive: up to 60 mins for heavy days (strain >= 12)
    int strainAdditive = 0;
    if (yesterdayStrain >= 16.0) {
      strainAdditive = 60;
    } else if (yesterdayStrain >= 12.0) {
      strainAdditive = 45;
    } else if (yesterdayStrain >= 6.0) {
      strainAdditive = 20;
    }

    // 3. Stress Additive: up to 30 mins
    final clampedStress = stressScore.clamp(1, 5);
    final stressAdditive = (clampedStress - 1) * 7.5.round();

    // 4. Illness Additive: +60 mins
    final illnessAdditive = isIllnessActive ? 60 : 0;

    final unscaledTotal = baselineNeedMin +
        debtAdditive +
        strainAdditive +
        stressAdditive +
        illnessAdditive;
    // Hard cap at 600 mins (10 hours)
    final totalSleepNeedMin = min(600, unscaledTotal);

    return SleepNeedResult(
      totalSleepNeedMin: totalSleepNeedMin,
      baselineNeedMin: baselineNeedMin,
      sleepDebtAdditiveMin: debtAdditive,
      strainAdditiveMin: strainAdditive,
      stressAdditiveMin: stressAdditive,
      illnessAdditiveMin: illnessAdditive,
    );
  }
}

/// 2. Bedtime Coach
class BedtimeCoachResult {
  final DateTime targetBedtime;
  final DateTime targetWakeTime;
  final int sleepNeedMin;
  final int windDownBufferMin;
  final String nudgeMessage;

  const BedtimeCoachResult({
    required this.targetBedtime,
    required this.targetWakeTime,
    required this.sleepNeedMin,
    required this.windDownBufferMin,
    required this.nudgeMessage,
  });
}

class BedtimeCoach {
  const BedtimeCoach();

  BedtimeCoachResult calculateBedtime({
    required int sleepNeedMin,
    required DateTime targetWakeTime,
    int windDownBufferMin = 15,
  }) {
    final totalOffsetMin = sleepNeedMin + windDownBufferMin;
    final targetBedtime =
        targetWakeTime.subtract(Duration(minutes: totalOffsetMin));

    final hours = (sleepNeedMin / 60).floor();
    final mins = sleepNeedMin % 60;
    final formattedNeed = '${hours}h ${mins > 0 ? '${mins}m' : ''}';

    final bedtimeFormatted =
        '${targetBedtime.hour.toString().padLeft(2, '0')}:${targetBedtime.minute.toString().padLeft(2, '0')}';

    final nudgeMessage =
        'Bedtime Coach: Wind down now to meet your $formattedNeed sleep target. Aim to sleep by $bedtimeFormatted to maintain recovery capacity.';

    return BedtimeCoachResult(
      targetBedtime: targetBedtime,
      targetWakeTime: targetWakeTime,
      sleepNeedMin: sleepNeedMin,
      windDownBufferMin: windDownBufferMin,
      nudgeMessage: nudgeMessage,
    );
  }
}

/// 3. Recovery Capacity & Decision Matrix
class RecoveryDecision {
  final int capacityScore; // 0 to 100
  final double strainCap; // Recommended strain ceiling (4.0 to 21.0)
  final String trainingAdvice;

  const RecoveryDecision({
    required this.capacityScore,
    required this.strainCap,
    required this.trainingAdvice,
  });
}

class RecoveryDecisionEngine {
  static const double maxStrainLimit = 21.0;

  const RecoveryDecisionEngine();

  RecoveryDecision evaluate({
    required int readinessScore,
    required double dailyStrain,
    required double sleepDebtHours,
  }) {
    final capacityFactor = (readinessScore / 100.0) - (sleepDebtHours * 0.1);
    final capacityScore = (capacityFactor * 100).clamp(0.0, 100.0).round();
    final strainCap = (capacityFactor * 18.0).clamp(4.0, maxStrainLimit);

    String trainingAdvice;
    if (readinessScore >= 80 && dailyStrain < strainCap) {
      trainingAdvice =
          'High Capacity. Body is fully primed for heavy training load.';
    } else if (readinessScore >= 50 && dailyStrain < strainCap) {
      trainingAdvice =
          'Standard Capacity. Maintain standard training; avoid extra sets.';
    } else {
      trainingAdvice =
          'Low Capacity / Overreaching. Limit strain to active recovery or rest.';
    }

    return RecoveryDecision(
      capacityScore: capacityScore,
      strainCap: strainCap,
      trainingAdvice: trainingAdvice,
    );
  }
}

/// 4. Recovery Behaviors & Actionable Prescriptions
class RecoveryPrescriptionItem {
  final String title;
  final String detail;
  final bool isCompleted;

  const RecoveryPrescriptionItem({
    required this.title,
    required this.detail,
    this.isCompleted = false,
  });
}

class RecoveryPrescriptionEngine {
  const RecoveryPrescriptionEngine();

  List<RecoveryPrescriptionItem> generatePrescription({
    required int readinessScore,
    required int capacityScore,
    required bool isIllnessActive,
  }) {
    final list = <RecoveryPrescriptionItem>[];

    if (readinessScore < 50 || isIllnessActive) {
      list.add(const RecoveryPrescriptionItem(
        title: 'Active Recovery',
        detail: 'Target 25-minute low-intensity walk or light mobility.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Sleep Extension',
        detail: 'Bedtime moved 45 min earlier tonight.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Nutrition',
        detail: 'Prioritize protein target for tissue repair.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Hydration Boost',
        detail: 'Hydrate with an extra +700ml water.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Training Restriction',
        detail: 'No high-intensity HIIT or maximum lifts today.',
      ));
    } else if (readinessScore < 70) {
      list.add(const RecoveryPrescriptionItem(
        title: 'Standard Workout',
        detail: 'Proceed with planned sets; omit extra burn-out sets.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Evening Wind-down',
        detail: '15-min evening mobility & foam rolling.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Hydration Target',
        detail: 'Maintain standard 2.5L hydration.',
      ));
    } else {
      list.add(const RecoveryPrescriptionItem(
        title: 'Full Training',
        detail: 'Push for progressive overload PRs today.',
      ));
      list.add(const RecoveryPrescriptionItem(
        title: 'Post-Workout Fuel',
        detail: 'Consume 30g protein within 45 mins post-workout.',
      ));
    }

    return list;
  }
}

/// 5. Circadian Score Engine
class CircadianScoreEngine {
  const CircadianScoreEngine();

  double calculateCircadianScore({
    required double midpointShiftMinutes,
    bool morningLightLogged = false,
  }) {
    double score = 100.0;

    // Midpoint Shift Penalty (shifts > 60 mins penalize score)
    if (midpointShiftMinutes > 60.0) {
      final excess = midpointShiftMinutes - 60.0;
      score -= (excess * 0.5).clamp(0.0, 20.0);
    } else if (midpointShiftMinutes > 30.0) {
      score -= 5.0;
    }

    // Morning Light Exposure bonus (+5 pts)
    if (morningLightLogged) {
      score += 5.0;
    }

    return score.clamp(0.0, 100.0);
  }
}

/// 6. Illness & Recovery Type Detection
enum FatigueType {
  optimal,
  sleepFatigue,
  trainingFatigue,
  stressFatigue,
  illnessFatigue,
}

class RecoveryTypeDetectionResult {
  final FatigueType type;
  final String label;
  final String description;
  final bool isIllnessDetected;

  const RecoveryTypeDetectionResult({
    required this.type,
    required this.label,
    required this.description,
    required this.isIllnessDetected,
  });
}

class IllnessRecoveryDetector {
  const IllnessRecoveryDetector();

  RecoveryTypeDetectionResult detect({
    required int currentRhr,
    required int baselineRhr,
    required double currentHrv,
    required double baselineHrv,
    required double sleepDebtHours,
    required double dailyStrain,
    required int stressScore,
  }) {
    final rhrElevated = baselineRhr > 0 && (currentRhr - baselineRhr) >= 7;
    final hrvDepressed = baselineHrv > 0 && (currentHrv / baselineHrv) <= 0.70;

    if (rhrElevated && hrvDepressed) {
      return const RecoveryTypeDetectionResult(
        type: FatigueType.illnessFatigue,
        label: 'Illness Fatigue',
        description:
            'Elevated biometric signals suggest potential illness. Mandatory rest day prescribed.',
        isIllnessDetected: true,
      );
    }

    if (sleepDebtHours >= 1.5) {
      return const RecoveryTypeDetectionResult(
        type: FatigueType.sleepFatigue,
        label: 'Sleep Fatigue',
        description:
            'Accumulated sleep debt is limiting physical recovery capacity.',
        isIllnessDetected: false,
      );
    }

    if (dailyStrain >= 15.0) {
      return const RecoveryTypeDetectionResult(
        type: FatigueType.trainingFatigue,
        label: 'Training Fatigue',
        description:
            'Heavy cardiovascular strain load accumulated. Prioritize muscle repair.',
        isIllnessDetected: false,
      );
    }

    if (stressScore >= 4) {
      return const RecoveryTypeDetectionResult(
        type: FatigueType.stressFatigue,
        label: 'Stress Fatigue',
        description:
            'Elevated daytime stress load detected. Incorporate parasympathetic breathwork.',
        isIllnessDetected: false,
      );
    }

    return const RecoveryTypeDetectionResult(
      type: FatigueType.optimal,
      label: 'Optimal Recovery',
      description: 'Biometrics and recovery capacity are balanced.',
      isIllnessDetected: false,
    );
  }
}

/// 7. Recovery Drivers Breakdown
class DriverItem {
  final String name;
  final int points; // positive for contributor, negative for detractor
  final bool isContributor;

  const DriverItem({
    required this.name,
    required this.points,
    required this.isContributor,
  });
}

class RecoveryDriversResult {
  final List<DriverItem> contributors;
  final List<DriverItem> detractors;

  const RecoveryDriversResult({
    required this.contributors,
    required this.detractors,
  });
}

class RecoveryDriversEngine {
  const RecoveryDriversEngine();

  RecoveryDriversResult calculateDrivers({
    required int sleepQuality,
    required int proteinG,
    required double hydrationL,
    required int stressScore,
    required int aqi,
    required double heatIndexC,
  }) {
    final contributors = <DriverItem>[];
    final detractors = <DriverItem>[];

    if (sleepQuality >= 4) {
      contributors.add(DriverItem(
          name: 'Sleep Quality',
          points: (sleepQuality * 4),
          isContributor: true));
    }
    if (proteinG >= 100) {
      contributors.add(const DriverItem(
          name: 'Protein Intake', points: 12, isContributor: true));
    }
    if (hydrationL >= 2.5) {
      contributors.add(const DriverItem(
          name: 'Hydration Target', points: 8, isContributor: true));
    }

    if (stressScore >= 3) {
      detractors.add(DriverItem(
          name: 'Daily Stress',
          points: -(stressScore * 4),
          isContributor: false));
    }
    if (aqi > 150) {
      detractors.add(const DriverItem(
          name: 'Poor Ambient AQI', points: -7, isContributor: false));
    }
    if (heatIndexC > 35) {
      detractors.add(const DriverItem(
          name: 'Extreme Heat', points: -4, isContributor: false));
    }

    return RecoveryDriversResult(
      contributors: contributors,
      detractors: detractors,
    );
  }
}

/// 8. Recovery Age & Forecasting
class RecoveryAgeResult {
  final int chronologicalAge;
  final int recoveryAge;
  final String summary;

  const RecoveryAgeResult({
    required this.chronologicalAge,
    required this.recoveryAge,
    required this.summary,
  });
}

class RecoveryForecastingEngine {
  const RecoveryForecastingEngine();

  RecoveryAgeResult calculateRecoveryAge({
    required int chronologicalAge,
    required double avgHrv,
    required double restingHr,
    required double sleepEfficiencyRatio,
  }) {
    int ageDelta = 0;

    if (avgHrv >= 70) {
      ageDelta -= 4;
    } else if (avgHrv <= 35) {
      ageDelta += 3;
    }

    if (restingHr <= 55) {
      ageDelta -= 3;
    } else if (restingHr >= 75) {
      ageDelta += 2;
    }

    if (sleepEfficiencyRatio >= 0.90) ageDelta -= 2;

    final recoveryAge = max(18, chronologicalAge + ageDelta);
    final summary =
        'Chronological Age: $chronologicalAge | Recovery Age: $recoveryAge. Your recovery speed matches a ${recoveryAge < chronologicalAge ? 'younger' : 'standard'} profile.';

    return RecoveryAgeResult(
      chronologicalAge: chronologicalAge,
      recoveryAge: recoveryAge,
      summary: summary,
    );
  }

  List<int> generate5DayForecast({
    required int currentReadiness,
    required double sleepDebtHours,
    required double avgStrain,
  }) {
    final forecast = <int>[currentReadiness];
    double current = currentReadiness.toDouble();

    for (int i = 1; i <= 4; i++) {
      if (sleepDebtHours > 1.0) {
        current -= 3.0;
      } else {
        current += 2.0;
      }
      if (avgStrain > 14.0) {
        current -= 4.0;
      }
      forecast.add(current.clamp(20.0, 100.0).round());
    }

    return forecast;
  }
}
