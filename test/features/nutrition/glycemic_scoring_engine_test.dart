import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/glycemic_scoring_engine.dart';
import 'package:fitkarma/features/nutrition/screens/glycemic_response_screen.dart';

void main() {
  group('§P5-M Glycemic Response & Personal Food Scoring Tests', () {
    const engine = GlycemicScoringEngine();

    test('computeScore assigns 10/10 for delta < 25 mg/dL with optimal energy stability feedback', () {
      final readings = [
        CgmReading(timestamp: DateTime.now(), glucoseMgDl: 115.0), // Peak 115 - Baseline 95 = +20 delta
      ];

      final score = engine.computeScore(
        postMealReadings: readings,
        baselineGlucose: 95.0,
        foodItemName: 'Paneer Tikka',
      );

      expect(score.score, equals(10.0));
      expect(score.glucoseDelta, equals(20.0));
      expect(score.recommendation, contains('Great glycemic response'));
    });

    test('computeScore assigns 7/10 for delta in 25..45 mg/dL and 3/10 for delta > 45 mg/dL with mitigation prompt', () {
      // 1. Moderate spike (+35 delta -> 7/10)
      final moderateReadings = [
        CgmReading(timestamp: DateTime.now(), glucoseMgDl: 130.0),
      ];

      final moderateScore = engine.computeScore(
        postMealReadings: moderateReadings,
        baselineGlucose: 95.0,
      );

      expect(moderateScore.score, equals(7.0));
      expect(moderateScore.glucoseDelta, equals(35.0));

      // 2. High spike (+48 delta -> 3/10)
      final highReadings = [
        CgmReading(timestamp: DateTime.now(), glucoseMgDl: 143.0),
      ];

      final highScore = engine.computeScore(
        postMealReadings: highReadings,
        baselineGlucose: 95.0,
        foodItemName: 'Ripe Banana',
      );

      expect(highScore.score, equals(3.0));
      expect(highScore.glucoseDelta, equals(48.0));
      expect(highScore.recommendation, contains('Ripe Banana spikes your glucose by +48 mg/dL'));
      expect(highScore.recommendation, contains('pairing it with 10 almonds'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('GlycemicResponseScreen renders CGM map, sliders, food score, and mitigation prompt', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: GlycemicResponseScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Glycemic Response & Food Score'), findsOneWidget);
      expect(find.text('Continuous Glucose Monitor (CGM) Map'), findsOneWidget);
      expect(find.text('Personal Food Score'), findsOneWidget);
      expect(find.textContaining('Insulin Spike Mitigation Prompt:'), findsOneWidget);
    });
  });
}
