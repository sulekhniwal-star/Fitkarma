import '../../../core/models/daily_intelligence_package.dart';
import '../../environmental_health/domain/environmental_health_engine.dart';
import '../../recovery_os/domain/body_soreness_map.dart';
import '../../recovery_os/domain/sleep_intelligence_engine.dart';
import 'coach_philosophy_prompt.dart';

class CoachUserContext {
  final String uid;
  final String name;
  final int age;
  final String sex;
  final double weightKg;
  final double heightCm;
  final double bmi;
  final String primaryGoal;
  final String primaryDosha;
  final bool isPcosDiagnosed;

  // Daily Snapshot
  final DailyIntelligencePackage dip;
  final SleepSessionData? sleepSession;
  final BodySorenessMap? sorenessMap;
  final EnvironmentalHealthSnapshot? environmentalSnapshot;
  final double currentStrain;
  final int todaySteps;

  const CoachUserContext({
    required this.uid,
    required this.name,
    required this.age,
    required this.sex,
    required this.weightKg,
    required this.heightCm,
    required this.bmi,
    required this.primaryGoal,
    required this.primaryDosha,
    this.isPcosDiagnosed = false,
    required this.dip,
    this.sleepSession,
    this.sorenessMap,
    this.environmentalSnapshot,
    this.currentStrain = 0.0,
    this.todaySteps = 0,
  });

  Map<String, dynamic> toStructuredPayload() {
    return {
      'userProfile': {
        'age': age,
        'sex': sex,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'bmi': bmi,
        'primaryGoal': primaryGoal,
        'dosha': primaryDosha,
        'isPcosDiagnosed': isPcosDiagnosed,
      },
      'todayHealthOS': {
        'date': dip.date,
        'readinessScore': dip.readinessScore,
        'readinessZone': dip.readinessZone.name,
        'healthScore': dip.healthScore,
        'targetCalories': dip.targetCalories,
        'targetProteinGrams': dip.targetProteinGrams,
        'targetSteps': dip.targetSteps,
      },
      'recoveryAndSleep': {
        'sleepHours': sleepSession?.totalSleepHours ?? 7.5,
        'deepSleepPercent': sleepSession != null
            ? (sleepSession!.deepSleepMinutes / sleepSession!.actualAsleepMinutes)
            : 0.18,
        'remSleepPercent': sleepSession != null
            ? (sleepSession!.remSleepMinutes / sleepSession!.actualAsleepMinutes)
            : 0.22,
        'somaticSorenessScore': sorenessMap?.cumulativeScore ?? 20,
      },
      'physicalStrain': {
        'todayStrain': currentStrain,
        'todaySteps': todaySteps,
      },
      'environmental': {
        'aqi': environmentalSnapshot?.aqi ?? 95,
        'heatIndexC': environmentalSnapshot?.heatIndexC ?? 32.0,
        'extraHydrationMl': environmentalSnapshot?.extraHydrationMl ?? 300,
      },
    };
  }
}

class AiCoachContextBuilder {
  /// Builds the complete system prompt with integrated real-time physiological context
  static String buildSystemPrompt(CoachUserContext context) {
    final payload = context.toStructuredPayload();

    return '''
${CoachPhilosophyPrompt.systemPersona}

### CURRENT USER REAL-TIME CONTEXT:
- Name: ${context.name}
- Biometrics: ${context.age} yrs, ${context.sex}, ${context.weightKg} kg, BMI: ${context.bmi.toStringAsFixed(1)}
- Primary Goal: ${context.primaryGoal} | Dosha: ${context.primaryDosha}${context.isPcosDiagnosed ? ' | (PCOS Aware Protocol)' : ''}
- Today's Readiness: ${context.dip.readinessScore}/100 [Zone: ${context.dip.readinessZone.name.toUpperCase()}]
- Nutrition Targets: ${context.dip.targetCalories} kcal | ${context.dip.targetProteinGrams}g Protein
- Sleep Last Night: ${(payload['recoveryAndSleep']['sleepHours'] as double).toStringAsFixed(1)} hrs (Deep: ${((payload['recoveryAndSleep']['deepSleepPercent'] as double) * 100).round()}%)
- Muscle Soreness: ${payload['recoveryAndSleep']['somaticSorenessScore']}% | Today's Strain: ${context.currentStrain}/21.0
- Environmental AQI: ${payload['environmental']['aqi']} | Heat Index: ${(payload['environmental']['heatIndexC'] as double).round()}°C

Respond concisely (2-4 paragraphs max), empathetically, and with actionable specificity.
''';
  }
}
