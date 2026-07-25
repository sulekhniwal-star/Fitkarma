/// §P13-A Subscription Tiers & Monetisation — Domain Models
///
/// Models for SubscriptionTier, PaywallTrigger, and OfferingPackages matching §P13-A spec.
library;

enum SubscriptionTier {
  free,
  pro,
  eliteCoach;

  String get displayName => switch (this) {
        free => 'Free Tier',
        pro => 'FitKarma Pro ⚡',
        eliteCoach => 'Elite Coach 👑',
      };
}

enum PaywallTrigger {
  aiMessage,
  mealPhoto,
  squadCreation,
  monthlyReport,
  predictiveBody,
  lifeEvents,
}

class RevenueCatPackage {
  const RevenueCatPackage({
    required this.identifier,
    required this.title,
    required this.priceString,
    required this.period,
    required this.tier,
    this.savingsPercentage,
  });

  final String identifier;
  final String title;
  final String priceString;
  final String period; // 'month' or 'year'
  final SubscriptionTier tier;
  final int? savingsPercentage;
}
