import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/social_provider.dart';

class ActivityFeedScreen extends ConsumerWidget {
  const ActivityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(socialProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Activity Feed & Squad', style: AppTypography.titleLarge),
        actions: [
          IconButton(
            icon: Icon(
              state.isAnonymousMode ? Icons.visibility_off : Icons.visibility,
              color: state.isAnonymousMode
                  ? AppColors.warningAmber
                  : AppColors.primaryCyan,
            ),
            onPressed: () =>
                ref.read(socialProvider.notifier).toggleAnonymity(),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Squad Invite Code Card
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Squad Invite Code',
                            style: AppTypography.titleMedium),
                        Text('Share with friends to form a squad',
                            style: AppTypography.labelSmall),
                      ],
                    ),
                    Chip(
                      backgroundColor: AppColors.glassBgMid,
                      side: const BorderSide(color: AppColors.glassBorder),
                      label: Text(state.squadInviteCode,
                          style: AppTypography.titleLarge
                              .copyWith(color: AppColors.primaryCyan)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Privacy-First Squad Readiness Board
              Text('Squad Readiness Board (Tiers Only)',
                  style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                child: Column(
                  children: state.squadReadinessBoard.map((member) {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(member.memberName,
                              style: AppTypography.titleMedium),
                          Row(
                            children: [
                              Chip(
                                backgroundColor: AppColors.glassBgMid,
                                side: const BorderSide(
                                    color: AppColors.glassBorder),
                                label: Text(member.tier.name.toUpperCase(),
                                    style: AppTypography.labelSmall),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(member.statusLabel,
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primaryEmerald)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Activity Feed Items List
              Text('Community Activity Feed', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...state.feedItems.map((item) {
                final displayName =
                    state.isAnonymousMode && item.userName == 'You'
                        ? 'Anonymous User'
                        : item.userName;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(displayName, style: AppTypography.titleMedium),
                            Text(item.timestamp,
                                style: AppTypography.labelSmall),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(item.title,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.primaryCyan)),
                        Text(item.description, style: AppTypography.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.back_hand,
                                color: item.isHighFived
                                    ? AppColors.warningAmber
                                    : AppColors.textMuted,
                              ),
                              onPressed: () => ref
                                  .read(socialProvider.notifier)
                                  .toggleHighFive(item.id),
                            ),
                            Text('${item.highFiveCount} High-Fives',
                                style: AppTypography.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
