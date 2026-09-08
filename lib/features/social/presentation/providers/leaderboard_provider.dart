import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/leaderboard_engine.dart';
import '../../domain/leaderboard_models.dart';

final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, LeaderboardReportState>((ref) {
  return LeaderboardNotifier();
});

class LeaderboardNotifier extends StateNotifier<LeaderboardReportState> {
  LeaderboardNotifier() : super(_buildInitialState());

  static LeaderboardReportState _buildInitialState() {
    final mockEntries = [
      const LeaderboardEntry(
        rank: 1,
        athleteId: 'user_vikram',
        athleteName: 'Vikram Rajput',
        avatarInitials: 'VR',
        karmaTierTitle: 'Luminary (Margdarshak)',
        cityLocation: 'Delhi NCR, Tier 1',
        scoreValue: 1850.0,
        scoreUnit: 'Karma',
        activeStreakDays: 34,
        isCurrentUser: false,
        kudosReceived: 142,
      ),
      const LeaderboardEntry(
        rank: 2,
        athleteId: 'user_ananya',
        athleteName: 'Ananya Deshmukh',
        avatarInitials: 'AD',
        karmaTierTitle: 'Vanguard (Agrani)',
        cityLocation: 'Mumbai, Tier 1',
        scoreValue: 1680.0,
        scoreUnit: 'Karma',
        activeStreakDays: 28,
        isCurrentUser: false,
        kudosReceived: 98,
      ),
      const LeaderboardEntry(
        rank: 3,
        athleteId: 'user_rohit',
        athleteName: 'Rohit Verma',
        avatarInitials: 'RV',
        karmaTierTitle: 'Vanguard (Agrani)',
        cityLocation: 'Pune, Tier 2',
        scoreValue: 1540.0,
        scoreUnit: 'Karma',
        activeStreakDays: 24,
        isCurrentUser: false,
        kudosReceived: 76,
      ),
      const LeaderboardEntry(
        rank: 4,
        athleteId: 'user_you',
        athleteName: 'You (Aarav Sharma)',
        avatarInitials: 'You',
        karmaTierTitle: 'Vanguard (Agrani)',
        cityLocation: 'Bengaluru, Tier 1',
        scoreValue: 1490.0,
        scoreUnit: 'Karma',
        activeStreakDays: 19,
        isCurrentUser: true,
        kudosReceived: 54,
      ),
      const LeaderboardEntry(
        rank: 5,
        athleteId: 'user_priya',
        athleteName: 'Priya Sharma',
        avatarInitials: 'PS',
        karmaTierTitle: 'Pacesetter',
        cityLocation: 'Bengaluru, Tier 1',
        scoreValue: 1380.0,
        scoreUnit: 'Karma',
        activeStreakDays: 19,
        isCurrentUser: false,
        kudosReceived: 45,
      ),
      const LeaderboardEntry(
        rank: 6,
        athleteId: 'user_siddharth',
        athleteName: 'Siddharth Iyer',
        avatarInitials: 'SI',
        karmaTierTitle: 'Pacesetter',
        cityLocation: 'Chennai, Tier 1',
        scoreValue: 1290.0,
        scoreUnit: 'Karma',
        activeStreakDays: 15,
        isCurrentUser: false,
        kudosReceived: 38,
      ),
      const LeaderboardEntry(
        rank: 7,
        athleteId: 'user_meera',
        athleteName: 'Meera Nair',
        avatarInitials: 'MN',
        karmaTierTitle: 'Pacesetter',
        cityLocation: 'Kochi, Tier 2',
        scoreValue: 1210.0,
        scoreUnit: 'Karma',
        activeStreakDays: 14,
        isCurrentUser: false,
        kudosReceived: 29,
      ),
    ];

    final userEntry = mockEntries.firstWhere((e) => e.isCurrentUser);
    const totalPool = 48250;
    final percentile = LeaderboardEngine.calculatePercentileRank(
      rank: userEntry.rank,
      totalAthletes: totalPool,
    );

    return LeaderboardReportState(
      selectedTimeframe: LeaderboardTimeframe.weekly,
      selectedCategory: LeaderboardCategory.karmaVelocity,
      selectedScope: LeaderboardScope.national,
      userEntry: userEntry,
      userPercentile: percentile,
      podiumEntries: LeaderboardEngine.extractPodium(mockEntries),
      allRankings: mockEntries,
      totalAthletesInPool: totalPool,
    );
  }

  void switchTimeframe(LeaderboardTimeframe timeframe) {
    state = state.copyWith(selectedTimeframe: timeframe);
  }

  void switchCategory(LeaderboardCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void switchScope(LeaderboardScope scope) {
    state = state.copyWith(selectedScope: scope);
  }

  void giveKudos(String athleteId) {
    final updatedRankings = state.allRankings.map((entry) {
      if (entry.athleteId == athleteId) {
        return LeaderboardEntry(
          rank: entry.rank,
          athleteId: entry.athleteId,
          athleteName: entry.athleteName,
          avatarInitials: entry.avatarInitials,
          karmaTierTitle: entry.karmaTierTitle,
          cityLocation: entry.cityLocation,
          scoreValue: entry.scoreValue,
          scoreUnit: entry.scoreUnit,
          activeStreakDays: entry.activeStreakDays,
          isCurrentUser: entry.isCurrentUser,
          kudosReceived: entry.kudosReceived + 1,
        );
      }
      return entry;
    }).toList();

    state = state.copyWith(allRankings: updatedRankings);
  }
}
