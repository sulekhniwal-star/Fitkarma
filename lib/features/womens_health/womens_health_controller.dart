import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/database/app_database.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Domain Models (§P1-H)
// ──────────────────────────────────────────────────────────────────────────────

enum CyclePhase { menstrual, follicular, ovulatory, luteal }

class WorkoutAdaptation {
  const WorkoutAdaptation({
    required this.intensityModifier,
    required this.preferredTypes,
    required this.avoidTypes,
    this.nutritionNote,
    required this.rationale,
  });

  final double intensityModifier;
  final List<String> preferredTypes;
  final List<String> avoidTypes;
  final String? nutritionNote;
  final String rationale;
}

class CycleAwareTrainingAdapter {
  const CycleAwareTrainingAdapter();

  WorkoutAdaptation adaptForCyclePhase(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => const WorkoutAdaptation(
          intensityModifier: 0.70,
          preferredTypes: ['Yoga', 'Walking', 'Light Pilates'],
          avoidTypes: ['HIIT', 'Heavy Lifting'],
          rationale: 'Energy and iron levels are lower. Gentle movement reduces cramps and improves mood.',
        ),
      CyclePhase.follicular => const WorkoutAdaptation(
          intensityModifier: 1.10,
          preferredTypes: ['Strength Training', 'HIIT', 'Running'],
          avoidTypes: [],
          rationale: 'Estrogen rising — best phase for high-intensity training and new personal records.',
        ),
      CyclePhase.ovulatory => const WorkoutAdaptation(
          intensityModifier: 1.05,
          preferredTypes: ['Strength', 'Cardio', 'Sports'],
          avoidTypes: [],
          rationale: 'Peak energy and coordination. Optimal for performance-focused sessions.',
        ),
      CyclePhase.luteal => const WorkoutAdaptation(
          intensityModifier: 0.85,
          preferredTypes: ['Moderate Cardio', 'Yoga', 'Strength'],
          avoidTypes: [],
          nutritionNote: 'Cravings increase — add complex carbs (oats, sweet potato) to curb PMS cravings.',
          rationale: 'Progesterone dominates. Body temperature slightly elevated; reduce intensity if fatigued.',
        ),
    };
  }
}

class MenstrualSymptomLogWrapper {
  const MenstrualSymptomLogWrapper({
    required this.logDate,
    required this.hasMenstrualFlow,
    this.basalBodyTemperatureCelsius,
    this.positiveLhTest,
    required this.physicalSymptoms,
    this.restingHeartRateBpm,
    this.heartRateVariabilityMs,
  });

  final DateTime logDate;
  final bool hasMenstrualFlow;
  final double? basalBodyTemperatureCelsius;
  final bool? positiveLhTest;
  final List<String> physicalSymptoms;
  final int? restingHeartRateBpm;
  final double? heartRateVariabilityMs;
}

