/// §P5-L Adaptive Hunger Controller
///
/// Riverpod Notifier managing subjective hunger & craving logs, stress level correlation,
/// and real-time proactive intervention evaluation.
library;

import 'package:fitkarma/features/food/adaptive_hunger_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class HungerCravingState {
  const HungerCravingState({
    this.logs = const [],
    this.currentStressLevel = 2.0,
    this.latestHungerScore = 2,
    this.activeIntervention = const HungerIntervention(shouldTriggerNudge: false),
  });

  final List<HungerCravingLog> logs;
  final double currentStressLevel;
  final int latestHungerScore;
  final HungerIntervention activeIntervention;

  HungerCravingState copyWith({
    List<HungerCravingLog>? logs,
    double? currentStressLevel,
    int? latestHungerScore,
    HungerIntervention? activeIntervention,
  }) {
    return HungerCravingState(
      logs: logs ?? this.logs,
      currentStressLevel: currentStressLevel ?? this.currentStressLevel,
      latestHungerScore: latestHungerScore ?? this.latestHungerScore,
      activeIntervention: activeIntervention ?? this.activeIntervention,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final adaptiveHungerEngineProvider = Provider<AdaptiveHungerEngine>((ref) {
  return const AdaptiveHungerEngine();
});

class HungerCravingNotifier extends Notifier<HungerCravingState> {
  @override
  HungerCravingState build() {
    return const HungerCravingState();
  }

  /// Logs a subjective hunger score and active craving type.
  void logHungerAndCraving({
    required int hungerScore,
    CravingType? cravingType,
    double? stressLevel,
    String? notes,
  }) {
    final updatedStress = stressLevel ?? state.currentStressLevel;
    final newLog = HungerCravingLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      loggedAt: DateTime.now(),
      hungerScore: hungerScore,
      cravingType: cravingType,
      stressLevel: updatedStress,
      notes: notes,
    );

    final newLogs = List<HungerCravingLog>.from(state.logs)..add(newLog);

    final engine = ref.read(adaptiveHungerEngineProvider);
    final intervention = engine.evaluateCravingRisk(
      cravingLogs: newLogs,
      currentStressLevel: updatedStress,
      currentTime: DateTime.now(),
    );

    state = state.copyWith(
      logs: newLogs,
      currentStressLevel: updatedStress,
      latestHungerScore: hungerScore,
      activeIntervention: intervention,
    );
  }

  /// Manually updates user stress level (1.0 to 5.0) and re-evaluates intervention risk.
  void setStressLevel(double stressLevel) {
    final engine = ref.read(adaptiveHungerEngineProvider);
    final intervention = engine.evaluateCravingRisk(
      cravingLogs: state.logs,
      currentStressLevel: stressLevel,
      currentTime: DateTime.now(),
    );

    state = state.copyWith(
      currentStressLevel: stressLevel,
      activeIntervention: intervention,
    );
  }

  /// Explicitly triggers an intervention evaluation for a simulated or current date/time.
  void evaluateInterventionForTime(DateTime simulatedTime) {
    final engine = ref.read(adaptiveHungerEngineProvider);
    final intervention = engine.evaluateCravingRisk(
      cravingLogs: state.logs,
      currentStressLevel: state.currentStressLevel,
      currentTime: simulatedTime,
    );

    state = state.copyWith(activeIntervention: intervention);
  }
}

final hungerCravingProvider =
    NotifierProvider<HungerCravingNotifier, HungerCravingState>(
  HungerCravingNotifier.new,
);
