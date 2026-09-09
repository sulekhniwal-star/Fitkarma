import 'subscription_models.dart';

/// Pure Dart Deterministic Engine for Subscription Entitlements, Gating & Quota Resolution
class SubscriptionEngine {
  const SubscriptionEngine();

  /// Evaluates whether a user is entitled to access a specific feature
  EntitlementAccessResult evaluateFeatureAccess(
    UserEntitlements entitlements,
    EntitlementFeature feature, {
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();

    // Check if subscription has expired without grace period
    if (entitlements.tier.isPaid) {
      if (entitlements.status == SubscriptionStatus.expired ||
          entitlements.status == SubscriptionStatus.pastDue) {
        return EntitlementAccessResult.denied(
          feature,
          SubscriptionTier.free,
          customReason: 'Your subscription has expired or payment is past due.',
          regionalReason: 'आपकी सदस्यता समाप्त हो गई है अथवा भुगतान लंबित है।',
        );
      }

      if (entitlements.expiresAt != null && now.isAfter(entitlements.expiresAt!)) {
        if (entitlements.status != SubscriptionStatus.gracePeriod) {
          return EntitlementAccessResult.denied(
            feature,
            SubscriptionTier.free,
            customReason: 'Subscription validity has expired.',
            regionalReason: 'सदस्यता की वैधता समाप्त हो चुकी है।',
          );
        }
      }
    }

    final effectiveTier = entitlements.tier;

    // Check tier hierarchy: free (0) < pro (1) < elite (2)
    final userTierLevel = _tierLevel(effectiveTier);
    final requiredTierLevel = _tierLevel(feature.minimumTier);

    if (userTierLevel >= requiredTierLevel) {
      return EntitlementAccessResult.granted(feature, effectiveTier);
    }

    return EntitlementAccessResult.denied(feature, effectiveTier);
  }

  /// Checks whether user has remaining daily AI token/request quota
  bool canMakeAiCall(UserEntitlements entitlements, {int requestedCalls = 1}) {
    final limit = entitlements.tier.dailyAiCallsQuota;
    return (entitlements.dailyAiCallsUsed + requestedCalls) <= limit;
  }

  /// Returns list of all features unlocked by a particular tier
  List<EntitlementFeature> featuresForTier(SubscriptionTier tier) {
    final tierLevel = _tierLevel(tier);
    return EntitlementFeature.values
        .where((f) => _tierLevel(f.minimumTier) <= tierLevel)
        .toList();
  }

  /// Calculates annual monetary savings in INR
  int calculateAnnualSavingsInr(SubscriptionTier tier) {
    if (!tier.isPaid) return 0;
    final totalMonthlyCost = tier.monthlyPriceInr * 12;
    final savings = totalMonthlyCost - tier.annualPriceInr;
    return savings > 0 ? savings : 0;
  }

  /// Generates a mock server-verified entitlement payload for testing & sandbox mode
  UserEntitlements createSandboxEntitlements({
    required String userId,
    required SubscriptionTier tier,
    required BillingCycle cycle,
  }) {
    final now = DateTime.now();
    final durationDays = cycle == BillingCycle.annual ? 365 : 30;

    return UserEntitlements(
      userId: userId,
      tier: tier,
      status: SubscriptionStatus.sandboxTest,
      expiresAt: tier.isPaid ? now.add(Duration(days: durationDays)) : null,
      willRenew: tier.isPaid,
      originalPurchaseTransactionId: tier.isPaid ? 'rc_sb_${now.millisecondsSinceEpoch}' : null,
      dailyAiCallsUsed: 0,
      lastQuotaResetDate: now,
      serverVerificationHash: 'mock_sha256_${tier.id}_${now.millisecondsSinceEpoch}',
      updatedAt: now,
    );
  }

  int _tierLevel(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.pro:
        return 1;
      case SubscriptionTier.elite:
        return 2;
    }
  }
}
