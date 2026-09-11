import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized service wrapping Supabase Client and Auth helpers
class SupabaseService {
  final SupabaseClient client;

  SupabaseService({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  /// Current authenticated user
  User? get currentUser => client.auth.currentUser;

  /// Current user ID (UUID) or null
  String? get currentUserId => client.auth.currentUser?.id;

  /// Check if user is currently authenticated
  bool get isAuthenticated => client.auth.currentUser != null;

  /// Stream of authentication state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  /// Send Phone OTP (India standard format e.g. +91XXXXXXXXXX)
  Future<void> sendPhoneOtp({required String phoneNumber}) async {
    final formattedPhone = phoneNumber.startsWith('+')
        ? phoneNumber
        : '+91${phoneNumber.replaceAll(RegExp(r'\D'), '')}';

    await client.auth.signInWithOtp(
      phone: formattedPhone,
    );
  }

  /// Verify 6-digit Phone OTP
  Future<AuthResponse> verifyPhoneOtp({
    required String phoneNumber,
    required String token,
  }) async {
    final formattedPhone = phoneNumber.startsWith('+')
        ? phoneNumber
        : '+91${phoneNumber.replaceAll(RegExp(r'\D'), '')}';

    return await client.auth.verifyOTP(
      phone: formattedPhone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// Sign In with Google OAuth
  Future<bool> signInWithGoogle({String? redirectTo}) async {
    return await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectTo,
    );
  }

  /// Sign Out of current session
  Future<void> signOut() async {
    await client.auth.signOut();
  }
}

// ----------------------------------------------------------------------------
// Riverpod Providers for Supabase
// ----------------------------------------------------------------------------

/// Provides the raw SupabaseClient instance
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provides the SupabaseService instance
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseService(client: client);
});

/// Provides a stream of AuthState changes
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  return service.authStateChanges;
});

/// Provides the current authenticated User (or null)
final currentUserProvider = Provider<User?>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  // Re-read when auth state stream emits
  ref.watch(authStateStreamProvider);
  return service.currentUser;
});

/// Provides whether a user is currently logged in
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});
