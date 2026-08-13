import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/clinical_copy_linter.dart';
import 'package:fitkarma/core/brain/medication_tracker_engine.dart';

void main() {
  group('§P10-M Clinical Copy Directive-Language Linter Tests', () {
    const linter = ClinicalCopyLinter();

    test('lint catches banned directive phrases (stop taking, do not take, switch to, reduce your dose)', () {
      expect(linter.lint('Please stop taking your statin immediately.'), hasLength(1));
      expect(linter.lint('Do not take metformin with high carbs.'), hasLength(1));
      expect(linter.lint('Switch to another workout plan.'), hasLength(1));
      expect(linter.lint('Reduce your dose before exercise.'), hasLength(1));
    });

    test('lint catches "avoid" when "consult" is NOT present nearby', () {
      expect(linter.lint('Avoid grapefruit while on statins.'), hasLength(1));
    });

    test('lint allows "avoid" when "consult" IS present nearby', () {
      expect(linter.lint('Consult your doctor to avoid grapefruit interaction.'), isEmpty);
    });

    test('lint verifies all active interaction warning strings in Medication Tracker Engine', () {
      const engine = DrugInteractionEngine();
      final med = MedicationSchedule(
        localId: 'm1',
        medicationName: 'Metformin',
        dosage: '500mg',
        scheduledTimes: ['08:00'],
        daysOfWeek: [1],
        startDate: DateTime(2026, 1, 1),
      );
      final meal = MealSnapshot(mealName: 'Lunch', carbsGrams: 90.0, foodItems: ['Grapefruit']);

      final warnings = engine.checkSchedule(med, meal, WorkoutIntensityLevel.high);

      for (final warn in warnings) {
        final violations = linter.lint(warn.message);
        // Copy should pass linter or provide informational guidance
        expect(violations, isEmpty, reason: 'Violation found in warning: ${warn.message}');
      }
    });
  });
}
