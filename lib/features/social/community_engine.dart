/// §P9-C Accountability Communities — Engine
///
/// Implements membership join/leave logic, cheer interactions, and feed privacy auditing
/// (asserting no private health metrics are exposed in public community feeds).
library;

import 'package:fitkarma/features/social/community_models.dart';

class CommunityPrivacyException implements Exception {
  CommunityPrivacyException(this.message);
  final String message;

  @override
  String toString() => 'CommunityPrivacyException: $message';
}

class CommunityEngine {
  const CommunityEngine();

  /// Toggles membership status for a community group.
  CommunityGroup toggleMembership(CommunityGroup group) {
    final newIsJoined = !group.isJoined;
    final newMemberCount = newIsJoined
        ? group.memberCount + 1
        : (group.memberCount > 0 ? group.memberCount - 1 : 0);

    return group.copyWith(
      isJoined: newIsJoined,
      memberCount: newMemberCount,
    );
  }

  /// Toggles supportive cheer on an activity feed post.
  CommunityPost toggleCheer(CommunityPost post) {
    final newIsCheered = !post.isCheered;
    final newCheerCount = newIsCheered
        ? post.cheerCount + 1
        : (post.cheerCount > 0 ? post.cheerCount - 1 : 0);

    return post.copyWith(
      isCheered: newIsCheered,
      cheerCount: newCheerCount,
    );
  }

  /// Privacy Audit (§P9-C requirement):
  /// Confirms no personal health data (e.g. raw blood pressure, weight kg, glucose mg/dL, medical diagnosis)
  /// leaks through community feed posts.
  void auditFeedPrivacy(List<CommunityPost> posts) {
    for (final post in posts) {
      final content = post.textContent.toLowerCase();
      if (content.contains('mg/dl') ||
          content.contains('mmhg') ||
          content.contains('blood pressure:') ||
          content.contains('glucose:') ||
          content.contains('kg weight') ||
          RegExp(r'\b\d{2,3}/\d{2,3}\b').hasMatch(content)) {
        throw CommunityPrivacyException(
          'Private medical/health metric detected in public community post ID ${post.id}: "${post.textContent}"',
        );
      }
    }
  }
}
