import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/step_tracker_engine.dart';
import '../providers/dashboard_provider.dart';

class StepsScreen extends ConsumerWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    final metrics = StepTrackerEngine.calculateMetrics(
      totalSteps: dashboard.stepsCurrent,
      targetSteps: dashboard.stepsTarget,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Steps & Daily Cadence',
          regionalText: 'कदम एवं दैनिक सक्रियता',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Step Progress Bento Card
              BentoCard(
                hasGlow: metrics.isGoalAchieved,
                glowColor: AppColors.karmaGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Daily Steps',
                          regionalText: 'आज के कुल कदम',
                        ),
                        const SizedBox(height: 6),
                        GlowingMetric(
                          label: 'Completed',
                          value: '${metrics.totalSteps}',
                          unit: 'steps',
                          isHero: true,
                          accentColor: AppColors.focusBlue,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Target: ${metrics.targetSteps} (${(metrics.progressPercent * 100).round()}%)',
                          style: AppTypography.bodySmall.copyWith(
                            color: metrics.isGoalAchieved ? AppColors.karmaGreen : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ActivityRings(
                      size: 110,
                      rings: [
                        RingData(
                          progress: metrics.progressPercent.clamp(0.0, 1.0),
                          color: AppColors.focusBlue,
                          strokeWidth: 10,
                        ),
                      ],
                      centerWidget: const Icon(
                        Icons.directions_walk_rounded,
                        color: AppColors.focusBlue,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Stride Distance & Active Calories Row
              Row(
                children: [
                  Expanded(
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.route_rounded, color: AppColors.karmaGreen, size: 20),
                          const SizedBox(height: 8),
                          GlowingMetric(
                            label: 'Estimated Distance',
                            value: '${metrics.distanceKm}',
                            unit: 'km',
                            accentColor: AppColors.karmaGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: AppColors.energyOrange, size: 20),
                          const SizedBox(height: 8),
                          GlowingMetric(
                            label: 'Active Burn',
                            value: '${metrics.activeCaloriesBurned}',
                            unit: 'kcal',
                            accentColor: AppColors.energyOrange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Shatpawali Post-Meal Quick Walk Action Card
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.karmaGreen.withValues(alpha: 0.15),
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: const Icon(Icons.snowshoeing_rounded, color: AppColors.karmaGreen, size: 24),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10-Min Post-Meal Walk (शतपावली)',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Quick 1,000 steps boost to lower postprandial glucose.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.karmaGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
                      ),
                      onPressed: () {
                        ref.read(dashboardProvider.notifier).addSteps(1000);
                      },
                      child: const Text('+1,000', style: TextStyle(color: AppColors.textInverse, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Hourly Cadence Bar Distribution Chart
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Hourly Activity Distribution',
                      regionalText: 'प्रति घंटा सक्रियता विवरण',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: metrics.hourlyCadence.map((block) {
                          final heightFactor = (block.steps / 2000.0).clamp(0.1, 1.0);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${block.steps}',
                                style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 18,
                                height: 80 * heightFactor,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.focusBlue.withValues(alpha: 0.4),
                                      AppColors.focusBlue,
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${block.hour}:00',
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 5. Actionable Metabolic Insight Card
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.insights_rounded, color: AppColors.focusBlue, size: 20),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BilingualLabel(
                            primaryText: 'Metabolic Insight',
                            regionalText: 'मेटाबॉलिक विश्लेषण',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            metrics.metabolicInsight,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
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
}