class DynamicCycleState {
  const DynamicCycleState({
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

  final int currentCycleDay;
  final int projectedCycleLength;
  final CyclePhase currentPhase;
  final bool isIrregularDetected;
}

class DynamicCycleCalibrator {
  const DynamicCycleCalibrator();

  DynamicCycleState recalibratePhase({
    required List<MenstrualSymptomLogWrapper> symptomLogs,
    required int defaultCycleLengthDays,
  }) {
    if (symptomLogs.isEmpty) {
      return DynamicCycleState.defaultCalendar(defaultCycleLengthDays, CyclePhase.follicular);
    }

    final sortedLogs = List<MenstrualSymptomLogWrapper>.from(symptomLogs)
      ..sort((a, b) => a.logDate.compareTo(b.logDate));

    final flowStarts = sortedLogs.where((l) => l.hasMenstrualFlow).map((l) => l.logDate).toList();
    if (flowStarts.isEmpty) {
      return DynamicCycleState.defaultCalendar(defaultCycleLengthDays, CyclePhase.follicular);
    }

    final currentCycleStart = flowStarts.last;
    final daysInCurrentCycle = DateTime.now().difference(currentCycleStart).inDays + 1;

    final historicalLengths = <int>[];
    for (int i = 1; i < flowStarts.length; i++) {
      historicalLengths.add(flowStarts[i].difference(flowStarts[i - 1]).inDays);
    }

    final isIrregular = historicalLengths.isNotEmpty &&
        (historicalLengths.map((l) => (l - defaultCycleLengthDays).abs()).reduce((a, b) => a + b) / historicalLengths.length > 4);

    DateTime? detectedOvulationDate;
    final currentCycleLogs = sortedLogs.where((l) => !l.logDate.isBefore(currentCycleStart)).toList();

    final lhPositiveLog = currentCycleLogs.firstWhere(
      (l) => l.positiveLhTest == true,
      orElse: () => MenstrualSymptomLogWrapper(logDate: DateTime(1970), hasMenstrualFlow: false, physicalSymptoms: []),
    );
    if (lhPositiveLog.logDate.year != 1970) {
      detectedOvulationDate = lhPositiveLog.logDate.add(const Duration(days: 1));
    }

    if (detectedOvulationDate == null && currentCycleLogs.length >= 3) {
      for (int i = 2; i < currentCycleLogs.length; i++) {
        final t0 = currentCycleLogs[i - 2].basalBodyTemperatureCelsius;
        final t1 = currentCycleLogs[i - 1].basalBodyTemperatureCelsius;
        final t2 = currentCycleLogs[i].basalBodyTemperatureCelsius;
        if (t0 != null && t1 != null && t2 != null) {
          if (t1 - t0 >= 0.2 && t2 - t0 >= 0.2) {
            detectedOvulationDate = currentCycleLogs[i - 1].logDate;
            break;
          }
        }
      }
    }

    if (detectedOvulationDate == null && currentCycleLogs.isNotEmpty) {
      final follicularRhrLogs = currentCycleLogs
          .where((l) => l.logDate.difference(currentCycleStart).inDays <= 10 && l.restingHeartRateBpm != null)
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
            final hasSubjectiveSymptoms = log.physicalSymptoms.contains('egg_white_mucus') ||
                log.physicalSymptoms.contains('ovulation_pain') ||
                log.physicalSymptoms.contains('mittelschmerz');

            if (hasSubjectiveSymptoms && log.logDate.difference(currentCycleStart).inDays > 10) {
              detectedOvulationDate = log.logDate;
              break;
            }
          }
        }
      }
    }

    CyclePhase phase;
    int adjustedCycleLength = defaultCycleLengthDays;

    if (detectedOvulationDate != null) {
      final daysPostOvulation = DateTime.now().difference(detectedOvulationDate).inDays;
      if (daysPostOvulation < 0) {
        phase = CyclePhase.ovulatory;
      } else if (daysPostOvulation <= 14) {
        phase = CyclePhase.luteal;
      } else {
        phase = CyclePhase.menstrual;
      }
      adjustedCycleLength = detectedOvulationDate.difference(currentCycleStart).inDays + 14;
    } else {
      if (isIrregular) {
        final avgLength = historicalLengths.isEmpty
            ? defaultCycleLengthDays
            : (historicalLengths.reduce((a, b) => a + b) / historicalLengths.length).round();
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

// ──────────────────────────────────────────────────────────────────────────────
// State
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingWomensHealthState {
  const OnboardingWomensHealthState({
    this.isCycleTrackingEnabled = false,
    this.averageCycleLength = 28,
    this.lastPeriodDate,
    this.isSaving = false,
  });

  final bool isCycleTrackingEnabled;
  final int averageCycleLength;
  final DateTime? lastPeriodDate;
  final bool isSaving;

  OnboardingWomensHealthState copyWith({
    bool? isCycleTrackingEnabled,
    int? averageCycleLength,
    DateTime? lastPeriodDate,
    bool? isSaving,
  }) {
    return OnboardingWomensHealthState(
      isCycleTrackingEnabled: isCycleTrackingEnabled ?? this.isCycleTrackingEnabled,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────────────────────────────────────

class OnboardingWomensHealthNotifier extends Notifier<OnboardingWomensHealthState> {
  @override
  OnboardingWomensHealthState build() => const OnboardingWomensHealthState();

  void setTrackingEnabled(bool enabled) {
    state = state.copyWith(isCycleTrackingEnabled: enabled);
  }

  void setAverageCycleLength(int length) {
    state = state.copyWith(averageCycleLength: length);
  }

  void setLastPeriodDate(DateTime date) {
    state = state.copyWith(lastPeriodDate: date);
  }

  Future<void> saveToDb(AppDatabase db, String userId) async {
    state = state.copyWith(isSaving: true);
    await db.updateUserProfile(
      userId: userId,
      isCycleTrackingEnabled: state.isCycleTrackingEnabled,
      averageCycleLength: state.isCycleTrackingEnabled ? state.averageCycleLength : null,
      lastPeriodDate: state.isCycleTrackingEnabled ? state.lastPeriodDate : null,
    );
    state = state.copyWith(isSaving: false);
  }
}

final onboardingWomensHealthProvider =
    NotifierProvider<OnboardingWomensHealthNotifier, OnboardingWomensHealthState>(
  OnboardingWomensHealthNotifier.new,
);
