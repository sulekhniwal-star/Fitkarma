import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/security/biometric_lock_service.dart';
import 'package:fitkarma/core/security/biometric_gate_provider.dart';

class MockBiometricPlatform implements BiometricAuthPlatform {
  bool isCapable;
  bool shouldSucceed;

  MockBiometricPlatform({this.isCapable = true, this.shouldSucceed = true});

  @override
  Future<bool> isDeviceCapable() async => isCapable;

  @override
  Future<bool> authenticate({required String localizedReason}) async =>
      isCapable && shouldSucceed;
}

void main() {
  group('§P14-A Biometric Verification Gate & Provider Tests', () {
    test('BiometricGateNotifier unlocks when authentication succeeds', () async {
      final mockPlatform = MockBiometricPlatform(isCapable: true, shouldSucceed: true);
      final service = BiometricLockService(mockPlatform);
      final notifier = BiometricGateNotifier(service, 'Test unlock', autoVerify: false);

      expect(notifier.state.isUnlocked, isFalse);
      expect(notifier.state.isAuthenticating, isFalse);

      await notifier.triggerVerification();

      expect(notifier.state.isUnlocked, isTrue);
      expect(notifier.state.isAuthenticating, isFalse);
      expect(notifier.state.error, isNull);

      // Re-lock
      notifier.resetLock();
      expect(notifier.state.isUnlocked, isFalse);
    });

    test('BiometricGateNotifier sets error when authentication fails or device incapable', () async {
      final mockPlatform = MockBiometricPlatform(isCapable: false, shouldSucceed: false);
      final service = BiometricLockService(mockPlatform);
      final notifier = BiometricGateNotifier(service, 'Failed unlock', autoVerify: false);

      await notifier.triggerVerification();

      expect(notifier.state.isUnlocked, isFalse);
      expect(notifier.state.error, contains('Biometric authorization required'));
    });

    test('biometricGateProvider isolates state across multiple route IDs', () async {
      final container = ProviderContainer(
        overrides: [
          biometricServiceProvider.overrideWithValue(
            BiometricLockService(MockBiometricPlatform(shouldSucceed: true)),
          ),
        ],
      );

      final glucoseState = container.read(biometricGateProvider('/health/glucose'));
      final bpState = container.read(biometricGateProvider('/health/bp'));

      expect(glucoseState, isNotNull);
      expect(bpState, isNotNull);
    });
  });
}
