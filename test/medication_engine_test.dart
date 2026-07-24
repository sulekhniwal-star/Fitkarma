import 'package:fitkarma/features/predictive/clinical_copy_linter.dart';
import 'package:fitkarma/features/predictive/clinical_disclaimer_shield.dart';
import 'package:fitkarma/features/predictive/medication_engine.dart';
import 'package:fitkarma/features/predictive/medication_notifier.dart';
import 'package:fitkarma/features/predictive/medication_tracker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const linter = ClinicalCopyLinter();
  final engine = DrugInteractionEngine();

  group('§P10-M ClinicalCopyLinter Unit Tests', () {
    test('Replaces diagnostic terms with approved non-diagnostic phrasing', () {
      const rawText = 'you are diagnosed with hypertension and need a prescription';
      final sanitized = linter.lintAndSanitize(rawText);

      expect(sanitized, contains('observations indicate potential markers for'));
      expect(sanitized, contains('medication protocol'));
      expect(sanitized, contains('Informational only: consult your physician'));
    });
  });

  group('§P10-I DrugInteractionEngine Unit Tests', () {
    test('Resolves RxNorm concept IDs for common Indian brand names', () {
      expect(engine.resolveRxcui('Glycomet SR 500'), '22501');
      expect(engine.resolveRxcui('Atorva 10'), '83367');
      expect(engine.resolveRxcui('Thyronorm 50'), '10582');
    });

    test('Generates linted drug-nutrient & drug-workout interaction warnings', () {
      final meds = [
        MedicationSchedule(
          medicationId: 'm1',
          medicationName: 'Glycomet SR 500 (Metformin)',
          dosage: '500 mg',
          scheduledTimes: ['08:30 AM'],
          requiresFood: true,
          startDate: DateTime.now(),
        ),
        MedicationSchedule(
          medicationId: 'm2',
          medicationName: 'Metoprolol',
          dosage: '25 mg',
          scheduledTimes: ['09:00 AM'],
          requiresFood: false,
          startDate: DateTime.now(),
        ),
      ];

      final warnings = engine.checkInteractions(
        medications: meds,
        recentMealCarbsGrams: 90.0,
        workoutIntensity: 'high',
      );

      expect(warnings.length, 2);
      expect(warnings.first.sourceMedication, contains('Glycomet'));
      expect(warnings.first.type, InteractionType.drugNutrient);
      expect(warnings.last.type, InteractionType.drugWorkout);
      expect(warnings.first.lintedMessage, contains('Informational only'));
    });
  });

  group('§P10-I MedicationTrackerScreen Widget Tests', () {
    testWidgets('Renders scheduled medications, active warnings, Non-Diagnostic Shield banner, and add trigger FAB', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            medicationProvider.overrideWith(MedicationNotifier.new),
          ],
          child: const MaterialApp(
            home: MedicationTrackerScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & FAB
      expect(find.text('💊 Medication Tracker & Warnings'), findsOneWidget);
      expect(find.text('Add Medication'), findsOneWidget);

      // 2. Non-Diagnostic Shield Banner (§P10-K)
      expect(find.byType(NonDiagnosticShieldBanner), findsOneWidget);

      // 3. Scheduled Medications List
      expect(find.text('Scheduled Medications'), findsOneWidget);
      expect(find.textContaining('Glycomet SR 500'), findsAtLeastNWidgets(1));

      // 4. Active Interaction Warnings List
      expect(find.text('⚠️ Active Interaction Warnings:'), findsOneWidget);
      expect(find.textContaining('Drug-Nutrient Conflict'), findsAtLeastNWidgets(1));
    });
  });
}
