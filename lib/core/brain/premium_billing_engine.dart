// §P13-A Premium Billing & Entitlement Guard Engine (Pure Dart, No AI)
// Cross-reference: §P13-A in Fitkarma_documentation.md

import '../../features/premium/models/subscription_model.dart';

/// Premium Entitlement Status
class EntitlementResult {
  final bool isProActive;
  final bool isInFreeTrial;
  final String entitlementLabel;
  final SubscriptionTier tier;

  const EntitlementResult({
    required this.isProActive,
    required this.isInFreeTrial,
    required this.entitlementLabel,
    this.tier = SubscriptionTier.free,
  });
}

/// Core Premium Billing & Entitlement Guard Engine (§P13-A)
class PremiumBillingEngine {
  const PremiumBillingEngine();

  /// Maximum daily quotas for Free tier (§P13-A)
  static const int freeDailyAiMessageLimit = 5;
  static const int freeDailyMealPhotoLimit = 2;

  /// Check access rights for Pro features
  EntitlementResult checkEntitlement({
    required bool hasActiveSubscription,
    required bool isTrialActive,
    SubscriptionTier tier = SubscriptionTier.free,
  }) {
    if (hasActiveSubscription || isTrialActive) {
      final effectiveTier = tier == SubscriptionTier.free ? SubscriptionTier.pro : tier;
      return EntitlementResult(
        isProActive: true,
        isInFreeTrial: isTrialActive && !hasActiveSubscription,
        entitlementLabel: isTrialActive && !hasActiveSubscription
            ? '7-Day Free Trial'
            : effectiveTier.displayName,
        tier: effectiveTier,
      );
    } else {
      return const EntitlementResult(
        isProActive: false,
        isInFreeTrial: false,
        entitlementLabel: 'Free Tier',
        tier: SubscriptionTier.free,
      );
    }
  }

  /// Verifies access for any §P13-A Paywall Trigger
  bool checkAccess({
    required PaywallTrigger trigger,
    required SubscriptionTier tier,
    required int dailyAiMessages,
    required int dailyMealPhotos,
  }) {
    // Pro and EliteCoach have unlimited access to core triggers
    if (tier != SubscriptionTier.free) return true;

    return switch (trigger) {
      PaywallTrigger.aiMessage => dailyAiMessages < freeDailyAiMessageLimit,
      PaywallTrigger.mealPhoto => dailyMealPhotos < freeDailyMealPhotoLimit,
      PaywallTrigger.squadCreation => false, // Free members can join only
      PaywallTrigger.monthlyReport => false, // Pro only
      PaywallTrigger.predictiveBody => false, // Pro only
      PaywallTrigger.lifeEvents => false, // Full Life Events Pro only
    };
  }
}
