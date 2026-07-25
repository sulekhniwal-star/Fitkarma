/// §P13-A Subscription Gating Engine
///
/// Enforces Free vs Pro vs Elite tier permissions across AI Coach chats,
/// Meal Photo Vision, Squad Creation, Monthly Reports, Predictive Analytics & Life Events matching §P13-A spec.
library;

import 'subscription_models.dart';

class SubscriptionGatingEngine {
  const SubscriptionGatingEngine();

  /// Evaluates permission access based on tier and daily usage quotas (§P13-A spec).
  bool checkAccess({
    required SubscriptionTier tier,
    required PaywallTrigger trigger,
    int dailyAiMessageCount = 0,
    int dailyMealPhotoCount = 0,
  }) {
    if (tier == SubscriptionTier.pro || tier == SubscriptionTier.eliteCoach) {
      return true;
    }

    return switch (trigger) {
      PaywallTrigger.aiMessage => dailyAiMessageCount < 5,
      PaywallTrigger.mealPhoto => dailyMealPhotoCount < 2,
      PaywallTrigger.squadCreation => false, // Free members can join existing squads only
      PaywallTrigger.monthlyReport => false,
      PaywallTrigger.predictiveBody => false,
      PaywallTrigger.lifeEvents => false,
    };
  }

  String getPaywallTitle(PaywallTrigger trigger) => switch (trigger) {
        PaywallTrigger.aiMessage => 'Daily AI Coach Limit Reached (5/5)',
        PaywallTrigger.mealPhoto => 'Daily Vision Photo Limit Reached (2/2)',
        PaywallTrigger.squadCreation => 'Unlock Squad Creation with Pro',
        PaywallTrigger.monthlyReport => 'Unlock Clinical Monthly Health Reports',
        PaywallTrigger.predictiveBody => 'Unlock 90-Day Predictive Body Composition',
        PaywallTrigger.lifeEvents => 'Unlock Life Events Engine',
      };

  String getPaywallDescription(PaywallTrigger trigger) => switch (trigger) {
        PaywallTrigger.aiMessage =>
          'Upgrade to FitKarma Pro for unlimited AI Coach messages & 24/7 personalized guidance.',
        PaywallTrigger.mealPhoto =>
          'Upgrade to FitKarma Pro for unlimited instant AI meal photo scanning & macro analysis.',
        PaywallTrigger.squadCreation =>
          'Create private accountability squads, challenge friends, and lead group fitness goals.',
        PaywallTrigger.monthlyReport =>
          'Export PDF & FHIR-lite clinical reports for doctor consultations.',
        PaywallTrigger.predictiveBody =>
          'Forecast body fat & lean mass trajectory across 90-day transformation windows.',
        PaywallTrigger.lifeEvents =>
          'Automatically adapt programs for weddings, travel, deadlines, and injuries.',
      };
}
