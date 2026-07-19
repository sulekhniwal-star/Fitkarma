import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/routing/app_router.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/daily_mission/daily_mission_screen.dart';
import 'package:fitkarma/features/dashboard/dashboard_controller.dart';
import 'package:fitkarma/shared/widgets/activity_rings.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;
    final cardBg = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;
    final primaryColor = isDark ? AppColorsDark.primary : AppColorsLight.primary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final successColor = isDark ? AppColorsDark.success : AppColorsLight.success;
    final secondaryColor = isDark ? AppColorsDark.secondary : AppColorsLight.secondary;

    // Loading State
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Header Container (320px, heroDeep gradient) ──
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColorsDark.heroGradient
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColorsLight.surface2,
                          AppColorsLight.bg1,
                          AppColorsLight.bg0,
                        ],
                      ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 12),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FITKARMA',
                                style: AppTypography.labelMd.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                'Health Dashboard',
                                style: AppTypography.h2.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh_rounded, color: textSecondary),
                            onPressed: () => ref.read(dashboardProvider.notifier).loadData(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Concurrently rendered Activity Rings & Steps Display Stack
                      Center(
                        child: SizedBox(
                          width: 180,
                          height: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 180px Activity Ring
                              ActivityRings(
                                rings: [
                                  RingData(
                                    value: state.steps.toDouble(),
                                    target: state.targetSteps.toDouble(),
                                    colors: [primaryColor, accentColor],
                                    strokeWidth: 12.0,
                                  ),
                                  RingData(
                                    value: state.caloriesConsumed.toDouble(),
                                    target: state.caloriesTarget.toDouble(),
                                    colors: [Colors.orange, Colors.deepOrange],
                                    strokeWidth: 12.0,
                                  ),
                                  RingData(
                                    value: 30, // Mocked active minutes
                                    target: 45,
                                    colors: [successColor, Colors.green],
                                    strokeWidth: 12.0,
                                  ),
                                ],
                                size: 180.0,
                                gap: 4.0,
                              ),
                              // Center text displaying steps & TrendChip
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${state.steps}',
                                    style: AppTypography.h1.copyWith(
                                      color: textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'STEPS',
                                    style: AppTypography.labelMd.copyWith(
                                      color: textSecondary,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // TrendChip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: successColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: successColor.withValues(alpha: 0.3), width: 0.5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '↑ 12%',
                                          style: AppTypography.labelMd.copyWith(
                                            color: successColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Scrollable Body Panel ──
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Health Score + Readiness side-by-side rings (80px)
                  BentoCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'READINESS',
                                  style: AppTypography.labelMd.copyWith(color: textSecondary, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ReadinessRing(
                                  score: state.readinessScore,
                                  confidenceLabel: 'High',
                                  size: 80,
                                ),
                              ],
                            ),
                            Container(
                              height: 60,
                              width: 1,
                              color: textSecondary.withValues(alpha: 0.15),
                            ),
                            Column(
                              children: [
                                Text(
                                  'HEALTH SCORE',
                                  style: AppTypography.labelMd.copyWith(color: textSecondary, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                HealthScoreRing(
                                  score: state.healthScore,
                                  size: 80,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Interactive button to go to Daily Mission
                        InkWell(
                          key: const Key('dashboard_mission_banner'),
                          onTap: () => context.go(AppRoutes.mission),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Tap to see today's mission",
                                  style: AppTypography.bodyMd.copyWith(color: primaryColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, color: primaryColor, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 2. Bento Row 1: Water & Calories progress
                  Row(
                    children: [
                      // Water Widget
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_drink_rounded, color: secondaryColor, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Water',
                                    style: AppTypography.bodyMd.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${state.waterL.toStringAsFixed(1)} / ${state.waterTargetL.toStringAsFixed(1)} L',
                                style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: (state.waterL / state.waterTargetL).clamp(0.0, 1.0),
                                backgroundColor: secondaryColor.withValues(alpha: 0.15),
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.bentoGap),
                      // Calories Widget
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Calories',
                                    style: AppTypography.bodyMd.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${state.caloriesConsumed} / ${state.caloriesTarget} kcal',
                                style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: (state.caloriesConsumed / state.caloriesTarget).clamp(0.0, 1.0),
                                backgroundColor: Colors.orange.withValues(alpha: 0.15),
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 3. AI Coach Insight Card (with orange border)
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.6), width: 1.5),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insights_rounded, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'AI COACH INSIGHT',
                              style: AppTypography.labelMd.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.primaryInsight,
                          style: AppTypography.bodyMd.copyWith(color: textPrimary, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 4. Bento Row 2: Sleep hours/score, Blood Pressure, Glucose widgets
                  Row(
                    children: [
                      // Sleep Widget
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.bedtime_rounded, color: Colors.indigoAccent, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Sleep',
                                    style: AppTypography.bodySm.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${state.sleepHours.toInt()}h ${( (state.sleepHours - state.sleepHours.toInt()) * 60 ).round()}m',
                                style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Score: ${state.sleepScore}',
                                style: AppTypography.labelMd.copyWith(color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.bentoGap),
                      // Blood Pressure Widget
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'BP',
                                    style: AppTypography.bodySm.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${state.systolic}/${state.diastolic}',
                                style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'mmHg · Normal',
                                style: AppTypography.labelMd.copyWith(color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.bentoGap),
                      // Glucose Widget
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.bloodtype_rounded, color: Colors.tealAccent, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Glucose',
                                    style: AppTypography.bodySm.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${state.glucose.round()}',
                                style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'mg/dL · Normal',
                                style: AppTypography.labelMd.copyWith(color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 5. Streak & Karma row
                  Row(
                    children: [
                      Expanded(
                        child: BentoCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                '${state.streakDays}-day streak',
                                style: AppTypography.bodyLg.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.bentoGap),
                      Expanded(
                        child: BentoCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                '${state.karmaPoints} karma',
                                style: AppTypography.bodyLg.copyWith(color: textPrimary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
