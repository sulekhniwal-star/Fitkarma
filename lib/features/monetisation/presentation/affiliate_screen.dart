import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/affiliate_models.dart';
import 'providers/affiliate_provider.dart';

/// Screen displaying Creator Affiliate Program, Commission Tracker,
/// UPI Payouts, and Promotional Creatives.
class AffiliateScreen extends ConsumerWidget {
  const AffiliateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(affiliateProvider);
    final notifier = ref.read(affiliateProvider.notifier);
    final profile = state.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Creator Affiliate Hub',
          regionalText: 'क्रिएटर सहबद्ध व कमीशन डैशबोर्ड',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.textSecondary),
            tooltip: 'Payout Settings',
            onPressed: () =>
                _showUpiSettingsBottomSheet(context, notifier, profile.upiId),
          ),
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showAffiliateTermsModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success / Error Banner
            if (state.successMessage != null)
              _buildMessageBanner(state.successMessage!, isError: false),
            if (state.errorMessage != null)
              _buildMessageBanner(state.errorMessage!, isError: true),

            // 1. Hero Earnings & Payout Bento Card
            _buildHeroEarningsCard(context, state, notifier),
            const SizedBox(height: AppSpacing.md),

            // 2. Referral Link & Share Bento Card
            _buildReferralShareCard(context, profile),
            const SizedBox(height: AppSpacing.md),

            // 3. Current Tier & Progression Card
            _buildTierProgressCard(profile),
            const SizedBox(height: AppSpacing.md),

            // 4. Recent Referral Conversions Header & List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BilingualLabel(
                  primaryText:
                      'Recent Referrals (${profile.recentReferrals.length})',
                  regionalText: 'हालिया रेफरल व कमीशन',
                ),
                TextButton.icon(
                  icon: const Icon(Icons.flash_on,
                      color: AppColors.gold, size: 14),
                  label: const Text('Simulate Sale',
                      style: TextStyle(color: AppColors.gold, fontSize: 11)),
                  onPressed: () {
                    notifier.simulateReferralSale(
                      plan: 'FitKarma Pro (Annual Plan - ₹3,999)',
                      amount: 3999,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...profile.recentReferrals.map((ref) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildReferralCard(ref),
                )),
            const SizedBox(height: AppSpacing.md),

            // 5. Promotional Marketing Creatives
            const BilingualLabel(
              primaryText: 'Promotional Creatives & Assets',
              regionalText: 'प्रचार सामग्री एवं सोशल मीडिया बैनर',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...state.promoAssets.map((asset) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPromoAssetCard(context, asset),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBanner(String message, {required bool isError}) {
    final color = isError ? AppColors.alertRed : AppColors.karmaGreen;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
              color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroEarningsCard(
    BuildContext context,
    AffiliateState state,
    AffiliateNotifier notifier,
  ) {
    final profile = state.profile;
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.karmaGreen, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.payments_outlined,
                        color: AppColors.karmaGreen, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'UPI: ${profile.upiId}',
                      style: const TextStyle(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${profile.totalClicks} Clicks (${profile.conversionRate.toStringAsFixed(1)}% CVR)',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              GlowingMetric(
                label: 'Total Earned',
                value: '₹${profile.totalEarningsInr}',
                unit: '',
                accentColor: AppColors.karmaGreen,
                isHero: true,
              ),
              const SizedBox(width: AppSpacing.lg),
              GlowingMetric(
                label: 'Pending Payout',
                value: '₹${profile.pendingPayoutInr}',
                unit: '',
                accentColor: AppColors.focusBlue,
                isHero: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: profile.pendingPayoutInr > 0
                    ? AppColors.focusBlue
                    : AppColors.surfaceElevated,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.radiusMd,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: profile.pendingPayoutInr > 0 && !state.isLoading
                  ? () => notifier.requestPayout()
                  : null,
              child: state.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(
                      profile.pendingPayoutInr > 0
                          ? 'Transfer ₹${profile.pendingPayoutInr} via UPI'
                          : 'No Pending Balance',
                      style: TextStyle(
                        color: profile.pendingPayoutInr > 0
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralShareCard(
      BuildContext context, AffiliateProfile profile) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.link, color: AppColors.focusBlue, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Your Referral Link & Promo Code',
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.energyOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  '${profile.tier.commissionPercent}% Commission',
                  style: const TextStyle(
                      color: AppColors.energyOrange,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.referralCode,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        profile.customLink,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceElevatedHigh,
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusSm),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  icon: const Icon(Icons.copy,
                      color: AppColors.focusBlue, size: 13),
                  label: const Text('Copy',
                      style:
                          TextStyle(color: AppColors.focusBlue, fontSize: 11)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: profile.customLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Referral link copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierProgressCard(AffiliateProfile profile) {
    final tierColor = Color(profile.tier.accentColorValue);
    final remaining = profile.nextTierConversionsRemaining;
    final totalConversions = profile.totalConversions;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.military_tech, color: tierColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    profile.tier.name,
                    style: TextStyle(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
              Text(
                '${profile.tier.commissionPercent}% Flat Cut',
                style: const TextStyle(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            remaining > 0
                ? '$remaining more conversions to unlock next tier commission rate.'
                : 'Maximum tier unlocked! Enjoying top-tier revenue splits.',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (totalConversions / 50).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(tierColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCard(AffiliateReferral referral) {
    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: const Icon(Icons.person_add_alt_1,
                color: AppColors.karmaGreen, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.planOrProgramPurchased,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Order Value: ₹${referral.orderAmountInr} • ${referral.status.name.toUpperCase()}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.karmaGreen.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Text(
              '+₹${referral.commissionAmountInr}',
              style: const TextStyle(
                color: AppColors.karmaGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoAssetCard(BuildContext context, PromoAsset asset) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                asset.title,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusSm,
                ),
                child: Text(
                  asset.dimension,
                  style: const TextStyle(
                      color: AppColors.focusBlue,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(
            asset.regionalTitle,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '"${asset.headline}"',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Recommended for: ${asset.recommendedPlatform}',
            style: const TextStyle(color: AppColors.karmaGreen, fontSize: 10),
          ),
        ],
      ),
    );
  }

  void _showUpiSettingsBottomSheet(
      BuildContext context, AffiliateNotifier notifier, String currentUpi) {
    final upiController = TextEditingController(text: currentUpi);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Payout UPI & Bank Settings',
                regionalText: 'कमीशन भुगतान यूपीआई विवरण',
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: upiController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'UPI ID (VPA)',
                  hintText: 'e.g. yourname@okhdfcbank',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.radiusSm,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () {
                    if (upiController.text.trim().isNotEmpty) {
                      notifier.updateUpiId(upiController.text.trim());
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save Payout Account',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAffiliateTermsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualLabel(
                primaryText: 'Creator Affiliate Program Rules',
                regionalText: 'एफिलिएट नियम व कमीशन शर्तें',
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Affiliates earn 15% to 30% flat commission on all FitKarma Pro and Elite subscription referrals, and 10% to 20% on Marketplace coach programs. Commissions clear after the 7-day refund buffer and are paid instantly via UPI.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.focusBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.radiusMd),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
