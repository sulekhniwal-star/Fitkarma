import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../main.dart';

/// Central GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FoundationHomePage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
);
