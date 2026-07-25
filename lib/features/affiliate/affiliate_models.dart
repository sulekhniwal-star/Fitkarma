/// §P13-C Creator Affiliate Program — Domain Models
///
/// Models for ReferralLink, AffiliateLedgerEntry, AffiliatePayout, and AffiliateSource matching §P13-C & §P16-E specs.
library;

enum PayoutStatus { calculated, processed, paid }

enum AffiliateSource {
  creatorReferral, // 15% recurring Pro subscription commission
  groceryCheckout, // Reused by §P16-E Grocery Vendor Checkout (Blinkit/Instamart/Zepto)
}

class ReferralLink {
  const ReferralLink({
    required this.linkId,
    required this.creatorId,
    required this.referralCode,
    this.clientDiscountPct = 10.0,
    this.creatorCommissionPct = 15.0,
    this.totalClicks = 0,
    this.freeSignups = 0,
    this.proConversions = 0,
  });

  final String linkId;
  final String creatorId;
  final String referralCode; // e.g., "SHARMA10"
  final double clientDiscountPct; // default 10% off
  final double creatorCommissionPct; // default 15% recurring
  final int totalClicks;
  final int freeSignups;
  final int proConversions;

  String get shareUrl => 'https://fitkarma.in/ref/${referralCode.toLowerCase()}';

  double get conversionRate =>
      freeSignups > 0 ? (proConversions / freeSignups) * 100.0 : 0.0;
}

class AffiliateLedgerEntry {
  const AffiliateLedgerEntry({
    required this.entryId,
    required this.affiliateId,
    required this.source,
    required this.referenceId,
    required this.description,
    required this.grossAmountInr,
    required this.commissionAmountInr,
    required this.timestamp,
    this.isPaid = false,
  });

  final String entryId;
  final String affiliateId;
  final AffiliateSource source;
  final String referenceId; // Pro subscription ID or Grocery order ID
  final String description;
  final double grossAmountInr;
  final double commissionAmountInr;
  final DateTime timestamp;
  final bool isPaid;
}

class AffiliatePayout {
  const AffiliatePayout({
    required this.payoutId,
    required this.creatorId,
    required this.amountInr,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
  });

  final String payoutId;
  final String creatorId;
  final double amountInr;
  final DateTime periodStart;
  final DateTime periodEnd;
  final PayoutStatus status;
}
