import 'package:flutter/foundation.dart';

/// Centralized configuration for Supabase integration across Web, Android, and iOS.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://quxqxdtsusrokdxuizxy.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF1eHF4ZHRzdXNyb2tkeHVpenh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk5ODMyNDQsImV4cCI6MjEwNTU1OTI0NH0.nm2WqQKZ5Pjd1cb5sxNln4F6x8i3UoW3Q8UvwZcEydI';

  /// Standard OAuth redirect URL configured in AndroidManifest, iOS Info.plist, and Supabase Dashboard
  static String? get authRedirectUrl {
    if (kIsWeb) {
      return null; // On web, Supabase automatically handles current origin
    }
    return 'com.fitkarma.app.fitkarma://login-callback/';
  }
}
