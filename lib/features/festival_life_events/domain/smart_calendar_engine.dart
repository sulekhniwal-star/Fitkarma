import 'smart_calendar_models.dart';

/// Pure Dart Deterministic Engine for Smart Calendar Integration & Micro-window Wellness Allocation
class SmartCalendarEngine {
  const SmartCalendarEngine();

  /// Generates a complete adaptive smart calendar plan report
  SmartCalendarPlanReport generateSchedulePlan({
    required DateTime targetDate,
    required List<CalendarEventBlock> events,
  }) {
    // Sort events chronologically
    final sortedEvents = List<CalendarEventBlock>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    // Calculate total busy / meeting hours & cognitive load
    double totalBusyMinutes = 0;
    double rawCognitiveScore = 0;

    for (final event in sortedEvents) {
      final durationMin = event.durationMinutes > 0 ? event.durationMinutes : 0;
      totalBusyMinutes += durationMin;
      final durationHours = durationMin / 60.0;
      rawCognitiveScore += durationHours * (event.type.cognitiveLoad * 1.8);
    }

    final totalMeetingHours = totalBusyMinutes / 60.0;
    final totalCognitiveLoadScore = rawCognitiveScore.clamp(0.0, 100.0);
    final isHighBurnout = totalCognitiveLoadScore >= 60.0 || totalMeetingHours >= 5.5;

    // Recommended workout pacing based on cognitive fatigue
    final String workoutPacing;
    if (isHighBurnout) {
      workoutPacing = 'Restorative Yoga, Breathwork & Light Mobility (कम तनाव पुनर्प्राप्ति योग व प्राणायाम)';
    } else if (totalCognitiveLoadScore >= 35.0 || totalMeetingHours >= 3.5) {
      workoutPacing = 'Zone 2 Cardio, Functional Posture & Core Stability (मध्यम कार्डियो एवं कोर सुदृढ़ीकरण)';
    } else {
      workoutPacing = 'High Intensity Strength & Hypertrophy Training (उच्च तीव्रता स्ट्रेंथ व वेट ट्रेनिंग)';
    }

    // Identify micro-wellness slots between 06:00 and 22:00
    final suggestedSlots = _identifyWellnessSlots(
      targetDate: targetDate,
      events: sortedEvents,
      isHighBurnout: isHighBurnout,
    );

    // Pre-meeting meal timing guidance
    final mealTips = _computeMealTimingTip(sortedEvents);

    return SmartCalendarPlanReport(
      scheduledDate: targetDate,
      scheduledEvents: sortedEvents,
      suggestedSlots: suggestedSlots,
      totalMeetingHours: double.parse(totalMeetingHours.toStringAsFixed(1)),
      totalCognitiveLoadScore: double.parse(totalCognitiveLoadScore.toStringAsFixed(1)),
      isHighCognitiveBurnoutDay: isHighBurnout,
      recommendedWorkoutPacing: workoutPacing,
      preMeetingMealTimingTip: mealTips.english,
      regionalPreMeetingMealTimingTip: mealTips.hindi,
      generatedAt: DateTime.now(),
    );
  }

  /// Extracts available schedule gaps and assigns targeted wellness micro-routines
  List<SuggestedWellnessSlot> _identifyWellnessSlots({
    required DateTime targetDate,
    required List<CalendarEventBlock> events,
    required bool isHighBurnout,
  }) {
    final List<SuggestedWellnessSlot> slots = [];
    final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day, 6, 0);
    final dayEnd = DateTime(targetDate.year, targetDate.month, targetDate.day, 22, 0);

    DateTime currentCursor = dayStart;

    for (final event in events) {
      if (event.startTime.isAfter(currentCursor)) {
        final gapMinutes = event.startTime.difference(currentCursor).inMinutes;
        if (gapMinutes >= 10) {
          final slot = _categorizeGapSlot(
            start: currentCursor,
            end: event.startTime,
            gapMinutes: gapMinutes,
            nextEvent: event,
            isHighBurnout: isHighBurnout,
          );
          if (slot != null) {
            slots.add(slot);
          }
        }
      }
      if (event.endTime.isAfter(currentCursor)) {
        currentCursor = event.endTime;
      }
    }

    // Check evening gap after last event until dayEnd
    if (currentCursor.isBefore(dayEnd)) {
      final eveningGap = dayEnd.difference(currentCursor).inMinutes;
      if (eveningGap >= 15) {
        slots.add(
          SuggestedWellnessSlot(
            startTime: currentCursor,
            endTime: dayEnd,
            durationMinutes: eveningGap,
            activityName: isHighBurnout
                ? 'Nidra Yoga & Parasympathetic Reset'
                : 'Evening Decompression & Foam Rolling',
            regionalActivityName: isHighBurnout
                ? 'योग निद्रा व तंत्रिका तंत्र विश्राम'
                : 'शाम का तनाव मुक्ति स्ट्रेचिंग व विश्राम',
            rationale: 'Dissolves residual cortisol before dinner to protect deep REM sleep architecture.',
            regionalRationale: 'गहरी नींद व तनाव मुक्ति हेतु शाम का विशेष विश्राम समय।',
            isOptimalTime: true,
          ),
        );
      }
    }

