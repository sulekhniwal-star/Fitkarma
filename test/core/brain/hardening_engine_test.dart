import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/hardening_engine.dart';

void main() {
  group('HardeningEngine Performance & Security Tests', () {
    const engine = HardeningEngine();

    test('Glass blur is disabled on DeviceTier.low for optimal frame rate', () {
      expect(engine.shouldDisableGlassBlur(deviceTier: 'low'), isTrue);
      expect(engine.shouldDisableGlassBlur(deviceTier: 'high'), isFalse);
    });

    test('Sentry PII stripping redacts emails and phone numbers', () {
      const raw = 'Error for user test@fitkarma.in with phone +919876543210';
      final clean = engine.stripPiiFromLog(raw);

      expect(clean, contains('[REDACTED_EMAIL]'));
      expect(clean, contains('[REDACTED_PHONE]'));
      expect(clean, isNot(contains('test@fitkarma.in')));
    });

    test('DLQ banner displays after 3 consecutive sync failures', () {
      expect(engine.shouldShowDlqBanner(2), isFalse);
      expect(engine.shouldShowDlqBanner(3), isTrue);
      expect(engine.shouldShowDlqBanner(5), isTrue);
    });
  });
}
