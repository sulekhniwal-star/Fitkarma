/// §P9-C Accountability Communities UI
///
/// Route: /communities
/// Dark glassmorphic layout displaying:
/// - Privacy guarantee banner
/// - Category filter tabs (All vs Joined)
/// - Community cards list with member count, target description, and Join / Joined toggle
/// - Activity feed drawer
library;

import 'package:fitkarma/features/social/community_models.dart';
import 'package:fitkarma/features/social/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  static const routeName = '/communities';

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  bool _showJoinedOnly = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(communityRepositoryProvider);
    final allCommunities = repo.communities;
    final displayedCommunities = _showJoinedOnly
        ? allCommunities.where((c) => c.isJoined).toList()
        : allCommunities;

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
          'Accountability Communities',
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
            // 1. Privacy Guarantee Banner
            _buildPrivacyBanner(),
            const SizedBox(height: 20),

            // 2. Filter Bar (All vs Joined)
            _buildFilterBar(),
            const SizedBox(height: 20),

            // 3. Communities List
            if (displayedCommunities.isEmpty)
              _buildEmptyState()
            else
              Column(
                children: displayedCommunities.map((group) {
                  return _buildCommunityCard(group);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade900.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.indigoAccent, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '🔒 Privacy Shield: No personal health data visible in communities — activity feeds only.',
              style: TextStyle(
                color: Colors.indigoAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        ChoiceChip(
          label: const Text('All Communities'),
          selected: !_showJoinedOnly,
          selectedColor: Colors.indigoAccent,
          backgroundColor: const Color(0xFF1E293B),
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: !_showJoinedOnly ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            if (selected) setState(() => _showJoinedOnly = false);
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Joined Only'),
          selected: _showJoinedOnly,
          selectedColor: Colors.indigoAccent,
          backgroundColor: const Color(0xFF1E293B),
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: _showJoinedOnly ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            if (selected) setState(() => _showJoinedOnly = true);
          },
        ),
      ],
    );
  }

  Widget _buildCommunityCard(CommunityGroup group) {
    final formattedMembers = group.memberCount
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: group.isJoined
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
                  Text(group.iconSymbol, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$formattedMembers Members',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    ref.read(communityRepositoryProvider).toggleMembership(group.id);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: group.isJoined
                      ? Colors.amber.shade900.withValues(alpha: 0.5)
                      : Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  group.isJoined ? 'Joined ✓' : 'Join',
                  style: TextStyle(
                    color: group.isJoined ? Colors.amberAccent : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            group.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
          if (group.activityPosts.isNotEmpty) ...[
            const Divider(color: Colors.white10, height: 24),
            _buildLatestPostSnippet(group),
          ],
        ],
      ),
    );
  }

  Widget _buildLatestPostSnippet(CommunityGroup group) {
    final post = group.activityPosts.first;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(post.avatarEmoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.authorName}: "${post.textContent}"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 14),
              const SizedBox(width: 4),
              Text(
                '${post.cheerCount}',
                style: const TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text(
            'No Joined Communities Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore "All Communities" above to join an accountability group!',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
