import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/security/domain/security_engine.dart';
import 'package:fitkarma/features/security/domain/security_models.dart';
import 'package:fitkarma/features/security/presentation/providers/security_provider.dart';

void main() {
  group('SecurityEngine Deterministic Tests', () {
    const engine = SecurityEngine();

    test('Full enterprise security posture evaluation yields 100/100 score',
        () {
      final report = engine.evaluateSecurityPosture(
        isAppCheckActive: true,
        provider: AppCheckProviderType.playIntegrity,
        biometricSettings: const BiometricLockSettings(
          isBiometricLockEnabled: true,
          requireOnClinicalReports: true,
          requireOnDoctorSharing: true,
          requireOnAffiliatePayouts: true,
        ),
        areZeroSecretsMaintained: true,
      );

      expect(report.overallSecurityScore, equals(100));
      expect(report.isEnterpriseHardened, isTrue);
      expect(report.checkItems.length, equals(6));
      expect(report.checkItems.every((c) => c.isPassed), isTrue);
    });

    test('Disabling App Check lowers score and produces warning status', () {
      final report = engine.evaluateSecurityPosture(
        isAppCheckActive: false,
        provider: AppCheckProviderType.debugProvider,
        biometricSettings: const BiometricLockSettings(),
        areZeroSecretsMaintained: true,
      );

      expect(report.overallSecurityScore, lessThan(100));
      final appCheckItem = report.checkItems.firstWhere(
        (c) => c.pillar == SecurityPillar.appCheckIntegrity,
      );
      expect(appCheckItem.status, equals(SecurityCheckStatus.warning));
    });

    test('Secrets scanner flags dangerous API key prefixes in source code', () {
      expect(engine.verifyZeroSecrets('const apiKey = "gsk_live_secret_123";'),
          isFalse);
      expect(engine.verifyZeroSecrets('const openAiKey = "sk-proj-999";'),
          isFalse);
      expect(engine.verifyZeroSecrets('const rcKey = "rc_secret_token";'),
          isFalse);
      expect(
          engine.verifyZeroSecrets('const googleKey = "AIzaSyXYZ";'), isFalse);
      expect(
          engine.verifyZeroSecrets(
              'const safeClientCode = "callCloudFunction(\'askAiCoach\')";'),
          isTrue);
    });

    test('Biometric setting copyWith mutates fields correctly', () {
      const initial = BiometricLockSettings(isBiometricLockEnabled: true);
      final updated = initial.copyWith(requireOnClinicalReports: false);

      expect(updated.isBiometricLockEnabled, isTrue);
      expect(updated.requireOnClinicalReports, isFalse);
    });
  });

  group('Security StateNotifier Provider Tests', () {
    test(
        'StateNotifier toggles App Check, switches provider, and handles biometrics',
        () async {
      final notifier = SecurityNotifier();

      expect(notifier.state.report.isAppCheckActive, isTrue);
      expect(notifier.state.isBiometricUnlocked, isFalse);

      notifier.toggleAppCheck(false);
      expect(notifier.state.report.isAppCheckActive, isFalse);

      notifier.setProvider(AppCheckProviderType.appAttest);
      expect(notifier.state.report.activeProvider,
          equals(AppCheckProviderType.appAttest));

      await notifier.authenticateBiometrics();
      expect(notifier.state.isBiometricUnlocked, isTrue);
      expect(notifier.state.successMessage, contains('vault unlocked'));

      notifier.lockBiometricVault();
      expect(notifier.state.isBiometricUnlocked, isFalse);
    });
  });
}
