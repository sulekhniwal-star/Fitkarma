enum Environment {
  dev,
  prod,
}

/// Central configuration for multi-environment execution (Dev vs Prod)
class AppConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableVerboseLogging;
  final bool isDebugBannerVisible;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    this.enableVerboseLogging = false,
    this.isDebugBannerVisible = false,
  });

  static AppConfig? _instance;

  static AppConfig get current => _instance ?? prod;

  static void initialize(AppConfig config) {
    _instance = config;
  }

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;

  /// Development Environment Blueprint
  static const AppConfig dev = AppConfig(
    environment: Environment.dev,
    appName: 'FitKarma Dev',
    apiBaseUrl: 'https://staging-api.fitkarma.in',
    enableVerboseLogging: true,
    isDebugBannerVisible: true,
  );

  /// Production / Release Environment Blueprint
  static const AppConfig prod = AppConfig(
    environment: Environment.prod,
    appName: 'FitKarma',
    apiBaseUrl: 'https://api.fitkarma.in',
    enableVerboseLogging: false,
    isDebugBannerVisible: false,
  );
}
