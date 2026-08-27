import '../../environmental_health/domain/environmental_health_engine.dart';

class CircadianMilestone {
  final String title;
  final String regionalTitle;
  final String timeWindow;
  final String guidance;
  final int iconCode;
  final bool isCurrent;

  const CircadianMilestone({
    required this.title,
    required this.regionalTitle,
    required this.timeWindow,
    required this.guidance,
    required this.iconCode,
    this.isCurrent = false,
  });
}

class CircadianEnvironmentalReport {
  final List<CircadianMilestone> milestones;
  final EnvironmentalHealthSnapshot environmentalSnapshot;
  final String currentPhaseSummary;
  final String workoutTimingRecommendation;
  final int recommendedExtraHydrationMl;

  const CircadianEnvironmentalReport({
    required this.milestones,
    required this.environmentalSnapshot,
    required this.currentPhaseSummary,
    required this.workoutTimingRecommendation,
    required this.recommendedExtraHydrationMl,
  });
}

class CircadianEnvironmentalEngine {
  /// Pure Dart deterministic evaluation of circadian milestones and environmental risk synthesis
  static CircadianEnvironmentalReport evaluateDailyEnvironment({
    required DateTime currentTime,
    int aqi = 85,
    double temperatureCelsius = 32.0,
    double relativeHumidityPercent = 65.0,
    double uvIndex = 6.0,
  }) {
    // 1. Evaluate environmental profile
    final envSnapshot = EnvironmentalHealthEngine.evaluate(
      aqi: aqi,
      temperatureC: temperatureCelsius,
      humidityPercent: relativeHumidityPercent,
      uvIndex: uvIndex,
    );

    final hour = currentTime.hour;

    // 2. Compute Circadian Milestones
    final milestones = [
      CircadianMilestone(
        title: 'Morning Light Anchor',
        regionalTitle: 'सुबह की धूप एवं कॉर्टिसोल पीक',
        timeWindow: '7:00 AM – 8:30 AM',
        guidance: 'Get 10-15 mins of natural sunlight to anchor your master circadian clock (SCN).',
        iconCode: 0xe6e1, // wb_sunny
        isCurrent: hour >= 7 && hour < 10,
      ),
      CircadianMilestone(
        title: 'Caffeine & Chai Cutoff',
        regionalTitle: 'कैफीन समाप्ति समय',
        timeWindow: '2:30 PM – 3:30 PM',
        guidance: 'Stop caffeine intake 8 hours prior to bedtime to ensure adenosine clearance.',
        iconCode: 0xe0c8, // local_cafe
        isCurrent: hour >= 14 && hour < 16,
      ),
      CircadianMilestone(
        title: 'Peak Strength & Power Window',
        regionalTitle: 'सर्वश्रेष्ठ कसरत समय',
        timeWindow: '4:30 PM – 7:00 PM',
        guidance: 'Body temperature, grip strength, and reaction speed peak during this window.',
        iconCode: 0xe28d, // fitness_center
        isCurrent: hour >= 16 && hour < 19,
      ),
      CircadianMilestone(
        title: 'Melatonin Window & Wind-down',
        regionalTitle: 'मेलाटोनिन स्राव एवं मंद प्रकाश',
        timeWindow: '9:00 PM – 10:30 PM',
        guidance: 'Dim overhead bright lights and transition to amber lighting to stimulate melatonin.',
        iconCode: 0xe42b, // bedtime
        isCurrent: hour >= 21 || hour < 6,
      ),
    ];

    // 3. Current Phase Summary
    final String currentSummary;
    if (hour >= 6 && hour < 11) {
      currentSummary = 'Morning Cortisol Awakening: Perfect for outdoor hydration and light exposure.';
    } else if (hour >= 11 && hour < 16) {
      currentSummary = 'Midday Metabolic Focus: Stay hydrated and schedule high-focus tasks.';
    } else if (hour >= 16 && hour < 20) {
      currentSummary = 'Peak Neuromuscular Window: Prime time for resistance training and PRs.';
    } else {
      currentSummary = 'Parasympathetic Wind-down: Lower room temperature and avoid blue light.';
    }

    // 4. Workout Timing & Environmental Safety Synthesis
    final String workoutRec;
    if (envSnapshot.aqiCategory == AqiCategory.veryPoor || envSnapshot.aqiCategory == AqiCategory.severe) {
      workoutRec = 'Outdoor air quality is Hazardous (AQI ${envSnapshot.aqi}). Strictly train indoors in filtered air.';
    } else if (envSnapshot.heatIndexC > 38.0) {
      workoutRec = 'Severe Heat Index (${envSnapshot.heatIndexC.round()}°C). Shift intense training to early morning (6:30 AM) or air-conditioned gym.';
    } else {
      workoutRec = 'Conditions are optimal for scheduled workout during your peak strength window (4:30 PM - 7:00 PM).';
    }

    return CircadianEnvironmentalReport(
      milestones: milestones,
      environmentalSnapshot: envSnapshot,
      currentPhaseSummary: currentSummary,
      workoutTimingRecommendation: workoutRec,
      recommendedExtraHydrationMl: envSnapshot.extraHydrationMl,
    );
  }
}
