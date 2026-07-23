import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/brain/readiness_engine.dart';

// Soreness mapping definitions
enum MuscleGroup {
  shoulders,
  chest,
  abs,
  quads,
  arms,
  lowerBack,
  glutes,
  hamstrings,
}

enum SorenessSeverity { none, mild, moderate, severe }

class SorenessState {
  final Map<MuscleGroup, SorenessSeverity> sorenessMap;
  const SorenessState({required this.sorenessMap});

  factory SorenessState.initial() => SorenessState(
    sorenessMap: {for (var m in MuscleGroup.values) m: SorenessSeverity.none},
  );

  // Compute composite score (1 to 5 scale) for Readiness Engine Ingestion
  int get compositeSorenessValue {
    int totalPoints = 0;
    for (final severity in sorenessMap.values) {
      switch (severity) {
        case SorenessSeverity.none:
          break;
        case SorenessSeverity.mild:
          totalPoints += 1;
          break;
        case SorenessSeverity.moderate:
          totalPoints += 2;
          break;
        case SorenessSeverity.severe:
          totalPoints += 3;
          break;
      }
    }
    if (totalPoints == 0) return 1;
    if (totalPoints <= 2) return 2;
    if (totalPoints <= 5) return 3;
    if (totalPoints <= 8) return 4;
    return 5;
  }
}

class RecoveryLogState {
  final SorenessState soreness;
  final int sleepQuality;
  final int sleepDurationMin;
  final int stressLevel;
  final int energyLevel;
  final int readinessScore;
  final double? restingHR;
  final double? hrv;
  final double? baselineHR;
  final double? baselineHRV;

  const RecoveryLogState({
    this.soreness = const SorenessState(sorenessMap: {}),
    this.sleepQuality = 3,
    this.sleepDurationMin = 480,
    this.stressLevel = 1,
    this.energyLevel = 3,
    this.readinessScore = 100,
    this.restingHR,
    this.hrv,
    this.baselineHR,
    this.baselineHRV,
  });

  RecoveryLogState copyWith({
    SorenessState? soreness,
    int? sleepQuality,
    int? sleepDurationMin,
    int? stressLevel,
    int? energyLevel,
    int? readinessScore,
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    return RecoveryLogState(
      soreness: soreness ?? this.soreness,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepDurationMin: sleepDurationMin ?? this.sleepDurationMin,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      readinessScore: readinessScore ?? this.readinessScore,
      restingHR: restingHR ?? this.restingHR,
      hrv: hrv ?? this.hrv,
      baselineHR: baselineHR ?? this.baselineHR,
      baselineHRV: baselineHRV ?? this.baselineHRV,
    );
  }
}

class RecoveryLogNotifier extends Notifier<RecoveryLogState> {
  @override
  RecoveryLogState build() {
    // Initial state with default empty/neutral values
    return RecoveryLogState(
      soreness: SorenessState.initial(),
      sleepQuality: 3,
      sleepDurationMin: 480,
      stressLevel: 1,
      energyLevel: 3,
      readinessScore: 100,
    );
  }

  void updateSoreness(MuscleGroup muscle, SorenessSeverity severity) {
    final updatedMap = Map<MuscleGroup, SorenessSeverity>.from(
      state.soreness.sorenessMap,
    )..[muscle] = severity;
    state = state.copyWith(soreness: SorenessState(sorenessMap: updatedMap));
    _recalculateReadiness();
  }

  void setCheckInResponses({
    required int sleepQuality,
    required int sleepDurationMin,
    required int stressLevel,
    required int energyLevel,
  }) {
    state = state.copyWith(
      sleepQuality: sleepQuality,
      sleepDurationMin: sleepDurationMin,
      stressLevel: stressLevel,
      energyLevel: energyLevel,
    );
    _recalculateReadiness();
  }

  void updateBiometrics({
    double? restingHR,
    double? hrv,
    double? baselineHR,
    double? baselineHRV,
  }) {
    state = state.copyWith(
      restingHR: restingHR,
      hrv: hrv,
      baselineHR: baselineHR,
      baselineHRV: baselineHRV,
    );
    _recalculateReadiness();
  }

  void _recalculateReadiness() {
    final calculator = ReadinessScoreCalculator();
    final result = calculator.calculate(
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

  String _determineConfidenceTier() {
    if (state.restingHR != null && state.hrv != null) {
      return 'premium';
    } else if (state.restingHR != null) {
      return 'enhanced';
    } else {
      return 'basic';
    }
  }

  String _serializeSorenessRegions() {
    final active = state.soreness.sorenessMap.entries
        .where((e) => e.value != SorenessSeverity.none)
        .map((e) => '${e.key.name}:${e.value.name}')
        .toList();
    return active.join(',');
  }

  Future<void> commitLog(AppDatabase db) async {
    final localId = 'recovery_${DateTime.now().millisecondsSinceEpoch}';
    final userId = 'onboarding_user';
    final logDate = DateTime.now();

    final confidenceTierStr = _determineConfidenceTier();

    await db.saveRecoveryLog(
      RecoveryLogsCompanion.insert(
        localId: localId,
        userId: userId,
        logDate: logDate,
        readinessScore: state.readinessScore,
        confidenceTier: confidenceTierStr,
        sleepQuality: state.sleepQuality,
        sorenessLevel: state.soreness.compositeSorenessValue,
        stressLevel: state.stressLevel,
        energyLevel: state.energyLevel,
        restingHR: Value(state.restingHR),
        hrv: Value(state.hrv),
        sorenessRegions: _serializeSorenessRegions(),
        prescribedActionsJson: '[]',
        recoveryDriversJson: '{}',
        syncStatus: 'pending',
        createdAt: DateTime.now(),
      ),
    );
  }
}

final recoveryLogProvider =
    NotifierProvider<RecoveryLogNotifier, RecoveryLogState>(
      RecoveryLogNotifier.new,
    );
