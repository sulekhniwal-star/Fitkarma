import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/analytics_provider.dart';

class VisualAnalyticsScreen extends ConsumerWidget {
  const VisualAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsProvider);
    final lean = state.leanMassInfo;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Visual Analytics', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lean Mass vs Fat Mass Split Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lean Body Mass (Boer Model)',
                        style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lean Mass', style: AppTypography.labelSmall),
                            Text(
                              '${lean.leanMassKg.toStringAsFixed(1)} kg',
                              style: AppTypography.titleLarge
                                  .copyWith(color: AppColors.primaryEmerald),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Fat Mass (${lean.bodyFatPercentage.round()}%)',
                                style: AppTypography.labelSmall),
                            Text(
                              '${lean.fatMassKg.toStringAsFixed(1)} kg',
                              style: AppTypography.titleLarge
                                  .copyWith(color: AppColors.warningAmber),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value: lean.leanMassKg / state.currentWeightKg,
                      backgroundColor: AppColors.warningAmber,
                      color: AppColors.primaryEmerald,
                      minHeight: 10.0,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 90-Day Trajectory Range Band Visualizer
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('90-Day Trajectory Range Band',
                            style: AppTypography.titleMedium),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text('Range: 68.5kg - 72.0kg',
                              style: AppTypography.labelSmall
                                  .copyWith(color: AppColors.primaryCyan)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Visualized as a confidence range band to prevent daily weight anxiety.',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Body Measurement Logging Action Card
              Text('Body Circumference Logging',
                  style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                onTap: () {
                  ref
                      .read(analyticsProvider.notifier)
                      .logMeasurement(82.0, 98.0, 34.0, 56.0);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quick Log Body Circumference',
                            style: AppTypography.titleMedium),
                        Text('Waist (82cm) • Chest (98cm) • Arms (34cm)',
                            style: AppTypography.labelSmall),
                      ],
                    ),
                    const Icon(Icons.add_circle_outline,
                        color: AppColors.primaryCyan),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
