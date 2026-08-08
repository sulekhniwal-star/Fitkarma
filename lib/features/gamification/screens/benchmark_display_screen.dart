import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/benchmarking_engine.dart';

/// §P7-E Benchmark Display Screen
/// Route: /benchmarking
class BenchmarkDisplayScreen extends StatelessWidget {
  final UserProfileData user;
  final UserHealthMetricsData metrics;

  const BenchmarkDisplayScreen({
    super.key,
    this.user = const UserProfileData(age: 28, gender: 'Male', country: 'India'),
    this.metrics = const UserHealthMetricsData(
      avgSteps7d: 9400,
      avgProtein7d: 78,
      avgSleepH: 7.1,
      workoutsPerWeek: 4.2,
    ),
  });

  @override
  Widget build(BuildContext context) {
    const engine = BenchmarkingEngine();
    final result = engine.compare(user: user, data: metrics);
    final topOverall = result.topLabel(result.overallPercentile);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Fitness Percentiles', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compared to: ${result.cohortLabel}',
                style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),

              // Overall Percentile BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Fitness Percentile', style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            topOverall,
                            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: result.overallPercentile / 100.0,
                        backgroundColor: AppColors.glassBorder,
                        color: AppColors.primary,
                        minHeight: 12.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Overall Score: ${result.overallPercentile}th percentile',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text('Metric Breakdown', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              _buildMetricCard(
                icon: Icons.directions_walk,
                title: 'Steps',
                percentile: result.stepsPercentile,
                metricValue: '${metrics.avgSteps7d.round()}/day avg',
                color: AppColors.teal,
                topLabel: result.topLabel(result.stepsPercentile),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildMetricCard(
                icon: Icons.restaurant,
                title: 'Protein',
                percentile: result.proteinPercentile,
                metricValue: '${metrics.avgProtein7d.round()}g/day avg',
                color: AppColors.warning,
                topLabel: result.topLabel(result.proteinPercentile),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildMetricCard(
                icon: Icons.single_bed,
                title: 'Sleep',
                percentile: result.sleepPercentile,
                metricValue: '${metrics.avgSleepH.toStringAsFixed(1)}h avg',
                color: AppColors.purple,
                topLabel: result.topLabel(result.sleepPercentile),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildMetricCard(
                icon: Icons.fitness_center,
                title: 'Workouts',
                percentile: result.workoutsPercentile,
                metricValue: '${metrics.workoutsPerWeek.toStringAsFixed(1)}/week',
                color: AppColors.accent,
                topLabel: result.topLabel(result.workoutsPercentile),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Biggest Opportunity Card
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 22),
                        const SizedBox(width: 8),
                        Text('Your biggest opportunity:', style: AppTypography.h3),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.opportunityTip,
                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required int percentile,
    required String metricValue,
    required Color color,
    required String topLabel,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLg),
                Text(metricValue, style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              topLabel,
              style: AppTypography.labelLg.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
