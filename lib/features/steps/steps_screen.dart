import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_spacing.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/features/steps/steps_controller.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';

class StepsScreen extends ConsumerWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stepsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColorsDark.bg0 : AppColorsLight.bg0;
    final textPrimary = isDark
        ? AppColorsDark.textPrimary
        : AppColorsLight.textPrimary;
    final textSecondary = isDark
        ? AppColorsDark.textSecondary
        : AppColorsLight.textSecondary;
    final primaryColor = isDark
        ? AppColorsDark.primary
        : AppColorsLight.primary;
    final accentColor = isDark ? AppColorsDark.accent : AppColorsLight.accent;
    final successColor = isDark
        ? AppColorsDark.success
        : AppColorsLight.success;
    final cardBg = isDark ? AppColorsDark.bg1 : AppColorsLight.bg1;

    final progressFraction = (state.stepsToday / state.targetSteps).clamp(
      0.0,
      1.0,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Steps Tracker',
          style: AppTypography.h3.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Sync Badge
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  (state.syncStatus == 'Syncing' ? accentColor : successColor)
                      .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (state.syncStatus == 'Syncing' ? accentColor : successColor)
                        .withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  state.syncStatus == 'Syncing'
                      ? Icons.sync_rounded
                      : Icons.check_circle_rounded,
                  color: state.syncStatus == 'Syncing'
                      ? accentColor
                      : successColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sync: ${state.syncStatus}',
                  style: AppTypography.labelMd.copyWith(
                    color: state.syncStatus == 'Syncing'
                        ? accentColor
                        : successColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Daily Progress Hero Card
                  BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Progress',
                              style: AppTypography.bodySm.copyWith(
                                color: textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.stepsToday} / ${state.targetSteps} steps',
                              style: AppTypography.bodyMd.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Linear Progress Indicator
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progressFraction,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, accentColor],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Metrics Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(
                              'Distance',
                              '${state.distanceKm} km',
                              Icons.directions_run_rounded,
                              accentColor,
                            ),
                            _buildStatItem(
                              'Active Time',
                              '${state.activeMinutes} min',
                              Icons.timer_rounded,
                              successColor,
                            ),
                            _buildStatItem(
                              'Calories',
                              '${state.caloriesBurned} kcal',
                              Icons.local_fire_department_rounded,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 2. Hourly Steps Distribution
                  BentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hourly Step Distribution',
                          style: AppTypography.h3.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Custom Vertical Bar Chart representation
                        SizedBox(
                          height: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildBarNode(
                                '08:00',
                                state.hourlySteps[8] ?? 0,
                                3000,
                                primaryColor,
                              ),
                              _buildBarNode(
                                '10:00',
                                state.hourlySteps[10] ?? 0,
                                3000,
                                primaryColor,
                              ),
                              _buildBarNode(
                                '12:00',
                                state.hourlySteps[12] ?? 0,
                                3000,
                                primaryColor,
                              ),
                              _buildBarNode(
                                '14:00',
                                state.hourlySteps[14] ?? 0,
                                3000,
                                primaryColor,
                              ),
                              _buildBarNode(
                                '16:00',
                                state.hourlySteps[16] ?? 0,
                                3000,
                                primaryColor,
                              ),
                              _buildBarNode(
                                '18:00',
                                state.hourlySteps[18] ?? 0,
                                3000,
                                primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.bentoGap),

                  // 3. AI Coach Tip Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tips_and_updates_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'COACH RECOMMENDATION',
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
                          'Great job! A 10-minute walk now will cross your daily goal before dinner.',
                          style: AppTypography.bodyMd.copyWith(
                            color: textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Interactive Simulation Buttons (For testing and validation)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          key: const Key('steps_sync_button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => ref
                              .read(stepsProvider.notifier)
                              .syncWithDeviceHealth(1500),
                          icon: const Icon(Icons.sync_rounded),
                          label: const Text('Simulate OS Sync (+1.5k)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String val, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              val,
              style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColorsDark.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarNode(String label, int value, int maxValue, Color color) {
    final fraction = (value / maxValue).clamp(0.02, 1.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value > 0 ? '${(value / 100).round() / 10}k' : '0',
          style: AppTypography.labelMd.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: SizedBox(
            width: 14,
            child: FractionallySizedBox(
              heightFactor: fraction,
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: fraction.clamp(0.4, 1.0)),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColorsDark.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
