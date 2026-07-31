import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/health_score_ring.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../providers/daily_mission_provider.dart';

class DailyBriefingScreen extends ConsumerWidget {
  const DailyBriefingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionState = ref.watch(dailyMissionProvider);
    final readiness = missionState.readiness;
    final checkIn = missionState.checkIn;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BilingualLabel(
                        englishText: 'Daily Briefing',
                        hindiText: 'दैनिक जानकारी',
                        englishStyle: AppTypography.displayMd,
                      ),
                      Text('Health OS Brain Context', style: AppTypography.bodySm),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              BentoCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const HealthScoreRing(score: 82, size: 100.0),
                        _buildReadinessDisplay(readiness),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      readiness.adviceSummary,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              if (!checkIn.isCompleted)
                BentoCard(
                  onTap: () => _showMorningCheckInModal(context, ref),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny_rounded, color: AppColors.warning, size: 28.0),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BilingualLabel(
                              englishText: 'Morning Check-in Pending',
                              hindiText: 'सुबह का चेक-इन बाकी है',
                              englishStyle: AppTypography.h2,
                            ),
                            Text('3-question ritual to calibrate readiness', style: AppTypography.labelMd),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    ],
                  ),
                ),
              if (!checkIn.isCompleted) const SizedBox(height: AppSpacing.md),

              const BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BilingualLabel(
                      englishText: "Today's Mission",
                      hindiText: 'आज का मिशन',
                      englishStyle: AppTypography.h2,
                    ),
                    SizedBox(height: 12),
                    _MissionItem(text: 'Hit 110g protein — you averaged 58g'),
                    _MissionItem(text: 'Morning-first workout: burn before celebrating'),
                    _MissionItem(text: 'Target 10,000 steps today'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Strain (0–21)', style: AppTypography.h2),
                        Text(
                          '${missionState.dailyStrain} / 21.0',
                          style: AppTypography.h1.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LinearProgressIndicator(
                      value: missionState.dailyStrain / 21.0,
                      backgroundColor: AppColors.surface2,
                      color: AppColors.primary,
                      minHeight: 8.0,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadinessDisplay(dynamic readiness) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: CircularProgressIndicator(
                value: readiness.score / 100.0,
                strokeWidth: 8.0,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.surface2,
                color: readiness.score >= 75 ? AppColors.success : (readiness.score >= 50 ? AppColors.warning : AppColors.error),
              ),
            ),
            Text('${readiness.score}', style: AppTypography.displayMd.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 4),
        Text('READINESS', style: AppTypography.labelMd.copyWith(letterSpacing: 1.0)),
      ],
    );
  }

  void _showMorningCheckInModal(BuildContext context, WidgetRef ref) {
    int sleep = 3;
    int soreness = 1;
    int stress = 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg1,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
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
                  const BilingualLabel(
                    englishText: 'Morning Check-in',
                    hindiText: 'सुबह का चेक-इन',
                    englishStyle: AppTypography.displayMd,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  const Text('How did you sleep?', style: AppTypography.h3),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < sleep ? Icons.star : Icons.star_border,
                          color: AppColors.accent,
                        ),
                        onPressed: () => setModalState(() => sleep = index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  const Text('How sore are you?', style: AppTypography.h3),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _SorenessOption(
                          label: 'Fresh',
                          isSelected: soreness == 1,
                          onTap: () => setModalState(() => soreness = 1),
                        ),
                        _SorenessOption(
                          label: 'Mild',
                          isSelected: soreness == 2,
                          onTap: () => setModalState(() => soreness = 2),
                        ),
                        _SorenessOption(
                          label: 'Moderate',
                          isSelected: soreness == 3,
                          onTap: () => setModalState(() => soreness = 3),
                        ),
                        _SorenessOption(
                          label: 'Very Sore',
                          isSelected: soreness == 4,
                          onTap: () => setModalState(() => soreness = 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Text('Stress level today? ($stress/5)', style: AppTypography.h3),
                  Slider(
                    value: stress.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setModalState(() => stress = val.round()),
                  ),

                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.bg0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      onPressed: () {
                        ref.read(dailyMissionProvider.notifier).submitCheckIn(sleep, soreness, stress);
                        Navigator.pop(context);
                      },
                      child: Text('COMPLETE CHECK-IN', style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold, color: AppColors.bg0)),
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

class _MissionItem extends StatelessWidget {
  final String text;
  const _MissionItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.bodyMd)),
        ],
      ),
    );
  }
}

class _SorenessOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SorenessOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withOpacity(0.3),
        labelStyle: AppTypography.labelMd.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
