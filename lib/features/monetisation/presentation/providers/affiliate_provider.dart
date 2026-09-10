import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/affiliate_engine.dart';
import '../../domain/affiliate_models.dart';

/// State of the Creator Affiliate Program
class AffiliateState {
  final AffiliateProfile profile;
  final List<PromoAsset> promoAssets;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const AffiliateState({
    required this.profile,
    required this.promoAssets,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  AffiliateState copyWith({
    AffiliateProfile? profile,
    List<PromoAsset>? promoAssets,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return AffiliateState(
      profile: profile ?? this.profile,
      promoAssets: promoAssets ?? this.promoAssets,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

final affiliateProvider =
    StateNotifierProvider<AffiliateNotifier, AffiliateState>((ref) {
  return AffiliateNotifier();
});

class AffiliateNotifier extends StateNotifier<AffiliateState> {
  AffiliateNotifier() : super(_buildInitialState());

  static const AffiliateEngine _engine = AffiliateEngine();

  static AffiliateState _buildInitialState() {
    return AffiliateState(
      profile: AffiliateEngine.sampleProfile(),
      promoAssets: AffiliateEngine.sampleCreatives(),
    );
  }

  void updateUpiId(String newUpiId) {
    state = state.copyWith(
      profile: state.profile.copyWith(upiId: newUpiId.trim()),
      successMessage: 'Payout UPI ID updated successfully!',
    );
  }

  void updateReferralCode(String newCode) {
    final cleanCode = newCode.trim().toUpperCase().replaceAll(' ', '');
    if (cleanCode.isEmpty) return;

    state = state.copyWith(
      profile: state.profile.copyWith(
        referralCode: cleanCode,
        customLink: 'https://fitkarma.in/ref/${cleanCode.toLowerCase()}',
      ),
      successMessage: 'Custom referral code updated to $cleanCode!',
    );
  }

  Future<void> requestPayout() async {
    if (state.profile.pendingPayoutInr <= 0) {
      state = state.copyWith(
          errorMessage: 'No pending balance available for payout.');
      return;
    }

    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    // Simulate instant UPI payout transfer
    await Future.delayed(const Duration(milliseconds: 350));

    final updatedProfile = _engine.processPayout(state.profile);

    state = state.copyWith(
      profile: updatedProfile,
      isLoading: false,
      successMessage:
          '₹${state.profile.pendingPayoutInr} transferred successfully to ${state.profile.upiId}!',
    );
  }

  /// Simulates a referral conversion in sandbox / testing mode
  void simulateReferralSale({required String plan, required int amount}) {
    final updatedProfile = _engine.recordConversion(
      state.profile,
      planOrProgramPurchased: plan,
      orderAmountInr: amount,
    );

    state = state.copyWith(
      profile: updatedProfile,
      successMessage:
          'New referral attributed! Earned +₹${_engine.calculateCommission(tier: state.profile.tier, orderAmountInr: amount)}.',
    );
  }
}
