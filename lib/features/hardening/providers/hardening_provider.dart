import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/hardening_engine.dart';

class HardeningState {
  final int syncFailures;
  final bool isDlqBannerActive;
  final String deviceTier;
  final bool isPiiStripped;

  const HardeningState({
    this.syncFailures = 3,
    this.isDlqBannerActive = true,
    this.deviceTier = 'high',
    this.isPiiStripped = true,
  });

  HardeningState copyWith({
    int? syncFailures,
    bool? isDlqBannerActive,
    String? deviceTier,
    bool? isPiiStripped,
  }) {
    return HardeningState(
      syncFailures: syncFailures ?? this.syncFailures,
      isDlqBannerActive: isDlqBannerActive ?? this.isDlqBannerActive,
      deviceTier: deviceTier ?? this.deviceTier,
      isPiiStripped: isPiiStripped ?? this.isPiiStripped,
    );
  }
}

class HardeningNotifier extends StateNotifier<HardeningState> {
  final HardeningEngine engine;

  HardeningNotifier(this.engine) : super(const HardeningState());

  void setDeviceTier(String tier) {
    state = state.copyWith(deviceTier: tier);
  }

  void resetSyncFailures() {
    state = state.copyWith(syncFailures: 0, isDlqBannerActive: false);
  }
}

final hardeningProvider =
    StateNotifierProvider<HardeningNotifier, HardeningState>((ref) {
  return HardeningNotifier(const HardeningEngine());
});
