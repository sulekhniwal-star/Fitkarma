import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fitkarma/features/nutrition/models/micronutrient_alert_engine.dart';
import 'package:fitkarma/features/nutrition/screens/micronutrient_intelligence_screen.dart';

void main() {
  group('§P5-I Micronutrient Intelligence Core Tests', () {
    const engine = MicronutrientAlertEngine();

    // ── Biomarkers Tracked & Target Adjustments Tests ───────────────────────

    test(
        'UserMicroTargets derives RDA, 1.8x Non-Heme Veg Iron, and Female/PCOS target adjustments',
        () {
      final maleOmnivore = UserMicroTargets.derive(
          isFemale: false, isVegetarian: false, hasPcosOrFertilityGoal: false);
      expect(maleOmnivore.targetIronMg, equals(8.0));
      expect(maleOmnivore.targetB12Mcg, equals(2.4));

      final vegMale = UserMicroTargets.derive(
          isFemale: false, isVegetarian: true, hasPcosOrFertilityGoal: false);
      expect(vegMale.targetIronMg, equals(8.0 * 1.8)); // 14.4 mg
      expect(vegMale.targetB12Mcg, equals(3.0));
      expect(vegMale.targetZincMg, equals(15.0));

      final femalePcos = UserMicroTargets.derive(
          isFemale: true, isVegetarian: false, hasPcosOrFertilityGoal: true);
      expect(femalePcos.targetIronMg, equals(21.0));
      expect(femalePcos.targetCalciumMg, equals(1200.0));
      expect(femalePcos.targetFolateMcg, equals(600.0));
    });

    // ── Auto-Alert Trigger Engine Tests ──────────────────────────────────────

    test(
        'evaluateLogs triggers B12 depletion risk alert for vegetarian with <50% intake',
        () {
      final targets = UserMicroTargets.derive(
          isFemale: false, isVegetarian: true, hasPcosOrFertilityGoal: false);
      final logs = [
        const DailyMicroLog(b12Mcg: 1.0), // 1.0 / 3.0 = 33% < 50%
      ];

      final alerts = engine.evaluateLogs(
        logs: logs,
        targets: targets,
        isVegetarian: true,
        isFemale: false,
      );

      expect(alerts.any((a) => a.title.contains('B12 Depletion')), isTrue);
      expect(
          alerts.firstWhere((a) => a.title.contains('B12 Depletion')).severity,
          equals(MicronutrientAlertSeverity.high));
    });

    test(
        'evaluateLogs triggers Iron Deficit Warning for female with <60% intake',
        () {
      final targets = UserMicroTargets.derive(
          isFemale: true, isVegetarian: false, hasPcosOrFertilityGoal: false);
      final logs = [
        const DailyMicroLog(ironMg: 8.0), // 8.0 / 18.0 = 44% < 60%
      ];

      final alerts = engine.evaluateLogs(
        logs: logs,
        targets: targets,
        isVegetarian: false,
        isFemale: true,
      );

      expect(alerts.any((a) => a.title.contains('Iron Deficit')), isTrue);
      expect(
          alerts.firstWhere((a) => a.title.contains('Iron Deficit')).severity,
          equals(MicronutrientAlertSeverity.medium));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'MicronutrientIntelligenceScreen renders controls, auto-alerts, and target table',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MicronutrientIntelligenceScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Micronutrient Intelligence Core'), findsOneWidget);
      expect(find.text('Demographic Profile Adjustments'), findsOneWidget);
      expect(find.text('Auto-Alert Warnings:'), findsOneWidget);
      expect(find.text('Biomarkers Tracked & Targets:'), findsOneWidget);
    });
  });
}
