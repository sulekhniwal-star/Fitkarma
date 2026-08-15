import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/travel_intelligence_engine.dart';

void main() {
  group('§P12-E Travel Intelligence Engine Tests (Pure Dart)', () {
    const engine = TravelIntelligenceEngine();

    test(
        'Domestic travel adaptation adapts workout, nutrition buffer, hydration, and sleep note',
        () {
      final context = TravelContext(
        mode: TravelMode.domestic,
        origin: 'Delhi',
        destination: 'Mumbai',
        departureDate: DateTime.now(),
      );

      final adaptation = engine.adapt(context);

      expect(adaptation.workoutPlan.minutes, equals(30));
      expect(adaptation.workoutPlan.title,
          contains('30-min hotel bodyweight session'));
      expect(adaptation.workoutPlan.exercises, contains('Push-ups'));
      expect(adaptation.workoutPlan.exercises, contains('Squats'));
      expect(adaptation.workoutPlan.exercises, contains('Lunges'));
      expect(adaptation.workoutPlan.exercises, contains('Plank'));

      expect(
          adaptation.calorieBudget, equals('+150 kcal buffer for eating out'));
      expect(adaptation.nutritionPlan.strategy,
          contains('high-protein items from hotel menu'));
      expect(adaptation.nutritionPlan.bestBets, contains('Grilled paneer'));
      expect(adaptation.nutritionPlan.bestBets,
          contains('Dal tadka / yellow dal'));

      expect(adaptation.hydrationNote, contains('Carry water bottle'));
      expect(adaptation.readinessAdjustment, equals(-5));
      expect(adaptation.sleepNote, contains('Hotel blackout curtains on'));
      expect(adaptation.jetLagProtocol, isNull);
      expect(adaptation.readinessExpectationSummary,
          contains('5–10% lower (travel fatigue)'));
    });

    test(
        'International travel adaptation includes JetLagProtocol and +200 kcal buffer',
        () {
      final context = TravelContext(
        mode: TravelMode.international,
        origin: 'Mumbai',
        destination: 'London',
        direction: TravelDirection.west,
        departureDate: DateTime.now(),
      );

      final adaptation = engine.adapt(context);

      expect(adaptation.workoutPlan.minutes, equals(25));
      expect(
          adaptation.calorieBudget, equals('+200 kcal buffer for travel days'));
      expect(adaptation.readinessAdjustment, equals(-12));
      expect(adaptation.jetLagProtocol, isNotNull);
      expect(
          adaptation.jetLagProtocol!.direction, equals(TravelDirection.west));
      expect(adaptation.jetLagProtocol!.recommendations,
          contains('Avoid caffeine 6h before new sleep time'));
      expect(adaptation.jetLagProtocol!.recommendations,
          contains('Get morning sunlight at destination ASAP'));
      expect(adaptation.jetLagProtocol!.recommendations,
          contains('Readiness will be 10–15% lower for 3 days — expected'));
    });

    test(
        'Airport mode adaptation sets airport terminal walk and airport survival food tips',
        () {
      final context = TravelContext(
        mode: TravelMode.airport,
        origin: 'Bengaluru',
        destination: 'Airport',
        departureDate: DateTime.now(),
      );

      final adaptation = engine.adapt(context);

      expect(adaptation.workoutPlan.title, equals('Airport Terminal Walk'));
      expect(adaptation.workoutPlan.tip,
          contains('Walk the terminal instead of sitting at the gate'));
      expect(adaptation.nutritionPlan.tip,
          contains('Best airport options: salads, grilled sandwiches, nuts'));
      expect(adaptation.hydrationNote,
          equals('Drink 250ml water per hour of flying.'));
    });
  });
}
