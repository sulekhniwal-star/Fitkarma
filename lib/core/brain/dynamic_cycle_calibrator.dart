enum CyclePhase { menstrual, follicular, ovulatory, luteal }

class MenstrualSymptomLog {
  final DateTime logDate;
  final bool hasMenstrualFlow; // Declares Day 1 of cycle
  final double?
      basalBodyTemperatureCelsius; // Post-ovulation BBT rises 0.2°C - 0.5°C
  final bool? positiveLhTest; // LH surge indicators
  final List<String>
      physicalSymptoms; // e.g., ['cramps', 'bloating', 'egg_white_mucus', 'ovulation_pain']
  final int?
      restingHeartRateBpm; // Progesterone surge causes RHR to rise 2-4 bpm
  final double?
      heartRateVariabilityMs; // Progesterone surge causes HRV to decrease

  MenstrualSymptomLog({
    required this.logDate,
    required this.hasMenstrualFlow,
    this.basalBodyTemperatureCelsius,
    this.positiveLhTest,
    required this.physicalSymptoms,
    this.restingHeartRateBpm,
    this.heartRateVariabilityMs,
  });
}

class DynamicCycleState {
  final int currentCycleDay;
  final int projectedCycleLength;
  final CyclePhase currentPhase;
  final bool isIrregularDetected;

  DynamicCycleState({
    required this.currentCycleDay,
    required this.projectedCycleLength,
    required this.currentPhase,
    required this.isIrregularDetected,
  });

  factory DynamicCycleState.defaultCalendar(int length, CyclePhase phase) =>
      DynamicCycleState(
        currentCycleDay: 1,
        projectedCycleLength: length,
        currentPhase: phase,
        isIrregularDetected: false,
      );
}

/// DynamicCycleCalibrator (Pure Dart, No AI)
class DynamicCycleCalibrator {
  const DynamicCycleCalibrator();

