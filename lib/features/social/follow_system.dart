/// §P9-E Activity Feed — Follow System Manager
///
/// Pure Dart follow system managing follower/following relationships and state.
library;

import 'package:fitkarma/features/social/feed_models.dart';

class FollowSystem {
  final List<FollowRecord> _records = [];

  /// Follows a target user.
  FollowRecord followUser(String followerId, String targetId) {
    if (followerId == targetId) {
      throw ArgumentError('Users cannot follow themselves.');
    }

    final existingIndex = _records.indexWhere(
      (r) => r.followerId == followerId && r.followingId == targetId,
    );

    if (existingIndex != -1) {
      return _records[existingIndex];
    }

    final record = FollowRecord(
      followerId: followerId,
      followingId: targetId,
      timestamp: DateTime.now(),
      isAccepted: true,
    );
    _records.add(record);
    return record;
  }

  /// Unfollows a target user.
  bool unfollowUser(String followerId, String targetId) {
    final countBefore = _records.length;
    _records.removeWhere(
      (r) => r.followerId == followerId && r.followingId == targetId,
    );
    return _records.length < countBefore;
  }

  /// Checks if [followerId] is following [targetId].
  bool isFollowing(String followerId, String targetId) {
    return _records.any(
      (r) => r.followerId == followerId && r.followingId == targetId && r.isAccepted,
    );
  }

  /// Returns list of user IDs that [userId] is following.
  List<String> getFollowingList(String userId) {
    return _records
        .where((r) => r.followerId == userId && r.isAccepted)
        .map((r) => r.followingId)
        .toList();
  }

  /// Returns list of follower user IDs for [userId].
  List<String> getFollowersList(String userId) {
    return _records
        .where((r) => r.followingId == userId && r.isAccepted)
        .map((r) => r.followerId)
        .toList();
  }

  /// Clears in-memory records (for testing).
  void clear() => _records.clear();

  List<FollowRecord> get allRecords => List.unmodifiable(_records);
}
