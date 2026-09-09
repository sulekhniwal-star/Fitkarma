import 'package:flutter/foundation.dart';

/// Affiliate tier levels based on referral volume
enum AffiliateTier {
  bronze(
    name: 'Bronze Ambassador',
    regionalName: 'कांस्य एम्बेसडर',
    commissionPercent: 15,
    minConversions: 0,
    accentColorValue: 0xFFCD7F32,
  ),
  silver(
    name: 'Silver Influencer',
    regionalName: 'रजत इन्फ्लुएंसर',
    commissionPercent: 20,
    minConversions: 11,
    accentColorValue: 0xFFC0C0C0,
  ),
  gold(
    name: 'Gold Creator',
    regionalName: 'स्वर्ण क्रिएटर',
    commissionPercent: 25,
    minConversions: 51,
    accentColorValue: 0xFFFFD700,
  ),
  platinum(
    name: 'Platinum Partner',
    regionalName: 'प्लैटिनम पार्टनर',
    commissionPercent: 30,
    minConversions: 201,
    accentColorValue: 0xFFE5E4E2,
  );

  final String name;
  final String regionalName;
  final int commissionPercent;
  final int minConversions;
  final int accentColorValue;

  const AffiliateTier({
    required this.name,
    required this.regionalName,
    required this.commissionPercent,
    required this.minConversions,
    required this.accentColorValue,
  });
}

/// Status of an affiliate commission payout
enum PayoutStatus {
  pending(name: 'Pending Clearance', regionalName: 'समीक्षाधीन'),
  cleared(name: 'Ready for Payout', regionalName: 'भुगतान हेतु तैयार'),
  paidOut(name: 'Transferred via UPI', regionalName: 'यूपीआई द्वारा प्रेषित');

  final String name;
  final String regionalName;

  const PayoutStatus({
    required this.name,
    required this.regionalName,
  });
}

/// A recorded referral conversion event
@immutable
class AffiliateReferral {
  final String referralId;
  final String affiliateId;
  final String planOrProgramPurchased;
  final int orderAmountInr;
  final int commissionAmountInr;
  final DateTime conversionDate;
  final PayoutStatus status;

  const AffiliateReferral({
    required this.referralId,
    required this.affiliateId,
    required this.planOrProgramPurchased,
    required this.orderAmountInr,
    required this.commissionAmountInr,
    required this.conversionDate,
    required this.status,
  });
}

/// Marketing & promotional creative asset
@immutable
class PromoAsset {
  final String assetId;
  final String title;
  final String regionalTitle;
  final String dimension;
  final String recommendedPlatform;
  final String headline;

  const PromoAsset({
    required this.assetId,
    required this.title,
    required this.regionalTitle,
    required this.dimension,
    required this.recommendedPlatform,
    required this.headline,
  });
}

/// Full creator / affiliate profile and metrics
@immutable
class AffiliateProfile {
  final String affiliateId;
  final String creatorName;
  final String referralCode;
  final String customLink;
  final AffiliateTier tier;
  final int totalClicks;
  final int totalConversions;
  final int totalEarningsInr;
  final int pendingPayoutInr;
  final int paidOutInr;
  final String upiId;
  final List<AffiliateReferral> recentReferrals;

  const AffiliateProfile({
    required this.affiliateId,
    required this.creatorName,
    required this.referralCode,
    required this.customLink,
    required this.tier,
    required this.totalClicks,
    required this.totalConversions,
    required this.totalEarningsInr,
    required this.pendingPayoutInr,
    required this.paidOutInr,
    required this.upiId,
    required this.recentReferrals,
  });

  double get conversionRate {
    if (totalClicks == 0) return 0.0;
    return (totalConversions / totalClicks) * 100;
  }

  int get nextTierConversionsRemaining {
    switch (tier) {
      case AffiliateTier.bronze:
        return 11 - totalConversions > 0 ? 11 - totalConversions : 0;
      case AffiliateTier.silver:
        return 51 - totalConversions > 0 ? 51 - totalConversions : 0;
      case AffiliateTier.gold:
        return 201 - totalConversions > 0 ? 201 - totalConversions : 0;
      case AffiliateTier.platinum:
        return 0;
    }
  }

  AffiliateProfile copyWith({
    String? creatorName,
    String? referralCode,
    String? customLink,
    AffiliateTier? tier,
    int? totalClicks,
    int? totalConversions,
    int? totalEarningsInr,
    int? pendingPayoutInr,
    int? paidOutInr,
    String? upiId,
    List<AffiliateReferral>? recentReferrals,
  }) {
    return AffiliateProfile(
      affiliateId: affiliateId,
      creatorName: creatorName ?? this.creatorName,
      referralCode: referralCode ?? this.referralCode,
      customLink: customLink ?? this.customLink,
      tier: tier ?? this.tier,
      totalClicks: totalClicks ?? this.totalClicks,
      totalConversions: totalConversions ?? this.totalConversions,
      totalEarningsInr: totalEarningsInr ?? this.totalEarningsInr,
      pendingPayoutInr: pendingPayoutInr ?? this.pendingPayoutInr,
      paidOutInr: paidOutInr ?? this.paidOutInr,
      upiId: upiId ?? this.upiId,
      recentReferrals: recentReferrals ?? this.recentReferrals,
    );
  }
}
