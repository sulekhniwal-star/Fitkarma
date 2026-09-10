import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/leaderboard_engine.dart';
import '../domain/leaderboard_models.dart';
import 'providers/leaderboard_provider.dart';

/// Screen displaying Weekly/Monthly Shreshthata Leaderboards, Podium, and Percentile Ranks
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardProvider);
    final user = state.userEntry;
    final pointsToNext = LeaderboardEngine.calculatePointsToNextRank(
      userEntry: user,
      allEntries: state.allRankings,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Shreshthata Leaderboards',
          regionalText: 'साधना श्रेष्ठता सूची',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showLeaderboardPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Timeframe Switcher Tabs (Weekly, Monthly, All-Time)
            _buildTimeframeSelector(ref, state.selectedTimeframe),
            const SizedBox(height: AppSpacing.md),

            // 2. Category Filter Chips
            _buildCategorySelector(ref, state.selectedCategory),
            const SizedBox(height: AppSpacing.md),

            // 3. Podium Bento Card (Top 3 Shreshthas)
            _buildPodiumBentoCard(state.podiumEntries),
            const SizedBox(height: AppSpacing.md),

            // 4. User's Sticky Rank Hero Card
            _buildUserRankCard(user, state.userPercentile, pointsToNext),
            const SizedBox(height: AppSpacing.md),

            // 5. Section Header
            BilingualLabel(
              primaryText:
                  'National Rankings (${state.totalAthletesInPool} Athletes)',
              regionalText: 'राष्ट्रीय श्रेष्ठता क्रम',
            ),
            const SizedBox(height: AppSpacing.sm),

            // 6. Leaderboard Rankings List
            ...state.allRankings.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildRankRowCard(context, ref, entry),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeSelector(WidgetRef ref, LeaderboardTimeframe selected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: LeaderboardTimeframe.values.map((tf) {
          final isSelected = tf == selected;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(
                tf.label.split('(')[0].trim(),
                style: AppTypography.metricLabel.copyWith(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.karmaGreen,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (val) {
                if (val) {
                  ref.read(leaderboardProvider.notifier).switchTimeframe(tf);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategorySelector(WidgetRef ref, LeaderboardCategory selected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: LeaderboardCategory.values.map((cat) {
          final isSelected = cat == selected;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(
                cat.label,
                style: AppTypography.metricLabel.copyWith(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.focusBlue,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (val) {
                if (val) {
                  ref.read(leaderboardProvider.notifier).switchCategory(cat);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPodiumBentoCard(List<LeaderboardEntry> podium) {
    if (podium.length < 3) return const SizedBox.shrink();

    final rank1 = podium[0];
    final rank2 = podium[1];
    final rank3 = podium[2];

    return BentoCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium,
                  color: AppColors.gold, size: 20),
              const SizedBox(width: 6),
              Text(
                'Weekly Sadhana Podium',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rank 2 (Silver)
              _buildPodiumColumn(rank2, 2, const Color(0xFFC0C0C0), 90),

              // Rank 1 (Gold)
              _buildPodiumColumn(rank1, 1, AppColors.gold, 115),

              // Rank 3 (Bronze)
              _buildPodiumColumn(rank3, 3, const Color(0xFFCD7F32), 75),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn(LeaderboardEntry entry, int rank, Color medalColor,
      double pedestalHeight) {
    return Column(
      children: [
        // Crown / Rank Icon
        Text(
          rank == 1
              ? '👑'
              : rank == 2
                  ? '🥈'
                  : '🥉',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: rank == 1 ? 24 : 20,
          backgroundColor: medalColor.withValues(alpha: 0.2),
          child: Text(
            entry.avatarInitials,
            style: AppTypography.titleSmall.copyWith(
              color: medalColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          entry.athleteName.split(' ')[0],
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${entry.scoreValue.toInt()} ${entry.scoreUnit}',
          style: AppTypography.metricLabel
              .copyWith(color: medalColor, fontSize: 10),
        ),
        const SizedBox(height: 6),

        // Pedestal
        Container(
          width: 75,
          height: pedestalHeight,
          decoration: BoxDecoration(
            color: medalColor.withValues(alpha: 0.12),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: medalColor.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: AppTypography.titleLarge.copyWith(
                color: medalColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserRankCard(
      LeaderboardEntry user, double percentile, double pointsToNext) {
    return BentoCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.karmaGreen.withValues(alpha: 0.2),
                        borderRadius: AppRadii.radiusFull,
                      ),
                      child: Text(
                        'Your Current Rank',
                        style: AppTypography.metricLabel.copyWith(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '#${user.rank}',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.scoreValue.toInt()} ${user.scoreUnit} • ${user.activeStreakDays}d streak',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                if (pointsToNext > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '+${pointsToNext.toInt()} ${user.scoreUnit} to reach #${user.rank - 1}',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.gold, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          GlowingMetric(
            value:
                'Top ${(100 - percentile).clamp(0.1, 99.0).toStringAsFixed(1)}%',
            label: 'National Decile',
            accentColor: AppColors.karmaGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildRankRowCard(
      BuildContext context, WidgetRef ref, LeaderboardEntry entry) {
    final isSelf = entry.isCurrentUser;
    final isTop3 = entry.rank <= 3;
    final rankColor = entry.rank == 1
        ? AppColors.gold
        : entry.rank == 2
            ? const Color(0xFFC0C0C0)
            : entry.rank == 3
                ? const Color(0xFFCD7F32)
                : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isSelf
            ? AppColors.karmaGreen.withValues(alpha: 0.10)
            : AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(
          color: isSelf
              ? AppColors.karmaGreen.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank Badge
          SizedBox(
            width: 32,
            child: Text(
              '#${entry.rank}',
              style: AppTypography.titleMedium.copyWith(
                color: isTop3 ? rankColor : AppColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: isSelf ? AppColors.karmaGreen : AppColors.surface,
            child: Text(
              entry.avatarInitials,
              style: AppTypography.metricLabel.copyWith(
                color: isSelf ? Colors.black : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Name & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.athleteName,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: isSelf ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                    if (isSelf)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: const BoxDecoration(
                          color: AppColors.karmaGreen,
                          borderRadius: AppRadii.radiusFull,
                        ),
                        child: Text(
                          'YOU',
                          style: AppTypography.metricLabel.copyWith(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  '${entry.karmaTierTitle} • ${entry.cityLocation}',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),

          // Score & Kudos
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.scoreValue.toInt()} ${entry.scoreUnit}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => ref
                    .read(leaderboardProvider.notifier)
                    .giveKudos(entry.athleteId),
                child: Row(
                  children: [
                    const Icon(Icons.favorite,
                        color: AppColors.karmaGreen, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '${entry.kudosReceived}',
                      style: AppTypography.metricLabel
                          .copyWith(color: AppColors.karmaGreen, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLeaderboardPhilosophyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shreshthata Leaderboard Philosophy',
                style: AppTypography.titleLarge
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma measures true holistic health mastery rather than toxic overtraining:\n\n'
                '• Karma Velocity rewards sleep, recovery, steps, and mindful nutrition equally.\n'
                '• Shatpawali consistency honors natural digestive fire (*Jatharagni*).\n'
                '• Unbroken habit streaks celebrate lifelong discipline (*Sthirata*).',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
