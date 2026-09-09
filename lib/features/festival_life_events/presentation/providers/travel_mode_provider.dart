import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/travel_mode_engine.dart';
import '../../domain/travel_mode_models.dart';

final travelModeProvider =
    StateNotifierProvider<TravelModeNotifier, TravelIntelligenceReport>((ref) {
  return TravelModeNotifier();
});

class TravelModeNotifier extends StateNotifier<TravelIntelligenceReport> {
  TravelModeNotifier() : super(_buildInitialReport());

  static final TravelModeEngine _engine = const TravelModeEngine();

  static TravelIntelligenceReport _buildInitialReport() {
    return _engine.generateTravelPlan(
      context: TravelContext.flightTransit,
      destinationCityOrTimezone: 'Dubai / London (GMT)',
      timezoneShiftHours: 5,
      isTravelModeActive: true,
    );
  }

  void updateContext(TravelContext context) {
    state = _engine.generateTravelPlan(
      context: context,
      destinationCityOrTimezone: state.destinationCityOrTimezone,
      timezoneShiftHours: state.timezoneShiftHours,
      isTravelModeActive: state.isTravelModeActive,
      executionTime: DateTime.now(),
    );
  }

  void updateDestination(String destination, int shiftHours) {
    state = _engine.generateTravelPlan(
      context: state.activeContext,
      destinationCityOrTimezone: destination,
      timezoneShiftHours: shiftHours,
      isTravelModeActive: state.isTravelModeActive,
      executionTime: DateTime.now(),
    );
  }

  void toggleTravelMode(bool isActive) {
    state = _engine.generateTravelPlan(
      context: state.activeContext,
      destinationCityOrTimezone: state.destinationCityOrTimezone,
      timezoneShiftHours: state.timezoneShiftHours,
      isTravelModeActive: isActive,
      executionTime: DateTime.now(),
    );
  }
}
