import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/device_reliability_engine.dart';
import '../models/wearable_sync_merger.dart';

// ── Wearable Comparison State ─────────────────────────────────────────────────

class WearableComparisonState {
  final WearableSource activeSource;
  final double rawHrvMs;
  final double rawHrBpm;
  final double userBaselineHrvMs;
  final List<WearableDataPoint> localHistory;
  final WearableReadingResult readingResult;
  final String syncSummary;
  final bool isSyncing;

  const WearableComparisonState({
    required this.activeSource,
    required this.rawHrvMs,
    required this.rawHrBpm,
    required this.userBaselineHrvMs,
    required this.localHistory,
    required this.readingResult,
    required this.syncSummary,
    this.isSyncing = false,
  });

  WearableComparisonState copyWith({
    WearableSource? activeSource,
    double? rawHrvMs,
    double? rawHrBpm,
    double? userBaselineHrvMs,
    List<WearableDataPoint>? localHistory,
    WearableReadingResult? readingResult,
    String? syncSummary,
    bool? isSyncing,
  }) {
    return WearableComparisonState(
      activeSource: activeSource ?? this.activeSource,
      rawHrvMs: rawHrvMs ?? this.rawHrvMs,
      rawHrBpm: rawHrBpm ?? this.rawHrBpm,
      userBaselineHrvMs: userBaselineHrvMs ?? this.userBaselineHrvMs,
      localHistory: localHistory ?? this.localHistory,
      readingResult: readingResult ?? this.readingResult,
      syncSummary: syncSummary ?? this.syncSummary,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

// ── Wearable Provider / Notifier ───────────────────────────────────────────────

class WearableComparisonNotifier extends StateNotifier<WearableComparisonState> {
  final DeviceReliabilityEngine _reliabilityEngine;
  final WearableSyncMerger _syncMerger;

  WearableComparisonNotifier(this._reliabilityEngine, this._syncMerger)
      : super(_buildInitialState(_reliabilityEngine));

  static WearableComparisonState _buildInitialState(DeviceReliabilityEngine engine) {
    const source = WearableSource.whoop;
    const rawHrv = 58.0;
    const rawHr = 62.0;
    const baselineHrv = 62.0;

    final result = engine.applyConfidence(
      source: source,
      rawHRV: rawHrv,
      rawHR: rawHr,
    );

    return WearableComparisonState(
      activeSource: source,
      rawHrvMs: rawHrv,
      rawHrBpm: rawHr,
      userBaselineHrvMs: baselineHrv,
      localHistory: const [],
      readingResult: result,
      syncSummary: 'Initial wearable sync established with WHOOP 4.0.',
    );
  }

  /// Switch active connected wearable source
  void selectSource(WearableSource newSource) {
    final result = _reliabilityEngine.applyConfidence(
      source: newSource,
      rawHRV: state.rawHrvMs,
      rawHR: state.rawHrBpm,
    );

    state = state.copyWith(
      activeSource: newSource,
      readingResult: result,
      syncSummary: 'Switched wearable data source to ${newSource.displayName}.',
    );
  }

  /// Trigger late-sync merge job
  Future<void> performLateSyncMerge(List<WearableDataPoint> incomingStream) async {
    state = state.copyWith(isSyncing: true);
    await Future.delayed(const Duration(milliseconds: 200));

    final mergeResult = _syncMerger.mergeDataStreams(
      localHistory: state.localHistory,
      incomingStream: incomingStream,
    );

    state = state.copyWith(
      localHistory: mergeResult.mergedPoints,
      syncSummary: mergeResult.summaryMessage,
      isSyncing: false,
    );
  }
}

final wearableComparisonProvider =
    StateNotifierProvider<WearableComparisonNotifier, WearableComparisonState>(
  (_) => WearableComparisonNotifier(
    const DeviceReliabilityEngine(),
    const WearableSyncMerger(),
  ),
);
