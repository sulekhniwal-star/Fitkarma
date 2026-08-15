import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/life_events_engine.dart';
import 'package:fitkarma/features/lifestyle/screens/life_events_screen.dart';

void main() {
  group('§P12-B Life Events Engine Tests', () {
    const engine = LifeEventsEngine();

    test(
        'LifeEventsEngine adapt returns injury isolation & recovery-first adaptation',
        () {
      final event = LifeEvent(
        id: 'e1',
        title: 'Knee Injury',
        type: LifeEventType.injury,
        startDate: DateTime.now(),
        injuredRegion: 'Right Knee',
      );

      final adapt = engine.adapt(event);
      expect(adapt.isRecoveryFirst, isTrue);
      expect(adapt.workoutFocus, contains('Right Knee isolated'));
      expect(adapt.workoutDurationMins, equals(20));
      expect(adapt.coachTone, contains('Empathetic'));
    });

    test(
        'LifeEventsEngine adapt returns time-compressed 15-min workout for office deadline',
        () {
      final event = LifeEvent(
        id: 'e2',
        title: 'Q3 Product Release',
        type: LifeEventType.officeDeadline,
        startDate: DateTime.now(),
      );

      final adapt = engine.adapt(event);
      expect(adapt.workoutDurationMins, equals(15));
      expect(adapt.simplifyNutrition, isTrue);
      expect(adapt.coachTone, contains('Focused'));
    });

    test(
        'LifeEventsEngine adapt handles travel abroad with jet lag hydration multiplier',
        () {
      final event = LifeEvent(
        id: 'e3',
        title: 'Trip to Tokyo',
        type: LifeEventType.travelAbroad,
        startDate: DateTime.now(),
        timezone: 'JST',
      );

      final adapt = engine.adapt(event);
      expect(adapt.hydrationMultiplier, equals(1.4));
      expect(adapt.workoutFocus, contains('Bodyweight hotel circuit'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'LifeEventsScreen renders selector tiles and updates active module adaptations',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LifeEventsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Life Events Engine 🌟'), findsOneWidget);
      expect(find.text('Active Module Adaptations'), findsOneWidget);
      expect(find.textContaining('Work / Office Deadline'), findsOneWidget);

      await tester.tap(find.textContaining('Work / Office Deadline'));
      await tester.pumpAndSettle();

      expect(find.text('ACTIVE LIFE EVENT'), findsOneWidget);
      expect(find.text('Office Deadline'), findsOneWidget);
      expect(find.textContaining('15 mins/day'), findsOneWidget);
    });
  });
}
