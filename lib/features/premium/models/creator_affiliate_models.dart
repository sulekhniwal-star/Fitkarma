// §P13-C Creator Affiliate Program Models (NEW v1)
// Cross-reference: §P13-C in Fitkarma_documentation.md

enum PayoutStatus {
  calculated,
  processed,
  paid;

  String get displayName {
    switch (this) {
      case PayoutStatus.calculated:
        return 'Calculated';
      case PayoutStatus.processed:
        return 'Processing';
      case PayoutStatus.paid:
        return '✓ Paid';
    }
  }
}

class ReferralLink {
  final String linkId;
  final String creatorId;
  final String referralCode; // e.g., "SHARMA10"
  final double clientDiscountPct; // default 10% off
  final double creatorCommissionPct; // default 15% recurring

  const ReferralLink({
    required this.linkId,
    required this.creatorId,
    required this.referralCode,
    this.clientDiscountPct = 0.10,
    this.creatorCommissionPct = 0.15,
  });

  String get fullUrl => 'fitkarma.com/ref/${referralCode.toLowerCase()}';
}

class AffiliatePayout {
  final String payoutId;
  final String creatorId;
  final double amountInr;
  final DateTime periodStart;
  final DateTime periodEnd;
  final PayoutStatus status;

  const AffiliatePayout({
    required this.payoutId,
    required this.creatorId,
    required this.amountInr,
    required this.periodStart,
    required this.periodEnd,
    this.status = PayoutStatus.paid,
  });

  String get formattedAmount => '₹${amountInr.toStringAsFixed(0)}';

  String get periodLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthName = months[periodStart.month - 1];
    return '$monthName ${periodStart.year}';
  }
}

class AffiliateStats {
  final double availableBalanceInr;
  final DateTime nextPayoutDate;
  final int totalClicks;
  final int freeSignups;
  final int proConversions;
  final List<AffiliatePayout> payoutHistory;

  const AffiliateStats({
    required this.availableBalanceInr,
    required this.nextPayoutDate,
    required this.totalClicks,
    required this.freeSignups,
    required this.proConversions,
    required this.payoutHistory,
  });

  double get conversionRate =>
      totalClicks > 0 ? (proConversions / totalClicks) * 100 : 0.0;

  String get formattedBalance => '₹${availableBalanceInr.toStringAsFixed(0)}';

  String get formattedConversionRate => '${conversionRate.toStringAsFixed(1)}%';

  AffiliateStats copyWith({
    double? availableBalanceInr,
    DateTime? nextPayoutDate,
    int? totalClicks,
    int? freeSignups,
    int? proConversions,
    List<AffiliatePayout>? payoutHistory,
  }) {
    return AffiliateStats(
      availableBalanceInr: availableBalanceInr ?? this.availableBalanceInr,
      nextPayoutDate: nextPayoutDate ?? this.nextPayoutDate,
      totalClicks: totalClicks ?? this.totalClicks,
      freeSignups: freeSignups ?? this.freeSignups,
      proConversions: proConversions ?? this.proConversions,
      payoutHistory: payoutHistory ?? this.payoutHistory,
    );
  }
}
