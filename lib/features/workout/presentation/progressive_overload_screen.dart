import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/progressive_overload_engine.dart';
import '../providers/workout_provider.dart';

class ProgressiveOverloadScreen extends ConsumerStatefulWidget {
  const ProgressiveOverloadScreen({super.key});

  @override
  ConsumerState<ProgressiveOverloadScreen> createState() => _ProgressiveOverloadScreenState();
}

class _ProgressiveOverloadScreenState extends ConsumerState<ProgressiveOverloadScreen> {
  double _simulatedReadinessScore = 85.0;

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutProvider);
    final session = workoutState.todaysSession;

    final prescriptions = session.plannedExercises.map((planned) {
      return ProgressiveOverloadEngine.computeOverloadPrescription(
        exercise: planned.exercise,
        recentCompletedSets: planned.completedSets,
        targetRepsMin: planned.targetRepsMin,
        targetRepsMax: planned.targetRepsMax,
        readinessScore: _simulatedReadinessScore,
      );
    }).toList();

    final primaryPrescription = prescriptions.isNotEmpty ? prescriptions.first : null;
    final primaryColor = primaryPrescription != null
        ? Color(primaryPrescription.recommendedAction.colorCode)
        : AppColors.karmaGreen;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Progressive Overload Engine',
          regionalText: 'प्रगतिशील भार एवं शक्ति वृद्धि तंत्र',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero 1RM & Overload Action Bento Card
              if (primaryPrescription != null) ...[
                BentoCard(
                  hasGlow: true,
                  glowColor: primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BilingualLabel(
                            primaryText: '${primaryPrescription.exercise.name} Overload Status',
                            regionalText: primaryPrescription.recommendedAction.regionalLabel,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.15),
                              borderRadius: AppRadii.radiusSm,
                              border: Border.all(color: primaryColor.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              primaryPrescription.recommendedAction.label.toUpperCase(),
                              style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GlowingMetric(
                            label: 'Estimated 1RM',
                            value: '${primaryPrescription.estimated1RmKg}',
                            unit: 'kg max',
                            isHero: true,
                            accentColor: primaryColor,
                          ),
                          GlowingMetric(
                            label: 'Next Target',
                            value: '${primaryPrescription.nextTargetWeightKg}',
                            unit: 'kg load',
                            accentColor: AppColors.energyOrange,
                          ),
                          GlowingMetric(
                            label: 'Rep Target',
                            value: '${primaryPrescription.nextTargetRepsMin}-${primaryPrescription.nextTargetRepsMax}',
                            unit: 'reps',
                            accentColor: AppColors.focusBlue,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        primaryPrescription.overloadRationale,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // 2. Interactive Readiness Simulation Slider
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Readiness Score Calibration',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                        ),
                        Text(
                          '${_simulatedReadinessScore.round()}% (${_simulatedReadinessScore >= 80 ? "Optimal" : (_simulatedReadinessScore >= 60 ? "Moderate" : "Deload Zone")})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: _simulatedReadinessScore >= 80
                                ? AppColors.karmaGreen
                                : (_simulatedReadinessScore >= 60 ? AppColors.focusBlue : AppColors.alertRed),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _simulatedReadinessScore,
                      min: 30.0,
                      max: 100.0,
                      divisions: 14,
                      activeColor: _simulatedReadinessScore >= 80 ? AppColors.karmaGreen : AppColors.energyOrange,
                      onChanged: (val) => setState(() => _simulatedReadinessScore = val),
                    ),
                    const Text(
                      'Low readiness (<50%) automatically triggers nervous system deload prescriptions (-20% load).',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Exercise-by-Exercise Double Progression Matrix
              const Text(
                'DOUBLE PROGRESSION MATRIX (द्वि-चरणीय प्रगति विश्लेषण)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...prescriptions.map((presc) {
                final Color actionColor = Color(presc.recommendedAction.colorCode);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    presc.exercise.name,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    presc.exercise.regionalName,
                                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: actionColor.withValues(alpha: 0.15),
                                borderRadius: AppRadii.radiusSm,
                                border: Border.all(color: actionColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                presc.recommendedAction.label,
                                style: TextStyle(color: actionColor, fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Current vs Next Load Comparison
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadii.radiusSm,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('CURRENT WORKING SET', style: TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w700)),
                                  Text(
                                    '${presc.currentWorkingWeightKg} kg × ${presc.currentReps} reps',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_rounded, color: AppColors.karmaGreen, size: 18),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('NEXT OVERLOAD TARGET', style: TextStyle(fontSize: 9, color: AppColors.karmaGreen, fontWeight: FontWeight.w700)),
                                  Text(
                                    '${presc.nextTargetWeightKg} kg × ${presc.nextTargetRepsMin}-${presc.nextTargetRepsMax} reps',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.karmaGreen),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Technique & Rationale
                        Text(
                          presc.overloadRationale,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11, height: 1.3),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.psychology_outlined, color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Form Cue: ${presc.techniqueFocusCue}',
                                style: const TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
