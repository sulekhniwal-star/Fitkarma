import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/whatsapp_food_logging_engine.dart';
import 'package:fitkarma/features/nutrition/models/whatsapp_logging_models.dart';
import 'package:fitkarma/features/lifestyle/providers/whatsapp_provider.dart';

void main() {
  group('§P16-A WhatsApp Business Food Logging Engine Tests', () {
    const engine = WhatsAppFoodLoggingEngine();

    test('Rejects incoming message if user is unlinked or opt-in is false', () {
      final payload = WhatsAppMessagePayload(
        senderPhone: '+919876543210',
        type: WhatsAppMessageType.text,
        textBody: '2 Roti and Dal Tadka',
        receivedAt: DateTime.now(),
      );

      // Default state: not opted in
      const unlinkedState = WhatsAppUserLinkState();

      final result = engine.processIncomingMessage(
        payload: payload,
        userLinkState: unlinkedState,
      );

      expect(result.isSuccess, isFalse);
      expect(result.isOptInError, isTrue);
      expect(result.responseMessage, contains("isn't linked to a FitKarma account"));
    });

    test('Parses text meal description for opted-in user and creates formatted reply', () {
      final payload = WhatsAppMessagePayload(
        senderPhone: '+919876543210',
        type: WhatsAppMessageType.text,
        textBody: 'Paneer Tikka and Whole Wheat Roti',
        receivedAt: DateTime.now(),
      );

      final optedInState = WhatsAppUserLinkState(
        isOptedIn: true,
        linkedPhoneNumber: '+919876543210',
        linkedAt: DateTime.now(),
      );

      final result = engine.processIncomingMessage(
        payload: payload,
        userLinkState: optedInState,
      );

      expect(result.isSuccess, isTrue);
      expect(result.foodSummary, contains('Paneer Tikka'));
      expect(result.calories, greaterThan(0));
      expect(result.proteinG, greaterThan(0));
      expect(result.responseMessage, startsWith('Logged:'));
      expect(result.responseMessage, contains('kcal'));
      expect(result.responseMessage, contains('g protein'));
    });

    test('Parses image meal message and generates structured confirmation', () {
      final payload = WhatsAppMessagePayload(
        senderPhone: '+919876543210',
        type: WhatsAppMessageType.image,
        imageId: 'img_wh_48392',
        receivedAt: DateTime.now(),
      );

      final optedInState = WhatsAppUserLinkState(
        isOptedIn: true,
        linkedPhoneNumber: '+919876543210',
      );

      final result = engine.processIncomingMessage(
        payload: payload,
        userLinkState: optedInState,
      );

      expect(result.isSuccess, isTrue);
      expect(result.foodSummary, contains('Dal Tadka'));
      expect(result.calories, equals(450));
      expect(result.proteinG, equals(16.0));
      expect(result.responseMessage, contains('Logged: Dal Tadka, 2 Roti, Sabzi — 450 kcal, 16g protein'));
    });

    test('WhatsAppNotifier links, unlinks, and tracks logged count accurately', () {
      final notifier = WhatsAppNotifier();

      expect(notifier.state.isOptedIn, isFalse);

      // Link
      notifier.linkPhoneNumber('+919876543210');
      expect(notifier.state.isOptedIn, isTrue);
      expect(notifier.state.linkedPhoneNumber, equals('+919876543210'));

      // Ingest message
      final payload = WhatsAppMessagePayload(
        senderPhone: '+919876543210',
        type: WhatsAppMessageType.text,
        textBody: 'Poha with Peanuts',
        receivedAt: DateTime.now(),
      );

      final res = notifier.ingestMessage(payload);
      expect(res.isSuccess, isTrue);
      expect(notifier.state.totalWhatsAppLogs, equals(1));

      // Unlink
      notifier.unlinkWhatsApp();
      expect(notifier.state.isOptedIn, isFalse);
      expect(notifier.state.linkedPhoneNumber, isNull);
    });
  });
}
