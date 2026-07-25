/// §P16-A WhatsApp Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'whatsapp_models.dart';
import 'whatsapp_webhook_service.dart';

class WhatsAppState {
  const WhatsAppState({
    this.isOptedIn = false, // OFF BY DEFAULT (§P16-A spec)
    this.linkedPhoneNumber,
    this.isPhoneVerified = false,
    this.messageLogHistory = const [],
    this.successMessage,
  });

  final bool isOptedIn;
  final String? linkedPhoneNumber;
  final bool isPhoneVerified;
  final List<String> messageLogHistory;
  final String? successMessage;

  WhatsAppState copyWith({
    bool? isOptedIn,
    String? linkedPhoneNumber,
    bool? isPhoneVerified,
    List<String>? messageLogHistory,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return WhatsAppState(
      isOptedIn: isOptedIn ?? this.isOptedIn,
      linkedPhoneNumber: linkedPhoneNumber ?? this.linkedPhoneNumber,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      messageLogHistory: messageLogHistory ?? this.messageLogHistory,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class WhatsAppNotifier extends Notifier<WhatsAppState> {
  late final WhatsAppWebhookService _service;

  @override
  WhatsAppState build() {
    _service = const WhatsAppWebhookService();
    // OFF BY DEFAULT (§P16-A spec requirement)
    return const WhatsAppState(isOptedIn: false);
  }

  void linkPhoneNumber(String phone) {
    final cleanPhone = phone.trim();
    state = state.copyWith(
      isOptedIn: true,
      linkedPhoneNumber: cleanPhone,
      isPhoneVerified: true,
      successMessage: '📱 WhatsApp linked successfully ($cleanPhone)! Opt-in enabled.',
    );
  }

  void toggleOptIn(bool enabled) {
    state = state.copyWith(
      isOptedIn: enabled,
      successMessage: enabled
          ? 'WhatsApp logging enabled.'
          : 'WhatsApp logging disabled (Opt-out active).',
    );
  }

  void unlinkWhatsApp() {
    state = const WhatsAppState(
      isOptedIn: false,
      linkedPhoneNumber: null,
      isPhoneVerified: false,
      successMessage: 'WhatsApp unlinked successfully.',
    );
  }

  Future<void> simulateIncomingWebhook(WhatsAppMessage message) async {
    final registeredUsers = [
      WhatsAppUserBinding(
        userId: 'user_current',
        phoneNumber: state.linkedPhoneNumber ?? '+919876543210',
        whatsAppOptIn: state.isOptedIn,
      ),
    ];

    final reply = await _service.processIncomingWebhook(
      message: message,
      registeredUsers: registeredUsers,
    );

    state = state.copyWith(
      messageLogHistory: [reply, ...state.messageLogHistory],
      successMessage: reply,
    );
  }
}

final whatsAppProvider =
    NotifierProvider<WhatsAppNotifier, WhatsAppState>(
  WhatsAppNotifier.new,
);
