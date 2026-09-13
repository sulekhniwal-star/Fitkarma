import 'vernacular_voice_engine.dart';

class WhatsAppLoggingEngine {
  final VernacularVoiceEngine voiceEngine;

  const WhatsAppLoggingEngine({
    this.voiceEngine = const VernacularVoiceEngine(),
  });

  /// Processes raw inbound WhatsApp message and returns structured confirmation text
  Map<String, dynamic> processInboundMessage({
    required String fromPhoneNumber,
    required String textMessage,
  }) {
    final parsed = voiceEngine.parseTranscript(textMessage);

    String replyMessage;
    if (parsed.entryType == 'meal') {
      final rotis = parsed.extractedEntities['roti_count'] ?? 0;
      final hasDal = parsed.extractedEntities['dal_katori'] != null;
      final hasPaneer = parsed.extractedEntities['paneer_g'] != null;

      replyMessage = '✅ FitKarma Meal Logged!\n'
          '🍽️ Items: ${rotis > 0 ? "$rotis Roti, " : ""}${hasDal ? "1 Katori Dal, " : ""}${hasPaneer ? "Paneer Sabzi" : ""}\n'
          '🔥 Est: ~480 kcal | Protein: 18g | Karma: +50 pts\n'
          'Keep your Yogi streak alive! 🧘‍♂️';
    } else if (parsed.entryType == 'workout') {
      final exercise = parsed.extractedEntities['exercise'] ?? 'Workout';
      final reps = parsed.extractedEntities['reps'] ?? 25;

      replyMessage = '💪 FitKarma Workout Logged!\n'
          '⚡ Activity: $reps reps of $exercise\n'
          '🔥 Cal: ~120 kcal | Karma: +100 pts\n'
          'Shabaash! Great momentum today! 🔥';
    } else {
      replyMessage = '🙏 Namaste! Send your meal (e.g. "2 roti dal dahi") or workout (e.g. "50 dand") to log instantly.';
    }

    return {
      'from': fromPhoneNumber,
      'parsed_entry': parsed,
      'reply_message': replyMessage,
    };
  }
}
