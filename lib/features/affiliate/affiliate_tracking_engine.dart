/// §P13-C Creator Affiliate Tracking Engine & Revenue Ledger Processor
///
/// Handles referral link generation, click/conversion tracking, 15% recurring Pro subscription payouts,
/// and 🆕 §P16-E Grocery Vendor Checkout affiliate commission tracking matching §P13-C & §P16-E specs.
library;

import 'affiliate_models.dart';

class SubscriptionConversionResult {
  const SubscriptionConversionResult({
    required this.updatedLink,
    required this.ledgerEntry,
  });

  final ReferralLink updatedLink;
  final AffiliateLedgerEntry ledgerEntry;
}

class AffiliateTrackingEngine {
  const AffiliateTrackingEngine();

  /// Generates a new referral link for a creator (§P13-C spec).
  ReferralLink generateLink({
    required String creatorId,
    required String referralCode,
    double clientDiscountPct = 10.0,
    double creatorCommissionPct = 15.0,
  }) {
    final linkId = 'ref_${referralCode.toLowerCase()}';
    return ReferralLink(
      linkId: linkId,
      creatorId: creatorId,
      referralCode: referralCode.toUpperCase(),
      clientDiscountPct: clientDiscountPct,
      creatorCommissionPct: creatorCommissionPct,
    );
  }

  /// Tracks a referral link click.
  ReferralLink trackClick(ReferralLink link) {
    return ReferralLink(
      linkId: link.linkId,
      creatorId: link.creatorId,
      referralCode: link.referralCode,
      clientDiscountPct: link.clientDiscountPct,
      creatorCommissionPct: link.creatorCommissionPct,
      totalClicks: link.totalClicks + 1,
      freeSignups: link.freeSignups,
      proConversions: link.proConversions,
    );
  }

  /// Tracks a free signup conversion.
  ReferralLink trackSignup(ReferralLink link) {
    return ReferralLink(
      linkId: link.linkId,
      creatorId: link.creatorId,
      referralCode: link.referralCode,
      clientDiscountPct: link.clientDiscountPct,
      creatorCommissionPct: link.creatorCommissionPct,
      totalClicks: link.totalClicks,
      freeSignups: link.freeSignups + 1,
      proConversions: link.proConversions,
    );
  }

  /// Tracks a Pro subscription conversion & creates recurring payout ledger entry (§P13-C spec).
  SubscriptionConversionResult trackSubscriptionConversion({
    required ReferralLink link,
    required double grossAmountInr,
    required String subscriptionId,
  }) {
    final commission = grossAmountInr * (link.creatorCommissionPct / 100.0);
    final entryId = 'led_${DateTime.now().millisecondsSinceEpoch}';

    final updatedLink = ReferralLink(
      linkId: link.linkId,
      creatorId: link.creatorId,
      referralCode: link.referralCode,
      clientDiscountPct: link.clientDiscountPct,
      creatorCommissionPct: link.creatorCommissionPct,
      totalClicks: link.totalClicks,
      freeSignups: link.freeSignups,
      proConversions: link.proConversions + 1,
    );

    final entry = AffiliateLedgerEntry(
      entryId: entryId,
      affiliateId: link.creatorId,
      source: AffiliateSource.creatorReferral,
      referenceId: subscriptionId,
      description: 'FitKarma Pro Subscription (${link.referralCode} - ${link.creatorCommissionPct.toInt()}% Recurring)',
      grossAmountInr: grossAmountInr,
      commissionAmountInr: commission,
      timestamp: DateTime.now(),
    );

    return SubscriptionConversionResult(
      updatedLink: updatedLink,
      ledgerEntry: entry,
    );
  }

  /// 🆕 Reused by §P16-E Grocery Vendor Checkout for affiliate revenue tracking (§P13-C / §P16-E spec).
  ///
  /// Tracks grocery order conversions (Blinkit, Zepto, Instamart) and appends earnings to affiliate ledger.
  AffiliateLedgerEntry trackGroceryAffiliateOrder({
    required String affiliateId,
    required String vendorName,
    required String orderId,
    required double orderTotalInr,
    double commissionRatePct = 3.0, // Default 3% grocery affiliate commission
  }) {
    final commission = orderTotalInr * (commissionRatePct / 100.0);
    final entryId = 'groc_led_${DateTime.now().millisecondsSinceEpoch}';

    return AffiliateLedgerEntry(
      entryId: entryId,
      affiliateId: affiliateId,
      source: AffiliateSource.groceryCheckout,
      referenceId: orderId,
      description: '🛒 $vendorName Grocery Checkout Order ($orderId - ${commissionRatePct.toInt()}% Commission)',
      grossAmountInr: orderTotalInr,
      commissionAmountInr: commission,
      timestamp: DateTime.now(),
    );
  }
}
