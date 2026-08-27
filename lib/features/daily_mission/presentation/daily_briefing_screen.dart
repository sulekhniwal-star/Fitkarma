import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../health_os/presentation/health_os_briefing_card.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../../readiness_engine/presentation/readiness_gauge_card.dart';
import '../../readiness_engine/providers/readiness_provider.dart';
import '../domain/daily_mission.dart';
import '../providers/daily_mission_provider.dart';

class DailyBriefingScreen extends ConsumerStatefulWidget {
  const DailyBriefingScreen({super.key});

  @override
  ConsumerState<DailyBriefingScreen> createState() => _DailyBriefingScreenState();
}

class _DailyBriefingScreenState extends ConsumerState<DailyBriefingScreen> {
  int _sleepStars = 4;
  int _energyStars = 4;
  int _sorenessLevel = 20; // 0 - 100
  bool _checkInSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final dipAsync = ref.watch(dailyIntelligenceProvider);
    final readinessAsync = ref.watch(dailyReadinessProvider);
    final missionsAsync = ref.watch(dailyMissionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Daily Briefing',
          regionalText: 'दैनिक स्वास्थ्य रिपोर्ट',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Morning Check-In Ritual Card (if not yet completed today)
              if (!_checkInSubmitted) ...[
                _buildCheckInRitualCard(),
                const SizedBox(height: AppSpacing.md),
              ],

              // 2. Health OS Daily Briefing Card
              dipAsync.when(
                data: (package) => HealthOsBriefingCard(package: package),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading DIP: $err'),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Body Readiness Gauge
              readinessAsync.when(
                data: (readiness) => ReadinessGaugeCard(readiness: readiness),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4. Daily Missions Checklist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BilingualLabel(
                    primaryText: "Today's Missions",
                    regionalText: 'आज के दैनिक लक्ष्य',
                  ),
                  missionsAsync.when(
                    data: (missions) {
                      final completedCount = missions.where((m) => m.isCompleted).length;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.karmaGreen.withValues(alpha: 0.15),
                          borderRadius: AppRadii.radiusSm,
                        ),
                        child: Text(
                          '$completedCount / ${missions.length} DONE',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.karmaGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Missions List
              missionsAsync.when(
                data: (missions) => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return _buildMissionCard(mission);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading missions: $err'),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInRitualCard() {
    return BentoCard(
      hasGlow: true,
      glowColor: AppColors.focusBlue,
      backgroundColor: AppColors.surfaceElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_sunny_rounded, color: AppColors.focusBlue, size: 20),
              SizedBox(width: 8),
              BilingualLabel(
                primaryText: 'Morning Check-In Ritual',
                regionalText: 'सुबह का शारीरिक स्व-मूल्यांकन',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Sleep Quality Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sleep Quality (नींद)', style: AppTypography.bodySmall),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      index < _sleepStars ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.gold,
                      size: 24,
                    ),
                    onPressed: () => setState(() => _sleepStars = index + 1),
                  );
                }),
              ),
            ],
          ),

          // Energy / Mood Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Energy & Mood (ऊर्जा)', style: AppTypography.bodySmall),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: Icon(
                      index < _energyStars ? Icons.bolt_rounded : Icons.flash_off_rounded,
                      color: AppColors.energyOrange,
                      size: 24,
                    ),
                    onPressed: () => setState(() => _energyStars = index + 1),
                  );
                }),
              ),
            ],
          ),

          // Muscle Soreness Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Muscle Soreness (दर्द/जकड़न)', style: AppTypography.bodySmall),
              Text(
                '$_sorenessLevel%',
                style: AppTypography.bodySmall.copyWith(
                  color: _sorenessLevel > 50 ? AppColors.alertRed : AppColors.karmaGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.focusBlue,
              inactiveTrackColor: AppColors.surface,
              thumbColor: AppColors.focusBlue,
            ),
            child: Slider(
              value: _sorenessLevel.toDouble(),
              min: 0.0,
              max: 100.0,
              divisions: 20,
              onChanged: (val) => setState(() => _sorenessLevel = val.round()),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Submit Check-In Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.focusBlue,
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.radiusSm),
              ),
              onPressed: () {
                setState(() => _checkInSubmitted = true);
                // Trigger readiness refresh with subjective parameters
                ref.read(readinessRepositoryProvider).getDailyReadiness(
                      uid: ref.read(currentUserIdProvider),
                      dateStr: ref.read(selectedDateProvider),
                      somaticSorenessScore: _sorenessLevel,
                    );
              },
              child: const Text(
                'Calculate Readiness (तैयारी जांचें)',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(DailyMissionItem mission) {
    final IconData categoryIcon;
    final Color categoryColor;

    switch (mission.category) {
      case MissionCategory.steps:
        categoryIcon = Icons.directions_walk_rounded;
        categoryColor = AppColors.focusBlue;
        break;
      case MissionCategory.workout:
        categoryIcon = Icons.fitness_center_rounded;
        categoryColor = AppColors.karmaGreen;
        break;
      case MissionCategory.nutrition:
        categoryIcon = Icons.restaurant_rounded;
        categoryColor = AppColors.energyOrange;
        break;
      case MissionCategory.hydration:
        categoryIcon = Icons.water_drop_rounded;
        categoryColor = AppColors.focusBlue;
        break;
      case MissionCategory.recovery:
        categoryIcon = Icons.bedtime_rounded;
        categoryColor = AppColors.aiPurple;
        break;
    }

    return BentoCard(
      hasGlow: mission.isCompleted,
      glowColor: AppColors.karmaGreen,
      border: Border.all(
        color: mission.isCompleted ? AppColors.karmaGreen.withValues(alpha: 0.5) : AppColors.glassBorder,
      ),
      onTap: () {
        ref.read(dailyMissionsProvider.notifier).toggleMission(mission.id);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mission.title,
                      style: AppTypography.titleSmall.copyWith(
                        color: mission.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                        decoration: mission.isCompleted ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '+${mission.karmaReward} Karma',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  mission.targetSubtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mission.isCompleted ? AppColors.karmaGreen : Colors.transparent,
              border: Border.all(
                color: mission.isCompleted ? AppColors.karmaGreen : AppColors.glassBorder,
                width: 1.5,
              ),
            ),
            child: mission.isCompleted
                ? const Icon(Icons.check_rounded, size: 16, color: AppColors.textInverse)
                : null,
          ),
        ],
      ),
    );
  }
}
