import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/health_tracking_provider.dart';

class VitalsTrackingScreen extends ConsumerWidget {
  const VitalsTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthTrackingProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Vitals & Risk Patterns', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auto Step Count Card (Health Connect)
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Steps (Health Connect)', style: AppTypography.titleMedium),
                        Text('Auto-detected via on-device sensor', style: AppTypography.labelSmall),
                      ],
                    ),
                    Text(
                      '${state.steps}',
                      style: AppTypography.displayLarge.copyWith(color: AppColors.primaryCyan),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Blood Pressure Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Blood Pressure', style: AppTypography.titleMedium),
                        Text(
                          '${state.systolicBp.round()}/${state.diastolicBp.round()} mmHg',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.primaryEmerald),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgSecondary),
                            onPressed: () => ref.read(healthTrackingProvider.notifier).logBloodPressure(120, 80),
                            child: Text('Normal (120/80)', style: AppTypography.labelSmall),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgSecondary),
                            onPressed: () => ref.read(healthTrackingProvider.notifier).logBloodPressure(138, 88),
                            child: Text('Elevated (138/88)', style: AppTypography.labelSmall.copyWith(color: AppColors.warningAmber)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Blood Glucose Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Blood Glucose', style: AppTypography.titleMedium),
                        Text(
                          '${state.glucoseMgDl.round()} mg/dL',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.infoBlue),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgSecondary),
                            onPressed: () => ref.read(healthTrackingProvider.notifier).logGlucose(95),
                            child: Text('Fasting (95)', style: AppTypography.labelSmall),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bgSecondary),
                            onPressed: () => ref.read(healthTrackingProvider.notifier).logGlucose(165),
                            child: Text('Postprandial (165)', style: AppTypography.labelSmall.copyWith(color: AppColors.warningAmber)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Active Risk Alerts Section
              Text('Preventive Intelligence Risk Alerts', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              if (state.activeAlerts.isEmpty)
                GlassCard(
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: AppColors.primaryEmerald),
                      const SizedBox(width: AppSpacing.md),
                      Text('No active health risk patterns detected.', style: AppTypography.bodyMedium),
                    ],
                  ),
                )
              else
                ...state.activeAlerts.map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GlassCard(
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: AppColors.warningAmber),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alert.patternName, style: AppTypography.titleMedium),
                                Text(alert.description, style: AppTypography.bodyMedium),
                                Text('Rec: ${alert.recommendation}', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryCyan)),
                              ],
                            ),
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
