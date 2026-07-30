import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/daily_mission_provider.dart';

class DailyBriefingScreen extends ConsumerWidget {
  const DailyBriefingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionState = ref.watch(dailyMissionProvider);
    final readiness = missionState.readiness;
    final checkIn = missionState.checkIn;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily Briefing', style: AppTypography.displayLarge),
                      Text('Health OS Brain Context', style: AppTypography.bodyMedium),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.primaryCyan),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              GlassCard(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 140.0,
                          height: 140.0,
                          child: CircularProgressIndicator(
                            value: readiness.score / 100.0,
                            strokeWidth: 12.0,
                            backgroundColor: AppColors.bgSecondary,
                            color: readiness.score >= 75
                                ? AppColors.primaryEmerald
                                : (readiness.score >= 50
                                    ? AppColors.warningAmber
                                    : AppColors.errorRed),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${readiness.score}',
                              style: AppTypography.displayLarge.copyWith(fontSize: 44.0),
                            ),
                            Text('READINESS', style: AppTypography.labelSmall),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Chip(
                      backgroundColor: AppColors.glassBgMid,
                      side: const BorderSide(color: AppColors.glassBorder),
                      label: Text(readiness.confidenceLabel, style: AppTypography.labelSmall),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      readiness.adviceSummary,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              if (!checkIn.isCompleted)
                GlassCard(
                  onTap: () => _showMorningCheckInModal(context, ref),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny, color: AppColors.warningAmber, size: 28.0),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Morning Check-in Pending', style: AppTypography.titleMedium),
                            Text('3-question ritual to calibrate readiness', style: AppTypography.labelSmall),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    ],
                  ),
                ),
              if (!checkIn.isCompleted) const SizedBox(height: AppSpacing.lg),

              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily Strain (0–21)', style: AppTypography.titleMedium),
                        Text(
                          '${missionState.dailyStrain} / 21.0',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.primaryCyan),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: missionState.dailyStrain / 21.0,
                      backgroundColor: AppColors.bgSecondary,
                      color: AppColors.primaryCyan,
                      minHeight: 8.0,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text('Resolved Priority Actions', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              ...missionState.activeActions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GlassCard(
                    child: Row(
                      children: [
                        Icon(
                          action.isMandatoryRest ? Icons.warning_amber : Icons.check_circle_outline,
                          color: action.isMandatoryRest ? AppColors.errorRed : AppColors.primaryEmerald,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(action.title, style: AppTypography.titleMedium),
                              Text(action.description, style: AppTypography.bodyMedium),
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

  void _showMorningCheckInModal(BuildContext context, WidgetRef ref) {
    int energy = 7;
    int soreness = 3;
    int mood = 8;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSecondary,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Morning Check-in Ritual', style: AppTypography.displayLarge),
                  const SizedBox(height: AppSpacing.md),

                  Text('Energy Level (1-10): $energy', style: AppTypography.bodyMedium),
                  Slider(
                    value: energy.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.warningAmber,
                    onChanged: (val) => setModalState(() => energy = val.round()),
                  ),

                  Text('Muscle Soreness (1-10): $soreness', style: AppTypography.bodyMedium),
                  Slider(
                    value: soreness.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.errorRed,
                    onChanged: (val) => setModalState(() => soreness = val.round()),
                  ),

                  Text('Mood Rating (1-10): $mood', style: AppTypography.bodyMedium),
                  Slider(
                    value: mood.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.primaryEmerald,
                    onChanged: (val) => setModalState(() => mood = val.round()),
                  ),

                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryCyan,
                        foregroundColor: AppColors.bgPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                        ),
                      ),
                      onPressed: () {
                        ref.read(dailyMissionProvider.notifier).submitCheckIn(energy, soreness, mood);
                        Navigator.pop(context);
                      },
                      child: Text('Submit Check-in', style: AppTypography.titleMedium.copyWith(color: AppColors.bgPrimary)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
