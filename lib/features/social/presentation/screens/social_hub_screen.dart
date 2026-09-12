import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/bilingual_label.dart';
import '../../data/social_repository.dart';
import '../../domain/models/social_models.dart';
import 'squad_detail_screen.dart';
import 'family_health_hub_screen.dart';

class SocialHubScreen extends ConsumerStatefulWidget {
  final String userId;
  final SocialRepository? repository;

  const SocialHubScreen({
    super.key,
    this.userId = 'demo-user-001',
    this.repository,
  });

  @override
  ConsumerState<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends ConsumerState<SocialHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: BilingualLabel(
          english: 'Social & Sangha Hub',
          hindi: 'सामाजिक व संघ केंद्र',
          primaryStyle: AppTypography.h3,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryCyan,
          labelColor: AppColors.primaryCyan,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: AppTypography.label.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.people_alt_rounded, size: 18), text: 'Squads'),
            Tab(icon: Icon(Icons.family_restroom_rounded, size: 18), text: 'Family'),
            Tab(icon: Icon(Icons.dynamic_feed_rounded, size: 18), text: 'Feed'),
            Tab(icon: Icon(Icons.emoji_events_rounded, size: 18), text: 'Clubs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSquadsTab(),
          _buildFamilyTab(),
          _buildFeedTab(),
          _buildClubsTab(),
        ],
      ),
    );
  }

  Widget _buildSquadsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Squad Hero Card
          BentoCard(
            isGlowing: true,
            glowColor: AppColors.primaryCyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vayu Warriors (4/5 Active)', style: AppTypography.h3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryEmerald.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('14d Streak 🔥', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Daily commitment: 10k steps + Indian high-protein lunch.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.80,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceCard,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryCyan),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SquadDetailScreen(
                            squad: const Squad(
                              id: 'sq-1',
                              name: 'Vayu Warriors',
                              bio: 'Early morning lifters & runners',
                              streakDays: 14,
                              totalKarma: 1450,
                              members: [
                                SquadMember(
                                  id: 'm1',
                                  squadId: 'sq-1',
                                  userId: 'demo-user-001',
                                  displayName: 'Aarav (You)',
                                  role: SquadRole.leader,
                                  todayLogged: true,
                                  todayKarma: 50,
                                  todayCommitment: 'Push day completed at 7 AM',
                                ),
                                SquadMember(
                                  id: 'm2',
                                  squadId: 'sq-1',
                                  userId: 'user-002',
                                  displayName: 'Priya S.',
                                  role: SquadRole.member,
                                  todayLogged: true,
                                  todayKarma: 40,
                                  todayCommitment: '8.5k steps + Lentil salad',
                                ),
                                SquadMember(
                                  id: 'm3',
                                  squadId: 'sq-1',
                                  userId: 'user-003',
                                  displayName: 'Rohan K.',
                                  role: SquadRole.member,
                                  todayLogged: false,
                                  todayKarma: 0,
                                  todayCommitment: 'Leg session pending',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Open Squad Room & Nudge', style: AppTypography.label.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),
          Text('Suggested Accountability Squads', style: AppTypography.h3),
          const SizedBox(height: 12),
          _buildSquadSuggestionCard('Bangalore Calisthenics Tribe', '4/5 members', 'Strength & Desi Dand', '12d Streak'),
          const SizedBox(height: 8),
          _buildSquadSuggestionCard('Desi Keto & Fasting Circle', '3/5 members', 'Intermittent Fasting & Low Carb', '21d Streak'),
        ],
      ),
    );
  }

  Widget _buildSquadSuggestionCard(String name, String members, String focus, String streak) {
    return BentoCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('$focus • $members', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryCyan),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: Text('Join', style: AppTypography.label.copyWith(color: AppColors.primaryCyan)),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyTab() {
    return const FamilyHealthHubScreen();
  }

  Widget _buildFeedTab() {
    final posts = [
      SocialActivityPost(
        id: 'p1',
        userId: 'u1',
        authorName: 'Vikram Mehta',
        activityType: ActivityType.workoutCompleted,
        title: 'Crushed 50 Desi Dands & 100 Hindu Squats!',
        description: 'Feeling high energy. Morning Ayurvedic kadha worked wonders.',
        karmaEarned: 60,
        likesCount: 14,
        cheersCount: 8,
        createdAt: DateTime(2026, 9, 12, 8, 30),
      ),
      SocialActivityPost(
        id: 'p2',
        userId: 'u2',
        authorName: 'Ananya Sharma',
        activityType: ActivityType.mealLogged,
        title: 'High Protein Palak Paneer & Quinoa Bowl',
        description: '42g protein, 520 kcal. Quality score: 92/100.',
        karmaEarned: 25,
        likesCount: 22,
        cheersCount: 12,
        createdAt: DateTime(2026, 9, 12, 13, 15),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = posts[index];
        return BentoCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryCyan.withAlpha(40),
                    child: Text(post.authorName.substring(0, 1), style: const TextStyle(color: AppColors.primaryCyan)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text('Today • Earned +${post.karmaEarned} Karma', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(post.title, style: AppTypography.h3.copyWith(fontSize: 16)),
              if (post.description != null) ...[
                const SizedBox(height: 4),
                Text(post.description!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.accentCoral, size: 20),
                    onPressed: () {},
                  ),
                  Text('${post.likesCount}', style: AppTypography.bodySmall),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.celebration_outlined, color: AppColors.primaryCyan, size: 20),
                    onPressed: () {},
                  ),
                  Text('${post.cheersCount} Cheers', style: AppTypography.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClubsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Local Geolocation Clubs', style: AppTypography.h3),
          const SizedBox(height: 12),
          _buildClubCard(
            name: 'Indiranagar Morning Runners',
            city: 'Bengaluru',
            type: 'Running & 10k Training',
            members: 142,
            meetup: 'Saturday 06:00 AM @ Defence Colony Park',
          ),
          const SizedBox(height: 12),
          _buildClubCard(
            name: 'Lodhi Garden Desi Akhada',
            city: 'Delhi NCR',
            type: 'Bodyweight & Calisthenics',
            members: 210,
            meetup: 'Sunday 06:30 AM @ Athpula Bridge',
          ),
          const SizedBox(height: 20),
          Text('City Leaderboard (Top Yogis)', style: AppTypography.h3),
          const SizedBox(height: 12),
          _buildLeaderboardRow(1, 'Aarav Nair', '2,850 pts', '👑 Golden Yogi (#1)', true),
          _buildLeaderboardRow(2, 'Rohit Sharma', '2,640 pts', '⚡ Podium Elite', false),
          _buildLeaderboardRow(3, 'Neha Sen', '2,510 pts', '⚡ Podium Elite', false),
          _buildLeaderboardRow(4, 'Kunal Kapoor', '2,320 pts', '🔥 Top 10 Champion', false),
        ],
      ),
    );
  }

  Widget _buildClubCard({
    required String name,
    required String city,
    required String type,
    required int members,
    required String meetup,
  }) {
    return BentoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primaryCyan.withAlpha(20), borderRadius: BorderRadius.circular(6)),
                child: Text(city, style: AppTypography.label.copyWith(color: AppColors.primaryCyan, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('$type • $members Active Yogis', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.accentAmber),
              const SizedBox(width: 4),
              Expanded(child: Text(meetup, style: AppTypography.bodySmall.copyWith(color: AppColors.accentAmber, fontSize: 11))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(int rank, String name, String pts, String badge, bool isSelf) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: BentoCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Text('#$rank', style: AppTypography.h3.copyWith(color: rank == 1 ? AppColors.accentAmber : AppColors.textSecondary)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name + (isSelf ? ' (You)' : ''), style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: isSelf ? AppColors.primaryCyan : AppColors.textPrimary)),
                  Text(badge, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.primaryEmerald)),
                ],
              ),
            ),
            Text(pts, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
