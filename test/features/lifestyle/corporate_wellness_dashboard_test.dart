import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/lifestyle/screens/corporate_wellness_dashboard_screen.dart';
import 'package:fitkarma/features/lifestyle/providers/corporate_wellness_provider.dart';

void main() {
  testWidgets('§P16-D CorporateWellnessDashboardScreen displays aggregate metrics and switches to below-threshold privacy alert',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: CorporateWellnessDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('🏢 Corporate Wellness & Insurer Portal'), findsOneWidget);
    expect(find.text('Infosys Wellness Program'), findsOneWidget);
    expect(find.text('Enrollment'), findsOneWidget);
    expect(find.text('Avg Adherence'), findsOneWidget);
    expect(find.text('Aggregate Adherence Distribution'), findsOneWidget);

    // Simulate below threshold (4 users)
    await tester.tap(find.byKey(const Key('btn_simulate_below_threshold')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('below_threshold_banner')), findsOneWidget);
    expect(find.text('Privacy Threshold Notice'), findsOneWidget);
    expect(find.textContaining('Enrolled Active: 4 / 10 required'), findsOneWidget);
    expect(find.text('Aggregate Adherence Distribution'), findsNothing);

    // Simulate above threshold (18 users)
    await tester.tap(find.byKey(const Key('btn_simulate_above_threshold')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('below_threshold_banner')), findsNothing);
    expect(find.text('Aggregate Adherence Distribution'), findsOneWidget);
  });
}
