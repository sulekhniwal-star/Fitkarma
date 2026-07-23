import 'package:fitkarma/features/karma/karma_hub_screen.dart';
import 'package:fitkarma/features/karma/karma_models.dart';
import 'package:fitkarma/features/karma/karma_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('§P7-B Karma Hub Screen Widget Tests', () {
    testWidgets('Renders level header card, progress bar, badges, cohort card', (tester) async {
      final repo = KarmaRepository();
      repo.recordOutcomeEvent(KarmaEventType.proteinTargetHit);
      repo.recordOutcomeEvent(KarmaEventType.streakMilestone7d);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            karmaRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: KarmaHubScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Level & Title
      expect(find.text('Karma Hub'), findsOneWidget);
      expect(find.text('Level 1 — Beginner'), findsOneWidget);
      expect(find.text('150 XP'), findsOneWidget);

      // 2. Achievements
      expect(find.text('Achievements'), findsOneWidget);
      expect(find.text('Prote-King'), findsOneWidget);
      expect(find.text('Sleepy-Head'), findsOneWidget);
      expect(find.text('Rep-Master'), findsOneWidget);
      expect(find.text('Completed ✓'), findsNWidgets(2));

      // 3. Demographic Cohort Card
      expect(find.text('Your Demographic Cohort Percentile'), findsOneWidget);
      expect(find.textContaining('You score higher than 82% of Noida Builders!'), findsOneWidget);
      expect(find.textContaining('Cohort Rank: #142 of 4210 members'), findsOneWidget);

      // 4. Activity History
      expect(find.text('Weekly Activity History'), findsOneWidget);
      expect(find.text('Protein target achieved'), findsOneWidget);
      expect(find.text('+50 XP'), findsOneWidget);
      expect(find.text('7-day streak milestone'), findsOneWidget);
      expect(find.text('+100 XP'), findsOneWidget);
    });
  });
}
