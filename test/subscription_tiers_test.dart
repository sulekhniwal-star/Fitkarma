/// §P13-A Subscription Tiers — Unit, Integration & Widget Tests

import 'package:fitkarma/features/subscription/paywall_screen.dart';
import 'package:fitkarma/features/subscription/revenuecat_subscription_service.dart';
import 'package:fitkarma/features/subscription/subscription_gating_engine.dart';
import 'package:fitkarma/features/subscription/subscription_models.dart';
import 'package:fitkarma/features/subscription/subscription_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const gatingEngine = SubscriptionGatingEngine();
  const revenueCatService = RevenueCatSubscriptionService();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: PaywallScreen(),
      ),
    );
  }

  group('§P13-A SubscriptionGatingEngine Unit Tests', () {
    test('Free tier allows AI messages up to 5/day and blocks thereafter', () {
      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.aiMessage,
          dailyAiMessageCount: 4,
        ),
        isTrue,
      );

      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.aiMessage,
          dailyAiMessageCount: 5,
        ),
        isFalse,
      );
    });

    test('Free tier allows Meal Photo scanning up to 2/day and blocks thereafter', () {
      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.mealPhoto,
          dailyMealPhotoCount: 1,
        ),
        isTrue,
      );

      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.mealPhoto,
          dailyMealPhotoCount: 2,
        ),
        isFalse,
      );
    });

    test('Free tier blocks squad creation, monthly report, predictive body & life events', () {
      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.squadCreation,
        ),
        isFalse,
      );

      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.monthlyReport,
        ),
        isFalse,
      );

      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.predictiveBody,
        ),
        isFalse,
      );

      expect(
        gatingEngine.checkAccess(
          tier: SubscriptionTier.free,
          trigger: PaywallTrigger.lifeEvents,
        ),
        isFalse,
      );
    });

    test('Pro & Elite tiers grant unrestricted access for all triggers', () {
      for (final trigger in PaywallTrigger.values) {
        expect(
          gatingEngine.checkAccess(
            tier: SubscriptionTier.pro,
            trigger: trigger,
            dailyAiMessageCount: 10,
            dailyMealPhotoCount: 10,
          ),
          isTrue,
        );

        expect(
          gatingEngine.checkAccess(
            tier: SubscriptionTier.eliteCoach,
            trigger: trigger,
            dailyAiMessageCount: 10,
            dailyMealPhotoCount: 10,
          ),
          isTrue,
        );
      }
    });
  });

  group('§P13-A RevenueCat Service & SubscriptionNotifier Integration Tests', () {
    test('fetches available packages from RevenueCat offerings', () async {
      final packages = await revenueCatService.fetchAvailablePackages();

      expect(packages, isNotEmpty);
      expect(packages.any((p) => p.identifier == 'pro_monthly_299'), isTrue);
      expect(packages.any((p) => p.identifier == 'pro_yearly_1999'), isTrue);
      expect(packages.any((p) => p.identifier == 'elite_monthly_999'), isTrue);
    });

    test('purchasing package upgrades state tier and starts trial', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(subscriptionProvider.notifier);

      expect(container.read(subscriptionProvider).activeTier, equals(SubscriptionTier.free));

      await notifier.purchaseRevenueCatPackage('pro_yearly_1999');
      final state = container.read(subscriptionProvider);

      expect(state.activeTier, equals(SubscriptionTier.pro));
      expect(state.isTrialActive, isTrue);
      expect(state.successMessage, contains('Upgraded to FitKarma Pro ⚡'));
    });

    test('restores active purchases successfully', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(subscriptionProvider.notifier);

      await notifier.restorePurchases();
      final state = container.read(subscriptionProvider);

      expect(state.activeTier, equals(SubscriptionTier.pro));
      expect(state.successMessage, contains('restored successfully'));
    });
  });

  group('§P13-A PaywallScreen Widget Tests', () {
    testWidgets('renders hero card, features checklist, packages, trial CTA, and restore option', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('⚡ Unlock FitKarma Pro'), findsOneWidget);
      expect(find.text('Supercharge Your Transformation'), findsOneWidget);
      expect(find.text('⭐ Included with FitKarma Pro'), findsOneWidget);
      expect(find.textContaining('Unlimited AI Coach Chats'), findsOneWidget);
      expect(find.text('Pro Annual (Best Value)'), findsOneWidget);
      expect(find.text('Start 7-Day Free Trial ✨'), findsOneWidget);
      expect(find.text('Restore Purchases'), findsOneWidget);
      expect(find.text('Continue with Free Plan'), findsOneWidget);
    });

    testWidgets('triggers trial purchase when CTA button is tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final ctaFinder = find.text('Start 7-Day Free Trial ✨');
      await tester.ensureVisible(ctaFinder);
      await tester.tap(ctaFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.textContaining('7-Day Free Trial started'), findsOneWidget);
    });
  });
}
