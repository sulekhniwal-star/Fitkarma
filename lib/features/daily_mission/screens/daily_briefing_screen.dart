import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/readiness_engine.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/health_score_ring.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/insight_card.dart';
import '../providers/daily_mission_provider.dart';
import '../../lifestyle/providers/calendar_provider.dart';
import '../widgets/calendar_briefing_card.dart';

/// Daily Briefing Screen (§P2-B specification)
/// First morning screen reading entirely from Daily Intelligence Package (DIP).
class DailyBriefingScreen extends ConsumerWidget {
  const DailyBriefingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionState = ref.watch(dailyMissionProvider);
    final calendarState = ref.watch(calendarProvider);
    final readiness = missionState.readiness;
    final checkIn = missionState.checkIn;
    final dip = missionState.dip;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Section (320px height, heroDeep gradient background)
              _buildHeroSection(context, missionState),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Morning Check-In Banner (if check-in not completed)
                    if (!checkIn.isCompleted) ...[
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
                                  Text('3-question ritual to calibrate readiness (<30s)', style: AppTypography.labelMd),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // 2. Health Score Card
                    BentoCard(
                      child: Row(
                        children: [
                          HealthScoreRing(score: missionState.healthScore, size: 80.0),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Unified Health Score', style: AppTypography.h3),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.trending_up, color: AppColors.success, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '↑ ${missionState.healthScoreTrend} pts from yesterday',
                                      style: AppTypography.bodyMd.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text('Consistency improving', style: AppTypography.labelMd),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // §P12-F Calendar-Aware Daily Briefing Card
                    if (calendarState.isConnected && calendarState.insight != null) ...[
                      CalendarIntelligenceCard(insight: calendarState.insight!),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // 3. Today's Mission Card (reading from DIP only)
                    BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BilingualLabel(
                            englishText: "🎯 Today's Mission",
                            hindiText: 'आज का मिशन',
                            englishStyle: AppTypography.h2,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...dip.dailyMissions.map((mission) => _MissionItem(text: mission)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 4. Today's Focus Bento Grid
                    const Text("Today's Focus", style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.sm),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.5,
                      children: [
                        _FocusTile(
                          icon: Icons.bedtime_outlined,
                          iconColor: AppColors.secondary,
                          label: 'Sleep Debt',
                          value: '${missionState.sleepDebtMin} min',
                        ),
                        _FocusTile(
                          icon: Icons.bolt,
                          iconColor: AppColors.accent,
                          label: 'Energy',
                          value: checkIn.energyLevel >= 4 ? 'High' : (checkIn.energyLevel >= 3 ? 'Moderate' : 'Low'),
                        ),
                        _FocusTile(
                          icon: Icons.local_fire_department,
                          iconColor: AppColors.primary,
                          label: 'Streak',
                          value: '${missionState.streakDays} days',
                        ),
                        _FocusTile(
                          icon: Icons.emoji_events,
                          iconColor: AppColors.teal,
                          label: 'Karma Today',
                          value: '+${missionState.karmaXpTarget} XP target',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // 5. AI Coach Insight (from DIP)
                    InsightCard(
                      title: 'Health OS Brain Focus',
                      description: dip.primaryFocus,
                    ),
                    const SizedBox(height: AppSpacing.md),


                    // 6. Conditional Recovery Alert (if readiness < 55 or medical risk active)
                    if (readiness.score < 55 || missionState.medicalRiskActive) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Decision Hierarchy: Recovery Priority',
                                    style: AppTypography.h3.copyWith(color: AppColors.error),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    missionState.medicalRiskActive
                                        ? 'Medical alarm active. Mandatory rest day prescribed.'
                                        : 'Readiness ${readiness.score}/100. Lower intensity & prioritize recovery.',
                                    style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // 7. Quick Actions
                    const Text('Quick Actions', style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.restaurant, size: 18),
                            label: const Text('Log Meal'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.bg0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: const Text('Start Workout'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.teal,
                              side: const BorderSide(color: AppColors.teal),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.water_drop, size: 18),
                            label: const Text('Log Water'),
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
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, DailyMissionState state) {
    final readiness = state.readiness;

    return Container(
      width: double.infinity,
      height: 320.0,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1435), Color(0xFF0F0F1A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Good morning, ${state.userName} 👋',
            style: AppTypography.displayMd.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),

          // ReadinessRing (128px)
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 128.0,
                height: 128.0,
                child: CircularProgressIndicator(
                  value: readiness.score / 100.0,
                  strokeWidth: 10.0,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.surface2,
                  color: readiness.score >= 75
                      ? AppColors.success
                      : (readiness.score >= 50 ? AppColors.warning : AppColors.error),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${readiness.score}',
                    style: AppTypography.displayLg.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'READINESS',
                    style: AppTypography.labelMd.copyWith(
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Score + Confidence Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface1,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              '${readiness.zone.displayName} · ${readiness.confidenceLabel} — ${readiness.adviceSummary}',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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

                  const Text('1. How did you sleep?', style: AppTypography.h3),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < sleep ? Icons.star : Icons.star_border,
                          color: AppColors.accent,
                          size: 28,
                        ),
                        onPressed: () => setModalState(() => sleep = index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  const Text('2. How sore are you?', style: AppTypography.h3),
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

                  Text('3. Stress level today? ($stress/5)', style: AppTypography.h3),
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
                      child: Text(
                        'COMPLETE CHECK-IN',
                        style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold, color: AppColors.bg0),
                      ),
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

class _FocusTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _FocusTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface0,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Text(label, style: AppTypography.labelMd.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.h2.copyWith(color: AppColors.textPrimary)),
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
        selectedColor: AppColors.primary.withValues(alpha: 0.3),
        labelStyle: AppTypography.labelMd.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

