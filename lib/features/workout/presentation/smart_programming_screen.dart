import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/smart_programming_engine.dart';
import '../domain/workout_models.dart';

class SmartProgrammingScreen extends ConsumerStatefulWidget {
  const SmartProgrammingScreen({super.key});

  @override
  ConsumerState<SmartProgrammingScreen> createState() =>
      _SmartProgrammingScreenState();
}

class _SmartProgrammingScreenState
    extends ConsumerState<SmartProgrammingScreen> {
  int _currentWeek = 2;
  double _simulatedRpe = 8.5;

  final Map<MuscleGroup, int> _mockWeeklySets = {
    MuscleGroup.chest: 14,
    MuscleGroup.back: 16,
    MuscleGroup.quads: 12,
    MuscleGroup.hamstrings: 10,
    MuscleGroup.shoulders: 15,
    MuscleGroup.arms: 12,
  };

  @override
  Widget build(BuildContext context) {
    final report = SmartProgrammingEngine.evaluateProgramming(
      weeklySetsPerMuscle: _mockWeeklySets,
      weekNumber: _currentWeek,
      recentSetRpe: _simulatedRpe,
    );

    final phase = report.currentPhase;
    final phaseColor = phase == MesocyclePhase.accumulation
        ? AppColors.karmaGreen
        : (phase == MesocyclePhase.intensification
            ? AppColors.energyOrange
            : AppColors.aiPurple);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Smart Programming & Overload',
          regionalText: 'स्मार्ट प्रोग्रामिंग एवं वॉल्यूम प्रबंधन',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Mesocycle Phase Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: phaseColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: '6-Week Mesocycle Wave',
                          regionalText: phase.regionalName,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: phaseColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color: phaseColor.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            phase.name.toUpperCase(),
                            style: TextStyle(
                                color: phaseColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Timeline',
                          value: 'Week $_currentWeek',
                          unit: 'of 6',
                          isHero: true,
                          accentColor: phaseColor,
                        ),
                        GlowingMetric(
                          label: 'Target RPE',
                          value: phase.rpeTargetRange,
                          unit: 'intensity',
                          accentColor: AppColors.focusBlue,
                        ),
                        GlowingMetric(
                          label: 'Volume Pacing',
                          value:
                              '${(phase.volumeModifierPercent * 100).toInt()}%',
                          unit: 'of max',
                          accentColor: AppColors.energyOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      phase.focus,
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

              // 2. Interactive Week Selector & Auto-Regulation RPE Calculator
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Simulate Mesocycle Week',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.textPrimary),
                        ),
                        Text(
                          'Week $_currentWeek',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: phaseColor),
                        ),
                      ],
                    ),
                    Slider(
                      value: _currentWeek.toDouble(),
                      min: 1.0,
                      max: 6.0,
                      divisions: 5,
                      activeColor: phaseColor,
                      onChanged: (val) =>
                          setState(() => _currentWeek = val.round()),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Auto-Regulate RPE on Last Set',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.textPrimary),
                        ),
                        Text(
                          'RPE ${_simulatedRpe.toStringAsFixed(1)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: AppColors.focusBlue),
                        ),
                      ],
                    ),
                    Slider(
                      value: _simulatedRpe,
                      min: 6.0,
                      max: 10.0,
                      divisions: 8,
                      activeColor: AppColors.focusBlue,
                      onChanged: (val) => setState(() => _simulatedRpe = val),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadii.radiusSm,
                        border: Border.all(
                            color: AppColors.focusBlue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.tune_rounded,
                              color: AppColors.focusBlue, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.autoRegulation.directiveTitle,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: AppColors.textPrimary),
                                ),
                                Text(
                                  report.autoRegulation.rationale,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Volume Landmark Intelligence (MEV -> MAV -> MRV)
              const Text(
                'VOLUME LANDMARKS (MEV → MAV → MRV सीमाएं)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.volumeLandmarks.map((lm) {
                final double progressFrac =
                    (lm.currentWeeklySets / lm.mrv).clamp(0.0, 1.0);
                final Color zoneColor = Color(lm.zone.colorCode);

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
                            Text(
                              lm.muscle.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textPrimary),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: zoneColor.withValues(alpha: 0.15),
                                borderRadius: AppRadii.radiusSm,
                                border: Border.all(
                                    color: zoneColor.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                lm.zone.label.split('(')[0].trim(),
                                style: TextStyle(
                                    color: zoneColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Current: ${lm.currentWeeklySets} sets',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: zoneColor)),
                            Text(
                              'MEV: ${lm.mev} • MAV: ${lm.mav} • MRV: ${lm.mrv} sets',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progressFrac,
                            backgroundColor: AppColors.surface,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(zoneColor),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lm.programmingAdvice,
                          style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              height: 1.2),
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
