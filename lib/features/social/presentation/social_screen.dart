import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/social_engine.dart';
import '../domain/social_models.dart';
import 'providers/social_provider.dart';

/// Main Social Screen on FitKarma (Sangha, Squads, Family Circles, and Activity Feed)
class SocialScreen extends ConsumerWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialState = ref.watch(socialProvider);
    final displayedItems = SocialEngine.filterFeed(
      allItems: socialState.feedItems,
      filter: socialState.selectedFilter,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Sangha & Community',
          regionalText: 'सत्संग, दल एवं परिवार',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSocialPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Squad & Energy Multiplier Card
            _buildSquadHeroCard(socialState.activeSquad),
            const SizedBox(height: AppSpacing.md),

            // 2. Family Health Circle Glance
            _buildFamilyCircleGlance(socialState.familyCircle),
            const SizedBox(height: AppSpacing.md),

            // 3. Local Club Spotlight
            _buildLocalClubSpotlight(socialState.localClub),
            const SizedBox(height: AppSpacing.md),

            // 4. Social Feed Filter Tabs
            _buildFilterSelector(context, ref, socialState.selectedFilter),
            const SizedBox(height: AppSpacing.md),

            // 5. Section Header for Feed
            BilingualLabel(
              primaryText: socialState.selectedFilter.label,
              regionalText: socialState.selectedFilter.regionalLabel,
            ),
            const SizedBox(height: AppSpacing.sm),

            // 6. Social Feed Items List
            if (displayedItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    'No activities in this circle yet. Complete a ritual to inspire your Sangha!',
                    style: TextStyle(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...displayedItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _buildFeedItemCard(context, ref, item),
                  )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadHeroCard(SquadSummary squad) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.groups,
                      color: AppColors.karmaGreen, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Active Accountability Squad',
                    style: AppTypography.titleMedium
                        .copyWith(color: AppColors.karmaGreen),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '${squad.activeStreakDays}d Streak',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.karmaGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            squad.squadName,
            style: AppTypography.titleMedium
                .copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${squad.memberCount} Athletes in Sync',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: squad.memberInitials.map((initials) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: initials == 'You'
                              ? AppColors.karmaGreen
                              : AppColors.surfaceElevated,
                          child: Text(
                            initials,
                            style: AppTypography.metricLabel.copyWith(
                              color: initials == 'You'
                                  ? Colors.black
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              GlowingMetric(
                value: '${squad.squadMultiplier}x',
                label: 'Squad Energy',
                accentColor: AppColors.karmaGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyCircleGlance(List<FamilyMemberSummary> family) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.family_restroom,
                      color: AppColors.focusBlue, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Family Health Circle (Parivar)',
                    style: AppTypography.titleMedium
                        .copyWith(color: AppColors.focusBlue),
                  ),
                ],
              ),
              Text(
                '${family.length} Connected',
                style: AppTypography.metricLabel
                    .copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...family.map((member) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${member.name} (${member.regionalRelationship})',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (member.alertRequired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.energyOrange
                                  .withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusFull,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.priority_high,
                                    color: AppColors.energyOrange, size: 12),
                                Text(
                                  'Prompt Walk',
                                  style: AppTypography.metricLabel.copyWith(
                                    color: AppColors.energyOrange,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            '${member.todaySteps} / ${member.dailyStepTarget} steps',
                            style: AppTypography.metricLabel
                                .copyWith(color: AppColors.karmaGreen),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.healthStatus,
                      style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: AppRadii.radiusFull,
                      child: LinearProgressIndicator(
                        value: member.stepProgressFraction,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          member.alertRequired
                              ? AppColors.energyOrange
                              : AppColors.focusBlue,
                        ),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocalClubSpotlight(LocalClubSummary club) {
    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.aiPurple.withValues(alpha: 0.15),
            child: const Icon(Icons.location_on,
                color: AppColors.aiPurple, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${club.cityArea} • ${club.activeMembersCount} active practitioners',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildFilterSelector(
      BuildContext context, WidgetRef ref, SocialFeedFilter selectedFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SocialFeedFilter.values.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(
                filter.label.split('(')[0].trim(),
                style: AppTypography.metricLabel.copyWith(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.karmaGreen,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (selected) {
                if (selected) {
                  ref.read(socialProvider.notifier).selectFilter(filter);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedItemCard(
      BuildContext context, WidgetRef ref, SocialFeedItem item) {
    final eventColor = Color(item.eventType.badgeColorCode);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surfaceElevated,
                    child: Text(
                      item.authorName.isNotEmpty ? item.authorName[0] : 'A',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.authorName,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.authorKarmaBadge} • ${item.authorLocation}',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: eventColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  item.eventType.title,
                  style: AppTypography.metricLabel.copyWith(
                    color: eventColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Event Headline
          Text(
            item.eventHeadline,
            style: AppTypography.titleMedium
                .copyWith(color: AppColors.textPrimary),
          ),
          Text(
            item.regionalEventHeadline,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Detail Metrics Pill
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 6),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusSm,
            ),
            child: Row(
              children: [
                const Icon(Icons.insights,
                    color: AppColors.karmaGreen, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.detailMetrics,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Action footer: Kudos Button & Karma
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateTime.now().difference(item.timestamp).inMinutes}m ago',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
              InkWell(
                borderRadius: AppRadii.radiusFull,
                onTap: () =>
                    ref.read(socialProvider.notifier).toggleKudos(item.id),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.hasUserLiked
                        ? AppColors.karmaGreen.withValues(alpha: 0.2)
                        : AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusFull,
                    border: Border.all(
                      color: item.hasUserLiked
                          ? AppColors.karmaGreen
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.hasUserLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: item.hasUserLiked
                            ? AppColors.karmaGreen
                            : AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.kudosCount} Kudos',
                        style: AppTypography.metricLabel.copyWith(
                          color: item.hasUserLiked
                              ? AppColors.karmaGreen
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSocialPhilosophyModal(BuildContext context) {
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
                'FitKarma Sangha Philosophy',
                style: AppTypography.titleLarge
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Unlike toxic social media feeds driven by vanity metrics, FitKarma Sangha is built on mutual upliftment, family care, and collective energy.\n\n'
                '• Micro-Squads multiply collective Karma.\n'
                '• Family Circles provide peace of mind for elders.\n'
                '• Giving Kudos sends positive Karma energy to your fellow practitioners.',
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
