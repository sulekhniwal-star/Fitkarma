// §P12-F Smart Calendar Integration (NEW v1, Pure Dart, No AI)
// Cross-reference: §P12-F in Fitkarma_documentation.md

enum CalendarSource {
  google,
  outlook,
  local;

  String get displayName {
    switch (this) {
      case CalendarSource.google:
        return 'Google Calendar';
      case CalendarSource.outlook:
        return 'Outlook Calendar';
      case CalendarSource.local:
        return 'Device Calendar';
    }
  }
}

enum SpecialEvent {
  wedding,
  travel,
  none;

  String get displayName {
    switch (this) {
      case SpecialEvent.wedding:
        return 'Wedding / Celebration';
      case SpecialEvent.travel:
        return 'Travel Commitment';
      case SpecialEvent.none:
        return 'None';
    }
  }
}

class CalendarEvent {
  final String id;
  final String title;
  final int startHour;
  final int durationMinutes;
  final DateTime date;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.startHour,
    required this.durationMinutes,
    required this.date,
  });
}

class WorkoutRecommendation {
  final String type;
  final String standardType;
  final String rationale;
  final int targetMinutes;
  final bool isAdapted;

  const WorkoutRecommendation({
    required this.type,
    this.standardType = '45-min strength session',
    required this.rationale,
    this.targetMinutes = 45,
    this.isAdapted = false,
  });

  factory WorkoutRecommendation.standard() {
    return const WorkoutRecommendation(
      type: '45-min strength session',
      standardType: '45-min strength session',
      rationale: 'Standard workout duration aligned with your daily program blueprint.',
      targetMinutes: 45,
      isAdapted: false,
    );
  }

  factory WorkoutRecommendation.shortenedHIIT() {
    return const WorkoutRecommendation(
      type: '20-min HIIT (meeting-day protocol)',
      standardType: '45-min strength session',
      rationale: 'Heavy meeting day — shortened workout better than skipping entirely.',
      targetMinutes: 20,
      isAdapted: true,
    );
  }

  factory WorkoutRecommendation.wedding() {
    return const WorkoutRecommendation(
      type: 'Light 20-min morning workout',
      standardType: '45-min strength session',
      rationale: 'Wedding day — brief workout keeps energy high without fatigue for the celebration.',
      targetMinutes: 20,
      isAdapted: true,
    );
  }
}

class DayCalendarInsight {
  final DateTime date;
  final int totalMeetingMinutes;
  final int meetingCount;
  final bool isBusyDay;
  final bool hasMorningCommitment;
  final bool hasEveningEvent;
  final SpecialEvent? specialEvent;
  final WorkoutRecommendation workoutRecommendation;
  final String nutritionNote;
  final bool isConnected;

  const DayCalendarInsight({
    required this.date,
    required this.totalMeetingMinutes,
    required this.meetingCount,
    required this.isBusyDay,
    required this.hasMorningCommitment,
    required this.hasEveningEvent,
    this.specialEvent,
    required this.workoutRecommendation,
    required this.nutritionNote,
    this.isConnected = true,
  });

  double get meetingHours =>
      double.parse((totalMeetingMinutes / 60.0).toStringAsFixed(1));

  String get summaryHeader =>
      '$meetingCount meetings · $meetingHours hours of calls';
}

/// Abstract Calendar API Interface for on-device read-only fetching
abstract class CalendarApi {
  Future<List<CalendarEvent>> getEvents(DateTime date, CalendarSource source);
}

/// Mock / Local On-Device Implementation of Calendar API
class LocalCalendarApi implements CalendarApi {
  final List<CalendarEvent>? _mockEvents;

  const LocalCalendarApi([this._mockEvents]);

  @override
  Future<List<CalendarEvent>> getEvents(DateTime date, CalendarSource source) async {
    if (_mockEvents != null) {
      return _mockEvents!;
    }

    // Default simulated busy work schedule (8 meetings, ~6.5 hours of calls)
    return [
      CalendarEvent(id: '1', title: 'Sprint Standup', startHour: 8, durationMinutes: 30, date: date),
      CalendarEvent(id: '2', title: 'Product Architecture Review', startHour: 10, durationMinutes: 60, date: date),
      CalendarEvent(id: '3', title: 'Client Quarterly Sync', startHour: 11, durationMinutes: 45, date: date),
      CalendarEvent(id: '4', title: 'Engineering 1:1', startHour: 13, durationMinutes: 45, date: date),
      CalendarEvent(id: '5', title: 'Design System Sprint', startHour: 14, durationMinutes: 60, date: date),
      CalendarEvent(id: '6', title: 'Executive Briefing', startHour: 15, durationMinutes: 60, date: date),
      CalendarEvent(id: '7', title: 'Operations Catch-up', startHour: 16, durationMinutes: 30, date: date),
      CalendarEvent(id: '8', title: 'Evening Wrap-up & Planning', startHour: 18, durationMinutes: 60, date: date),
    ];
  }
}

