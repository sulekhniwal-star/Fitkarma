import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/medication_tracker_engine.dart';
import 'package:fitkarma/features/predictive_health/screens/medication_tracker_screen.dart';

void main() {
  group('§P10-I Medication Tracker & Interaction Warning Engine Tests', () {
    const engine = DrugInteractionEngine();
    const service = RxNavInteractionService();

    test('checkSchedule triggers warning for Metformin when meal carbs > 80g',
        () {
      final med = MedicationSchedule(
        localId: 'm1',
        medicationName: 'Glycomet 500mg',
        dosage: '1 Tab',
        scheduledTimes: const ['08:00'],
        daysOfWeek: const [1],
        startDate: DateTime(2026, 1, 1),
      );
      const meal = MealSnapshot(
          mealName: 'High Carb Meal', carbsGrams: 95.0, foodItems: ['Rice']);

      final warnings =
          engine.checkSchedule(med, meal, WorkoutIntensityLevel.moderate);

      expect(warnings.length, equals(1));
      expect(warnings.first.severity, equals(InteractionSeverity.moderate));
      expect(warnings.first.message,
          contains('Metformin combined with high simple carbs'));
    });

    test(
        'checkSchedule triggers high severity warning for Statins with Grapefruit',
        () {
      final med = MedicationSchedule(
        localId: 'm2',
        medicationName: 'Atorva 10mg',
        dosage: '1 Tab',
        scheduledTimes: const ['22:00'],
        daysOfWeek: const [1],
        startDate: DateTime(2026, 1, 1),
      );
      const meal = MealSnapshot(
          mealName: 'Citrus Meal',
          carbsGrams: 30.0,
          foodItems: ['Grapefruit Juice']);

      final warnings =
          engine.checkSchedule(med, meal, WorkoutIntensityLevel.low);

      expect(warnings.length, equals(1));
      expect(warnings.first.severity, equals(InteractionSeverity.high));
      expect(warnings.first.message,
          contains('Grapefruit compounds inhibit metabolic enzymes'));
    });

    test(
        'resolveOfflineRxcui maps Indian brand names to RxNorm Concept IDs (RxCUIs)',
        () {
      expect(service.resolveOfflineRxcui('Glycomet 500'), equals('22501'));
      expect(service.resolveOfflineRxcui('Atorva 10'), equals('83367'));
      expect(service.resolveOfflineRxcui('Thyronorm 50mcg'), equals('10582'));
      expect(service.resolveOfflineRxcui('Unknown Brand'), isNull);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'MedicationTrackerScreen renders scheduled medications and active interaction warnings',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MedicationTrackerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('💊 Medication Tracker'), findsOneWidget);
      expect(find.text('⚠️ Interaction Warnings (Real-Time)'), findsOneWidget);
      expect(find.textContaining('Metformin combined with high simple carbs'),
          findsOneWidget);
      expect(find.text('Scheduled Medications'), findsOneWidget);
      expect(find.textContaining('Glycomet 500mg'), findsAtLeastNWidgets(1));
      expect(find.textContaining('NIH RxNav Service Active'), findsOneWidget);
    });
  });
}
