import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/community_engine.dart';
import '../domain/community_models.dart';
import 'providers/community_provider.dart';

/// Screen displaying Thematic Accountability Communities (Mandalas / समाज),
/// Discussion Threads, Mentor Answers, and Knowledge Vaults.
class AccountabilityCommunitiesScreen extends ConsumerWidget {
  const AccountabilityCommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communitiesProvider);
    final displayedCommunities = CommunityEngine.filterCommunities(
      communities: state.allCommunities,
      category: state.selectedCategory,
      joinedOnly: state.showJoinedOnly,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Accountability Communities',
          regionalText: 'साधक मंडल एवं ज्ञान विमर्श',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showCommunityPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Filter Chips by Category
            _buildCategoryFilterRow(context, ref, state.selectedCategory),
            const SizedBox(height: AppSpacing.md),

            // 2. Section Header with Joined-Only Filter Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BilingualLabel(
                  primaryText: 'Thematic Mandalas',
                  regionalText: 'सक्रिय स्वास्थ्य मंडल',
                ),
                FilterChip(
                  label: Text(
                    'Joined Only',
                    style: AppTypography.metricLabel.copyWith(
                      color: state.showJoinedOnly
                          ? Colors.black
                          : AppColors.textSecondary,
                      fontWeight: state.showJoinedOnly
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: state.showJoinedOnly,
                  selectedColor: AppColors.karmaGreen,
                  backgroundColor: AppColors.surfaceElevated,
                  onSelected: (val) => ref
                      .read(communitiesProvider.notifier)
                      .toggleJoinedOnly(val),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // 3. Communities List
            if (displayedCommunities.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    'No communities found for this filter.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...displayedCommunities.map((community) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _buildCommunityCard(context, ref, community),
                  )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterRow(BuildContext context, WidgetRef ref,
      CommunityCategory? selectedCategory) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CommunityCategory.values.map((cat) {
          final isSelected = cat == selectedCategory;
          final color = Color(cat.badgeColorCode);

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(
                cat.label.split('&')[0].trim(),
                style: AppTypography.metricLabel.copyWith(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: color,
              backgroundColor: AppColors.surfaceElevated,
              onSelected: (_) =>
                  ref.read(communitiesProvider.notifier).selectCategory(cat),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommunityCard(
      BuildContext context, WidgetRef ref, AccountabilityCommunity community) {
    final catColor = Color(community.category.badgeColorCode);

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category Badge & Join Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  community.category.label,
                  style: AppTypography.metricLabel.copyWith(
                    color: catColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: community.isUserJoined
                      ? AppColors.surfaceElevated
                      : AppColors.karmaGreen,
                  foregroundColor: community.isUserJoined
                      ? AppColors.textSecondary
                      : Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => ref
                    .read(communitiesProvider.notifier)
                    .toggleJoinCommunity(community.id),
                child: Text(
                  community.isUserJoined ? 'Joined' : 'Join Mandala',
                  style: AppTypography.metricLabel.copyWith(
                    fontWeight: FontWeight.bold,
                    color: community.isUserJoined
                        ? AppColors.textSecondary
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Title & Manifesto
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      community.name,
                      style: AppTypography.titleLarge
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      community.regionalName,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${community.manifesto}"',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GlowingMetric(
                value: '${community.communityPulseScore.toInt()}%',
                label: 'Pulse Rate',
                accentColor: catColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Lead Mentor Spotlight
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusMd,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.focusBlue.withValues(alpha: 0.15),
                  child: const Icon(Icons.verified,
                      color: AppColors.focusBlue, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.leadMentor.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        community.leadMentor.title,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Text(
                  '⭐ ${community.leadMentor.rating}',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Active Discussion Threads Snippet
          if (community.activeThreads.isNotEmpty) ...[
            Text(
              'Featured Community Discussion',
              style: AppTypography.metricLabel.copyWith(
                  color: AppColors.focusBlue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...community.activeThreads.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(color: AppColors.surfaceElevated),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              t.title,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${t.upvotesCount} Upvotes',
                            style: AppTypography.metricLabel.copyWith(
                                color: AppColors.karmaGreen, fontSize: 10),
                          ),
                        ],
                      ),
                      if (t.topAnswerSnippet != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          t.topAnswerSnippet!,
                          style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                )),
          ],

          // Knowledge Vault Resource Link
          if (community.knowledgeVault.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.menu_book, color: AppColors.gold, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Knowledge Vault: ${community.knowledgeVault.first.title} (${community.knowledgeVault.first.durationOrPages})',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.gold, fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showCommunityPhilosophyModal(BuildContext context) {
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
                'Accountability Communities (Mandalas)',
                style: AppTypography.titleLarge
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Mandalas are themed accountability circles dedicated to specific health objectives (e.g. Glucose reversal, Shatpawali, Desi Strength).\n\n'
                '• Guided by verified Ayurvedic Doctors & CSCS Coaches.\n'
                '• Free of misinformation and aggressive marketing.\n'
                '• Community Pulse Index aggregates member adherence to prove real-world outcomes.',
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
