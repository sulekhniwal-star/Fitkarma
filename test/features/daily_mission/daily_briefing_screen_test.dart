import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/daily_mission/screens/daily_briefing_screen.dart';
import 'package:fitkarma/features/daily_mission/providers/daily_mission_provider.dart';

void main() {
  group('DailyBriefingScreen Widget & Provider Tests (§P2-B)', () {
    testWidgets('Renders Hero Section, Health Score, DIP missions and Focus tiles', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DailyBriefingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check Hero Section greeting
      expect(find.textContaining('Good morning, Arjun'), findsOneWidget);
      expect(find.text('READINESS'), findsOneWidget);

      // Check Unified Health Score
      expect(find.text('Unified Health Score'), findsOneWidget);
      expect(find.textContaining('pts from yesterday'), findsOneWidget);

      // Check Today's Mission section with DIP items
      expect(find.textContaining("Today's Mission"), findsOneWidget);
      expect(find.text('Hit 110g protein target today'), findsOneWidget);
      expect(find.text('Complete 45-min strength training'), findsOneWidget);

      // Check Focus tiles
      expect(find.text("Today's Focus"), findsOneWidget);
      expect(find.text('Sleep Debt'), findsOneWidget);
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('Karma Today'), findsOneWidget);

      // Check Quick Actions
      expect(find.text('Log Meal'), findsOneWidget);
      expect(find.text('Start Workout'), findsOneWidget);
      expect(find.text('Log Water'), findsOneWidget);
    });

    testWidgets('Shows Morning Check-in Pending banner and opens modal on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DailyBriefingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Pending banner present
      expect(find.text('Morning Check-in Pending'), findsOneWidget);

      // Tap on Morning Check-in Pending banner
      await tester.tap(find.text('Morning Check-in Pending'));
      await tester.pumpAndSettle();

      // Verify modal opened with 3 ritual questions
      expect(find.text('1. How did you sleep?'), findsOneWidget);
      expect(find.text('2. How sore are you?'), findsOneWidget);
      expect(find.textContaining('3. Stress level today?'), findsOneWidget);

      // Tap Complete Check-in button
      await tester.tap(find.text('COMPLETE CHECK-IN'));
      await tester.pumpAndSettle();

      // Modal closed and check-in pending banner disappears
      expect(find.text('Morning Check-in Pending'), findsNothing);
    });
  });
}