  /// Evaluates and recalibrates cycle phases dynamically based on historical averages
  /// and symptom logs, resolving PCOS or general irregularity issues.
  DynamicCycleState recalibratePhase({
    required List<MenstrualSymptomLog> symptomLogs,
    required int defaultCycleLengthDays, // e.g. 28 days onboarding fallback
  }) {
    if (symptomLogs.isEmpty) {
      return DynamicCycleState.defaultCalendar(
          defaultCycleLengthDays, CyclePhase.follicular);
    }

    // Sort logs chronologically
    final sortedLogs = List<MenstrualSymptomLog>.from(symptomLogs)
      ..sort((a, b) => a.logDate.compareTo(b.logDate));

    // 1. Identify start of current cycle (first day of flow)
    final flowStarts = sortedLogs
        .where((l) => l.hasMenstrualFlow)
        .map((l) => l.logDate)
        .toList();
    if (flowStarts.isEmpty) {
      return DynamicCycleState.defaultCalendar(
          defaultCycleLengthDays, CyclePhase.follicular);
    }

    final currentCycleStart = flowStarts.last;
    final daysInCurrentCycle =
        DateTime.now().difference(currentCycleStart).inDays + 1;

    // Calculate historical cycle lengths to detect variance (irregularity indicator)
    final historicalLengths = <int>[];
    for (int i = 1; i < flowStarts.length; i++) {
      historicalLengths.add(flowStarts[i].difference(flowStarts[i - 1]).inDays);
    }

    final isIrregular = historicalLengths.isNotEmpty &&
        (historicalLengths
                    .map((l) => (l - defaultCycleLengthDays).abs())
                    .reduce((a, b) => a + b) /
                historicalLengths.length >
            4);

    // 2. Scan logs of current cycle for ovulation events
    DateTime? detectedOvulationDate;
    final currentCycleLogs = sortedLogs
        .where((l) => !l.logDate.isBefore(currentCycleStart))
        .toList();

    // Check for positive LH strip test
    final lhPositiveLog = currentCycleLogs.firstWhere(
      (l) => l.positiveLhTest == true,
      orElse: () => MenstrualSymptomLog(
          logDate: DateTime(1970),
          hasMenstrualFlow: false,
          physicalSymptoms: []),
    );
    if (lhPositiveLog.logDate.year != 1970) {
      detectedOvulationDate = lhPositiveLog.logDate
          .add(const Duration(days: 1)); // Ovulation roughly 24h post-LH surge
    }

    // If no LH test, check for basal body temperature (BBT) shift: sustained rise of 0.2°C - 0.5°C
    if (detectedOvulationDate == null && currentCycleLogs.length >= 3) {
      for (int i = 2; i < currentCycleLogs.length; i++) {
        final t0 = currentCycleLogs[i - 2].basalBodyTemperatureCelsius;
        final t1 = currentCycleLogs[i - 1].basalBodyTemperatureCelsius;
        final t2 = currentCycleLogs[i].basalBodyTemperatureCelsius;
        if (t0 != null && t1 != null && t2 != null) {
          if (t1 - t0 >= 0.2 && t2 - t0 >= 0.2) {
            detectedOvulationDate =
                currentCycleLogs[i - 1].logDate; // Temp shifted on day i-1
            break;
          }
        }
      }
    }

    // Fallback: If BBT and LH are missing, run continuous resting heart rate (RHR) and symptom tracking
    if (detectedOvulationDate == null && currentCycleLogs.isNotEmpty) {
      final follicularRhrLogs = currentCycleLogs
          .where((l) =>
              l.logDate.difference(currentCycleStart).inDays <= 10 &&
              l.restingHeartRateBpm != null)
          .toList();

      if (follicularRhrLogs.isNotEmpty) {
        final double follicularBaselineRhr = follicularRhrLogs
                .map((l) => l.restingHeartRateBpm!)
                .reduce((a, b) => a + b) /
            follicularRhrLogs.length;

        for (int i = 0; i < currentCycleLogs.length; i++) {
          final log = currentCycleLogs[i];
          final rhr = log.restingHeartRateBpm;

          if (rhr != null && rhr - follicularBaselineRhr >= 2.0) {
            final hasSubjectiveSymptoms =
                log.physicalSymptoms.contains('egg_white_mucus') ||
                    log.physicalSymptoms.contains('ovulation_pain') ||
                    log.physicalSymptoms.contains('mittelschmerz');

            if (hasSubjectiveSymptoms &&
                log.logDate.difference(currentCycleStart).inDays > 10) {
              detectedOvulationDate = log.logDate;
              break;
            }
          }
        }
      }
    }

    // 3. Determine current phase dynamically
    CyclePhase phase;
    int adjustedCycleLength = defaultCycleLengthDays;

    if (detectedOvulationDate != null) {
      final daysPostOvulation =
          DateTime.now().difference(detectedOvulationDate).inDays;
      if (daysPostOvulation < 0) {
        phase = CyclePhase.ovulatory;
      } else if (daysPostOvulation <= 14) {
        phase = CyclePhase.luteal;
      } else {
        phase = CyclePhase.menstrual;
      }
      adjustedCycleLength =
          detectedOvulationDate.difference(currentCycleStart).inDays + 14;
    } else {
      if (isIrregular) {
        final avgLength = historicalLengths.isEmpty
            ? defaultCycleLengthDays
            : (historicalLengths.reduce((a, b) => a + b) /
                    historicalLengths.length)
                .round();
        adjustedCycleLength = avgLength;
      }

      if (daysInCurrentCycle <= 5) {
        phase = CyclePhase.menstrual;
      } else if (daysInCurrentCycle <= (adjustedCycleLength - 16)) {
        phase = CyclePhase.follicular;
      } else if (daysInCurrentCycle <= (adjustedCycleLength - 14)) {
        phase = CyclePhase.ovulatory;
      } else {
        phase = CyclePhase.luteal;
      }
    }

    return DynamicCycleState(
      currentCycleDay: daysInCurrentCycle,
      projectedCycleLength: adjustedCycleLength,
      currentPhase: phase,
      isIrregularDetected: isIrregular,
    );
  }
}
