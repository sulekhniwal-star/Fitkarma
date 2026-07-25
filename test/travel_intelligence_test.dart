/// §P12-E Travel Intelligence — Unit, Widget & Timezone DIP Scheduling Tests

import 'package:fitkarma/features/travel/travel_controller.dart';
import 'package:fitkarma/features/travel/travel_intelligence_engine.dart';
import 'package:fitkarma/features/travel/travel_mode_screen.dart';
import 'package:fitkarma/features/travel/travel_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const detector = TravelDetector();
  const engine = TravelIntelligenceEngine();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: TravelModeScreen(),
      ),
    );
  }

  group('§P12-E TravelDetector Unit Tests', () {
    test('detects domestic travel mode for same timezone offset', () {
      final ctx = detector.detect(
        origin: 'Delhi',
        destination: 'Mumbai',
        originOffsetMinutes: 330,
        destinationOffsetMinutes: 330,
      );

      expect(ctx.mode, equals(TravelMode.domestic));
      expect(ctx.timezoneDeltaHours, equals(0));
    });

    test('detects international travel mode for timezone offset shift >= 3 hours', () {
      final ctx = detector.detect(
        origin: 'Delhi',
        destination: 'London',
        originOffsetMinutes: 330,
        destinationOffsetMinutes: 0,
      );

      expect(ctx.mode, equals(TravelMode.international));
      expect(ctx.timezoneDeltaHours, equals(6));
      expect(ctx.direction, equals('West'));
    });

    test('detects airport travel mode when location contains Airport keyword', () {
      final ctx = detector.detect(
        origin: 'Delhi',
        destination: 'IGIA Airport Terminal 3',
        originOffsetMinutes: 330,
        destinationOffsetMinutes: 330,
      );

      expect(ctx.mode, equals(TravelMode.airport));
    });
  });

  group('§P12-E TravelIntelligenceEngine Adaptations Tests', () {
    test('generates domestic travel adaptation with +150 kcal buffer & 3.0L water', () {
      final ctx = detector.detect(
        origin: 'Delhi',
        destination: 'Bangalore',
        originOffsetMinutes: 330,
        destinationOffsetMinutes: 330,
      );

      final adapt = engine.adapt(ctx);

      expect(adapt.workoutDurationMin, equals(30));
      expect(adapt.calorieBufferNote, contains('+150 kcal'));
      expect(adapt.hydrationTargetL, equals(3.0));
      expect(adapt.readinessAdjustment, equals(-5));
    });

    test('generates international travel adaptation with jetlag protocol & +200 kcal buffer', () {
      final ctx = detector.detect(
        origin: 'Delhi',
        destination: 'London',
        originOffsetMinutes: 330,
        destinationOffsetMinutes: 0,
      );

      final adapt = engine.adapt(ctx);

      expect(adapt.mode, equals(TravelMode.international));
      expect(adapt.workoutDurationMin, equals(25));
      expect(adapt.calorieBufferNote, contains('+200 kcal'));
      expect(adapt.hydrationTargetL, equals(3.5));
      expect(adapt.readinessAdjustment, equals(-12));
      expect(adapt.jetLagProtocol, isNotNull);
      expect(adapt.jetLagProtocol!.recommendations.any((r) => r.contains('sunlight')), isTrue);
    });
  });

  group('§P12-E 🔒 Timezone-Aware DIP Scheduler Verification Tests (v1.0 Hardening)', () {
    test('DIP generation respects user timezone offset for home (IST +5:30)', () {
      const preferredDIPHour = 6; // 6:00am local
      const istOffsetMinutes = 330; // +5:30

      // UTC 00:30 -> IST 06:00
      final utcTime0030 = DateTime.utc(2026, 7, 25, 0, 30);
      final isDue = TravelIntelligenceEngine.isUserDueForDIP(
        preferredDIPHour: preferredDIPHour,
        timezoneOffsetMinutes: istOffsetMinutes,
        utcTime: utcTime0030,
      );

      expect(isDue, isTrue);
    });

    test('DIP generation respects active Travel Mode destination timezone (GMT +0:00)', () {
      const preferredDIPHour = 6; // 6:00am local
      const gmtOffsetMinutes = 0; // GMT in London during Travel Mode

      // At UTC 00:30 (when IST users get their DIP), GMT user local time is 00:30am -> NOT DUE
      final utcTime0030 = DateTime.utc(2026, 7, 25, 0, 30);
      final isDueAt0030 = TravelIntelligenceEngine.isUserDueForDIP(
        preferredDIPHour: preferredDIPHour,
        timezoneOffsetMinutes: gmtOffsetMinutes,
        utcTime: utcTime0030,
      );
      expect(isDueAt0030, isFalse);

      // At UTC 06:00 -> GMT user local time is 06:00am -> DUE!
      final utcTime0600 = DateTime.utc(2026, 7, 25, 6, 0);
      final isDueAt0600 = TravelIntelligenceEngine.isUserDueForDIP(
        preferredDIPHour: preferredDIPHour,
        timezoneOffsetMinutes: gmtOffsetMinutes,
        utcTime: utcTime0600,
      );
      expect(isDueAt0600, isTrue);
    });
  });

  group('§P12-E TravelModeScreen Widget Tests', () {
    testWidgets('renders Travel Mode header and activates travel mode', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('✈️ Travel Intelligence Mode'), findsOneWidget);
      expect(find.text('🏠 Home Location Active'), findsOneWidget);

      await tester.tap(find.text('Log Upcoming Travel'));
      await tester.pumpAndSettle();

      expect(find.text('Activate Travel Mode'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Activate'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Travel Mode Active').first, findsOneWidget);
      expect(find.text('🎯 Adapted Travel Plan'), findsOneWidget);
    });
  });
}
