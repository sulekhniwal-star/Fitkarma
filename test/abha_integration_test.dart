/// §P16-C ABHA Health ID Integration — Unit & Widget Tests

import 'package:fitkarma/features/abha/abha_controller.dart';
import 'package:fitkarma/features/abha/abha_models.dart';
import 'package:fitkarma/features/abha/abha_service.dart';
import 'package:fitkarma/features/abha/abha_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = AbhaService();

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: AbhaSettingsScreen(),
      ),
    );
  }

  group('§P16-C AbhaService Unit Tests', () {
    test('initiates NDHM OAuth flow and verifies 6-digit OTP', () async {
      final txnId = await service.requestOtp('14-8899-1234-5678');
      expect(txnId, startsWith('txn_ndhm_'));

      final account = await service.verifyOtpAndLink(
        txnId: txnId,
        otpCode: '123456',
        abhaHealthId: '14-8899-1234-5678',
      );

      expect(account.isLinked, isTrue);
      expect(account.abhaHealthId, equals('14-8899-1234-5678'));
      expect(account.fullName, equals('Rahul Sharma'));
    });

    test('encrypts abhaHealthId at rest via SQLCipher passkey generator', () {
      const rawId = '14-8899-1234-5678';
      final encrypted = service.encryptAbhaIdAtRest(rawId);

      expect(encrypted, isNotEmpty);
      expect(encrypted, isNot(contains(rawId)));
    });

    test('generates valid FHIR-lite R4 JSON bundle for doctor sharing', () {
      final bundle = service.generateFhirLiteBundle(
        abhaHealthId: '14-8899-1234-5678',
        hrvAvg: 48.5,
        systolicBp: 120,
        diastolicBp: 80,
        fastingGlucose: 95,
      );

      expect(bundle['resourceType'], equals('Bundle'));
      expect(bundle['type'], equals('document'));
      expect(bundle['entry'], hasLength(3));
      expect(bundle['meta']['disclaimer'], contains('observational reference only'));
    });

    test('applies §P10-M compliance boundary to shared content', () {
      const jsonPayload = '{"hrv": 45, "bp": "120/80"}';
      final compliantPayload = service.applyClinicalComplianceBoundary(jsonPayload);

      expect(compliantPayload, contains('⚠️ CLINICAL NOTICE (§P10-M)'));
      expect(compliantPayload, contains('Does not constitute formal medical diagnosis'));
    });
  });

  group('§P16-C AbhaNotifier Integration Tests', () {
    test('initializes with passcode-PDF export mode as DEFAULT (§P16-C spec)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(abhaProvider);

      expect(state.sharingMode, equals(DoctorSharingMode.passcodePdf));
      expect(state.account, isNull);
    });

    test('updates state after OTP verification and mode toggle', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(abhaProvider.notifier);

      await notifier.requestOtp('14-8899-1234-5678');
      expect(container.read(abhaProvider).isOtpSent, isTrue);

      await notifier.submitOtp(otp: '123456', abhaHealthId: '14-8899-1234-5678');
      final state = container.read(abhaProvider);

      expect(state.account, isNotNull);
      expect(state.account!.isLinked, isTrue);

      notifier.setSharingMode(DoctorSharingMode.fhirLiteAbha);
      expect(container.read(abhaProvider).sharingMode, equals(DoctorSharingMode.fhirLiteAbha));
    });
  });

  group('§P16-C AbhaSettingsScreen Widget Tests', () {
    testWidgets('renders screen header, passcode PDF default radio option, and compliance banner', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('🏥 ABHA Health ID Integration'), findsOneWidget);
      expect(find.text('Ayushman Bharat Digital Mission (ABDM)'), findsOneWidget);
      expect(find.text('📄 Passcode PDF Export (Default)'), findsOneWidget);
      expect(find.text('🏥 FHIR-lite ABHA Bundle Mode'), findsOneWidget);
      expect(find.text('§P10-M Compliance Boundary Applied'), findsOneWidget);
    });

    testWidgets('requests OTP and verifies ABHA linking flow', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request NDHM OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Verify OTP & Link ABHA'), findsOneWidget);

      await tester.tap(find.text('Verify OTP & Link ABHA'));
      await tester.pumpAndSettle();

      expect(find.text('✓ ABHA ID Linked & Verified'), findsOneWidget);
      expect(find.text('SQLCipher Encrypted'), findsOneWidget);
    });
  });
}
