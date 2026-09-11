enum Environment {
  dev,
  prod,
}

/// Central configuration for multi-environment execution (Dev vs Prod)
class AppConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool enableVerboseLogging;
  final bool isDebugBannerVisible;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
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
    supabaseUrl: String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://abnepbjdslbozmmhjaxq.supabase.co',
    ),
    supabaseAnonKey: String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: '',
    ),
    enableVerboseLogging: true,
    isDebugBannerVisible: true,
  );

  /// Production / Release Environment Blueprint
  static const AppConfig prod = AppConfig(
    environment: Environment.prod,
    appName: 'FitKarma',
    apiBaseUrl: 'https://api.fitkarma.in',
    supabaseUrl: String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://abnepbjdslbozmmhjaxq.supabase.co',
    ),
    supabaseAnonKey: String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: '',
    ),
    enableVerboseLogging: false,
    isDebugBannerVisible: false,
  );
}
