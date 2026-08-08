import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/gamification/providers/karma_hub_provider.dart';
import 'package:fitkarma/features/gamification/screens/karma_hub_screen.dart';

void main() {
  group('§P7-B Karma Hub Screen & KarmaHubNotifier Tests', () {
    test('KarmaHubNotifier calculates initial level L4 Builder for 1450 XP per §P7-B spec', () {
      final container = ProviderContainer();
      final state = container.read(karmaHubProvider);

      expect(state.totalXp, equals(1450));
      expect(state.levelInfo.currentLevel, equals(4));
      expect(state.levelInfo.levelName, equals('Builder'));
      expect(state.levelInfo.xpInCurrentLevel, equals(450));
      expect(state.levelInfo.xpNeededForNextLevel, equals(1000));
      expect(state.levelInfo.levelProgressRatio, equals(0.45));
      expect(state.cohortRank, equals(142));
      expect(state.totalCohortMembers, equals(4210));
      expect(state.cohortPercentile, equals(82));

      container.dispose();
    });

    test('awardOutcomeXp increases total XP and records recent XP event', () {
      final container = ProviderContainer();
      final notifier = container.read(karmaHubProvider.notifier);

      notifier.awardOutcomeXp('bmi_category_improved', customEventTitle: 'BMI Category Improved');

      final state = container.read(karmaHubProvider);
      expect(state.totalXp, equals(1750)); // 1450 + 300
      expect(state.recentEvents.first.title, equals('BMI Category Improved'));
      expect(state.recentEvents.first.xpAwarded, equals(300));

      container.dispose();
    });

    test('unlockAchievement unlocks specified achievement badge', () {
      final container = ProviderContainer();
      final notifier = container.read(karmaHubProvider.notifier);

      notifier.unlockAchievement('a3');

      final state = container.read(karmaHubProvider);
      final ach = state.achievements.firstWhere((a) => a.id == 'a3');
      expect(ach.isUnlocked, isTrue);

      container.dispose();
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('KarmaHubScreen renders Karma level header, cohort rank card, achievements grid, and XP feed', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: KarmaHubScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Karma Hub — Level 4'), findsOneWidget);
      expect(find.textContaining('Level 4 — Builder'), findsOneWidget);
      expect(find.textContaining('You score higher than 82% of Noida Builders!'), findsOneWidget);
      expect(find.text('Cohort Rank: #142 of 4210 members'), findsOneWidget);
      expect(find.text('Achievements'), findsOneWidget);
      expect(find.text('Prote-King'), findsOneWidget);
      expect(find.text('Recent Outcome XP Activity'), findsOneWidget);
      expect(find.text('+100 XP'), findsOneWidget);
    });
  });
}
