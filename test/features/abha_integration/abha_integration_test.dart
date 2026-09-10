import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/abha_integration/domain/abha_engine.dart';
import 'package:fitkarma/features/abha_integration/domain/abha_models.dart';
import 'package:fitkarma/features/abha_integration/providers/abha_provider.dart';

void main() {
  group('AbhaEngine Deterministic Tests', () {
    const engine = AbhaEngine();

    test('Validates and formats 14-digit ABHA Numbers accurately', () {
      expect(AbhaEngine.isValidAbhaNumber('14882249128734'), isTrue);
      expect(AbhaEngine.isValidAbhaNumber('14-8822-4912-8734'), isTrue);
      expect(AbhaEngine.isValidAbhaNumber('1234'), isFalse);
      expect(AbhaEngine.formatAbhaNumber('14882249128734'), equals('14-8822-4912-8734'));
    });

    test('Validates ABHA PHR Address handles across valid ABDM domains', () {
      expect(AbhaEngine.isValidAbhaAddress('rahul.sharma@abdm'), isTrue);
      expect(AbhaEngine.isValidAbhaAddress('priya_fit@sbx'), isTrue);
      expect(AbhaEngine.isValidAbhaAddress('user@fitkarma'), isTrue);
      expect(AbhaEngine.isValidAbhaAddress('invalid@gmail.com'), isFalse);
    });

    test('Generates deterministic KYC OTP and verifies successfully', () {
      final otp = engine.generateKycOtp('14882249128734');
      expect(otp.length, equals(6));
      expect(engine.verifyKycOtp(enteredOtp: otp, expectedOtp: otp), isTrue);
      expect(engine.verifyKycOtp(enteredOtp: '000000', expectedOtp: otp), isFalse);
    });

    test('Synthesizes verified ABHA profile with official QR payload', () {
      final profile = engine.synthesizeVerifiedProfile(
        aadhaarOrAbhaNumber: '14882249128734',
        fullName: 'Rahul Sharma',
        mobileNumber: '+919876543210',
      );

      expect(profile.isLinked, isTrue);
      expect(profile.abhaNumber, equals('14-8822-4912-8734'));
      expect(profile.verificationStatus, equals(AbhaVerificationStatus.verifiedAadhaar));
      expect(profile.qrCodePayload, contains('nha_v'));
    });

    test('Serializes ABDM FHIR R4 Document Bundle correctly', () {
      final profile = engine.synthesizeVerifiedProfile(
        aadhaarOrAbhaNumber: '14882249128734',
        fullName: 'Rahul Sharma',
        mobileNumber: '+919876543210',
      );

      final bundle = engine.generateFhirR4Bundle(
        profile: profile,
        biologicalAge: 28.5,
        longevityScore: 91.0,
        prakritiConstitution: 'Pitta-Vata',
        vo2Max: 46.2,
        weeklyStepsAverage: 11200,
      );

      expect(bundle['resourceType'], equals('Bundle'));
      expect(bundle['type'], equals('document'));
      final entries = bundle['entry'] as List;
      expect(entries.length, equals(4));

      final patient = entries[0]['resource'];
      expect(patient['resourceType'], equals('Patient'));

      final longevityObs = entries[1]['resource'];
      expect(longevityObs['resourceType'], equals('Observation'));
      expect(longevityObs['valueQuantity']['value'], equals(91.0));
    });
  });

  group('AbhaIntegrationNotifier State Tests', () {
    test('Handles Aadhaar OTP verification, consent management, and FHIR sync', () {
      final notifier = AbhaIntegrationNotifier();
      expect(notifier.state.profile.isLinked, isTrue);
      expect(notifier.state.activeConsents.length, equals(2));

      // Initiate KYC
      notifier.initiateAadhaarKyc('14882249128734');
      expect(notifier.state.pendingOtp, isNotNull);
      expect(notifier.state.profile.verificationStatus, equals(AbhaVerificationStatus.pendingOtp));

      final otp = notifier.state.pendingOtp!;
      final verified = notifier.verifyOtp(otp);
      expect(verified, isTrue);
      expect(notifier.state.profile.isLinked, isTrue);

      // Consent Revocation
      notifier.revokeConsent('cr_apollo_001');
      final apolloConsent = notifier.state.activeConsents.firstWhere((c) => c.consentRequestId == 'cr_apollo_001');
      expect(apolloConsent.status, equals(AbhaConsentStatus.revoked));
      expect(apolloConsent.isActive, isFalse);

      // Re-authorize
      notifier.approveConsent('cr_apollo_001');
      expect(notifier.state.activeConsents.firstWhere((c) => c.consentRequestId == 'cr_apollo_001').isActive, isTrue);

      // FHIR Sync
      notifier.syncFhirRecordsWithAbdm();
      expect(notifier.state.latestFhirBundle, isNotNull);
      expect(notifier.state.latestFhirBundle?.observationCount, equals(4));
    });
  });
}
