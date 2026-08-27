enum MuscleGroup {
  neckTraps(name: 'Neck & Traps', regionalName: 'गर्दन एवं ट्रैप्स'),
  shoulders(name: 'Shoulders', regionalName: 'कंधे'),
  chest(name: 'Chest / Pecs', regionalName: 'छाती'),
  upperBack(name: 'Upper Back & Lats', regionalName: 'पीठ का ऊपरी हिस्सा'),
  lowerBack(name: 'Lower Back & Spine', regionalName: 'कमर एवं रीढ़'),
  arms(name: 'Arms (Biceps/Triceps)', regionalName: 'बांहें'),
  coreAbs(name: 'Core & Abdominals', regionalName: 'पेट एवं कोर'),
  quadriceps(name: 'Quadriceps', regionalName: 'जांघें (आगे)'),
  hamstringsGlutes(name: 'Hamstrings & Glutes', regionalName: 'हैमस्ट्रिंग एवं नितंब'),
  calves(name: 'Calves & Shins', regionalName: 'पिंडलियां');

  final String name;
  final String regionalName;

  const MuscleGroup({required this.name, required this.regionalName});
}

enum SorenessLevel {
  none(value: 0, label: 'None (सामान्य)', colorHex: 0xFF22C55E),
  mild(value: 1, label: 'Mild DOMS (हल्का दर्द)', colorHex: 0xFF3B82F6),
  moderate(value: 2, label: 'Moderate (मध्यम थकान)', colorHex: 0xFFF97316),
  severe(value: 3, label: 'Severe Strain (अत्यधिक दर्द)', colorHex: 0xFFEF4444);

  final int value;
  final String label;
  final int colorHex;

  const SorenessLevel({
    required this.value,
    required this.label,
    required this.colorHex,
  });
}

class BodySorenessMap {
  final Map<MuscleGroup, SorenessLevel> muscleStates;
  final DateTime loggedAt;

  const BodySorenessMap({
    required this.muscleStates,
    required this.loggedAt,
  });

  /// Computes cumulative body soreness score (0 - 100)
  int get cumulativeScore {
    if (muscleStates.isEmpty) return 0;
    int totalPoints = 0;
    for (final level in muscleStates.values) {
      totalPoints += level.value;
    }
    final maxPoints = MuscleGroup.values.length * 3;
    return ((totalPoints / maxPoints) * 100).round().clamp(0, 100);
  }

  /// Generates targeted somatic relief recommendations
  List<String> get reliefProtocols {
    final List<String> protocols = [];

    muscleStates.forEach((muscle, level) {
      if (level.value >= 2) {
        switch (muscle) {
          case MuscleGroup.neckTraps:
            protocols.add('Neck & Traps: 5 min chin tucks, upper trap stretch, warm compress.');
            break;
          case MuscleGroup.shoulders:
            protocols.add('Shoulders: Light band dislocates, doorway pec stretch, avoid overhead pressing.');
            break;
          case MuscleGroup.chest:
            protocols.add('Chest: Foam roll thoracic spine, open-book mobility drills.');
            break;
          case MuscleGroup.upperBack:
            protocols.add('Upper Back: Lat foam rolling, thread-the-needle spinal rotations.');
            break;
          case MuscleGroup.lowerBack:
            protocols.add('Lower Back: Cat-Cow stretch, Bird-Dog holds, pelvic tilts, avoid spinal compression.');
            break;
          case MuscleGroup.arms:
            protocols.add('Arms: Forearm extensor massage, light biceps stretching, magnesium hydration.');
            break;
          case MuscleGroup.coreAbs:
            protocols.add('Core: Cobra stretch, gentle diaphragmatic breathing exercises.');
            break;
          case MuscleGroup.quadriceps:
            protocols.add('Quads: Foam rolling anterior thigh, standing quad stretch, post-workout walk.');
            break;
          case MuscleGroup.hamstringsGlutes:
            protocols.add('Hamstrings/Glutes: Pigeon pose, figure-4 glute stretch, lacrosse ball release.');
            break;
          case MuscleGroup.calves:
            protocols.add('Calves: Wall calf stretch, ankle dorsiflexion mobility, electrolyte replenishment.');
            break;
        }
      }
    });

    if (protocols.isEmpty) {
      protocols.add('Muscles are fresh and well-recovered. Ready for standard training loads.');
    }

    return protocols;
  }

  factory BodySorenessMap.fromMap(Map<String, dynamic> map) {
    final Map<MuscleGroup, SorenessLevel> states = {};
    final rawStates = map['muscleStates'] as Map<String, dynamic>? ?? {};

    for (final muscle in MuscleGroup.values) {
      final val = rawStates[muscle.name] as int? ?? 0;
      states[muscle] = SorenessLevel.values.firstWhere(
        (l) => l.value == val,
        orElse: () => SorenessLevel.none,
      );
    }

    return BodySorenessMap(
      muscleStates: states,
      loggedAt: map['loggedAt'] != null
          ? DateTime.tryParse(map['loggedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, int> raw = {};
    muscleStates.forEach((k, v) => raw[k.name] = v.value);

    return {
      'muscleStates': raw,
      'cumulativeScore': cumulativeScore,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  static BodySorenessMap initial() {
    final Map<MuscleGroup, SorenessLevel> initialMap = {
      for (var m in MuscleGroup.values) m: SorenessLevel.none,
    };
    return BodySorenessMap(muscleStates: initialMap, loggedAt: DateTime.now());
  }
}
