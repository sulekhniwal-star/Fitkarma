import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/readiness_engine.dart';
import '../models/soreness_models.dart';

class RecoveryLogState {
  final SorenessState soreness;
  final int sleepQuality;
  final int sleepDurationMin;
  final int stressLevel;
  final int readinessScore;
  final double restingHR;
  final double hrv;
  final double baselineHR;
  final double baselineHRV;
  final bool isCommitted;

  const RecoveryLogState({
    this.soreness = const SorenessState(),
    this.sleepQuality = 4,
    this.sleepDurationMin = 465, // 7h 45m
    this.stressLevel = 1,
    this.readinessScore = 85,
    this.restingHR = 58.0,
    this.hrv = 62.0,
    this.baselineHR = 60.0,
    this.baselineHRV = 60.0,
    this.isCommitted = false,
  });

  RecoveryLogState copyWith({
    SorenessState? soreness,
    int? sleepQuality,
    int? sleepDurationMin,
    int? stressLevel,
    int? readinessScore,
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
    bool? isCommitted,
  }) {
    return RecoveryLogState(
      soreness: soreness ?? this.soreness,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepDurationMin: sleepDurationMin ?? this.sleepDurationMin,
      stressLevel: stressLevel ?? this.stressLevel,
      readinessScore: readinessScore ?? this.readinessScore,
      restingHR: restingHR ?? this.restingHR,
      hrv: hrv ?? this.hrv,
      baselineHR: baselineHR ?? this.baselineHR,
      baselineHRV: baselineHRV ?? this.baselineHRV,
      isCommitted: isCommitted ?? this.isCommitted,
    );
  }
}

class RecoveryLogNotifier extends StateNotifier<RecoveryLogState> {
  final ReadinessScoreCalculator _calculator;

  RecoveryLogNotifier({ReadinessScoreCalculator calculator = const ReadinessScoreCalculator()})
      : _calculator = calculator,
        super(const RecoveryLogState()) {
    _recalculateReadiness();
  }

  void updateSoreness(MuscleGroup muscle, SorenessSeverity severity) {
    final updatedMap = Map<MuscleGroup, SorenessSeverity>.from(state.soreness.sorenessMap)
      ..[muscle] = severity;
    state = state.copyWith(soreness: SorenessState(sorenessMap: updatedMap));
    _recalculateReadiness();
  }

  void toggleMuscleSoreness(MuscleGroup muscle) {
    final current = state.soreness.sorenessMap[muscle] ?? SorenessSeverity.none;
    updateSoreness(muscle, current.next());
  }

  void setCheckInResponses({
    required int sleepQuality,
    required int sleepDurationMin,
    required int stressLevel,
  }) {
    state = state.copyWith(
      sleepQuality: sleepQuality,
      sleepDurationMin: sleepDurationMin,
      stressLevel: stressLevel,
    );
    _recalculateReadiness();
  }

  void _recalculateReadiness() {
    final result = _calculator.calculate(
      sleepQuality: state.sleepQuality,
      sleepDurationMin: state.sleepDurationMin,
      sorenessLevel: state.soreness.compositeSorenessValue,
      stressLevel: state.stressLevel,
      restingHR: state.restingHR,
      hrv: state.hrv,
      baselineHR: state.baselineHR,
      baselineHRV: state.baselineHRV,
    );
    state = state.copyWith(readinessScore: result.score);
  }

  void commitLog() {
    state = state.copyWith(isCommitted: true);
  }
}

final recoveryLogProvider =
    StateNotifierProvider<RecoveryLogNotifier, RecoveryLogState>((ref) {
  return RecoveryLogNotifier();
});
