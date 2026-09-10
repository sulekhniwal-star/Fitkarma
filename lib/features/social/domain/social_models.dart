import 'package:flutter/foundation.dart';

/// Filter tabs on the Social Hub
enum SocialFeedFilter {
  all(
    label: 'All Activity (Sangha)',
    regionalLabel: 'समस्त गतिविधि (संघ)',
    iconName: 'public',
  ),
  squad(
    label: 'My Squad (Dal)',
    regionalLabel: 'मेरा दल (सक्रिय समूह)',
    iconName: 'groups',
  ),
  family(
    label: 'Family Circle (Parivar)',
    regionalLabel: 'परिवार चक्र',
    iconName: 'family_restroom',
  ),
  localClubs(
    label: 'Local Clubs (Kshetra)',
    regionalLabel: 'स्थानीय क्लब व क्षेत्र',
    iconName: 'location_on',
  );

  final String label;
  final String regionalLabel;
  final String iconName;

  const SocialFeedFilter({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
  });
}

/// Type of social activity event
enum SocialEventType {
  workoutCompleted(
    title: 'Workout Completed',
    regionalTitle: 'व्यायाम पूर्ण',
    iconName: 'fitness_center',
    badgeColorCode: 0xFF00E676,
  ),
  shatpawaliStreak(
    title: 'Shatpawali Streak',
    regionalTitle: 'शतपावली निरंतरता',
    iconName: 'directions_walk',
    badgeColorCode: 0xFF00B0FF,
  ),
  milestoneUnlocked(
    title: 'Milestone Unlocked',
    regionalTitle: 'पड़ाव पार (सिद्धि)',
    iconName: 'military_tech',
    badgeColorCode: 0xFFFFD700,
  ),
  familyCheckIn(
    title: 'Family Health Check',
    regionalTitle: 'पारिवारिक स्वास्थ्य अवलोकन',
    iconName: 'favorite',
    badgeColorCode: 0xFFFF9100,
  ),
  karmaTierPromotion(
    title: 'Karma Tier Elevation',
    regionalTitle: 'कर्म पदोन्नति',
    iconName: 'auto_awesome',
    badgeColorCode: 0xFF7C4DFF,
  );

  final String title;
  final String regionalTitle;
  final String iconName;
  final int badgeColorCode;

  const SocialEventType({
    required this.title,
    required this.regionalTitle,
    required this.iconName,
    required this.badgeColorCode,
  });
}

/// Individual Social Feed Post / Activity
@immutable
class SocialFeedItem {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final String authorLocation; // e.g. "Bengaluru, Tier 1"
  final String authorKarmaBadge; // e.g. "Vanguard (Agrani)"
  final SocialEventType eventType;
  final String eventHeadline;
  final String regionalEventHeadline;
  final String
      detailMetrics; // e.g. "12,400 steps • 100% Shatpawali • +45 Karma"
  final DateTime timestamp;
  final int kudosCount;
  final bool hasUserLiked;
  final String? attachedImageUrl;

  const SocialFeedItem({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.authorLocation,
    required this.authorKarmaBadge,
    required this.eventType,
    required this.eventHeadline,
    required this.regionalEventHeadline,
    required this.detailMetrics,
    required this.timestamp,
    required this.kudosCount,
    this.hasUserLiked = false,
    this.attachedImageUrl,
  });

  SocialFeedItem copyWith({
    int? kudosCount,
    bool? hasUserLiked,
  }) {
    return SocialFeedItem(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      authorLocation: authorLocation,
      authorKarmaBadge: authorKarmaBadge,
      eventType: eventType,
      eventHeadline: eventHeadline,
      regionalEventHeadline: regionalEventHeadline,
      detailMetrics: detailMetrics,
      timestamp: timestamp,
      kudosCount: kudosCount ?? this.kudosCount,
      hasUserLiked: hasUserLiked ?? this.hasUserLiked,
      attachedImageUrl: attachedImageUrl,
    );
  }
}

/// High-level overview of the user's active micro-squad
@immutable
class SquadSummary {
  final String squadId;
  final String squadName;
  final String regionalSquadName;
  final int memberCount;
  final int activeStreakDays;
  final double squadAdherenceScore;
  final double squadMultiplier; // e.g. 1.25x
  final int totalWeeklyKarma;
  final List<String> memberInitials;

  const SquadSummary({
    required this.squadId,
    required this.squadName,
    required this.regionalSquadName,
    required this.memberCount,
    required this.activeStreakDays,
    required this.squadAdherenceScore,
    required this.squadMultiplier,
    required this.totalWeeklyKarma,
    required this.memberInitials,
  });
}

/// Quick intergenerational family member check-in summary
@immutable
class FamilyMemberSummary {
  final String memberId;
  final String name;
  final String relationship; // e.g. "Father (Pitaji)", "Mother (Mataji)"
  final String regionalRelationship;
  final int todaySteps;
  final int dailyStepTarget;
  final String healthStatus; // "Optimal", "Needs Shatpawali", "Vitals Logged"
  final bool alertRequired;

  const FamilyMemberSummary({
    required this.memberId,
    required this.name,
    required this.relationship,
    required this.regionalRelationship,
    required this.todaySteps,
    required this.dailyStepTarget,
    required this.healthStatus,
    this.alertRequired = false,
  });

  double get stepProgressFraction =>
      (todaySteps / dailyStepTarget).clamp(0.0, 1.0);
}

/// Local neighborhood fitness circle spotlight
@immutable
class LocalClubSummary {
  final String clubId;
  final String name;
  final String cityArea; // e.g. "Koramangala 4th Block, BLR"
  final int activeMembersCount;
  final String primaryActivity; // "Sunrise Shatpawali & Running"
  final int weeklyCollectiveSteps;

  const LocalClubSummary({
    required this.clubId,
    required this.name,
    required this.cityArea,
    required this.activeMembersCount,
    required this.primaryActivity,
    required this.weeklyCollectiveSteps,
  });
}

/// Complete state container for Social Hub
@immutable
class SocialHubState {
  final SocialFeedFilter selectedFilter;
  final SquadSummary activeSquad;
  final List<FamilyMemberSummary> familyCircle;
  final LocalClubSummary localClub;
  final List<SocialFeedItem> feedItems;

  const SocialHubState({
    required this.selectedFilter,
    required this.activeSquad,
    required this.familyCircle,
    required this.localClub,
    required this.feedItems,
  });

  SocialHubState copyWith({
    SocialFeedFilter? selectedFilter,
    SquadSummary? activeSquad,
    List<FamilyMemberSummary>? familyCircle,
    LocalClubSummary? localClub,
    List<SocialFeedItem>? feedItems,
  }) {
    return SocialHubState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      activeSquad: activeSquad ?? this.activeSquad,
      familyCircle: familyCircle ?? this.familyCircle,
      localClub: localClub ?? this.localClub,
      feedItems: feedItems ?? this.feedItems,
    );
  }
}
