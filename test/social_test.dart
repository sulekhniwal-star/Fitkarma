import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_sync_worker.dart';
import 'package:fitkarma/features/social/domain/models/social_models.dart';
import 'package:fitkarma/features/social/domain/services/squad_accountability_engine.dart';
import 'package:fitkarma/features/social/domain/services/family_health_monitoring_engine.dart';
import 'package:fitkarma/features/social/domain/services/leaderboard_ranking_engine.dart';
import 'package:fitkarma/features/social/data/social_repository.dart';

void main() {
  group('SquadAccountabilityEngine Tests', () {
    const engine = SquadAccountabilityEngine();

    test('calculateSquadDailyAdherence computes correct ratio', () {
      final members = [
        const SquadMember(
          id: 'm1',
          squadId: 's1',
          userId: 'u1',
          displayName: 'Aarav',
          role: SquadRole.leader,
          todayLogged: true,
          todayKarma: 50,
        ),
        const SquadMember(
          id: 'm2',
          squadId: 's1',
          userId: 'u2',
          displayName: 'Priya',
          role: SquadRole.member,
          todayLogged: false,
          todayKarma: 0,
        ),
        const SquadMember(
          id: 'm3',
          squadId: 's1',
          userId: 'u3',
          displayName: 'Rohan',
          role: SquadRole.member,
          todayLogged: true,
          todayKarma: 40,
        ),
        const SquadMember(
          id: 'm4',
          squadId: 's1',
          userId: 'u4',
          displayName: 'Neha',
          role: SquadRole.member,
          todayLogged: false,
          todayKarma: 0,
        ),
      ];

      final adherence = engine.calculateSquadDailyAdherence(members);
      expect(adherence, equals(0.5)); // 2 out of 4 logged
    });

    test('calculateSquadStreakMultiplier returns proper bonus tiers', () {
      expect(engine.calculateSquadStreakMultiplier(0), 1.0);
      expect(engine.calculateSquadStreakMultiplier(3), 1.10);
      expect(engine.calculateSquadStreakMultiplier(7), 1.20);
      expect(engine.calculateSquadStreakMultiplier(14), 1.35);
      expect(engine.calculateSquadStreakMultiplier(30), 1.50);
    });

    test('generatePendingNudges targets only unlogged members with bilingual text', () {
      final members = [
        const SquadMember(
          id: 'm1',
          squadId: 's1',
          userId: 'u1',
          displayName: 'Aarav',
          role: SquadRole.leader,
          todayLogged: true,
          todayKarma: 50,
        ),
        const SquadMember(
          id: 'm2',
          squadId: 's1',
          userId: 'u2',
          displayName: 'Priya',
          role: SquadRole.member,
          todayLogged: false,
          todayKarma: 0,
        ),
      ];

      final nudges = engine.generatePendingNudges(
        senderId: 'u1',
        members: members,
        currentTime: DateTime(2026, 9, 12, 19, 0), // evening
      );

      expect(nudges.length, equals(1));
      expect(nudges.first.recipientId, equals('u2'));
      expect(nudges.first.messageHindi, contains('हमारे स्क्वाड का स्ट्रीक आपके हाथ में है'));
    });
  });

  group('FamilyHealthMonitoringEngine Tests', () {
    const engine = FamilyHealthMonitoringEngine();

    test('Identifies hypertensive crisis BP (>= 180/120)', () {
      final status = engine.evaluateHealthStatus(
        id: 'fam-1',
        userId: 'user-001',
        relativeUserId: 'parent-1',
        relativeName: 'Ramesh Nair',
        relation: 'Father',
        age: 64,
        systolicBp: 185.0,
        diastolicBp: 122.0,
        recordedAt: DateTime.now(),
      );

      expect(status.alertLevel, equals(HealthAlertLevel.urgentConsultation));
      expect(status.alertMessage, contains('crisis'));
    });

    test('Identifies elevated fasting glucose (>= 126 mg/dL)', () {
      final status = engine.evaluateHealthStatus(
        id: 'fam-2',
        userId: 'user-001',
        relativeUserId: 'parent-2',
        relativeName: 'Lakshmi Nair',
        relation: 'Mother',
        age: 60,
        fastingGlucoseMgDl: 145.0,
        recordedAt: DateTime.now(),
      );

      expect(status.alertLevel, equals(HealthAlertLevel.attentionNeeded));
      expect(status.alertMessageHindi, contains('भोजन के बाद हल्का टहलना'));
    });

    test('Creates respectful Pranam and Ashirwad blessings', () {
      final pranam = engine.createBlessing(
        id: 'b1',
        senderId: 'user-1',
        senderName: 'Aarav',
        recipientId: 'parent-1',
        blessingType: 'pranam',
      );
      expect(pranam.blessingHindi, contains('सादर प्रणाम'));

      final ashirwad = engine.createBlessing(
        id: 'b2',
        senderId: 'parent-1',
        senderName: 'Ramesh',
        recipientId: 'user-1',
        blessingType: 'ashirwad',
      );
      expect(ashirwad.blessingHindi, contains('सदा निरोगी और ऊर्जावान रहो'));
    });
  });

  group('LeaderboardRankingEngine Tests', () {
    const engine = LeaderboardRankingEngine();

    test('Ranks users by total Karma and assigns Golden Yogi to #1', () {
      final rawEntries = [
        const LeaderboardRank(
          rank: 0,
          entityId: 'u2',
          name: 'Rohit',
          totalKarma: 2400,
          streakDays: 10,
          cohortBadge: '',
        ),
        const LeaderboardRank(
          rank: 0,
          entityId: 'u1',
          name: 'Aarav',
          totalKarma: 3100,
          streakDays: 21,
          cohortBadge: '',
        ),
        const LeaderboardRank(
          rank: 0,
          entityId: 'u3',
          name: 'Neha',
          totalKarma: 1800,
          streakDays: 5,
          cohortBadge: '',
        ),
      ];

      final ranked = engine.rankUsersByKarma(rawEntries: rawEntries, currentUserId: 'u1');

      expect(ranked[0].rank, equals(1));
      expect(ranked[0].entityId, equals('u1'));
      expect(ranked[0].cohortBadge, contains('Golden Yogi'));
      expect(ranked[0].isCurrentUser, isTrue);

      expect(ranked[1].rank, equals(2));
      expect(ranked[1].cohortBadge, contains('Podium Elite'));
    });
  });

  group('SocialRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxSyncWorker syncWorker;
    late SocialRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      syncWorker = OutboxSyncWorker(db: db, supabaseClient: null);
      repo = SocialRepository(db: db, syncWorker: syncWorker);
    });

    tearDown(() async {
      await db.close();
    });

    test('createSquad & joinSquad persist to Drift and queue Outbox mutations', () async {
      await repo.createSquad(
        id: 'squad-101',
        name: 'Vayu Warriors',
        bio: 'Morning runners and lifters',
        creatorUserId: 'u1',
        creatorDisplayName: 'Aarav',
      );

      await repo.joinSquad(
        squadId: 'squad-101',
        userId: 'u2',
        displayName: 'Priya',
      );

      final squads = await db.select(db.localSquads).get();
      expect(squads.length, equals(1));
      expect(squads.first.name, equals('Vayu Warriors'));

      final members = await db.select(db.localSquadMembers).get();
      expect(members.length, equals(2));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'squads'), isTrue);
      expect(pending.any((p) => p.targetTable == 'squad_members'), isTrue);
    });

    test('publishActivityPost saves feed post and queues Outbox mutation', () async {
      await repo.publishActivityPost(
        id: 'post-1',
        userId: 'u1',
        authorName: 'Aarav',
        activityType: ActivityType.workoutCompleted,
        title: 'Completed 100 Desi Baithaks!',
        karmaEarned: 50,
      );

      final posts = await db.select(db.localCommunityPosts).get();
      expect(posts.length, equals(1));
      expect(posts.first.title, equals('Completed 100 Desi Baithaks!'));

      final pending = await db.select(db.pendingMutations).get();
      expect(pending.any((p) => p.targetTable == 'community_posts'), isTrue);
    });

    test('seedLocalClubsIfEmpty populates initial Indian city clubs', () async {
      await repo.seedLocalClubsIfEmpty();

      final clubs = await db.select(db.localClubs).get();
      expect(clubs.length, greaterThanOrEqualTo(3));
      expect(clubs.any((c) => c.city == 'Bengaluru'), isTrue);
      expect(clubs.any((c) => c.city == 'Delhi NCR'), isTrue);
      expect(clubs.any((c) => c.city == 'Mumbai'), isTrue);
    });
  });
}
