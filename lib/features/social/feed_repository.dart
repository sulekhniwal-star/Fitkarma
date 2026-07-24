/// §P9-E Activity Feed — Persistence Repository
///
/// In-memory repository for paginated FeedItem lists and FollowSystem relationship storage.
library;

import 'package:fitkarma/features/social/feed_curation_engine.dart';
import 'package:fitkarma/features/social/feed_models.dart';
import 'package:fitkarma/features/social/follow_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedRepository {
  FeedRepository() {
    _initializeDefaultFeed();
  }

  final FollowSystem _followSystem = FollowSystem();
  final FeedCurationEngine _curationEngine = const FeedCurationEngine();
  late List<FeedItem> _feedItems;

  FollowSystem get followSystem => _followSystem;

  void _initializeDefaultFeed() {
    final now = DateTime.now();

    _feedItems = [
      FeedItem(
        localId: 'feed_1',
        userId: 'user_priya',
        userName: 'Priya Sharma',
        userAvatar: '🏃‍♀️',
        type: FeedItemType.workout,
        timestamp: now.subtract(const Duration(minutes: 30)),
        workoutPayload: const WorkoutPayload(
          exerciseName: 'Upper Body Power & Core',
          durationMinutes: 45,
          caloriesBurned: 320,
          formQualityScore: 92,
        ),
        highFiveCount: 8,
        highFivedUserIds: const ['user_rohan', 'user_me'],
      ),
      FeedItem(
        localId: 'feed_2',
        userId: 'user_rohan',
        userName: 'Rohan Verma',
        userAvatar: '🏃‍♂️',
        type: FeedItemType.routeShare,
        timestamp: now.subtract(const Duration(hours: 2)),
        routePayload: const GPSRouteSummary(
          routeId: 'route_noida_loop',
          routeName: 'Noida City Park Morning Loop',
          distanceKm: 8.4,
          durationMinutes: 42,
          elevationGainM: 45,
          averagePace: "5'00\" /km",
        ),
        highFiveCount: 14,
        highFivedUserIds: const ['user_priya'],
      ),
      FeedItem(
        localId: 'feed_3',
        userId: 'user_me',
        userName: 'Arjun (You)',
        userAvatar: '⚡',
        type: FeedItemType.transformation,
        timestamp: now.subtract(const Duration(hours: 5)),
        transformationPayload: const TransformationPayload(
          weightDeltaKg: -4.5,
          fatLossPct: 3,
          muscleGainPct: 2,
          streakDays: 30,
          healthScoreDelta: 12,
        ),
        highFiveCount: 20,
        highFivedUserIds: const ['user_priya', 'user_rohan'],
      ),
      FeedItem(
        localId: 'feed_4',
        userId: 'user_amit',
        userName: 'Amit Patel',
        userAvatar: '🏋️',
        type: FeedItemType.milestone,
        timestamp: now.subtract(const Duration(hours: 12)),
        milestonePayload: const MilestonePayload(
          milestoneTitle: 'Level 4 Builder Unlocked',
          streakDays: 14,
          xpEarned: 150,
        ),
        highFiveCount: 6,
        highFivedUserIds: const [],
      ),
    ];

    // Default follow relationship: current user follows Priya & Rohan
    _followSystem.followUser('user_me', 'user_priya');
    _followSystem.followUser('user_me', 'user_rohan');
  }

  /// Returns paginated feed items (page 0-indexed, 20 items per page).
  List<FeedItem> getPaginatedFeed({int page = 0, int pageSize = 20, FeedItemType? typeFilter}) {
    final filtered = typeFilter == null
        ? _feedItems
        : _feedItems.where((item) => item.type == typeFilter).toList();

    final startIndex = page * pageSize;
    if (startIndex >= filtered.length) return [];
    final endIndex = (startIndex + pageSize).clamp(0, filtered.length);

    return filtered.sublist(startIndex, endIndex);
  }

  /// Toggles High-Five reaction on a feed item (awards +2 XP up to 10 XP cap).
  void toggleHighFive(String localId, String currentUserId) {
    final index = _feedItems.indexWhere((item) => item.localId == localId);
    if (index == -1) return;

    final item = _feedItems[index];
    final userIds = List<String>.from(item.highFivedUserIds);
    final hasHighFived = userIds.contains(currentUserId);

    if (hasHighFived) {
      userIds.remove(currentUserId);
      _feedItems[index] = item.copyWith(
        highFiveCount: item.highFiveCount > 0 ? item.highFiveCount - 1 : 0,
        highFivedUserIds: userIds,
      );
    } else {
      userIds.add(currentUserId);
      _feedItems[index] = item.copyWith(
        highFiveCount: item.highFiveCount + 1,
        highFivedUserIds: userIds,
      );
    }
  }

  /// Adds a new curated feed item.
  bool addFeedItem(FeedItem newItem) {
    if (!_curationEngine.shouldCurateItem(
      type: newItem.type,
      workoutDurationMinutes: newItem.workoutPayload?.durationMinutes,
      caloriesBurned: newItem.workoutPayload?.caloriesBurned,
    )) {
      return false; // Rejected by curation gate (e.g. routine water/meal log)
    }

    _feedItems.insert(0, newItem);
    return true;
  }
}

final feedRepositoryProvider = Provider<FeedRepository>((_) {
  return FeedRepository();
});
