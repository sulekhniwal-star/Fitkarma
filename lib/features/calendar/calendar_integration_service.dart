/// §P12-F Calendar Integration Service & Calendar Intelligence Engine
///
/// Analyzes device & cloud calendar events (Google/Outlook/Apple), detects heavy meeting days (>5h),
/// special events (wedding, travel, deadlines), and generates calendar-aware workout & nutrition adaptations matching §P12-F spec.
library;

import 'calendar_models.dart';

class CalendarIntegrationService {
  const CalendarIntegrationService();

  /// Analyzes a list of calendar events for a specific date (§P12-F spec).
  DayCalendarInsight analyze(DateTime date, List<CalendarEvent> events) {
    int meetingMinutes = 0;
    bool hasMorningCommitment = false;
    bool hasEveningEvent = false;
    SpecialEvent specialEvent = SpecialEvent.none;

    for (final event in events) {
      meetingMinutes += event.durationMinutes;

      if (event.startHour < 9) hasMorningCommitment = true;
      if (event.startHour >= 18) hasEveningEvent = true;

      // Keyword detection for special events
      final title = event.title.toLowerCase();
      if (title.contains('wedding') || title.contains('marriage') || title.contains('reception')) {
        specialEvent = SpecialEvent.wedding;
      } else if (title.contains('travel') || title.contains('flight') || title.contains('airport')) {
        specialEvent = SpecialEvent.travel;
      } else if (title.contains('deadline') || title.contains('exam') || title.contains('submission')) {
        specialEvent = SpecialEvent.deadline;
      } else if (title.contains('party') || title.contains('celebration') || title.contains('dinner')) {
        specialEvent = SpecialEvent.party;
      }
    }

    final isBusyDay = meetingMinutes >= 300; // > 5 hours of meetings

    final workoutRec = _workoutRecommendation(meetingMinutes, specialEvent);
    final nutritionNote = _nutritionNote(specialEvent, meetingMinutes);
    final suggestions = _generateSuggestions(meetingMinutes, hasMorningCommitment, hasEveningEvent, specialEvent);

    return DayCalendarInsight(
      totalMeetingMinutes: meetingMinutes,
      isBusyDay: isBusyDay,
      hasMorningCommitment: hasMorningCommitment,
      hasEveningEvent: hasEveningEvent,
      specialEvent: specialEvent,
      workoutRecommendation: workoutRec,
      nutritionNote: nutritionNote,
      schedulingSuggestions: suggestions,
    );
  }

  WorkoutRecommendation _workoutRecommendation(int meetingMinutes, SpecialEvent specialEvent) {
    if (specialEvent == SpecialEvent.wedding) {
      return const WorkoutRecommendation(
        type: 'Light 20-min Morning Mobility & Stretch',
        recommendedDurationMin: 20,
        rationale: 'Wedding day — brief morning workout keeps energy high without fatigue.',
      );
    }

    if (specialEvent == SpecialEvent.travel) {
      return const WorkoutRecommendation(
        type: '25-min Hotel Bodyweight Session',
        recommendedDurationMin: 25,
        rationale: 'Travel day — quick bodyweight session keeps momentum high while away.',
      );
    }

    if (meetingMinutes >= 360) {
      // > 6 hours of meetings
      return const WorkoutRecommendation(
        type: 'Quick 20-min Express HIIT or Walk',
        recommendedDurationMin: 20,
        rationale: 'Heavy meeting day (6+ hrs) — shortened workout is far better than skipping.',
      );
    }

    if (meetingMinutes >= 240) {
      // > 4 hours of meetings
      return const WorkoutRecommendation(
        type: '30-min Express Resistance Session',
        recommendedDurationMin: 30,
        rationale: 'Moderate meeting schedule (4+ hrs) — streamlined 30-min session recommended.',
      );
    }

    return WorkoutRecommendation.standard();
  }

  String _nutritionNote(SpecialEvent specialEvent, int meetingMinutes) {
    if (specialEvent == SpecialEvent.wedding || specialEvent == SpecialEvent.party) {
      return '🎉 Festive celebration event: Prioritize protein at lunch; enjoy event foods guilt-free.';
    }
    if (specialEvent == SpecialEvent.travel) {
      return '✈️ Travel day: Carry almonds/seeds; drink +500ml extra water for cabin air dryness.';
    }
    if (meetingMinutes >= 300) {
      return '💼 Heavy meeting day: Keep quick healthy snacks (roasted chana, makhana, fruit) at desk to avoid junk food cravings.';
    }
    return '🥗 Standard balanced nutrition plan.';
  }

  List<String> _generateSuggestions(
    int meetingMinutes,
    bool morningCommitment,
    bool eveningEvent,
    SpecialEvent specialEvent,
  ) {
    final list = <String>[];

    if (morningCommitment) {
      list.add('Morning meeting before 9 AM: Schedule workout for 5:30 PM or lunchtime.');
    } else {
      list.add('Morning open: Ideal 7:00 AM workout window.');
    }

    if (meetingMinutes >= 300) {
      list.add('Heavy meeting schedule detected: FitKarma auto-shortened workout to 20 mins.');
    }

    if (eveningEvent) {
      list.add('Evening commitment detected: Complete 15-min walk during lunch break.');
    }

    return list;
  }

  /// Returns sample mock calendar events for testing & demonstration (§P12-F spec).
  List<CalendarEvent> getSampleDeviceEvents(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);

    return [
      CalendarEvent(
        id: 'cal_1',
        title: 'Morning Executive Sync',
        startTime: startOfDay.add(const Duration(hours: 8, minutes: 30)),
        endTime: startOfDay.add(const Duration(hours: 9, minutes: 30)),
        source: CalendarSource.outlook,
      ),
      CalendarEvent(
        id: 'cal_2',
        title: 'Product Roadmap Review & Sprint Planning',
        startTime: startOfDay.add(const Duration(hours: 10, minutes: 0)),
        endTime: startOfDay.add(const Duration(hours: 13, minutes: 0)),
        source: CalendarSource.google,
      ),
      CalendarEvent(
        id: 'cal_3',
        title: 'Client Strategy Presentation (Deadline Submission)',
        startTime: startOfDay.add(const Duration(hours: 14, minutes: 0)),
        endTime: startOfDay.add(const Duration(hours: 17, minutes: 30)),
        source: CalendarSource.google,
      ),
    ];
  }
}
