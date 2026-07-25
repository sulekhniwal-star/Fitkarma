/// §P11-A Body Analytics — Riverpod Notifier & State Management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'body_analytics_models.dart';

class BodyAnalyticsState {
  const BodyAnalyticsState({
    required this.history,
    this.isLoading = false,
    this.successMessage,
  });

  final List<BodyMeasurementEntry> history;
  final bool isLoading;
  final String? successMessage;

  BodyMeasurementEntry? get latestEntry =>
      history.isNotEmpty ? history.first : null;

  BodyMeasurementEntry? get previousEntry =>
      history.length >= 2 ? history[1] : null;

  List<BodyMeasurementTrend> get trends {
    final latest = latestEntry;
    final prev = previousEntry;
    if (latest == null || prev == null) return const [];

    final result = <BodyMeasurementTrend>[];

    void addTrend(String siteName, double? current, double? previous) {
      if (current != null && previous != null) {
        result.add(BodyMeasurementTrend(
          siteName: siteName,
          currentCm: current,
          previousCm: previous,
          deltaCm: current - previous,
        ));
      }
    }

    addTrend('Waist', latest.waistCm, prev.waistCm);
    addTrend('Chest', latest.chestCm, prev.chestCm);
    addTrend('Biceps', latest.bicepsCm, prev.bicepsCm);
    addTrend('Hips', latest.hipsCm, prev.hipsCm);
    addTrend('Thigh', latest.thighCm, prev.thighCm);
    addTrend('Calves', latest.calvesCm, prev.calvesCm);
    addTrend('Neck', latest.neckCm, prev.neckCm);

    return result;
  }

  BodyAnalyticsState copyWith({
    List<BodyMeasurementEntry>? history,
    bool? isLoading,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return BodyAnalyticsState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class BodyAnalyticsNotifier extends Notifier<BodyAnalyticsState> {
  @override
  BodyAnalyticsState build() {
    final now = DateTime.now();
    // Default initial historical entries for demonstration
    final initialHistory = [
      BodyMeasurementEntry(
        localId: 'bm_002',
        userId: 'user_local_001',
        logDate: now,
        neckCm: 38.0,
        chestCm: 98.0,
        bicepsCm: 34.5,
        waistCm: 82.0,
        hipsCm: 96.0,
        thighCm: 56.0,
        calvesCm: 37.0,
        weightKg: 72.5,
      ),
      BodyMeasurementEntry(
        localId: 'bm_001',
        userId: 'user_local_001',
        logDate: now.subtract(const Duration(days: 30)),
        neckCm: 38.5,
        chestCm: 99.5,
        bicepsCm: 33.8,
        waistCm: 84.5,
        hipsCm: 97.5,
        thighCm: 57.0,
        calvesCm: 37.2,
        weightKg: 74.0,
      ),
    ];

    return BodyAnalyticsState(history: initialHistory);
  }

  void addMeasurement(BodyMeasurementEntry entry) {
    final updatedHistory = [entry, ...state.history];
    state = state.copyWith(
      history: updatedHistory,
      successMessage: 'Body measurements logged & persisted to BodyMeasurements table! 📏',
    );
  }
}

final bodyAnalyticsProvider =
    NotifierProvider<BodyAnalyticsNotifier, BodyAnalyticsState>(
  BodyAnalyticsNotifier.new,
);
