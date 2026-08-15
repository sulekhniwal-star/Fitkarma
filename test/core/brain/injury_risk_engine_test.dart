import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/injury_risk_engine.dart';
import 'package:fitkarma/shared/widgets/injury_risk_card.dart';

void main() {
  group('§P10-D Injury Risk Engine Tests', () {
    const engine = InjuryRiskEngine();

    test(
        'analyze detects Shoulder injury risk on high pressing volume (>12,000 kg) and soreness (>3.0)',
        () {
      final recoveryLogs = [
        const RecoveryLogSnapshot(region: 'shoulder', sorenessLevel: 3.4),
      ];
      final workoutLogs = [
        const WorkoutLogSnapshot(
            exerciseCategory: 'pressing', volumeKg: 14200.0),
      ];

      final alerts = engine.analyze(
        recoveryLogs: recoveryLogs,
        workoutLogs: workoutLogs,
        formHistory: const FormHistoryData(),
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.region, equals('Shoulder'));
      expect(alerts.first.risk, equals(InjuryRiskLevel.moderate));
      expect(alerts.first.actions,
          contains('Reduce pressing volume by 20% this week'));
    });

    test(
        'analyze detects Knee injury risk on knee valgus incidents (>2) and lower body volume (>15,000 kg)',
        () {
      final workoutLogs = [
        const WorkoutLogSnapshot(
            exerciseCategory: 'lower_body', volumeKg: 16500.0),
      ];

      final alerts = engine.analyze(
        recoveryLogs: [],
        workoutLogs: workoutLogs,
        formHistory: const FormHistoryData(kneeValgusIncidents: 3),
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.region, equals('Knee'));
      expect(alerts.first.risk, equals(InjuryRiskLevel.moderate));
    });

    test(
        'analyze detects Lower Back high injury risk on soreness (>3.5) and HRV decline',
        () {
      final recoveryLogs = [
        const RecoveryLogSnapshot(
            region: 'lower_back', sorenessLevel: 4.0, isHrvDeclining: true),
      ];

      final alerts = engine.analyze(
        recoveryLogs: recoveryLogs,
        workoutLogs: [],
        formHistory: const FormHistoryData(),
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.region, equals('Lower Back'));
      expect(alerts.first.risk, equals(InjuryRiskLevel.high));
      expect(alerts.first.actions,
          contains('Skip deadlifts and heavy rows this week'));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'InjuryRiskCard renders high/moderate risk alerts and action items correctly',
        (tester) async {
      const alerts = [
        InjuryRiskAlert(
          region: 'Shoulder',
          risk: InjuryRiskLevel.moderate,
          message: 'High pressing volume + elevated shoulder soreness.',
          actions: ['Reduce pressing volume by 20%', 'Add face pulls (2x15)'],
        ),
        InjuryRiskAlert(
          region: 'Lower Back',
          risk: InjuryRiskLevel.high,
          message: 'HRV declining + persistent soreness.',
          actions: ['Skip deadlifts this week'],
        ),
      ];

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: InjuryRiskCard(alerts: alerts),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('⚠️ Injury Risk Alerts'), findsOneWidget);
      expect(find.textContaining('Shoulder — Moderate Risk'), findsOneWidget);
      expect(find.textContaining('Lower Back — High Risk'), findsOneWidget);
      expect(find.text('Skip deadlifts this week'), findsOneWidget);
    });
  });
}
