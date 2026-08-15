import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/shared/widgets/bento_card.dart';
import 'package:fitkarma/shared/widgets/activity_rings.dart';
import 'package:fitkarma/shared/widgets/glowing_metric.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';

void main() {
  group('Shared Foundation Widgets Tests', () {
    testWidgets('BentoCard renders child and triggers onTap callback on click',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BentoCard(
              onTap: () {
                tapped = true;
              },
              child: const Text('Bento Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Bento Card Content'), findsOneWidget);

      await tester.tap(find.byType(BentoCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('ActivityRings renders CustomPaint canvas',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityRings(
              rings: [
                RingData(
                  value: 75,
                  target: 100,
                  colors: [Colors.red, Colors.orange],
                ),
                RingData(
                  value: 50,
                  target: 100,
                  colors: [Colors.green, Colors.teal],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ActivityRings), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('GlowingMetric renders value, label, and unit correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlowingMetric(
              value: '85',
              label: 'Readiness',
              unit: 'PTS',
              glowColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('READINESS'), findsOneWidget);
      expect(find.byType(GlowingMetric), findsOneWidget);
    });

    testWidgets('BilingualLabel renders English and Hindi text when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BilingualLabel(
              englishText: 'Daily Goal',
              hindiText: 'दैनिक लक्ष्य',
            ),
          ),
        ),
      );

      expect(find.text('Daily Goal'), findsOneWidget);
      expect(find.text('दैनिक लक्ष्य'), findsOneWidget);
    });
  });
}
