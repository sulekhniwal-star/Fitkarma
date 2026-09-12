import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/core/widgets/bilingual_label.dart';
import 'package:fitkarma/core/widgets/glowing_metric.dart';
import 'package:fitkarma/core/widgets/activity_rings.dart';
import 'package:fitkarma/core/theme/app_colors.dart';

void main() {
  testWidgets('BentoCard renders child and responds to tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BentoCard(
            onTap: () => tapped = true,
            child: const Text('Bento Content'),
          ),
        ),
      ),
    );

    expect(find.text('Bento Content'), findsOneWidget);
    await tester.tap(find.byType(BentoCard));
    expect(tapped, isTrue);
  });

  testWidgets('BilingualLabel renders English and Hindi correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BilingualLabel(
            english: 'Readiness Score',
            hindi: 'तत्परता स्कोर',
          ),
        ),
      ),
    );

    expect(find.text('Readiness Score'), findsOneWidget);
    expect(find.text('तत्परता स्कोर'), findsOneWidget);
  });

  testWidgets('GlowingMetric renders value, unit, and label', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlowingMetric(
            value: '92',
            unit: 'bpm',
            label: 'Heart Rate',
            hindiLabel: 'हृदय गति',
          ),
        ),
      ),
    );

    expect(find.text('92'), findsOneWidget);
    expect(find.text('bpm'), findsOneWidget);
    expect(find.text('Heart Rate'), findsOneWidget);
    expect(find.text('हृदय गति'), findsOneWidget);
  });

  testWidgets('ActivityRings renders concentric progress ring painter', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityRings(
            rings: [
              RingData(progress: 0.8, color: AppColors.primaryCyan),
              RingData(progress: 0.5, color: AppColors.primaryEmerald),
            ],
            centerChild: Text('Center'),
          ),
        ),
      ),
    );

    expect(find.byType(ActivityRings), findsOneWidget);
    expect(find.text('Center'), findsOneWidget);
  });
}
