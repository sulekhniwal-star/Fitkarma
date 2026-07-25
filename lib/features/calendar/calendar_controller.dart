/// §P12-F Calendar Controller & Riverpod Notifier

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calendar_integration_service.dart';
import 'calendar_models.dart';

class CalendarState {
  const CalendarState({
    required this.events,
    required this.insight,
    this.isGoogleSynced = true,
    this.isOutlookSynced = true,
    this.isAppleSynced = false,
    this.isAutoAdaptationEnabled = true,
    this.successMessage,
  });

  final List<CalendarEvent> events;
  final DayCalendarInsight insight;
  final bool isGoogleSynced;
  final bool isOutlookSynced;
  final bool isAppleSynced;
  final bool isAutoAdaptationEnabled;
  final String? successMessage;

  CalendarState copyWith({
    List<CalendarEvent>? events,
    DayCalendarInsight? insight,
    bool? isGoogleSynced,
    bool? isOutlookSynced,
    bool? isAppleSynced,
    bool? isAutoAdaptationEnabled,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return CalendarState(
      events: events ?? this.events,
      insight: insight ?? this.insight,
      isGoogleSynced: isGoogleSynced ?? this.isGoogleSynced,
      isOutlookSynced: isOutlookSynced ?? this.isOutlookSynced,
      isAppleSynced: isAppleSynced ?? this.isAppleSynced,
      isAutoAdaptationEnabled:
          isAutoAdaptationEnabled ?? this.isAutoAdaptationEnabled,
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

class CalendarNotifier extends Notifier<CalendarState> {
  late final CalendarIntegrationService _service;

  @override
  CalendarState build() {
    _service = const CalendarIntegrationService();
    final today = DateTime.now();
    final sampleEvents = _service.getSampleDeviceEvents(today);
    final initialInsight = _service.analyze(today, sampleEvents);

    return CalendarState(
      events: sampleEvents,
      insight: initialInsight,
    );
  }

  void toggleSource(CalendarSource source, bool enabled) {
    bool google = state.isGoogleSynced;
    bool outlook = state.isOutlookSynced;
    bool apple = state.isAppleSynced;

    switch (source) {
      case CalendarSource.google:
        google = enabled;
        break;
      case CalendarSource.outlook:
        outlook = enabled;
        break;
      case CalendarSource.apple:
      case CalendarSource.deviceLocal:
        apple = enabled;
        break;
    }

    state = state.copyWith(
      isGoogleSynced: google,
      isOutlookSynced: outlook,
      isAppleSynced: apple,
      successMessage: '${source.name.toUpperCase()} Calendar sync ${enabled ? "enabled" : "disabled"}.',
    );
  }

  void toggleAutoAdaptation(bool enabled) {
    state = state.copyWith(
      isAutoAdaptationEnabled: enabled,
      successMessage: enabled
          ? 'Auto-adaptation enabled: Workouts will adjust for heavy meeting days (>5h).'
          : 'Auto-adaptation disabled.',
    );
  }

  void addEvent(CalendarEvent event) {
    final updatedEvents = [...state.events, event];
    final updatedInsight = _service.analyze(DateTime.now(), updatedEvents);

    state = state.copyWith(
      events: updatedEvents,
      insight: updatedInsight,
      successMessage: 'Calendar event (${event.title}) synced & analyzed!',
    );
  }
}

final calendarProvider =
    NotifierProvider<CalendarNotifier, CalendarState>(
  CalendarNotifier.new,
);
