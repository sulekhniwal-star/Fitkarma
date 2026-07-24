/// §P9-C Accountability Communities — Persistence Repository
///
/// In-memory repository for persisting CommunityGroups and user membership states.
library;

import 'package:fitkarma/features/social/community_engine.dart';
import 'package:fitkarma/features/social/community_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityRepository {
  CommunityRepository() {
    _initializeDefaultCommunities();
  }

  final CommunityEngine _engine = const CommunityEngine();
  late List<CommunityGroup> _communities;

  void _initializeDefaultCommunities() {
    _communities = CommunityCategory.values.map((cat) {
      final samplePosts = [
        CommunityPost(
          id: 'post_${cat.name}_1',
          communityId: cat.name,
          authorName: 'Aarav M.',
          avatarEmoji: '🏃',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          textContent: 'Hit my daily milestone goal today! Feeling energized. 🔥',
          cheerCount: 14,
        ),
        CommunityPost(
          id: 'post_${cat.name}_2',
          communityId: cat.name,
          authorName: 'Diya K.',
          avatarEmoji: '🥗',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          textContent: 'Prepared high-protein paneer bhurji for dinner. Consistency win!',
          cheerCount: 22,
        ),
      ];

      return CommunityGroup(
        id: cat.name,
        category: cat,
        name: cat.title,
        description: cat.targetDescription,
        iconSymbol: cat.iconSymbol,
        memberCount: cat.initialMemberCount,
        isJoined: cat == CommunityCategory.steps10k || cat == CommunityCategory.vegMuscle,
        activityPosts: samplePosts,
      );
    }).toList();
  }

  List<CommunityGroup> get communities => List.unmodifiable(_communities);

  List<CommunityGroup> get joinedCommunities =>
      _communities.where((c) => c.isJoined).toList();

  /// Toggles membership for a community group.
  void toggleMembership(String communityId) {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index != -1) {
      _communities[index] = _engine.toggleMembership(_communities[index]);
    }
  }

  /// Toggles supportive cheer on a community post.
  void toggleCheer(String communityId, String postId) {
    final groupIndex = _communities.indexWhere((c) => c.id == communityId);
    if (groupIndex != -1) {
      final group = _communities[groupIndex];
      final postIndex = group.activityPosts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final updatedPosts = List<CommunityPost>.from(group.activityPosts);
        updatedPosts[postIndex] = _engine.toggleCheer(updatedPosts[postIndex]);
        _communities[groupIndex] = group.copyWith(activityPosts: updatedPosts);
      }
    }
  }
}

final communityRepositoryProvider = Provider<CommunityRepository>((_) {
  return CommunityRepository();
});
