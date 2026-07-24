/// §P9-B Squad Details Screen UI
///
/// Route: /squad-details
/// Displays squad header, collective streak counter, challenge eligibility banner,
/// active mission progress, and member roster with nudge actions.
library;

import 'package:fitkarma/features/social/squad_engine.dart';
import 'package:fitkarma/features/social/squad_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SquadDetailsScreen extends ConsumerWidget {
  const SquadDetailsScreen({super.key});

  static const routeName = '/squad-details';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(squadRepositoryProvider);
    final squad = repo.squad;
    final members = repo.members;
    final mission = repo.activeMission;
    final avgReadiness = repo.averageReadiness;
    final isEligible = repo.isChallengeEligible;

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
          'Squad Management',
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
            // 1. Squad Header Banner
            _buildSquadHeaderCard(squad, avgReadiness),
            const SizedBox(height: 16),

            // 2. Challenge Eligibility Banner (§P9-B >= 60% High readiness requirement)
            _buildEligibilityBanner(isEligible),
            const SizedBox(height: 20),

            // 3. Active Squad Mission Progress Card
            _buildMissionCard(mission),
            const SizedBox(height: 24),

            // 4. Member Roster Section
            const Text(
              'Squad Member Roster',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMemberRoster(context, ref, members),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadHeaderCard(SquadGroup squad, double avgReadiness) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                squad.squadName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade900.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orangeAccent),
                ),
                child: Text(
                  '🔥 ${squad.collectiveStreakDays} Days Streak',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.tealAccent, size: 18),
              const SizedBox(width: 6),
              Text(
                'Team Average Readiness: ${avgReadiness.round()}%',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityBanner(bool isEligible) {
    final color = isEligible ? Colors.greenAccent : Colors.amberAccent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isEligible
            ? Colors.green.shade900.withValues(alpha: 0.3)
            : Colors.amber.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            isEligible ? Icons.emoji_events : Icons.lock_clock,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEligible
                  ? '🎯 Challenge Eligible! Over 60% of squad members are in High Readiness.'
                  : '⚠️ Challenges Locked: Need at least 60% of members in High Readiness to unlock team challenges.',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(SquadMissionData mission) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🎯 ${mission.title}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(mission.progressPercent * 100).round()}% Completed',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            mission.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: mission.progressPercent,
              minHeight: 10,
              backgroundColor: const Color(0xFF0F172A),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberRoster(
      BuildContext context, WidgetRef ref, List<SquadMemberItem> members) {
    return Column(
      children: members.map((m) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    m.readinessTier.indicatorEmoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.isCurrentUser ? '${m.name} (You)' : m.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: m.isCurrentUser ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Readiness: ${m.readinessScore.round()}% (${m.readinessTier.displayName})',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!m.isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.indigoAccent),
                  onPressed: () {
                    ref.read(squadRepositoryProvider).sendNudge(m.userId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nudge sent to ${m.name}! 🔥')),
                    );
                  },
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
