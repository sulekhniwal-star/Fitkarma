import 'workout_models.dart';

enum FundamentalMovementPattern {
  horizontalPush(name: 'Horizontal Push', regionalName: 'क्षैतिज धक्का (चेस्ट प्रेस / दंड)'),
  horizontalPull(name: 'Horizontal Pull', regionalName: 'क्षैतिज खिंचाव (रोइंग / पीठ)'),
  verticalPush(name: 'Vertical Push', regionalName: 'ऊर्ध्वाधर धक्का (ओवरहेड प्रेस)'),
  verticalPull(name: 'Vertical Pull', regionalName: 'ऊर्ध्वाधर खिंचाव (पुल-अप्स / लैट्स)'),
  kneeDominant(name: 'Knee Dominant (Squat)', regionalName: 'घुटना प्रधान (स्क्वैट्स / देसी बैठक)'),
  hipDominant(name: 'Hip Dominant (Hinge)', regionalName: 'कूल्हा प्रधान (डेडलिफ्ट / हिंज)'),
  rotationalCore(name: 'Rotational & Core Integrity', regionalName: 'घूर्णन एवं कोर (मुद्गर / गदा घुमाना)');

  final String name;
  final String regionalName;

  const FundamentalMovementPattern({
    required this.name,
    required this.regionalName,
  });
}

class MovementBalanceReport {
  final int overallMovementQualityScore; // 0 to 100
  final double pushToPullRatio; // Target: 0.9 to 1.1
  final double quadToHamstringRatio; // Target: 1.0 to 1.3
  final Map<FundamentalMovementPattern, int> patternWeeklySets;
  final List<String> biomechanicalDiagnoses;
  final List<String> correctiveWarmupPrescriptions;
  final String structuralBalanceSummary;

  const MovementBalanceReport({
    required this.overallMovementQualityScore,
    required this.pushToPullRatio,
    required this.quadToHamstringRatio,
    required this.patternWeeklySets,
    required this.biomechanicalDiagnoses,
    required this.correctiveWarmupPrescriptions,
    required this.structuralBalanceSummary,
  });
}