/// §P12-F CalendarIntelligenceEngine / CalendarIntegrationService
class CalendarIntegrationService {
  final CalendarApi _calendarApi;

  const CalendarIntegrationService([CalendarApi? calendarApi])
      : _calendarApi = calendarApi ?? const LocalCalendarApi();

  /// Analyzes calendar for a given date and generates adaptive DayCalendarInsight
  Future<DayCalendarInsight> analyze(
    DateTime date, {
    CalendarSource source = CalendarSource.google,
    List<CalendarEvent>? mockEvents,
  }) async {
    final api = mockEvents != null ? LocalCalendarApi(mockEvents) : _calendarApi;
    final events = await api.getEvents(date, source);

    int meetingMinutes = 0;
    int meetingCount = events.length;
    bool hasMorningCommitment = false;
    bool hasEveningEvent = false;
    SpecialEvent? specialEvent;

    for (final event in events) {
      meetingMinutes += event.durationMinutes;
      if (event.startHour < 9) hasMorningCommitment = true;
      if (event.startHour >= 18) hasEveningEvent = true;

      // On-device title keyword scanning
      final lowerTitle = event.title.toLowerCase();
      if (_containsAny(lowerTitle, ['wedding', 'marriage', 'reception', 'sangeet', 'mehendi'])) {
        specialEvent = SpecialEvent.wedding;
      } else if (_containsAny(lowerTitle, ['travel', 'flight', 'airport', 'boarding', 'train journey'])) {
        specialEvent = SpecialEvent.travel;
      }
    }

    return DayCalendarInsight(
      date: date,
      totalMeetingMinutes: meetingMinutes,
      meetingCount: meetingCount,
      isBusyDay: meetingMinutes > 300, // >5h of meetings (§P12-F)
      hasMorningCommitment: hasMorningCommitment,
      hasEveningEvent: hasEveningEvent,
      specialEvent: specialEvent,
      workoutRecommendation: _workoutRecommendation(meetingMinutes, specialEvent),
      nutritionNote: _nutritionNote(specialEvent, meetingMinutes),
      isConnected: true,
    );
  }

  WorkoutRecommendation _workoutRecommendation(
    int meetingMinutes,
    SpecialEvent? event,
  ) {
    if (event == SpecialEvent.wedding) {
      return WorkoutRecommendation.wedding();
    }

    if (meetingMinutes > 360) { // >6h meetings (§P12-F)
      return WorkoutRecommendation.shortenedHIIT();
    }

    if (meetingMinutes > 300) { // >5h meetings
      return const WorkoutRecommendation(
        type: '30-min Express Workout',
        standardType: '45-min strength session',
        rationale: 'Busy schedule (>5h calls) — condensed training session to protect recovery.',
        targetMinutes: 30,
        isAdapted: true,
      );
    }

    return WorkoutRecommendation.standard();
  }

  String _nutritionNote(SpecialEvent? event, int meetingMinutes) {
    if (event == SpecialEvent.wedding) {
      return 'Wedding celebration: Prioritize hydration and a high-protein lunch to balance evening festivities.';
    }

    if (event == SpecialEvent.travel) {
      return 'Travel day protocol: Carry a 1L water bottle and healthy nuts/sprouts for on-the-go nutrition.';
    }

    if (meetingMinutes > 300) { // Heavy cognitive load day
      return 'Heavy cognitive load day → craving more carbs is normal. Keep a healthy snack nearby to avoid vending machine.';
    }

    return 'Standard schedule: Maintain your regular meal timings and macro split.';
  }

  bool _containsAny(String text, List<String> keywords) {
    for (final kw in keywords) {
      if (text.contains(kw)) return true;
    }
    return false;
  }
}
