import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/whatsapp_logging/domain/whatsapp_engine.dart';
import 'package:fitkarma/features/whatsapp_logging/domain/whatsapp_models.dart';
import 'package:fitkarma/features/whatsapp_logging/providers/whatsapp_provider.dart';

void main() {
  group('WhatsAppEngine Deterministic Tests', () {
    const engine = WhatsAppEngine();

    test('Normalizes Indian mobile numbers correctly to E.164', () {
      expect(WhatsAppEngine.normalizeIndianPhoneNumber('9876543210'), equals('+919876543210'));
      expect(WhatsAppEngine.normalizeIndianPhoneNumber('+919876543210'), equals('+919876543210'));
      expect(WhatsAppEngine.normalizeIndianPhoneNumber('919876543210'), equals('+919876543210'));
      expect(WhatsAppEngine.normalizeIndianPhoneNumber('12345'), isNull);
    });

    test('Generates deterministic 6-digit OTP and verifies accurately', () {
      final otp = engine.generateVerificationOtp('+919876543210');
      expect(otp.length, equals(6));
      expect(int.tryParse(otp), isNotNull);
      expect(engine.verifyOtp(enteredOtp: otp, expectedOtp: otp), isTrue);
      expect(engine.verifyOtp(enteredOtp: '000000', expectedOtp: otp), isFalse);
    });

    test('Parses natural Indian meal messages with macros and calories', () {
      final parsed = engine.parseInboundMessage('2 roti, 1 bowl dal tadka, cucumber salad');
      expect(parsed.logType, equals(WhatsAppLogType.meal));
      expect(parsed.identifiedItems.length, greaterThanOrEqualTo(2));
      expect(parsed.calories, greaterThan(300.0));
      expect(parsed.proteinGrams, greaterThan(10.0));
      expect(parsed.fiberGrams, greaterThan(5.0));

      final replyEn = engine.formatBotReply(parsed, language: 'en');
      expect(replyEn, contains('FitKarma Logged!'));
      expect(replyEn, contains('Shatapadi'));

      final replyHi = engine.formatBotReply(parsed, language: 'hi');
      expect(replyHi, contains('फिटकर्मा भोजन दर्ज!'));
    });

    test('Parses hydration water logs across various units', () {
      final p1 = engine.parseInboundMessage('500ml water');
      expect(p1.logType, equals(WhatsAppLogType.water));
      expect(p1.waterMl, equals(500));

      final p2 = engine.parseInboundMessage('2 glasses of paani');
      expect(p2.logType, equals(WhatsAppLogType.water));
      expect(p2.waterMl, equals(500));

      final p3 = engine.parseInboundMessage('1.5 liter coconut water');
      expect(p3.logType, equals(WhatsAppLogType.water));
      expect(p3.waterMl, equals(1500));
    });

    test('Parses workout, steps, and weight logs accurately', () {
      final w1 = engine.parseInboundMessage('Walked 45 mins 4500 steps');
      expect(w1.logType, equals(WhatsAppLogType.workout));
      expect(w1.workoutDurationMinutes, equals(45));
      expect(w1.stepsCount, equals(4500));
      expect(w1.calories, greaterThan(150.0));

      final wt = engine.parseInboundMessage('weight 73.5 kg');
      expect(wt.logType, equals(WhatsAppLogType.weight));
      expect(wt.weightKg, equals(73.5));
    });

    test('Constructs interactive Meta Business Cloud API template payloads', () {
      final payload = engine.buildInteractiveTemplatePayload(
        templateType: WhatsAppTemplateType.morningReadiness,
        recipientPhone: '+919876543210',
      );

      expect(payload['messaging_product'], equals('whatsapp'));
      expect(payload['to'], equals('+919876543210'));
      expect(payload['type'], equals('interactive'));
      expect(payload['interactive']['action']['buttons'].length, equals(2));
    });
  });

  group('WhatsAppLoggingNotifier State Tests', () {
    test('Simulates OTP linking flow and conversational messaging', () {
      final notifier = WhatsAppLoggingNotifier();
      expect(notifier.state.profile.linkStatus, equals(WhatsAppLinkStatus.activeLinked));

      // Initiate linking on new phone
      notifier.initiatePhoneLinking('9876543210');
      expect(notifier.state.profile.linkStatus, equals(WhatsAppLinkStatus.pendingVerification));
      expect(notifier.state.profile.verificationOtp, isNotNull);

      final otp = notifier.state.profile.verificationOtp!;
      final success = notifier.confirmOtp(otp);
      expect(success, isTrue);
      expect(notifier.state.profile.linkStatus, equals(WhatsAppLinkStatus.activeLinked));

      // Simulate Inbound WhatsApp meal
      final initialCount = notifier.state.messageHistory.length;
      notifier.simulateInboundMessage('1 plate chicken biryani');
      expect(notifier.state.messageHistory.length, equals(initialCount + 1));
      expect(notifier.state.messageHistory.first.parsedEntity?.calories, greaterThan(400.0));

      // Toggle preferences
      notifier.togglePreference(morningBriefing: false);
      expect(notifier.state.profile.enableMorningBriefing, isFalse);

      // Unlink
      notifier.unlinkAccount();
      expect(notifier.state.profile.linkStatus, equals(WhatsAppLinkStatus.unlinked));
    });
  });
}
