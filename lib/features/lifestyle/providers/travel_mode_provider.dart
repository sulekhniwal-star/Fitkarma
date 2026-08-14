import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/travel_intelligence_engine.dart';

/// §P12-E Travel Mode State Model
class TravelModeState {
  final bool isActive;
  final TravelContext? activeContext;
  final TravelAdaptation? adaptation;
  final int extendedDays;
  final TravelIntelligenceEngine engine;

  const TravelModeState({
    this.isActive = true,
    this.activeContext,
    this.adaptation,
    this.extendedDays = 0,
    this.engine = const TravelIntelligenceEngine(),
  });

  TravelModeState copyWith({
    bool? isActive,
    TravelContext? activeContext,
    TravelAdaptation? adaptation,
    int? extendedDays,
  }) {
    return TravelModeState(
      isActive: isActive ?? this.isActive,
      activeContext: activeContext ?? this.activeContext,
      adaptation: adaptation ?? this.adaptation,
      extendedDays: extendedDays ?? this.extendedDays,
      engine: engine,
    );
  }
}

/// §P12-E Travel Mode Notifier
class TravelModeNotifier extends StateNotifier<TravelModeState> {
  TravelModeNotifier()
      : super(
          TravelModeState(
            isActive: true,
            activeContext: TravelContext(
              mode: TravelMode.domestic,
              origin: 'Delhi',
              destination: 'Mumbai',
              departureDate: DateTime.now(),
              daysDuration: 3,
            ),
            adaptation: const TravelIntelligenceEngine().adapt(
              TravelContext(
                mode: TravelMode.domestic,
                origin: 'Delhi',
                destination: 'Mumbai',
                departureDate: DateTime.now(),
                daysDuration: 3,
              ),
            ),
          ),
        );

  /// Activates or updates Travel Mode with a new travel context
  void startTravelMode(TravelContext context) {
    final adaptation = state.engine.adapt(context);
    state = state.copyWith(
      isActive: true,
      activeContext: context,
      adaptation: adaptation,
      extendedDays: 0,
    );
  }

  /// Extends active travel mode by N days (§P12-E wireframe "[Extend by 1 day]")
  void extendTravelMode({int days = 1}) {
    if (state.activeContext == null) return;
    final updatedDays = state.extendedDays + days;
    state = state.copyWith(extendedDays: updatedDays);
  }

  /// Ends travel mode and resets adaptation
  void endTravelMode() {
    state = state.copyWith(
      isActive: false,
      extendedDays: 0,
    );
  }
}

final travelModeProvider =
    StateNotifierProvider<TravelModeNotifier, TravelModeState>(
  (ref) => TravelModeNotifier(),
);
