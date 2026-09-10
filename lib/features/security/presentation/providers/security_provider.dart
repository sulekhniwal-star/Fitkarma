import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/security_engine.dart';
import '../../domain/security_models.dart';

/// State of Enterprise Security & App Check
class SecurityState {
  final SecurityAuditReport report;
  final bool isBiometricUnlocked;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const SecurityState({
    required this.report,
    this.isBiometricUnlocked = false,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  SecurityState copyWith({
    SecurityAuditReport? report,
    bool? isBiometricUnlocked,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return SecurityState(
      report: report ?? this.report,
      isBiometricUnlocked: isBiometricUnlocked ?? this.isBiometricUnlocked,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}

final securityProvider =
    StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
  return SecurityNotifier();
});

class SecurityNotifier extends StateNotifier<SecurityState> {
  SecurityNotifier() : super(_buildInitialState());

  static const SecurityEngine _engine = SecurityEngine();

  static SecurityState _buildInitialState() {
    final report = _engine.evaluateSecurityPosture(
      isAppCheckActive: true,
      provider: AppCheckProviderType.playIntegrity,
      biometricSettings: const BiometricLockSettings(),
      areZeroSecretsMaintained: true,
    );
    return SecurityState(report: report);
  }

  void toggleAppCheck(bool isActive) {
    final updated = _engine.evaluateSecurityPosture(
      isAppCheckActive: isActive,
      provider: state.report.activeProvider,
      biometricSettings: state.report.biometricSettings,
      areZeroSecretsMaintained: true,
    );
    state = state.copyWith(
      report: updated,
      successMessage: isActive
          ? 'Firebase App Check attestation enabled!'
          : 'App Check disabled (Sandbox mode active).',
    );
  }

  void setProvider(AppCheckProviderType provider) {
    final updated = _engine.evaluateSecurityPosture(
      isAppCheckActive: state.report.isAppCheckActive,
      provider: provider,
      biometricSettings: state.report.biometricSettings,
      areZeroSecretsMaintained: true,
    );
    state = state.copyWith(
      report: updated,
      successMessage: 'App Check attestation switched to ${provider.name}.',
    );
  }

  void updateBiometricSettings(BiometricLockSettings settings) {
    final updated = _engine.evaluateSecurityPosture(
      isAppCheckActive: state.report.isAppCheckActive,
      provider: state.report.activeProvider,
      biometricSettings: settings,
      areZeroSecretsMaintained: true,
    );
    state = state.copyWith(
      report: updated,
      successMessage: 'Biometric security settings saved.',
    );
  }

  /// Triggers biometric prompt simulation for sensitive health data access
  Future<bool> authenticateBiometrics() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate native local_auth biometric verification
    await Future.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      isLoading: false,
      isBiometricUnlocked: true,
      successMessage:
          'Biometric verification successful. Health vault unlocked.',
    );
    return true;
  }

  void lockBiometricVault() {
    state = state.copyWith(
      isBiometricUnlocked: false,
      successMessage: 'Sensitive health vault locked.',
    );
  }
}
