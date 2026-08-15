import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/accountability_communities_engine.dart';
import 'package:fitkarma/features/social/screens/communities_screen.dart';

void main() {
  group('§P9-C Accountability Communities Tests', () {
    const engine = AccountabilityCommunitiesEngine();

    test('getAvailableCommunities returns 8 pre-seeded Indian communities', () {
      final list = engine.getAvailableCommunities();

      expect(list.length, equals(8));
      expect(list.any((c) => c.title == '10K Steps India'), isTrue);
      expect(list.any((c) => c.title == 'Office Fat Loss'), isTrue);
      expect(list.any((c) => c.title == 'PCOS Warriors'), isTrue);
      expect(list.any((c) => c.title == 'Vegetarian Muscle Builders'), isTrue);
      expect(list.any((c) => c.title == 'Diabetes Reversal Support'), isTrue);
      expect(list.any((c) => c.title == 'Wedding Transformation'), isTrue);
      expect(list.any((c) => c.title == 'Navratri Fitness'), isTrue);
      expect(list.any((c) => c.title == 'Senior Strength India'), isTrue);
    });

    test('isPostPrivacyCompliant flags sensitive medical data leakage', () {
      const validPost = CommunityActivityPost(
        id: 'p1',
        communityId: 'c1',
        authorName: 'Rahul',
        activityTitle: 'Logged 10,000 steps today!',
        timeAgo: '5m',
        cheerCount: 4,
      );

      const invalidPost = CommunityActivityPost(
        id: 'p2',
        communityId: 'c1',
        authorName: 'Sneha',
        activityTitle: 'Blood pressure today is 138 mmHg',
        timeAgo: '10m',
        cheerCount: 2,
      );

      expect(engine.isPostPrivacyCompliant(validPost), isTrue);
      expect(engine.isPostPrivacyCompliant(invalidPost), isFalse);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'CommunitiesScreen renders 8 communities, privacy banner, and activity feed',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: CommunitiesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accountability Communities'), findsOneWidget);
      expect(
          find.textContaining(
              'Zero personal health data visible in communities'),
          findsOneWidget);
      expect(find.text('Explore Communities (8)'), findsOneWidget);
      expect(find.text('10K Steps India'), findsOneWidget);
      expect(find.text('Office Fat Loss'), findsOneWidget);
      expect(find.text('Community Activity Feed'), findsOneWidget);
      expect(find.textContaining('Logged 11,400 steps on morning walk'),
          findsOneWidget);
    });
  });
}
