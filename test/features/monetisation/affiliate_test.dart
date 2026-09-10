import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/monetisation/domain/affiliate_engine.dart';
import 'package:fitkarma/features/monetisation/domain/affiliate_models.dart';
import 'package:fitkarma/features/monetisation/presentation/providers/affiliate_provider.dart';

void main() {
  group('AffiliateEngine Deterministic Tests', () {
    const engine = AffiliateEngine();

    test('Calculates tier-based commissions accurately in INR', () {
      expect(
          engine.calculateCommission(
              tier: AffiliateTier.bronze, orderAmountInr: 3999),
          equals(600)); // 15%
      expect(
          engine.calculateCommission(
              tier: AffiliateTier.silver, orderAmountInr: 3999),
          equals(800)); // 20%
      expect(
          engine.calculateCommission(
              tier: AffiliateTier.gold, orderAmountInr: 3999),
          equals(1000)); // 25%
      expect(
          engine.calculateCommission(
              tier: AffiliateTier.platinum, orderAmountInr: 3999),
          equals(1200)); // 30%
    });

    test('Resolves tier promotions accurately based on conversion counts', () {
      expect(engine.resolveTier(0), equals(AffiliateTier.bronze));
      expect(engine.resolveTier(10), equals(AffiliateTier.bronze));
      expect(engine.resolveTier(11), equals(AffiliateTier.silver));
      expect(engine.resolveTier(50), equals(AffiliateTier.silver));
      expect(engine.resolveTier(51), equals(AffiliateTier.gold));
      expect(engine.resolveTier(200), equals(AffiliateTier.gold));
      expect(engine.resolveTier(201), equals(AffiliateTier.platinum));
      expect(engine.resolveTier(500), equals(AffiliateTier.platinum));
    });

    test('Recording referral conversion promotes tier and accumulates earnings',
        () {
      const initialProfile = AffiliateProfile(
        affiliateId: 'test_creator',
        creatorName: 'Aman',
        referralCode: 'AMAN20',
        customLink: 'https://fitkarma.in/ref/aman20',
        tier: AffiliateTier.bronze,
        totalClicks: 30,
        totalConversions: 10,
        totalEarningsInr: 5000,
        pendingPayoutInr: 1000,
        paidOutInr: 4000,
        upiId: 'aman@upi',
        recentReferrals: [],
      );

      final updated = engine.recordConversion(
        initialProfile,
        planOrProgramPurchased: 'FitKarma Pro Annual',
        orderAmountInr: 4000,
      );

      expect(updated.totalConversions, equals(11));
      expect(updated.tier, equals(AffiliateTier.silver)); // Promoted to Silver!
      expect(
          updated.totalEarningsInr, equals(5600)); // 5000 + (15% of 4000 = 600)
      expect(updated.pendingPayoutInr, equals(1600));
      expect(updated.recentReferrals.length, equals(1));
    });

    test('Processes payout and resets pending balance to zero', () {
      final profileWithPending = AffiliateEngine.sampleProfile();
      expect(profileWithPending.pendingPayoutInr, greaterThan(0));

      final initialPaidOut = profileWithPending.paidOutInr;
      final pendingAmount = profileWithPending.pendingPayoutInr;

      final clearedProfile = engine.processPayout(profileWithPending);

      expect(clearedProfile.pendingPayoutInr, equals(0));
      expect(clearedProfile.paidOutInr, equals(initialPaidOut + pendingAmount));
      expect(
          clearedProfile.recentReferrals
              .every((r) => r.status == PayoutStatus.paidOut),
          isTrue);
    });
  });

  group('Affiliate StateNotifier Provider Tests', () {
    test(
        'StateNotifier updates UPI ID, referral code, and simulates referral attribution',
        () async {
      final notifier = AffiliateNotifier();

      expect(notifier.state.profile.referralCode, equals('VIKRAM20'));

      notifier.updateUpiId('new.creator@icici');
      expect(notifier.state.profile.upiId, equals('new.creator@icici'));

      notifier.updateReferralCode('FITPRO50');
      expect(notifier.state.profile.referralCode, equals('FITPRO50'));
      expect(notifier.state.profile.customLink, contains('fitpro50'));

      final initialConversions = notifier.state.profile.totalConversions;
      notifier.simulateReferralSale(
        plan: '12-Week Desi Muscle Hypertrophy Program',
        amount: 2499,
      );

      expect(notifier.state.profile.totalConversions,
          equals(initialConversions + 1));
      expect(
          notifier.state.successMessage, contains('New referral attributed'));

      await notifier.requestPayout();
      expect(notifier.state.profile.pendingPayoutInr, equals(0));
      expect(
          notifier.state.successMessage, contains('transferred successfully'));
    });
  });
}
