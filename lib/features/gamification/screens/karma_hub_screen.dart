import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/karma_hub_provider.dart';

/// §P7-B Karma Hub Screen
/// Route: /karma
class KarmaHubScreen extends ConsumerWidget {
  const KarmaHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(karmaHubProvider);
    final level = state.levelInfo;

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
        title: Text('Karma Hub — Level ${level.currentLevel}',
            style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Karma Level & Outcome XP BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${level.currentLevel} — ${level.levelName}',
                          style: AppTypography.h2
                              .copyWith(color: AppColors.primary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${state.totalXp} XP',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Progress to Next Level (${level.xpInCurrentLevel} / ${level.xpNeededForNextLevel} XP):',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: level.levelProgressRatio,
                        backgroundColor: AppColors.glassBorder,
                        color: AppColors.primary,
                        minHeight: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Demographic Cohort Rank & Network Effects Card
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Demographic Cohort Percentile',
                        style: AppTypography.h3),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.teal.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: AppColors.teal, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You score higher than ${state.cohortPercentile}% of Noida Builders!',
                              style: AppTypography.labelLg
                                  .copyWith(color: AppColors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Cohort Rank: #${state.cohortRank} of ${state.totalCohortMembers} members',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Achievement Grid Section
              Text('Achievements', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: state.achievements.length,
                itemBuilder: (context, index) {
                  final ach = state.achievements[index];
                  return GlassCard(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          ach.isUnlocked ? Icons.verified : Icons.lock_outline,
                          color: ach.isUnlocked
                              ? AppColors.accent
                              : AppColors.textMuted,
                          size: 28.0,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ach.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.labelLg.copyWith(
                            color: ach.isUnlocked
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ach.category,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Recent Outcome XP Activity History Section
              Text('Recent Outcome XP Activity', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              for (final event in state.recentEvents)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.warning, size: 18),
                            const SizedBox(width: 8),
                            Text(event.title, style: AppTypography.bodySm),
                          ],
                        ),
                        Text(
                          '+${event.xpAwarded} XP',
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
