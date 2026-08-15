import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/features/predictive_health/screens/doctor_sharing_screen.dart';
import 'package:fitkarma/features/predictive_health/providers/abha_provider.dart';
import 'package:fitkarma/core/brain/abha_integration_engine.dart';

void main() {
  testWidgets('§P16-C DoctorSharingScreen renders ABHA card and supports FHIR-Lite export',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer(
      overrides: [
        abhaProvider.overrideWith((ref) {
          final notifier = AbhaNotifier();
          notifier.linkAbha(
            rawAbhaNumber: '91-1234-5678-9012',
            abhaAddress: 'arjun.sharma@abdm',
          );
          return notifier;
        }),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: DoctorSharingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ABHA Health ID (NDHM)'), findsOneWidget);
    expect(find.text('VERIFIED'), findsOneWidget);
    expect(find.text('Linked: 91-1234-5678-9012 (arjun.sharma@abdm)'), findsOneWidget);
    expect(find.text('Export FHIR-Lite JSON Bundle'), findsOneWidget);

    // Tap Export FHIR bundle
    await tester.tap(find.text('Export FHIR-Lite JSON Bundle'));
    await tester.pumpAndSettle();

    expect(find.text('FHIR-Lite Clinical Bundle Generated for NDHM Network'), findsOneWidget);
  });
}
