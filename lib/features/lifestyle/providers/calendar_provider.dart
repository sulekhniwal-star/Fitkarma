import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/brain/calendar_intelligence_engine.dart';

/// §P12-F Calendar Integration State Model
class CalendarState {
  final bool isConnected;
  final CalendarSource source;
  final DayCalendarInsight? insight;
  final bool isPlanConfirmed;
  final bool useOriginalPlan;
  final bool isLoading;
  final CalendarIntegrationService service;

  const CalendarState({
    this.isConnected = true,
    this.source = CalendarSource.google,
    this.insight,
    this.isPlanConfirmed = false,
    this.useOriginalPlan = false,
    this.isLoading = false,
    this.service = const CalendarIntegrationService(),
  });

  CalendarState copyWith({
    bool? isConnected,
    CalendarSource? source,
    DayCalendarInsight? insight,
    bool? isPlanConfirmed,
    bool? useOriginalPlan,
    bool? isLoading,
  }) {
    return CalendarState(
      isConnected: isConnected ?? this.isConnected,
      source: source ?? this.source,
      insight: insight ?? this.insight,
      isPlanConfirmed: isPlanConfirmed ?? this.isPlanConfirmed,
      useOriginalPlan: useOriginalPlan ?? this.useOriginalPlan,
      isLoading: isLoading ?? this.isLoading,
      service: service,
    );
  }
}

/// §P12-F Calendar Notifier
class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier() : super(const CalendarState()) {
    loadTodayInsight();
  }

  /// Loads and analyzes calendar events for the given date (default today)
  Future<void> loadTodayInsight({DateTime? date, List<CalendarEvent>? mockEvents}) async {
    state = state.copyWith(isLoading: true);
    final targetDate = date ?? DateTime.now();

    final insight = await state.service.analyze(
      targetDate,
      source: state.source,
      mockEvents: mockEvents,
    );

    state = state.copyWith(
      insight: insight,
      isLoading: false,
      isPlanConfirmed: false,
      useOriginalPlan: false,
    );
  }

  /// Confirms the calendar-adapted workout plan (§P12-F "[Confirm Adapted Plan]")
  void confirmAdaptedPlan() {
    state = state.copyWith(
      isPlanConfirmed: true,
      useOriginalPlan: false,
    );
  }

  /// Rejects the adaptation and sticks to original routine (§P12-F "[Keep Original Plan]")
  void keepOriginalPlan() {
    state = state.copyWith(
      isPlanConfirmed: false,
      useOriginalPlan: true,
    );
  }

  /// Connects to a specific calendar source
  void connectCalendar(CalendarSource source) {
    state = state.copyWith(
      isConnected: true,
      source: source,
    );
    loadTodayInsight();
  }

  /// Disconnects calendar access per §P12-F Privacy settings
  void disconnectCalendar() {
    state = state.copyWith(
      isConnected: false,
      insight: null,
      isPlanConfirmed: false,
      useOriginalPlan: false,
    );
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) => CalendarNotifier(),
);
