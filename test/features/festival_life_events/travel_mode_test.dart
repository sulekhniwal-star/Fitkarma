import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/festival_life_events/domain/travel_mode_engine.dart';
import 'package:fitkarma/features/festival_life_events/domain/travel_mode_models.dart';

void main() {
  group('TravelModeEngine Deterministic Tests', () {
    const engine = TravelModeEngine();

    test(
        'Generates flight transit plan with anti-edema and hydration protocols',
        () {
      final report = engine.generateTravelPlan(
        context: TravelContext.flightTransit,
        destinationCityOrTimezone: 'Dubai / London',
        timezoneShiftHours: 4,
        isTravelModeActive: true,
      );

      expect(report.activeContext, equals(TravelContext.flightTransit));
      expect(report.isTravelModeActive, isTrue);
      expect(report.adaptedStepGoal, equals(6000));
      expect(report.hotelWorkoutDurationMinutes, equals(15));
      expect(report.activeTravelActions.length, equals(3));
      expect(
          report.activeTravelActions
              .any((a) => a.title.contains('Viparita Karani')),
          isTrue);
      expect(report.vataBalancingRitual, contains('Pada Abhyanga'));
      expect(report.regionalVataBalancingRitual, contains('पाद अभ्यंग'));
      expect(report.airportDhabaDiningTip, contains('Idli-Sambar'));
    });

    test(
        'Generates circadian sunlight timing for international long-haul jet lag',
        () {
      final report = engine.generateTravelPlan(
        context: TravelContext.internationalJetLag,
        destinationCityOrTimezone: 'New York (EST)',
        timezoneShiftHours: -9,
      );

      expect(report.activeContext, equals(TravelContext.internationalJetLag));
      expect(report.jetLagCircadianAdvice, contains('morning sunlight'));
      expect(report.regionalJetLagAdvice, contains('सुबह २० मिनट की धूप'));
      expect(report.adaptedStepGoal, equals(7000));
    });

    test('Generates higher step and workout target for hotel with equipped gym',
        () {
      final report = engine.generateTravelPlan(
        context: TravelContext.hotelWithGym,
        destinationCityOrTimezone: 'Bengaluru (IST)',
        timezoneShiftHours: 0,
      );

      expect(report.adaptedStepGoal, equals(10000));
      expect(report.hotelWorkoutDurationMinutes, equals(35));
    });

    test('All TravelContext values produce complete valid reports', () {
      for (final ctx in TravelContext.values) {
        final report = engine.generateTravelPlan(context: ctx);
        expect(report.activeContext, equals(ctx));
        expect(report.activeTravelActions, isNotEmpty);
        expect(report.vataBalancingRitual, isNotEmpty);
        expect(report.regionalVataBalancingRitual, isNotEmpty);
        expect(report.airportDhabaDiningTip, isNotEmpty);
      }
    });
  });
}
