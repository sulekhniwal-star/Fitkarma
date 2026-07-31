import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/premium_billing_engine.dart';
import '../models/subscription_model.dart';

class PremiumState {
  final EntitlementResult entitlement;
  final List<SubscriptionPackage> packages;

  const PremiumState({
    required this.entitlement,
    this.packages = RevenueCatConfig.availablePackages,
  });

  PremiumState copyWith({
    EntitlementResult? entitlement,
    List<SubscriptionPackage>? packages,
  }) {
    return PremiumState(
      entitlement: entitlement ?? this.entitlement,
      packages: packages ?? this.packages,
    );
  }
}

class PremiumNotifier extends StateNotifier<PremiumState> {
  final PremiumBillingEngine engine;

  PremiumNotifier(this.engine)
      : super(
          PremiumState(
            entitlement: const PremiumBillingEngine().checkEntitlement(
              hasActiveSubscription: false,
              isTrialActive: false,
            ),
          ),
        );

  void startFreeTrial() {
    final result = engine.checkEntitlement(
      hasActiveSubscription: false,
      isTrialActive: true,
    );
    state = state.copyWith(entitlement: result);
  }
}

final premiumProvider = StateNotifierProvider<PremiumNotifier, PremiumState>((ref) {
  return PremiumNotifier(const PremiumBillingEngine());
});
