/// §P16-A WhatsApp Business Logging — Unit & Widget Tests

import 'package:fitkarma/features/whatsapp/whatsapp_controller.dart';
import 'package:fitkarma/features/whatsapp/whatsapp_models.dart';
import 'package:fitkarma/features/whatsapp/whatsapp_settings_screen.dart';
import 'package:fitkarma/features/whatsapp/whatsapp_webhook_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = WhatsAppWebhookService();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: WhatsAppSettingsScreen(),
      ),
    );
  }

  group('§P16-A WhatsAppWebhookService Unit Tests', () {
    test('resolves phone number to userId when whatsAppOptIn is true', () {
      final users = [
        const WhatsAppUserBinding(
          userId: 'usr_1',
          phoneNumber: '+919876543210',
          whatsAppOptIn: true,
        ),
        const WhatsAppUserBinding(
          userId: 'usr_2',
          phoneNumber: '+919876543211',
          whatsAppOptIn: false,
        ),
      ];

      final resolvedOptedIn = service.resolveUserByPhone(
        phoneNumber: '+919876543210',
        registeredUsers: users,
      );
      final resolvedOptedOut = service.resolveUserByPhone(
        phoneNumber: '+919876543211',
        registeredUsers: users,
      );

      expect(resolvedOptedIn, isNotNull);
      expect(resolvedOptedIn!.userId, equals('usr_1'));
      expect(resolvedOptedOut, isNull); // Opted out user is not resolved!
    });

    test('returns unlinked fallback message for unregistered or non-opted-in numbers', () async {
      final users = <WhatsAppUserBinding>[];
      const message = WhatsAppMessage(
        messageId: 'msg_1',
        fromPhoneNumber: '+919999999999',
        type: WhatsAppMessageType.text,
        textBody: '2 roti, dal',
      );

      final reply = await service.processIncomingWebhook(
        message: message,
        registeredUsers: users,
      );

      expect(reply, contains("This number isn't linked to a FitKarma account yet"));
      expect(reply, contains('Settings → Link WhatsApp'));
    });

    test('parses text messages and returns 1-line WhatsApp reply confirmation', () async {
      final users = [
        const WhatsAppUserBinding(
          userId: 'usr_1',
          phoneNumber: '+919876543210',
          whatsAppOptIn: true,
        ),
      ];
      const message = WhatsAppMessage(
        messageId: 'msg_2',
        fromPhoneNumber: '+919876543210',
        type: WhatsAppMessageType.text,
        textBody: '2 roti, dal, sabzi',
      );

      final reply = await service.processIncomingWebhook(
        message: message,
        registeredUsers: users,
      );

      expect(reply, contains('Logged: 2 roti, dal, sabzi'));
      expect(reply, contains('420 kcal'));
      expect(reply, contains('14g protein'));
    });

    test('routes image messages to meal_photo_analyzer (§P5-C) Groq Vision pipeline', () async {
      final users = [
        const WhatsAppUserBinding(
          userId: 'usr_1',
          phoneNumber: '+919876543210',
          whatsAppOptIn: true,
        ),
      ];
      const message = WhatsAppMessage(
        messageId: 'msg_3',
        fromPhoneNumber: '+919876543210',
        type: WhatsAppMessageType.image,
        imageId: 'img_plate_99',
      );

      final reply = await service.processIncomingWebhook(
        message: message,
        registeredUsers: users,
      );

      expect(reply, contains('Logged: Grilled Chicken Salad & Paneer Bowl'));
      expect(reply, contains('480 kcal'));
      expect(reply, contains('32g protein'));
    });
  });

  group('§P16-A WhatsAppNotifier Integration Tests', () {
    test('initializes with whatsAppOptIn OFF by default (§P16-A spec)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(whatsAppProvider);

      expect(state.isOptedIn, isFalse);
      expect(state.isPhoneVerified, isFalse);
    });

    test('linking phone number enables whatsAppOptIn and sets verified state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(whatsAppProvider.notifier);

      notifier.linkPhoneNumber('+919876543210');
      final state = container.read(whatsAppProvider);

      expect(state.isOptedIn, isTrue);
      expect(state.linkedPhoneNumber, equals('+919876543210'));
      expect(state.isPhoneVerified, isTrue);
    });

    test('unlinking WhatsApp disables opt-in and resets phone number', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(whatsAppProvider.notifier);

      notifier.linkPhoneNumber('+919876543210');
      notifier.unlinkWhatsApp();
      final state = container.read(whatsAppProvider);

      expect(state.isOptedIn, isFalse);
      expect(state.linkedPhoneNumber, isNull);
    });
  });

  group('§P16-A WhatsAppSettingsScreen Widget Tests', () {
    testWidgets('renders screen header, opt-in switch (off by default), and phone input', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('💬 Link WhatsApp Logging'), findsOneWidget);
      expect(find.text('Log Meals via WhatsApp'), findsOneWidget);
      expect(find.text('WhatsApp Logging (Opt-In)'), findsOneWidget);
      expect(find.text('⚠️ UNLINKED'), findsOneWidget);
      expect(find.text('Link Phone Number'), findsOneWidget);
    });

    testWidgets('links phone number and tests text message webhook simulation', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link Phone Number'));
      await tester.pumpAndSettle();

      expect(find.text('✓ LINKED'), findsOneWidget);

      final sendBtnFinder = find.text('Send Text Msg');
      await tester.ensureVisible(sendBtnFinder);
      await tester.tap(sendBtnFinder);
      await tester.pumpAndSettle();

      expect(find.textContaining('Logged: 2 roti, dal, sabzi'), findsOneWidget);
    });
  });
}
