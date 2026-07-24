/// §P9-F Local Geolocation Clubs UI Screen
///
/// Route: /clubs
/// Dark glassmorphic layout displaying nearby clubs and interest circles:
/// - Filter bar (Near Me [10km], My City, Interest Circles)
/// - Micro-location distance badges (📍 Noida Sector 62 · 0.0 km away)
/// - Group metrics (Member count, Team avg adherence score, Weekly steps)
/// - Interactive Join Club / Joined ✓ toggle buttons
library;

import 'package:fitkarma/features/social/club_engine.dart';
import 'package:fitkarma/features/social/club_models.dart';
import 'package:fitkarma/features/social/club_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubScreen extends ConsumerStatefulWidget {
  const ClubScreen({super.key});

  static const routeName = '/clubs';

  @override
  ConsumerState<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends ConsumerState<ClubScreen> {
  int _selectedFilterIndex = 0; // 0 = Near Me, 1 = My City, 2 = Interest Circles
  final constEngine = const ClubEngine();

  // Default user location: Noida Sector 62 (28.6280, 77.3649)
  final double _userLat = 28.6280;
  final double _userLon = 77.3649;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(clubRepositoryProvider);
    final allClubs = repo.clubs;

    List<HealthClub> displayedClubs;
    if (_selectedFilterIndex == 0) {
      displayedClubs = repo.getNearbyClubs(userLat: _userLat, userLon: _userLon, radiusKm: 15.0);
    } else if (_selectedFilterIndex == 1) {
      displayedClubs = allClubs.where((c) => c.type == ClubType.geolocation).toList();
    } else {
      displayedClubs = allClubs.where((c) => c.type == ClubType.interestCircle).toList();
    }

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
          'Clubs & Circles',
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
            // 1. Filter Bar
            _buildFilterBar(),
            const SizedBox(height: 20),

            // 2. Clubs List
            if (displayedClubs.isEmpty)
              _buildEmptyState()
            else
              Column(
                children: displayedClubs.map((club) {
                  return _buildClubCard(club);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['Near Me (15 km)', 'My City', 'Interest Circles'];

    return Row(
      children: List.generate(filters.length, (index) {
        final isSelected = index == _selectedFilterIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < filters.length - 1 ? 8.0 : 0.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
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
                    filters[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

  Widget _buildClubCard(HealthClub club) {
    final distance = constEngine.computeDistanceKm(_userLat, _userLon, club.latitude, club.longitude);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: club.isJoined
              ? Colors.tealAccent.withValues(alpha: 0.4)
              : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.tealAccent, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        club.type == ClubType.geolocation
                            ? '${club.microLocation ?? club.city} · $distance km away'
                            : '${club.city} · Interest Circle',
                        style: TextStyle(
                          color: Colors.tealAccent.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    ref.read(clubRepositoryProvider).toggleMembership(club.clubId, 'user_me');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: club.isJoined
                      ? Colors.teal.shade900.withValues(alpha: 0.5)
                      : Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  club.isJoined ? 'Joined ✓' : 'Join Club',
                  style: TextStyle(
                    color: club.isJoined ? Colors.tealAccent : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            club.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricPill('👥 ${club.aggregateMetrics.memberCount} Members'),
              _buildMetricPill('🔥 Adherence: ${club.aggregateMetrics.averageAdherenceScore.round()}%'),
              _buildMetricPill('🎯 ${club.aggregateMetrics.activeSquadMissionsCount} Missions'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
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
      child: Center(
        child: Text(
          'No clubs found in this filter area.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
        ),
      ),
    );
  }
}
