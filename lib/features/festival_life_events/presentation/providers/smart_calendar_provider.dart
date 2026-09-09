import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/smart_calendar_engine.dart';
import '../../domain/smart_calendar_models.dart';

final smartCalendarProvider =
    StateNotifierProvider<SmartCalendarNotifier, SmartCalendarPlanReport>((ref) {
  return SmartCalendarNotifier();
});

class SmartCalendarNotifier extends StateNotifier<SmartCalendarPlanReport> {
  SmartCalendarNotifier() : super(_buildInitialReport());

  static final SmartCalendarEngine _engine = const SmartCalendarEngine();

  static SmartCalendarPlanReport _buildInitialReport() {
    final now = DateTime.now();
    final events = SmartCalendarEngine.sampleCorporateDay(now);
    return _engine.generateSchedulePlan(targetDate: now, events: events);
  }

  void addEvent(CalendarEventBlock event) {
    final updatedEvents = List<CalendarEventBlock>.from(state.scheduledEvents)..add(event);
    state = _engine.generateSchedulePlan(
      targetDate: state.scheduledDate,
      events: updatedEvents,
    );
  }

  void removeEvent(String eventId) {
    final updatedEvents = state.scheduledEvents.where((e) => e.eventId != eventId).toList();
    state = _engine.generateSchedulePlan(
      targetDate: state.scheduledDate,
      events: updatedEvents,
    );
  }

  void resetToSampleDay() {
    final now = DateTime.now();
    final events = SmartCalendarEngine.sampleCorporateDay(now);
    state = _engine.generateSchedulePlan(targetDate: now, events: events);
  }

  void clearAllEvents() {
    state = _engine.generateSchedulePlan(targetDate: state.scheduledDate, events: const []);
  }
}
