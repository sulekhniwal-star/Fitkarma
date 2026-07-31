import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/gamification_provider.dart';

class KarmaHubScreen extends ConsumerWidget {
  const KarmaHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gamificationProvider);
    final level = state.levelInfo;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Karma Hub', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Level Badge Ring & XP Progress Card
              GlassCard(
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: CircularProgressIndicator(
                            value: level.levelProgressRatio,
                            strokeWidth: 8.0,
                            backgroundColor: AppColors.bgSecondary,
                            color: AppColors.primaryViolet,
                          ),
                        ),
                        Text(
                          'Lvl ${level.currentLevel}',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.primaryViolet),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Outcome XP: ${state.totalXp}', style: AppTypography.titleLarge),
                          Text('${level.xpForNextLevel - state.totalXp} XP to Level ${level.currentLevel + 1}', style: AppTypography.labelSmall),
                          const SizedBox(height: 4.0),
                          LinearProgressIndicator(
                            value: level.levelProgressRatio,
                            backgroundColor: AppColors.bgSecondary,
                            color: AppColors.primaryViolet,
                            minHeight: 6.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Achievement Grid Section
              Text('Achievement Grid', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: state.achievements.length,
                itemBuilder: (context, index) {
                  final ach = state.achievements[index];
                  return GlassCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          ach.isUnlocked ? Icons.stars : Icons.lock,
                          color: ach.isUnlocked ? AppColors.warningAmber : AppColors.textMuted,
                          size: 32.0,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(ach.title, textAlign: TextAlign.center, style: AppTypography.titleMedium),
                        Text(ach.category, style: AppTypography.labelSmall),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Demographic Cohort Benchmarks Section
              Text('Demographic Cohort Benchmarks', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...state.benchmarks.map(
                (bench) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bench.metricName, style: AppTypography.titleMedium),
                            Text(bench.cohortName, style: AppTypography.labelSmall),
                          ],
                        ),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text(bench.userPercentile, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryEmerald)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
