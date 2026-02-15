import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../presentation/main_shell.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/karma_screen.dart';
import '../../features/food/presentation/food_logging_screen.dart';
import '../../features/food/presentation/food_tab_screen.dart';
import '../../features/weight/presentation/weight_screen.dart';
import '../../features/water/presentation/water_screen.dart';
import '../../features/workouts/presentation/workout_screen.dart';
import '../../features/workouts/presentation/workouts_tab_screen.dart';
import '../../features/heart_rate/presentation/heart_rate_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';

enum AppRoute { 
  onboarding, 
  login, 
  dashboard, 
  karma, 
  foodLog, 
  foodTab,
  weight, 
  water, 
  workoutTab,
  workout, 
  heartRate,
  profile,
  settings 
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  debugLogDiagnostics: true,
  routes: [
    // Auth routes (outside shell)
    GoRoute(
      path: '/onboarding',
      name: AppRoute.onboarding.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    
    // Main app routes with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        final location = state.matchedLocation;
        int currentIndex = 0;
        
        if (location.startsWith('/food')) {
          currentIndex = 1;
        } else if (location.startsWith('/workouts')) {
          currentIndex = 2;
        } else if (location.startsWith('/profile')) {
          currentIndex = 3;
        }
        
        return MainShell(
          currentIndex: currentIndex,
          child: child,
        );
      },
      routes: [
        // Home/Dashboard tab
        GoRoute(
          path: '/dashboard',
          name: AppRoute.dashboard.name,
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'karma',
              name: AppRoute.karma.name,
              builder: (context, state) => const KarmaScreen(),
            ),
            GoRoute(
              path: 'weight',
              name: AppRoute.weight.name,
              builder: (context, state) => const WeightScreen(),
            ),
            GoRoute(
              path: 'water',
              name: AppRoute.water.name,
              builder: (context, state) => const WaterScreen(),
            ),
            GoRoute(
              path: 'heart-rate',
              name: AppRoute.heartRate.name,
              builder: (context, state) => const HeartRateScreen(),
            ),
          ],
        ),
        
        // Food tab
        GoRoute(
          path: '/food',
          name: AppRoute.foodTab.name,
          builder: (context, state) => const FoodTabScreen(),
          routes: [
            GoRoute(
              path: 'log',
              name: AppRoute.foodLog.name,
              builder: (context, state) {
                final mealType = state.uri.queryParameters['mealType'];
                return FoodLoggingScreen(initialMealType: mealType);
              },
            ),
          ],
        ),
        
        // Workouts tab
        GoRoute(
          path: '/workouts',
          name: AppRoute.workoutTab.name,
          builder: (context, state) => const WorkoutsTabScreen(),
          routes: [
            GoRoute(
              path: 'detail',
              name: AppRoute.workout.name,
              builder: (context, state) => const WorkoutScreen(),
            ),
          ],
        ),
        
        // Profile tab
        GoRoute(
          path: '/profile',
          name: AppRoute.profile.name,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'settings',
              name: AppRoute.settings.name,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
