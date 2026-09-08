import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/social_models.dart';

final socialProvider =
    StateNotifierProvider<SocialNotifier, SocialHubState>((ref) {
  return SocialNotifier();
});

class SocialNotifier extends StateNotifier<SocialHubState> {
  SocialNotifier() : super(_buildInitialState());

  static SocialHubState _buildInitialState() {
    const defaultSquad = SquadSummary(
      squadId: 'squad_vayuprecision',
      squadName: 'Vayu Pacesetters (वायु साधक दल)',
      regionalSquadName: 'वायु साधक दल (५ सदस्य)',
      memberCount: 5,
      activeStreakDays: 19,
      squadAdherenceScore: 92.5,
      squadMultiplier: 1.26,
      totalWeeklyKarma: 4850,
      memberInitials: ['AK', 'PS', 'RV', 'NM', 'You'],
    );

    const defaultFamilyCircle = [
      FamilyMemberSummary(
        memberId: 'fam_1',
        name: 'Father (Pitaji)',
        relationship: 'Father',
        regionalRelationship: 'पिताजी',
        todaySteps: 6200,
        dailyStepTarget: 6000,
        healthStatus: 'Optimal • Blood Pressure Logged (122/78)',
        alertRequired: false,
      ),
      FamilyMemberSummary(
        memberId: 'fam_2',
        name: 'Mother (Mataji)',
        relationship: 'Mother',
        regionalRelationship: 'माताजी',
        todaySteps: 4100,
        dailyStepTarget: 5000,
        healthStatus: 'Needs Evening Shatpawali Walk',
        alertRequired: true,
      ),
    ];

    const defaultClub = LocalClubSummary(
      clubId: 'club_blr_koramangala',
      name: 'Koramangala Morning Sadhana Circle',
      cityArea: 'Koramangala 4th Block, Bengaluru',
      activeMembersCount: 84,
      primaryActivity: 'Sunrise Calisthenics & Shatpawali',
      weeklyCollectiveSteps: 4820000,
    );

    final initialFeedItems = [
      SocialFeedItem(
        id: 'post_1',
        authorId: 'user_priya',
        authorName: 'Priya Sharma',
        authorAvatarUrl: '',
        authorLocation: 'Bengaluru, Tier 1',
        authorKarmaBadge: 'Vanguard (Agrani)',
        eventType: SocialEventType.shatpawaliStreak,
        eventHeadline: 'Completed 21-Day Post-Dinner Shatpawali Streak!',
        regionalEventHeadline: '२१ दिवसीय शतपावली साधना पूर्ण!',
        detailMetrics: '100 steps after every meal • Morning recovery at 92% • +50 Karma',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        kudosCount: 18,
        hasUserLiked: false,
      ),
      SocialFeedItem(
        id: 'post_2',
        authorId: 'user_rohit',
        authorName: 'Rohit Verma',
        authorAvatarUrl: '',
        authorLocation: 'Pune, Tier 2',
        authorKarmaBadge: 'Kshatriya Athlete',
        eventType: SocialEventType.workoutCompleted,
        eventHeadline: 'Crushed Heavy Desi Baithak & Deadlift PR (140kg)',
        regionalEventHeadline: 'देसी बैठक व १४० किग्रा डेडलिफ्ट रिकॉर्ड स्थापित!',
        detailMetrics: '4 Sets Baithak • 140kg 1RM • Form Checked by Vision AI • +75 Karma',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 10)),
        kudosCount: 34,
        hasUserLiked: true,
      ),
      SocialFeedItem(
        id: 'post_3',
        authorId: 'user_ananya',
        authorName: 'Ananya Deshmukh',
        authorAvatarUrl: '',
        authorLocation: 'Mumbai, Tier 1',
        authorKarmaBadge: 'Dharma Yogi',
        eventType: SocialEventType.milestoneUnlocked,
        eventHeadline: 'Reversed Visceral Adiposity Risk (WHtR < 0.48)',
        regionalEventHeadline: 'उपापचयी स्वास्थ्य में स्वर्ण मानक प्राप्त (<०.४८)!',
        detailMetrics: 'Waist reduced 6cm • Fasting Glucose stabilized • +250 Karma',
        timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 45)),
        kudosCount: 52,
        hasUserLiked: false,
      ),
      SocialFeedItem(
        id: 'post_4',
        authorId: 'user_vikram',
        authorName: 'Vikram Mehta',
        authorAvatarUrl: '',
        authorLocation: 'Delhi NCR, Tier 1',
        authorKarmaBadge: 'Luminary (Margdarshak)',
        eventType: SocialEventType.karmaTierPromotion,
        eventHeadline: 'Elevated to Sangha Luminary Tier!',
        regionalEventHeadline: 'संघ मार्गदर्शक पदवी पर आरोहण!',
        detailMetrics: '5,000+ Karma accumulated • Squad multiplier at 1.40x • +500 Karma',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        kudosCount: 89,
        hasUserLiked: false,
      ),
    ];

    return SocialHubState(
      selectedFilter: SocialFeedFilter.all,
      activeSquad: defaultSquad,
      familyCircle: defaultFamilyCircle,
      localClub: defaultClub,
      feedItems: initialFeedItems,
    );
  }

  void selectFilter(SocialFeedFilter filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  void toggleKudos(String postId) {
    final updatedFeed = state.feedItems.map((item) {
      if (item.id == postId) {
        final currentlyLiked = item.hasUserLiked;
        return item.copyWith(
          hasUserLiked: !currentlyLiked,
          kudosCount: currentlyLiked ? item.kudosCount - 1 : item.kudosCount + 1,
        );
      }
      return item;
    }).toList();

    state = state.copyWith(feedItems: updatedFeed);
  }
}
