import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/whatsapp_engine.dart';
import '../domain/whatsapp_models.dart';

@immutable
class WhatsAppState {
  final WhatsAppUserProfile profile;
  final List<WhatsAppMessageRecord> messageHistory;
  final bool isSimulating;
  final String? statusMessage;

  const WhatsAppState({
    required this.profile,
    required this.messageHistory,
    this.isSimulating = false,
    this.statusMessage,
  });

  WhatsAppState copyWith({
    WhatsAppUserProfile? profile,
    List<WhatsAppMessageRecord>? messageHistory,
    bool? isSimulating,
    String? statusMessage,
  }) {
    return WhatsAppState(
      profile: profile ?? this.profile,
      messageHistory: messageHistory ?? this.messageHistory,
      isSimulating: isSimulating ?? this.isSimulating,
      statusMessage: statusMessage,
    );
  }
}

final whatsappLoggingProvider =
    StateNotifierProvider<WhatsAppLoggingNotifier, WhatsAppState>((ref) {
  return WhatsAppLoggingNotifier();
});

class WhatsAppLoggingNotifier extends StateNotifier<WhatsAppState> {
  WhatsAppLoggingNotifier() : super(_buildInitialState());

  static const WhatsAppEngine _engine = WhatsAppEngine();

  static WhatsAppState _buildInitialState() {
    const profile = WhatsAppUserProfile(
      phoneNumber: '+919876543210',
      linkStatus: WhatsAppLinkStatus.activeLinked,
      preferredLanguage: 'hinglish',
      enableMorningBriefing: true,
      enableMealLogging: true,
      enableWaterNudges: true,
      enablePostDinnerWalkAlert: true,
    );

    final initialMessages = [
      WhatsAppMessageRecord(
        id: 'msg_001',
        rawMessage: '2 roti, 1 bowl dal tadka, cucumber salad',
        direction: WhatsAppMessageDirection.inboundUser,
        parsedEntity: const ParsedWhatsAppEntity(
          logType: WhatsAppLogType.meal,
          parsedSummary:
              '2 Roti(s), 1 Bowl Dal Tadka, 1 Bowl Fresh Green Salad',
          regionalParsedSummary: '२ रोटी, दाल तड़का, ककड़ी सलाद',
          calories: 350.0,
          proteinGrams: 14.0,
          carbsGrams: 56.0,
          fatGrams: 7.5,
          fiberGrams: 11.0,
          identifiedItems: [
            '2 Roti(s)',
            '1 Bowl Dal Tadka',
            '1 Bowl Fresh Green Salad'
          ],
        ),
        botReplyText: '''*✅ FitKarma Logged! 🥗*
━━━━━━━━━━━━━━━━━
🍽️ *Items:* 2 Roti(s), 1 Bowl Dal Tadka, 1 Bowl Fresh Green Salad
🔥 *Calories:* 350 kcal
💪 *Protein:* 14.0g | 🌾 *Carbs:* 56.0g | 🥑 *Fat:* 7.5g
🚶‍♂️ *Tip:* Take a 100-step Shatapadi walk to blunt post-prandial glucose spike!''',
        regionalBotReplyText: 'भोजन दर्ज: ३५० कैलोरी, १४ ग्राम प्रोटीन',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      WhatsAppMessageRecord(
        id: 'msg_002',
        rawMessage: '500ml water',
        direction: WhatsAppMessageDirection.inboundUser,
        parsedEntity: const ParsedWhatsAppEntity(
          logType: WhatsAppLogType.water,
          parsedSummary: 'Logged 500 mL of Water / Hydration',
          regionalParsedSummary: '५०० मिली जल दर्ज',
          waterMl: 500,
        ),
        botReplyText: '''*💧 Hydration Logged!*
━━━━━━━━━━━━━━━━━
+500 mL successfully logged. Stay on track towards your 3,000 mL daily goal! 🥥''',
        regionalBotReplyText: '५०० मिली जल दर्ज',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    return WhatsAppState(
      profile: profile,
      messageHistory: initialMessages,
    );
  }

  void initiatePhoneLinking(String rawPhone) {
    final normalized = WhatsAppEngine.normalizeIndianPhoneNumber(rawPhone);
    if (normalized == null) {
      state = state.copyWith(
          statusMessage:
              'Invalid phone number. Must be valid 10-digit Indian mobile.');
      return;
    }

    final otp = _engine.generateVerificationOtp(normalized);
    final updatedProfile = state.profile.copyWith(
      phoneNumber: normalized,
      linkStatus: WhatsAppLinkStatus.pendingVerification,
      verificationOtp: otp,
    );

    state = state.copyWith(
      profile: updatedProfile,
      statusMessage:
          'Verification OTP sent to $normalized: $otp (Demo Simulated)',
    );
  }

  bool confirmOtp(String enteredOtp) {
    if (state.profile.verificationOtp == null) return false;

    final isValid = _engine.verifyOtp(
      enteredOtp: enteredOtp,
      expectedOtp: state.profile.verificationOtp!,
    );

    if (isValid) {
      final updatedProfile = state.profile.copyWith(
        linkStatus: WhatsAppLinkStatus.activeLinked,
        verificationOtp: null,
        linkedAt: DateTime.now(),
      );
      state = state.copyWith(
        profile: updatedProfile,
        statusMessage: 'WhatsApp number verified and linked successfully! 📱',
      );
      return true;
    } else {
      state = state.copyWith(
          statusMessage: 'Incorrect OTP. Please check and try again.');
      return false;
    }
  }

  void togglePreference({
    bool? morningBriefing,
    bool? mealLogging,
    bool? waterNudges,
    bool? postDinnerWalk,
  }) {
    final updatedProfile = state.profile.copyWith(
      enableMorningBriefing:
          morningBriefing ?? state.profile.enableMorningBriefing,
      enableMealLogging: mealLogging ?? state.profile.enableMealLogging,
      enableWaterNudges: waterNudges ?? state.profile.enableWaterNudges,
      enablePostDinnerWalkAlert:
          postDinnerWalk ?? state.profile.enablePostDinnerWalkAlert,
    );
    state = state.copyWith(
      profile: updatedProfile,
      statusMessage: 'Preferences updated.',
    );
  }

  void setPreferredLanguage(String lang) {
    state = state.copyWith(
      profile: state.profile.copyWith(preferredLanguage: lang),
      statusMessage: 'Language preference set to ${lang.toUpperCase()}.',
    );
  }

  void simulateInboundMessage(String messageText) {
    if (messageText.trim().isEmpty) return;

    final parsed = _engine.parseInboundMessage(messageText);
    final reply = _engine.formatBotReply(parsed,
        language: state.profile.preferredLanguage);

    final newRecord = WhatsAppMessageRecord(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      rawMessage: messageText,
      direction: WhatsAppMessageDirection.inboundUser,
      parsedEntity: parsed,
      botReplyText: reply,
      regionalBotReplyText: parsed.regionalParsedSummary,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messageHistory: [newRecord, ...state.messageHistory],
      statusMessage: 'Processed WhatsApp message: ${parsed.parsedSummary}',
    );
  }

  void unlinkAccount() {
    state = state.copyWith(
      profile: state.profile.copyWith(linkStatus: WhatsAppLinkStatus.unlinked),
      statusMessage: 'WhatsApp account unlinked.',
    );
  }
}
