/// §P9-E Activity Feed UI Screen
///
/// Route: /feed
/// Dark glassmorphic layout displaying curated activity feed items:
/// - Curation filter tabs (All Activity, Workouts, Routes, Milestones)
/// - 🏋️ Workout Summary Card (Duration, Active Calories, Form Score)
/// - 🗺️ GPS Route Sharing Card (Map track summary, Distance, Elevation, Pace)
/// - 📈 Transformation Card (Shielded metrics: Weight delta, streak days)
/// - 🏆 Milestone Card (Level-Up badge)
/// - Spring-loaded High-Five reaction button (🙌 High-Five +2 XP)
library;

import 'package:fitkarma/features/social/feed_models.dart';
import 'package:fitkarma/features/social/feed_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityFeedScreen extends ConsumerStatefulWidget {
  const ActivityFeedScreen({super.key});

  static const routeName = '/feed';

  @override
  ConsumerState<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends ConsumerState<ActivityFeedScreen> {
  FeedItemType? _selectedTypeFilter;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(feedRepositoryProvider);
    final feedItems = repo.getPaginatedFeed(typeFilter: _selectedTypeFilter);

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
          'Activity Feed',
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
            // 1. Curation Filter Bar
            _buildTypeFilterBar(),
            const SizedBox(height: 20),

            // 2. Feed Timeline
            if (feedItems.isEmpty)
              _buildEmptyFeedState()
            else
              Column(
                children: feedItems.map((item) {
                  return _buildFeedCard(item);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All Activity', null),
          const SizedBox(width: 8),
          _buildFilterChip('Workouts 🏋️', FeedItemType.workout),
          const SizedBox(width: 8),
          _buildFilterChip('Routes 🗺️', FeedItemType.routeShare),
          const SizedBox(width: 8),
          _buildFilterChip('Milestones 🏆', FeedItemType.milestone),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, FeedItemType? type) {
    final isSelected = _selectedTypeFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.indigoAccent,
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        color: Colors.white,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedTypeFilter = type);
        }
      },
    );
  }

  Widget _buildFeedCard(FeedItem item) {
    final isHighFived = item.highFivedUserIds.contains('user_me');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Author Name, Time
          Row(
            children: [
              Text(item.userAvatar ?? '👤', style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimestamp(item.timestamp),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Payload Body Card
          if (item.type == FeedItemType.workout && item.workoutPayload != null)
            _buildWorkoutCard(item.workoutPayload!),
          if (item.type == FeedItemType.routeShare && item.routePayload != null)
            _buildRouteCard(item.routePayload!),
          if (item.type == FeedItemType.transformation && item.transformationPayload != null)
            _buildTransformationCard(item.transformationPayload!),
          if (item.type == FeedItemType.milestone && item.milestonePayload != null)
            _buildMilestoneCard(item.milestonePayload!),

          const SizedBox(height: 14),

          // Reaction Footer: High-Five Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    ref.read(feedRepositoryProvider).toggleHighFive(item.localId, 'user_me');
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHighFived
                        ? Colors.amber.shade900.withValues(alpha: 0.5)
                        : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHighFived ? Colors.amberAccent : Colors.white10,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('🙌', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        'High-Five (${item.highFiveCount})',
                        style: TextStyle(
                          color: isHighFived ? Colors.amberAccent : Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '+2 XP',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '🔒 ${item.privacy.name}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutPayload payload) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏋️ ${payload.exerciseName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.teal.shade900.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Form Score: ${payload.formQualityScore}%',
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Duration: ${payload.durationMinutes} mins  ·  Calories: ${payload.caloriesBurned} kcal',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(GPSRouteSummary payload) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🗺️ ${payload.routeName}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Distance: ${payload.distanceKm} km', style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
              Text('Pace: ${payload.averagePace}', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
              Text('Elev: ${payload.elevationGainM.round()}m', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransformationCard(TransformationPayload payload) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 Transformation Milestone Achieved!',
            style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Weight Delta: ${payload.weightDeltaKg} kg  ·  Consistency Streak: 🔥 ${payload.streakDays} Days',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(MilestonePayload payload) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏆 ${payload.milestoneTitle}',
            style: const TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Earned +${payload.xpEarned} Karma XP  ·  Streak: 🔥 ${payload.streakDays} Days',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeedState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          'No activity posts in this filter yet.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
