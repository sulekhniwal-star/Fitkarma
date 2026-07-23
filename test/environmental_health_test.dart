import 'package:fitkarma/core/environmental/environmental_health_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EnvironmentalHealthEngine engine;

  setUp(() {
    engine = EnvironmentalHealthEngine();
  });

  test(
    'EnvironmentalHealthEngine classifies hazardous AQI and adapts missions',
    () {
      final env = EnvironmentalData(
        aqi: 340, // Hazardous
        heatIndexC: 30.0,
        uvIndex: 4.0,
      );

      final adaptation = engine.evaluate(env);
      expect(adaptation.workoutRecommendation, WorkoutLocation.indoorOnly);
      expect(adaptation.hydrationBoostL, 0.5);
      expect(adaptation.warningBanner, contains('Hazardous'));

      final baseMission = DailyMission(
        title: 'Monday Cardio',
        stepGoal: 10000,
        workoutSuggestion: '5k Outdoor Run',
        hydrationGoalL: 2.5,
      );

      final adjusted = engine.adjustMission(baseMission, adaptation);
      // Steps target should drop by 30% (7000 steps)
      expect(adjusted.stepGoal, 7000);
      expect(adjusted.workoutSuggestion, contains('Indoor'));
      expect(adjusted.hydrationGoalL, 3.0); // 2.5 + 0.5
    },
  );

  test('EnvironmentalHealthEngine evaluates extreme heat index warnings', () {
    final env = EnvironmentalData(
      aqi: 80,
      heatIndexC: 42.5, // Extreme Heat
      uvIndex: 5.0,
    );

    final adaptation = engine.evaluate(env);
    expect(
      adaptation.workoutRecommendation,
      WorkoutLocation.earlyMorningOrIndoor,
    );
    expect(adaptation.hydrationBoostL, 0.8);
    expect(adaptation.warningBanner, contains('42.5'));

    final baseMission = DailyMission(
      title: 'Power Walking',
      stepGoal: 8000,
      workoutSuggestion: 'Long afternoon stroll',
      hydrationGoalL: 2.0,
    );

    final adjusted = engine.adjustMission(baseMission, adaptation);
    expect(adjusted.workoutSuggestion, contains('Early Morning'));
    expect(adjusted.hydrationGoalL, 2.8); // 2.0 + 0.8
  });

  test('EnvironmentalHealthEngine handles UV index scaling', () {
    final env = EnvironmentalData(
      aqi: 90,
      heatIndexC: 28.0,
      uvIndex: 12.0, // Extreme UV
    );

    final adaptation = engine.evaluate(env);
    expect(adaptation.workoutRecommendation, WorkoutLocation.indoorPreferred);
    expect(adaptation.hydrationBoostL, 0.2);
    expect(adaptation.warningBanner, contains('sunscreen'));
  });
}
