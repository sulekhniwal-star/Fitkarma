import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/family_health_hub_engine.dart';
import 'package:fitkarma/features/social/screens/family_hub_screen.dart';

void main() {
  group('§P9-D Family Health Hub Tests', () {
    const engine = FamilyHealthHubEngine();

    test('validateFamilyCapacity enforces maximum 6 household members', () {
      expect(engine.validateFamilyCapacity(4), isTrue);
      expect(engine.validateFamilyCapacity(6), isTrue);
      expect(engine.validateFamilyCapacity(7), isFalse);
    });

    test(
        'generateFamilyNudges generates high severity BP check alerts and moderate low protein nudges',
        () {
      const members = [
        FamilyMemberProfile(
          id: 'm1',
          firstName: 'Ramesh',
          relationship: 'Dad',
          age: 54,
          role: FamilyRole.parent,
          healthScore: 71,
          bpStatus: '⚠️ Moderate',
          stepsToday: 4200,
          sleepHours: 6.1,
          activeProgramOrRisk: 'Hypertension watch',
          activeRisks: [HealthRiskType.hypertension],
          bpCheckDaysAgo: 3,
          lowProteinDays: 0,
        ),
        FamilyMemberProfile(
          id: 'm4',
          firstName: 'Priya',
          relationship: 'Daughter',
          age: 24,
          role: FamilyRole.child,
          healthScore: 79,
          bpStatus: 'Normal',
          stepsToday: 7800,
          sleepHours: 8.1,
          activeProgramOrRisk: 'Protein: ⚠️ Low',
          activeRisks: [HealthRiskType.lowProtein],
          bpCheckDaysAgo: 0,
          lowProteinDays: 4,
        ),
      ];

      final nudges = engine.generateFamilyNudges(members);
      expect(nudges.length, equals(2));
      expect(nudges.first.targetMemberName, equals('Ramesh'));
      expect(nudges.first.severity, equals(FamilyNudgeSeverity.high));
      expect(nudges.last.targetMemberName, equals('Priya'));
      expect(nudges.last.severity, equals(FamilyNudgeSeverity.moderate));
    });

    test(
        'filterPrivacyForDisplay hides weight and body composition for minors (<18)',
        () {
      const minorMember = FamilyMemberProfile(
        id: 'm5',
        firstName: 'Anand',
        relationship: 'Son',
        age: 14,
        role: FamilyRole.child,
        healthScore: 82,
        bpStatus: 'Normal',
        stepsToday: 8000,
        sleepHours: 8.5,
        activeProgramOrRisk: 'Junior Fitness',
        activeRisks: [],
        bpCheckDaysAgo: 0,
        lowProteinDays: 0,
      );

      final displayData = engine.filterPrivacyForDisplay(minorMember);
      expect(displayData['isWeightHidden'], isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'FamilyHubScreen renders family name, members list, active alerts, and nudge buttons',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: FamilyHubScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Family Health Hub'), findsOneWidget);
      expect(find.text('The Sharma Family'), findsOneWidget);
      expect(find.textContaining('Household Members'), findsWidgets);
      expect(find.textContaining('Dad (Ramesh, 54)'), findsOneWidget);
      expect(find.textContaining('Mom (Sunita, 51)'), findsOneWidget);
      expect(find.text('Family Alerts & Nudges'), findsOneWidget);
    });
  });
}
