import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/premium_billing_engine.dart';

void main() {
  group('PremiumBillingEngine Entitlement Guard Tests', () {
    const engine = PremiumBillingEngine();

    test('Free tier user gets Free Tier entitlement label and inactive Pro status', () {
      final res = engine.checkEntitlement(
        hasActiveSubscription: false,
        isTrialActive: false,
      );

      expect(res.isProActive, isFalse);
      expect(res.isInFreeTrial, isFalse);
      expect(res.entitlementLabel, equals('Free Tier'));
    });

    test('7-Day free trial user gets active Pro status in trial mode', () {
      final res = engine.checkEntitlement(
        hasActiveSubscription: false,
        isTrialActive: true,
      );

      expect(res.isProActive, isTrue);
      expect(res.isInFreeTrial, isTrue);
      expect(res.entitlementLabel, equals('7-Day Free Trial'));
    });

    test('Subscribed user gets active Pro status', () {
      final res = engine.checkEntitlement(
        hasActiveSubscription: true,
        isTrialActive: false,
      );

      expect(res.isProActive, isTrue);
      expect(res.isInFreeTrial, isFalse);
      expect(res.entitlementLabel, equals('Pro Subscriber'));
    });
  });
}
