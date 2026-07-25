/// §P12-C Wedding Transformation Mode — Unit, Widget & End-to-End Synthetic Data Tests

import 'package:fitkarma/features/wedding/wedding_dashboard_screen.dart';
import 'package:fitkarma/features/wedding/wedding_notifier.dart';
import 'package:fitkarma/features/wedding/wedding_program_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const generator = WeddingProgramGenerator();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: WeddingDashboardScreen(),
      ),
    );
  }

  group('§P12-C WeddingProgramGenerator Phase Logic Unit Tests', () {
    test('generates Foundation Phase for countdown > 90 days', () {
      final now = DateTime(2026, 7, 25);
      final weddingDate = DateTime(2026, 11, 25); // 123 days out

      final plan = generator.generatePlan(weddingDate: weddingDate, currentDate: now);

      expect(plan.phase, equals(WeddingPhase.foundation));
      expect(plan.phaseName, contains('Foundation Phase'));
      expect(plan.dailyCalorieTarget, equals(2000));
      expect(plan.dailyProteinG, equals(110));
      expect(plan.dailyHydrationL, equals(3.0));
    });

    test('generates Peak Shred Phase for countdown 30-90 days out', () {
      final now = DateTime(2026, 7, 25);
      final weddingDate = DateTime(2026, 9, 23); // 60 days out

      final plan = generator.generatePlan(weddingDate: weddingDate, currentDate: now);

      expect(plan.phase, equals(WeddingPhase.peakShred));
      expect(plan.phaseName, contains('Peak Shred Phase'));
      expect(plan.dailyCalorieTarget, equals(1750));
      expect(plan.dailyProteinG, equals(125));
      expect(plan.dailyHydrationL, equals(3.0));
    });

    test('generates Final Taper & Skin Glow Phase for countdown < 30 days out', () {
      final now = DateTime(2026, 7, 25);
      final weddingDate = DateTime(2026, 8, 9); // 15 days out

      final plan = generator.generatePlan(weddingDate: weddingDate, currentDate: now);

      expect(plan.phase, equals(WeddingPhase.finalTaper));
      expect(plan.phaseName, contains('Final Taper & Skin Glow Phase'));
      expect(plan.dailyCalorieTarget, equals(1900));
      expect(plan.dailyProteinG, equals(100));
      expect(plan.dailyHydrationL, equals(3.5)); // Maximized hydration for skin radiance
      expect(plan.skinGlowNutrients, contains('Vitamin C (Citrus & Berries)'));
    });
  });

  group('§P12-C WeddingDashboardScreen Widget Tests', () {
    testWidgets('renders countdown card, phase badge, target macros & prep checklist', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('💍 Wedding Prep Dashboard'), findsOneWidget);
      expect(find.textContaining('UNTIL THE BIG DAY 💍'), findsOneWidget);
      expect(find.textContaining('Phase'), findsOneWidget);
      expect(find.text('Skin Glow & Radiance Protocol'), findsOneWidget);
      expect(find.textContaining('Daily Wedding Prep Checklist'), findsOneWidget);
    });

    testWidgets('toggles prep checklist items when tapped', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('0/4 Done'), findsOneWidget);

      final checkbox = find.byType(Checkbox).first;
      await tester.ensureVisible(checkbox);
      await tester.pumpAndSettle();

      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      expect(find.text('1/4 Done'), findsOneWidget);
    });
  });

  group('§P12-C End-to-End Synthetic Data Simulation Test', () {
    test('Simulates synthetic user journey from Peak Shred (60d) to Final Taper (15d)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(weddingTransformationProvider.notifier);

      // Phase 1: Synthetic user sets wedding date 60 days out (Peak Shred)
      final date60Days = DateTime.now().add(const Duration(days: 60));
      notifier.updateWeddingDate(date60Days);

      var state = container.read(weddingTransformationProvider);
      expect(state.currentPhase, equals(WeddingPhase.peakShred));
      expect(state.programPlan.dailyCalorieTarget, equals(1750));
      expect(state.programPlan.dailyProteinG, equals(125));

      // User completes daily checklist items
      notifier.toggleCheckitem(state.checklist[0].id);
      notifier.toggleCheckitem(state.checklist[1].id);

      expect(container.read(weddingTransformationProvider).completedChecklistCount, equals(2));

      // Phase 2: Time passes to 15 days out (Final Taper & Skin Glow)
      final date15Days = DateTime.now().add(const Duration(days: 15));
      notifier.updateWeddingDate(date15Days);

      state = container.read(weddingTransformationProvider);
      expect(state.currentPhase, equals(WeddingPhase.finalTaper));
      expect(state.programPlan.dailyHydrationL, equals(3.5));
      expect(state.programPlan.phaseName, contains('Final Taper & Skin Glow Phase'));
    });
  });
}
