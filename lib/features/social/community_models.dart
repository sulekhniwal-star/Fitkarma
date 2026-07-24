/// §P9-C Accountability Communities — Models
///
/// Defines community categories, groups, activity posts, and privacy models
/// matching §P9-C specification.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Community Category Enum (§P9-C Table)
// ─────────────────────────────────────────────────────────────────────────────

enum CommunityCategory {
  steps10k('10K Steps India', 'Anyone wanting to walk more', '👟', 12500),
  officeFatLoss('Office Fat Loss', 'Desk workers rebuilding baseline', '💼', 8400),
  pcosWarriors('PCOS Warriors', 'Women managing PCOS with lifestyle', '🌸', 6200),
  vegMuscle('Vegetarian Muscle Builders', 'Veg users building serious muscle', '🥦', 9100),
  diabetesSupport('Diabetes Reversal Support', 'Glucose management & reversal', '🩸', 4800),
  weddingPrep('Wedding Transformation', 'Short-term goal sprint users', '💍', 3400),
  navratriFitness('Navratri Fitness', 'Seasonal fasting & fitness community', '🪔', 2900),
  seniorStrength('Senior Strength India', 'Active users age 50+', '👴', 1800);

  const CommunityCategory(
    this.title,
    this.targetDescription,
    this.iconSymbol,
    this.initialMemberCount,
  );

  final String title;
  final String targetDescription;
  final String iconSymbol;
  final int initialMemberCount;
}

// ─────────────────────────────────────────────────────────────────────────────
// Community Post Model
// ─────────────────────────────────────────────────────────────────────────────

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.communityId,
    required this.authorName,
    required this.avatarEmoji,
    required this.timestamp,
    required this.textContent,
    required this.cheerCount,
    this.isCheered = false,
  });

  final String id;
  final String communityId;
  final String authorName;
  final String avatarEmoji;
  final DateTime timestamp;
  final String textContent;
  final int cheerCount;
  final bool isCheered;

  CommunityPost copyWith({
    int? cheerCount,
    bool? isCheered,
  }) {
    return CommunityPost(
      id: id,
      communityId: communityId,
      authorName: authorName,
      avatarEmoji: avatarEmoji,
      timestamp: timestamp,
      textContent: textContent,
      cheerCount: cheerCount ?? this.cheerCount,
      isCheered: isCheered ?? this.isCheered,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Community Group Model
// ─────────────────────────────────────────────────────────────────────────────

class CommunityGroup {
  const CommunityGroup({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.iconSymbol,
    required this.memberCount,
    this.isJoined = false,
    this.activityPosts = const [],
  });

  final String id;
  final CommunityCategory category;
  final String name;
  final String description;
  final String iconSymbol;
  final int memberCount;
  final bool isJoined;
  final List<CommunityPost> activityPosts;

  CommunityGroup copyWith({
    int? memberCount,
    bool? isJoined,
    List<CommunityPost>? activityPosts,
  }) {
    return CommunityGroup(
      id: id,
      category: category,
      name: name,
      description: description,
      iconSymbol: iconSymbol,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
      activityPosts: activityPosts ?? this.activityPosts,
    );
  }
}
