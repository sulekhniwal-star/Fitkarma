import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_radii.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../data/exercise_database.dart';
import '../domain/biomechanics_trajectory_engine.dart';

class BiomechanicsTrajectoryScreen extends ConsumerStatefulWidget {
  const BiomechanicsTrajectoryScreen({super.key});

  @override
  ConsumerState<BiomechanicsTrajectoryScreen> createState() => _BiomechanicsTrajectoryScreenState();
}

class _BiomechanicsTrajectoryScreenState extends ConsumerState<BiomechanicsTrajectoryScreen> {
  AnthropometricLimbProfile _selectedProfile = AnthropometricLimbProfile.longFemurs;
  int _simulatedAdherence = 90;

  @override
  Widget build(BuildContext context) {
    final primaryExercises = [
      ExerciseDatabase.exercises[0], // Bench Press
      ExerciseDatabase.exercises[5], // Squat
      ExerciseDatabase.exercises[7], // RDL
      ExerciseDatabase.exercises[2], // Desi Dand
    ];

    final Map<String, double> current1RmMap = {
      'ex_barbell_bench_press': 80.0,
      'ex_barbell_back_squat': 105.0,
      'ex_romanian_deadlift': 120.0,
      'ex_hindu_pushups': 35.0,
    };

    final report = BiomechanicsTrajectoryEngine.calculateTrajectoryProjections(
      primaryExercises: primaryExercises,
      current1RmMap: current1RmMap,
      adherencePercentage: _simulatedAdherence,
      profile: _selectedProfile,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Biomechanics & Strength Trajectory',
          regionalText: 'बायोमेकेनिक्स एवं भविष्य शक्ति अनुमान',
          alignment: CrossAxisAlignment.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero 6-Month Projection Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.karmaGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BilingualLabel(
                          primaryText: '6-Month Projection Curve',
                          regionalText: '६-माह शक्ति एवं मांसपेशी अनुमान',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.karmaGreen.withValues(alpha: 0.15),
                            borderRadius: AppRadii.radiusSm,
                            border: Border.all(color: AppColors.karmaGreen.withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            'CONFIDENCE 94%',
                            style: TextStyle(color: AppColors.karmaGreen, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GlowingMetric(
                          label: 'Lean Muscle Gain',
                          value: '+${report.projectedLeanMassGainKg6Months}',
                          unit: 'kg net',
                          isHero: true,
                          accentColor: AppColors.karmaGreen,
                        ),
                        const GlowingMetric(
                          label: 'Strength Surge',
                          value: '+22.4%',
                          unit: '1RM load',
                          accentColor: AppColors.energyOrange,
                        ),
                        GlowingMetric(
                          label: 'Adherence',
                          value: '$_simulatedAdherence%',
                          unit: 'target',
                          accentColor: AppColors.focusBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.trajectoryConfidenceSummary,
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

              // 2. Anthropometric Lever Advisor Bento Card
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Anthropometric Lever Profile',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                        ),
                        DropdownButton<AnthropometricLimbProfile>(
                          value: _selectedProfile,
                          dropdownColor: AppColors.surfaceElevated,
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 12, color: AppColors.focusBlue, fontWeight: FontWeight.w700),
                          items: AnthropometricLimbProfile.values.map((p) {
                            return DropdownMenuItem(value: p, child: Text(p.title.split('/')[0].trim()));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedProfile = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadii.radiusSm,
                        border: Border.all(color: AppColors.focusBlue.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.accessibility_new_rounded, color: AppColors.focusBlue, size: 16),
                              const SizedBox(width: 6),
                              Text('Squat Stance Cue: ${_selectedProfile.title}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textPrimary)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _selectedProfile.squatSetupRecommendation,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Simulate 30-Day Adherence', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary)),
                        Text('$_simulatedAdherence%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.karmaGreen)),
                      ],
                    ),
                    Slider(
                      value: _simulatedAdherence.toDouble(),
                      min: 50.0,
                      max: 100.0,
                      divisions: 10,
                      activeColor: AppColors.karmaGreen,
                      onChanged: (val) => setState(() => _simulatedAdherence = val.round()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Compound Strength Milestones
              const Text(
                'LOGARITHMIC 1RM MILESTONES (प्रगतिशील शक्ति मील के पत्थर)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...report.strengthProjections.map((proj) {
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
                              proj.exercise.name,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                            ),
                            Text(
                              '+${proj.projectedVolumeTonnageGainPercent}% Gain',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.karmaGreen),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Milestone Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMilestonePill(label: 'Current 1RM', value: '${proj.current1RmKg} kg', color: AppColors.textPrimary),
                            _buildMilestonePill(label: '3 Months', value: '${proj.projected1Rm3MonthsKg} kg', color: AppColors.focusBlue),
                            _buildMilestonePill(label: '6 Months', value: '${proj.projected1Rm6MonthsKg} kg', color: AppColors.energyOrange),
                            _buildMilestonePill(label: '12 Months', value: '${proj.projected1Rm12MonthsKg} kg', color: AppColors.karmaGreen),
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

  Widget _buildMilestonePill({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusSm,
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}
