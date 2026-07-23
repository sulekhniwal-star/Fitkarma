/// §P5-G Nutrition Periodization Controller
///
/// Riverpod Notifier managing current periodization phase, start dates,
/// progression evaluations, and Drift database persistence (`Users.nutritionPeriodizationPhase`).
library;

import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/nutrition_periodization_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class PeriodizationState {
  const PeriodizationState({
    this.currentPhase = PeriodizationPhase.maintenance,
    this.phaseStartedAt,
    this.status,
    this.macroTargets,
    this.tdee = 2200.0,
    this.weightKg = 70.0,
  });

  final PeriodizationPhase currentPhase;
  final DateTime? phaseStartedAt;
  final PeriodizationStatus? status;
  final PeriodizedMacroTargets? macroTargets;
  final double tdee;
  final double weightKg;

  PeriodizationState copyWith({
    PeriodizationPhase? currentPhase,
    DateTime? phaseStartedAt,
    PeriodizationStatus? status,
    PeriodizedMacroTargets? macroTargets,
    double? tdee,
    double? weightKg,
  }) {
    return PeriodizationState(
      currentPhase: currentPhase ?? this.currentPhase,
      phaseStartedAt: phaseStartedAt ?? this.phaseStartedAt,
      status: status ?? this.status,
      macroTargets: macroTargets ?? this.macroTargets,
      tdee: tdee ?? this.tdee,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final nutritionPeriodizationEngineProvider =
    Provider<NutritionPeriodizationEngine>((ref) {
      return const NutritionPeriodizationEngine();
    });

class PeriodizationNotifier extends Notifier<PeriodizationState> {
  static const String _userId = 'local_user';

  @override
  PeriodizationState build() {
    final engine = ref.watch(nutritionPeriodizationEngineProvider);
    const initialPhase = PeriodizationPhase.maintenance;
    final now = DateTime.now();

    final initialTargets = engine.calculateMacroTargets(
      phase: initialPhase,
      tdee: 2200.0,
      weightKg: 70.0,
    );

    _loadUserPeriodizationState();

    return PeriodizationState(
      currentPhase: initialPhase,
      phaseStartedAt: now,
      macroTargets: initialTargets,
    );
  }

  /// Manually or automatically transitions to [newPhase], updating state and persisting to Drift.
  Future<void> transitionToPhase(PeriodizationPhase newPhase) async {
    final engine = ref.read(nutritionPeriodizationEngineProvider);
    final now = DateTime.now();

    final newTargets = engine.calculateMacroTargets(
      phase: newPhase,
      tdee: state.tdee,
      weightKg: state.weightKg,
    );

    final status = engine.checkPhaseProgression(
      currentPhase: newPhase,
      phaseStartedAt: now,
      recentWeightLogsKg: const [],
    );

    state = state.copyWith(
      currentPhase: newPhase,
      phaseStartedAt: now,
      macroTargets: newTargets,
      status: status,
    );

    // Persist to Drift Users table
    try {
      final db = ref.read(databaseProvider);
      await db.updateUserProfile(
        userId: _userId,
        nutritionPeriodizationPhase: newPhase.name,
        periodizationPhaseStartedAt: now,
      );
    } catch (_) {
      // Offline fallback
    }
  }

  /// Evaluates phase progression rules against recent weight history.
  void evaluateProgression(List<double> recentWeightLogsKg) {
    final engine = ref.read(nutritionPeriodizationEngineProvider);
    final status = engine.checkPhaseProgression(
      currentPhase: state.currentPhase,
      phaseStartedAt: state.phaseStartedAt,
      recentWeightLogsKg: recentWeightLogsKg,
    );

    state = state.copyWith(status: status);

    // Auto-transition if rule action is required (e.g. 8-week deficit timeout or plateau)
    if (status.actionRequired && status.nextPhase != state.currentPhase) {
      transitionToPhase(status.nextPhase);
    }
  }

  /// Updates user TDEE and body weight parameters and recalculates target macros.
  void updateUserMetrics({double? tdee, double? weightKg}) {
    final updatedTdee = tdee ?? state.tdee;
    final updatedWeight = weightKg ?? state.weightKg;

    final engine = ref.read(nutritionPeriodizationEngineProvider);
    final newTargets = engine.calculateMacroTargets(
      phase: state.currentPhase,
      tdee: updatedTdee,
      weightKg: updatedWeight,
    );

    state = state.copyWith(
      tdee: updatedTdee,
      weightKg: updatedWeight,
      macroTargets: newTargets,
    );
  }

  Future<void> _loadUserPeriodizationState() async {
    try {
      final db = ref.read(databaseProvider);
      final user = await (db.select(
        db.users,
      )..where((t) => t.id.equals(_userId))).getSingleOrNull();

      if (user != null && user.nutritionPeriodizationPhase.isNotEmpty) {
        final phaseName = user.nutritionPeriodizationPhase;
        final phase = PeriodizationPhase.values.firstWhere(
          (p) => p.name == phaseName,
          orElse: () => PeriodizationPhase.maintenance,
        );

        final startDate = user.periodizationPhaseStartedAt ?? DateTime.now();

        final engine = ref.read(nutritionPeriodizationEngineProvider);
        final targets = engine.calculateMacroTargets(
          phase: phase,
          tdee: state.tdee,
          weightKg: user.weight ?? state.weightKg,
        );

        state = state.copyWith(
          currentPhase: phase,
          phaseStartedAt: startDate,
          macroTargets: targets,
          weightKg: user.weight ?? state.weightKg,
        );
      }
    } catch (_) {
      // Fallback to default build state
    }
  }
}

final periodizationProvider =
    NotifierProvider<PeriodizationNotifier, PeriodizationState>(
      PeriodizationNotifier.new,
    );
