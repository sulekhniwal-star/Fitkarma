import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../main.dart';
import '../controllers/auth_controller.dart';
import 'auth_screen.dart';

/// AuthGate listens to real-time auth state changes from Supabase.
/// If authenticated -> loads main FitKarma Dashboard.
/// If unauthenticated -> displays AuthScreen.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateStreamProvider);

    return authStateAsync.when(
      data: (user) {
        if (user != null) {
          return const FoundationDashboardScreen();
        }
        return const AuthScreen();
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryCyan,
          ),
        ),
      ),
      error: (err, stack) => const AuthScreen(),
    );
  }
}
