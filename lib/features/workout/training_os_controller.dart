/// §P6-E Training OS Controller
///
/// Riverpod Notifier wiring MobilityDiagnosisEngine, LocalReadinessScorer,
/// and RecoveryAwareOverloadEngine into unified UserScores state.
library;

import 'package:fitkarma/features/workout/recovery_aware_overload_engine.dart';
import 'package:fitkarma/features/workout/training_os_engine.dart';
import 'package:fitkarma/features/workout/user_scores.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Providers for engines
// ─────────────────────────────────────────────────────────────────────────────

final mobilityDiagnosisEngineProvider = Provider<MobilityDiagnosisEngine>(
  (_) => const MobilityDiagnosisEngine(),
);

final adaptiveExerciseSelectorProvider = Provider<AdaptiveExerciseSelector>(
  (_) => const AdaptiveExerciseSelector(),
);

final localReadinessScorerProvider = Provider<LocalReadinessScorer>(
  (_) => const LocalReadinessScorer(),
);

final recoveryAwareOverloadEngineProvider = Provider<RecoveryAwareOverloadEngine>(
  (_) => const RecoveryAwareOverloadEngine(),
);

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class TrainingOsNotifier extends Notifier<UserScores> {
  @override
  UserScores build() => const UserScores();

  /// Evaluates readiness from perceived soreness and a mobility report,
  /// updating [UserScores.upperBodyReadiness], [lowerBodyReadiness],
  /// [overallReadiness], [mobilityIndex], and [daySwapSuggestion].
  void evaluateReadiness({
    required double upperSoreness,
    required double lowerSoreness,
    required MobilityReport mobilityReport,
  }) {
    final scorer = ref.read(localReadinessScorerProvider);
    final readiness = scorer.evaluate(
      upperSoreness: upperSoreness,
      lowerSoreness: lowerSoreness,
      mobilityIndex: mobilityReport.mobilityIndex,
    );

    state = state.copyWith(
      upperBodyReadiness: readiness.upperBodyReadiness,
      lowerBodyReadiness: readiness.lowerBodyReadiness,
      overallReadiness: readiness.overallReadiness,
      mobilityIndex: mobilityReport.mobilityIndex,
      daySwapSuggestion: readiness.daySwapSuggestion,
    );
  }

  /// Returns an overload suggestion from the RecoveryAwareOverloadEngine.
  OverloadSuggestion getOverloadSuggestion({
    required String exerciseId,
    required double baseWeightKg,
    required double recoveryCapacity,
    required double sleepDebtHours,
  }) {
    final engine = ref.read(recoveryAwareOverloadEngineProvider);
    return engine.suggest(
      exerciseId: exerciseId,
      baseTargetWeightKg: baseWeightKg,
      recoveryCapacity: recoveryCapacity,
      sleepDebtHours: sleepDebtHours,
    );
  }

  /// Returns an adaptive exercise alternative via AdaptiveExerciseSelector.
  String selectAdaptiveExercise(
    String primaryExerciseId,
    List<String> identifiedLimitations,
  ) {
    final selector = ref.read(adaptiveExerciseSelectorProvider);
    return selector.selectAlternative(primaryExerciseId, identifiedLimitations);
  }
}

final trainingOsProvider =
    NotifierProvider<TrainingOsNotifier, UserScores>(
  TrainingOsNotifier.new,
);
