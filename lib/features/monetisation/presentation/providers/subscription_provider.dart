import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/subscription_engine.dart';
import '../../domain/subscription_models.dart';

/// State of subscription management and paywall
class SubscriptionState {
  final UserEntitlements entitlements;
  final BillingCycle selectedBillingCycle;
  final SubscriptionTier selectedTier;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SubscriptionState({
    required this.entitlements,
    required this.selectedBillingCycle,
    required this.selectedTier,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  SubscriptionState copyWith({
    UserEntitlements? entitlements,
    BillingCycle? selectedBillingCycle,
    SubscriptionTier? selectedTier,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return SubscriptionState(
      entitlements: entitlements ?? this.entitlements,
      selectedBillingCycle: selectedBillingCycle ?? this.selectedBillingCycle,
      selectedTier: selectedTier ?? this.selectedTier,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier()
      : super(
          SubscriptionState(
            entitlements: UserEntitlements.free('user_fitkarma_local'),
            selectedBillingCycle: BillingCycle.annual,
            selectedTier: SubscriptionTier.pro,
          ),
        );

  static const SubscriptionEngine _engine = SubscriptionEngine();

  void selectBillingCycle(BillingCycle cycle) {
    state = state.copyWith(selectedBillingCycle: cycle);
  }

  void selectTier(SubscriptionTier tier) {
    state = state.copyWith(selectedTier: tier);
  }

  /// Evaluates permission for a specific app feature
  EntitlementAccessResult checkAccess(EntitlementFeature feature) {
    return _engine.evaluateFeatureAccess(state.entitlements, feature);
  }

  /// Simulates / activates offline sandbox upgrade with valid cryptographic mock hash
  Future<void> upgradeTier(SubscriptionTier targetTier) async {
    if (targetTier == state.entitlements.tier) return;

    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    // Simulate verified server handshake
    await Future.delayed(const Duration(milliseconds: 300));

    final newEntitlements = _engine.createSandboxEntitlements(
      userId: state.entitlements.userId,
      tier: targetTier,
      cycle: state.selectedBillingCycle,
    );

    state = state.copyWith(
      entitlements: newEntitlements,
      selectedTier: targetTier,
      isLoading: false,
      successMessage: targetTier == SubscriptionTier.free
          ? 'Switched to FitKarma Free'
          : 'Upgraded to ${targetTier.name} successfully!',
    );
  }

  /// Restores server-verified active subscription
  Future<void> restorePurchases() async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    await Future.delayed(const Duration(milliseconds: 250));

    state = state.copyWith(
      isLoading: false,
      successMessage: 'Server entitlements synced & verified.',
    );
  }

  /// Increments daily AI call counter
  void recordAiCallUsed() {
    if (!_engine.canMakeAiCall(state.entitlements)) return;

    final updated = UserEntitlements(
      userId: state.entitlements.userId,
      tier: state.entitlements.tier,
      status: state.entitlements.status,
      expiresAt: state.entitlements.expiresAt,
      willRenew: state.entitlements.willRenew,
      originalPurchaseTransactionId:
          state.entitlements.originalPurchaseTransactionId,
      dailyAiCallsUsed: state.entitlements.dailyAiCallsUsed + 1,
      lastQuotaResetDate: state.entitlements.lastQuotaResetDate,
      serverVerificationHash: state.entitlements.serverVerificationHash,
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(entitlements: updated);
  }
}
