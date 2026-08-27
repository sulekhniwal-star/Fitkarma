enum WearableBrand {
  whoop(name: 'WHOOP 4.0', hrvConfidence: 0.95, sleepConfidence: 0.95, stepConfidence: 0.80),
  oura(name: 'Oura Ring Gen 3', hrvConfidence: 0.95, sleepConfidence: 0.98, stepConfidence: 0.75),
  appleWatch(name: 'Apple Watch Ultra / Series', hrvConfidence: 0.90, sleepConfidence: 0.90, stepConfidence: 0.95),
  garmin(name: 'Garmin Forerunner / Fenix', hrvConfidence: 0.85, sleepConfidence: 0.85, stepConfidence: 0.95),
  polarChestStrap(name: 'Polar H10 Chest Strap', hrvConfidence: 0.99, sleepConfidence: 0.0, stepConfidence: 0.0),
  noiseBoat(name: 'Noise / boAt Smartwatch', hrvConfidence: 0.55, sleepConfidence: 0.60, stepConfidence: 0.75),
  phonePedometer(name: 'Phone Sensor (Health Connect)', hrvConfidence: 0.0, sleepConfidence: 0.50, stepConfidence: 0.85);

  final String name;
  final double hrvConfidence;
  final double sleepConfidence;
  final double stepConfidence;

  const WearableBrand({
    required this.name,
    required this.hrvConfidence,
    required this.sleepConfidence,
    required this.stepConfidence,
  });
}

enum MetricType { hrv, sleep, steps, workoutHeartRate }

class WearableSample {
  final String id;
  final WearableBrand source;
  final MetricType metric;
  final double value;
  final DateTime recordedAt;
  final DateTime syncedAt;

  const WearableSample({
    required this.id,
    required this.source,
    required this.metric,
    required this.value,
    required this.recordedAt,
    required this.syncedAt,
  });
}

class MergedMetricResult {
  final MetricType metric;
  final double authoritativeValue;
  final WearableBrand selectedSource;
  final double confidenceScore;
  final String resolutionReason;
  final List<WearableSample> candidateSamples;

  const MergedMetricResult({
    required this.metric,
    required this.authoritativeValue,
    required this.selectedSource,
    required this.confidenceScore,
    required this.resolutionReason,
    required this.candidateSamples,
  });
}

class WearableMergeEngine {
  /// Pure Dart deterministic late-sync resolution based on Device Confidence Matrix
  static MergedMetricResult resolveMetricConflict({
    required MetricType metric,
    required List<WearableSample> incomingSamples,
  }) {
    if (incomingSamples.isEmpty) {
      return MergedMetricResult(
        metric: metric,
        authoritativeValue: 0.0,
        selectedSource: WearableBrand.phonePedometer,
        confidenceScore: 0.5,
        resolutionReason: 'Default baseline (no device samples).',
        candidateSamples: const [],
      );
    }

    if (incomingSamples.length == 1) {
      final s = incomingSamples.first;
      return MergedMetricResult(
        metric: metric,
        authoritativeValue: s.value,
        selectedSource: s.source,
        confidenceScore: _getConfidence(s.source, metric),
        resolutionReason: 'Single authoritative source available.',
        candidateSamples: incomingSamples,
      );
    }

    // Sort candidates primarily by Device Confidence Matrix, secondarily by latest sync timestamp
    final sorted = List<WearableSample>.from(incomingSamples);
    sorted.sort((a, b) {
      final confA = _getConfidence(a.source, metric);
      final confB = _getConfidence(b.source, metric);

      if ((confA - confB).abs() > 0.05) {
        return confB.compareTo(confA); // higher confidence first
      }
      // If confidence within 5%, prefer most recent valid synced sample
      return b.syncedAt.compareTo(a.syncedAt);
    });

    final winner = sorted.first;
    final winnerConf = _getConfidence(winner.source, metric);

    return MergedMetricResult(
      metric: metric,
      authoritativeValue: winner.value,
      selectedSource: winner.source,
      confidenceScore: winnerConf,
      resolutionReason: 'Selected ${winner.source.name} (Tier Confidence: ${(winnerConf * 100).round()}%) over ${sorted.length - 1} conflicting late-sync sources.',
      candidateSamples: sorted,
    );
  }

  static double _getConfidence(WearableBrand brand, MetricType metric) {
    switch (metric) {
      case MetricType.hrv:
        return brand.hrvConfidence;
      case MetricType.sleep:
        return brand.sleepConfidence;
      case MetricType.steps:
        return brand.stepConfidence;
      case MetricType.workoutHeartRate:
        return brand == WearableBrand.polarChestStrap ? 0.99 : brand.hrvConfidence;
    }
  }
}
