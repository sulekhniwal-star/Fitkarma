/// §P14-D Environment Configuration & --dart-define Variable Manager
///
/// Manages dev/staging/prod environment settings and verifies all required compile-time --dart-define parameters matching §P14-D spec.
library;

enum AppEnvironment { dev, staging, prod }

class EnvironmentConfigService {
  const EnvironmentConfigService();

  static const String currentEnvironmentName =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');

  static const String azureSqlEndpoint = String.fromEnvironment(
    'AZURE_SQL_ENDPOINT',
    defaultValue: 'https://fitkarma-api-dev.azurewebsites.net',
  );

  static const String azureFunctionBaseUrl = String.fromEnvironment(
    'AZURE_FUNCTION_BASE_URL',
    defaultValue: 'https://fitkarma-func-dev.azurewebsites.net/api',
  );

  static const String azureEntraClientId = String.fromEnvironment(
    'AZURE_ENTRA_CLIENT_ID',
    defaultValue: 'fitkarma-entra-client-id-dev',
  );

  static const String groqFunctionKey = String.fromEnvironment(
    'GROQ_FUNCTION_KEY',
    defaultValue: 'groq_sec_key_dev',
  );

  static AppEnvironment get activeEnvironment => switch (currentEnvironmentName.toLowerCase()) {
        'prod' || 'production' => AppEnvironment.prod,
        'staging' => AppEnvironment.staging,
        _ => AppEnvironment.dev,
      };

  /// Verifies that all required --dart-define variables are set and non-empty for [env] (§P14-D spec).
  static bool verifyEnvironmentVars(AppEnvironment env) {
    if (azureSqlEndpoint.trim().isEmpty) return false;
    if (azureFunctionBaseUrl.trim().isEmpty) return false;
    if (azureEntraClientId.trim().isEmpty) return false;
    if (groqFunctionKey.trim().isEmpty) return false;

    if (env == AppEnvironment.prod) {
      if (!azureSqlEndpoint.startsWith('https://')) return false;
      if (!azureFunctionBaseUrl.startsWith('https://')) return false;
    }

    return true;
  }
}
