import '../models/monetisation_models.dart';

class AffiliateEngine {
  const AffiliateEngine();

  /// Calculates rewards for creator/user referrals
  AffiliateReferral processReferral({
    required String id,
    required String referrerId,
    required String referralCode,
    required String refereeUserId,
    required AppSubscriptionTier purchasedTier,
  }) {
    int karmaReward = 250; // Base referral karma
    int commissionInr = 0;

    switch (purchasedTier) {
      case AppSubscriptionTier.free:
        karmaReward = 100;
        commissionInr = 0;
        break;
      case AppSubscriptionTier.pro:
        karmaReward = 500;
        commissionInr = 200; // ₹200 affiliate commission on Pro
        break;
      case AppSubscriptionTier.elite:
        karmaReward = 1500;
        commissionInr = 500; // ₹500 affiliate commission on Elite
        break;
      case AppSubscriptionTier.corporate:
        karmaReward = 2000;
        commissionInr = 1000;
        break;
    }

    return AffiliateReferral(
      id: id,
      referrerId: referrerId,
      referralCode: referralCode.toUpperCase(),
      refereeUserId: refereeUserId,
      karmaReward: karmaReward,
      commissionInr: commissionInr,
      createdAt: DateTime.now(),
    );
  }

  /// Generates clean branded referral code from username
  String generateReferralCode(String userName) {
    final clean = userName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    final prefix = clean.length >= 4 ? clean.substring(0, 4) : clean.padRight(4, 'X');
    return 'YOGI-$prefix';
  }
}
