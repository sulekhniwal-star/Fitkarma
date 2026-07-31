/// Subscription Package Model
class SubscriptionPackage {
  final String productId;
  final String name;
  final String priceFormatted;
  final String period;
  final bool hasFreeTrial;

  const SubscriptionPackage({
    required this.productId,
    required this.name,
    required this.priceFormatted,
    required this.period,
    this.hasFreeTrial = true,
  });
}

/// Seeded RevenueCat Product IDs Configuration
class RevenueCatConfig {
  static const String monthlyProductId = 'fitkarma_pro_monthly';
  static const String yearlyProductId = 'fitkarma_pro_yearly';

  static const List<SubscriptionPackage> availablePackages = [
    SubscriptionPackage(
      productId: monthlyProductId,
      name: 'FitKarma Pro Monthly',
      priceFormatted: '₹499 / month',
      period: 'Monthly',
      hasFreeTrial: true,
    ),
    SubscriptionPackage(
      productId: yearlyProductId,
      name: 'FitKarma Pro Annual',
      priceFormatted: '₹3,999 / year',
      period: 'Yearly (Save 33%)',
      hasFreeTrial: true,
    ),
  ];
}
