import 'device_reliability_engine.dart';

// ── Metric Type for Wearable Merging ───────────────────────────────────────────

enum MetricType { cumulativeSteps, pointInTimeHeartRate, sleepDuration, hrvMs }

// ── Wearable Data Point Model ──────────────────────────────────────────────────

class WearableDataPoint {
  final DateTime timestamp;
  final WearableSource source;
  final MetricType type;
  final double value;

  const WearableDataPoint({
    required this.timestamp,
    required this.source,
    required this.type,
    required this.value,
  });

  /// Unique bucket key for deduplication and resolution
  String get bucketKey {
    if (type == MetricType.cumulativeSteps) {
      // Hour bucket resolution: YYYY-MM-DD-HH
      return '${timestamp.year}-${timestamp.month}-${timestamp.day}-${timestamp.hour}_steps';
    } else if (type == MetricType.sleepDuration) {
      // Day bucket resolution: YYYY-MM-DD
      return '${timestamp.year}-${timestamp.month}-${timestamp.day}_sleep';
    } else {
      // Minute bucket resolution for HR/HRV: YYYY-MM-DD-HH-mm
      return '${timestamp.year}-${timestamp.month}-${timestamp.day}-${timestamp.hour}-${timestamp.minute}_${type.name}';
    }
  }
}

// ── Wearable Sync Merge Result ─────────────────────────────────────────────────

class SyncMergeResult {
  final List<WearableDataPoint> mergedPoints;
  final bool requiresReadinessRecalculation;
  final String summaryMessage;

  const SyncMergeResult({
    required this.mergedPoints,
    required this.requiresReadinessRecalculation,
    required this.summaryMessage,
  });
}

// ── WearableSyncMerger (Pure Dart) ──────────────────────────────────────────────

class WearableSyncMerger {
  const WearableSyncMerger();

  /// Merges late-sync wearable streams using resolution rules:
  /// 1. Cardiac (HR/HRV): Highest confidence source in overlapping minute bucket overrides lower confidence.
  /// 2. Cumulative (Steps/Calories): Smartwatch hourly bucket overrides phone steps (does NOT double-count).
  /// 3. Readiness Recalculation Trigger: Sleep delta > 30m OR Morning HRV delta > 10%.
  SyncMergeResult mergeDataStreams({
    required List<WearableDataPoint> localHistory,
    required List<WearableDataPoint> incomingStream,
    Map<WearableSource, double>? customConfidenceMap,
  }) {
    final confidenceMap = customConfidenceMap ??
        DeviceReliabilityEngine.deviceProfiles.map(
          (key, value) => MapEntry(key, value.hrvConfidence),
        );

    final bucketMap = <String, WearableDataPoint>{};

    // 1. Populate initial local history into bucket map
    for (final pt in localHistory) {
      bucketMap[pt.bucketKey] = pt;
    }

    bool triggerReadinessRecalc = false;
    double sleepDeltaMinutes = 0.0;
    double hrvDeltaPct = 0.0;

    // 2. Resolve incoming stream against local history
    for (final incoming in incomingStream) {
      final key = incoming.bucketKey;
      final existing = bucketMap[key];

      if (existing == null) {
        bucketMap[key] = incoming;
      } else {
        final existingConfidence = confidenceMap[existing.source] ?? 0.30;
        final incomingConfidence = confidenceMap[incoming.source] ?? 0.30;

        // Resolution Rule 1 & 2: Higher confidence overrides existing bucket
        if (incomingConfidence > existingConfidence) {
          bucketMap[key] = incoming;

          // Check Trigger Rule 3 for late-sync readiness recalculation
          if (incoming.type == MetricType.sleepDuration) {
            sleepDeltaMinutes += (incoming.value - existing.value).abs();
          } else if (incoming.type == MetricType.hrvMs && existing.value > 0) {
            final delta = ((incoming.value - existing.value) / existing.value).abs() * 100.0;
            if (delta > hrvDeltaPct) hrvDeltaPct = delta;
          }
        }
      }
    }

    if (sleepDeltaMinutes > 30.0 || hrvDeltaPct > 10.0) {
      triggerReadinessRecalc = true;
    }

    final mergedList = bucketMap.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final summary = triggerReadinessRecalc
        ? 'Late sync merged: Sleep/HRV delta detected. Readiness score recalibrated dynamically.'
        : 'Late sync merged successfully without readiness recalibration.';

    return SyncMergeResult(
      mergedPoints: mergedList,
      requiresReadinessRecalculation: triggerReadinessRecalc,
      summaryMessage: summary,
    );
  }
}
