// §P4-G Smart Wearable Comparison Layer & Device Reliability Engine (Pure Dart)

// ── Wearable Sources ──────────────────────────────────────────────────────────

enum WearableSource {
  appleWatch,       // Apple Watch Series 9+
  whoop,            // WHOOP 4.0
  garmin,           // Garmin Fenix / Forerunner
  samsungGalaxy,    // Samsung Galaxy Watch 6
  fitbitSense,      // Fitbit Sense 2
  miBandNoise,      // Mi Band / Noise / Consumer entry
  manualInput,      // User manual entry
}

extension WearableSourceInfo on WearableSource {
  String get displayName {
    switch (this) {
      case WearableSource.appleWatch:
        return 'Apple Watch Series 9+';
      case WearableSource.whoop:
        return 'WHOOP 4.0';
      case WearableSource.garmin:
        return 'Garmin Fenix/Forerunner';
      case WearableSource.samsungGalaxy:
        return 'Samsung Galaxy Watch 6';
      case WearableSource.fitbitSense:
        return 'Fitbit Sense 2';
      case WearableSource.miBandNoise:
        return 'Mi Band / Noise';
      case WearableSource.manualInput:
        return 'Manual Input';
    }
  }

  String get notes {
    switch (this) {
      case WearableSource.appleWatch:
        return 'ECG-grade HR; HRV from SDNN';
      case WearableSource.whoop:
        return 'Purpose-built recovery; best HRV';
      case WearableSource.garmin:
        return 'Trusted optical; good HRV';
      case WearableSource.samsungGalaxy:
        return 'HRV less validated for readiness';
      case WearableSource.fitbitSense:
        return 'Consumer-grade; moderate accuracy';
      case WearableSource.miBandNoise:
        return 'Entry-level optical; treat as estimate';
      case WearableSource.manualInput:
        return 'User-entered; high uncertainty';
    }
  }
}

// ── Device Profile Metadata ───────────────────────────────────────────────────

class DeviceConfidenceProfile {
  final WearableSource source;
  final double hrvConfidence; // 0.0 - 1.0
  final double hrConfidence;  // 0.0 - 1.0

  const DeviceConfidenceProfile({
    required this.source,
    required this.hrvConfidence,
    required this.hrConfidence,
  });

  String get confidenceLabel {
    final avg = (hrvConfidence + hrConfidence) / 2;
    if (avg >= 0.90) return 'Very High';
    if (avg >= 0.80) return 'High';
    if (avg >= 0.65) return 'Medium';
    return 'Low';
  }

  int get starRating {
    final avg = (hrvConfidence + hrConfidence) / 2;
    if (avg >= 0.90) return 5;
    if (avg >= 0.80) return 4;
    if (avg >= 0.65) return 3;
    if (avg >= 0.45) return 2;
    return 1;
  }
}

// ── Wearable Reading Result ───────────────────────────────────────────────────

class WearableReadingResult {
  final double adjustedHRV;
  final double adjustedHR;
  final double hrvConfidence;
  final double hrConfidence;
  final double readinessWeight;
  final String displayLabel;

  const WearableReadingResult({
    required this.adjustedHRV,
    required this.adjustedHR,
    required this.hrvConfidence,
    required this.hrConfidence,
    required this.readinessWeight,
    required this.displayLabel,
  });
}

// ── DeviceReliabilityEngine ───────────────────────────────────────────────────

class DeviceReliabilityEngine {
  const DeviceReliabilityEngine();

  /// Confidence matrix mapping per §P4-G documentation
  static const Map<WearableSource, DeviceConfidenceProfile> deviceProfiles = {
    WearableSource.appleWatch: DeviceConfidenceProfile(
      source: WearableSource.appleWatch,
      hrvConfidence: 0.85,
      hrConfidence: 0.95,
    ),
    WearableSource.whoop: DeviceConfidenceProfile(
      source: WearableSource.whoop,
      hrvConfidence: 0.95,
      hrConfidence: 0.90,
    ),
    WearableSource.garmin: DeviceConfidenceProfile(
      source: WearableSource.garmin,
      hrvConfidence: 0.88,
      hrConfidence: 0.88,
    ),
    WearableSource.samsungGalaxy: DeviceConfidenceProfile(
      source: WearableSource.samsungGalaxy,
      hrvConfidence: 0.70,
      hrConfidence: 0.85,
    ),
    WearableSource.fitbitSense: DeviceConfidenceProfile(
      source: WearableSource.fitbitSense,
      hrvConfidence: 0.65,
      hrConfidence: 0.75,
    ),
    WearableSource.miBandNoise: DeviceConfidenceProfile(
      source: WearableSource.miBandNoise,
      hrvConfidence: 0.40,
      hrConfidence: 0.60,
    ),
    WearableSource.manualInput: DeviceConfidenceProfile(
      source: WearableSource.manualInput,
      hrvConfidence: 0.30,
      hrConfidence: 0.30,
    ),
  };

  /// Apply device confidence weights to raw wearable metrics
  WearableReadingResult applyConfidence({
    required WearableSource source,
    required double rawHRV,
    required double rawHR,
  }) {
    final profile = deviceProfiles[source] ?? deviceProfiles[WearableSource.manualInput]!;

    final readinessW = calculateReadinessWeight(profile.hrvConfidence);

    return WearableReadingResult(
      adjustedHRV: rawHRV,
      adjustedHR: rawHR,
      hrvConfidence: profile.hrvConfidence,
      hrConfidence: profile.hrConfidence,
      readinessWeight: readinessW,
      displayLabel: '${source.displayName} · ${profile.confidenceLabel} confidence',
    );
  }

  /// Readiness calculation weight:
  /// - confidence >= 0.85 -> 1.0 (Full weight)
  /// - confidence >= 0.65 -> 0.70 (70% weight)
  /// - otherwise -> 0.40 (40% guideline weight)
  double calculateReadinessWeight(double hrvConfidence) {
    if (hrvConfidence >= 0.85) return 1.0;
    if (hrvConfidence >= 0.65) return 0.70;
    return 0.40;
  }
}
