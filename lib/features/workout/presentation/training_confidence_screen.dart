import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/training_confidence_engine.dart';
import '../providers/workout_provider.dart';

class TrainingConfidenceScreen extends ConsumerStatefulWidget {
  const TrainingConfidenceScreen({super.key});

  @override
  ConsumerState<TrainingConfidenceScreen> createState() =>
      _TrainingConfidenceScreenState();
}

class _TrainingConfidenceScreenState
    extends ConsumerState<TrainingConfidenceScreen> {
  bool _isLiveLogged = true;
  final double _readinessScore = 87.0;

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(workoutProvider);
    final session = workoutState.todaysSession;

    final report = TrainingConfidenceEngine.evaluateTrainingConfidence(
      session: session,
      readinessScore: _readinessScore,
      isRealTimeLogged: _isLiveLogged,
    );

    final Color tierColor = Color(report.tier.colorCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Training Confidence Shield',
          regionalText: 'प्रशिक्षण डेटा विश्वसनीयता सुरक्षा कवच',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Training Confidence Shield Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: tierColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Training OS Confidence',
                          regionalText: report.tier.regionalLabel,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tierColor.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(
                                color: tierColor.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shield_rounded,
                                  color: tierColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                report.tier.grade,
                                style: TextStyle(
                                    color: tierColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '• ${report.tier.label.split('/')[0].trim().toUpperCase()}',
                                style: TextStyle(
                                    color: tierColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Confidence',
                          value: '${report.compositeConfidenceScore}%',
                          unit: 'Score',
                          isHero: true,
                          accentColor: tierColor,
                        ),
                        GlowingMetric(
                          label: 'Readiness',
                          value: '${_readinessScore.round()}%',
                          unit: 'CNS match',
                          accentColor: AppColors.focusBlue,
                        ),
                        const GlowingMetric(
                          label: 'Shield Status',
                          value: 'Active',
                          unit: 'Verified',
                          accentColor: AppColors.karmaGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.executiveSummary,
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

              // 2. Interactive Logging Mode Switch
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Real-Time In-Gym Stopwatch Logging',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textPrimary),
                  ),
                  subtitle: const Text(
                    'Live set completion tracking prevents post-workout RPE memory decay (-35% uncertainty)',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  value: _isLiveLogged,
                  activeThumbColor: AppColors.karmaGreen,
                  onChanged: (val) => setState(() => _isLiveLogged = val),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. 4 Confidence Pillars Breakdown
              const Text(
                '4 TRAINING CONFIDENCE PILLARS (४ प्रशिक्षण आधार स्तंभ)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.pillars.map((pillar) {
                final double scoreFrac = (pillar.score / 100.0).clamp(0.0, 1.0);
                final Color pillarColor = pillar.score >= 80
                    ? AppColors.karmaGreen
                    : (pillar.score >= 60
                        ? AppColors.focusBlue
                        : (pillar.score >= 40
                            ? AppColors.gold
                            : AppColors.alertRed));

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
                                  Row(
                                    children: [
                                      Text(
                                        pillar.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 1),
                                        decoration: const BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: AppRadii.radiusSm,
                                        ),
                                        child: Text(
                                          '${(pillar.weight * 100).toInt()}% wt',
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: AppColors.textMuted,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    pillar.regionalName,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${pillar.score.round()}%',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: pillarColor),
                                ),
                                Text(
                                  pillar.status,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: pillarColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: scoreFrac,
                            backgroundColor: AppColors.surface,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(pillarColor),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pillar.diagnosticDetail,
                          style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              height: 1.3),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.bolt_rounded,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                pillar.optimizationGuidance,
                                style: const TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),

              // 4. Active Safeguard Calibrations
              const Text(
                'TRAINING SHIELD SAFEGUARDS (सक्रिय सुरक्षा उपाय)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.activeShieldCalibrations.map((calib) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BentoCard(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified_user_rounded,
                            color: AppColors.focusBlue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            calib,
                            style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary, height: 1.3),
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
