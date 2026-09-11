import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../config/app_environment.dart';
import '../services/local_storage_service.dart';

class AppBootstrap {
  /// Initializes core app services, Supabase backend, local storage, system UI, and error handling
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Configure System UI Overlays (immersive dark theme status bar)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0D0F12),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // 2. Initialize Local Storage (Hive offline cache)
    try {
      await LocalStorageService.initialize();
    } catch (e) {
      debugPrint('Warning: LocalStorageService initialization deferred: $e');
    }

    // 3. Initialize Supabase Backend
    try {
      final config = AppConfig.current;
      if (config.supabaseUrl.isNotEmpty && config.supabaseAnonKey.isNotEmpty) {
        await Supabase.initialize(
          url: config.supabaseUrl,
          publishableKey: config.supabaseAnonKey,
        );
        debugPrint('Supabase initialized successfully for ${config.appName}');
      } else {
        debugPrint(
            'Notice: Supabase credentials not provided, running in offline-first mode.');
      }
    } catch (e) {
      debugPrint(
          'Notice: Supabase initialization deferred or running in offline mode: $e');
    }

    // 4. Global Error Handling & Sentry Monitoring
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exceptionAsString()}');
      try {
        Sentry.captureException(details.exception, stackTrace: details.stack);
      } catch (_) {}
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught Platform Error: $error\n$stack');
      try {
        Sentry.captureException(error, stackTrace: stack);
      } catch (_) {}
      return true;
    };
  }
}
