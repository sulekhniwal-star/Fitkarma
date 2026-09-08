import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/athletic_profiling_engine.dart';

class AthleticProfilingScreen extends ConsumerWidget {
  const AthleticProfilingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = AthleticProfilingEngine.evaluateAthleticProfile(
      completedWorkouts30Days: 18,
      scheduledWorkouts30Days: 20,
      currentStreakDays: 14,
      totalTonnage30Days: 42500.0,
      includesIndianTraditionalMovements: true,
    );

    final persona = report.primaryPersona;
    final personaColor = Color(persona.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Athletic Profile & Adherence',
          regionalText: 'एथलेटिक प्रोफाइल एवं निरंतरता सूचकांक',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Athletic Persona Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: personaColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Athletic Persona',
                          regionalText: persona.regionalTitle,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: personaColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: personaColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            persona.title.split('/')[0].trim().toUpperCase(),
                            style: TextStyle(color: personaColor, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Adherence',
                          value: '${report.adherenceScore}%',
                          unit: '30-Day',
                          isHero: true,
                          accentColor: personaColor,
                        ),
                        GlowingMetric(
                          label: 'Active Streak',
                          value: '${report.currentStreakDays}',
                          unit: 'days',
                          accentColor: AppColors.gold,
                        ),
                        GlowingMetric(
                          label: 'Sessions',
                          value: '${report.completedWorkouts30Days}/${report.scheduledWorkouts30Days}',
                          unit: 'done',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      persona.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      report.athleteSummary,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. 5-Vector Athletic Radar Matrix
              const Text(
                '5-VECTOR ATHLETIC RADAR (५-आयामी एथलेटिक रडार)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  children: report.radarVectors.map((vector) {
                    final double frac = (vector.score / 100.0).clamp(0.0, 1.0);
                    final Color vectorColor = vector.score >= 85
                        ? AppColors.karmaGreen
                        : (vector.score >= 70 ? AppColors.focusBlue : AppColors.energyOrange);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(vector.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
                                  Text(vector.regionalName, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${vector.score}%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: vectorColor)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: vectorColor.withValues(alpha: 0.12),
                                      borderRadius: AppRadii.radiusSm,
                                    ),
                                    child: Text(
                                      vector.status,
                                      style: TextStyle(fontSize: 9, color: vectorColor, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: frac,
                              backgroundColor: AppColors.surface,
                              valueColor: AlwaysStoppedAnimation<Color>(vectorColor),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Time-Crunched Anti-Quit Protocol
              BentoCard(
                backgroundColor: AppColors.surface,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flash_on_rounded, color: AppColors.gold, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time-Crunched Anti-Quit Protocol',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            report.timeCrunchedRecommendation,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
