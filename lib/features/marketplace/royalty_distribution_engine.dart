/// §P13-B Royalty & Wallet Distribution Engine (ADR-040)
///
/// Implements 80/20 royalty split settlement between creators (80%) and platform (20%) matching §P13-B spec.
library;

import 'marketplace_models.dart';

class RoyaltySplit {
  const RoyaltySplit({
    required this.grossAmountInr,
    required this.creatorEarningsInr,
    required this.platformFeeInr,
  });

  final double grossAmountInr;
  final double creatorEarningsInr; // 80%
  final double platformFeeInr; // 20%
}

class RoyaltyDistributionEngine {
  const RoyaltyDistributionEngine();

  /// Calculates 80/20 platform fee split according to ADR-040.
  RoyaltySplit calculateSplit(double grossAmountInr) {
    final creatorEarnings = grossAmountInr * 0.80;
    final platformFee = grossAmountInr * 0.20;

    return RoyaltySplit(
      grossAmountInr: grossAmountInr,
      creatorEarningsInr: creatorEarnings,
      platformFeeInr: platformFee,
    );
  }

  /// Credits transaction to creator wallet ledger and updates balances.
  WalletLedger recordTransaction({
    required WalletLedger currentWallet,
    required String transactionType,
    required double grossAmountInr,
  }) {
    final split = calculateSplit(grossAmountInr);
    final entryId = 'tx_${DateTime.now().millisecondsSinceEpoch}';

    final newEntry = LedgerEntry(
      entryId: entryId,
      transactionType: transactionType,
      grossAmountInr: split.grossAmountInr,
      creatorEarningsInr: split.creatorEarningsInr,
      platformFeeInr: split.platformFeeInr,
      timestamp: DateTime.now(),
    );

    return WalletLedger(
      walletId: currentWallet.walletId,
      creatorId: currentWallet.creatorId,
      balanceInr: currentWallet.balanceInr + split.creatorEarningsInr,
      totalEarningsInr: currentWallet.totalEarningsInr + split.creatorEarningsInr,
      pendingPayoutInr: currentWallet.pendingPayoutInr + split.creatorEarningsInr,
      entries: [newEntry, ...currentWallet.entries],
    );
  }
}
