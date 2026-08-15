// §P13-A Premium State Management (Riverpod 2.x, Pure Dart, Offline-First)
// Cross-reference: §P13-A in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/premium_billing_engine.dart';
import '../models/subscription_model.dart';

/// In-Memory & Local Key-Value Store for Billing State & Daily Quota Tracking (§P13-A)
class BillingStorage {
  static final Map<String, dynamic> _inMemoryStore = {};

  Future<int?> getInt(String key) async => _inMemoryStore[key] as int?;
  Future<void> setInt(String key, int val) async => _inMemoryStore[key] = val;

  Future<String?> getString(String key) async => _inMemoryStore[key] as String?;
  Future<void> setString(String key, String val) async =>
      _inMemoryStore[key] = val;

  Future<bool?> getBool(String key) async => _inMemoryStore[key] as bool?;
  Future<void> setBool(String key, bool val) async => _inMemoryStore[key] = val;

  static void resetForTesting() {
    _inMemoryStore.clear();
  }
}

/// §P13-A Premium State Model
class PremiumState {
  final SubscriptionTier activeTier;
  final DateTime? renewalDate;
  final int dailyAiMessageCount;
  final int dailyMealPhotoAnalysisCount;
  final String billingErrorMessage;
  final bool isTrialActive;
  final List<SubscriptionPackage> packages;
  final SubscriptionPackage selectedPackage;

  const PremiumState({
    required this.activeTier,
    this.renewalDate,
    required this.dailyAiMessageCount,
    required this.dailyMealPhotoAnalysisCount,
    required this.billingErrorMessage,
    required this.isTrialActive,
    this.packages = RevenueCatConfig.availablePackages,
    required this.selectedPackage,
  });

  factory PremiumState.initial() => PremiumState(
        activeTier: SubscriptionTier.free,
        dailyAiMessageCount: 0,
        dailyMealPhotoAnalysisCount: 0,
        billingErrorMessage: '',
        isTrialActive: false,
        packages: RevenueCatConfig.availablePackages,
        selectedPackage: RevenueCatConfig
            .availablePackages[2], // Annual by default (best value)
      );

  bool get isProActive => activeTier != SubscriptionTier.free || isTrialActive;

  PremiumState copyWith({
    SubscriptionTier? activeTier,
    DateTime? renewalDate,
    int? dailyAiMessageCount,
    int? dailyMealPhotoAnalysisCount,
    String? billingErrorMessage,
    bool? isTrialActive,
    List<SubscriptionPackage>? packages,
    SubscriptionPackage? selectedPackage,
  }) {
    return PremiumState(
      activeTier: activeTier ?? this.activeTier,
      renewalDate: renewalDate ?? this.renewalDate,
      dailyAiMessageCount: dailyAiMessageCount ?? this.dailyAiMessageCount,
      dailyMealPhotoAnalysisCount:
          dailyMealPhotoAnalysisCount ?? this.dailyMealPhotoAnalysisCount,
      billingErrorMessage: billingErrorMessage ?? this.billingErrorMessage,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
    );
  }
}

/// §P13-A PremiumStateNotifier
class PremiumStateNotifier extends StateNotifier<PremiumState> {
  final PremiumBillingEngine engine;
  final BillingStorage storage;

  PremiumStateNotifier([
    this.engine = const PremiumBillingEngine(),
    BillingStorage? storage,
  ])  : storage = storage ?? BillingStorage(),
        super(PremiumState.initial()) {
    loadBillingState();
  }

  /// Loads current billing tier and cached usage counts
  Future<void> loadBillingState() async {
    try {
      // Resolve billing tier
      final tierIndex = await storage.getInt('premium_tier_index') ?? 0;
      final tier = tierIndex >= 0 && tierIndex < SubscriptionTier.values.length
          ? SubscriptionTier.values[tierIndex]
          : SubscriptionTier.free;

      // Resolve date boundary reset (§P13-A)
      final lastResetString = await storage.getString('quota_last_reset_date');
      final todayString = DateTime.now().toIso8601String().substring(0, 10);

      int messages = await storage.getInt('daily_ai_messages') ?? 0;
      int photos = await storage.getInt('daily_meal_photos') ?? 0;

      if (lastResetString != todayString) {
        // Date changed - reset daily usage quotas
        await storage.setString('quota_last_reset_date', todayString);
        await storage.setInt('daily_ai_messages', 0);
        await storage.setInt('daily_meal_photos', 0);
        messages = 0;
        photos = 0;
      }

      final trialActive =
          await storage.getBool('billing_trial_active') ?? false;
      final renewalMilli = await storage.getInt('billing_renewal_milli');
      final renewal = renewalMilli != null
          ? DateTime.fromMillisecondsSinceEpoch(renewalMilli)
          : null;

      state = state.copyWith(
        activeTier: tier,
        renewalDate: renewal,
        dailyAiMessageCount: messages,
        dailyMealPhotoAnalysisCount: photos,
        billingErrorMessage: '',
        isTrialActive: trialActive,
      );
    } catch (_) {}
  }

  /// Selects active plan on paywall sheet
  void selectPackage(SubscriptionPackage package) {
    state = state.copyWith(selectedPackage: package);
  }

  /// Verifies if user has remaining quota or a paid subscription (§P13-A)
  bool checkAccess(PaywallTrigger trigger) {
    return engine.checkAccess(
      trigger: trigger,
      tier: state.activeTier,
      dailyAiMessages: state.dailyAiMessageCount,
      dailyMealPhotos: state.dailyMealPhotoAnalysisCount,
    );
  }

  /// Increments daily AI coach message count
  Future<void> incrementAiMessageCount() async {
    final nextVal = state.dailyAiMessageCount + 1;
    state = state.copyWith(dailyAiMessageCount: nextVal);

    try {
      await storage.setInt('daily_ai_messages', nextVal);
    } catch (_) {}
  }

  /// Increments daily meal photo count
  Future<void> incrementMealPhotoCount() async {
    final nextVal = state.dailyMealPhotoAnalysisCount + 1;
    state = state.copyWith(dailyMealPhotoAnalysisCount: nextVal);

    try {
      await storage.setInt('daily_meal_photos', nextVal);
    } catch (_) {}
  }

  /// Starts 7-day free trial on selected subscription package (§P13-A)
  Future<void> startFreeTrial([SubscriptionPackage? package]) async {
    final selected = package ?? state.selectedPackage;
    final renewal = DateTime.now().add(const Duration(days: 7));

    state = state.copyWith(
      activeTier: selected.tier,
      isTrialActive: true,
      renewalDate: renewal,
    );

    try {
      await storage.setInt('premium_tier_index', selected.tier.index);
      await storage.setInt(
          'billing_renewal_milli', renewal.millisecondsSinceEpoch);
      await storage.setBool('billing_trial_active', true);
    } catch (_) {}
  }

  /// Upgrades subscription tier directly
  Future<void> upgradeSubscription(SubscriptionTier tier) async {
    final renewal = DateTime.now().add(const Duration(days: 30));

    state = state.copyWith(
      activeTier: tier,
      isTrialActive: false,
      renewalDate: renewal,
    );

    try {
      await storage.setInt('premium_tier_index', tier.index);
      await storage.setInt(
          'billing_renewal_milli', renewal.millisecondsSinceEpoch);
      await storage.setBool('billing_trial_active', false);
    } catch (_) {}
  }
}

final premiumProvider =
    StateNotifierProvider<PremiumStateNotifier, PremiumState>((ref) {
  return PremiumStateNotifier(const PremiumBillingEngine());
});
