/// §P9-A Social Screen UI
///
/// Route: /social
/// Dark bento layout matching §P9-A ASCII wireframe:
/// - Tab selection pills ([ My Squad ], [ Challenges ], [ Leaderboards ])
/// - Squad header card ("Noida Ground Shakers", streak "🔥 14 Days")
/// - Anonymized member readiness & recovery status list (🟩 High, 🟨 Moderate, 🟥 Low)
/// - Team average readiness summary
/// - Active squad mission card ("🎯 Team Protein Target", 78% Done)
/// - Action buttons ([ Nudge Member ], [ Propose Challenge ])
library;

import 'package:fitkarma/features/social/social_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  static const routeName = '/social';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialProvider);

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
          'Social & Squads',
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
            // 1. Tab Selector Pills
            _buildTabSelector(ref, state.selectedTabIndex),
            const SizedBox(height: 20),

            // Tab 0: My Squad View
            if (state.selectedTabIndex == 0) ...[
              // 2. Squad Header Banner
              _buildSquadHeaderCard(state),
              const SizedBox(height: 20),

              // 3. Member Readiness List Card
              _buildMemberReadinessCard(context, state),
              const SizedBox(height: 20),

              // 4. Active Squad Mission Card
              if (state.activeMission != null)
                _buildActiveMissionCard(state.activeMission!),
              const SizedBox(height: 24),

              // 5. Action Buttons Row
              _buildActionButtons(context),
            ] else if (state.selectedTabIndex == 1) ...[
              _buildPlaceholderCard('Squad Challenges', 'No active challenge right now. Propose a new challenge to your squad!'),
            ] else ...[
              _buildPlaceholderCard('Regional Leaderboards', 'Compete with top members in Noida and earn Karma XP!'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(WidgetRef ref, int selectedIndex) {
    final tabs = ['My Squad', 'Challenges', 'Leaderboards'];

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = index == selectedIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < tabs.length - 1 ? 8.0 : 0.0),
            child: GestureDetector(
              onTap: () => ref.read(socialProvider.notifier).selectTab(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.indigoAccent : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.indigoAccent : Colors.white10,
                  ),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSquadHeaderCard(SquadState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Squad: ${state.squadName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.members.length} Active Members',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade900.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orangeAccent),
            ),
            child: Text(
              'Streak: 🔥 ${state.collectiveStreakDays} Days',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberReadinessCard(BuildContext context, SquadState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Members Readiness & Recovery Status (Anonymized)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: state.members.map((m) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          m.readinessLevel.indicatorEmoji,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          m.isCurrentUser ? 'You (${m.name})' : m.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: m.isCurrentUser ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      m.readinessLevel.label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const Divider(color: Colors.white10, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Team Average Readiness:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              Text(
                '${state.averageReadinessScore.round()}%',
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveMissionCard(ActiveSquadMission mission) {
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
              Row(
                children: [
                  const Icon(Icons.track_changes, color: Colors.amberAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Active Squad Mission: ${mission.title}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${mission.percentCompleteInt}% Done',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Current Avg: ${mission.currentAverage.round()}g / member (Target: ${mission.targetPerMember.round()}g)',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: mission.percentComplete,
              minHeight: 8,
              backgroundColor: const Color(0xFF0F172A),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nudge sent to rest! 🔥')),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.white, size: 18),
            label: const Text('Nudge Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Challenge proposed to squad!')),
              );
            },
            icon: const Icon(Icons.add, color: Colors.amberAccent, size: 18),
            label: const Text('Propose Challenge'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.amberAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
