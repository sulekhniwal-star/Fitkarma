import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/cohort_models.dart';
import 'providers/cohort_provider.dart';

/// Screen displaying Demographic Cohort Insights, Percentile Distributions,
/// and Positive Social Contagion Network Effects (Sangha Power).
class DemographicCohortInsightsScreen extends ConsumerWidget {
  const DemographicCohortInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cohortState = ref.watch(demographicCohortProvider);
    final report = cohortState.report;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const BilingualLabel(
          primaryText: 'Demographic Cohorts & Sangha',
          regionalText: 'जनसांख्यिकीय समूह व संघ प्रभाव',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textSecondary),
            onPressed: () => _showCohortMethodologyModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Bento Card: Network Contagion & Sangha Influence
            _buildNetworkContagionHero(context, report),
            const SizedBox(height: AppSpacing.md),

            // 2. Filter & Persona Selector Card
            _buildCohortFilterSelector(context, ref, cohortState),
            const SizedBox(height: AppSpacing.md),

            // 3. Cultural Sangha Nudge Bento
            _buildCulturalNudgeCard(report),
            const SizedBox(height: AppSpacing.md),

            // 4. Collective Sangha Milestone Challenge
            _buildCollectiveGoalCard(report.activeCollectiveGoal),
            const SizedBox(height: AppSpacing.md),

            // 5. Section Header for Comparative Lifestyle Pillars
            const BilingualLabel(
              primaryText: 'Comparative Lifestyle Pillars',
              regionalText: 'जीवनशैली स्तंभ तुलनात्मक विश्लेषण',
            ),
            const SizedBox(height: AppSpacing.sm),

