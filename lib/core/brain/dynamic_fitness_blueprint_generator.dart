import 'dart:convert';

class BlueprintPhase {
  final String name;
  final String weeks;
  final String intensity;

  const BlueprintPhase({
    required this.name,
    required this.weeks,
    required this.intensity,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'weeks': weeks,
        'intensity': intensity,
      };

  factory BlueprintPhase.fromJson(Map<String, dynamic> json) {
    return BlueprintPhase(
      name: json['name'] as String,
      weeks: json['weeks'] as String,
      intensity: json['intensity'] as String,
    );
  }
}

class FitnessBlueprint {
  final String programName;
  final int durationWeeks;
  final int daysPerWeek;
  final int sessionDuration;
  final List<BlueprintPhase> phases;
  final List<int> deloadWeeks;
  final DateTime generatedAt;
  final bool isCachedLocally;

  const FitnessBlueprint({
    required this.programName,
    required this.durationWeeks,
    required this.daysPerWeek,
    required this.sessionDuration,
    required this.phases,
    required this.deloadWeeks,
    required this.generatedAt,
    this.isCachedLocally = true,
  });

  Map<String, dynamic> toJson() => {
        'programName': programName,
        'durationWeeks': durationWeeks,
        'daysPerWeek': daysPerWeek,
        'sessionDuration': sessionDuration,
        'phases': phases.map((p) => p.toJson()).toList(),
        'deloadWeeks': deloadWeeks,
        'generatedAt': generatedAt.toIso8601String(),
        'isCachedLocally': isCachedLocally,
      };

  factory FitnessBlueprint.fromJson(Map<String, dynamic> json) {
    return FitnessBlueprint(
      programName: json['programName'] as String,
      durationWeeks: json['durationWeeks'] as int,
      daysPerWeek: json['daysPerWeek'] as int,
      sessionDuration: json['sessionDuration'] as int,
      phases: (json['phases'] as List<dynamic>)
          .map((p) => BlueprintPhase.fromJson(p as Map<String, dynamic>))
          .toList(),
      deloadWeeks: (json['deloadWeeks'] as List<dynamic>).cast<int>(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      isCachedLocally: json['isCachedLocally'] as bool? ?? true,
    );
  }

  String toRawJson() => jsonEncode(toJson());
  factory FitnessBlueprint.fromRawJson(String raw) =>
      FitnessBlueprint.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}

/// Pure-Dart Dynamic Fitness Blueprint Generator & Local Caching Engine per §P6-D spec
class DynamicFitnessBlueprintGenerator {
  // In-memory cache representing local storage (e.g. Drift DB / SharedPreferences)
  static final Map<String, String> _driftBlueprintCache = {};

  const DynamicFitnessBlueprintGenerator();

  /// Generates or fetches a cached 12-week Fitness Blueprint for the chosen program.
  /// Rule: Generated once at program selection, cached locally. Not regenerated unless program changes or Evolution event occurs.
  FitnessBlueprint getOrGenerateBlueprint({
    required String programName,
    bool forceRegenerate = false,
  }) {
    final cacheKey = programName.toLowerCase().replaceAll(' ', '_');

    // 1. Check Local Cache (Drift DB simulation)
    if (!forceRegenerate && _driftBlueprintCache.containsKey(cacheKey)) {
      final rawCached = _driftBlueprintCache[cacheKey]!;
      return FitnessBlueprint.fromRawJson(rawCached);
    }

    // 2. Generate New Program Blueprint
    final newBlueprint = _buildBlueprintForProgram(programName);

    // 3. Cache to Local Store
    _driftBlueprintCache[cacheKey] = newBlueprint.toRawJson();

    return newBlueprint;
  }

  /// Triggers a Program Evolution Event (e.g. user plateaued, switched goal, or finished 12 weeks)
  FitnessBlueprint triggerProgramEvolutionEvent({
    required String programName,
    required String evolutionReason,
  }) {
    return getOrGenerateBlueprint(
      programName: programName,
      forceRegenerate: true,
    );
  }

  FitnessBlueprint _buildBlueprintForProgram(String name) {
    if (name.contains('Fat Loss') || name.contains('Corporate')) {
      return FitnessBlueprint(
        programName: 'Corporate Fat Loss',
        durationWeeks: 12,
        daysPerWeek: 4,
        sessionDuration: 45,
        phases: const [
          BlueprintPhase(
              name: 'Foundation', weeks: '1-3', intensity: 'RPE 6-7'),
          BlueprintPhase(name: 'Build', weeks: '4-8', intensity: 'RPE 7-8'),
          BlueprintPhase(name: 'Peak', weeks: '9-12', intensity: 'RPE 8-9'),
        ],
        deloadWeeks: const [4, 8, 12],
        generatedAt: DateTime.now(),
        isCachedLocally: true,
      );
    }

    // Default Muscle Building Blueprint
    return FitnessBlueprint(
      programName: name,
      durationWeeks: 12,
      daysPerWeek: 5,
      sessionDuration: 50,
      phases: const [
        BlueprintPhase(
            name: 'Hypertrophy Prep', weeks: '1-3', intensity: 'RPE 6.5-7.5'),
        BlueprintPhase(
            name: 'Overload Accumulation',
            weeks: '4-8',
            intensity: 'RPE 7.5-8.5'),
        BlueprintPhase(
            name: 'Intensity Peak', weeks: '9-12', intensity: 'RPE 8.5-9.5'),
      ],
      deloadWeeks: const [4, 8, 12],
      generatedAt: DateTime.now(),
      isCachedLocally: true,
    );
  }

  static void clearCache() {
    _driftBlueprintCache.clear();
  }
}
