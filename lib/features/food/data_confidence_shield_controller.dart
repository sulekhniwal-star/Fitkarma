/// §P5-O Data Confidence Shield Controller
///
/// Riverpod Notifier evaluating 7-day rolling nutrition reliability scores and managing
/// Data Confidence Shield lockout states.
library;

import 'package:fitkarma/features/food/data_confidence_shield_engine.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

class DataConfidenceShieldState {
  const DataConfidenceShieldState({
    required this.result,
    this.past7DayLogs = const [],
    this.weightPlateauWeeks = 0.0,
  });

  final DataConfidenceShieldResult result;
  final List<DailyLogQualityRecord> past7DayLogs;
  final double weightPlateauWeeks;

  DataConfidenceShieldState copyWith({
    DataConfidenceShieldResult? result,
    List<DailyLogQualityRecord>? past7DayLogs,
    double? weightPlateauWeeks,
  }) {
    return DataConfidenceShieldState(
      result: result ?? this.result,
      past7DayLogs: past7DayLogs ?? this.past7DayLogs,
      weightPlateauWeeks: weightPlateauWeeks ?? this.weightPlateauWeeks,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier & Provider
// ─────────────────────────────────────────────────────────────────────────────

final dataConfidenceShieldEngineProvider = Provider<DataConfidenceShieldEngine>(
  (ref) {
    return const DataConfidenceShieldEngine();
  },
);

class DataConfidenceShieldNotifier extends Notifier<DataConfidenceShieldState> {
  @override
  DataConfidenceShieldState build() {
    final engine = ref.watch(dataConfidenceShieldEngineProvider);
    final foodState = ref.watch(foodProvider);

    // Construct 7 days mock history combined with today's logged items
    final todayCount = foodState.loggedItems.length;
    final todayProteinMet =
        foodState.loggedItems.fold(0, (s, i) => s + i.protein) >=
        foodState.proteinTarget;

    final now = DateTime.now();
    final logs = <DailyLogQualityRecord>[
      DailyLogQualityRecord(
        date: now,
        mealsLoggedCount: todayCount,
        wasProteinTargetMet: todayProteinMet,
        wasWaterTargetMet: true,
      ),
      for (int i = 1; i < 7; i++)
        DailyLogQualityRecord(
          date: now.subtract(Duration(days: i)),
          mealsLoggedCount: i % 2 == 0 ? 3 : 2,
          wasProteinTargetMet: i % 2 == 0,
          wasWaterTargetMet: true,
        ),
    ];

    final result = engine.evaluateLoggingQuality(
      past7DayLogs: logs,
      weightPlateauWeeks: 0.0,
    );

    return DataConfidenceShieldState(result: result, past7DayLogs: logs);
  }

  /// Sets weight plateau weeks duration and re-evaluates shield message.
  void setPlateauDuration(double weeks) {
    final engine = ref.read(dataConfidenceShieldEngineProvider);
    final result = engine.evaluateLoggingQuality(
      past7DayLogs: state.past7DayLogs,
      weightPlateauWeeks: weeks,
    );

    state = state.copyWith(weightPlateauWeeks: weeks, result: result);
  }

  /// Explicitly updates rolling 7-day log quality records for testing.
  void updateLogs(List<DailyLogQualityRecord> logs) {
    final engine = ref.read(dataConfidenceShieldEngineProvider);
    final result = engine.evaluateLoggingQuality(
      past7DayLogs: logs,
      weightPlateauWeeks: state.weightPlateauWeeks,
    );

    state = state.copyWith(past7DayLogs: logs, result: result);
  }
}

final dataConfidenceShieldProvider =
    NotifierProvider<DataConfidenceShieldNotifier, DataConfidenceShieldState>(
      DataConfidenceShieldNotifier.new,
    );
