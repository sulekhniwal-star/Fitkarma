import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/doctor_sharing_service.dart';
import 'package:fitkarma/features/predictive_health/screens/doctor_sharing_screen.dart';

void main() {
  group('§P10-J Doctor Sharing Portal Tests', () {
    const service = DoctorSharingService();

    test('generateShareToken creates token with 4-digit PIN and 7-day expiration', () {
      final token = service.generateShareToken(passCodePin: '1234', validDays: 7);

      expect(token.passCodePin, equals('1234'));
      expect(token.validDays, equals(7));
      expect(token.isExpired, isFalse);
      expect(token.shareUrl, contains('share.fitkarma.app/portal/'));
    });

    test('generateSampleReportSummary compiles 90-day averages and active risk flags', () {
      final summary = service.generateSampleReportSummary('Dr. Sharma Patient');

      expect(summary.patientName, equals('Dr. Sharma Patient'));
      expect(summary.averageSystolicBp, equals(122));
      expect(summary.adherencePct90Days, equals(88.5));
      expect(summary.activeRiskFlags, hasLength(2));
      expect(summary.biomarkerSummary, hasLength(3));
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('DoctorSharingScreen renders Security Protocol banner, report summary, and export PDF button', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DoctorSharingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🩺 Doctor Sharing Portal'), findsOneWidget);
      expect(find.text('Patient Consent & Security Protocol'), findsOneWidget);
      expect(find.text('Included Report Contents (90-Day Overview)'), findsOneWidget);
      expect(find.text('Export Encrypted PDF'), findsOneWidget);

      await tester.ensureVisible(find.text('Export Encrypted PDF'));
      await tester.tap(find.text('Export Encrypted PDF'));
      await tester.pumpAndSettle();

      expect(find.text('🌐 Active Time-Decaying Link'), findsOneWidget);
      expect(find.textContaining('PIN: 4829'), findsOneWidget);
    });
  });
}
