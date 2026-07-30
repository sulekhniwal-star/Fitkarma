import 'package:go_router/go_router.dart';
import '../../features/coach/screens/coach_chat_screen.dart';
import '../../features/daily_mission/screens/daily_briefing_screen.dart';
import '../../features/daily_mission/screens/recovery_log_screen.dart';
import '../../features/health_tracking/screens/vitals_tracking_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';

/// Central GoRouter configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DailyBriefingScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/daily_mission',
      builder: (context, state) => const DailyBriefingScreen(),
    ),
    GoRoute(
      path: '/recovery_log',
      builder: (context, state) => const RecoveryLogScreen(),
    ),
    GoRoute(
      path: '/coach',
      builder: (context, state) => const CoachChatScreen(),
    ),
    GoRoute(
      path: '/health_tracking',
      builder: (context, state) => const VitalsTrackingScreen(),
    ),
  ],
);
