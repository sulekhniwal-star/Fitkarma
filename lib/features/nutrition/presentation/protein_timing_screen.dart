import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/protein_timing_engine.dart';
import '../providers/nutrition_provider.dart';

class ProteinTimingScreen extends ConsumerWidget {
  const ProteinTimingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrition = ref.watch(nutritionProvider);
    final report = ProteinTimingEngine.evaluateProteinTiming(
      dailyProteinTarget: nutrition.targetProtein,
      loggedMeals: nutrition.loggedMeals,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Protein Distribution & MPS Timing',
          regionalText: 'प्रोटीन समय एवं मांसपेशी संश्लेषण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero MPS Triggers Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.energyOrange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Muscle Protein Synthesis (MPS)',
                          regionalText: 'दैनिक मांसपेशी संश्लेषण चक्र',
                        ),
                        Icon(Icons.bolt_rounded, color: AppColors.energyOrange, size: 22),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'MPS Triggers',
                          value: '${report.totalMpsTriggersAchieved}',
                          unit: '/ ${report.totalMpsTriggersTarget} today',
                          isHero: true,
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Total Protein',
                          value: '${report.dailyTotalProtein.round()}g',
                          unit: '/ ${nutrition.targetProtein}g',
                          accentColor: AppColors.karmaGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Distributing protein into 4 distinct ~30g boluses containing ≥2.5g leucine activates muscle synthesis far more effectively than backloading protein into dinner.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. 4-Bolus Timeline Stream
              const Text(
                '4-BOLUS TIMELINE (4-चरण प्रोटीन वितरण)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.boluses.map((bolus) {
                final isDone = bolus.isMpsTriggered;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    hasGlow: isDone,
                    glowColor: AppColors.karmaGreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: (isDone ? AppColors.karmaGreen : AppColors.surfaceElevated).withValues(alpha: 0.2),
                                    borderRadius: AppRadii.radiusSm,
                                  ),
                                  child: Icon(
                                    isDone ? Icons.check_circle_rounded : Icons.schedule_rounded,
                                    color: isDone ? AppColors.karmaGreen : AppColors.textMuted,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(bolus.phase.name, style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
                                    Text(bolus.timingLabel, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (isDone ? AppColors.karmaGreen : AppColors.focusBlue).withValues(alpha: 0.15),
                                borderRadius: AppRadii.radiusSm,
                              ),
                              child: Text(
                                isDone ? 'MPS TRIGGERED' : 'PENDING BOLUS',
                                style: TextStyle(
                                  color: isDone ? AppColors.karmaGreen : AppColors.focusBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Protein: ${bolus.currentProteinGrams}g / ${bolus.targetProteinGrams}g target',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Leucine: ~${bolus.estimatedLeucineGrams}g',
                              style: TextStyle(
                                fontSize: 11,
                                color: bolus.estimatedLeucineGrams >= 2.2 ? AppColors.karmaGreen : AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: (bolus.currentProteinGrams / bolus.targetProteinGrams).clamp(0.0, 1.0),
                          backgroundColor: AppColors.surfaceElevated,
                          valueColor: AlwaysStoppedAnimation(isDone ? AppColors.karmaGreen : AppColors.energyOrange),
                          minHeight: 4,
                          borderRadius: AppRadii.radiusSm,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // 3. Indian Plant Protein Amino Acid Pairing Card
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.grain_rounded, color: AppColors.focusBlue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Indian Amino Acid Pairing (अमीनो एसिड संतुलन)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(report.aminoAcidPairingNote, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // 4. Peri-Workout Anabolic Window Card
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.fitness_center_rounded, color: AppColors.energyOrange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Peri-Workout Anabolic Protocol (वर्कआउट पोषण प्रोटोकॉल)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(report.periWorkoutPrescription, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3)),
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
