import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/squad_models.dart';
import 'providers/squad_provider.dart';

/// Comprehensive Squad Detail Screen on FitKarma (Micro-Squad Dynamics & Standups)
class SquadDetailScreen extends ConsumerWidget {
  const SquadDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final squad = ref.watch(squadDetailProvider);
    final tierColor = Color(squad.tier.badgeColorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Squad Command (Dal)',
          regionalText: 'दल नियंत्रण एवं सह-साधना',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showSquadPhilosophyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Squad Hero Banner with Multiplier & Streak
            _buildSquadHeroBanner(squad, tierColor),
            const SizedBox(height: AppSpacing.md),

            // 2. Squad Manifesto (Dal Sankalpa)
            _buildManifestoCard(squad),
            const SizedBox(height: AppSpacing.md),

            // 3. Sanjeevani Streak Shield Card
            _buildSanjeevaniCard(context, ref, squad),
            const SizedBox(height: AppSpacing.md),

            // 4. Active Weekly Challenge (Sanghathon)
            _buildChallengeCard(squad.activeChallenge),
            const SizedBox(height: AppSpacing.md),

            // 5. Daily Squad Standup Matrix
            BilingualLabel(
              primaryText: 'Daily Standup (${squad.checkedInMembersCount}/${squad.totalMembersCount} Checked In)',
              regionalText: 'दैनिक सह-साधना अवलोकन',
            ),
            const SizedBox(height: AppSpacing.sm),
            ...squad.members.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildMemberStandupCard(context, ref, member),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadHeroBanner(SquadDetail squad, Color tierColor) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                  border: Border.all(color: tierColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield, color: tierColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      squad.tier.title,
                      style: AppTypography.metricLabel.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '${squad.totalCollectiveKarma} Squad Karma',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      squad.squadName,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${squad.currentStreakDays} Days Streak • Best: ${squad.bestStreakDays} Days',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.karmaGreen),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${squad.squadCheckInRate.toStringAsFixed(0)}% check-in rate today across ${squad.totalMembersCount} athletes.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              GlowingMetric(
                value: '${squad.tier.multiplier}x',
                label: 'Squad Multiplier',
                accentColor: tierColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: squad.squadCheckInRate / 100.0,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(tierColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManifestoCard(SquadDetail squad) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.focusBlue.withValues(alpha: 0.10),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.focusBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_stories, color: AppColors.focusBlue, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Squad Manifesto (Dal Sankalpa)',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"${squad.manifesto}"',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '"${squad.regionalManifesto}"',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSanjeevaniCard(BuildContext context, WidgetRef ref, SquadDetail squad) {
    return BentoCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.karmaGreen.withValues(alpha: 0.15),
            child: const Icon(Icons.healing, color: AppColors.karmaGreen, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sanjeevani Streak Shield (${squad.availableSanjeevaniShields} Available)',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                ),
                Text(
                  'Protects squad streak from resetting if a member is traveling or resting.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          if (squad.availableSanjeevaniShields > 0)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceElevated,
                foregroundColor: AppColors.karmaGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () => ref.read(squadDetailProvider.notifier).useSanjeevaniShield(),
              child: const Text('Deploy Shield'),
            ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(SquadChallengeGoal challenge) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.flag, color: AppColors.energyOrange, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Active Squad Sanghathon',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.energyOrange),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '+${challenge.karmaRewardPool} Karma Pool',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            challenge.title,
            style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            challenge.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(challenge.currentQuantity / 1000).toInt()}k / ${(challenge.targetQuantity / 1000).toInt()}k ${challenge.unit}',
                style: AppTypography.metricLabel.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${challenge.progressPercentage.toStringAsFixed(0)}%',
                style: AppTypography.metricLabel.copyWith(
                  color: AppColors.energyOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: challenge.progressFraction,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.energyOrange),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberStandupCard(BuildContext context, WidgetRef ref, SquadMemberDetail member) {
    final isSelf = member.memberId == 'user_you';

    return BentoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isSelf ? AppColors.karmaGreen : AppColors.surfaceElevated,
            child: Text(
              member.avatarInitials,
              style: AppTypography.titleSmall.copyWith(
                color: isSelf ? Colors.black : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (member.role == SquadMemberRole.captain)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: AppRadii.radiusFull,
                        ),
                        child: Text(
                          'Captain',
                          style: AppTypography.metricLabel.copyWith(
                            color: AppColors.gold,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  '${member.todaySteps} steps • ${member.completedRingsCount}/4 Rings Complete',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
                const SizedBox(height: 4),
                // Tiny completed rings indicators
                Row(
                  children: [
                    _buildRingStatusIcon('Steps', member.todaySteps >= member.dailyStepTarget),
                    const SizedBox(width: 4),
                    _buildRingStatusIcon('Shatpawali', member.hasCompletedShatpawali),
                    const SizedBox(width: 4),
                    _buildRingStatusIcon('Workout', member.hasCompletedWorkout),
                    const SizedBox(width: 4),
                    _buildRingStatusIcon('Nutrition', member.hasLoggedNutrition),
                  ],
                ),
              ],
            ),
          ),
          if (isSelf)
            IconButton(
              icon: const Icon(Icons.check_circle, color: AppColors.karmaGreen, size: 28),
              onPressed: () => ref.read(squadDetailProvider.notifier).checkInSelf(),
            )
          else
            IconButton(
              icon: const Icon(Icons.favorite_border, color: AppColors.energyOrange, size: 24),
              onPressed: () => ref.read(squadDetailProvider.notifier).cheerMember(member.memberId),
            ),
        ],
      ),
    );
  }

  Widget _buildRingStatusIcon(String label, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: isDone ? AppColors.karmaGreen.withValues(alpha: 0.15) : AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusFull,
      ),
      child: Text(
        label,
        style: AppTypography.metricLabel.copyWith(
          color: isDone ? AppColors.karmaGreen : AppColors.textMuted,
          fontSize: 9,
          fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showSquadPhilosophyModal(BuildContext context) {
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
                'FitKarma Squad (Dal) Architecture',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Micro-Squads consist of 3–8 athletes practicing daily mutual accountability.\n\n'
                '• All-for-One Streak: When all members check in, your squad tier and multiplier elevate.\n'
                '• Sanjeevani Shield: Emergency protections safeguard your collective streak.\n'
                '• Sanghathon Challenges: Complete collective distance and nutrition goals to earn community Karma pools.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
