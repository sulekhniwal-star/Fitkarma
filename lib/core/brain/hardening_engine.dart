/// Core Production Hardening & Performance Engine
class HardeningEngine {
  const HardeningEngine();

  /// Check if GlassCard blur should be disabled (Disabled on DeviceTier.low)
  bool shouldDisableGlassBlur({required String deviceTier}) {
    return deviceTier.toLowerCase() == 'low';
  }

  /// Strip PII (email, phone, IP) from Sentry diagnostic log messages
  String stripPiiFromLog(String rawLog) {
    var cleaned = rawLog.replaceAll(
        RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
        '[REDACTED_EMAIL]');
    cleaned = cleaned.replaceAll(RegExp(r'\+?\d{10,12}'), '[REDACTED_PHONE]');
    return cleaned;
  }

  /// Check if Dead Letter Queue (DLQ) sync failure alert banner should display (>= 3 failures)
  bool shouldShowDlqBanner(int consecutiveSyncFailures) {
    return consecutiveSyncFailures >= 3;
  }
}
