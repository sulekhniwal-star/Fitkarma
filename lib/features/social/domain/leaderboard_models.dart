import 'package:flutter/foundation.dart';

/// Time horizon for leaderboard ranking
enum LeaderboardTimeframe {
  weekly(
    label: 'Weekly Sprint (Saptahik)',
    regionalLabel: 'साप्ताहिक श्रेष्ठता',
    description: 'Resets every Monday 00:00 IST',
  ),
  monthly(
    label: 'Monthly Endurance (Masik)',
    regionalLabel: 'मासिक साधना',
    description: 'Cumulative 30-day endurance cycle',
  ),
  allTime(
    label: 'Hall of Fame (Sthirata)',
    regionalLabel: 'सर्वकालिक अमर साधक',
    description: 'Lifetime Karma milestones',
  );

  final String label;
  final String regionalLabel;
  final String description;

  const LeaderboardTimeframe({
    required this.label,
    required this.regionalLabel,
    required this.description,
  });
}

/// Discipline pillar for leaderboard sorting
enum LeaderboardCategory {
  karmaVelocity(
    label: 'Overall Karma Velocity',
    regionalLabel: 'समग्र कर्म अर्जन',
    unit: 'Karma',
    iconName: 'auto_awesome',
  ),
  shatpawaliConsistency(
    label: 'Shatpawali Compliance',
    regionalLabel: 'शतपावली निरंतरता',
    unit: '% meals',
    iconName: 'directions_walk',
  ),
  adherenceStreak(
    label: 'Habit Streak Longevity',
    regionalLabel: 'साधना निरंतरता दिवस',
    unit: 'days',
    iconName: 'local_fire_department',
  ),
  relativeStrength(
    label: 'Relative Strength Tonnage',
    regionalLabel: 'सापेक्ष शक्ति व भार',
    unit: 'kg volume',
    iconName: 'fitness_center',
  );

  final String label;
  final String regionalLabel;
  final String unit;
  final String iconName;

  const LeaderboardCategory({
    required this.label,
    required this.regionalLabel,
    required this.unit,
    required this.iconName,
  });
}

/// Geographic / Community scope of the leaderboard
enum LeaderboardScope {
  national(
    label: 'National (Pan-India)',
    regionalLabel: 'अखिल भारतीय',
  ),
  cityTier(
    label: 'City Tier Peers',
    regionalLabel: 'समान शहर वर्ग',
  ),
  squadsOnly(
    label: 'Squads Leaderboard',
    regionalLabel: 'दल श्रेष्ठता',
  );

  final String label;
  final String regionalLabel;

  const LeaderboardScope({
    required this.label,
    required this.regionalLabel,
  });
}

/// Individual entry on the leaderboard
@immutable
class LeaderboardEntry {
  final int rank;
  final String athleteId;
  final String athleteName;
  final String avatarInitials;
  final String karmaTierTitle;
  final String cityLocation;
  final double scoreValue;
  final String scoreUnit;
  final int activeStreakDays;
  final bool isCurrentUser;
  final int kudosReceived;

  const LeaderboardEntry({
    required this.rank,
    required this.athleteId,
    required this.athleteName,
    required this.avatarInitials,
    required this.karmaTierTitle,
    required this.cityLocation,
    required this.scoreValue,
    required this.scoreUnit,
    required this.activeStreakDays,
    required this.isCurrentUser,
    required this.kudosReceived,
  });
}

/// State container for Leaderboard screen
@immutable
class LeaderboardReportState {
  final LeaderboardTimeframe selectedTimeframe;
  final LeaderboardCategory selectedCategory;
  final LeaderboardScope selectedScope;
  final LeaderboardEntry userEntry;
  final double userPercentile; // e.g. Top 4%
  final List<LeaderboardEntry> podiumEntries; // Rank 1, 2, 3
  final List<LeaderboardEntry> allRankings;
  final int totalAthletesInPool;

  const LeaderboardReportState({
    required this.selectedTimeframe,
    required this.selectedCategory,
    required this.selectedScope,
    required this.userEntry,
    required this.userPercentile,
    required this.podiumEntries,
    required this.allRankings,
    required this.totalAthletesInPool,
  });

  LeaderboardReportState copyWith({
    LeaderboardTimeframe? selectedTimeframe,
    LeaderboardCategory? selectedCategory,
    LeaderboardScope? selectedScope,
    LeaderboardEntry? userEntry,
    double? userPercentile,
    List<LeaderboardEntry>? podiumEntries,
    List<LeaderboardEntry>? allRankings,
    int? totalAthletesInPool,
  }) {
    return LeaderboardReportState(
      selectedTimeframe: selectedTimeframe ?? this.selectedTimeframe,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedScope: selectedScope ?? this.selectedScope,
      userEntry: userEntry ?? this.userEntry,
      userPercentile: userPercentile ?? this.userPercentile,
      podiumEntries: podiumEntries ?? this.podiumEntries,
      allRankings: allRankings ?? this.allRankings,
      totalAthletesInPool: totalAthletesInPool ?? this.totalAthletesInPool,
    );
  }
}
