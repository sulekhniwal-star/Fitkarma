import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/habit_identity_models.dart';
import 'providers/habit_identity_provider.dart';

/// Screen displaying the Behavioral Habit Identity Layer (Swadharma Identity Fusion),
/// Automaticity Progression, Identity Votes Cast, and Archetype Affirmations.
class HabitIdentityScreen extends ConsumerWidget {
  const HabitIdentityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(habitIdentityProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Habit Identity & Swadharma',
          regionalText: 'आदत आत्मसात एवं स्वधर्म स्वरूप',
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showBehaviorScienceModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Bento Card: Identity Fusion Stage & Score
            _buildIdentityFusionHero(report),
            const SizedBox(height: AppSpacing.md),

            // 2. Archetype Selector & Mantra Card
            _buildArchetypeSelector(context, ref, report),
            const SizedBox(height: AppSpacing.md),

            // 3. Daily Sankalpa Affirmation Bento
            _buildSankalpaAffirmationCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Automaticity & Cognitive Friction Reduction Gauge
            _buildAutomaticityGaugeCard(report),
            const SizedBox(height: AppSpacing.md),

            // 5. Archetype Vote Distribution Tally
            const BilingualLabel(
              primaryText: 'Identity Vote Distribution',
              regionalText: 'संकल्प मत विभाजन (आचरण साक्ष्य)',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildVoteDistributionCard(report.voteTallies),
            const SizedBox(height: AppSpacing.md),

            // 6. Recent Identity Votes Log
            const BilingualLabel(
              primaryText: 'Recent Actions Cast as Votes',
              regionalText: 'हाल ही में अर्जित संकल्प मत',
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildRecentVotesStream(report.recentVotes),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityFusionHero(HabitIdentityReport report) {
    final stage = report.fusionStage;
    final color = stage == IdentityFusionStage.sahaja
        ? AppColors.gold
        : stage == IdentityFusionStage.nishtha
            ? AppColors.karmaGreen
            : stage == IdentityFusionStage.abhyasi
                ? AppColors.focusBlue
                : AppColors.energyOrange;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fingerprint, color: color, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Level ${stage.level}: ${stage.title}',
                      style: AppTypography.metricLabel.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '${report.totalVotesCast} Total Votes Cast',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
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
                      'Identity Fusion Index',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.identityFusionScore.toStringAsFixed(1)}%',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stage.description,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              GlowingMetric(
                value: '${report.identityFusionScore.toInt()}%',
                label: 'Identity',
                accentColor: color,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: (report.identityFusionScore / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchetypeSelector(
      BuildContext context, WidgetRef ref, HabitIdentityReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology,
                  color: AppColors.focusBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Chosen Swadharma Archetype',
                style: AppTypography.titleMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: IdentityArchetype.values.map((archetype) {
                final isSelected = archetype == report.primaryArchetype;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      archetype.title.split('(')[0].trim(),
                      style: AppTypography.metricLabel.copyWith(
                        color:
                            isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.karmaGreen,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                            .read(habitIdentityProvider.notifier)
                            .switchArchetype(archetype);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: AppRadii.radiusMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Core Mantra:',
                  style: AppTypography.metricLabel
                      .copyWith(color: AppColors.karmaGreen),
                ),
                const SizedBox(height: 2),
                Text(
                  '"${report.primaryArchetype.mantra}"',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '"${report.primaryArchetype.regionalMantra}"',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
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

  Widget _buildSankalpaAffirmationCard(HabitIdentityReport report) {
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
          const Icon(Icons.auto_awesome, color: AppColors.focusBlue, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Swadharma Sankalpa (Identity Affirmation)',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.dailySankalpaAffirmation,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.regionalDailySankalpaAffirmation,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomaticityGaugeCard(HabitIdentityReport report) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.energyOrange, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Habit Automaticity & Cognitive Friction',
                style: AppTypography.titleMedium
                    .copyWith(color: AppColors.energyOrange),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Lally Asymptotic Habit Curve: Willpower needed to start is dropping steadily.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Automaticity Index',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                  Text(
                    '${report.habitAutomaticityIndex.toStringAsFixed(1)}%',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.energyOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Mental Friction Reduction',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                  Text(
                    '-${report.cognitiveFrictionReductionPercent.toStringAsFixed(0)}% effort',
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.karmaGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: (report.habitAutomaticityIndex / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.energyOrange),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteDistributionCard(List<ArchetypeVoteTally> tallies) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tallies.map((tally) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tally.archetype.title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${tally.totalVotes} votes (${tally.percentageShare.toStringAsFixed(0)}%)',
                      style: AppTypography.metricLabel.copyWith(
                        color: AppColors.karmaGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: AppRadii.radiusFull,
                  child: LinearProgressIndicator(
                    value: (tally.percentageShare / 100.0).clamp(0.0, 1.0),
                    backgroundColor: AppColors.surfaceElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.karmaGreen),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentVotesStream(List<IdentityVoteRecord> votes) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: votes.map((vote) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Icon(Icons.how_to_vote,
                      color: AppColors.focusBlue, size: 14),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vote.habitName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vote.reinforcementMessage,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.focusBlue.withValues(alpha: 0.12),
                    borderRadius: AppRadii.radiusFull,
                  ),
                  child: Text(
                    '+${vote.votesCount} Vote',
                    style: AppTypography.metricLabel.copyWith(
                      color: AppColors.focusBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showBehaviorScienceModal(BuildContext context) {
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
                'Identity-Based Habit Science',
                style: AppTypography.titleLarge
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Based on behavioral psychology (Clear, Fogg, Lally) and Vedic Swadharma:\n\n'
                '• Outcome habits say: "I want to finish 10k steps."\n'
                '• Identity habits say: "I am an active practitioner who moves every day."\n\n'
                'Every time you complete Shatpawali or a workout, you cast an undeniable vote for your chosen athlete identity, permanently lowering mental resistance.',
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
