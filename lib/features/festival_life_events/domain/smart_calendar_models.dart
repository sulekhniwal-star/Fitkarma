import 'package:flutter/foundation.dart';

/// Event type / intensity category in user's calendar
enum CalendarEventType {
  highStressMeeting(
      name: 'Executive / Client Meeting',
      regionalName: 'उच्च तनाव बैठक',
      cognitiveLoad: 8),
  routineWorkBlock(
      name: 'Desk Work & Coding',
      regionalName: 'नियमित कार्य ब्लॉक',
      cognitiveLoad: 4),
  commuteTravel(
      name: 'Transit / Commute',
      regionalName: 'पारगमन व आवागमन',
      cognitiveLoad: 3),
  socialFamilyEvent(
      name: 'Family Gathering / Dinner',
      regionalName: 'पारिवारिक व सामाजिक कार्यक्रम',
      cognitiveLoad: 5),
  freeWindow(
      name: 'Open Schedule Gap',
      regionalName: 'उपलब्ध समय अंतराल',
      cognitiveLoad: 0);

  final String name;
  final String regionalName;
  final int cognitiveLoad; // 0 to 10

  const CalendarEventType({
    required this.name,
    required this.regionalName,
    required this.cognitiveLoad,
  });
}

/// A parsed calendar event block
@immutable
class CalendarEventBlock {
  final String eventId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final CalendarEventType type;

  const CalendarEventBlock({
    required this.eventId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  int get durationMinutes => endTime.difference(startTime).inMinutes;
}

/// Micro-window workout / wellness recommendation slot
@immutable
class SuggestedWellnessSlot {
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String activityName;
  final String regionalActivityName;
  final String rationale;
  final String regionalRationale;
  final bool isOptimalTime;

  const SuggestedWellnessSlot({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.activityName,
    required this.regionalActivityName,
    required this.rationale,
    required this.regionalRationale,
    required this.isOptimalTime,
  });
}

/// Comprehensive Smart Calendar Schedule & Adaptive Plan
@immutable
class SmartCalendarPlanReport {
  final DateTime scheduledDate;
  final List<CalendarEventBlock> scheduledEvents;
  final List<SuggestedWellnessSlot> suggestedSlots;
  final double totalMeetingHours;
  final double totalCognitiveLoadScore; // 0 to 100
  final bool isHighCognitiveBurnoutDay;
  final String
      recommendedWorkoutPacing; // e.g. "Restorative Yoga & Mobility" vs "High-Intensity Strength"
  final String preMeetingMealTimingTip;
  final String regionalPreMeetingMealTimingTip;
  final DateTime generatedAt;

  const SmartCalendarPlanReport({
    required this.scheduledDate,
    required this.scheduledEvents,
    required this.suggestedSlots,
    required this.totalMeetingHours,
    required this.totalCognitiveLoadScore,
    required this.isHighCognitiveBurnoutDay,
    required this.recommendedWorkoutPacing,
    required this.preMeetingMealTimingTip,
    required this.regionalPreMeetingMealTimingTip,
    required this.generatedAt,
  });
}
