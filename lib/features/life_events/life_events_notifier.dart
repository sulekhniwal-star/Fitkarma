/// §P12-B Life Events Notifier & State Management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../transformation/transformation_memory_repository.dart';
import 'life_events_engine.dart';
import 'life_events_models.dart';

class LifeEventsState {
  const LifeEventsState({
    required this.events,
    this.activeAdaptation,
    this.successMessage,
  });

  final List<LifeEventRecord> events;
  final LifeEventAdaptation? activeAdaptation;
  final String? successMessage;

  List<LifeEventRecord> get activeEvents =>
      events.where((e) => e.isActive).toList();

  LifeEventsState copyWith({
    List<LifeEventRecord>? events,
    LifeEventAdaptation? activeAdaptation,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return LifeEventsState(
      events: events ?? this.events,
      activeAdaptation: activeAdaptation ?? this.activeAdaptation,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class LifeEventsNotifier extends Notifier<LifeEventsState> {
  late final LifeEventsEngine _engine;

  @override
  LifeEventsState build() {
    _engine = const LifeEventsEngine();
    return const LifeEventsState(events: []);
  }

  void logLifeEvent(
    LifeEventRecord event,
    TransformationMemoryRepository memoryRepo,
  ) {
    final updatedEvents = [event, ...state.events];
    final adaptation = _engine.adapt(event);

    // Wire event into Transformation Memory
    _engine.wireIntoTransformationMemory(event, memoryRepo);

    state = state.copyWith(
      events: updatedEvents,
      activeAdaptation: adaptation,
      successMessage:
          'Life Event (${event.eventType.name}) logged & wired into Transformation Memory! 🧠',
    );
  }

  void endLifeEvent(String localId) {
    final updatedEvents = state.events.map((e) {
      if (e.localId == localId) {
        return LifeEventRecord(
          localId: e.localId,
          userId: e.userId,
          eventType: e.eventType,
          eventData: e.eventData,
          startDate: e.startDate,
          endDate: DateTime.now(),
          isActive: false,
          createdAt: e.createdAt,
        );
      }
      return e;
    }).toList();

    state = state.copyWith(
      events: updatedEvents,
      activeAdaptation: null,
      successMessage: 'Life Event completed.',
    );
  }
}

final lifeEventsProvider =
    NotifierProvider<LifeEventsNotifier, LifeEventsState>(
  LifeEventsNotifier.new,
);
