import 'community_models.dart';

/// Pure Dart Deterministic Engine for Community Pulse Scores,
/// Discussion Filtering, and Knowledge Vault Indexing.
class CommunityEngine {
  const CommunityEngine._();

  /// Calculates Community Pulse Score (0.0 to 100.0)
  static double calculateCommunityPulse({
    required double averageMemberAdherence,
    required int activeDailyThreads,
    required double mentorResponseRatePercent,
  }) {
    final adherenceComponent = averageMemberAdherence * 0.50;
    final activityComponent =
        (activeDailyThreads / 20.0).clamp(0.0, 1.0) * 30.0;
    final mentorComponent =
        (mentorResponseRatePercent / 100.0).clamp(0.0, 1.0) * 20.0;

    return (adherenceComponent + activityComponent + mentorComponent)
        .clamp(0.0, 100.0);
  }

  /// Filters communities by category or joined status
  static List<AccountabilityCommunity> filterCommunities({
    required List<AccountabilityCommunity> communities,
    CommunityCategory? category,
    bool joinedOnly = false,
  }) {
    return communities.where((c) {
      if (joinedOnly && !c.isUserJoined) return false;
      if (category != null && c.category != category) return false;
      return true;
    }).toList();
  }
}
