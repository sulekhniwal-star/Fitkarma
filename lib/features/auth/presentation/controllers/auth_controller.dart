import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/auth_user_model.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for Auth Repository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client);
});

/// Stream of auth state changes (FitKarmaUser? or null)
final authStateStreamProvider = StreamProvider<FitKarmaUser?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges;
});

/// Current authenticated user provider
final currentUserProvider = Provider<FitKarmaUser?>((ref) {
  final asyncUser = ref.watch(authStateStreamProvider);
  return asyncUser.value ?? ref.watch(authRepositoryProvider).currentUser;
});

/// State of auth action execution (idle, loading, error, success)
enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  IAuthRepository get _authRepository => ref.read(authRepositoryProvider);

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      final msg = _formatAuthError(e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: msg,
      );
    }
  }

  Future<void> signUpWithEmail(String email, String password, String? fullName) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      state = state.copyWith(
        status: AuthStatus.success,
        successMessage: 'Account created! Please check your email inbox to verify your account and sign in.',
      );
    } catch (e) {
      final msg = _formatAuthError(e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: msg,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.signInWithGoogle();
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      final msg = _formatAuthError(e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: msg,
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.signOut();
      state = state.copyWith(status: AuthStatus.initial);
    } catch (e) {
      final msg = _formatAuthError(e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: msg,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authRepository.resetPassword(email);
      state = state.copyWith(
        status: AuthStatus.success,
        successMessage: 'Password reset link sent to $email.',
      );
    } catch (e) {
      final msg = _formatAuthError(e);
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: msg,
      );
    }
  }

  String _formatAuthError(dynamic e) {
    final str = e.toString().toLowerCase();

    if (str.contains('invalid login credentials') || str.contains('invalid_credentials')) {
      return 'Incorrect email or password. If you just created your account, please verify the link in your email inbox first.';
    }

    if (str.contains('email not confirmed') || str.contains('email_not_confirmed')) {
      return 'Please verify your email address to sign in. We have sent a confirmation link to your inbox.';
    }

    if (str.contains('user already registered') || str.contains('user_already_exists') || str.contains('already registered')) {
      return 'An account with this email already exists. Please tap "Sign In" above to continue.';
    }

    if (str.contains('password should be at least') || str.contains('weak_password')) {
      return 'Password must be at least 6 characters long.';
    }

    if (str.contains('invalid email') || str.contains('validation_failed')) {
      return 'Please enter a valid email address.';
    }

    if (str.contains('socketexception') ||
        str.contains('failed host lookup') ||
        str.contains('socketfailed') ||
        str.contains('network') ||
        str.contains('connection refused') ||
        str.contains('timeout')) {
      return 'Unable to connect to the server right now. Please check your internet connection or tap "Explore as Guest" below.';
    }

    if (str.contains('over_email_send_rate_limit') || str.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment before trying again.';
    }

    return 'Something went wrong while signing in. Please check your details and try again.';
  }

  void clearError() {
    if (state.errorMessage != null || state.successMessage != null) {
      state = state.copyWith(errorMessage: null, successMessage: null);
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
