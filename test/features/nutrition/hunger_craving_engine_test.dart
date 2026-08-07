import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/hunger_craving_engine.dart';
import 'package:fitkarma/features/nutrition/screens/adaptive_hunger_cravings_screen.dart';

void main() {
  group('§P5-L Adaptive Hunger & Cravings Engine Tests', () {
    const engine = HungerCravingEngine();
    final now = DateTime.now();

    test('evaluateCravingRisk triggers 7 PM pre-emptive snacking nudge when late-night stress-binge history is detected', () {
      final historyLogs = [
        CravingLog(
          timestamp: DateTime(2026, 8, 6, 21, 30), // 9:30 PM
          hungerScore: 4,
          cravingType: CravingType.sweet,
          isUltraProcessed: true,
          stressLevel: 4.2,
        ),
      ];

      final intervention = engine.evaluateCravingRisk(
        logs: historyLogs,
        currentTime: DateTime(2026, 8, 7, 19, 0), // 7:00 PM
        currentStressLevel: 4.0,
      );

      expect(intervention.shouldTriggerNudge, isTrue);
      expect(intervention.nudgeTitle, contains('Pre-Emptive Snacking'));
      expect(intervention.nudgeBody, contains('crave sweet snacks at 9 PM'));
      expect(intervention.recommendedSnack, contains('Greek yogurt'));
    });

    test('evaluateCravingRisk triggers High Hunger Warning when recent hunger score is 5', () {
      final recentStarvingLog = [
        CravingLog(
          timestamp: now.subtract(const Duration(minutes: 30)),
          hungerScore: 5,
          cravingType: CravingType.salty,
          isUltraProcessed: false,
          stressLevel: 2.0,
        ),
      ];

      final intervention = engine.evaluateCravingRisk(
        logs: recentStarvingLog,
        currentTime: now,
        currentStressLevel: 2.0,
      );

      expect(intervention.shouldTriggerNudge, isTrue);
      expect(intervention.nudgeTitle, contains('High Hunger Warning'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('AdaptiveHungerCravingsScreen renders sliders, choice chips, and pre-emptive nudge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AdaptiveHungerCravingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hunger & Cravings Predictor'), findsOneWidget);
      expect(find.text('Log Current Hunger & Stress'), findsOneWidget);
      expect(find.text('Pre-Emptive Snacking Alert'), findsOneWidget);
      expect(find.text('SWEET'), findsOneWidget);
      expect(find.text('SALTY'), findsOneWidget);
    });
  });
}
