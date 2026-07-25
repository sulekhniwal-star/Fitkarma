/// §P13-B Marketplace Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'coach_matching_engine.dart';
import 'marketplace_azure_service.dart';
import 'marketplace_models.dart';
import 'royalty_distribution_engine.dart';

class MarketplaceState {
  const MarketplaceState({
    required this.coaches,
    required this.matchedCoaches,
    required this.programs,
    required this.activeAssignments,
    required this.creatorWallet,
    this.isCoachOnboarded = false,
    this.successMessage,
  });

  final List<CreatorProfile> coaches;
  final List<MatchResult> matchedCoaches;
  final List<ProgramBlueprint> programs;
  final List<CoachClientAssignment> activeAssignments;
  final WalletLedger creatorWallet;
  final bool isCoachOnboarded;
  final String? successMessage;

  MarketplaceState copyWith({
    List<CreatorProfile>? coaches,
    List<MatchResult>? matchedCoaches,
    List<ProgramBlueprint>? programs,
    List<CoachClientAssignment>? activeAssignments,
    WalletLedger? creatorWallet,
    bool? isCoachOnboarded,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return MarketplaceState(
      coaches: coaches ?? this.coaches,
      matchedCoaches: matchedCoaches ?? this.matchedCoaches,
      programs: programs ?? this.programs,
      activeAssignments: activeAssignments ?? this.activeAssignments,
      creatorWallet: creatorWallet ?? this.creatorWallet,
      isCoachOnboarded: isCoachOnboarded ?? this.isCoachOnboarded,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class MarketplaceNotifier extends Notifier<MarketplaceState> {
  late final CoachMatchingEngine _matchingEngine;
  late final RoyaltyDistributionEngine _royaltyEngine;
  late final MarketplaceAzureService _azureService;

  @override
  MarketplaceState build() {
    _matchingEngine = const CoachMatchingEngine();
    _royaltyEngine = const RoyaltyDistributionEngine();
    _azureService = const MarketplaceAzureService();

    final coaches = MarketplaceAzureService.seedCoaches;
    final programs = MarketplaceAzureService.seedPrograms;
    final defaultMatches = _matchingEngine.match(
      clientGoals: ['pcos', 'weight_loss'],
      allCoaches: coaches,
    );

    const initialWallet = WalletLedger(
      walletId: 'w_coach_1',
      creatorId: 'coach_1',
      balanceInr: 14800.0,
      totalEarningsInr: 28400.0,
      pendingPayoutInr: 14800.0,
      entries: [],
    );

    return MarketplaceState(
      coaches: coaches,
      matchedCoaches: defaultMatches,
      programs: programs,
      activeAssignments: [],
      creatorWallet: initialWallet,
    );
  }

  void matchCoaches(List<String> clientGoals) {
    final matches = _matchingEngine.match(
      clientGoals: clientGoals,
      allCoaches: state.coaches,
    );
    state = state.copyWith(matchedCoaches: matches);
  }

  Future<void> hireCoach(String coachId) async {
    final assignment = await _azureService.hireCoach(
      coachId: coachId,
      clientId: 'user_current',
    );

    final hiredCoach = state.coaches.firstWhere((c) => c.creatorId == coachId);
    final updatedWallet = _royaltyEngine.recordTransaction(
      currentWallet: state.creatorWallet,
      transactionType: 'coaching_subscription',
      grossAmountInr: hiredCoach.monthlyCoachingRateInr,
    );

    state = state.copyWith(
      activeAssignments: [...state.activeAssignments, assignment],
      creatorWallet: updatedWallet,
      successMessage: '🎉 Hired ${hiredCoach.name}! 80% split credited to coach wallet.',
    );
  }

  void purchaseProgram(ProgramBlueprint program) {
    final updatedWallet = _royaltyEngine.recordTransaction(
      currentWallet: state.creatorWallet,
      transactionType: 'program_sale',
      grossAmountInr: program.priceInr,
    );

    state = state.copyWith(
      creatorWallet: updatedWallet,
      successMessage: '🛍️ Purchased "${program.title}" for ₹${program.priceInr.toInt()}! (₹${(program.priceInr * 0.8).toInt()} creator / ₹${(program.priceInr * 0.2).toInt()} platform split)',
    );
  }

  void onboardCreator({
    required String name,
    required String bio,
    required List<String> certifications,
    required List<CoachSpecialty> specialties,
    required double rateInr,
  }) {
    final newCoach = CreatorProfile(
      creatorId: 'coach_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      bio: bio,
      certifications: certifications,
      specialties: specialties,
      averageRating: 5.0,
      activeClientsCount: 0,
      monthlyCoachingRateInr: rateInr,
      isVerified: true,
    );

    final updatedCoaches = [...state.coaches, newCoach];
    final updatedMatches = _matchingEngine.match(
      clientGoals: ['pcos', 'weight_loss'],
      allCoaches: updatedCoaches,
    );

    state = state.copyWith(
      coaches: updatedCoaches,
      matchedCoaches: updatedMatches,
      isCoachOnboarded: true,
      successMessage: '🏆 Verified Creator Profile created for $name!',
    );
  }

  Future<void> requestPayout() async {
    final success = await _azureService.triggerPayout(
      walletId: state.creatorWallet.walletId,
      amountInr: state.creatorWallet.pendingPayoutInr,
    );

    if (success) {
      final resetWallet = WalletLedger(
        walletId: state.creatorWallet.walletId,
        creatorId: state.creatorWallet.creatorId,
        balanceInr: 0.0,
        totalEarningsInr: state.creatorWallet.totalEarningsInr,
        pendingPayoutInr: 0.0,
        entries: state.creatorWallet.entries,
      );

      state = state.copyWith(
        creatorWallet: resetWallet,
        successMessage: '💸 Payout request submitted to bank account via Razorpay Route.',
      );
    }
  }
}

final marketplaceProvider =
    NotifierProvider<MarketplaceNotifier, MarketplaceState>(
  MarketplaceNotifier.new,
);