class MovementIntelligenceEngine {
  /// Pure Dart deterministic calculation of Movement Intelligence & Biomechanical Balance
  static MovementBalanceReport evaluateMovementSymmetry({
    required List<WorkoutSession> weeklySessions,
  }) {
    if (weeklySessions.isEmpty) {
      return _buildEmptyReport();
    }

    final Map<FundamentalMovementPattern, int> patternSets = {
      for (var p in FundamentalMovementPattern.values) p: 0,
    };

    for (final session in weeklySessions) {
      for (final planned in session.plannedExercises) {
        final pattern = _classifyExercise(planned.exercise);
        patternSets[pattern] = (patternSets[pattern] ?? 0) + planned.targetSets;
      }
    }

    // Ratio Calculations
    final int pushSets = (patternSets[FundamentalMovementPattern.horizontalPush] ?? 0) +
        (patternSets[FundamentalMovementPattern.verticalPush] ?? 0);
    final int pullSets = (patternSets[FundamentalMovementPattern.horizontalPull] ?? 0) +
        (patternSets[FundamentalMovementPattern.verticalPull] ?? 0);

    final double pushPullRatio = pullSets > 0 ? double.parse((pushSets / pullSets).toStringAsFixed(2)) : 1.0;

    final int quadSets = patternSets[FundamentalMovementPattern.kneeDominant] ?? 0;
    final int hamSets = patternSets[FundamentalMovementPattern.hipDominant] ?? 0;

    final double quadHamRatio = hamSets > 0 ? double.parse((quadSets / hamSets).toStringAsFixed(2)) : 1.0;

    // Diagnostic flags
    final List<String> diagnoses = [];
    final List<String> correctives = [];
    double score = 100.0;

    if (pushPullRatio > 1.3) {
      score -= 15.0;
      diagnoses.add('Push-dominant bias detected ($pushPullRatio ratio). Excessive anterior deltoid and pec minor tension.');
      correctives.add('Add 3-4 sets of Face Pulls or Prone Y-Raises to strengthen middle/lower trapezius.');
    } else if (pushPullRatio < 0.7) {
      score -= 10.0;
      diagnoses.add('Pull-dominant bias ($pushPullRatio ratio). Chest volume below optimal hypertrophy threshold.');
      correctives.add('Add Incline DB Press or Desi Dand volume.');
    } else {
      diagnoses.add('Optimal Push-to-Pull structural equilibrium ($pushPullRatio ratio). Protects glenohumeral joint integrity.');
    }

    if (quadHamRatio > 1.5) {
      score -= 15.0;
      diagnoses.add('Quad-dominant knee bias ($quadHamRatio ratio). Hamstring-to-quad strength deficit increases ACL shear stress.');
      correctives.add('Add Romanian Deadlifts (RDLs) or Nordic Hamstring Curls to balance posterior chain.');
    } else {
      diagnoses.add('Balanced Lower Body Hinge-to-Squat ratio ($quadHamRatio). Protects patellar tendons and lumbar spine.');
    }

    final int rotationalSets = patternSets[FundamentalMovementPattern.rotationalCore] ?? 0;
    if (rotationalSets < 3) {
      score -= 10.0;
      diagnoses.add('Low rotational and multi-planar core stimulus ($rotationalSets sets).');
      correctives.add('Prescribe 10 minutes of Mudgar / Karlakattai 360 circular swings for rotational shoulder stability.');
    } else {
      correctives.add('Maintain Mudgar & Desi Dand dynamic movement prep before loading heavy barbells.');
    }

    final int qualityScore = score.round().clamp(40, 100);

    return MovementBalanceReport(
      overallMovementQualityScore: qualityScore,
      pushToPullRatio: pushPullRatio,
      quadToHamstringRatio: quadHamRatio,
      patternWeeklySets: patternSets,
      biomechanicalDiagnoses: diagnoses,
      correctiveWarmupPrescriptions: correctives,
      structuralBalanceSummary: 'Weekly movement distribution scored $qualityScore/100 on the Biomechanical Balance Index. '
          'Push:Pull ($pushPullRatio) and Squat:Hinge ($quadHamRatio) are structurally mapped to prevent postural drift.',
    );
  }

  static FundamentalMovementPattern _classifyExercise(Exercise exercise) {
    final name = exercise.name.toLowerCase();
    final id = exercise.id.toLowerCase();

    if (name.contains('bench') || name.contains('incline') || name.contains('pushup') || name.contains('dand')) {
      return FundamentalMovementPattern.horizontalPush;
    }
    if (name.contains('row') || id.contains('row')) {
      return FundamentalMovementPattern.horizontalPull;
    }
    if (name.contains('overhead') || name.contains('shoulder') || name.contains('ohp') || name.contains('lateral')) {
      return FundamentalMovementPattern.verticalPush;
    }
    if (name.contains('lat') || name.contains('pulldown') || name.contains('pull-up') || name.contains('chin')) {
      return FundamentalMovementPattern.verticalPull;
    }
    if (name.contains('squat') || name.contains('baithak') || name.contains('lunge') || name.contains('leg press')) {
      return FundamentalMovementPattern.kneeDominant;
    }
    if (name.contains('deadlift') || name.contains('rdl') || name.contains('thrust') || name.contains('hinge')) {
      return FundamentalMovementPattern.hipDominant;
    }
    return FundamentalMovementPattern.rotationalCore;
  }

  static MovementBalanceReport _buildEmptyReport() {
    return const MovementBalanceReport(
      overallMovementQualityScore: 85,
      pushToPullRatio: 1.0,
      quadToHamstringRatio: 1.0,
      patternWeeklySets: {},
      biomechanicalDiagnoses: ['Schedule workout sessions to evaluate your movement balance.'],
      correctiveWarmupPrescriptions: ['Start every session with 5 minutes of joint mobility and Akhara Mudgar flow.'],
      structuralBalanceSummary: 'No active workout sessions loaded yet.',
    );
  }
}
