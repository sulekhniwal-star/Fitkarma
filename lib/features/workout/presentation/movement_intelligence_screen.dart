import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/movement_intelligence_engine.dart';
import '../providers/workout_provider.dart';

class MovementIntelligenceScreen extends ConsumerWidget {
  const MovementIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);
    final report = MovementIntelligenceEngine.evaluateMovementSymmetry(
      weeklySessions: workoutState.weeklySchedule,
    );

    final scoreColor = report.overallMovementQualityScore >= 80
        ? AppColors.karmaGreen
        : (report.overallMovementQualityScore >= 60 ? AppColors.focusBlue : AppColors.alertRed);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Movement Intelligence Platform',
          regionalText: 'बायोमेकेनिकल संतुलन एवं गति विश्लेषण',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Movement Quality & Symmetry Score Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: scoreColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: 'Biomechanical Balance Index',
                          regionalText: 'संरचनात्मक समरूपता सूचकांक',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: scoreColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'SYMMETRY GRADE A',
                            style: TextStyle(color: scoreColor, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Balance Score',
                          value: '${report.overallMovementQualityScore}',
                          unit: '/ 100',
                          isHero: true,
                          accentColor: scoreColor,
                        ),
                        GlowingMetric(
                          label: 'Push : Pull',
                          value: '${report.pushToPullRatio}',
                          unit: 'ratio',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Squat : Hinge',
                          value: '${report.quadToHamstringRatio}',
                          unit: 'ratio',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.structuralBalanceSummary,
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

              // 2. Fundamental Movement Pattern Distribution
              const Text(
                '7 FUNDAMENTAL MOVEMENT PATTERNS (७ मूलभूत व्यायाम प्रारूप)',
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
                  children: FundamentalMovementPattern.values.map((pattern) {
                    final int sets = report.patternWeeklySets[pattern] ?? 0;
                    final double frac = (sets / 16.0).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pattern.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
                                  Text(pattern.regionalName, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ],
                              ),
                              Text('$sets sets / wk', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.karmaGreen)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: frac,
                              backgroundColor: AppColors.surface,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.karmaGreen),
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Biomechanical Diagnoses
              const Text(
                'STRUCTURAL DIAGNOSTICS & JOINT SAFETY (जोड़ों की सुरक्षा रिपोर्ट)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.biomechanicalDiagnoses.map((diag) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.karmaGreen, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            diag,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.md),

              // 4. Corrective Movement Prep & Akhara Flow
              const Text(
                'CORRECTIVE WARMUP & AKHARA FLOW (पारंपरिक वार्मअप प्रोटोकॉल)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.correctiveWarmupPrescriptions.map((presc) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.sports_kabaddi_rounded, color: AppColors.energyOrange, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            presc,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
                          ),
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
