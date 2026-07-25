/// §P13-C Affiliate Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'affiliate_models.dart';
import 'affiliate_tracking_engine.dart';

class AffiliateState {
  const AffiliateState({
    required this.activeLink,
    required this.ledgerEntries,
    required this.payoutHistory,
    required this.availableBalanceInr,
    required this.lifetimeEarningsInr,
    this.successMessage,
  });

  final ReferralLink activeLink;
  final List<AffiliateLedgerEntry> ledgerEntries;
  final List<AffiliatePayout> payoutHistory;
  final double availableBalanceInr;
  final double lifetimeEarningsInr;
  final String? successMessage;

  AffiliateState copyWith({
    ReferralLink? activeLink,
    List<AffiliateLedgerEntry>? ledgerEntries,
    List<AffiliatePayout>? payoutHistory,
    double? availableBalanceInr,
    double? lifetimeEarningsInr,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return AffiliateState(
      activeLink: activeLink ?? this.activeLink,
      ledgerEntries: ledgerEntries ?? this.ledgerEntries,
      payoutHistory: payoutHistory ?? this.payoutHistory,
      availableBalanceInr: availableBalanceInr ?? this.availableBalanceInr,
      lifetimeEarningsInr: lifetimeEarningsInr ?? this.lifetimeEarningsInr,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class AffiliateNotifier extends Notifier<AffiliateState> {
  late final AffiliateTrackingEngine _engine;

  @override
  AffiliateState build() {
    _engine = const AffiliateTrackingEngine();

    const initialLink = ReferralLink(
      linkId: 'ref_sharma10',
      creatorId: 'creator_1',
      referralCode: 'SHARMA10',
      clientDiscountPct: 10.0,
      creatorCommissionPct: 15.0,
      totalClicks: 4210,
      freeSignups: 1820,
      proConversions: 214,
    );

    final initialLedger = [
      AffiliateLedgerEntry(
        entryId: 'led_1',
        affiliateId: 'creator_1',
        source: AffiliateSource.creatorReferral,
        referenceId: 'sub_pro_101',
        description: 'FitKarma Pro Annual Subscription (15% Recurring)',
        grossAmountInr: 1999.0,
        commissionAmountInr: 299.85,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      AffiliateLedgerEntry(
        entryId: 'led_2',
        affiliateId: 'creator_1',
        source: AffiliateSource.groceryCheckout,
        referenceId: 'order_blk_8910',
        description: '🛒 Blinkit Grocery Checkout Order #BLK-8910 (3% Commission)',
        grossAmountInr: 1420.0,
        commissionAmountInr: 42.60,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];

    final initialPayouts = [
      AffiliatePayout(
        payoutId: 'pay_1',
        creatorId: 'creator_1',
        amountInr: 4820.0,
        periodStart: DateTime(2026, 5, 1),
        periodEnd: DateTime(2026, 5, 31),
        status: PayoutStatus.paid,
      ),
      AffiliatePayout(
        payoutId: 'pay_2',
        creatorId: 'creator_1',
        amountInr: 3600.0,
        periodStart: DateTime(2026, 4, 1),
        periodEnd: DateTime(2026, 4, 30),
        status: PayoutStatus.paid,
      ),
    ];

    return AffiliateState(
      activeLink: initialLink,
      ledgerEntries: initialLedger,
      payoutHistory: initialPayouts,
      availableBalanceInr: 8420.0,
      lifetimeEarningsInr: 16840.0,
    );
  }

  void createCustomReferralCode(String code) {
    final newLink = _engine.generateLink(
      creatorId: state.activeLink.creatorId,
      referralCode: code,
    );
    state = state.copyWith(
      activeLink: newLink,
      successMessage: '🔗 Referral code updated to "${newLink.referralCode}"!',
    );
  }

  void trackClick() {
    final updated = _engine.trackClick(state.activeLink);
    state = state.copyWith(activeLink: updated);
  }

  void trackProSubscriptionConversion(double grossAmountInr) {
    final result = _engine.trackSubscriptionConversion(
      link: state.activeLink,
      grossAmountInr: grossAmountInr,
      subscriptionId: 'sub_${DateTime.now().millisecondsSinceEpoch}',
    );

    final updatedBalance = state.availableBalanceInr + result.ledgerEntry.commissionAmountInr;
    final updatedLifetime = state.lifetimeEarningsInr + result.ledgerEntry.commissionAmountInr;

    state = state.copyWith(
      activeLink: result.updatedLink,
      ledgerEntries: [result.ledgerEntry, ...state.ledgerEntries],
      availableBalanceInr: updatedBalance,
      lifetimeEarningsInr: updatedLifetime,
      successMessage: '🎉 New Pro Referral Conversion! +₹${result.ledgerEntry.commissionAmountInr.toStringAsFixed(2)} credited.',
    );
  }

  /// 🆕 Reused by §P16-E Grocery Vendor Checkout for affiliate revenue tracking.
  void trackGroceryVendorConversion(String vendorName, String orderId, double orderTotalInr) {
    final entry = _engine.trackGroceryAffiliateOrder(
      affiliateId: state.activeLink.creatorId,
      vendorName: vendorName,
      orderId: orderId,
      orderTotalInr: orderTotalInr,
    );

    final updatedBalance = state.availableBalanceInr + entry.commissionAmountInr;
    final updatedLifetime = state.lifetimeEarningsInr + entry.commissionAmountInr;

    state = state.copyWith(
      ledgerEntries: [entry, ...state.ledgerEntries],
      availableBalanceInr: updatedBalance,
      lifetimeEarningsInr: updatedLifetime,
      successMessage: '🛒 $vendorName Grocery Affiliate Order Commission (+₹${entry.commissionAmountInr.toStringAsFixed(2)}) recorded!',
    );
  }

  void requestInstantPayout() {
    if (state.availableBalanceInr <= 0) return;

    final newPayout = AffiliatePayout(
      payoutId: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      creatorId: state.activeLink.creatorId,
      amountInr: state.availableBalanceInr,
      periodStart: DateTime.now().subtract(const Duration(days: 30)),
      periodEnd: DateTime.now(),
      status: PayoutStatus.processed,
    );

    state = state.copyWith(
      availableBalanceInr: 0.0,
      payoutHistory: [newPayout, ...state.payoutHistory],
      successMessage: '💸 Instant bank payout request submitted for ₹${newPayout.amountInr.toStringAsFixed(2)}!',
    );
  }
}

final affiliateProvider =
    NotifierProvider<AffiliateNotifier, AffiliateState>(
  AffiliateNotifier.new,
);
