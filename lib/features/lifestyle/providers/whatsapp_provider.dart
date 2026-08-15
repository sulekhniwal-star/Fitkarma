// §P16-A WhatsApp Connection & Privacy Provider
// Cross-reference: §P16-A in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../nutrition/models/whatsapp_logging_models.dart';
import '../../../core/brain/whatsapp_food_logging_engine.dart';

class WhatsAppNotifier extends StateNotifier<WhatsAppUserLinkState> {
  final WhatsAppFoodLoggingEngine _engine;

  WhatsAppNotifier([WhatsAppFoodLoggingEngine? engine])
      : _engine = engine ?? const WhatsAppFoodLoggingEngine(),
        super(const WhatsAppUserLinkState());

  /// Enables WhatsApp food logging for a verified phone number
  void linkPhoneNumber(String phoneNumber) {
    state = state.copyWith(
      isOptedIn: true,
      linkedPhoneNumber: phoneNumber,
      linkedAt: DateTime.now(),
    );
  }

  /// Disables WhatsApp logging and unlinks phone number instantly
  void unlinkWhatsApp() {
    state = const WhatsAppUserLinkState(
      isOptedIn: false,
      linkedPhoneNumber: null,
      linkedAt: null,
    );
  }

  /// Toggles opt-in status
  void toggleOptIn(bool value) {
    state = state.copyWith(isOptedIn: value);
  }

  /// Process message via state notifier
  WhatsAppLogResult ingestMessage(WhatsAppMessagePayload payload) {
    final result = _engine.processIncomingMessage(
      payload: payload,
      userLinkState: state,
    );

    if (result.isSuccess) {
      state = state.copyWith(totalWhatsAppLogs: state.totalWhatsAppLogs + 1);
    }

    return result;
  }
}

final whatsAppLoggingEngineProvider =
    Provider<WhatsAppFoodLoggingEngine>((ref) => const WhatsAppFoodLoggingEngine());

final whatsAppProvider =
    StateNotifierProvider<WhatsAppNotifier, WhatsAppUserLinkState>((ref) {
  final engine = ref.watch(whatsAppLoggingEngineProvider);
  return WhatsAppNotifier(engine);
});
