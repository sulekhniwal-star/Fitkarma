import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/daily_mission/widgets/calendar_briefing_card.dart';
import 'package:fitkarma/features/daily_mission/screens/daily_briefing_screen.dart';
import 'package:fitkarma/core/brain/calendar_intelligence_engine.dart';

void main() {
  testWidgets(
      'CalendarIntelligenceCard renders §P12-F wireframe content properly',
      (tester) async {
    final testInsight = DayCalendarInsight(
      date: DateTime.now(),
      totalMeetingMinutes: 390,
      meetingCount: 8,
      isBusyDay: true,
      hasMorningCommitment: true,
      hasEveningEvent: true,
      workoutRecommendation: const WorkoutRecommendation(
        type: '20-min HIIT (meeting-day protocol)',
        standardType: '45-min strength session',
        rationale:
            'Heavy meeting day — shortened workout better than skipping entirely.',
        targetMinutes: 20,
        isAdapted: true,
      ),
      nutritionNote:
          'Heavy cognitive load day → craving more carbs is normal. Keep a healthy snack nearby to avoid vending machine.',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CalendarIntelligenceCard(
              insight: testInsight,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Meeting Summary
    expect(find.text('Calendar Intelligence — Today'), findsOneWidget);
    expect(find.text('8 meetings · 6.5 hours of calls'), findsOneWidget);

    // Verify Workout Comparison
    expect(find.text('Your workout has been adapted:'), findsOneWidget);
    expect(find.text('45-min strength session'), findsOneWidget);
    expect(find.text('20-min HIIT (meeting-day protocol)'), findsOneWidget);

    // Verify Nutrition Note
    expect(
        find.text(
            'Heavy cognitive load day → craving more carbs is normal. Keep a healthy snack nearby to avoid vending machine.'),
        findsOneWidget);

    // Verify Decision Buttons
    expect(find.text('Confirm Adapted Plan'), findsOneWidget);
    expect(find.text('Keep Original Plan'), findsOneWidget);
  });

  testWidgets('Tapping Confirm Adapted Plan shows confirmed state',
      (tester) async {
    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: CalendarIntelligenceCard(
              insight: DayCalendarInsight(
                date: DateTime.now(),
                totalMeetingMinutes: 360,
                meetingCount: 6,
                isBusyDay: true,
                hasMorningCommitment: false,
                hasEveningEvent: false,
                workoutRecommendation: const WorkoutRecommendation(
                  type: '20-min HIIT (meeting-day protocol)',
                  standardType: '45-min strength session',
                  rationale: 'Meeting day protocol',
                  targetMinutes: 20,
                  isAdapted: true,
                ),
                nutritionNote: 'Focus on clean snacks',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Confirm
    await tester.tap(find.text('Confirm Adapted Plan'));
    await tester.pumpAndSettle();

    expect(find.text('Adapted Plan Confirmed'), findsOneWidget);
    expect(find.text('Confirm Adapted Plan'), findsNothing);
  });

  testWidgets(
      'DailyBriefingScreen renders CalendarIntelligenceCard when connected',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: DailyBriefingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Calendar Intelligence — Today'), findsOneWidget);
  });
}
