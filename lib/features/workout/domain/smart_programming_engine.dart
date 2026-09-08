import 'workout_models.dart';

enum MesocyclePhase {
  accumulation(
    name: 'Volume Accumulation',
    regionalName: 'वॉल्यूम संचय चरण (सप्ताह १-३)',
    focus: 'Hypertrophic volume ramp with progressive rep & load addition',
    rpeTargetRange: '7.5 – 8.5',
    volumeModifierPercent: 1.0,
  ),
  intensification(
    name: 'Strength Intensification',
    regionalName: 'तीव्रता एवं शक्ति वृद्धि (सप्ताह ४-५)',
    focus: 'Heavy load peaking, lower reps, maximum mechanical tension',
    rpeTargetRange: '8.5 – 9.5',
    volumeModifierPercent: 0.85,
  ),
  deload(
    name: 'Active Resensitization Deload',
    regionalName: 'सक्रिय डीलोड एवं पुनर्प्राप्ति (सप्ताह ६)',
    focus: 'Volume reduction to clear CNS fatigue and restore joint health',
    rpeTargetRange: '6.0 – 7.0',
    volumeModifierPercent: 0.60,
  );

  final String name;
  final String regionalName;
  final String focus;
  final String rpeTargetRange;
  final double volumeModifierPercent;

  const MesocyclePhase({
    required this.name,
    required this.regionalName,
    required this.focus,
    required this.rpeTargetRange,
    required this.volumeModifierPercent,
  });
}

enum VolumeLandmarkZone {
  belowMev(label: 'Below MEV (Sub-stimulative)', colorCode: 0xff64748B),
  mevToMav(label: 'MEV → MAV (Optimal Growth Zone)', colorCode: 0xff22C55E),
  mavToMrv(label: 'MAV → MRV (High Volume Overreach)', colorCode: 0xff3B82F6),
  exceedingMrv(label: 'Exceeding MRV (Overtraining Risk)', colorCode: 0xffEF4444);

  final String label;
  final int colorCode;

  const VolumeLandmarkZone({
    required this.label,
    required this.colorCode,
  });
}

class MuscleVolumeLandmark {
  final MuscleGroup muscle;
  final int currentWeeklySets;
  final int mev; // Minimum Effective Volume
  final int mav; // Maximum Adaptive Volume
  final int mrv; // Maximum Recoverable Volume
  final VolumeLandmarkZone zone;
  final String programmingAdvice;

  const MuscleVolumeLandmark({
    required this.muscle,
    required this.currentWeeklySets,
    required this.mev,
    required this.mav,
    required this.mrv,
    required this.zone,
    required this.programmingAdvice,
  });
}

class AutoRegulationDirective {
  final double loggedRpe;
  final double loadAdjustmentPercent; // e.g. +5% or -5%
  final String directiveTitle;
  final String rationale;

  const AutoRegulationDirective({
    required this.loggedRpe,
    required this.loadAdjustmentPercent,
    required this.directiveTitle,
    required this.rationale,
  });
}

class SmartProgrammingReport {
  final MesocyclePhase currentPhase;
  final int currentWeekNumber;
  final int totalWeeksInCycle;
  final List<MuscleVolumeLandmark> volumeLandmarks;
  final AutoRegulationDirective autoRegulation;
  final String periodizationSummary;

  const SmartProgrammingReport({
    required this.currentPhase,
    required this.currentWeekNumber,
    required this.totalWeeksInCycle,
    required this.volumeLandmarks,
    required this.autoRegulation,
    required this.periodizationSummary,
  });
}

