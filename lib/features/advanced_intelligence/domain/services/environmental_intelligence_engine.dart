import '../models/advanced_intelligence_models.dart';

class EnvironmentalIntelligenceEngine {
  const EnvironmentalIntelligenceEngine();

  /// Generates real-time environmental workout modifications and pollution shields
  EnvironmentalShieldPlan generateEnvironmentalPlan({
    required String city,
    required int aqi,
    required double temperatureC,
    required double humidityPercent,
  }) {
    String aqiCategory;
    bool canExerciseOutdoors = true;
    String indoorWorkout;
    String indoorWorkoutHi;
    String hydration;

    if (aqi > 250) {
      aqiCategory = 'Hazardous Smog (Severe)';
      canExerciseOutdoors = false;
      indoorWorkout = 'Indoor Air-Purified Surya Namaskar (12-18 rounds) + Bhastrika & Kapalbhati pranayama.';
      indoorWorkoutHi = 'घर के अंदर १२-१८ सूर्य नमस्कार और अनुलोम-विलोम प्राणायाम करें। बाहर न जाएं।';
    } else if (aqi > 150) {
      aqiCategory = 'Poor Air Quality';
      canExerciseOutdoors = false;
      indoorWorkout = 'Indoor Bodyweight Strength Complex: 40 Hindu Pushups, 60 Baithak, 3 min Plank.';
      indoorWorkoutHi = 'कमरे के अंदर ही देसी दंड और बैठक का अभ्यास करें।';
    } else if (aqi > 80) {
      aqiCategory = 'Moderate';
      canExerciseOutdoors = true;
      indoorWorkout = 'Outdoor brisk walking acceptable. Avoid peak traffic rush hours (8-10 AM / 6-8 PM).';
      indoorWorkoutHi = 'सुबह जल्दी या शाम को टहल सकते हैं, मुख्य सड़कों से दूर रहें।';
    } else {
      aqiCategory = 'Good / Sattvic Air';
      canExerciseOutdoors = true;
      indoorWorkout = 'Ideal conditions for outdoor running, Akhada training, and open-air yoga.';
      indoorWorkoutHi = 'खुली हवा में योग और दौड़ने के लिए मौसम अत्यंत अनुकूल है।';
    }

    // Compute Heat Index
    final heatIndex = temperatureC + (humidityPercent > 60 ? (temperatureC * 0.15) : 0);

    if (heatIndex > 38.0) {
      hydration = 'Critical thermal alert: Drink 750ml electrolyte water (Nimbu Pani + Sendha Namak) per hour.';
    } else if (heatIndex > 32.0) {
      hydration = 'High heat index: Ensure 500ml hydration with tender coconut water post-workout.';
    } else {
      hydration = 'Standard hydration: Maintain 2.5L to 3L daily water intake.';
    }

    return EnvironmentalShieldPlan(
      city: city,
      aqi: aqi,
      aqiCategory: aqiCategory,
      heatIndexC: double.parse(heatIndex.toStringAsFixed(1)),
      canExerciseOutdoors: canExerciseOutdoors,
      indoorSubstitutionWorkout: indoorWorkout,
      indoorSubstitutionWorkoutHindi: indoorWorkoutHi,
      hydrationModifier: hydration,
    );
  }
}
