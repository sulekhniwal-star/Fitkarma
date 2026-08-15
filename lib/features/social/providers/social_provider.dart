import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/daily_intelligence_package.dart';
import '../../../core/brain/squad_engine.dart';
import '../models/squad_model.dart';

class SocialState {
  final String squadInviteCode;
  final List<SquadReadinessStatus> squadReadinessBoard;
  final List<ActivityFeedItem> feedItems;
  final List<LeaderboardEntry> leaderboard;
  final bool isAnonymousMode;

  const SocialState({
    required this.squadInviteCode,
    this.squadReadinessBoard = const [
      SquadReadinessStatus(
          memberName: 'Aarav M.',
          tier: ReadinessTier.premium,
          statusLabel: 'Peak Readiness'),
      SquadReadinessStatus(
          memberName: 'Priya K.',
          tier: ReadinessTier.enhanced,
          statusLabel: 'Moderate Active'),
      SquadReadinessStatus(
          memberName: 'Rohan S.',
          tier: ReadinessTier.basic,
          statusLabel: 'Active Recovery'),
    ],
    this.feedItems = const [
      ActivityFeedItem(
          id: 'feed_1',
          userName: 'Priya K.',
          userAvatarUrl: '',
          title: 'Completed Barbell Squat Session',
          description: 'Earned +150 Outcome XP • Form Quality 98%',
          timestamp: '2h ago',
          highFiveCount: 5),
      ActivityFeedItem(
          id: 'feed_2',
          userName: 'Aarav M.',
          userAvatarUrl: '',
          title: 'Hit Daily Protein Target',
          description: '135g Protein Logged (Pure Veg)',
          timestamp: '4h ago',
          highFiveCount: 8),
    ],
    this.leaderboard = const [
      LeaderboardEntry(rank: 1, name: 'Aarav M.', outcomeXp: 1450),
      LeaderboardEntry(rank: 2, name: 'Priya K.', outcomeXp: 1200),
      LeaderboardEntry(rank: 3, name: 'You', outcomeXp: 950),
    ],
    this.isAnonymousMode = false,
  });

  SocialState copyWith({
    String? squadInviteCode,
    List<SquadReadinessStatus>? squadReadinessBoard,
    List<ActivityFeedItem>? feedItems,
    List<LeaderboardEntry>? leaderboard,
    bool? isAnonymousMode,
  }) {
    return SocialState(
      squadInviteCode: squadInviteCode ?? this.squadInviteCode,
      squadReadinessBoard: squadReadinessBoard ?? this.squadReadinessBoard,
      feedItems: feedItems ?? this.feedItems,
      leaderboard: leaderboard ?? this.leaderboard,
      isAnonymousMode: isAnonymousMode ?? this.isAnonymousMode,
    );
  }
}

class SocialNotifier extends StateNotifier<SocialState> {
  final SquadEngine engine;

  SocialNotifier(this.engine)
      : super(
          SocialState(
            squadInviteCode: engine.generateInviteCode(),
          ),
        );

  void toggleHighFive(String feedItemId) {
    final updatedList = state.feedItems.map((item) {
      if (item.id == feedItemId) {
        final newCount =
            item.isHighFived ? item.highFiveCount - 1 : item.highFiveCount + 1;
        return item.copyWith(
            highFiveCount: newCount, isHighFived: !item.isHighFived);
      }
      return item;
    }).toList();

    state = state.copyWith(feedItems: updatedList);
  }

  void toggleAnonymity() {
    state = state.copyWith(isAnonymousMode: !state.isAnonymousMode);
  }
}

final socialProvider =
    StateNotifierProvider<SocialNotifier, SocialState>((ref) {
  return SocialNotifier(const SquadEngine());
});
