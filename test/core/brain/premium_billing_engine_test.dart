import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/premium_billing_engine.dart';
import 'package:fitkarma/features/premium/models/subscription_model.dart';
import 'package:fitkarma/features/premium/providers/premium_provider.dart';

void main() {
  group('§P13-A Premium Billing Engine & Subscription Tiers Tests', () {
    const engine = PremiumBillingEngine();

    test('Pricing configuration matches India-first pricing specification', () {
      final packages = RevenueCatConfig.availablePackages;

      final monthly = packages.firstWhere((p) => p.productId == RevenueCatConfig.proMonthlyId);
      expect(monthly.priceInr, equals(299.0));
      expect(monthly.priceFormatted, equals('₹299 / month'));

      final quarterly = packages.firstWhere((p) => p.productId == RevenueCatConfig.proQuarterlyId);
      expect(quarterly.priceInr, equals(699.0));
      expect(quarterly.savingsBadge, contains('Saves 22%'));

      final annual = packages.firstWhere((p) => p.productId == RevenueCatConfig.proAnnualId);
      expect(annual.priceInr, equals(1999.0));
      expect(annual.savingsBadge, contains('Saves 44%'));

      final elite = packages.firstWhere((p) => p.productId == RevenueCatConfig.eliteCoachMonthlyId);
      expect(elite.priceInr, equals(1499.0));
      expect(elite.tier, equals(SubscriptionTier.eliteCoach));
    });

    test('checkAccess enforces AI message limit (5/day for free, unlimited for pro)', () {
      // Free tier with 4 messages -> allowed
      expect(
        engine.checkAccess(
          trigger: PaywallTrigger.aiMessage,
          tier: SubscriptionTier.free,
          dailyAiMessages: 4,
          dailyMealPhotos: 0,
        ),
        isTrue,
      );

      // Free tier with 5 messages -> blocked
      expect(
        engine.checkAccess(
          trigger: PaywallTrigger.aiMessage,
          tier: SubscriptionTier.free,
          dailyAiMessages: 5,
          dailyMealPhotos: 0,
        ),
        isFalse,
      );

      // Pro tier with 10 messages -> allowed
      expect(
        engine.checkAccess(
          trigger: PaywallTrigger.aiMessage,
          tier: SubscriptionTier.pro,
          dailyAiMessages: 10,
          dailyMealPhotos: 0,
        ),
        isTrue,
      );
    });

    test('checkAccess enforces meal photo limit (2/day for free, unlimited for pro)', () {
      // Free tier with 1 photo -> allowed
      expect(
        engine.checkAccess(
          trigger: PaywallTrigger.mealPhoto,
          tier: SubscriptionTier.free,
          dailyAiMessages: 0,
          dailyMealPhotos: 1,
        ),
        isTrue,
      );

      // Free tier with 2 photos -> blocked
      expect(
        engine.checkAccess(
          trigger: PaywallTrigger.mealPhoto,
          tier: SubscriptionTier.free,
          dailyAiMessages: 0,
          dailyMealPhotos: 2,
        ),
        isFalse,
      );

      // Pro tier with 5 photos -> allowed
      expect(
        engine.checkAccess(
          trigger: PaywallTrigger.mealPhoto,
          tier: SubscriptionTier.pro,
          dailyAiMessages: 0,
          dailyMealPhotos: 5,
        ),
        isTrue,
      );
    });

    test('checkAccess locks squad creation, monthly report, predictive body, and life events for free tier', () {
      for (final trigger in [
        PaywallTrigger.squadCreation,
        PaywallTrigger.monthlyReport,
        PaywallTrigger.predictiveBody,
        PaywallTrigger.lifeEvents,
      ]) {
        expect(
          engine.checkAccess(
            trigger: trigger,
            tier: SubscriptionTier.free,
            dailyAiMessages: 0,
            dailyMealPhotos: 0,
          ),
          isFalse,
          reason: 'Trigger ${trigger.name} should be locked on free tier',
        );

        expect(
          engine.checkAccess(
            trigger: trigger,
            tier: SubscriptionTier.pro,
            dailyAiMessages: 0,
            dailyMealPhotos: 0,
          ),
          isTrue,
          reason: 'Trigger ${trigger.name} should be unlocked on Pro tier',
        );
      }
    });

    test('PremiumStateNotifier starts 7-day trial and increments quotas', () async {
      final notifier = PremiumStateNotifier(engine);

      expect(notifier.state.activeTier, equals(SubscriptionTier.free));
      expect(notifier.state.isProActive, isFalse);

      // Increment messages
      await notifier.incrementAiMessageCount();
      expect(notifier.state.dailyAiMessageCount, equals(1));

      // Increment meal photos
      await notifier.incrementMealPhotoCount();
      expect(notifier.state.dailyMealPhotoAnalysisCount, equals(1));

      // Start free trial
      await notifier.startFreeTrial();
      expect(notifier.state.isProActive, isTrue);
      expect(notifier.state.isTrialActive, isTrue);
      expect(notifier.state.activeTier, equals(SubscriptionTier.pro));
      expect(notifier.state.renewalDate, isNotNull);
    });
  });
}
