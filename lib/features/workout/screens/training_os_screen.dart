import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/training_operating_system_engine.dart';

/// §P6-E Training Operating System (TOS) Screen
/// Route: /workout/tos
class TrainingOsScreen extends StatefulWidget {
  const TrainingOsScreen({super.key});

  @override
  State<TrainingOsScreen> createState() => _TrainingOsScreenState();
}

class _TrainingOsScreenState extends State<TrainingOsScreen> {
  final _engine = const TrainingOperatingSystemEngine();

  // Demo State
  final double _mhsScore = 82.0;
  final double _upperReadiness = 85.0;
  final double _lowerReadiness = 52.0;

  late MobilityReport _mobilityReport;
  late AsymmetryReport _asymmetryReport;
  late ProjectedPerformance _forecast;
  late MovementAgeProfile _movementProfile;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    final mob = _engine.diagnoseSquatPattern(
      setLogs: const [
        FormAnalysisResult(
            kneeValgusDetected: false,
            heelLiftDetected: true,
            squatDepthAngle: 75.0),
        FormAnalysisResult(
            kneeValgusDetected: true,
            heelLiftDetected: true,
            squatDepthAngle: 85.0),
        FormAnalysisResult(
            kneeValgusDetected: false,
            heelLiftDetected: true,
            squatDepthAngle: 72.0),
      ],
    );

    final asym = _engine.analyzeUnilateralRep(
      leftAngleDeg: 82.0,
      rightAngleDeg: 96.0,
      exerciseKey: 'single_leg_squat',
    );

    final fc = _engine.forecastStrength(
      historicWeights: const [75.0, 77.5, 80.0, 80.0],
      reliabilityScore: 90.0,
    );

    final age = _engine.calculateMovementAge(
      actualAge: 32,
      mhsScore: _mhsScore,
    );

    setState(() {
      _mobilityReport = mob;
      _asymmetryReport = asym;
      _forecast = fc;
      _movementProfile = age;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Training OS — TOS 5.0', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movement Health Score & Movement Age BentoCard
            BentoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Movement Health Score (MHS)',
                          style: AppTypography.bodySm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Movement Age: ${_movementProfile.movementAge} yrs',
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.teal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                      '${_movementProfile.movementHealthScore} / 100 (${_movementProfile.athleticTier})',
                      style: AppTypography.h1),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Synthesized across Mobility (25%), Stability (25%), Balance (15%), Coordination (15%), and Form Accuracy (20%).',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Segmented Local Muscle Readiness Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Segmented Local Muscle Readiness',
                      style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Upper Body', style: AppTypography.bodySm),
                          Text('${_upperReadiness.round()}%',
                              style: AppTypography.h2
                                  .copyWith(color: AppColors.success)),
                        ],
                      ),
                      Container(
                          width: 1, height: 35, color: AppColors.glassBorder),
                      Column(
                        children: [
                          Text('Lower Body', style: AppTypography.bodySm),
                          Text('${_lowerReadiness.round()}%',
                              style: AppTypography.h2
                                  .copyWith(color: AppColors.accent)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bg0,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Text(
                      '⚡ Smart Swap Suggestion: Readiness overall is high, but your legs need recovery. Swap Leg Day with Upper Body Day to maximize training capacity.',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.accent, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Level 3 Mobility Diagnosis & Correctives Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mobility Diagnosis & Correctives',
                          style: AppTypography.h3),
                      Text('Index: ${_mobilityReport.mobilityIndex}/100',
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                      'Identified Faults: ${_mobilityReport.identifiedIssues.join(", ")}',
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.accent)),
                  const SizedBox(height: 6),
                  Text('Prescribed Warm-up Drills:',
                      style:
                          AppTypography.bodySm.copyWith(color: AppColors.teal)),
                  for (final drill in _mobilityReport.prescribedDrills)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              size: 14, color: AppColors.teal),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(drill, style: AppTypography.bodySm)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Advanced Biomechanics — Movement Asymmetry & Forecasting Card
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Biomechanical Asymmetry & Forecasting',
                      style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.accent, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(_asymmetryReport.recommendedAdjustment,
                            style: AppTypography.bodySm
                                .copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('12-Week Performance Projection:',
                      style: AppTypography.labelLg),
                  const SizedBox(height: 4),
                  Text(_forecast.forecastSummary,
                      style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary, height: 1.3)),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
