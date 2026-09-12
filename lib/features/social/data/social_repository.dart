import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/social_models.dart';
import '../domain/services/family_health_monitoring_engine.dart';
import '../domain/services/leaderboard_ranking_engine.dart';
import '../domain/services/squad_accountability_engine.dart';

class SocialRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final SquadAccountabilityEngine squadEngine;
  final FamilyHealthMonitoringEngine familyEngine;
  final LeaderboardRankingEngine leaderboardEngine;

  SocialRepository({
    required this.db,
    required this.syncWorker,
    this.squadEngine = const SquadAccountabilityEngine(),
    this.familyEngine = const FamilyHealthMonitoringEngine(),
    this.leaderboardEngine = const LeaderboardRankingEngine(),
  });

  // ==========================================
  // 1. SQUAD OPERATIONS
  // ==========================================

  Future<void> createSquad({
    required String id,
    required String name,
    required String bio,
    String? bannerUrl,
    required String creatorUserId,
    required String creatorDisplayName,
  }) async {
    // 1. Insert Squad
    await db.into(db.localSquads).insertOnConflictUpdate(
      LocalSquadsCompanion(
        id: Value(id),
        name: Value(name),
        bio: Value(bio),
        bannerUrl: Value(bannerUrl),
        streakDays: const Value(1),
        totalKarma: const Value(100),
      ),
    );

    // 2. Insert creator as Leader
    await db.into(db.localSquadMembers).insertOnConflictUpdate(
      LocalSquadMembersCompanion(
        id: Value('${id}_$creatorUserId'),
        squadId: Value(id),
        userId: Value(creatorUserId),
        displayName: Value(creatorDisplayName),
        role: Value(SquadRole.leader.name),
        todayLogged: const Value(true),
        todayKarma: const Value(50),
      ),
    );

    // 3. Queue Outbox
    await syncWorker.enqueueMutation(
      tableName: 'squads',
      action: 'INSERT',
      payload: {
        'id': id,
        'name': name,
        'bio': bio,
        'banner_url': bannerUrl,
        'streak_days': 1,
        'total_karma': 100,
      },
    );

    await syncWorker.enqueueMutation(
      tableName: 'squad_members',
      action: 'INSERT',
      payload: {
        'id': '${id}_$creatorUserId',
        'squad_id': id,
        'user_id': creatorUserId,
        'display_name': creatorDisplayName,
        'role': SquadRole.leader.name,
        'today_logged': true,
        'today_karma': 50,
      },
    );
  }

  Future<void> joinSquad({
    required String squadId,
    required String userId,
    required String displayName,
  }) async {
    final memberId = '${squadId}_$userId';
    await db.into(db.localSquadMembers).insertOnConflictUpdate(
      LocalSquadMembersCompanion(
        id: Value(memberId),
        squadId: Value(squadId),
        userId: Value(userId),
        displayName: Value(displayName),
        role: Value(SquadRole.member.name),
        todayLogged: const Value(false),
        todayKarma: const Value(0),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'squad_members',
      action: 'INSERT',
      payload: {
        'id': memberId,
        'squad_id': squadId,
        'user_id': userId,
        'display_name': displayName,
        'role': SquadRole.member.name,
        'today_logged': false,
        'today_karma': 0,
      },
    );
  }

  Stream<Squad?> watchSquad(String squadId) {
    return (db.select(db.localSquads)..where((t) => t.id.equals(squadId)))
        .watchSingleOrNull()
        .asyncMap((squadRow) async {
      if (squadRow == null) return null;

      final memberRows = await (db.select(db.localSquadMembers)
            ..where((t) => t.squadId.equals(squadId)))
          .get();

      final members = memberRows
          .map((m) => SquadMember(
                id: m.id,
                squadId: m.squadId,
                userId: m.userId,
                displayName: m.displayName,
                avatarUrl: m.avatarUrl,
                role: m.role == SquadRole.leader.name ? SquadRole.leader : SquadRole.member,
                todayLogged: m.todayLogged,
                todayKarma: m.todayKarma,
                todayCommitment: m.todayCommitment,
              ))
          .toList();

      return Squad(
        id: squadRow.id,
        name: squadRow.name,
        bio: squadRow.bio,
        bannerUrl: squadRow.bannerUrl,
        streakDays: squadRow.streakDays,
        totalKarma: squadRow.totalKarma,
        members: members,
      );
    });
  }

  // ==========================================
  // 2. COMMUNITY ACTIVITY POSTS
  // ==========================================

  Future<void> publishActivityPost({
    required String id,
    required String userId,
    required String authorName,
    String? authorAvatar,
    required ActivityType activityType,
    required String title,
    String? description,
    String? mediaUrl,
    required int karmaEarned,
  }) async {
    final now = DateTime.now();

    await db.into(db.localCommunityPosts).insertOnConflictUpdate(
      LocalCommunityPostsCompanion(
        id: Value(id),
        userId: Value(userId),
        authorName: Value(authorName),
        authorAvatar: Value(authorAvatar),
        activityType: Value(activityType.name),
        title: Value(title),
        description: Value(description),
        mediaUrl: Value(mediaUrl),
        karmaEarned: Value(karmaEarned),
        likesCount: const Value(0),
        cheersCount: const Value(0),
        createdAt: Value(now),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'community_posts',
      action: 'INSERT',
      payload: {
        'id': id,
        'user_id': userId,
        'author_name': authorName,
        'author_avatar': authorAvatar,
        'activity_type': activityType.name,
        'title': title,
        'description': description,
        'media_url': mediaUrl,
        'karma_earned': karmaEarned,
        'likes_count': 0,
        'cheers_count': 0,
        'created_at': now.toIso8601String(),
      },
    );
  }

  Stream<List<SocialActivityPost>> watchCommunityFeed() {
    return (db.select(db.localCommunityPosts)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows
            .map((r) => SocialActivityPost(
                  id: r.id,
                  userId: r.userId,
                  authorName: r.authorName,
                  authorAvatar: r.authorAvatar,
                  activityType: ActivityType.values.firstWhere(
                    (a) => a.name == r.activityType,
                    orElse: () => ActivityType.workoutCompleted,
                  ),
                  title: r.title,
                  description: r.description,
                  mediaUrl: r.mediaUrl,
                  karmaEarned: r.karmaEarned,
                  likesCount: r.likesCount,
                  cheersCount: r.cheersCount,
                  createdAt: r.createdAt,
                ))
            .toList());
  }

  // ==========================================
  // 3. FAMILY HEALTH HUB
  // ==========================================

  Future<void> saveFamilyMemberHealth(FamilyMemberHealth health) async {
    await db.into(db.localFamilyMembers).insertOnConflictUpdate(
      LocalFamilyMembersCompanion(
        id: Value(health.id),
        userId: Value(health.userId),
        relativeUserId: Value(health.relativeUserId),
        relativeName: Value(health.relativeName),
        relation: Value(health.relation),
        age: Value(health.age),
        latestSystolicBp: Value(health.latestSystolicBp),
        latestDiastolicBp: Value(health.latestDiastolicBp),
        latestFastingGlucoseMgDl: Value(health.latestFastingGlucoseMgDl),
        todaySteps: Value(health.todaySteps),
        alertLevel: Value(health.alertLevel.name),
        alertMessage: Value(health.alertMessage),
        alertMessageHindi: Value(health.alertMessageHindi),
        updatedAt: Value(health.updatedAt),
      ),
    );

    await syncWorker.enqueueMutation(
      tableName: 'family_members',
      action: 'INSERT',
      payload: health.toJson(),
    );
  }

  Stream<List<FamilyMemberHealth>> watchFamilyMembers(String userId) {
    return (db.select(db.localFamilyMembers)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows
            .map((r) => FamilyMemberHealth(
                  id: r.id,
                  userId: r.userId,
                  relativeUserId: r.relativeUserId,
                  relativeName: r.relativeName,
                  relation: r.relation,
                  age: r.age,
                  latestSystolicBp: r.latestSystolicBp,
                  latestDiastolicBp: r.latestDiastolicBp,
                  latestFastingGlucoseMgDl: r.latestFastingGlucoseMgDl,
                  todaySteps: r.todaySteps,
                  alertLevel: HealthAlertLevel.values.firstWhere(
                    (a) => a.name == r.alertLevel,
                    orElse: () => HealthAlertLevel.normal,
                  ),
                  alertMessage: r.alertMessage,
                  alertMessageHindi: r.alertMessageHindi,
                  updatedAt: r.updatedAt,
                ))
            .toList());
  }

  // ==========================================
  // 4. LOCAL CLUBS
  // ==========================================

  Future<void> seedLocalClubsIfEmpty() async {
    final count = await db.select(db.localClubs).get();
    if (count.isNotEmpty) return;

    final initialClubs = [
      const SocialClub(
        id: 'club_blr_indiranagar_runners',
        name: 'Indiranagar Morning Runners',
        city: 'Bengaluru',
        locality: 'Indiranagar & 100ft Road',
        clubType: 'Running & Stamina',
        memberCount: 142,
        nextMeetup: 'Saturday 06:00 AM @ Defence Colony Park',
        nextMeetupHindi: 'शनिवार सुबह ०६:०० बजे, डिफेन्स कॉलोनी पार्क',
      ),
      const SocialClub(
        id: 'club_delhi_lodhi_calisthenics',
        name: 'Lodhi Garden Calisthenics & Desi Akhada',
        city: 'Delhi NCR',
        locality: 'Lodhi Garden / Central Delhi',
        clubType: 'Calisthenics & Bodyweight',
        memberCount: 210,
        nextMeetup: 'Sunday 06:30 AM @ Athpula Bridge',
        nextMeetupHindi: 'रविवार सुबह ०६:३० बजे, आठपुला ब्रिज',
      ),
      const SocialClub(
        id: 'club_mumbai_marine_drive_yogi',
        name: 'Marine Drive Sunrise Yogis',
        city: 'Mumbai',
        locality: 'Marine Drive Promenade',
        clubType: 'Pranayama & Asana',
        memberCount: 320,
        nextMeetup: 'Daily 05:45 AM @ Nariman Point',
        nextMeetupHindi: 'दैनिक सुबह ०५:४५ बजे, नरीमन पॉइंट',
      ),
    ];

    for (final club in initialClubs) {
      await db.into(db.localClubs).insertOnConflictUpdate(
        LocalClubsCompanion(
          id: Value(club.id),
          name: Value(club.name),
          city: Value(club.city),
          locality: Value(club.locality),
          clubType: Value(club.clubType),
          memberCount: Value(club.memberCount),
          nextMeetup: Value(club.nextMeetup),
          nextMeetupHindi: Value(club.nextMeetupHindi),
        ),
      );
    }
  }

  Stream<List<SocialClub>> watchLocalClubs() {
    return (db.select(db.localClubs)..orderBy([(t) => OrderingTerm.asc(t.city)]))
        .watch()
        .map((rows) => rows
            .map((r) => SocialClub(
                  id: r.id,
                  name: r.name,
                  city: r.city,
                  locality: r.locality,
                  clubType: r.clubType,
                  memberCount: r.memberCount,
                  bannerUrl: r.bannerUrl,
                  nextMeetup: r.nextMeetup,
                  nextMeetupHindi: r.nextMeetupHindi,
                ))
            .toList());
  }
}
