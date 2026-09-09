import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/festival_life_events/domain/smart_calendar_engine.dart';
import 'package:fitkarma/features/festival_life_events/domain/smart_calendar_models.dart';
import 'package:fitkarma/features/festival_life_events/presentation/providers/smart_calendar_provider.dart';

void main() {
  group('Smart Calendar Engine Tests', () {
    const engine = SmartCalendarEngine();
    final testDate = DateTime(2026, 9, 9);

    test('Corporate day schedule calculates meeting hours and cognitive load', () {
      final sampleEvents = SmartCalendarEngine.sampleCorporateDay(testDate);
      final report = engine.generateSchedulePlan(targetDate: testDate, events: sampleEvents);

      expect(report.scheduledEvents.length, equals(4));
      expect(report.totalMeetingHours, greaterThan(4.0));
      expect(report.totalCognitiveLoadScore, greaterThan(0));
      expect(report.suggestedSlots.isNotEmpty, isTrue);
      expect(report.preMeetingMealTimingTip.isNotEmpty, isTrue);
      expect(report.regionalPreMeetingMealTimingTip.isNotEmpty, isTrue);
    });

    test('Identifies Shatapadi digestive walk during midday lunch gap', () {
      final events = [
        CalendarEventBlock(
          eventId: 'evt_morning',
          title: 'Morning Sync',
          startTime: DateTime(testDate.year, testDate.month, testDate.day, 10, 0),
          endTime: DateTime(testDate.year, testDate.month, testDate.day, 12, 0),
          type: CalendarEventType.routineWorkBlock,
        ),
        CalendarEventBlock(
          eventId: 'evt_afternoon',
          title: 'Afternoon Client Pitch',
          startTime: DateTime(testDate.year, testDate.month, testDate.day, 14, 30),
          endTime: DateTime(testDate.year, testDate.month, testDate.day, 16, 0),
          type: CalendarEventType.highStressMeeting,
        ),
      ];

      final report = engine.generateSchedulePlan(targetDate: testDate, events: events);
      
      // Should find a lunchtime gap with Shatapadi
      final shatapadiSlot = report.suggestedSlots.firstWhere(
        (s) => s.activityName.contains('Shatapadi'),
        orElse: () => throw Exception('Shatapadi slot not found'),
      );

      expect(shatapadiSlot.durationMinutes, greaterThanOrEqualTo(10));
      expect(shatapadiSlot.regionalActivityName, contains('शतपावली'));
    });

    test('High cognitive stress day switches recommended workout to restorative pacing', () {
      final highStressEvents = [
        CalendarEventBlock(
          eventId: 'evt_1',
          title: 'Board Meeting',
          startTime: DateTime(testDate.year, testDate.month, testDate.day, 9, 0),
          endTime: DateTime(testDate.year, testDate.month, testDate.day, 12, 0),
          type: CalendarEventType.highStressMeeting,
        ),
        CalendarEventBlock(
          eventId: 'evt_2',
          title: 'Client Negotiation',
          startTime: DateTime(testDate.year, testDate.month, testDate.day, 13, 0),
          endTime: DateTime(testDate.year, testDate.month, testDate.day, 16, 0),
          type: CalendarEventType.highStressMeeting,
        ),
        CalendarEventBlock(
          eventId: 'evt_3',
          title: 'Crisis Management',
          startTime: DateTime(testDate.year, testDate.month, testDate.day, 16, 30),
          endTime: DateTime(testDate.year, testDate.month, testDate.day, 19, 0),
          type: CalendarEventType.highStressMeeting,
        ),
      ];

      final report = engine.generateSchedulePlan(targetDate: testDate, events: highStressEvents);

      expect(report.isHighCognitiveBurnoutDay, isTrue);
      expect(report.recommendedWorkoutPacing, contains('Restorative Yoga'));
    });

    test('Empty day schedule returns zero meetings and active hypertrophy pacing', () {
      final report = engine.generateSchedulePlan(targetDate: testDate, events: const []);

      expect(report.scheduledEvents.isEmpty, isTrue);
      expect(report.totalMeetingHours, equals(0.0));
      expect(report.totalCognitiveLoadScore, equals(0.0));
      expect(report.isHighCognitiveBurnoutDay, isFalse);
      expect(report.recommendedWorkoutPacing, contains('High Intensity Strength'));
    });
  });

  group('Smart Calendar Notifier Provider Tests', () {
    test('StateNotifier adds and removes events seamlessly', () {
      final notifier = SmartCalendarNotifier();
      final initialCount = notifier.state.scheduledEvents.length;

      final newEvent = CalendarEventBlock(
        eventId: 'test_evt_99',
        title: 'Emergency Sync',
        startTime: DateTime(2026, 9, 9, 19, 0),
        endTime: DateTime(2026, 9, 9, 20, 0),
        type: CalendarEventType.highStressMeeting,
      );

      notifier.addEvent(newEvent);
      expect(notifier.state.scheduledEvents.length, equals(initialCount + 1));

      notifier.removeEvent('test_evt_99');
      expect(notifier.state.scheduledEvents.length, equals(initialCount));

      notifier.clearAllEvents();
      expect(notifier.state.scheduledEvents.isEmpty, isTrue);
      expect(notifier.state.totalMeetingHours, equals(0.0));

      notifier.resetToSampleDay();
      expect(notifier.state.scheduledEvents.isNotEmpty, isTrue);
    });
  });
}
