/// §P12-F Smart Calendar Integration — Domain Models
///
/// Models for CalendarSource, CalendarEvent, SpecialEvent, and DayCalendarInsight matching §P12-F spec.
library;

enum CalendarSource { google, outlook, apple, deviceLocal }

enum SpecialEvent { wedding, travel, flight, deadline, party, none }

class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.location,
    this.source = CalendarSource.deviceLocal,
  });

  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final CalendarSource source;

  int get durationMinutes => endTime.difference(startTime).inMinutes.abs();

  int get startHour => startTime.hour;
}

class WorkoutRecommendation {
  const WorkoutRecommendation({
    required this.type,
    required this.recommendedDurationMin,
    required this.rationale,
  });

  final String type;
  final int recommendedDurationMin;
  final String rationale;

  factory WorkoutRecommendation.standard() => const WorkoutRecommendation(
        type: 'Standard Scheduled Workout',
        recommendedDurationMin: 45,
        rationale: 'Normal schedule — full workout planned.',
      );
}

class DayCalendarInsight {
  const DayCalendarInsight({
    required this.totalMeetingMinutes,
    required this.isBusyDay,
    required this.hasMorningCommitment,
    required this.hasEveningEvent,
    required this.specialEvent,
    required this.workoutRecommendation,
    required this.nutritionNote,
    required this.schedulingSuggestions,
  });

  final int totalMeetingMinutes;
  final bool isBusyDay;
  final bool hasMorningCommitment;
  final bool hasEveningEvent;
  final SpecialEvent specialEvent;
  final WorkoutRecommendation workoutRecommendation;
  final String nutritionNote;
  final List<String> schedulingSuggestions;

  double get meetingHours => totalMeetingMinutes / 60.0;
}
