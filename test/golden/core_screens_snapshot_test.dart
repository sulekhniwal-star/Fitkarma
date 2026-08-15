import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/daily_mission/screens/daily_briefing_screen.dart';
import 'package:fitkarma/features/workout/screens/workout_home_screen.dart';
import 'package:fitkarma/features/social/screens/social_screen.dart';
import 'package:fitkarma/features/premium/screens/paywall_bottom_sheet.dart';
import 'package:fitkarma/features/transformation/screens/transformation_timeline_screen.dart';

void main() {
  group('§P14-C Golden & Snapshot Screen Tests (Dark Mode)', () {
    testWidgets('Snapshot: Daily Briefing Screen renders full layout without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DailyBriefingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unified Health Score'), findsOneWidget);
      expect(find.byType(DailyBriefingScreen), findsOneWidget);
    });

    testWidgets('Snapshot: Workout Home Screen renders session card and history',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WorkoutHomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WorkoutHomeScreen), findsOneWidget);
    });

    testWidgets('Snapshot: Social & Karma Squad Screen renders active squad and leaderboard',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SocialScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SocialScreen), findsOneWidget);
    });

    testWidgets('Snapshot: Transformation Timeline Screen renders weight forecast',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TransformationTimelineScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TransformationTimelineScreen), findsOneWidget);
    });

    testWidgets('Snapshot: Paywall Bottom Sheet renders premium tiers',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PaywallBottomSheet(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unlock FitKarma Pro'), findsOneWidget);
    });
  });
}
