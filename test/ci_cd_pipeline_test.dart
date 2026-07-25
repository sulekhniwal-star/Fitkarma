/// §P14-D CI/CD Pipeline — Unit & Verification Tests

import 'dart:io';
import 'package:fitkarma/core/config/environment_config_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('§P14-D Environment --dart-define Config Tests', () {
    test('verifies default dev environment variables are populated and valid', () {
      expect(EnvironmentConfigService.azureSqlEndpoint, isNotEmpty);
      expect(EnvironmentConfigService.azureFunctionBaseUrl, isNotEmpty);
      expect(EnvironmentConfigService.azureEntraClientId, isNotEmpty);
      expect(EnvironmentConfigService.groqFunctionKey, isNotEmpty);
    });

    test('verifyEnvironmentVars returns true for dev, staging & prod configs', () {
      expect(EnvironmentConfigService.verifyEnvironmentVars(AppEnvironment.dev), isTrue);
      expect(EnvironmentConfigService.verifyEnvironmentVars(AppEnvironment.staging), isTrue);
      expect(EnvironmentConfigService.verifyEnvironmentVars(AppEnvironment.prod), isTrue);
    });
  });

  group('§P14-D GitHub Actions Workflow YAML Verification Tests', () {
    test('ci.yml workflow file exists and defines test, build-android, and build-ios jobs', () {
      final ciFile = File('.github/workflows/ci.yml');
      expect(ciFile.existsSync(), isTrue);

      final content = ciFile.readAsStringSync();

      expect(content, contains('test:'));
      expect(content, contains('build-android:'));
      expect(content, contains('build-ios:'));
      expect(content, contains('flutter test'));
      expect(content, contains('flutter build appbundle --release'));
      expect(content, contains('flutter build ipa --release'));
      expect(content, contains('--dart-define=AZURE_SQL_ENDPOINT'));
      expect(content, contains('--dart-define=AZURE_FUNCTION_BASE_URL'));
    });
  });
}
