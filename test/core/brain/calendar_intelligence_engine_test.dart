import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/calendar_intelligence_engine.dart';

void main() {
  group('§P12-F Calendar Intelligence Engine Tests (Pure Dart)', () {
    const service = CalendarIntegrationService();
    final now = DateTime.now();

    test('Heavy meeting schedule (>6h / >360m) adapts workout to 20-min HIIT meeting-day protocol', () async {
      final heavySchedule = [
        CalendarEvent(id: '1', title: 'Strategy Review', startHour: 9, durationMinutes: 120, date: now),
        CalendarEvent(id: '2', title: 'Product Deep Dive', startHour: 11, durationMinutes: 120, date: now),
        CalendarEvent(id: '3', title: 'Client Workshop', startHour: 14, durationMinutes: 150, date: now),
      ]; // total = 390m (6.5 hours)

      final insight = await service.analyze(now, mockEvents: heavySchedule);

      expect(insight.isBusyDay, isTrue);
      expect(insight.totalMeetingMinutes, equals(390));
      expect(insight.meetingHours, equals(6.5));
      expect(insight.meetingCount, equals(3));
      expect(insight.summaryHeader, equals('3 meetings · 6.5 hours of calls'));
      expect(insight.workoutRecommendation.isAdapted, isTrue);
      expect(insight.workoutRecommendation.type, equals('20-min HIIT (meeting-day protocol)'));
      expect(insight.workoutRecommendation.rationale, contains('Heavy meeting day — shortened workout better than skipping entirely.'));
      expect(insight.nutritionNote, contains('Heavy cognitive load day → craving more carbs is normal.'));
      expect(insight.nutritionNote, contains('Keep a healthy snack nearby to avoid vending machine.'));
    });

    test('Detects wedding event and triggers 20-min light morning workout', () async {
      final weddingSchedule = [
        CalendarEvent(id: '1', title: 'Priya & Rohan Wedding Reception', startHour: 17, durationMinutes: 240, date: now),
      ];

      final insight = await service.analyze(now, mockEvents: weddingSchedule);

      expect(insight.specialEvent, equals(SpecialEvent.wedding));
      expect(insight.workoutRecommendation.isAdapted, isTrue);
      expect(insight.workoutRecommendation.type, equals('Light 20-min morning workout'));
      expect(insight.workoutRecommendation.rationale, contains('Wedding day — brief workout keeps energy high without fatigue for the celebration.'));
      expect(insight.nutritionNote, contains('Wedding celebration: Prioritize hydration'));
    });

    test('Detects travel event and sets travel nutrition hydration note', () async {
      final travelSchedule = [
        CalendarEvent(id: '1', title: 'Flight to Bengaluru Airport', startHour: 7, durationMinutes: 180, date: now),
      ];

      final insight = await service.analyze(now, mockEvents: travelSchedule);

      expect(insight.specialEvent, equals(SpecialEvent.travel));
      expect(insight.hasMorningCommitment, isTrue);
      expect(insight.nutritionNote, contains('Travel day protocol'));
      expect(insight.nutritionNote, contains('Carry a 1L water bottle'));
    });

    test('Standard schedule (<300m) maintains standard 45-min workout', () async {
      final lightSchedule = [
        CalendarEvent(id: '1', title: 'Quick Daily Sync', startHour: 10, durationMinutes: 30, date: now),
        CalendarEvent(id: '2', title: 'Code Review', startHour: 15, durationMinutes: 45, date: now),
      ]; // total = 75m

      final insight = await service.analyze(now, mockEvents: lightSchedule);

      expect(insight.isBusyDay, isFalse);
      expect(insight.totalMeetingMinutes, equals(75));
      expect(insight.workoutRecommendation.isAdapted, isFalse);
      expect(insight.workoutRecommendation.type, equals('45-min strength session'));
      expect(insight.nutritionNote, contains('Standard schedule: Maintain your regular meal timings'));
    });

    test('Detects morning commitments (<9am) and evening commitments (>=6pm)', () async {
      final schedule = [
        CalendarEvent(id: '1', title: 'Early Global Call', startHour: 8, durationMinutes: 45, date: now),
        CalendarEvent(id: '2', title: 'Evening Wrap-up', startHour: 19, durationMinutes: 60, date: now),
      ];

      final insight = await service.analyze(now, mockEvents: schedule);

      expect(insight.hasMorningCommitment, isTrue);
      expect(insight.hasEveningEvent, isTrue);
    });
  });
}
