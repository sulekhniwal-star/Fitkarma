import 'package:fitkarma/core/providers/core_providers.dart';
import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/features/onboarding/onboarding_flow_controller.dart';
import 'package:fitkarma/features/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// ── Helper: creates a WelcomeScreen wrapped in the full provider + GoRouter ──

Widget buildSubject({String? initialLocation}) {
  return ProviderScope(
    child: Consumer(
      builder: (context, ref, _) {
        final router = GoRouter(
          initialLocation: initialLocation ?? AppRoutes.onboardingWelcome,
          routes: [
            GoRoute(
              path: AppRoutes.onboardingWelcome,
              builder: (_, __) => const WelcomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.onboardingGoals,
              builder: (_, __) => const Scaffold(body: Text('Goals')),
            ),
            GoRoute(
              path: AppRoutes.login,
              builder: (_, __) => const Scaffold(body: Text('Login')),
            ),
          ],
        );
        return MaterialApp.router(routerConfig: router);
      },
    ),
  );
}

void main() {
  group('WelcomeScreen', () {
    testWidgets('renders flame icon and FitKarma wordmark', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(); // first frame

      // The logo icon
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);

      // The wordmark is a RichText — verify it contains the brand name
      final richTexts = find.byType(RichText);
      expect(richTexts, findsWidgets);
      // At least one RichText whose plain text contains 'FitKarma' (or 'Fit'+'Karma' combined)
      final wordmarkFinder = find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Fit'),
      );
      expect(wordmarkFinder, findsWidgets);
    });

    testWidgets('renders tagline and value proposition copy', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.textContaining('Your health, your karma.'), findsOneWidget);
      expect(find.textContaining('Track steps'), findsOneWidget);
    });

    testWidgets('renders Get Started and Login buttons', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Buttons are present (may still be opacity 0 during animation)
      expect(find.byKey(const Key('welcome_get_started_btn')), findsOneWidget);
      expect(find.byKey(const Key('welcome_login_btn')), findsOneWidget);
    });

    testWidgets('tapping Get Started advances to Goals route', (tester) async {
      await tester.pumpWidget(buildSubject());

      // Let animations settle fully
      await tester.pump(const Duration(milliseconds: 300)); // delay before logo
      await tester.pump(const Duration(milliseconds: 900)); // logo controller
      await tester.pump(
        const Duration(milliseconds: 550),
      ); // content controller
      await tester.pump(); // final settle

      await tester.tap(find.byKey(const Key('welcome_get_started_btn')));
      await tester.pumpAndSettle();

      // Should have navigated — goals placeholder shows "Goals"
      expect(find.text('Goals'), findsOneWidget);
    });

    testWidgets('tapping Login link navigates to /login', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump(const Duration(milliseconds: 550));
      await tester.pump();

      await tester.tap(find.byKey(const Key('welcome_login_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('animation plays without errors', (tester) async {
      await tester.pumpWidget(buildSubject());

      // Pump through the full animation sequence: 300ms delay + 900ms logo + 550ms content
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump(const Duration(milliseconds: 550));
      await tester.pumpAndSettle();

      // No exceptions, logo is visible at full opacity/scale
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
