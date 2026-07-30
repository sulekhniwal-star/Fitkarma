import 'package:go_router/go_router.dart';
import '../../main.dart';

/// Central GoRouter Navigation Engine
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FoundationHomePage(),
    ),
  ],
);
