import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/affiliate_engine.dart';
import 'package:fitkarma/features/premium/models/creator_affiliate_models.dart';
import 'package:fitkarma/features/premium/providers/affiliate_provider.dart';

void main() {
  group('§P13-C Creator Affiliate Engine Tests (Pure Dart)', () {
    const engine = AffiliateEngine();

    test('Calculates 15% recurring affiliate commission accurately', () {
      // Annual plan: ₹1,999 -> 15% = ₹299.85
      final annualCommission =
          engine.calculateCommission(saleAmountInr: 1999.0);
      expect(annualCommission, equals(299.85));

      // Monthly plan: ₹299 -> 15% = ₹44.85
      final monthlyCommission =
          engine.calculateCommission(saleAmountInr: 299.0);
      expect(monthlyCommission, equals(44.85));
    });

    test('Calculates 10% client referral discount accurately', () {
      final annualDiscount =
          engine.calculateDiscount(originalAmountInr: 1999.0);
      expect(annualDiscount, equals(199.90));
    });

    test('Calculates click-to-pro conversion rate percentage', () {
      final rate = engine.calculateConversionRate(
        totalClicks: 4210,
        proConversions: 214,
      );
      expect(rate, equals(5.1)); // 214 / 4210 = 5.083% -> 5.1%
    });

    test(
        'processInstantPayout generates a new paid entry and zeroes available balance',
        () {
      final initialStats = AffiliateStats(
        availableBalanceInr: 8420.0,
        nextPayoutDate: DateTime(2026, 6, 15),
        totalClicks: 4210,
        freeSignups: 1820,
        proConversions: 214,
        payoutHistory: const [],
      );

      final updated = engine.processInstantPayout(
        currentStats: initialStats,
        creatorId: 'creator_sharma',
      );

      expect(updated.availableBalanceInr, equals(0.0));
      expect(updated.payoutHistory.length, equals(1));
      expect(updated.payoutHistory.first.amountInr, equals(8420.0));
      expect(updated.payoutHistory.first.status, equals(PayoutStatus.paid));
    });

    test(
        'AffiliateNotifier updates referral promo code and processes bank transfers',
        () async {
      final notifier = AffiliateNotifier(engine);

      expect(notifier.state.referralLink.referralCode, equals('SHARMA10'));
      expect(notifier.state.referralLink.fullUrl,
          equals('fitkarma.com/ref/sharma10'));
      expect(notifier.state.stats.availableBalanceInr, equals(8420.0));

      // Update code
      notifier.updateReferralCode('fitdelhi');
      expect(notifier.state.referralLink.referralCode, equals('FITDELHI'));
      expect(notifier.state.referralLink.fullUrl,
          equals('fitkarma.com/ref/fitdelhi'));

      // Instant bank transfer
      await notifier.requestInstantBankTransfer();
      expect(notifier.state.stats.availableBalanceInr, equals(0.0));
      expect(notifier.state.stats.payoutHistory.length, equals(3));
      expect(notifier.state.statusMessage, contains('Instant transfer'));
    });
  });
}
