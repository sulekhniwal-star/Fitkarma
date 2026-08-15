import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/accountability_communities_engine.dart';

final communitiesListProvider = StateProvider<List<CommunityInfo>>((ref) {
  const engine = AccountabilityCommunitiesEngine();
  return engine.getAvailableCommunities();
});

final communityPostsProvider =
    StateProvider<List<CommunityActivityPost>>((ref) {
  return const [
    CommunityActivityPost(
      id: 'post_1',
      communityId: 'comm_10k',
      authorName: 'Vikram R.',
      activityTitle:
          'Logged 11,400 steps on morning walk in Lodhi Garden! 🏃‍♂️',
      timeAgo: '15m ago',
      cheerCount: 14,
    ),
    CommunityActivityPost(
      id: 'post_2',
      communityId: 'comm_office',
      authorName: 'Ananya M.',
      activityTitle:
          'Hit 100g protein target today with Soya Chunks + Paneer lunch! 💪',
      timeAgo: '45m ago',
      cheerCount: 8,
    ),
    CommunityActivityPost(
      id: 'post_3',
      communityId: 'comm_veg',
      authorName: 'Karan T.',
      activityTitle: 'Completed Athletic Lean Build Day 12 workout! 🔥',
      timeAgo: '2h ago',
      cheerCount: 22,
    ),
  ];
});

/// §P9-C Communities Screen
/// Route: /communities
class CommunitiesScreen extends ConsumerWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communities = ref.watch(communitiesListProvider);
    final posts = ref.watch(communityPostsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Accountability Communities', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Guarantee Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.privacy_tip,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Zero personal health data visible in communities — activity & milestone feeds only.',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.primary, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Communities Grid (2 Columns)
              Text('Explore Communities (${communities.length})',
                  style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: communities.length,
                itemBuilder: (context, index) {
                  final comm = communities[index];
                  return BentoCard(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(comm.iconEmoji,
                                style: const TextStyle(fontSize: 24)),
                            GestureDetector(
                              onTap: () {
                                final updated = [...communities];
                                updated[index] =
                                    comm.copyWith(isJoined: !comm.isJoined);
                                ref
                                    .read(communitiesListProvider.notifier)
                                    .state = updated;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: comm.isJoined
                                      ? AppColors.success.withValues(alpha: 0.2)
                                      : AppColors.primary
                                          .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  comm.isJoined ? 'Joined' : '+ Join',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: comm.isJoined
                                        ? AppColors.success
                                        : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(comm.title,
                            style: AppTypography.labelLg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(comm.targetAudience,
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.textSecondary, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Text('${comm.memberCount} members',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Activity Feed Section
              Text('Community Activity Feed', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Column(
                children: [
                  for (int i = 0; i < posts.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.2),
                              child: Text(posts[i].authorName.substring(0, 1),
                                  style: AppTypography.labelLg
                                      .copyWith(color: AppColors.primary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(posts[i].authorName,
                                          style: AppTypography.labelLg),
                                      Text(posts[i].timeAgo,
                                          style: AppTypography.bodySm.copyWith(
                                              color: AppColors.textMuted,
                                              fontSize: 11)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(posts[i].activityTitle,
                                      style: AppTypography.bodySm.copyWith(
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                posts[i].isCheered
                                    ? Icons.local_fire_department
                                    : Icons.local_fire_department_outlined,
                                color: posts[i].isCheered
                                    ? AppColors.warning
                                    : AppColors.textMuted,
                              ),
                              onPressed: () {
                                final updated = [...posts];
                                final current = posts[i];
                                updated[i] = current.copyWith(
                                  cheerCount: current.isCheered
                                      ? current.cheerCount - 1
                                      : current.cheerCount + 1,
                                  isCheered: !current.isCheered,
                                );
                                ref
                                    .read(communityPostsProvider.notifier)
                                    .state = updated;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
