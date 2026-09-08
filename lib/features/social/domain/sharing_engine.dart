import 'sharing_models.dart';

/// Pure Dart Deterministic Engine for Shareable Story Cards,
/// Formatted Social Payloads, and Viral Contagion Indexing.
class ActivitySharingEngine {
  const ActivitySharingEngine._();

  /// Formats human-readable share text for WhatsApp, SMS, or Telegram
  static String generateShareableTextPayload({
    required ShareableActivityPayload payload,
    String appUrl = 'https://fitkarma.app/sadhana',
  }) {
    final buffer = StringBuffer();
    buffer.writeln('🌟 *FitKarma Health Milestone* 🌟');
    buffer.writeln('🔥 *${payload.headline}*');
    buffer.writeln('✨ ${payload.regionalHeadline}');
    buffer.writeln('');
    buffer.writeln('📊 *Achievement:* ${payload.primaryMetricValue} (${payload.primaryMetricLabel})');
    buffer.writeln('⚡ *Details:* ${payload.detailedSubtitle}');
    buffer.writeln('🛡️ *Status:* Verified via ${payload.verificationSource}');
    buffer.writeln('');
    buffer.writeln('Join my accountability Sangha on FitKarma 👇');
    buffer.writeln(appUrl);

    return buffer.toString();
  }

  /// Calculates Viral Contagion Index (0.0 to 100.0)
  static double calculateViralContagionIndex({
    required int totalSharesCount,
    required int karmaPointsEarned,
  }) {
    final shareComponent = (totalSharesCount * 12.5).clamp(0.0, 60.0);
    final karmaComponent = (karmaPointsEarned / 500.0).clamp(0.0, 1.0) * 40.0;
    return (shareComponent + karmaComponent).clamp(5.0, 100.0);
  }
}
