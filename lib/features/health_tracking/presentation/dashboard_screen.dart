import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/daily_intelligence_package.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final dipAsync = ref.watch(dailyIntelligenceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header with Karma Points Badge & Streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BilingualLabel(
                        primaryText: 'Health OS Dashboard',
                        regionalText: 'दैनिक स्वास्थ्य अवलोकन',
                        primaryStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderBadge('🔥 ${dashboard.streakDays}d', AppColors.energyOrange),
                      const SizedBox(width: 8),
                      _buildHeaderBadge('✨ ${dashboard.karmaPoints}', AppColors.gold),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Health OS Brain Hero Bento Card
              dipAsync.when(
                data: (dip) => _buildHealthOsHeroCard(dip, dashboard),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading DIP: $err'),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Biometric Streams 2x2 Bento Grid
              Row(
                children: [
                  // Steps Card
                  Expanded(
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.directions_walk_rounded, color: AppColors.focusBlue, size: 20),
                              Text(
                                '${((dashboard.stepsCurrent / dashboard.stepsTarget) * 100).round()}%',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.focusBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GlowingMetric(
                            label: 'Steps Walked',
                            value: '${dashboard.stepsCurrent}',
                            accentColor: AppColors.focusBlue,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Goal: ${dashboard.stepsTarget}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Sleep Score Card
                  Expanded(
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.bedtime_rounded, color: AppColors.aiPurple, size: 20),
                              Text(
                                '${dashboard.sleepHours}h',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.aiPurple,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GlowingMetric(
                            label: 'Sleep Score',
                            value: '${dashboard.sleepScore}',
                            unit: '/100',
                            accentColor: AppColors.aiPurple,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Optimal architecture',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  // Hydration Card with quick +250ml tap
                  Expanded(
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.water_drop_rounded, color: AppColors.focusBlue, size: 20),
                              GestureDetector(
                                onTap: () => ref.read(dashboardProvider.notifier).addWater(0.25),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.focusBlue.withValues(alpha: 0.2),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: const Text(
                                    '+250ml',
                                    style: TextStyle(color: AppColors.focusBlue, fontSize: 10, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GlowingMetric(
                            label: 'Hydration Log',
                            value: '${dashboard.hydrationCurrentLiters}L',
                            accentColor: AppColors.focusBlue,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Target: ${dashboard.hydrationTargetLiters}L',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Strain Meter Card
                  Expanded(
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.whatshot_rounded, color: AppColors.energyOrange, size: 20),
                              Text(
                                'Target: ${dashboard.targetStrainMax.round()}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.energyOrange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GlowingMetric(
                            label: 'Daily Strain',
                            value: '${dashboard.currentStrain}',
                            unit: '/21',
                            accentColor: AppColors.energyOrange,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Balanced exertion',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Nutrition Macro Progress Card
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Daily Nutrition Target',
                          regionalText: 'दैनिक पोषण लक्ष्य',
                        ),
                        Text(
                          '${dashboard.caloriesConsumed} / ${dashboard.caloriesTarget} kcal',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.karmaGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: (dashboard.caloriesConsumed / dashboard.caloriesTarget).clamp(0.0, 1.0),
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation(AppColors.karmaGreen),
                      minHeight: 6,
                      borderRadius: AppRadii.radiusSm,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Protein: ${dashboard.proteinConsumedGrams}g / ${dashboard.proteinTargetGrams}g',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          '${dashboard.caloriesTarget - dashboard.caloriesConsumed} kcal remaining',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthOsHeroCard(DailyIntelligencePackage dip, DashboardSummaryState dashboard) {
    final Color zoneColor = dip.readinessScore >= 80
        ? AppColors.karmaGreen
        : dip.readinessScore >= 60
            ? AppColors.focusBlue
            : AppColors.energyOrange;

    final stepsProgress = (dashboard.stepsCurrent / dashboard.stepsTarget).clamp(0.0, 1.0);
    final nutritionProgress = (dashboard.proteinConsumedGrams / dashboard.proteinTargetGrams).clamp(0.0, 1.0);
    final readinessProgress = (dip.readinessScore / 100.0).clamp(0.0, 1.0);

    return BentoCard(
      hasGlow: true,
      glowColor: zoneColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: zoneColor.withValues(alpha: 0.15),
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(color: zoneColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'ZONE: ${dip.readinessZone.name.toUpperCase()}',
                    style: TextStyle(color: zoneColor, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 6),
                GlowingMetric(
                  label: 'Unified Health Score',
                  value: '${dip.healthScore}',
                  unit: '/100',
                  isHero: true,
                  accentColor: zoneColor,
                ),
                const SizedBox(height: 4),
                Text(
                  dip.workoutRecommendation,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          ActivityRings(
            size: 105,
            rings: [
              RingData(progress: readinessProgress, color: zoneColor, strokeWidth: 8),
              RingData(progress: stepsProgress, color: AppColors.focusBlue, strokeWidth: 8),
              RingData(progress: nutritionProgress, color: AppColors.energyOrange, strokeWidth: 8),
            ],
            centerWidget: Icon(Icons.favorite_rounded, color: zoneColor, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}
