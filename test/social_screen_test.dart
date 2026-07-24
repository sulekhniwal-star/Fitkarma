import 'package:fitkarma/features/social/social_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('§P9-A Social Screen Widget Tests', () {
    testWidgets('Renders squad name, streak badge, member readiness list, and mission card', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SocialScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Tab Pills
      expect(find.text('Social & Squads'), findsOneWidget);
      expect(find.text('My Squad'), findsOneWidget);
      expect(find.text('Challenges'), findsOneWidget);
      expect(find.text('Leaderboards'), findsOneWidget);

      // 2. Squad Header Banner
      expect(find.text('Squad: Noida Ground Shakers'), findsOneWidget);
      expect(find.textContaining('Streak: 🔥 14 Days'), findsOneWidget);

      // 3. Member Readiness List
      expect(find.text('Members Readiness & Recovery Status (Anonymized)'), findsOneWidget);
      expect(find.text('You (You)'), findsOneWidget);
      expect(find.text('Priya'), findsOneWidget);
      expect(find.text('Amit'), findsOneWidget);
      expect(find.text('Rohan'), findsOneWidget);
      expect(find.text('Sneha'), findsOneWidget);
      expect(find.text('Team Average Readiness:'), findsOneWidget);

      // 4. Active Squad Mission Card
      expect(find.textContaining('Team Protein Target'), findsOneWidget);
      expect(find.textContaining('78% Done'), findsOneWidget);

      // 5. Action Buttons
      expect(find.text('Nudge Member'), findsOneWidget);
      expect(find.text('Propose Challenge'), findsOneWidget);
    });

    testWidgets('Switches tabs between My Squad, Challenges, and Leaderboards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SocialScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on My Squad tab
      expect(find.text('Squad: Noida Ground Shakers'), findsOneWidget);

      // Tap Challenges tab
      await tester.tap(find.text('Challenges'));
      await tester.pumpAndSettle();

      expect(find.text('Squad Challenges'), findsOneWidget);

      // Tap Leaderboards tab
      await tester.tap(find.text('Leaderboards'));
      await tester.pumpAndSettle();

      expect(find.text('Regional Leaderboards'), findsOneWidget);
    });
  });
}
