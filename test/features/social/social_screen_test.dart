import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/social/providers/squad_state_provider.dart';
import 'package:fitkarma/features/social/screens/social_screen.dart';

void main() {
  group('§P9-A Social Screen & SquadStateNotifier Tests', () {
    test('SquadStateNotifier initializes squad state correctly', () {
      final container = ProviderContainer();
      final state = container.read(squadStateProvider);

      expect(state.squadName, equals('Noida Fitness Warriors'));
      expect(state.collectiveStreakDays, equals(14));
      expect(state.averageReadinessScore, equals(82.5));
      expect(state.isChallengeEligible, isTrue);
      expect(state.members.length, equals(4));

      container.dispose();
    });

    test('sendSquadNudge updates nudgeMessage in state', () {
      final container = ProviderContainer();
      final notifier = container.read(squadStateProvider.notifier);

      notifier.sendSquadNudge('Sneha K.', 'Rest & Recover');
      expect(container.read(squadStateProvider).nudgeMessage, contains('Sent "Rest & Recover" nudge to Sneha K.'));

      container.dispose();
    });

    test('proposeChallenge updates active squad mission when eligible', () {
      final container = ProviderContainer();
      final notifier = container.read(squadStateProvider.notifier);

      notifier.proposeChallenge('🔥 100,000 Step Squad Challenge');

      final state = container.read(squadStateProvider);
      expect(state.activeMission?.missionTitle, equals('🔥 100,000 Step Squad Challenge'));
      expect(state.nudgeMessage, contains('Proposed new challenge'));

      container.dispose();
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('SocialScreen renders squad name, streak counter, active mission, member list, and nudge buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SocialScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Squad Accountability Hub'), findsOneWidget);
      expect(find.text('Noida Fitness Warriors'), findsOneWidget);
      expect(find.textContaining('14-Day Squad Streak'), findsOneWidget);
      expect(find.text('Active Squad Mission'), findsOneWidget);
      expect(find.text('Squad Members (4)'), findsOneWidget);
      expect(find.text('Nudge to Rest'), findsOneWidget);

      // Tap Nudge to Rest
      await tester.tap(find.text('Nudge to Rest'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Sent "Rest & Recover" nudge to Sneha K.'), findsOneWidget);
    });
  });
}
