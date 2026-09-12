import 'dart:convert';
import 'package:intl/intl.dart';
import '../../environmental/services/environmental_health_engine.dart';
import '../../metabolism/services/metabolism_engine.dart';
import '../domain/models/dip_package.dart';
import 'ai_routing_service.dart';

/// HealthOSBrain — Central intelligence orchestrator for FitKarma
/// Synthesizes readiness scores, metabolic targets, and environmental risks into the Daily Intelligence Package (DIP).
class HealthOSBrain {
  final MetabolismEngine metabolismEngine;
  final EnvironmentalHealthEngine environmentalEngine;
  final AIRoutingService aiRoutingService;

  const HealthOSBrain({
    this.metabolismEngine = const MetabolismEngine(),
    this.environmentalEngine = const EnvironmentalHealthEngine(),
    required this.aiRoutingService,
  });

  /// Orchestrate Daily Intelligence Package (DIP)
  /// Attempts Edge Function AI synthesis first; falls back to pure deterministic logic when offline.
  Future<DipPackage> generateDailyPackage({
    required String userId,
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required Goal goal,
    required int readinessScore,
    required int aqi,
    required double uvIndex,
    required double temperatureC,
    required double humidityPercent,
  }) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Compute Deterministic Metabolism Profile
    final metabolic = metabolismEngine.calculateProfile(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
    );

    // 2. Compute Deterministic Environmental Assessment
    final env = environmentalEngine.assess(
      aqi: aqi,
      uvIndex: uvIndex,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
    );

    // Determine readiness tier
    final readinessTier = readinessScore >= 80
        ? 'prime'
        : readinessScore >= 60
            ? 'steady'
            : 'recovery';

    // 3. Prepare Context Snapshot for AI Edge Function
    final contextSnapshot = {
      'readiness_score': readinessScore,
      'readiness_tier': readinessTier,
      'metabolic': {
        'calories': metabolic.targetCalories,
        'protein': metabolic.targetProteinGrams,
        'carbs': metabolic.targetCarbsGrams,
        'fats': metabolic.targetFatsGrams,
      },
      'environmental': {
        'aqi': env.aqi,
        'outdoor_safe': env.isOutdoorSafe,
        'heat_index': env.heatIndexC,
      },
    };

    // 4. Try Edge Function AI synthesis
    final remoteDip = await aiRoutingService.fetchSynthesizedDIP(
      userId: userId,
      contextSnapshot: contextSnapshot,
    );

    if (remoteDip != null) {
      return remoteDip;
    }

    // 5. Pure Dart Deterministic Fallback (Offline Mode)
    String briefing = 'Your body is in steady condition today. Maintain balanced nutrition and steady cadence.';
    String briefingHindi = 'आज आपका शरीर संतुलित स्थिति में है। पौष्टिक आहार और नियमित व्यायाम बनाए रखें।';
    String workoutRecommendation = 'Standard hypertrophy or 45-min Zone 2 cardio.';

    if (readinessScore >= 80) {
      briefing = 'High readiness detected! Your nervous system is primed for peak intensity.';
      briefingHindi = 'आज आपकी शारीरिक ऊर्जा चरम पर है! भारी कसरत के लिए आदर्श दिन है।';
      workoutRecommendation = 'Heavy compound lifts or HIIT conditioning.';
    } else if (readinessScore < 60) {
      briefing = 'Elevated systemic strain detected. Prioritize active recovery and sleep hygiene.';
      briefingHindi = 'शरीर में थकान के संकेत हैं। आज हल्की स्ट्रेचिंग और पर्याप्त नींद को प्राथमिकता दें।';
      workoutRecommendation = '30-min mobility flow, yoga, or light walk.';
    }

    return DipPackage(
      date: today,
      readinessScore: readinessScore,
      readinessTier: readinessTier,
      morningBriefing: briefing,
      morningBriefingHindi: briefingHindi,
      metabolicBudgetKcal: metabolic.targetCalories,
      targetProteinGrams: metabolic.targetProteinGrams,
      targetCarbsGrams: metabolic.targetCarbsGrams,
      targetFatsGrams: metabolic.targetFatsGrams,
      environmentalAdvisory: env.safetyAdvisory,
      trainingRecommendation: workoutRecommendation,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }
}
