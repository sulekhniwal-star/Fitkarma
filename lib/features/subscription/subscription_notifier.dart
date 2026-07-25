/// §P12-A Subscription Notifier & State Management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'revenuecat_subscription_service.dart';
import 'subscription_gating_engine.dart';
import 'subscription_models.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.activeTier,
    this.dailyAiMessageCount = 0,
    this.dailyMealPhotoCount = 0,
    this.renewalDate,
    this.isTrialActive = false,
    this.billingError,
    this.isLoading = false,
    this.successMessage,
  });

  final SubscriptionTier activeTier;
  final int dailyAiMessageCount;
  final int dailyMealPhotoCount;
  final DateTime? renewalDate;
  final bool isTrialActive;
  final String? billingError;
  final bool isLoading;
  final String? successMessage;

  SubscriptionState copyWith({
    SubscriptionTier? activeTier,
    int? dailyAiMessageCount,
    int? dailyMealPhotoCount,
    DateTime? renewalDate,
    bool? isTrialActive,
    String? billingError,
    bool? isLoading,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return SubscriptionState(
      activeTier: activeTier ?? this.activeTier,
      dailyAiMessageCount: dailyAiMessageCount ?? this.dailyAiMessageCount,
      dailyMealPhotoCount: dailyMealPhotoCount ?? this.dailyMealPhotoCount,
      renewalDate: renewalDate ?? this.renewalDate,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      billingError: clearMessages ? null : (billingError ?? this.billingError),
      isLoading: isLoading ?? this.isLoading,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  late final SubscriptionGatingEngine _gatingEngine;
  late final RevenueCatSubscriptionService _revenueCatService;

  @override
  SubscriptionState build() {
    _gatingEngine = const SubscriptionGatingEngine();
    _revenueCatService = const RevenueCatSubscriptionService();

    return const SubscriptionState(
      activeTier: SubscriptionTier.free,
      dailyAiMessageCount: 0,
      dailyMealPhotoCount: 0,
    );
  }

  bool checkAccess(PaywallTrigger trigger) {
    return _gatingEngine.checkAccess(
      tier: state.activeTier,
      trigger: trigger,
      dailyAiMessageCount: state.dailyAiMessageCount,
      dailyMealPhotoCount: state.dailyMealPhotoCount,
    );
  }

  void incrementAiMessageCount() {
    state = state.copyWith(dailyAiMessageCount: state.dailyAiMessageCount + 1);
  }

  void incrementMealPhotoCount() {
    state = state.copyWith(dailyMealPhotoCount: state.dailyMealPhotoCount + 1);
  }

  Future<void> upgradeTier(SubscriptionTier newTier) async {
    final renewal = DateTime.now().add(const Duration(days: 30));
    state = state.copyWith(
      activeTier: newTier,
      renewalDate: renewal,
      isTrialActive: true,
      successMessage: '🎉 Upgraded to ${newTier.displayName}! 7-Day Free Trial started.',
    );
  }

  Future<void> purchaseRevenueCatPackage(String packageId) async {
    state = state.copyWith(isLoading: true);
    try {
      final upgradedTier = await _revenueCatService.purchasePackage(packageId);
      await upgradeTier(upgradedTier);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        billingError: 'Purchase failed: $e',
      );
    }
  }

  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true);
    try {
      final restoredTier = await _revenueCatService.restorePurchases();
      state = state.copyWith(
        isLoading: false,
        activeTier: restoredTier,
        successMessage: 'Purchases restored successfully (${restoredTier.displayName}).',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        billingError: 'Restore failed: $e',
      );
    }
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
  SubscriptionNotifier.new,
);
