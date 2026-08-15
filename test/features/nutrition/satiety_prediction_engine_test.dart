import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/satiety_prediction_engine.dart';
import 'package:fitkarma/features/nutrition/screens/satiety_prediction_screen.dart';

void main() {
  group('§P5-P Satiety Prediction Engine Tests', () {
    const engine = SatietyPredictionEngine();

    test(
        'computeForSeededItem validates Paneer Bhurji (90/100) & Rajma Chawal (85/100) per §P5-P spec',
        () {
      final paneerBhurji =
          SeededIndianSatietyTable.items.firstWhere((i) => i.id == 'sat_1');
      final paneerScore = engine.computeForSeededItem(paneerBhurji);
      expect(paneerScore.satietyScore, greaterThanOrEqualTo(85.0));

      final rajmaChawal =
          SeededIndianSatietyTable.items.firstWhere((i) => i.id == 'sat_2');
      final rajmaScore = engine.computeForSeededItem(rajmaChawal);
      expect(rajmaScore.satietyScore, greaterThanOrEqualTo(85.0));
    });

    test(
        'computeForSeededItem validates Deep-Fried Samosa (30/100) vs Air-Fried Samosa (60/100)',
        () {
      final airFried =
          SeededIndianSatietyTable.items.firstWhere((i) => i.id == 'sat_3');
      final airScore = engine.computeForSeededItem(airFried);
      expect(airScore.satietyScore, greaterThanOrEqualTo(50.0));

      final deepFried =
          SeededIndianSatietyTable.items.firstWhere((i) => i.id == 'sat_4');
      final deepScore = engine.computeForSeededItem(deepFried);
      expect(deepScore.satietyScore, lessThan(40.0));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'SatietyPredictionScreen renders dropdown selector, satiety score card, and reference list',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SatietyPredictionScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Satiety Prediction Engine'), findsOneWidget);
      expect(find.text('Indian Food Satiety Reference Table'), findsOneWidget);
      expect(find.text('Satiety Index Score'), findsOneWidget);
      expect(find.text('Seeded Indian Food Comparison:'), findsOneWidget);
    });
  });
}
