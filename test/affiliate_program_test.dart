/// §P13-C & §P16-E Creator Affiliate Program — Unit, Integration & Widget Tests

import 'package:fitkarma/features/affiliate/affiliate_controller.dart';
import 'package:fitkarma/features/affiliate/affiliate_dashboard_screen.dart';
import 'package:fitkarma/features/affiliate/affiliate_models.dart';
import 'package:fitkarma/features/affiliate/affiliate_tracking_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const engine = AffiliateTrackingEngine();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: AffiliateDashboardScreen(),
      ),
    );
  }

  group('§P13-C AffiliateTrackingEngine Unit Tests', () {
    test('generates referral link with proper shareUrl and default commission rates', () {
      final link = engine.generateLink(
        creatorId: 'creator_1',
        referralCode: 'SHARMA10',
      );

      expect(link.referralCode, equals('SHARMA10'));
      expect(link.clientDiscountPct, equals(10.0));
      expect(link.creatorCommissionPct, equals(15.0));
      expect(link.shareUrl, equals('https://fitkarma.in/ref/sharma10'));
    });

    test('tracks clicks and free signups correctly', () {
      var link = engine.generateLink(creatorId: 'c1', referralCode: 'FIT10');
      link = engine.trackClick(link);
      link = engine.trackSignup(link);

      expect(link.totalClicks, equals(1));
      expect(link.freeSignups, equals(1));
    });

    test('tracks Pro subscription conversion with 15% recurring commission', () {
      final link = engine.generateLink(creatorId: 'c1', referralCode: 'FIT10');
      final result = engine.trackSubscriptionConversion(
        link: link,
        grossAmountInr: 1999.0,
        subscriptionId: 'sub_101',
      );

      expect(result.updatedLink.proConversions, equals(1));
      expect(result.ledgerEntry.source, equals(AffiliateSource.creatorReferral));
      expect(result.ledgerEntry.commissionAmountInr, closeTo(299.85, 0.01)); // 15% of 1999
    });

    test('🆕 §P16-E Grocery Vendor Checkout affiliate tracking records 3% commission', () {
      final entry = engine.trackGroceryAffiliateOrder(
        affiliateId: 'creator_1',
        vendorName: 'Blinkit',
        orderId: 'order_blk_99',
        orderTotalInr: 1000.0,
        commissionRatePct: 3.0,
      );

      expect(entry.source, equals(AffiliateSource.groceryCheckout));
      expect(entry.grossAmountInr, equals(1000.0));
      expect(entry.commissionAmountInr, equals(30.0)); // 3% of 1000
    });
  });

  group('§P13-C AffiliateNotifier Integration Tests', () {
    test('updates custom referral code correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(affiliateProvider.notifier);
      notifier.createCustomReferralCode('VIP20');

      final state = container.read(affiliateProvider);
      expect(state.activeLink.referralCode, equals('VIP20'));
      expect(state.successMessage, contains('VIP20'));
    });

    test('tracks Pro subscription conversion and updates balance & lifetime earnings', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(affiliateProvider.notifier);
      final initialBalance = container.read(affiliateProvider).availableBalanceInr;

      notifier.trackProSubscriptionConversion(1000.0); // 15% = +150 INR
      final state = container.read(affiliateProvider);

      expect(state.availableBalanceInr, equals(initialBalance + 150.0));
      expect(state.ledgerEntries.first.commissionAmountInr, equals(150.0));
    });

    test('🆕 §P16-E tracks grocery vendor conversion and appends to ledger', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(affiliateProvider.notifier);
      final initialBalance = container.read(affiliateProvider).availableBalanceInr;

      notifier.trackGroceryVendorConversion('Zepto', 'zep_777', 2000.0); // 3% = +60 INR
      final state = container.read(affiliateProvider);

      expect(state.availableBalanceInr, equals(initialBalance + 60.0));
      expect(state.ledgerEntries.first.description, contains('Zepto Grocery'));
    });

    test('requestInstantPayout resets available balance and appends payout entry', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(affiliateProvider.notifier);
      notifier.requestInstantPayout();

      final state = container.read(affiliateProvider);

      expect(state.availableBalanceInr, equals(0.0));
      expect(state.payoutHistory, isNotEmpty);
      expect(state.successMessage, contains('Instant bank payout request submitted'));
    });
  });

  group('§P13-C AffiliateDashboardScreen Widget Tests', () {
    testWidgets('renders Creator Earnings title, available balance, referral code, and analytics grid', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('💰 Creator Earnings Center'), findsOneWidget);
      expect(find.text('Available Balance'), findsOneWidget);
      expect(find.text('YOUR CODE: SHARMA10'), findsOneWidget);
      expect(find.text('📈 Lifetime Referral Performance'), findsOneWidget);
      expect(find.text('Copy Link'), findsOneWidget);
    });

    testWidgets('taps Copy Link and verifies SnackBar feedback', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Copy Link'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Referral link copied'), findsOneWidget);
    });
  });
}
