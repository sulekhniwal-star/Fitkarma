import '../models/health_models.dart';

class CanonicalMetricPoint {
  final DateTime timestamp;
  final String metric;
  final double value;
  final String unit;
  final String primarySource;
  final double confidenceScore;

  const CanonicalMetricPoint({
    required this.timestamp,
    required this.metric,
    required this.value,
    required this.unit,
    required this.primarySource,
    required this.confidenceScore,
  });
}

class WearableComparisonEngine {
  const WearableComparisonEngine();

  /// Resolve device confidence weight (0.0 to 1.0)
  double getDeviceConfidence(String source) {
    final lower = source.toLowerCase();
    if (lower.contains('apple') ||
        lower.contains('garmin') ||
        lower.contains('pixel') ||
        lower.contains('polar') ||
        lower.contains('healthkit') ||
        lower.contains('health_connect')) {
      return 1.0; // Tier 1: Medical / high-accuracy clinical grade
    }
    if (lower.contains('fitbit') ||
        lower.contains('samsung') ||
        lower.contains('galaxy') ||
        lower.contains('amazfit') ||
        lower.contains('whoop') ||
        lower.contains('oura')) {
      return 0.85; // Tier 2: Mid-tier / dedicated fitness sensors
    }
    if (lower.contains('noise') ||
        lower.contains('boat') ||
        lower.contains('fireboltt') ||
        lower.contains('realme') ||
        lower.contains('xiaomi') ||
        lower.contains('mi_band')) {
      return 0.65; // Tier 3: Budget trackers
    }
    return 0.50; // Tier 4: Manual entry / unknown
  }

  /// Deduplicate and reconcile multiple wearable streams into a canonical stream
  List<CanonicalMetricPoint> reconcileStreams(List<WearableSample> samples) {
    if (samples.isEmpty) return [];

    // Group samples by metric
    final Map<String, List<WearableSample>> metricGroups = {};
    for (final sample in samples) {
      metricGroups.putIfAbsent(sample.metric, () => []).add(sample);
    }

    final List<CanonicalMetricPoint> canonical = [];

    for (final entry in metricGroups.entries) {
      final metric = entry.key;
      final group = entry.value;

      // Sort by timestamp ascending
      group.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Bucket samples within 5-minute windows
      final Map<int, List<WearableSample>> timeBuckets = {};
      for (final s in group) {
        final bucketKey = s.timestamp.millisecondsSinceEpoch ~/ (5 * 60 * 1000);
        timeBuckets.putIfAbsent(bucketKey, () => []).add(s);
      }

      for (final bucket in timeBuckets.values) {
        if (bucket.isEmpty) continue;

        // Select sample with highest source confidence
        bucket.sort((a, b) {
          final confA = getDeviceConfidence(a.source);
          final confB = getDeviceConfidence(b.source);
          return confB.compareTo(confA);
        });

        final winner = bucket.first;
        final confidence = getDeviceConfidence(winner.source);

        canonical.add(
          CanonicalMetricPoint(
            timestamp: winner.timestamp,
            metric: metric,
            value: winner.value,
            unit: winner.unit,
            primarySource: winner.source,
            confidenceScore: confidence,
          ),
        );
      }
    }

    canonical.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return canonical;
  }

  /// Reconcile step count across sources (resolves double counting)
  int calculateReconciledDailySteps(List<WearableSample> samples) {
    final stepSamples = samples.where((s) => s.metric == 'steps').toList();
    if (stepSamples.isEmpty) return 0;

    // If samples are cumulative per source for the day, pick max per source, then take source with highest confidence
    final Map<String, double> maxPerSource = {};
    for (final s in stepSamples) {
      final current = maxPerSource[s.source] ?? 0.0;
      if (s.value > current) {
        maxPerSource[s.source] = s.value;
      }
    }

    String bestSource = maxPerSource.keys.first;
    double bestConfidence = -1.0;

    for (final source in maxPerSource.keys) {
      final conf = getDeviceConfidence(source);
      if (conf > bestConfidence) {
        bestConfidence = conf;
        bestSource = source;
      }
    }

    return (maxPerSource[bestSource] ?? 0.0).round();
  }

  /// Reconcile resting heart rate from wearable samples (weighted average by confidence)
  int calculateReconciledRestingHeartRate(List<WearableSample> samples) {
    final hrSamples = samples.where((s) => s.metric == 'heart_rate' || s.metric == 'resting_heart_rate').toList();
    if (hrSamples.isEmpty) return 0;

    double totalWeightedHr = 0.0;
    double totalWeight = 0.0;

    for (final s in hrSamples) {
      final weight = getDeviceConfidence(s.source);
      totalWeightedHr += s.value * weight;
      totalWeight += weight;
    }

    if (totalWeight == 0) return 0;
    return (totalWeightedHr / totalWeight).round();
  }
}
