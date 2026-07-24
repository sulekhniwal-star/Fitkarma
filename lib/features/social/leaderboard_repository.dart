/// §P9-G Weekly & Monthly Leaderboards — Persistence Repository
///
/// In-memory repository managing weekly and monthly cohort rankings for micro-regions
/// matching §P9-G specification.
library;

import 'package:fitkarma/features/social/leaderboard_engine.dart';
import 'package:fitkarma/features/social/leaderboard_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardRepository {
  LeaderboardRepository() {
    _initializeDefaultLeaderboard();
  }

  final LeaderboardEngine _engine = const LeaderboardEngine();
  bool _isAnonymousMode = false;
  late List<LeaderboardEntry> _rawWeeklyStepsEntries;

  bool get isAnonymousMode => _isAnonymousMode;

  void toggleAnonymousMode() {
    _isAnonymousMode = !_isAnonymousMode;
  }

  void _initializeDefaultLeaderboard() {
    final now = DateTime.now();

    _rawWeeklyStepsEntries = [
      LeaderboardEntry(
        rank: 0,
        userId: 'u_ramesh',
        userName: 'Ramesh S.',
        userAvatar: '🏃‍♂️',
        score: 78400,
        metricUnit: 'steps',
        version: 1,
        lastUpdatedAt: now.subtract(const Duration(hours: 1)),
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_priya',
        userName: 'Priya K.',
        userAvatar: '🏃‍♀️',
        score: 76200,
        metricUnit: 'steps',
        version: 1,
        lastUpdatedAt: now.subtract(const Duration(hours: 2)),
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'user_me',
        userName: 'Arjun T. (You)',
        userAvatar: '⚡',
        score: 74900,
        metricUnit: 'steps',
        version: 1,
        lastUpdatedAt: now.subtract(const Duration(minutes: 30)),
        isCurrentUser: true,
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_amit',
        userName: 'Amit P.',
        userAvatar: '🏋️',
        score: 68500,
        metricUnit: 'steps',
        version: 1,
        lastUpdatedAt: now.subtract(const Duration(hours: 4)),
      ),
      LeaderboardEntry(
        rank: 0,
        userId: 'u_sneha',
        userName: 'Sneha M.',
        userAvatar: '🧘',
        score: 61200,
        metricUnit: 'steps',
        version: 1,
        lastUpdatedAt: now.subtract(const Duration(hours: 6)),
        isAnonymous: true,
      ),
    ];
  }

  /// Fetches computed rankings for a given timeframe and metric.
  List<LeaderboardEntry> getRankings({
    LeaderboardTimeframe timeframe = LeaderboardTimeframe.weekly,
    LeaderboardMetric metric = LeaderboardMetric.steps,
  }) {
    final computed = _engine.computeRankings(_rawWeeklyStepsEntries);

    if (_isAnonymousMode) {
      return computed.map((entry) {
        if (entry.isCurrentUser) return entry;
        return entry.copyWith(userName: 'Anonymous Athlete', isAnonymous: true);
      }).toList();
    }

    return computed;
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((_) {
  return LeaderboardRepository();
});
