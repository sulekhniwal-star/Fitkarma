import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import '../domain/models/auth_user_model.dart';

abstract class IAuthRepository {
  Stream<FitKarmaUser?> get authStateChanges;
  FitKarmaUser? get currentUser;
  Future<FitKarmaUser?> signInWithEmail({required String email, required String password});
  Future<FitKarmaUser?> signUpWithEmail({required String email, required String password, String? fullName});
  Future<bool> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class SupabaseAuthRepository implements IAuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<FitKarmaUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? FitKarmaUser.fromSupabase(user) : null;
    });
  }

  @override
  FitKarmaUser? get currentUser {
    final user = _client.auth.currentUser;
    return user != null ? FitKarmaUser.fromSupabase(user) : null;
  }

  @override
  Future<FitKarmaUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      final user = response.user;
      return user != null ? FitKarmaUser.fromSupabase(user) : null;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Sign in failed. Please check your credentials.');
    }
  }

  @override
  Future<FitKarmaUser?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: fullName != null ? {'full_name': fullName.trim()} : null,
      );
      final user = response.user;
      return user != null ? FitKarmaUser.fromSupabase(user) : null;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Registration failed. Please try again.');
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final redirectUrl = SupabaseConfig.authRedirectUrl;
      return await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Google sign-in initiation failed. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: SupabaseConfig.authRedirectUrl,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to send password reset email.');
    }
  }
}
