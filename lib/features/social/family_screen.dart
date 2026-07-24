/// §P9-D Family Health Hub UI Screen
///
/// Route: /family
/// Dark bento layout matching §P9-D ASCII wireframe:
/// - Household header banner ("The Sharma Family", familyUnitId badge)
/// - Family member bento cards (Dad, Mom, You, Daughter) displaying permission-gated metrics
/// - Family Alerts Card (Critical & Warning household notices)
/// - Action Bar (Add Member, Privacy Settings, Send Nudge)
library;

import 'package:fitkarma/features/social/family_models.dart';
import 'package:fitkarma/features/social/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  static const routeName = '/family';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(familyRepositoryProvider);
    final hubData = repo.hubData;
    final members = repo.permissionGatedMembers;

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
          'Family Health Hub',
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
            // 1. Household Header Banner
            _buildHouseholdHeader(hubData),
            const SizedBox(height: 20),

            // 2. Family Member Bento Cards
            Column(
              children: members.map((m) => _buildMemberCard(m)).toList(),
            ),
            const SizedBox(height: 20),

            // 3. Family Health Alerts Banner
            if (hubData.familyAlerts.isNotEmpty)
              _buildFamilyAlertsCard(hubData.familyAlerts),
            const SizedBox(height: 24),

            // 4. Household Action Bar
            _buildHouseholdActionBar(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseholdHeader(FamilyHubData hubData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.family_restroom, color: Colors.indigoAccent, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hubData.familyName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Unit ID: ${hubData.familyUnitId} (${hubData.members.length} / 6 Members)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.indigoAccent),
            ),
            child: const Text(
              'Household Tier',
              style: TextStyle(
                color: Colors.indigoAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(FamilyMemberProfile member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: member.isCurrentUser
              ? Colors.amberAccent.withValues(alpha: 0.4)
              : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(member.role.iconSymbol, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                    member.isCurrentUser ? '${member.name} (You)' : member.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (member.healthScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade900.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.tealAccent),
                  ),
                  child: Text(
                    'Score: ${member.healthScore}',
                    style: const TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (member.stepsToday != null)
                _buildMetricBadge('👟 Steps: ${member.stepsToday}'),
              if (member.sleepHours != null) ...[
                const SizedBox(width: 8),
                _buildMetricBadge('😴 Sleep: ${member.sleepHours}h'),
              ],
              if (member.weightKg != null) ...[
                const SizedBox(width: 8),
                _buildMetricBadge('⚖️ ${member.weightKg}kg'),
              ] else if (!member.isCurrentUser) ...[
                const SizedBox(width: 8),
                _buildMetricBadge('🔒 Weight Hidden'),
              ],
            ],
          ),
          if (member.riskWatch != null) ...[
            const SizedBox(height: 8),
            Text(
              'Watch: ${member.riskWatch}',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFamilyAlertsCard(List<FamilyAlert> alerts) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 22),
              SizedBox(width: 8),
              Text(
                'Family Health Alerts',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: alerts.map((a) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(a.severity.indicatorEmoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        a.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdActionBar(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support nudge sent to family! 💪')),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.black, size: 18),
            label: const Text('Send Family Nudge'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
