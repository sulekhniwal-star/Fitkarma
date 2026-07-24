/// §P9-G Weekly & Monthly Leaderboards UI Screen
///
/// Route: /leaderboard
/// Dark glassmorphic layout matching §P9-G ASCII wireframe:
/// - Region header banner ("🏆 Noida Sector 62 Leaderboard")
/// - Timeframe (Weekly vs Monthly) & Metric selector (Steps, Active Mins, Adherence)
/// - Top 3 Podium row (🥇 Gold, 🥈 Silver, 🥉 Bronze with +100 XP aura highlights)
/// - Full Rankings List
/// - Leaderboard Anonymity Mode toggle switch
library;

import 'package:fitkarma/features/social/leaderboard_models.dart';
import 'package:fitkarma/features/social/leaderboard_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  static const routeName = '/leaderboard';

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  LeaderboardTimeframe _selectedTimeframe = LeaderboardTimeframe.weekly;
  LeaderboardMetric _selectedMetric = LeaderboardMetric.steps;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(leaderboardRepositoryProvider);
    final rankings = repo.getRankings(
      timeframe: _selectedTimeframe,
      metric: _selectedMetric,
    );

    final top3 = rankings.take(3).toList();
    final remainingRankings = rankings.skip(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Leaderboards',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Region Header Banner
            _buildRegionHeader(),
            const SizedBox(height: 16),

            // 2. Anonymity Toggle Switch Bar
            _buildAnonymityToggleBar(repo),
            const SizedBox(height: 20),

            // 3. Timeframe & Metric Selector
            _buildSelectorControls(),
            const SizedBox(height: 24),

            // 4. Top 3 Podium Row
            if (top3.isNotEmpty) _buildPodiumRow(top3),
            const SizedBox(height: 24),

            // 5. Full Rankings List
            const Text(
              'Cohort Rankings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: remainingRankings.map((entry) {
                return _buildRankRow(entry);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_events, color: Colors.amberAccent, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🏆 Noida Sector 62 Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Top 10% unlocks Golden Karma Aura & +100 XP',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymityToggleBar(LeaderboardRepository repo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.visibility_off, color: Colors.indigoAccent, size: 20),
              SizedBox(width: 10),
              Text(
                'Leaderboard Anonymity Mode',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Switch(
            value: repo.isAnonymousMode,
            activeThumbColor: Colors.indigoAccent,
            onChanged: (val) {
              setState(() {
                repo.toggleAnonymousMode();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorControls() {
    return Column(
      children: [
        // Timeframe Selector
        Row(
          children: [
            Expanded(
              child: _buildTimeframeChip('Weekly', LeaderboardTimeframe.weekly),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTimeframeChip('Monthly', LeaderboardTimeframe.monthly),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Metric Selector
        Row(
          children: LeaderboardMetric.values.map((metric) {
            final isSelected = _selectedMetric == metric;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMetric = metric),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.indigoAccent : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${metric.iconSymbol} ${metric.displayName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeframeChip(String label, LeaderboardTimeframe timeframe) {
    final isSelected = _selectedTimeframe == timeframe;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeframe = timeframe),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigoAccent : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumRow(List<LeaderboardEntry> top3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (top3.length >= 2) _buildPodiumCard(top3[1], 2, Colors.blueGrey),
        if (top3.isNotEmpty) _buildPodiumCard(top3[0], 1, Colors.amberAccent),
        if (top3.length >= 3) _buildPodiumCard(top3[2], 3, Colors.deepOrangeAccent),
      ],
    );
  }

  Widget _buildPodiumCard(LeaderboardEntry entry, int position, Color accentColor) {
    final isFirst = position == 1;

    return Container(
      width: isFirst ? 110 : 95,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor, width: isFirst ? 2 : 1),
      ),
      child: Column(
        children: [
          Text(
            position == 1 ? '🥇' : (position == 2 ? '🥈' : '🥉'),
            style: TextStyle(fontSize: isFirst ? 28 : 22),
          ),
          const SizedBox(height: 6),
          Text(
            entry.userName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatScore(entry.score)} ${entry.metricUnit}',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankRow(LeaderboardEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isCurrentUser
              ? Colors.amberAccent.withValues(alpha: 0.5)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '${entry.rank}.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Text(entry.userAvatar, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.userName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
          if (entry.badge != null) ...[
            Text(entry.badge!.iconSymbol, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
          ],
          Text(
            '${_formatScore(entry.score)} ${entry.metricUnit}',
            style: const TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(double score) {
    if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}k';
    }
    return score.round().toString();
  }
}
