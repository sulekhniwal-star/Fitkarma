import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/data_confidence_shield.dart';
import 'package:fitkarma/features/nutrition/screens/data_confidence_shield_screen.dart';

void main() {
  group('§P5-O Nutrition Reliability Score & Data Confidence Shield Tests', () {
    const shield = DataConfidenceShield();

    test('evaluateLoggingQuality computes rolling reliability score and engages lockout below 70%', () {
      final lowLogs = List.generate(7, (i) {
        return DailyReliabilityLog(
          mealsLogged: i < 3 ? 3 : 1, // 3/7 = 0.428 * 0.40 = 0.171
          wasProteinTargetMet: i < 3, // 3/7 = 0.428 * 0.30 = 0.128
          wasWaterTargetMet: i < 4,   // 4/7 = 0.571 * 0.30 = 0.171 -> Total ~ 47-48%
        );
      });

      final status = shield.evaluateLoggingQuality(
        pastWeekLogs: lowLogs,
        weightPlateauWeeks: 3.0,
      );

      expect(status.isLockoutActive, isTrue);
      expect(status.reliabilityScore, lessThan(0.70));
      expect(status.alertMessage, contains('log reliability is only'));
    });

    test('evaluateLoggingQuality unlocks target adaptations when rolling reliability score is >= 70%', () {
      final highLogs = List.generate(7, (i) {
        return const DailyReliabilityLog(
          mealsLogged: 3,
          wasProteinTargetMet: true,
          wasWaterTargetMet: true,
        );
      });

      final status = shield.evaluateLoggingQuality(
        pastWeekLogs: highLogs,
        weightPlateauWeeks: 3.0,
      );

      expect(status.isLockoutActive, isFalse);
      expect(status.reliabilityScore, equals(1.0));
      expect(status.alertMessage, contains('Data confidence high'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('DataConfidenceShieldScreen renders simulator sliders and lockout shield banner', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: DataConfidenceShieldScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Data Confidence Shield'), findsOneWidget);
      expect(find.text('Rolling 7-Day Log Simulator'), findsOneWidget);
      expect(find.textContaining('Reliability:'), findsOneWidget);
    });
  });
}
