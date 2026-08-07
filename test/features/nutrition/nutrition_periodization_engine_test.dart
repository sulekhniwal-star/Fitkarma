import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/periodization_controller.dart';
import 'package:fitkarma/features/nutrition/screens/nutrition_periodization_screen.dart';

void main() {
  group('§P5-G Nutrition Periodization Engine Tests', () {
    const controller = PeriodizationController();

    // ── Periodization Phases & Modifiers Tests ───────────────────────────────

    test('PeriodizationPhase calorie & protein modifiers compute correctly', () {
      expect(PeriodizationPhase.fatLoss.calorieModifier, equals(0.80));
      expect(PeriodizationPhase.leanGain.calorieModifier, equals(1.10));
      expect(PeriodizationPhase.recomposition.proteinTargetGPerKg, equals(2.2));
    });

    // ── Periodization Controller Transition Rules ────────────────────────────

    test('Rule 1: Auto-triggers Diet Break after 8 consecutive weeks in Fat Loss deficit', () {
      final status = controller.checkPhaseProgression(
        currentPhase: PeriodizationPhase.fatLoss,
        phaseStartAt: DateTime.now().subtract(const Duration(days: 57)), // 8.1 weeks
        weightHistory: [],
      );

      expect(status.actionRequired, isTrue);
      expect(status.nextPhase, equals(PeriodizationPhase.dietBreak));
      expect(status.reason, contains('8+ weeks'));
    });

    test('Rule 2: Auto-triggers Diet Break when weight plateau is detected (<200g variance over 3 weeks)', () {
      final now = DateTime.now();
      final plateauLogs = [
        WeightLog(loggedAt: now, weightKg: 80.0),
        WeightLog(loggedAt: now.subtract(const Duration(days: 7)), weightKg: 80.1),
        WeightLog(loggedAt: now.subtract(const Duration(days: 14)), weightKg: 80.0),
        WeightLog(loggedAt: now.subtract(const Duration(days: 21)), weightKg: 80.05),
        WeightLog(loggedAt: now.subtract(const Duration(days: 28)), weightKg: 80.0),
      ];

      final status = controller.checkPhaseProgression(
        currentPhase: PeriodizationPhase.fatLoss,
        phaseStartAt: now.subtract(const Duration(days: 21)), // 3 weeks
        weightHistory: plateauLogs,
      );

      expect(status.actionRequired, isTrue);
      expect(status.nextPhase, equals(PeriodizationPhase.dietBreak));
      expect(status.reason, contains('Plateau detected'));
    });

    test('Rule 3: Resumes Fat Loss after 2 weeks in Diet Break', () {
      final status = controller.checkPhaseProgression(
        currentPhase: PeriodizationPhase.dietBreak,
        phaseStartAt: DateTime.now().subtract(const Duration(days: 15)), // 2.1 weeks
        weightHistory: [],
      );

      expect(status.actionRequired, isTrue);
      expect(status.nextPhase, equals(PeriodizationPhase.fatLoss));
      expect(status.reason, contains('Diet Break completed'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('NutritionPeriodizationScreen renders active phase card, transition prompt, and phase cycle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NutritionPeriodizationScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nutrition Periodization'), findsOneWidget);
      expect(find.text('Active Phase'), findsOneWidget);
      expect(find.text('Periodization Transition Prompt'), findsOneWidget);
      expect(find.text('Periodization Phase Cycle:'), findsOneWidget);
    });
  });
}
