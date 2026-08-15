import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../providers/recovery_log_provider.dart';
import '../widgets/body_soreness_map_widget.dart';

/// Recovery Log Screen (§P2-C specification)
/// Full-screen scrollable bento layout with biometrics readouts and interactive widgets.
class RecoveryLogScreen extends ConsumerWidget {
  const RecoveryLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recoveryLogProvider);
    final notifier = ref.read(recoveryLogProvider.notifier);

    final sleepHoursStr =
        '${(state.sleepDurationMin / 60).floor()}h ${state.sleepDurationMin % 60}m';

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        title: const BilingualLabel(
          englishText: 'Recovery Log',
          hindiText: 'रिकवरी लॉग',
          englishStyle: AppTypography.displayMd,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Recovery Capacity & Score Banner
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recovery Score: ${state.readinessScore}',
                          style: AppTypography.h2
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    AppColors.success.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            state.readinessScore >= 80
                                ? 'Optimal Capacity'
                                : (state.readinessScore >= 65
                                    ? 'Moderate'
                                    : 'Rest Advised'),
                            style: AppTypography.labelMd
                                .copyWith(color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: state.readinessScore / 100.0,
                      backgroundColor: AppColors.surface2,
                      color: state.readinessScore >= 75
                          ? AppColors.success
                          : (state.readinessScore >= 50
                              ? AppColors.warning
                              : AppColors.error),
                      minHeight: 8.0,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Sleep: $sleepHoursStr · HRV: ${state.hrv.round()} ms · Resting HR: ${state.restingHR.round()} bpm',
                      style: AppTypography.labelMd
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Interactive Body Soreness Map
              const Text('Interactive Soreness Map', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.sm),
              BodySorenessMapWidget(
                sorenessState: state.soreness,
                onToggleMuscle: (muscle) =>
                    notifier.toggleMuscleSoreness(muscle),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. HRV Trend (7-Day) Card
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('HRV Trend (7-Day)',
                            style: AppTypography.h3),
                        Text(
                          '${state.hrv.round()} ms (Optimal)',
                          style:
                              AppTypography.h3.copyWith(color: AppColors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _HrvBar(day: 'M', heightPct: 0.75),
                          _HrvBar(day: 'T', heightPct: 0.85),
                          _HrvBar(day: 'W', heightPct: 0.60),
                          _HrvBar(day: 'T', heightPct: 0.90),
                          _HrvBar(day: 'F', heightPct: 0.80),
                          _HrvBar(day: 'S', heightPct: 0.95, isCurrent: true),
                          _HrvBar(day: 'S', heightPct: 0.70),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4. Commit Recovery Log Button
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isCommitted
                        ? AppColors.success
                        : AppColors.primary,
                    foregroundColor: AppColors.bg0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  onPressed: () {
                    notifier.commitLog();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.isCommitted
                              ? 'Recovery Log committed & targets calibrated!'
                              : 'Commit successful!',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  child: Text(
                    state.isCommitted
                        ? '✓ LOG COMMITTED'
                        : 'COMMIT RECOVERY LOG',
                    style: AppTypography.h2.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.bg0),
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

class _HrvBar extends StatelessWidget {
  final String day;
  final double heightPct;
  final bool isCurrent;

  const _HrvBar({
    required this.day,
    required this.heightPct,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 14,
          height: 40 * heightPct,
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.teal : AppColors.surface2,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: AppTypography.labelMd.copyWith(
            color: isCurrent ? AppColors.teal : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
