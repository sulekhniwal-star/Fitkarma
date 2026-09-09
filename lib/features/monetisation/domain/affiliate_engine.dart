import 'affiliate_models.dart';

/// Pure Dart Deterministic Engine for Creator Affiliate Tracking, Commission Calculation & Tier Upgrades
class AffiliateEngine {
  const AffiliateEngine();

  /// Calculates commission earnings based on affiliate tier and transaction value
  int calculateCommission({
    required AffiliateTier tier,
    required int orderAmountInr,
  }) {
    if (orderAmountInr <= 0) return 0;
    return ((orderAmountInr * tier.commissionPercent) / 100).round();
  }

  /// Evaluates and promotes affiliate tier based on cumulative conversion count
  AffiliateTier resolveTier(int totalConversions) {
    if (totalConversions >= AffiliateTier.platinum.minConversions) {
      return AffiliateTier.platinum;
    }
    if (totalConversions >= AffiliateTier.gold.minConversions) {
      return AffiliateTier.gold;
    }
    if (totalConversions >= AffiliateTier.silver.minConversions) {
      return AffiliateTier.silver;
    }
    return AffiliateTier.bronze;
  }

  /// Processes and attributes a new referral sale to the creator's profile
  AffiliateProfile recordConversion(
    AffiliateProfile currentProfile, {
    required String planOrProgramPurchased,
    required int orderAmountInr,
    DateTime? date,
  }) {
    final now = date ?? DateTime.now();
    final commission = calculateCommission(
      tier: currentProfile.tier,
      orderAmountInr: orderAmountInr,
    );

    final newConversionCount = currentProfile.totalConversions + 1;
    final updatedTier = resolveTier(newConversionCount);

    final newReferral = AffiliateReferral(
      referralId: 'ref_${now.millisecondsSinceEpoch}',
      affiliateId: currentProfile.affiliateId,
      planOrProgramPurchased: planOrProgramPurchased,
      orderAmountInr: orderAmountInr,
      commissionAmountInr: commission,
      conversionDate: now,
      status: PayoutStatus.pending,
    );

    final updatedReferrals = List<AffiliateReferral>.from(currentProfile.recentReferrals)
      ..insert(0, newReferral);

    return currentProfile.copyWith(
      tier: updatedTier,
      totalClicks: currentProfile.totalClicks + 4, // Average 4 clicks per conversion
      totalConversions: newConversionCount,
      totalEarningsInr: currentProfile.totalEarningsInr + commission,
      pendingPayoutInr: currentProfile.pendingPayoutInr + commission,
      recentReferrals: updatedReferrals,
    );
  }

  /// Simulates / processes transfer of pending balance to creator's verified UPI ID
  AffiliateProfile processPayout(AffiliateProfile currentProfile) {
    if (currentProfile.pendingPayoutInr <= 0) return currentProfile;

    final updatedReferrals = currentProfile.recentReferrals.map((ref) {
      if (ref.status == PayoutStatus.pending) {
        return AffiliateReferral(
          referralId: ref.referralId,
          affiliateId: ref.affiliateId,
          planOrProgramPurchased: ref.planOrProgramPurchased,
          orderAmountInr: ref.orderAmountInr,
          commissionAmountInr: ref.commissionAmountInr,
          conversionDate: ref.conversionDate,
          status: PayoutStatus.paidOut,
        );
      }
      return ref;
    }).toList();

    return currentProfile.copyWith(
      paidOutInr: currentProfile.paidOutInr + currentProfile.pendingPayoutInr,
      pendingPayoutInr: 0,
      recentReferrals: updatedReferrals,
    );
  }

  /// Sample creator profile for initial dashboard state and testing
  static AffiliateProfile sampleProfile() {
    final now = DateTime.now();
    return AffiliateProfile(
      affiliateId: 'aff_vikram_99',
      creatorName: 'Vikram Rawat',
      referralCode: 'VIKRAM20',
      customLink: 'https://fitkarma.in/ref/vikram20',
      tier: AffiliateTier.silver,
      totalClicks: 142,
      totalConversions: 18,
      totalEarningsInr: 14380,
      pendingPayoutInr: 3490,
      paidOutInr: 10890,
      upiId: 'vikram.fitness@okhdfcbank',
      recentReferrals: [
        AffiliateReferral(
          referralId: 'ref_101',
          affiliateId: 'aff_vikram_99',
          planOrProgramPurchased: 'FitKarma Pro (Annual Plan - ₹3,999)',
          orderAmountInr: 3999,
          commissionAmountInr: 800, // 20%
          conversionDate: now.subtract(const Duration(hours: 4)),
          status: PayoutStatus.pending,
        ),
        AffiliateReferral(
          referralId: 'ref_102',
          affiliateId: 'aff_vikram_99',
          planOrProgramPurchased: '12-Week Desi Muscle Hypertrophy Program',
          orderAmountInr: 2499,
          commissionAmountInr: 500, // 20%
          conversionDate: now.subtract(const Duration(days: 1)),
          status: PayoutStatus.pending,
        ),
        AffiliateReferral(
          referralId: 'ref_103',
          affiliateId: 'aff_vikram_99',
          planOrProgramPurchased: 'FitKarma Elite (Annual VIP - ₹9,999)',
          orderAmountInr: 9999,
          commissionAmountInr: 2000, // 20%
          conversionDate: now.subtract(const Duration(days: 3)),
          status: PayoutStatus.paidOut,
        ),
      ],
    );
  }

  /// Pre-designed marketing creatives for creator promotions
  static List<PromoAsset> sampleCreatives() {
    return const [
      PromoAsset(
        assetId: 'promo_story_1',
        title: 'Instagram 9:16 Story Template',
        regionalTitle: 'इंस्टाग्राम स्टोरी बैनर',
        dimension: '1080 x 1920 px',
        recommendedPlatform: 'Instagram & WhatsApp Stories',
        headline: 'Transform your body with Indian macros & Ayurvedic science. Use code for 20% off!',
      ),
      PromoAsset(
        assetId: 'promo_banner_2',
        title: 'YouTube / Community Banner',
        regionalTitle: 'यूट्यूब कम्युनिटी पोस्ट बैनर',
        dimension: '1200 x 675 px',
        recommendedPlatform: 'YouTube & Telegram Groups',
        headline: 'Track your HRV, Sleep & Desi Nutrition with FitKarma AI Coach.',
      ),
      PromoAsset(
        assetId: 'promo_whatsapp_3',
        title: 'WhatsApp Broadcast Card',
        regionalTitle: 'व्हाट्सएप ब्रॉडकास्ट कार्ड',
        dimension: '1080 x 1080 px',
        recommendedPlatform: 'WhatsApp Community & Fitness Squads',
        headline: 'Join my squad on FitKarma! Get daily personalized workouts.',
      ),
    ];
  }
}
