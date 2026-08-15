// §P14-A Biometric Verification Gate & Riverpod State Management
// Cross-reference: §P14-A in Fitkarma_documentation.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'biometric_lock_service.dart';

class BiometricGateState {
  final bool isUnlocked;
  final bool isAuthenticating;
  final String? error;

  const BiometricGateState({
    required this.isUnlocked,
    required this.isAuthenticating,
    this.error,
  });

  factory BiometricGateState.initial() => const BiometricGateState(
        isUnlocked: false,
        isAuthenticating: false,
      );

  BiometricGateState copyWith({
    bool? isUnlocked,
    bool? isAuthenticating,
    String? error,
  }) {
    return BiometricGateState(
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      error: error,
    );
  }
}

class BiometricGateNotifier extends StateNotifier<BiometricGateState> {
  final BiometricLockService _service;
  final String _reason;

  BiometricGateNotifier(
    this._service,
    this._reason, {
    bool autoVerify = true,
  }) : super(BiometricGateState.initial()) {
    if (autoVerify) {
      triggerVerification();
    }
  }

  /// Triggers biometric authentication prompt
  Future<void> triggerVerification() async {
    state = state.copyWith(isAuthenticating: true, error: null);

    final success = await _service.authenticate(_reason);
    if (success) {
      state = state.copyWith(isUnlocked: true, isAuthenticating: false);
    } else {
      state = state.copyWith(
        isUnlocked: false,
        isAuthenticating: false,
        error: 'Biometric authorization required.',
      );
    }
  }

  /// Re-locks the gated route/feature
  void resetLock() {
    state =
        const BiometricGateState(isUnlocked: false, isAuthenticating: false);
  }

  /// Allows explicit unlock during tests
  void unlockManuallyForTesting() {
    state = const BiometricGateState(isUnlocked: true, isAuthenticating: false);
  }
}

/// Managed family provider that locks screen by ID/Route
final biometricGateProvider = StateNotifierProvider.family<
    BiometricGateNotifier, BiometricGateState, String>((ref, routeName) {
  final service = ref.watch(biometricServiceProvider);
  final String reason = 'Unlock secure metrics for $routeName';
  return BiometricGateNotifier(service, reason);
});
