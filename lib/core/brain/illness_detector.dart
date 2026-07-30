/// Biometric Illness Detection Result
class IllnessAlarmResult {
  final bool isAlarmTriggered;
  final String reason;
  final double rhrDeltaBpm;
  final double hrvRatio;

  const IllnessAlarmResult({
    required this.isAlarmTriggered,
    required this.reason,
    required this.rhrDeltaBpm,
    required this.hrvRatio,
  });
}

/// Evaluates resting heart rate and HRV anomalies to detect sickness onset
class IllnessDetector {
  const IllnessDetector();

  /// Check for illness alarm triggers: RHR > +7 bpm OR HRV < 70% of 30-day baseline
  IllnessAlarmResult checkIllnessAlarm({
    required int currentRhr,
    required int baselineRhr,
    required double currentHrv,
    required double baselineHrv,
  }) {
    final rhrDelta = (currentRhr - baselineRhr).toDouble();
    final hrvRatio = currentHrv / baselineHrv;

    bool triggered = false;
    final reasons = <String>[];

    if (rhrDelta >= 7.0) {
      triggered = true;
      reasons.add('Resting HR elevated by +${rhrDelta.round()} bpm');
    }

    if (hrvRatio <= 0.70) {
      triggered = true;
      reasons.add('HRV dropped to ${(hrvRatio * 100).round()}% of baseline');
    }

    return IllnessAlarmResult(
      isAlarmTriggered: triggered,
      reason: triggered ? reasons.join(' & ') : 'Biometrics normal',
      rhrDeltaBpm: rhrDelta,
      hrvRatio: hrvRatio,
    );
  }
}
