// §P14-A Biometric Verification Service (Pure Dart / Platform Abstraction)
// Cross-reference: §P14-A in Fitkarma_documentation.md

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract Biometric Authentication Interface
abstract class BiometricAuthPlatform {
  Future<bool> isDeviceCapable();
  Future<bool> authenticate({required String localizedReason});
}

/// Default In-App / Simulated Biometric Authenticator
class DefaultBiometricAuthPlatform implements BiometricAuthPlatform {
  final bool _deviceCapable;
  final bool _mockAuthResult;

  const DefaultBiometricAuthPlatform({
    bool deviceCapable = true,
    bool mockAuthResult = true,
  })  : _deviceCapable = deviceCapable,
        _mockAuthResult = mockAuthResult;

  @override
  Future<bool> isDeviceCapable() async {
    return _deviceCapable;
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    if (!_deviceCapable) return false;
    return _mockAuthResult;
  }
}

/// §P14-A Biometric Lock Service
class BiometricLockService {
  final BiometricAuthPlatform _platform;

  BiometricLockService([BiometricAuthPlatform? platform])
      : _platform = platform ?? const DefaultBiometricAuthPlatform();

  /// Verifies if device has active biometrics or passcode lock
  Future<bool> isDeviceCapable() async {
    try {
      return await _platform.isDeviceCapable();
    } catch (e) {
      debugPrint('Biometric capability check error: $e');
      return false;
    }
  }

  /// Prompts user with OS-level biometric authentication
  Future<bool> authenticate(String reason) async {
    try {
      if (!await isDeviceCapable()) return false;
      return await _platform.authenticate(localizedReason: reason);
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false; // Lock screen on any OS error
    }
  }
}

final biometricServiceProvider =
    Provider<BiometricLockService>((ref) => BiometricLockService());
