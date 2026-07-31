/// Premium Entitlement Status
class EntitlementResult {
  final bool isProActive;
  final bool isInFreeTrial;
  final String entitlementLabel;

  const EntitlementResult({
    required this.isProActive,
    required this.isInFreeTrial,
    required this.entitlementLabel,
  });
}

/// Core Premium Billing & Entitlement Guard Engine
class PremiumBillingEngine {
  const PremiumBillingEngine();

  /// Check access rights for Pro features
  EntitlementResult checkEntitlement({
    required bool hasActiveSubscription,
    required bool isTrialActive,
  }) {
    if (hasActiveSubscription) {
      return const EntitlementResult(
        isProActive: true,
        isInFreeTrial: false,
        entitlementLabel: 'Pro Subscriber',
      );
    } else if (isTrialActive) {
      return const EntitlementResult(
        isProActive: true,
        isInFreeTrial: true,
        entitlementLabel: '7-Day Free Trial',
      );
    } else {
      return const EntitlementResult(
        isProActive: false,
        isInFreeTrial: false,
        entitlementLabel: 'Free Tier',
      );
    }
  }
}
