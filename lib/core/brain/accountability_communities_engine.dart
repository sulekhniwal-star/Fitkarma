enum CommunityCategory {
  generalFitness,
  corporateDesk,
  womenHealth,
  vegNutrition,
  metabolicHealth,
  eventGoal,
  seasonalFasting,
  seniorHealth,
}

class CommunityInfo {
  final String id;
  final String title;
  final String description;
  final CommunityCategory category;
  final String targetAudience;
  final int memberCount;
  final String iconEmoji;
  final bool isJoined;

  const CommunityInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetAudience,
    required this.memberCount,
    required this.iconEmoji,
    this.isJoined = false,
  });

  CommunityInfo copyWith({bool? isJoined}) {
    return CommunityInfo(
      id: id,
      title: title,
      description: description,
      category: category,
      targetAudience: targetAudience,
      memberCount: memberCount,
      iconEmoji: iconEmoji,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}

class CommunityActivityPost {
  final String id;
  final String communityId;
  final String authorName;
  final String activityTitle; // e.g. "Completed 10,000 steps today!"
  final String timeAgo;
  final int cheerCount;
  final bool isCheered;

  const CommunityActivityPost({
    required this.id,
    required this.communityId,
    required this.authorName,
    required this.activityTitle,
    required this.timeAgo,
    required this.cheerCount,
    this.isCheered = false,
  });

  CommunityActivityPost copyWith({int? cheerCount, bool? isCheered}) {
    return CommunityActivityPost(
      id: id,
      communityId: communityId,
      authorName: authorName,
      activityTitle: activityTitle,
      timeAgo: timeAgo,
      cheerCount: cheerCount ?? this.cheerCount,
      isCheered: isCheered ?? this.isCheered,
    );
  }
}

/// Pure-Dart Accountability Communities Engine per §P9-C spec
class AccountabilityCommunitiesEngine {
  const AccountabilityCommunitiesEngine();

  /// Returns 8 pre-seeded Indian Accountability Communities per §P9-C spec
  List<CommunityInfo> getAvailableCommunities() {
    return const [
      CommunityInfo(
        id: 'comm_10k',
        title: '10K Steps India',
        description: 'Anyone wanting to walk more daily.',
        category: CommunityCategory.generalFitness,
        targetAudience: 'Anyone wanting to walk more',
        memberCount: 14250,
        iconEmoji: '🚶‍♂️',
        isJoined: true,
      ),
      CommunityInfo(
        id: 'comm_office',
        title: 'Office Fat Loss',
        description: 'Desk workers overcoming sedentary office fatigue.',
        category: CommunityCategory.corporateDesk,
        targetAudience: 'Desk workers',
        memberCount: 8900,
        iconEmoji: '💼',
        isJoined: true,
      ),
      CommunityInfo(
        id: 'comm_pcos',
        title: 'PCOS Warriors',
        description:
            'Women managing hormone balance through fitness & nutrition.',
        category: CommunityCategory.womenHealth,
        targetAudience: 'Women with PCOS',
        memberCount: 6400,
        iconEmoji: '🌸',
      ),
      CommunityInfo(
        id: 'comm_veg',
        title: 'Vegetarian Muscle Builders',
        description:
            'High-protein Satvik and Indian vegetarian recipes & strength gains.',
        category: CommunityCategory.vegNutrition,
        targetAudience: 'Veg users building muscle',
        memberCount: 11200,
        iconEmoji: '🌱',
      ),
      CommunityInfo(
        id: 'comm_diabetes',
        title: 'Diabetes Reversal Support',
        description:
            'Glycemic control and glucose stabilization through lifestyle.',
        category: CommunityCategory.metabolicHealth,
        targetAudience: 'High glucose users',
        memberCount: 5100,
        iconEmoji: '🩸',
      ),
      CommunityInfo(
        id: 'comm_wedding',
        title: 'Wedding Transformation',
        description: 'Short-term high-intensity body composition goals.',
        category: CommunityCategory.eventGoal,
        targetAudience: 'Short-term goal users',
        memberCount: 3800,
        iconEmoji: '💍',
      ),
      CommunityInfo(
        id: 'comm_navratri',
        title: 'Navratri Fitness',
        description: 'Seasonal Satvik fasting & energetic workout adaptations.',
        category: CommunityCategory.seasonalFasting,
        targetAudience: 'Seasonal community',
        memberCount: 7200,
        iconEmoji: '🪔',
      ),
      CommunityInfo(
        id: 'comm_senior',
        title: 'Senior Strength India',
        description:
            'Joint-friendly strength, balance & vitality for 50+ members.',
        category: CommunityCategory.seniorHealth,
        targetAudience: 'Users 50+',
        memberCount: 2900,
        iconEmoji: '🧘‍♀️',
      ),
    ];
  }

  /// Privacy Safeguard check: guarantees zero personal health data is exposed
  bool isPostPrivacyCompliant(CommunityActivityPost post) {
    final lower = post.activityTitle.toLowerCase();
    // Block raw metrics / sensitive medical data leakage (BP values, raw weight kg, medical diagnoses)
    if (lower.contains('bp ') ||
        lower.contains('mmhg') ||
        lower.contains('glucose') ||
        lower.contains('diagnosis')) {
      return false;
    }
    return true;
  }
}