class SmartProgrammingEngine {
  /// Pure Dart deterministic calculation of Volume Landmarks (MEV/MAV/MRV) and Mesocycle Periodization
  static SmartProgrammingReport evaluateProgramming({
    required Map<MuscleGroup, int> weeklySetsPerMuscle,
    int weekNumber = 2,
    double recentSetRpe = 8.5,
  }) {
    final currentWeek = weekNumber.clamp(1, 6);
    final MesocyclePhase phase;

    if (currentWeek <= 3) {
      phase = MesocyclePhase.accumulation;
    } else if (currentWeek <= 5) {
      phase = MesocyclePhase.intensification;
    } else {
      phase = MesocyclePhase.deload;
    }

    // Evaluate Volume Landmarks for all primary muscle groups
    final List<MuscleVolumeLandmark> landmarks = [];

    for (final muscle in [
      MuscleGroup.chest,
      MuscleGroup.back,
      MuscleGroup.quads,
      MuscleGroup.hamstrings,
      MuscleGroup.shoulders,
      MuscleGroup.arms,
    ]) {
      final currentSets = weeklySetsPerMuscle[muscle] ?? 12;
      final mev = _getMev(muscle);
      final mav = _getMav(muscle);
      final mrv = _getMrv(muscle);

      final VolumeLandmarkZone zone;
      final String advice;

      if (currentSets < mev) {
        zone = VolumeLandmarkZone.belowMev;
        advice = 'Below maintenance stimulus. Add +2 sets next session.';
      } else if (currentSets <= mav) {
        zone = VolumeLandmarkZone.mevToMav;
        advice = 'Optimal growth zone. Maintain current progression rate.';
      } else if (currentSets <= mrv) {
        zone = VolumeLandmarkZone.mavToMrv;
        advice = 'High volume threshold. Prepare for upcoming deload.';
      } else {
        zone = VolumeLandmarkZone.exceedingMrv;
        advice = 'Exceeding recovery capacity. Trim 3-4 sets to avoid chronic joint inflammation.';
      }

      landmarks.add(MuscleVolumeLandmark(
        muscle: muscle,
        currentWeeklySets: currentSets,
        mev: mev,
        mav: mav,
        mrv: mrv,
        zone: zone,
        programmingAdvice: advice,
      ));
    }

    // Auto-Regulation calculation from logged RPE
    final autoReg = _calculateAutoRegulation(recentSetRpe);

    return SmartProgrammingReport(
      currentPhase: phase,
      currentWeekNumber: currentWeek,
      totalWeeksInCycle: 6,
      volumeLandmarks: landmarks,
      autoRegulation: autoReg,
      periodizationSummary: 'Currently in Week $currentWeek of 6 (${phase.name}). '
          'Targeting RPE ${phase.rpeTargetRange} with volume modifier at ${(phase.volumeModifierPercent * 100).toInt()}%.',
    );
  }

  static AutoRegulationDirective _calculateAutoRegulation(double rpe) {
    if (rpe < 7.0) {
      return const AutoRegulationDirective(
        loggedRpe: 6.5,
        loadAdjustmentPercent: 0.05,
        directiveTitle: 'Under-Stimulated: Increase Load +5%',
        rationale: 'RPE < 7.0 indicates 3+ Reps In Reserve (RIR). Elevate working load by +5% to hit target mechanical tension.',
      );
    } else if (rpe <= 9.0) {
      return AutoRegulationDirective(
        loggedRpe: rpe,
        loadAdjustmentPercent: 0.0,
        directiveTitle: 'Optimal RPE Sweet Spot (1–2 RIR)',
        rationale: 'RPE ${rpe.toStringAsFixed(1)} aligns with the hyper-productive hypertrophy zone. Maintain planned double progression.',
      );
    } else {
      return AutoRegulationDirective(
        loggedRpe: rpe,
        loadAdjustmentPercent: -0.05,
        directiveTitle: 'Near Failure (0 RIR): Hold Load',
        rationale: 'RPE ${rpe.toStringAsFixed(1)} reaches technical threshold. Avoid premature failure to keep systemic fatigue manageable.',
      );
    }
  }

  static int _getMev(MuscleGroup muscle) {
    switch (muscle) {
      case MuscleGroup.chest:
        return 8;
      case MuscleGroup.back:
        return 10;
      case MuscleGroup.quads:
        return 8;
      case MuscleGroup.hamstrings:
        return 6;
      case MuscleGroup.shoulders:
        return 8;
      case MuscleGroup.arms:
        return 6;
      case MuscleGroup.core:
      case MuscleGroup.fullBody:
        return 6;
    }
  }

  static int _getMav(MuscleGroup muscle) {
    switch (muscle) {
      case MuscleGroup.chest:
        return 14;
      case MuscleGroup.back:
        return 16;
      case MuscleGroup.quads:
        return 14;
      case MuscleGroup.hamstrings:
        return 12;
      case MuscleGroup.shoulders:
        return 16;
      case MuscleGroup.arms:
        return 12;
      case MuscleGroup.core:
      case MuscleGroup.fullBody:
        return 10;
    }
  }

  static int _getMrv(MuscleGroup muscle) {
    switch (muscle) {
      case MuscleGroup.chest:
        return 20;
      case MuscleGroup.back:
        return 22;
      case MuscleGroup.quads:
        return 20;
      case MuscleGroup.hamstrings:
        return 16;
      case MuscleGroup.shoulders:
        return 22;
      case MuscleGroup.arms:
        return 18;
      case MuscleGroup.core:
      case MuscleGroup.fullBody:
        return 14;
    }
  }
}
