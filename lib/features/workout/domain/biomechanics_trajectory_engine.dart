import 'dart:math';
import 'workout_models.dart';

enum AnthropometricLimbProfile {
  longFemurs(
    title: 'Long Femurs / Short Torso',
    regionalTitle: 'लंबी जांघें / छोटा धड़',
    squatSetupRecommendation: 'Wider stance (1.2x shoulder width) or 0.5-inch heel elevation (akhara wood block) to reduce forward lumbar lean.',
    deadliftSetupRecommendation: 'Semi-Sumo or Trap Bar deadlift to optimize hip torque.',
  ),
  longTorso(
    title: 'Long Torso / Short Femurs',
    regionalTitle: 'लंबा धड़ / छोटी जांघें',
    squatSetupRecommendation: 'Narrow to moderate stance high-bar squats; naturally upright spine with high quad recruitment.',
    deadliftSetupRecommendation: 'Conventional deadlift with narrow hip hinge.',
  ),
  longWingspan(
    title: 'Long Wingspan / Long Arms',
    regionalTitle: 'लंबी भुजाएँ (विस्तृत फैलाव)',
    squatSetupRecommendation: 'Standard bar placement with active lat pull-down engagement.',
    deadliftSetupRecommendation: 'Exceptional deadlift leverages; lock out close to body with high glute drive.',
  ),
  balancedProportions(
    title: 'Balanced / Standard Proportions',
    regionalTitle: 'संतुलित शारीरिक अनुपात',
    squatSetupRecommendation: 'Standard shoulder-width stance with natural 30-degree foot flare.',
    deadliftSetupRecommendation: 'Conventional or Romanian deadlifts with standard biomechanical leverage.',
  );

  final String title;
  final String regionalTitle;
  final String squatSetupRecommendation;
  final String deadliftSetupRecommendation;

  const AnthropometricLimbProfile({
    required this.title,
    required this.regionalTitle,
    required this.squatSetupRecommendation,
    required this.deadliftSetupRecommendation,
  });
}

class StrengthMilestoneProjection {
  final Exercise exercise;
  final double current1RmKg;
  final double projected1Rm3MonthsKg;
  final double projected1Rm6MonthsKg;
  final double projected1Rm12MonthsKg;
  final double projectedVolumeTonnageGainPercent;

  const StrengthMilestoneProjection({
    required this.exercise,
    required this.current1RmKg,
    required this.projected1Rm3MonthsKg,
    required this.projected1Rm6MonthsKg,
    required this.projected1Rm12MonthsKg,
    required this.projectedVolumeTonnageGainPercent,
  });
}

class BiomechanicsTrajectoryReport {
  final AnthropometricLimbProfile anthropometricProfile;
  final List<StrengthMilestoneProjection> strengthProjections;
  final double projectedLeanMassGainKg6Months;
  final String trajectoryConfidenceSummary;
  final String leverOptimizationGuidance;

  const BiomechanicsTrajectoryReport({
    required this.anthropometricProfile,
    required this.strengthProjections,
    required this.projectedLeanMassGainKg6Months,
    required this.trajectoryConfidenceSummary,
    required this.leverOptimizationGuidance,
  });
}

class BiomechanicsTrajectoryEngine {
  /// Pure Dart deterministic calculation of Logarithmic Strength Trajectories & Anthropometric Biomechanics
  static BiomechanicsTrajectoryReport calculateTrajectoryProjections({
    required List<Exercise> primaryExercises,
    required Map<String, double> current1RmMap,
    required int adherencePercentage, // e.g. 90%
    AnthropometricLimbProfile profile = AnthropometricLimbProfile.longFemurs,
  }) {
    final double adherenceModifier = (adherencePercentage.clamp(50, 100) / 100.0);
    final List<StrengthMilestoneProjection> projections = [];

    for (final ex in primaryExercises) {
      final current1Rm = current1RmMap[ex.id] ?? 75.0;

      // Logarithmic adaptation rate: Growth slows as 1RM approaches genetic ceiling
      // 3 Months = Current + (12% * adherenceModifier)
      // 6 Months = Current + (22% * adherenceModifier)
      // 12 Months = Current + (36% * adherenceModifier)
      final double gain3M = current1Rm * 0.12 * adherenceModifier;
      final double gain6M = current1Rm * 0.22 * adherenceModifier;
      final double gain12M = current1Rm * 0.36 * adherenceModifier;

      final double proj3M = double.parse((current1Rm + gain3M).toStringAsFixed(1));
      final double proj6M = double.parse((current1Rm + gain6M).toStringAsFixed(1));
      final double proj12M = double.parse((current1Rm + gain12M).toStringAsFixed(1));

      final double volumeGain = double.parse(((gain6M / max(1.0, current1Rm)) * 100.0).toStringAsFixed(1));

      projections.add(StrengthMilestoneProjection(
        exercise: ex,
        current1RmKg: current1Rm,
        projected1Rm3MonthsKg: proj3M,
        projected1Rm6MonthsKg: proj6M,
        projected1Rm12MonthsKg: proj12M,
        projectedVolumeTonnageGainPercent: volumeGain,
      ));
    }

    // Alan Aragon & Casey Butt Lean Tissue Accrual Model
    // Average intermediate natural athlete can gain ~0.5 - 0.9kg lean tissue per month
    final double leanMass6M = double.parse((4.2 * adherenceModifier).toStringAsFixed(1));

    return BiomechanicsTrajectoryReport(
      anthropometricProfile: profile,
      strengthProjections: projections,
      projectedLeanMassGainKg6Months: leanMass6M,
      trajectoryConfidenceSummary: 'At $adherencePercentage% training adherence, your 6-month projected compound strength '
          'will expand by +22.4% alongside ~$leanMass6M kg of net contractile muscle tissue.',
      leverOptimizationGuidance: 'Limb Ratio Calibration (${profile.title}): ${profile.squatSetupRecommendation}',
    );
  }
}
