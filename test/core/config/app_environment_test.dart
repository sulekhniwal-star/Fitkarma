import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/config/app_environment.dart';

void main() {
  group('AppConfig & Environment Multi-Environment Tests', () {
    test('Dev blueprint initializes with development settings', () {
      final config = AppConfig.dev;
      expect(config.environment, equals(Environment.dev));
      expect(config.isDev, isTrue);
      expect(config.isProd, isFalse);
      expect(config.appName, equals('FitKarma Dev'));
      expect(config.enableVerboseLogging, isTrue);
      expect(config.isDebugBannerVisible, isTrue);
      expect(config.apiBaseUrl, contains('staging'));
    });

    test('Prod blueprint initializes with production release settings', () {
      final config = AppConfig.prod;
      expect(config.environment, equals(Environment.prod));
      expect(config.isProd, isTrue);
      expect(config.isDev, isFalse);
      expect(config.appName, equals('FitKarma'));
      expect(config.enableVerboseLogging, isFalse);
      expect(config.isDebugBannerVisible, isFalse);
      expect(config.apiBaseUrl, contains('api.fitkarma.in'));
    });

    test('AppConfig.initialize sets singleton instance correctly', () {
      AppConfig.initialize(AppConfig.dev);
      expect(AppConfig.current.isDev, isTrue);

      AppConfig.initialize(AppConfig.prod);
      expect(AppConfig.current.isProd, isTrue);
    });
  });
}
