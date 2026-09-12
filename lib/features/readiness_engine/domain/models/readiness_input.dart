enum ConfidenceTier { high, moderate, low }

class MuscleSorenessEntry {
  final String muscleGroup; // e.g. 'chest', 'back', 'quads', 'shoulders'
  final int severity; // 1 (mild) to 5 (extreme DOMS)

  const MuscleSorenessEntry({
    required this.muscleGroup,
    required this.severity,
  });

  Map<String, dynamic> toJson() => {
        'muscle_group': muscleGroup,
        'severity': severity,
      };

  factory MuscleSorenessEntry.fromJson(Map<String, dynamic> json) =>
      MuscleSorenessEntry(
        muscleGroup: json['muscle_group'] as String,
        severity: json['severity'] as int,
      );
}

/// ReadinessInput — Multi-Tier Input Payload
class ReadinessInput {
  // Tier 1 (High Confidence): Biometrics from Wearables
  final double? hrvRmssdMs; // e.g. 58 ms (baseline comparison)
  final double? hrvBaselineMs; // e.g. 55 ms
  final int? restingHeartRateBpm; // e.g. 52 bpm
  final int? restingHeartRateBaselineBpm; // e.g. 54 bpm
  final double? deepSleepMinutes; // e.g. 85 min
  final double? remSleepMinutes; // e.g. 95 min

  // Tier 2 (Moderate Confidence): Sleep Duration & Check-in
  final double sleepDurationHours; // e.g. 7.2 hours
  final double sleepTargetHours; // e.g. 8.0 hours

  // Tier 3 (Baseline/Manual): Subjective Morning Check-in
  final int perceivedEnergy; // 1 (exhausted) to 5 (peak energy)
  final int perceivedStress; // 1 (calm) to 5 (high stress)
  final List<MuscleSorenessEntry> sorenessList;

  const ReadinessInput({
    this.hrvRmssdMs,
    this.hrvBaselineMs,
    this.restingHeartRateBpm,
    this.restingHeartRateBaselineBpm,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    this.sleepDurationHours = 7.5,
    this.sleepTargetHours = 8.0,
    this.perceivedEnergy = 3,
    this.perceivedStress = 2,
    this.sorenessList = const [],
  });

  ConfidenceTier get detectedTier {
    if (hrvRmssdMs != null && restingHeartRateBpm != null && deepSleepMinutes != null) {
      return ConfidenceTier.high;
    }
    if (sleepDurationHours > 0) {
      return ConfidenceTier.moderate;
    }
    return ConfidenceTier.low;
  }
}
