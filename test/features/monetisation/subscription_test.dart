import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/monetisation/domain/subscription_engine.dart';
import 'package:fitkarma/features/monetisation/domain/subscription_models.dart';
import 'package:fitkarma/features/monetisation/presentation/providers/subscription_provider.dart';

void main() {
  group('SubscriptionEngine Deterministic Tests', () {
    const engine = SubscriptionEngine();

    test('Free tier allows basic features and blocks pro/elite features', () {
      final freeUser = UserEntitlements.free('user_123');

      final basicAccess = engine.evaluateFeatureAccess(
          freeUser, EntitlementFeature.aiCoachBasic);
      expect(basicAccess.isGranted, isTrue);

      final proAccess = engine.evaluateFeatureAccess(
          freeUser, EntitlementFeature.aiRoastMode);
      expect(proAccess.isGranted, isFalse);
      expect(proAccess.requiredTier, equals(SubscriptionTier.pro));

      final eliteAccess = engine.evaluateFeatureAccess(
          freeUser, EntitlementFeature.clinicalLabReportParsing);
      expect(eliteAccess.isGranted, isFalse);
      expect(eliteAccess.requiredTier, equals(SubscriptionTier.elite));
    });

    test('Pro tier unlocks Pro features but blocks Elite features', () {
      final proUser = engine.createSandboxEntitlements(
        userId: 'user_pro',
        tier: SubscriptionTier.pro,
        cycle: BillingCycle.monthly,
      );

      final proAccess = engine.evaluateFeatureAccess(
          proUser, EntitlementFeature.wearableFreeComposition);
      expect(proAccess.isGranted, isTrue);

      final weddingAccess = engine.evaluateFeatureAccess(
          proUser, EntitlementFeature.weddingTransformation);
      expect(weddingAccess.isGranted, isTrue);

      final eliteAccess = engine.evaluateFeatureAccess(
          proUser, EntitlementFeature.humanCoachConsultations);
      expect(eliteAccess.isGranted, isFalse);
      expect(eliteAccess.requiredTier, equals(SubscriptionTier.elite));
    });

    test('Elite tier unlocks all features in the ecosystem', () {
      final eliteUser = engine.createSandboxEntitlements(
        userId: 'user_elite',
        tier: SubscriptionTier.elite,
        cycle: BillingCycle.annual,
      );

      for (final feature in EntitlementFeature.values) {
        final result = engine.evaluateFeatureAccess(eliteUser, feature);
        expect(result.isGranted, isTrue,
            reason: 'Feature ${feature.name} should be unlocked for Elite');
      }
    });

    test('Expired subscription without grace period denies access', () {
      final now = DateTime(2026, 9, 9);
      final expiredUser = UserEntitlements(
        userId: 'user_expired',
        tier: SubscriptionTier.pro,
        status: SubscriptionStatus.expired,
        expiresAt: now.subtract(const Duration(days: 2)),
        willRenew: false,
        dailyAiCallsUsed: 0,
        lastQuotaResetDate: now,
        serverVerificationHash: 'mock_hash',
        updatedAt: now,
      );

      final result = engine.evaluateFeatureAccess(
        expiredUser,
        EntitlementFeature.aiRoastMode,
        currentTime: now,
      );
      expect(result.isGranted, isFalse);
    });

    test('Grace period subscription retains access temporarily', () {
      final now = DateTime(2026, 9, 9);
      final graceUser = UserEntitlements(
        userId: 'user_grace',
        tier: SubscriptionTier.pro,
        status: SubscriptionStatus.gracePeriod,
        expiresAt: now.subtract(const Duration(hours: 12)),
        willRenew: true,
        dailyAiCallsUsed: 5,
        lastQuotaResetDate: now,
        serverVerificationHash: 'mock_hash',
        updatedAt: now,
      );

      final result = engine.evaluateFeatureAccess(
        graceUser,
        EntitlementFeature.aiRoastMode,
        currentTime: now,
      );
      expect(result.isGranted, isTrue);
    });

    test('Daily AI token quota check behaves accurately', () {
      final freeUser = UserEntitlements(
        userId: 'user_free_quota',
        tier: SubscriptionTier.free,
        status: SubscriptionStatus.active,
        expiresAt: null,
        willRenew: false,
        dailyAiCallsUsed: 9,
        lastQuotaResetDate: DateTime.now(),
        serverVerificationHash: 'free_hash',
        updatedAt: DateTime.now(),
      );

      expect(engine.canMakeAiCall(freeUser, requestedCalls: 1), isTrue);
      expect(engine.canMakeAiCall(freeUser, requestedCalls: 2), isFalse);
    });

    test('Annual savings calculations in INR are correct', () {
      final proSavings = engine.calculateAnnualSavingsInr(SubscriptionTier.pro);
      // Monthly 499 * 12 = 5988; Annual = 3999; Savings = 1989
      expect(proSavings, equals(1989));

      final eliteSavings =
          engine.calculateAnnualSavingsInr(SubscriptionTier.elite);
      // Monthly 1499 * 12 = 17988; Annual = 9999; Savings = 7989
      expect(eliteSavings, equals(7989));
    });
  });

  group('Subscription StateNotifier Provider Tests', () {
    test(
        'StateNotifier updates billing cycle, upgrades tier, and records AI calls',
        () async {
      final notifier = SubscriptionNotifier();

      expect(notifier.state.entitlements.tier, equals(SubscriptionTier.free));
      expect(notifier.state.selectedBillingCycle, equals(BillingCycle.annual));

      notifier.selectBillingCycle(BillingCycle.monthly);
      expect(notifier.state.selectedBillingCycle, equals(BillingCycle.monthly));

      await notifier.upgradeTier(SubscriptionTier.pro);
      expect(notifier.state.entitlements.tier, equals(SubscriptionTier.pro));
      expect(notifier.state.entitlements.isActive, isTrue);

      final initialUsage = notifier.state.entitlements.dailyAiCallsUsed;
      notifier.recordAiCallUsed();
      expect(notifier.state.entitlements.dailyAiCallsUsed,
          equals(initialUsage + 1));

      await notifier.restorePurchases();
      expect(notifier.state.successMessage, contains('synced'));
    });
  });
}
