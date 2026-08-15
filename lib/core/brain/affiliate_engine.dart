// §P13-C Creator Affiliate Engine (Pure Dart, No AI)
// Cross-reference: §P13-C in Fitkarma_documentation.md

import '../../features/premium/models/creator_affiliate_models.dart';

class AffiliateEngine {
  const AffiliateEngine();

  /// Calculates recurring creator affiliate commission (default 15%)
  double calculateCommission({
    required double saleAmountInr,
    double commissionPct = 0.15,
  }) {
    return double.parse((saleAmountInr * commissionPct).toStringAsFixed(2));
  }

  /// Calculates client discount amount (default 10%)
  double calculateDiscount({
    required double originalAmountInr,
    double discountPct = 0.10,
  }) {
    return double.parse((originalAmountInr * discountPct).toStringAsFixed(2));
  }

  /// Calculates click-to-pro conversion rate percentage
  double calculateConversionRate({
    required int totalClicks,
    required int proConversions,
  }) {
    if (totalClicks <= 0) return 0.0;
    final rate = (proConversions / totalClicks) * 100.0;
    return double.parse(rate.toStringAsFixed(1));
  }

  /// Processes instant bank transfer request and moves available balance to payout history
  AffiliateStats processInstantPayout({
    required AffiliateStats currentStats,
    required String creatorId,
  }) {
    if (currentStats.availableBalanceInr <= 0) return currentStats;

    final now = DateTime.now();
    final newPayout = AffiliatePayout(
      payoutId: 'payout_${now.millisecondsSinceEpoch}',
      creatorId: creatorId,
      amountInr: currentStats.availableBalanceInr,
      periodStart: DateTime(now.year, now.month, 1),
      periodEnd: now,
      status: PayoutStatus.paid,
    );

    return currentStats.copyWith(
      availableBalanceInr: 0.0,
      payoutHistory: [newPayout, ...currentStats.payoutHistory],
    );
  }
}
