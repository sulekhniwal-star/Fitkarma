import 'package:fitkarma/features/transformation/transformation_timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('§P8-B Transformation Timeline Screen Widget Tests', () {
    testWidgets('Renders journey stage banner, forecast card, target predictions, and milestones', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TransformationTimelineScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Journey Stage Banner
      expect(find.text('Transformation Journey'), findsOneWidget);
      expect(find.textContaining('Stage: Active Transformation (Day 75)'), findsOneWidget);

      // 2. Weight Projection & 90-Day Range Card
      expect(find.text('Weight Projection & 90-Day Range'), findsOneWidget);
      expect(find.textContaining('Current: 72'), findsOneWidget);
      expect(find.textContaining('Shaded Forecast Channel'), findsOneWidget);

      // 3. Target Prediction Card
      expect(find.text('Target Prediction (At Current Pace)'), findsOneWidget);
      expect(find.text('Projected Weight (90 days)'), findsOneWidget);
      expect(find.text('Projected Body Fat'), findsOneWidget);
      expect(find.text('Program Target'), findsOneWidget);

      // 4. Secure Progress Photos
      expect(find.text('🔒 Secure Progress Photos'), findsOneWidget);
      expect(find.text('Tap to Unlock Photos'), findsOneWidget);

      // 5. Milestones Timeline
      expect(find.text('Journey Milestones'), findsOneWidget);
      expect(find.text('First 5k Steps Streak'), findsOneWidget);
      expect(find.text('5kg Weight Milestone'), findsOneWidget);
    });

    testWidgets('Toggles progress photos unlock state when unlock button is tapped', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TransformationTimelineScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially locked
      expect(find.text('Week 1 (Locked)'), findsOneWidget);
      expect(find.text('Tap to Unlock Photos'), findsOneWidget);

      // Tap unlock button
      final finder = find.text('Tap to Unlock Photos');
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();

      // Now unlocked
      expect(find.text('Week 1'), findsOneWidget);
      expect(find.text('Lock Progress Photos'), findsOneWidget);
    });
  });
}
