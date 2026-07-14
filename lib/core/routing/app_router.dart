import 'package:fitkarma/core/config/user_experience_stage.dart';
import 'package:fitkarma/core/providers/core_providers.dart';
import 'package:fitkarma/features/onboarding/demographics_screen.dart';
import 'package:fitkarma/features/onboarding/diet_plan_screen.dart';
import 'package:fitkarma/features/onboarding/goals_screen.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/welcome_screen.dart';
import 'package:fitkarma/features/onboarding/dosha_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Route Paths (centralized constants)
// ──────────────────────────────────────────────────────────────────────────────

class AppRoutes {
  AppRoutes._();

  // Onboarding funnel
  static const onboardingWelcome      = '/onboarding/welcome';
  static const onboardingGoals        = '/onboarding/goals';
  static const onboardingDemographics = '/onboarding/demographics';
  static const onboardingDietPlan     = '/onboarding/diet_plan';
  static const onboardingDosha        = '/onboarding/dosha';
  static const onboardingProgramSelect = '/onboarding/program_select';
  static const onboardingPermissions  = '/onboarding/permissions';

  // Main app shell
  static const dashboard = '/dashboard';

  // Auth
  static const login = '/login';
}

// ──────────────────────────────────────────────────────────────────────────────
// Route → OnboardingStep mapping (used for deep-link restoration)
// ──────────────────────────────────────────────────────────────────────────────

OnboardingStep? stepForPath(String path) {
  return switch (path) {
    AppRoutes.onboardingWelcome       => OnboardingStep.welcome,
    AppRoutes.onboardingGoals         => OnboardingStep.goals,
    AppRoutes.onboardingDemographics  => OnboardingStep.demographics,
    AppRoutes.onboardingDietPlan      => OnboardingStep.dietPlan,
    AppRoutes.onboardingDosha         => OnboardingStep.dosha,
    AppRoutes.onboardingProgramSelect => OnboardingStep.programSelect,
    AppRoutes.onboardingPermissions   => OnboardingStep.permissions,
    _                                 => null,
  };
}

/// Map an [OnboardingStep] back to its canonical URL path.
String pathForStep(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.welcome       => AppRoutes.onboardingWelcome,
    OnboardingStep.goals         => AppRoutes.onboardingGoals,
    OnboardingStep.demographics  => AppRoutes.onboardingDemographics,
    OnboardingStep.dietPlan      => AppRoutes.onboardingDietPlan,
    OnboardingStep.dosha         => AppRoutes.onboardingDosha,
    OnboardingStep.programSelect => AppRoutes.onboardingProgramSelect,
    OnboardingStep.permissions   => AppRoutes.onboardingPermissions,
  };
}

// ──────────────────────────────────────────────────────────────────────────────
// Placeholder screens (stubs; real UIs are built in subsequent §P1 tasks)
// ──────────────────────────────────────────────────────────────────────────────

class _OnboardingPlaceholderScreen extends ConsumerWidget {
  const _OnboardingPlaceholderScreen({required this.title, this.stepNumber});

  final String title;
  final int? stepNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowNotifier = ref.read(onboardingFlowProvider.notifier);
    final canBack = ref.watch(onboardingCanGoBackProvider);
    final canSkipStep = ref.watch(onboardingCanSkipProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  final prev = flowNotifier.back();
                  if (prev != null) context.go(pathForStep(prev));
                },
              )
            : null,
        actions: [
          if (canSkipStep)
            TextButton(
              onPressed: () {
                final next = flowNotifier.skip();
                if (next != null) {
                  context.go(pathForStep(next));
                } else {
                  context.go(AppRoutes.dashboard);
                }
              },
              child: const Text('Skip'),
            ),
        ],
      ),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard — coming soon')),
    );
  }
}

class _LoginPlaceholder extends StatelessWidget {
  const _LoginPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login — coming soon')),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// AppRouter
// ──────────────────────────────────────────────────────────────────────────────

class AppRouter {
  AppRouter._();

  /// Creates the GoRouter instance.
  /// The [ref] parameter allows redirect logic to read Riverpod providers.
  static GoRouter create(WidgetRef ref) {
    return GoRouter(
      debugLogDiagnostics: false,
      initialLocation: AppRoutes.onboardingWelcome,

      // ── Global redirect guard ────────────────────────────────────────────
      redirect: (BuildContext context, GoRouterState state) {
        final uxStage = ref.read(uxStageProvider);
        final onboardingComplete =
            ref.read(onboardingFlowProvider).isComplete;

        final onOnboardingRoute =
            state.uri.toString().startsWith('/onboarding');

        // If user has already completed onboarding, send them to dashboard
        if (uxStage == UserExperienceStage.active && onboardingComplete) {
          if (onOnboardingRoute) return AppRoutes.dashboard;
        }

        // If user is in onboarding stage, keep them in the funnel
        if (uxStage == UserExperienceStage.onboarding && !onOnboardingRoute) {
          return AppRoutes.onboardingWelcome;
        }

        return null; // no redirect needed
      },

      routes: [
        // ── Onboarding funnel ───────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.onboardingWelcome,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const WelcomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboardingGoals,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const GoalsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboardingDemographics,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const DemographicsScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboardingDietPlan,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const DietPlanScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboardingDosha,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const DoshaScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboardingProgramSelect,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const _OnboardingPlaceholderScreen(
              title: 'Choose Your Blueprint',
              stepNumber: 4,
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.onboardingPermissions,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const _OnboardingPlaceholderScreen(
              title: 'Health Permissions',
              stepNumber: 5,
            ),
          ),
        ),

        // ── Main app ────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.dashboard,
          pageBuilder: (context, state) =>
              _fadeTransition(state, const _DashboardPlaceholder()),
        ),

        // ── Auth ─────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) =>
              _fadeTransition(state, const _LoginPlaceholder()),
        ),
      ],
    );
  }

  // ── Page transitions ─────────────────────────────────────────────────────

  /// Smooth cross-fade (used for welcome and dashboard).
  static CustomTransitionPage<void> _fadeTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Horizontal slide-in (used for the step-by-step funnel pages).
  static CustomTransitionPage<void> _slideTransition(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        final slideTween = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.25, 0.0),
        ).chain(CurveTween(curve: Curves.easeInCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(slideTween),
            child: child,
          ),
        );
      },
    );
  }
}
