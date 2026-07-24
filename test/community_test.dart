import 'package:fitkarma/features/social/community_engine.dart';
import 'package:fitkarma/features/social/community_models.dart';
import 'package:fitkarma/features/social/community_repository.dart';
import 'package:fitkarma/features/social/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = CommunityEngine();

  final sampleGroup = const CommunityGroup(
    id: 'steps10k',
    category: CommunityCategory.steps10k,
    name: '10K Steps India',
    description: 'Anyone wanting to walk more',
    iconSymbol: '👟',
    memberCount: 12500,
    isJoined: false,
  );

  group('§P9-C CommunityEngine Unit Tests', () {
    test('Toggling membership increments memberCount when joining', () {
      final joined = engine.toggleMembership(sampleGroup);
      expect(joined.isJoined, true);
      expect(joined.memberCount, 12501);

      final left = engine.toggleMembership(joined);
      expect(left.isJoined, false);
      expect(left.memberCount, 12500);
    });

    test('Toggling cheer increments cheerCount', () {
      final post = CommunityPost(
        id: 'p1',
        communityId: 'c1',
        authorName: 'Aarav',
        avatarEmoji: '🏃',
        timestamp: DateTime.now(),
        textContent: 'Hit 10k steps today!',
        cheerCount: 10,
        isCheered: false,
      );

      final cheered = engine.toggleCheer(post);
      expect(cheered.isCheered, true);
      expect(cheered.cheerCount, 11);

      final uncheered = engine.toggleCheer(cheered);
      expect(uncheered.isCheered, false);
      expect(uncheered.cheerCount, 10);
    });

    test('Privacy audit throws exception if medical PII is detected in community post', () {
      final invalidPost = CommunityPost(
        id: 'p1',
        communityId: 'c1',
        authorName: 'Aarav',
        avatarEmoji: '🏃',
        timestamp: DateTime.now(),
        textContent: 'My blood pressure: 140/90 mmHg today',
        cheerCount: 0,
      );

      expect(
        () => engine.auditFeedPrivacy([invalidPost]),
        throwsA(isA<CommunityPrivacyException>()),
      );
    });

    test('Privacy audit passes for non-PII milestone activity post', () {
      final validPost = CommunityPost(
        id: 'p1',
        communityId: 'c1',
        authorName: 'Aarav',
        avatarEmoji: '🏃',
        timestamp: DateTime.now(),
        textContent: 'Completed 30 minutes of walking!',
        cheerCount: 5,
      );

      expect(() => engine.auditFeedPrivacy([validPost]), returnsNormally);
    });
  });

  group('§P9-C CommunityScreen Widget Tests', () {
    testWidgets('Renders privacy banner, community cards, member counts, and join button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            communityRepositoryProvider.overrideWithValue(CommunityRepository()),
          ],
          child: const MaterialApp(
            home: CommunityScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Privacy Banner
      expect(find.text('Accountability Communities'), findsOneWidget);
      expect(find.textContaining('Privacy Shield: No personal health data visible'), findsOneWidget);

      // 2. Filter Bar
      expect(find.text('All Communities'), findsOneWidget);
      expect(find.text('Joined Only'), findsOneWidget);

      // 3. Community Cards
      expect(find.text('10K Steps India'), findsOneWidget);
      expect(find.text('Office Fat Loss'), findsOneWidget);
      expect(find.text('PCOS Warriors'), findsOneWidget);
      expect(find.text('Vegetarian Muscle Builders'), findsOneWidget);
      expect(find.text('Joined ✓'), findsWidgets);
    });

    testWidgets('Toggles membership when Join button is tapped', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            communityRepositoryProvider.overrideWithValue(CommunityRepository()),
          ],
          child: const MaterialApp(
            home: CommunityScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find first "Join" button for an unjoined community
      final joinButtons = find.widgetWithText(ElevatedButton, 'Join');
      expect(joinButtons, findsWidgets);

      await tester.tap(joinButtons.first);
      await tester.pumpAndSettle();

      // Confirm state toggles
      expect(find.text('Joined ✓'), findsWidgets);
    });
  });
}
