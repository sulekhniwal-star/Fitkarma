import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/coach/models/escalation_service.dart';
import 'package:fitkarma/features/coach/providers/escalation_provider.dart';
import 'package:fitkarma/features/coach/widgets/escalation_ui.dart';

void main() {
  group('§P3-D Health Coach Escalation Layer Tests', () {
    const service = CoachEscalationService();

    // ── Trigger Logic Tests ─────────────────────────────────────────────────

    test('shouldEscalate returns false when no triggers met', () {
      final state = const UserEscalationState();
      expect(service.shouldEscalate(state), isFalse);
    });

    test('shouldEscalate triggers on HIGH severity active risk', () {
      final state = UserEscalationState(
        activeRisks: [
          const ActiveRisk(
            riskType: 'thyroid_disruption',
            severity: RiskSeverity.high,
            description: 'Possible thyroid/cortisol involvement',
          ),
        ],
      );
      expect(service.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate does NOT trigger on MEDIUM severity risk', () {
      final state = UserEscalationState(
        activeRisks: [
          const ActiveRisk(
            riskType: 'mild_plateau',
            severity: RiskSeverity.medium,
            description: 'Minor plateau',
          ),
        ],
      );
      expect(service.shouldEscalate(state), isFalse);
    });

    test('shouldEscalate triggers on 4+ week plateau after adaptive adjustment', () {
      const state = UserEscalationState(
        plateauWeeks: 4,
        adaptiveCaloriesAlreadyAdjusted: true,
      );
      expect(service.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate does NOT trigger on 3-week plateau (threshold is 4)', () {
      const state = UserEscalationState(
        plateauWeeks: 3,
        adaptiveCaloriesAlreadyAdjusted: true,
      );
      expect(service.shouldEscalate(state), isFalse);
    });

    test('shouldEscalate triggers on 3+ consecutive relapse attempts', () {
      const state = UserEscalationState(consecutiveRelapseAttempts: 3);
      expect(service.shouldEscalate(state), isTrue);
    });

    test('shouldEscalate triggers when user explicitly requests human coach', () {
      const state = UserEscalationState(userRequestedHumanCoach: true);
      expect(service.shouldEscalate(state), isTrue);
    });

    // ── Escalation Reason Tests ─────────────────────────────────────────────

    test('identifyReason picks highRiskMedical as highest priority', () {
      final state = UserEscalationState(
        activeRisks: [
          const ActiveRisk(
            riskType: 'thyroid',
            severity: RiskSeverity.high,
            description: 'Thyroid irregularity',
          ),
        ],
        plateauWeeks: 4,
        adaptiveCaloriesAlreadyAdjusted: true,
      );
      final reason = service.identifyReason(state);
      expect(reason.triggerType, equals(EscalationTriggerType.highRiskMedical));
      expect(reason.clinicalNote, contains('Thyroid irregularity'));
    });

    test('identifyReason picks userRequested as fallback', () {
      const state = UserEscalationState(userRequestedHumanCoach: true);
      final reason = service.identifyReason(state);
      expect(reason.triggerType, equals(EscalationTriggerType.userRequested));
    });

    // ── Coach Briefing Package Tests ────────────────────────────────────────

    test('buildBriefing generates HIGH recovery debt label for 5+ day deficit', () {
      const state = UserEscalationState(userRequestedHumanCoach: true);
      final reason = service.identifyReason(state);
      final briefing = service.buildBriefing(
        userId: 'user_1',
        userName: 'Arjun Sharma',
        goal: 'Fat loss (−8 kg in 12 weeks)',
        programWeek: 7,
        programTotalWeeks: 12,
        programName: 'Corporate Fat Loss',
        weightChange4wKg: -0.4,
        expectedWeightChange4wKg: -2.0,
        calorieTarget: 1680,
        adaptiveAdjustmentCount: 2,
        nutritionAdherencePct: 62,
        trainingAdherencePct: 55,
        sleepDeficitDays: 5,
        aiLimitationsHit: [
          '4 consecutive weeks of plateau post-recalibration',
          'User reports extreme fatigue + mood changes',
        ],
        escalationReason: reason,
        aiCoachNotesSummary: 'User flagged extreme fatigue and requested human review.',
      );

      expect(briefing.userName, equals('Arjun Sharma'));
      expect(briefing.recoveryDebtLevel, equals('HIGH'));
      expect(briefing.weightChange4wKg, equals(-0.4));
      expect(briefing.aiLimitationsHit, hasLength(2));
    });

    test('toFormattedBriefing produces structured output matching §P3-D spec', () {
      const state = UserEscalationState(userRequestedHumanCoach: true);
      final reason = service.identifyReason(state);
      final briefing = service.buildBriefing(
        userId: 'user_2',
        userName: 'Priya Mehta',
        goal: 'Fat loss (−5 kg in 12 weeks)',
        programWeek: 7,
        programTotalWeeks: 12,
        programName: 'Corporate Fat Loss',
        weightChange4wKg: -0.4,
        expectedWeightChange4wKg: -2.0,
        calorieTarget: 1680,
        adaptiveAdjustmentCount: 2,
        nutritionAdherencePct: 62,
        trainingAdherencePct: 55,
        sleepDeficitDays: 5,
        aiLimitationsHit: ['4 consecutive weeks of plateau'],
        escalationReason: reason,
        aiCoachNotesSummary: 'User requested review.',
      );

      final text = briefing.toFormattedBriefing();
      expect(text, contains('Coach Briefing — Priya Mehta'));
      expect(text, contains('Week:         7 of 12'));
      expect(text, contains('Corporate Fat Loss'));
      expect(text, contains('-0.4 kg'));
      expect(text, contains('Nutrition 62% / Training 55%'));
      expect(text, contains('AI Limitations Hit:'));
    });

    test('toJson produces complete key set for Cloudflare D1 storage', () {
      const state = UserEscalationState(userRequestedHumanCoach: true);
      final reason = service.identifyReason(state);
      final briefing = service.buildBriefing(
        userId: 'user_3',
        userName: 'Test',
        goal: 'test',
        programWeek: 1,
        programTotalWeeks: 12,
        programName: 'test',
        weightChange4wKg: 0,
        expectedWeightChange4wKg: -1,
        calorieTarget: 1800,
        adaptiveAdjustmentCount: 0,
        nutritionAdherencePct: 70,
        trainingAdherencePct: 70,
        sleepDeficitDays: 0,
        aiLimitationsHit: const [],
        escalationReason: reason,
        aiCoachNotesSummary: 'test',
      );

      final json = briefing.toJson();
      expect(json['user_id'], equals('user_3'));
      expect(json['recovery_debt_level'], equals('LOW'));
      expect(json['escalation_trigger'], equals('userRequested'));
    });

    // ── EscalationNotifier Tests ────────────────────────────────────────────

    test('EscalationNotifier.requestHumanCoach sets isEscalated = true', () async {
      final notifier = EscalationNotifier(const CoachEscalationService());
      expect(notifier.state.isEscalated, isFalse);

      await notifier.requestHumanCoach(
        userId: 'user_test',
        userName: 'Test User',
      );

      expect(notifier.state.isEscalated, isTrue);
      expect(notifier.state.lastResult?.escalated, isTrue);
      expect(notifier.state.lastResult?.reason,
          equals(EscalationTriggerType.userRequested));
      expect(notifier.state.briefing, isNotNull);
    });

    // ── UI Widget Tests ─────────────────────────────────────────────────────

    testWidgets('EscalateToHumanCoachButton renders Elite tier button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: EscalateToHumanCoachButton()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Human Coach'), findsOneWidget);
    });

    testWidgets('Escalation bottom sheet shows on button tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: EscalateToHumanCoachButton()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Human Coach'));
      await tester.pumpAndSettle();

      expect(find.text('Talk to a Human Coach'), findsOneWidget);
      expect(find.text('Continue with AI Coach'), findsOneWidget);
      // Request button may require scroll in small viewport — confirm it exists somewhere
      expect(find.textContaining('Request Coach Review', skipOffstage: false), findsOneWidget);
    });

    testWidgets('EscalationSuccessBanner shows notification title', (tester) async {
      const result = EscalationResult(
        escalated: true,
        reason: EscalationTriggerType.userRequested,
        userNotificationTitle: 'Your health coach will review your plan',
        userNotificationBody: 'A certified coach is reviewing your data.',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EscalationSuccessBanner(result: result),
          ),
        ),
      );

      expect(find.text('Your health coach will review your plan'), findsOneWidget);
      expect(find.text('A certified coach is reviewing your data.'), findsOneWidget);
    });
  });
}
