/// §P12-F Smart Calendar Integration — Unit & Widget Tests

import 'package:fitkarma/features/calendar/calendar_controller.dart';
import 'package:fitkarma/features/calendar/calendar_integration_service.dart';
import 'package:fitkarma/features/calendar/calendar_models.dart';
import 'package:fitkarma/features/calendar/calendar_sync_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = CalendarIntegrationService();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: CalendarSyncScreen(),
      ),
    );
  }

  group('§P12-F CalendarIntegrationService Analysis Unit Tests', () {
    test('detects busy day and generates 20-min express workout for > 6h meetings', () {
      final date = DateTime(2026, 7, 25);
      final events = [
        CalendarEvent(
          id: '1',
          title: 'Quarterly Business Review',
          startTime: DateTime(2026, 7, 25, 9, 0),
          endTime: DateTime(2026, 7, 25, 13, 0), // 240 mins
        ),
        CalendarEvent(
          id: '2',
          title: 'Executive Client Strategy Meeting',
          startTime: DateTime(2026, 7, 25, 14, 0),
          endTime: DateTime(2026, 7, 25, 17, 30), // 210 mins (Total = 450 mins = 7.5 hrs)
        ),
      ];

      final insight = service.analyze(date, events);

      expect(insight.totalMeetingMinutes, equals(450));
      expect(insight.isBusyDay, isTrue); // > 300 mins
      expect(insight.workoutRecommendation.recommendedDurationMin, equals(20));
      expect(insight.workoutRecommendation.type, contains('Quick 20-min Express'));
      expect(insight.nutritionNote, contains('healthy snacks'));
    });

    test('detects wedding special event and generates 20-min light morning workout', () {
      final date = DateTime(2026, 7, 25);
      final events = [
        CalendarEvent(
          id: '1',
          title: 'Sister Wedding Ceremony & Reception',
          startTime: DateTime(2026, 7, 25, 10, 0),
          endTime: DateTime(2026, 7, 25, 16, 0),
        ),
      ];

      final insight = service.analyze(date, events);

      expect(insight.specialEvent, equals(SpecialEvent.wedding));
      expect(insight.workoutRecommendation.recommendedDurationMin, equals(20));
      expect(insight.workoutRecommendation.type, contains('Morning Mobility'));
      expect(insight.nutritionNote, contains('Festive celebration'));
    });

    test('detects travel/flight special event and generates travel nutrition note', () {
      final date = DateTime(2026, 7, 25);
      final events = [
        CalendarEvent(
          id: '1',
          title: 'Flight BA142 to London Airport',
          startTime: DateTime(2026, 7, 25, 6, 0),
          endTime: DateTime(2026, 7, 25, 15, 0),
        ),
      ];

      final insight = service.analyze(date, events);

      expect(insight.specialEvent, equals(SpecialEvent.travel));
      expect(insight.workoutRecommendation.type, contains('Hotel Bodyweight'));
      expect(insight.nutritionNote, contains('Travel day'));
    });
  });

  group('§P12-F CalendarNotifier Integration Tests', () {
    test('toggles account sync sources and auto-adaptation settings', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(calendarProvider.notifier);

      notifier.toggleSource(CalendarSource.apple, true);
      var state = container.read(calendarProvider);

      expect(state.isAppleSynced, isTrue);
      expect(state.successMessage, contains('APPLE Calendar sync enabled'));

      notifier.toggleAutoAdaptation(false);
      state = container.read(calendarProvider);

      expect(state.isAutoAdaptationEnabled, isFalse);
    });

    test('adding a new meeting event re-evaluates calendar insight', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(calendarProvider.notifier);

      final newEvent = CalendarEvent(
        id: 'cal_new',
        title: 'Emergency Board Meeting (Deadline)',
        startTime: DateTime.now().add(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 5)), // 240 mins
      );

      notifier.addEvent(newEvent);
      final state = container.read(calendarProvider);

      expect(state.events.any((e) => e.id == 'cal_new'), isTrue);
      expect(state.insight.isBusyDay, isTrue);
    });
  });

  group('§P12-F CalendarSyncScreen Widget Tests', () {
    testWidgets('renders sync accounts, auto-adaptation switch, and analysis preview', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('📅 Smart Calendar Sync'), findsOneWidget);
      expect(find.text('Google Calendar'), findsOneWidget);
      expect(find.text('Microsoft Outlook'), findsOneWidget);
      expect(find.text('Apple / Device Calendar'), findsOneWidget);
      expect(find.text('Auto-Shorten Workouts on Heavy Days'), findsOneWidget);
      expect(find.textContaining('Today\'s Calendar Analysis & Adaptation'), findsOneWidget);
    });

    testWidgets('toggles Google Calendar switch and triggers SnackBar feedback', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final googleSwitch = find.byType(Switch).first;
      await tester.tap(googleSwitch);
      await tester.pumpAndSettle();

      expect(find.textContaining('GOOGLE Calendar sync disabled'), findsOneWidget);
    });
  });
}
