import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/sleep_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/daily_mission_provider.dart';

class RecoveryLogScreen extends ConsumerWidget {
  const RecoveryLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionState = ref.watch(dailyMissionProvider);
    final readiness = missionState.readiness;

    const sleepEngine = SleepEngine();
    final sleepResult = sleepEngine.calculateSleepPerformance(
      actualSleepHours: missionState.sleepHours,
      sleepNeedHours: 8.0,
    );

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Recovery Log', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Confidence Tier Badge
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Confidence Tier', style: AppTypography.titleMedium),
                    Chip(
                      backgroundColor: AppColors.glassBgMid,
                      side: const BorderSide(color: AppColors.glassBorder),
                      label: Text(readiness.confidenceLabel, style: AppTypography.labelSmall),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4-Pillar Sleep Score Card
              Text('Sleep Performance (4 Pillars)', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                child: Column(
                  children: [
                    _buildPillarRow('Overall Sleep Score', '${sleepResult.overallScore} / 100', AppColors.primaryCyan),
                    const Divider(color: AppColors.glassBorder),
                    _buildPillarRow('Duration (35%)', '${sleepResult.durationScore.round()}%', AppColors.primaryEmerald),
                    const Divider(color: AppColors.glassBorder),
                    _buildPillarRow('Efficiency (25%)', '${sleepResult.efficiencyScore.round()}%', AppColors.infoBlue),
                    const Divider(color: AppColors.glassBorder),
                    _buildPillarRow('Restfulness (25%)', '${sleepResult.restfulnessScore.round()}%', AppColors.primaryViolet),
                    const Divider(color: AppColors.glassBorder),
                    _buildPillarRow('Circadian Alignment (15%)', '${sleepResult.circadianScore.round()}%', AppColors.warningAmber),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Recovery Prescription Checklist
              Text('Recovery Prescription Checklist', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                child: Column(
                  children: [
                    _buildChecklistItem('8 Hours Baseline Sleep Need Target', true),
                    const SizedBox(height: 8.0),
                    _buildChecklistItem('Magnesium Glycinate Supplementation', true),
                    const SizedBox(height: 8.0),
                    _buildChecklistItem('15min Evening Mobility & Foam Rolling', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.titleMedium.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, bool isCompleted) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppColors.primaryEmerald : AppColors.textMuted,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              color: isCompleted ? AppColors.textPrimary : AppColors.textMuted,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }
}
