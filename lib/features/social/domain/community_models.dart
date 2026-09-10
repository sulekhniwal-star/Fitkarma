import 'package:flutter/foundation.dart';

/// Thematic category for Accountability Communities
enum CommunityCategory {
  cardiometabolic(
    label: 'Cardiometabolic & Glucose Reversal',
    regionalLabel: 'हृदय व शुगर संतुलन',
    iconName: 'monitor_heart',
    badgeColorCode: 0xFF00E676,
  ),
  dailyMovement(
    label: 'Daily Movement & Shatpawali',
    regionalLabel: 'दैनिक गतिशीलता व शतपावली',
    iconName: 'directions_walk',
    badgeColorCode: 0xFF00B0FF,
  ),
  desiStrength(
    label: 'Desi Strength & Body Recomp',
    regionalLabel: 'देसी शक्ति व शारीरिक सौष्ठव',
    iconName: 'fitness_center',
    badgeColorCode: 0xFFFFD700,
  ),
  ayurvedaCircadian(
    label: 'Ayurveda & Circadian Discipline',
    regionalLabel: 'दिनचर्या व त्रिदोष संतुलन',
    iconName: 'spa',
    badgeColorCode: 0xFFFF9100,
  ),
  womensHealth(
    label: 'Women’s Hormonal & Shakti Circle',
    regionalLabel: 'महिला शक्ति व हार्मोनल संतुलन',
    iconName: 'female',
    badgeColorCode: 0xFF7C4DFF,
  );

  final String label;
  final String regionalLabel;
  final String iconName;
  final int badgeColorCode;

  const CommunityCategory({
    required this.label,
    required this.regionalLabel,
    required this.iconName,
    required this.badgeColorCode,
  });
}

/// Mentor / Guide leading a community
@immutable
class CommunityMentor {
  final String id;
  final String name;
  final String regionalName;
  final String
      title; // e.g. "Ayurvedic Physician (BAMS)", "CSCS Strength Coach"
  final String avatarUrl;
  final double rating;
  final int verifiedAnswersCount;

  const CommunityMentor({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.title,
    required this.avatarUrl,
    required this.rating,
    required this.verifiedAnswersCount,
  });
}

/// Individual Discussion Question / Thread in a community
@immutable
class CommunityDiscussionThread {
  final String id;
  final String communityId;
  final String authorName;
  final String authorKarmaTier;
  final String title;
  final String regionalTitle;
  final String body;
  final DateTime createdAt;
  final int repliesCount;
  final int upvotesCount;
  final bool hasVerifiedMentorReply;
  final String? topAnswerSnippet;

  const CommunityDiscussionThread({
    required this.id,
    required this.communityId,
    required this.authorName,
    required this.authorKarmaTier,
    required this.title,
    required this.regionalTitle,
    required this.body,
    required this.createdAt,
    required this.repliesCount,
    required this.upvotesCount,
    required this.hasVerifiedMentorReply,
    this.topAnswerSnippet,
  });
}

/// Educational / Protocol resource inside a community
@immutable
class CommunityKnowledgeResource {
  final String id;
  final String title;
  final String regionalTitle;
  final String durationOrPages;
  final String resourceType; // "Meal Template", "Protocol Guide", "Video Flow"
  final int karmaToUnlock;
  final bool isUnlocked;

  const CommunityKnowledgeResource({
    required this.id,
    required this.title,
    required this.regionalTitle,
    required this.durationOrPages,
    required this.resourceType,
    required this.karmaToUnlock,
    required this.isUnlocked,
  });
}

/// Accountability Community (Mandala / समाज)
@immutable
class AccountabilityCommunity {
  final String id;
  final String name;
  final String regionalName;
  final CommunityCategory category;
  final String manifesto;
  final String regionalManifesto;
  final int activeMembersCount;
  final double communityPulseScore; // 0.0 to 100.0 (aggregated adherence)
  final int totalCollectiveKarma;
  final bool isUserJoined;
  final CommunityMentor leadMentor;
  final List<CommunityDiscussionThread> activeThreads;
  final List<CommunityKnowledgeResource> knowledgeVault;

  const AccountabilityCommunity({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.category,
    required this.manifesto,
    required this.regionalManifesto,
    required this.activeMembersCount,
    required this.communityPulseScore,
    required this.totalCollectiveKarma,
    required this.isUserJoined,
    required this.leadMentor,
    required this.activeThreads,
    required this.knowledgeVault,
  });

  AccountabilityCommunity copyWith({
    bool? isUserJoined,
    int? activeMembersCount,
    double? communityPulseScore,
    List<CommunityDiscussionThread>? activeThreads,
  }) {
    return AccountabilityCommunity(
      id: id,
      name: name,
      regionalName: regionalName,
      category: category,
      manifesto: manifesto,
      regionalManifesto: regionalManifesto,
      activeMembersCount: activeMembersCount ?? this.activeMembersCount,
      communityPulseScore: communityPulseScore ?? this.communityPulseScore,
      totalCollectiveKarma: totalCollectiveKarma,
      isUserJoined: isUserJoined ?? this.isUserJoined,
      leadMentor: leadMentor,
      activeThreads: activeThreads ?? this.activeThreads,
      knowledgeVault: knowledgeVault,
    );
  }
}
