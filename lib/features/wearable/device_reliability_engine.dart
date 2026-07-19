enum WearableSource {
  appleWatch,
  whoop,
  garmin,
  samsungWatch,
  fitbit,
  miBand,
  manual,
}

extension WearableSourceExtension on WearableSource {
  String get displayName {
    return switch (this) {
      WearableSource.appleWatch => 'Apple Watch Series 9+',
      WearableSource.whoop => 'WHOOP 4.0',
      WearableSource.garmin => 'Garmin',
      WearableSource.samsungWatch => 'Samsung Galaxy Watch 6',
      WearableSource.fitbit => 'Fitbit Sense 2',
      WearableSource.miBand => 'Mi Band / Noise',
      WearableSource.manual => 'Manual Input',
    };
  }
}

enum MetricType {
  cumulativeSteps,
  pointInTimeHeartRate,
  sleepDuration,
}

class WearableDataPoint {
  final DateTime timestamp;
  final WearableSource source;
  final MetricType type;
  final double value;

  WearableDataPoint({
    required this.timestamp,
    required this.source,
    required this.type,
    required this.value,
  });
}

class WearableReadingResult {
  final double adjustedHRV;
  final double adjustedHR;
  final double hrvConfidence;
  final double hrConfidence;
  final double readinessWeight;
  final String displayLabel;

  WearableReadingResult({
    required this.adjustedHRV,
    required this.adjustedHR,
    required this.hrvConfidence,
    required this.hrConfidence,
    required this.readinessWeight,
    required this.displayLabel,
  });
}

class DeviceProfile {
  final double hrvConfidence;
  final double hrConfidence;
  final String confidenceLabel;

  const DeviceProfile({
    required this.hrvConfidence,
    required this.hrConfidence,
    required this.confidenceLabel,
  });
}

class DeviceReliabilityEngine {
  static const Map<WearableSource, DeviceProfile> deviceProfiles = {
    WearableSource.appleWatch: DeviceProfile(hrvConfidence: 0.85, hrConfidence: 0.95, confidenceLabel: 'High'),
    WearableSource.whoop: DeviceProfile(hrvConfidence: 0.95, hrConfidence: 0.90, confidenceLabel: 'Very High'),
    WearableSource.garmin: DeviceProfile(hrvConfidence: 0.88, hrConfidence: 0.88, confidenceLabel: 'High'),
    WearableSource.samsungWatch: DeviceProfile(hrvConfidence: 0.70, hrConfidence: 0.85, confidenceLabel: 'Medium'),
    WearableSource.fitbit: DeviceProfile(hrvConfidence: 0.65, hrConfidence: 0.75, confidenceLabel: 'Medium'),
    WearableSource.miBand: DeviceProfile(hrvConfidence: 0.40, hrConfidence: 0.60, confidenceLabel: 'Low'),
    WearableSource.manual: DeviceProfile(hrvConfidence: 0.30, hrConfidence: 0.30, confidenceLabel: 'Low'),
  };

  WearableReadingResult applyConfidence({
    required WearableSource source,
    required double rawHRV,
    required double rawHR,
  }) {
    final profile = deviceProfiles[source]!;

    return WearableReadingResult(
      adjustedHRV: rawHRV,
      adjustedHR: rawHR,
      hrvConfidence: profile.hrvConfidence,
      hrConfidence: profile.hrConfidence,
      readinessWeight: _readinessWeight(profile.hrvConfidence),
      displayLabel: '${source.displayName} · ${profile.confidenceLabel} confidence',
    );
  }

  double _readinessWeight(double confidence) {
    if (confidence >= 0.85) return 1.0;   // Full weight
    if (confidence >= 0.65) return 0.70;  // 70% weight
    return 0.40;                           // 40% weight — guideline only
  }
}

class WearableSyncMerger {
  /// Merges late-sync wearable points with existing local data based on the device confidence hierarchy,
  /// preventing duplicate step counts or overwritten high-fidelity cardiac metrics.
  List<WearableDataPoint> mergeDataStreams({
    required List<WearableDataPoint> localHistory,
    required List<WearableDataPoint> incomingStream,
    required Map<WearableSource, double> sourceConfidenceMap,
  }) {
    final merged = <String, WearableDataPoint>{};

    // 1. Ingest existing local points
    for (final point in localHistory) {
      final key = _makeKey(point);
      merged[key] = point;
    }

    // 2. Process incoming points with conflict resolution
    for (final point in incomingStream) {
      final key = _makeKey(point);
      if (!merged.containsKey(key)) {
        merged[key] = point;
        continue;
      }

      final existing = merged[key]!;
      final existingConfidence = sourceConfidenceMap[existing.source] ?? 0.0;
      final incomingConfidence = sourceConfidenceMap[point.source] ?? 0.0;

      // Override rule: Select the data point with the higher confidence rating
      if (incomingConfidence > existingConfidence) {
        merged[key] = point;
      }
    }

    return merged.values.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  String _makeKey(WearableDataPoint p) {
    if (p.type == MetricType.pointInTimeHeartRate) {
      // Bucket by minute to prevent overlapping heart rates
      final bucket = DateTime(p.timestamp.year, p.timestamp.month, p.timestamp.day, p.timestamp.hour, p.timestamp.minute);
      return '${p.type.name}_$bucket';
    } else if (p.type == MetricType.cumulativeSteps) {
      // Bucket by hour to prevent double counting steps between watch and phone
      final bucket = DateTime(p.timestamp.year, p.timestamp.month, p.timestamp.day, p.timestamp.hour);
      return '${p.type.name}_$bucket';
    }
    // Daily point metrics
    final date = DateTime(p.timestamp.year, p.timestamp.month, p.timestamp.day);
    return '${p.type.name}_$date';
  }
}
