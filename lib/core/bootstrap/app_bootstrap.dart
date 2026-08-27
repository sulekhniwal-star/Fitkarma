import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/local_storage_service.dart';

class AppBootstrap {
  /// Initializes core app services, local storage, system UI, and error handling
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

    // 3. Initialize Firebase (with safety fallback if options not yet configured in local test mode)
    try {
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully.');
    } catch (e) {
      debugPrint('Notice: Firebase initialization deferred or running in offline mode: $e');
    }

    // 4. Global Error Handling
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exceptionAsString()}');
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Uncaught Platform Error: $error\n$stack');
      return true;
    };
  }
}
