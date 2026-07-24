import 'package:fitkarma/features/social/family_engine.dart';
import 'package:fitkarma/features/social/family_models.dart';
import 'package:fitkarma/features/social/family_repository.dart';
import 'package:fitkarma/features/social/family_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = FamilyEngine();

  const sampleMember = FamilyMemberProfile(
    memberId: 'mem_dad',
    familyUnitId: 'fam_123',
    name: 'Dad',
    age: 54,
    role: FamilyMemberRole.parent,
    healthScore: 71,
    bpStatus: '⚠️ Moderate',
    stepsToday: 4200,
    sleepHours: 6.1,
    weightKg: 82.0,
    riskWatch: 'Hypertension watch',
    consentSettings: FamilyPrivacyConsent(
      shareHealthScore: true,
      shareSteps: true,
      shareSleep: true,
      shareWeight: false, // Weight sharing off
    ),
    isCurrentUser: false,
  );

  group('§P9-D FamilyEngine Unit Tests', () {
    test('Permission-gated filter masks weight when shareWeight is false', () {
      final filtered = engine.filterMemberForView(sampleMember);

      expect(filtered.healthScore, 71);
      expect(filtered.stepsToday, 4200);
      expect(filtered.sleepHours, 6.1);
      expect(filtered.weightKg, isNull); // Masked
    });

    test('Current user sees weight regardless of consent toggles', () {
      const currentUserMember = FamilyMemberProfile(
        memberId: 'mem_me',
        familyUnitId: 'fam_123',
        name: 'Me',
        age: 28,
        role: FamilyMemberRole.primaryAccount,
        healthScore: 84,
        bpStatus: 'Normal',
        stepsToday: 9400,
        sleepHours: 7.8,
        weightKg: 74.0,
        consentSettings: FamilyPrivacyConsent(shareWeight: false),
        isCurrentUser: true,
      );

      final filtered = engine.filterMemberForView(currentUserMember);
      expect(filtered.weightKg, 74.0); // Not masked for current user
    });

    test('Enforces max 6 members per household limit', () {
      expect(() => engine.validateAddMember(6), throwsA(isA<FamilyCapacityException>()));
      expect(() => engine.validateAddMember(5), returnsNormally);
    });

    test('Aggregates household health alerts correctly', () {
      final alerts = engine.aggregateFamilyAlerts([sampleMember]);
      expect(alerts.length, 2); // 1 BP watch + 1 Low steps watch
      expect(alerts.first.severity, FamilyAlertSeverity.critical);
      expect(alerts.first.message, contains('BP elevated'));
    });
  });

  group('§P9-D FamilyScreen Widget Tests', () {
    testWidgets('Renders household header, family member cards, and alerts banner', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            familyRepositoryProvider.overrideWithValue(FamilyRepository()),
          ],
          child: const MaterialApp(
            home: FamilyScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Header Banner
      expect(find.text('Family Health Hub'), findsOneWidget);
      expect(find.text('The Sharma Family'), findsOneWidget);
      expect(find.textContaining('Unit ID: fam_sharma_123'), findsOneWidget);

      // 2. Member Cards
      expect(find.text('Dad (Ramesh)'), findsOneWidget);
      expect(find.text('Mom (Sunita)'), findsOneWidget);
      expect(find.text('Son (Arjun) (You)'), findsOneWidget);
      expect(find.text('Daughter (Priya)'), findsOneWidget);
      expect(find.text('🔒 Weight Hidden'), findsWidgets);

      // 3. Alerts Card
      expect(find.text('Family Health Alerts'), findsOneWidget);
      expect(find.textContaining('BP elevated 3 days'), findsOneWidget);

      // 4. Action Button
      expect(find.text('Send Family Nudge'), findsOneWidget);
    });
  });
}
