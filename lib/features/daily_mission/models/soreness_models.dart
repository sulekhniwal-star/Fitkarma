/// Muscle Groups & Soreness Models per §P2-C spec
enum MuscleGroup {
  shoulders,
  chest,
  abs,
  quads,
  arms,
  lowerBack,
  glutes,
  hamstrings,
}

extension MuscleGroupExtension on MuscleGroup {
  String get displayName {
    switch (this) {
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.abs:
        return 'Abs';
      case MuscleGroup.quads:
        return 'Quads';
      case MuscleGroup.arms:
        return 'Arms';
      case MuscleGroup.lowerBack:
        return 'Lower Back';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.hamstrings:
        return 'Hamstrings';
    }
  }

  bool get isAnterior {
    switch (this) {
      case MuscleGroup.shoulders:
      case MuscleGroup.chest:
      case MuscleGroup.abs:
      case MuscleGroup.quads:
      case MuscleGroup.arms:
        return true;
      case MuscleGroup.lowerBack:
      case MuscleGroup.glutes:
      case MuscleGroup.hamstrings:
        return false;
    }
  }
}

enum SorenessSeverity { none, mild, moderate, severe }

extension SorenessSeverityExtension on SorenessSeverity {
  SorenessSeverity next() {
    switch (this) {
      case SorenessSeverity.none:
        return SorenessSeverity.mild;
      case SorenessSeverity.mild:
        return SorenessSeverity.moderate;
      case SorenessSeverity.moderate:
        return SorenessSeverity.severe;
      case SorenessSeverity.severe:
        return SorenessSeverity.none;
    }
  }

  String get displayName {
    switch (this) {
      case SorenessSeverity.none:
        return 'None';
      case SorenessSeverity.mild:
        return 'Mild';
      case SorenessSeverity.moderate:
        return 'Moderate';
      case SorenessSeverity.severe:
        return 'Severe';
    }
  }
}

class SorenessState {
  final Map<MuscleGroup, SorenessSeverity> sorenessMap;

  const SorenessState({
    this.sorenessMap = const {
      MuscleGroup.shoulders: SorenessSeverity.none,
      MuscleGroup.chest: SorenessSeverity.none,
      MuscleGroup.abs: SorenessSeverity.none,
      MuscleGroup.quads: SorenessSeverity.none,
      MuscleGroup.arms: SorenessSeverity.none,
      MuscleGroup.lowerBack: SorenessSeverity.none,
      MuscleGroup.glutes: SorenessSeverity.none,
      MuscleGroup.hamstrings: SorenessSeverity.none,
    },
  });

  factory SorenessState.initial() => SorenessState(
        sorenessMap: {for (var m in MuscleGroup.values) m: SorenessSeverity.none},
      );

  int get compositeSorenessValue {
    int totalPoints = 0;
    for (final severity in sorenessMap.values) {
      switch (severity) {
        case SorenessSeverity.none:
          break;
        case SorenessSeverity.mild:
          totalPoints += 1;
          break;
        case SorenessSeverity.moderate:
          totalPoints += 2;
          break;
        case SorenessSeverity.severe:
          totalPoints += 3;
          break;
      }
    }
    if (totalPoints == 0) return 1;
    if (totalPoints <= 2) return 2;
    if (totalPoints <= 5) return 3;
    if (totalPoints <= 8) return 4;
    return 5;
  }
}
