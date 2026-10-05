import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../health_os/presentation/providers/dashboard_providers.dart';
import '../../../health_os/presentation/screens/main_navigation_shell.dart';
import '../../../onboarding/presentation/screens/onboarding_flow_screen.dart';
import '../controllers/auth_controller.dart';
import 'auth_screen.dart';

/// AuthGate listens to real-time auth state changes and user profile onboarding status.
/// - If unauthenticated -> displays AuthScreen.
/// - If authenticated but not onboarded -> displays OnboardingFlowScreen.
/// - If authenticated and onboarded -> displays MainNavigationShell.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateStreamProvider);

    return authStateAsync.when(
      data: (user) {
        if (user == null) {
          return const AuthScreen();
        }

        // Authenticated: check if user has completed onboarding in local Drift DB
        final profileAsync = ref.watch(userProfileStreamProvider);

        return profileAsync.when(
          data: (profile) {
            final isOnboarded = profile != null &&
                profile.primaryGoal != null &&
                profile.weightKg != null &&
                profile.weightKg! > 0;

            if (isOnboarded) {
              return const MainNavigationShell();
            } else {
              return const OnboardingFlowScreen();
            }
          },
          loading: () => const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryCyan,
              ),
            ),
          ),
          error: (_, __) => const OnboardingFlowScreen(),
        );
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
