/// §P14-D CI/CD Dart Define Verification Script
///
/// Verifies all required --dart-define environment variables before building release binaries (§P14-D spec).
import 'dart:io';
import 'package:fitkarma/core/config/environment_config_service.dart';

void main(List<String> args) {
  print('🔒 [FitKarma CI/CD] Verifying --dart-define Environment Variables...');

  final isVerified = EnvironmentConfigService.verifyEnvironmentVars(
    EnvironmentConfigService.activeEnvironment,
  );

  if (isVerified) {
    print('✅ Environment Configuration Verified for [${EnvironmentConfigService.activeEnvironment.name.toUpperCase()}]!');
    print('   - AZURE_SQL_ENDPOINT: ${EnvironmentConfigService.azureSqlEndpoint}');
    print('   - AZURE_FUNCTION_BASE_URL: ${EnvironmentConfigService.azureFunctionBaseUrl}');
    print('   - AZURE_ENTRA_CLIENT_ID: ${EnvironmentConfigService.azureEntraClientId}');
    exit(0);
  } else {
    print('❌ ERROR: Missing or invalid --dart-define environment variables!');
    exit(1);
  }
}
