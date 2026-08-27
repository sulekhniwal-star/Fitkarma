import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/circadian_environmental_engine.dart';

class CircadianEnvironmentalScreen extends StatelessWidget {
  final int aqi;
  final double temperatureCelsius;
  final double relativeHumidityPercent;
  final double uvIndex;

  const CircadianEnvironmentalScreen({
    super.key,
    this.aqi = 95,
    this.temperatureCelsius = 33.0,
    this.relativeHumidityPercent = 68.0,
    this.uvIndex = 7.0,
  });

  @override
  Widget build(BuildContext context) {
    final report = CircadianEnvironmentalEngine.evaluateDailyEnvironment(
      currentTime: DateTime.now(),
      aqi: aqi,
      temperatureCelsius: temperatureCelsius,
      relativeHumidityPercent: relativeHumidityPercent,
      uvIndex: uvIndex,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Circadian & Environmental Health',
          regionalText: 'दिनचर्या एवं पर्यावरणीय स्वास्थ्य',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Current Phase Hero Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.focusBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: AppColors.focusBlue, size: 20),
                        SizedBox(width: 8),
                        BilingualLabel(
                          primaryText: 'Current Circadian State',
                          regionalText: 'वर्तमान जैविक घड़ी स्थिति',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.currentPhaseSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center_rounded, color: AppColors.karmaGreen, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              report.workoutTimingRecommendation,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.karmaGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. Environmental Heat & AQI Stress Metrics
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualLabel(
                      primaryText: 'Local Environmental Factors',
                      regionalText: 'स्थानीय वायु एवं तापमान प्रभाव',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'AQI Level',
                          value: '${report.environmentalSnapshot.aqi}',
                          unit: report.environmentalSnapshot.aqiCategory.name.toUpperCase(),
                          accentColor: report.environmentalSnapshot.aqi > 200 ? AppColors.alertRed : AppColors.karmaGreen,
                        ),
                        GlowingMetric(
                          label: 'Heat Index',
                          value: '${report.environmentalSnapshot.heatIndexC.round()}°C',
                          unit: 'Feels like',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Extra Water',
                          value: '+${report.recommendedExtraHydrationMl}',
                          unit: 'ml/day',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Circadian Milestones Timeline
              const Text(
                "TODAY'S CIRCADIAN TIMELINE (दैनिक चक्र)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: report.milestones.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final milestone = report.milestones[index];

                  return BentoCard(
                    hasGlow: milestone.isCurrent,
                    glowColor: AppColors.focusBlue,
                    backgroundColor: milestone.isCurrent ? AppColors.surfaceElevated : AppColors.surface,
                    border: Border.all(
                      color: milestone.isCurrent ? AppColors.focusBlue : AppColors.glassBorder,
                      width: milestone.isCurrent ? 1.5 : 1.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (milestone.isCurrent ? AppColors.focusBlue : AppColors.textSecondary).withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Icon(
                            _getMilestoneIcon(milestone.iconCode),
                            color: milestone.isCurrent ? AppColors.focusBlue : AppColors.textSecondary,
                            size: 20,
                          ),
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
                                    milestone.title,
                                    style: AppTypography.titleSmall.copyWith(
                                      color: milestone.isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    milestone.timeWindow,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: milestone.isCurrent ? AppColors.focusBlue : AppColors.textMuted,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                milestone.regionalTitle,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                milestone.guidance,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMilestoneIcon(int iconCode) {
    switch (iconCode) {
      case 0xe6e1:
        return Icons.wb_sunny_rounded;
      case 0xe0c8:
        return Icons.local_cafe_rounded;
      case 0xe28d:
        return Icons.fitness_center_rounded;
      case 0xe42b:
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }
}
