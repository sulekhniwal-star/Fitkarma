import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/transformation/providers/wedding_transformation_provider.dart';
import 'package:fitkarma/features/transformation/screens/wedding_dashboard_screen.dart';

void main() {
  group('§P12-C Wedding Transformation Mode Tests', () {
    test(
        'setWeddingDate calculates days remaining and resolves Peak Shred vs Final Taper phase',
        () {
      final notifier = WeddingTransformationNotifier();

      final taperDate = DateTime.now().add(const Duration(days: 15));
      notifier.setWeddingDate(taperDate);
      expect(notifier.state.currentPhase, equals(WeddingPhase.finalTaper));
      expect(notifier.state.hydrationTargetLiters, equals(3.5));

      final shredDate = DateTime.now().add(const Duration(days: 45));
      notifier.setWeddingDate(shredDate);
      expect(notifier.state.currentPhase, equals(WeddingPhase.peakShred));
      expect(notifier.state.proteinTargetG, equals(125.0));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets(
        'WeddingDashboardScreen renders countdown, action checklist, and macro guidelines',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: WeddingDashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Wedding Prep Dashboard'), findsOneWidget);
      expect(find.text('WEDDING COUNTDOWN'), findsOneWidget);
      expect(find.text('Specialized Daily Action Checklist'), findsOneWidget);
      expect(find.text('Phase-Shifted Macro Guidelines'), findsOneWidget);

      await tester.tap(find.textContaining('Skin Hydration Target'));
      await tester.pumpAndSettle();
    });
  });
}
