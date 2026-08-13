import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/life_events_engine.dart';

class LifeEventsState {
  final List<LifeEvent> activeEvents;
  final LifeEvent? primaryEvent;
  final LifeEventAdaptation activeAdaptation;

  const LifeEventsState({
    required this.activeEvents,
    this.primaryEvent,
    required this.activeAdaptation,
  });

  factory LifeEventsState.initial() {
    return LifeEventsState(
      activeEvents: const [],
      primaryEvent: null,
      activeAdaptation: LifeEventAdaptation.standard(),
    );
  }

  LifeEventsState copyWith({
    List<LifeEvent>? activeEvents,
    LifeEvent? primaryEvent,
    LifeEventAdaptation? activeAdaptation,
  }) {
    return LifeEventsState(
      activeEvents: activeEvents ?? this.activeEvents,
      primaryEvent: primaryEvent ?? this.primaryEvent,
      activeAdaptation: activeAdaptation ?? this.activeAdaptation,
    );
  }
}

class LifeEventsNotifier extends StateNotifier<LifeEventsState> {
  LifeEventsNotifier() : super(LifeEventsState.initial());

  void setPrimaryEvent(LifeEvent event) {
    const engine = LifeEventsEngine();
    final adaptation = engine.adapt(event);

    final updatedList = [...state.activeEvents];
    if (!updatedList.any((e) => e.id == event.id)) {
      updatedList.add(event);
    }

    state = state.copyWith(
      activeEvents: updatedList,
      primaryEvent: event,
      activeAdaptation: adaptation,
    );
  }

  void clearPrimaryEvent() {
    state = state.copyWith(
      primaryEvent: null,
      activeAdaptation: LifeEventAdaptation.standard(),
    );
  }
}

final lifeEventsProvider = StateNotifierProvider<LifeEventsNotifier, LifeEventsState>((ref) {
  return LifeEventsNotifier();
});
