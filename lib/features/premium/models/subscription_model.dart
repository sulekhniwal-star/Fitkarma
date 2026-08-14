// §P13-A Subscription Tiers & Pricing Models (India-first)
// Cross-reference: §P13-A in Fitkarma_documentation.md

/// Subscription Tiers per §P13-A
enum SubscriptionTier {
  free,
  pro,
  eliteCoach;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free Plan';
      case SubscriptionTier.pro:
        return 'FitKarma Pro';
      case SubscriptionTier.eliteCoach:
        return 'Elite Coach (Waitlist)';
    }
  }

  bool get isPaid => this != SubscriptionTier.free;
}

/// 6 Documented Paywall Triggers per §P13-A
enum PaywallTrigger {
  aiMessage,
  mealPhoto,
  squadCreation,
  monthlyReport,
  predictiveBody,
  lifeEvents;

  String get triggerDescription {
    switch (this) {
      case PaywallTrigger.aiMessage:
        return 'AI Coach message daily quota reached (Free limit: 5/day)';
      case PaywallTrigger.mealPhoto:
        return 'Meal photo analysis daily quota reached (Free limit: 2/day)';
      case PaywallTrigger.squadCreation:
        return 'Squad creation is a Pro feature (Free tier: Join only)';
      case PaywallTrigger.monthlyReport:
        return 'Comprehensive Monthly Health Report is a Pro feature';
      case PaywallTrigger.predictiveBody:
        return '90-Day Body Projection & Advanced Analytics is a Pro feature';
      case PaywallTrigger.lifeEvents:
        return 'Full Life Events Engine is a Pro feature';
    }
  }
}

/// Subscription Package Model
class SubscriptionPackage {
  final String productId;
  final String name;
  final String priceFormatted;
  final double priceInr;
  final String period;
  final String? savingsBadge;
  final bool hasFreeTrial;
  final SubscriptionTier tier;

  const SubscriptionPackage({
    required this.productId,
    required this.name,
    required this.priceFormatted,
    required this.priceInr,
    required this.period,
    this.savingsBadge,
    this.hasFreeTrial = true,
    this.tier = SubscriptionTier.pro,
  });
}

/// Seeded RevenueCat Product IDs & India-First Pricing Configuration per §P13-A
class RevenueCatConfig {
  static const String proMonthlyId = 'fitkarma_pro_monthly';
  static const String proQuarterlyId = 'fitkarma_pro_quarterly';
  static const String proAnnualId = 'fitkarma_pro_annual';
  static const String eliteCoachMonthlyId = 'fitkarma_elite_coach_monthly';

  static const List<SubscriptionPackage> availablePackages = [
    SubscriptionPackage(
      productId: proMonthlyId,
      name: 'FitKarma Pro Monthly',
      priceFormatted: '₹299 / month',
      priceInr: 299.0,
      period: 'Monthly',
      hasFreeTrial: true,
      tier: SubscriptionTier.pro,
    ),
    SubscriptionPackage(
      productId: proQuarterlyId,
      name: 'FitKarma Pro Quarterly',
      priceFormatted: '₹699 / quarter',
      priceInr: 699.0,
      period: 'Quarterly',
      savingsBadge: 'Saves 22%',
      hasFreeTrial: true,
      tier: SubscriptionTier.pro,
    ),
    SubscriptionPackage(
      productId: proAnnualId,
      name: 'FitKarma Pro Annual',
      priceFormatted: '₹1,999 / year',
      priceInr: 1999.0,
      period: 'Annual',
      savingsBadge: 'Saves 44% (Best Value)',
      hasFreeTrial: true,
      tier: SubscriptionTier.pro,
    ),
    SubscriptionPackage(
      productId: eliteCoachMonthlyId,
      name: 'Elite Coach (Waitlist)',
      priceFormatted: '₹1,499 / month',
      priceInr: 1499.0,
      period: 'Monthly',
      hasFreeTrial: true,
      tier: SubscriptionTier.eliteCoach,
    ),
  ];
}
