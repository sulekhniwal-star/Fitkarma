// §P13-C Creator Affiliate Provider (Riverpod 2.x)
// Cross-reference: §P13-C in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/affiliate_engine.dart';
import '../models/creator_affiliate_models.dart';

class AffiliateState {
  final ReferralLink referralLink;
  final AffiliateStats stats;
  final bool isRequestingPayout;
  final String? statusMessage;
  final AffiliateEngine engine;

  const AffiliateState({
    required this.referralLink,
    required this.stats,
    this.isRequestingPayout = false,
    this.statusMessage,
    this.engine = const AffiliateEngine(),
  });

  AffiliateState copyWith({
    ReferralLink? referralLink,
    AffiliateStats? stats,
    bool? isRequestingPayout,
    String? statusMessage,
  }) {
    return AffiliateState(
      referralLink: referralLink ?? this.referralLink,
      stats: stats ?? this.stats,
      isRequestingPayout: isRequestingPayout ?? this.isRequestingPayout,
      statusMessage: statusMessage ?? this.statusMessage,
      engine: engine,
    );
  }
}

class AffiliateNotifier extends StateNotifier<AffiliateState> {
  AffiliateNotifier([AffiliateEngine engine = const AffiliateEngine()])
      : super(
          AffiliateState(
            referralLink: const ReferralLink(
              linkId: 'link_sharma10',
              creatorId: 'creator_sharma',
              referralCode: 'SHARMA10',
              clientDiscountPct: 0.10,
              creatorCommissionPct: 0.15,
            ),
            stats: AffiliateStats(
              availableBalanceInr: 8420.0,
              nextPayoutDate: DateTime(2026, 6, 15),
              totalClicks: 4210,
              freeSignups: 1820,
              proConversions: 214,
              payoutHistory: [
                AffiliatePayout(
                  payoutId: 'payout_may2026',
                  creatorId: 'creator_sharma',
                  amountInr: 4820.0,
                  periodStart: DateTime(2026, 5, 1),
                  periodEnd: DateTime(2026, 5, 31),
                  status: PayoutStatus.paid,
                ),
                AffiliatePayout(
                  payoutId: 'payout_apr2026',
                  creatorId: 'creator_sharma',
                  amountInr: 3600.0,
                  periodStart: DateTime(2026, 4, 1),
                  periodEnd: DateTime(2026, 4, 30),
                  status: PayoutStatus.paid,
                ),
              ],
            ),
            engine: engine,
          ),
        );

  /// Requests instant payout to bank account via RazorpayX / Payout API
  Future<void> requestInstantBankTransfer() async {
    if (state.stats.availableBalanceInr <= 0) {
      state = state.copyWith(statusMessage: 'No available balance to withdraw.');
      return;
    }

    state = state.copyWith(isRequestingPayout: true);

    final updatedStats = state.engine.processInstantPayout(
      currentStats: state.stats,
      creatorId: state.referralLink.creatorId,
    );

    state = state.copyWith(
      stats: updatedStats,
      isRequestingPayout: false,
      statusMessage: '🎉 Instant transfer of ₹${state.stats.availableBalanceInr.toStringAsFixed(0)} initiated!',
    );
  }

  /// Updates personalized referral promo code
  void updateReferralCode(String newCode) {
    state = state.copyWith(
      referralLink: ReferralLink(
        linkId: state.referralLink.linkId,
        creatorId: state.referralLink.creatorId,
        referralCode: newCode.trim().toUpperCase(),
        clientDiscountPct: state.referralLink.clientDiscountPct,
        creatorCommissionPct: state.referralLink.creatorCommissionPct,
      ),
    );
  }
}

final affiliateProvider =
    StateNotifierProvider<AffiliateNotifier, AffiliateState>((ref) {
  return AffiliateNotifier();
});