            // 6. Pillar Metric Comparison Cards
            ...report.pillarMetrics.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildPillarComparisonCard(m),
                )),
            const SizedBox(height: AppSpacing.md),

            // 7. Live Anonymized Peer Activity Stream (Network Contagion)
            _buildLivePeerActivityStream(report.recentPeerActivities),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkContagionHero(BuildContext context, DemographicCohortReport report) {
    final influence = report.networkInfluence;
    final color = influence == NetworkInfluenceTier.luminary
        ? AppColors.gold
        : influence == NetworkInfluenceTier.vanguard
            ? AppColors.karmaGreen
            : influence == NetworkInfluenceTier.catalyst
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
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hub, color: color, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      influence.title,
                      style: AppTypography.metricLabel.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.karmaGreen.withValues(alpha: 0.12),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  '${report.networkBonusMultiplier}x Karma Multiplier',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.karmaGreen,
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
                      'Social Contagion Index',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.socialContagionIndex.toStringAsFixed(1)}/100',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      influence.description,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              GlowingMetric(
                value: '${(report.networkBonusMultiplier * 100).toInt()}%',
                label: 'Sangha Power',
                accentColor: color,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress bar for Social Contagion
          ClipRRect(
            borderRadius: AppRadii.radiusFull,
            child: LinearProgressIndicator(
              value: (report.socialContagionIndex / 100.0).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCohortFilterSelector(
      BuildContext context, WidgetRef ref, DemographicCohortState state) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_city, color: AppColors.focusBlue, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Active Demographic Cohort',
                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // City Tier Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: IndianCityTier.values.map((tier) {
                final isSelected = tier == state.selectedCityTier;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      tier == IndianCityTier.tier1
                          ? 'Tier 1 Metro'
                          : tier == IndianCityTier.tier2
                              ? 'Tier 2 Emerging'
                              : 'Tier 3 Towns',
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
                        ref.read(demographicCohortProvider.notifier).updateCityTier(tier);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          // Persona Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ActivityPersonaCluster.values.map((persona) {
                final isSelected = persona == state.selectedPersona;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(
                      persona == ActivityPersonaCluster.techSedentary
                          ? 'Knowledge Worker'
                          : persona == ActivityPersonaCluster.activeExecutive
                              ? 'Executive'
                              : persona == ActivityPersonaCluster.studentAthlete
                                  ? 'Student / Athlete'
                                  : 'Homemaker',
                      style: AppTypography.metricLabel.copyWith(
                        color: isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.focusBlue,
                    backgroundColor: AppColors.surfaceElevated,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(demographicCohortProvider.notifier).updatePersona(persona);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Benchmarked against ${state.report.cohortGroup.activePeersCount} verified peers in ${state.report.cohortGroup.ageBracket}.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalNudgeCard(DemographicCohortReport report) {
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
          const Icon(Icons.insights, color: AppColors.focusBlue, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cohort Prerana (Sangha Insight)',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.focusBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.primaryPositiveNudge,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.regionalPrimaryPositiveNudge,
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

  Widget _buildCollectiveGoalCard(SanghaCollectiveGoal goal) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.groups, color: AppColors.energyOrange, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Sangha Challenge',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.energyOrange),
                  ),
                ],
              ),
              Text(
                '${goal.participatingAthletes} Athletes',
                style: AppTypography.metricLabel.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            goal.title,
            style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            goal.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(goal.currentQuantity / 1000000).toStringAsFixed(2)}M / ${(goal.targetQuantity / 1000000).toStringAsFixed(0)}M ${goal.unit}',
                style: AppTypography.metricLabel.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${goal.progressPercentage.toStringAsFixed(1)}%',
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
              value: goal.progressFraction,
              backgroundColor: AppColors.surfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.energyOrange),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarComparisonCard(CohortPillarMetric metric) {
    final isAhead = metric.userPercentile >= 50.0;
    final badgeColor = metric.userPercentile >= 75.0
        ? AppColors.karmaGreen
        : metric.userPercentile >= 50.0
            ? AppColors.focusBlue
            : AppColors.energyOrange;

    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metric.title,
                      style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                    ),
                    Text(
                      metric.regionalTitle,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: AppRadii.radiusFull,
                ),
                child: Text(
                  'Top ${(100 - metric.userPercentile).clamp(1.0, 99.0).toStringAsFixed(0)}%',
                  style: AppTypography.metricLabel.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Score', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                  Text(
                    '${metric.userValue % 1 != 0 ? metric.userValue.toStringAsFixed(1) : metric.userValue.toInt()} ${metric.unit}',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Cohort Avg', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                  Text(
                    '${metric.cohortAverage % 1 != 0 ? metric.cohortAverage.toStringAsFixed(1) : metric.cohortAverage.toInt()} ${metric.unit}',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Top 10% Benchmark', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                  Text(
                    '${metric.top10PercentileValue % 1 != 0 ? metric.top10PercentileValue.toStringAsFixed(1) : metric.top10PercentileValue.toInt()} ${metric.unit}',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.karmaGreen),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                isAhead ? Icons.arrow_upward : Icons.arrow_downward,
                color: isAhead ? AppColors.karmaGreen : AppColors.energyOrange,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                isAhead
                    ? '${metric.deltaPercentage.abs().toStringAsFixed(0)}% above cohort average'
                    : '${metric.deltaPercentage.abs().toStringAsFixed(0)}% below cohort average',
                style: AppTypography.bodySmall.copyWith(
                  color: isAhead ? AppColors.karmaGreen : AppColors.energyOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLivePeerActivityStream(List<AnonymizedPeerActivity> activities) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: AppColors.karmaGreen, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Live Sangha Stream',
                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Realtime anonymized positive habit momentum across your cohort.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          ...activities.map((act) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.surfaceElevated,
                      child: Icon(Icons.flash_on, color: AppColors.karmaGreen, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act.peerAlias,
                            style: AppTypography.metricLabel.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            act.actionDescription,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0x1F00E676),
                        borderRadius: AppRadii.radiusFull,
                      ),
                      child: Text(
                        '+${act.karmaGenerated} Karma',
                        style: AppTypography.metricLabel.copyWith(
                          color: AppColors.karmaGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showCohortMethodologyModal(BuildContext context) {
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
                'Demographic Cohort & Sangha Science',
                style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'FitKarma utilizes Gaussian distribution modeling across verified South Asian demographic clusters to provide truthful, contextual health percentiles.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Network Contagion Effect:',
                style: AppTypography.titleMedium.copyWith(color: AppColors.karmaGreen),
              ),
              const SizedBox(height: 4),
              Text(
                'When you maintain high consistency, your habit momentum radiates through the anonymized Sangha feed, lifting peer adherence and unlocking collective karma multipliers.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
