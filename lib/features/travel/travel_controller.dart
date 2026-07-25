/// §P12-E Travel Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'travel_intelligence_engine.dart';
import 'travel_models.dart';

class TravelState {
  const TravelState({
    this.activeContext,
    this.adaptation,
    this.isTravelModeActive = false,
    this.successMessage,
  });

  final TravelContext? activeContext;
  final TravelAdaptation? adaptation;
  final bool isTravelModeActive;
  final String? successMessage;

  TravelState copyWith({
    TravelContext? activeContext,
    TravelAdaptation? adaptation,
    bool? isTravelModeActive,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return TravelState(
      activeContext: activeContext ?? this.activeContext,
      adaptation: adaptation ?? this.adaptation,
      isTravelModeActive: isTravelModeActive ?? this.isTravelModeActive,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class TravelNotifier extends Notifier<TravelState> {
  late final TravelDetector _detector;
  late final TravelIntelligenceEngine _engine;

  @override
  TravelState build() {
    _detector = const TravelDetector();
    _engine = const TravelIntelligenceEngine();
    return const TravelState();
  }

  void activateTravelMode({
    required String origin,
    required String destination,
    required int originOffsetMinutes,
    required int destinationOffsetMinutes,
  }) {
    final context = _detector.detect(
      origin: origin,
      destination: destination,
      originOffsetMinutes: originOffsetMinutes,
      destinationOffsetMinutes: destinationOffsetMinutes,
    );

    final adaptation = _engine.adapt(context);

    state = state.copyWith(
      activeContext: context,
      adaptation: adaptation,
      isTravelModeActive: true,
      successMessage:
          '✈️ Travel Mode Active (${context.origin} → ${context.destination})!',
    );
  }

  void endTravelMode() {
    state = const TravelState(
      isTravelModeActive: false,
      successMessage: 'Travel Mode ended. Welcome home!',
    );
  }
}

final travelProvider = NotifierProvider<TravelNotifier, TravelState>(
  TravelNotifier.new,
);