    return slots;
  }

  SuggestedWellnessSlot? _categorizeGapSlot({
    required DateTime start,
    required DateTime end,
    required int gapMinutes,
    required CalendarEventBlock nextEvent,
    required bool isHighBurnout,
  }) {
    final hour = start.hour;

    // Morning gap before 9:00 AM
    if (hour < 9 && gapMinutes >= 25) {
      return SuggestedWellnessSlot(
        startTime: start,
        endTime: end,
        durationMinutes: gapMinutes,
        activityName: 'Morning Surya Namaskar & Core Activation',
        regionalActivityName: 'प्रातः कालीन सूर्य नमस्कार व कोर सक्रियता',
        rationale: 'Elevates core body temperature and primes metabolic alertness before screen time.',
        regionalRationale: 'दिन भर की ऊर्जा और एकाग्रता के लिए प्रातः सक्रियता।',
        isOptimalTime: true,
      );
    }

    // Midday lunch digestion window (12:00 - 15:00)
    if (hour >= 12 && hour <= 14 && gapMinutes >= 10) {
      return SuggestedWellnessSlot(
        startTime: start,
        endTime: end,
        durationMinutes: gapMinutes,
        activityName: 'Post-Meal Shatapadi Stroll (1,000 Paces)',
        regionalActivityName: 'भोजनोपरांत शतपावली (१०-मिनट टहलना)',
        rationale: 'Blunts post-prandial glucose spike and prevents afternoon 2:30 PM sluggish brain fog.',
        regionalRationale: 'भोजन के बाद रक्त शर्करा नियंत्रण और आलस्य दूर करने हेतु शतपावली।',
        isOptimalTime: true,
      );
    }

    // Buffer right before high-stress meeting
    if (nextEvent.type == CalendarEventType.highStressMeeting && gapMinutes >= 5) {
      return SuggestedWellnessSlot(
        startTime: start,
        endTime: end,
        durationMinutes: gapMinutes,
        activityName: 'Anulom Vilom & Box Breathing Buffer',
        regionalActivityName: 'अनुलोम विलोम एवं बॉक्स ब्रीदिंग प्राणायाम',
        rationale: 'Activates vagus nerve, stabilises heart rate variability, and sharpens cognitive clarity.',
        regionalRationale: 'महत्वपूर्ण बैठक से पहले मानसिक शांति और स्पष्टता के लिए प्राणायाम।',
        isOptimalTime: true,
      );
    }

    // General micro-mobility break
    if (gapMinutes >= 15) {
      return SuggestedWellnessSlot(
        startTime: start,
        endTime: end,
        durationMinutes: gapMinutes,
        activityName: 'Desk Posture Reset & Cervical Mobility',
        regionalActivityName: 'डेस्क पोस्चर सुधार एवं गर्दन/कंधे का स्ट्रेच',
        rationale: 'Releases thoracic tension from continuous laptop hunching and improves upper limb blood flow.',
        regionalRationale: 'लैपटॉप पर निरंतर काम से गर्दन व पीठ के तनाव को दूर करने हेतु स्ट्रेच।',
        isOptimalTime: false,
      );
    }

    return null;
  }

  _BilingualTip _computeMealTimingTip(List<CalendarEventBlock> events) {
    if (events.isEmpty) {
      return const _BilingualTip(
        english: 'Maintain balanced 3-meal cadence with steady hydration every 90 minutes.',
        hindi: 'नियमित समय पर संतुलित आहार लें तथा प्रत्येक ९० मिनट में पर्याप्त जल पिएं।',
      );
    }

    // Find first heavy meeting
    final heavyMeeting = events.firstWhere(
      (e) => e.type == CalendarEventType.highStressMeeting || e.durationMinutes >= 90,
      orElse: () => events.first,
    );

    final meetingHour = heavyMeeting.startTime.hour;
    final meetingMinute = heavyMeeting.startTime.minute.toString().padLeft(2, '0');

    return _BilingualTip(
      english: 'Heavy engagement scheduled at $meetingHour:$meetingMinute. Consume a light protein & complex carb snack (e.g., roasted chana + almond butter or buttermilk) 60 min before to eliminate lethargy.',
      hindi: '$meetingHour:$meetingMinute पर महत्वपूर्ण बैठक है। आलस्य से बचने हेतु १ घंटा पूर्व भुना चना, छाछ या हल्का प्रोटीन युक्त अल्पाहार लें।',
    );
  }

  /// Sample corporate work schedule template for quick preview & testing
  static List<CalendarEventBlock> sampleCorporateDay(DateTime date) {
    return [
      CalendarEventBlock(
        eventId: 'evt_1',
        title: 'Engineering Sprint Planning & Standup',
        startTime: DateTime(date.year, date.month, date.day, 9, 30),
        endTime: DateTime(date.year, date.month, date.day, 10, 30),
        type: CalendarEventType.routineWorkBlock,
      ),
      CalendarEventBlock(
        eventId: 'evt_2',
        title: 'Executive Client Strategy Pitch',
        startTime: DateTime(date.year, date.month, date.day, 11, 0),
        endTime: DateTime(date.year, date.month, date.day, 12, 30),
        type: CalendarEventType.highStressMeeting,
      ),
      CalendarEventBlock(
        eventId: 'evt_3',
        title: 'Cross-Functional Design & Product Review',
        startTime: DateTime(date.year, date.month, date.day, 14, 0),
        endTime: DateTime(date.year, date.month, date.day, 15, 15),
        type: CalendarEventType.routineWorkBlock,
      ),
      CalendarEventBlock(
        eventId: 'evt_4',
        title: 'Quarterly OKR & Performance Retrospective',
        startTime: DateTime(date.year, date.month, date.day, 16, 0),
        endTime: DateTime(date.year, date.month, date.day, 17, 30),
        type: CalendarEventType.highStressMeeting,
      ),
    ];
  }
}

class _BilingualTip {
  final String english;
  final String hindi;
  const _BilingualTip({required this.english, required this.hindi});
}
