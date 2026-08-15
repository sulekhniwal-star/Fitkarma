import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/abha_integration_engine.dart';
import 'package:fitkarma/core/brain/doctor_sharing_service.dart';
import 'package:fitkarma/features/predictive_health/providers/abha_provider.dart';

void main() {
  group('§P16-C ABHA Health ID & FHIR-Lite Integration Engine Tests', () {
    const engine = AbhaIntegrationEngine();

    test('Validates 14-digit ABHA numbers and standard display formatting', () {
      expect(engine.validateAbhaNumber('91-1234-5678-9012'), isTrue);
      expect(engine.validateAbhaNumber('91123456789012'), isTrue);
      expect(engine.validateAbhaNumber('12345'), isFalse);
      expect(engine.validateAbhaNumber('91-1234-5678-ABCD'), isFalse);

      expect(engine.formatAbhaNumber('91123456789012'), equals('91-1234-5678-9012'));
    });

    test('Validates NDHM ABHA addresses (@abdm, @sbx, @ndhm)', () {
      expect(engine.validateAbhaAddress('arjun.sharma@abdm'), isTrue);
      expect(engine.validateAbhaAddress('test_user@sbx'), isTrue);
      expect(engine.validateAbhaAddress('doctor@ndhm'), isTrue);
      expect(engine.validateAbhaAddress('invalid@gmail.com'), isFalse);
    });

    test('Generates valid FHIR-Lite structured bundle for NDHM network doctors', () {
      const profile = AbhaHealthProfile(
        abhaNumber: '91-1234-5678-9012',
        abhaAddress: 'arjun.sharma@abdm',
        isLinked: true,
        isKycVerified: true,
      );

      const doctorService = DoctorSharingService();
      final reportSummary = doctorService.generateSampleReportSummary('Arjun Sharma');

      final fhirBundle = engine.generateFhirLiteBundle(
        profile: profile,
        reportSummary: reportSummary,
      );

      expect(fhirBundle.patientAbhaId, equals('91-1234-5678-9012'));
      expect(fhirBundle.patientName, equals('Arjun Sharma'));
      expect(fhirBundle.clinicalDisclaimer, contains('NON-DIAGNOSTIC NOTICE'));

      final json = fhirBundle.toJson();
      expect(json['resourceType'], equals('Bundle'));
      expect(json['type'], equals('document'));
      expect((json['entry'] as List).length, greaterThanOrEqualTo(3));
    });

    test('AbhaNotifier links, formats, and unlinks ABHA profiles correctly', () {
      final notifier = AbhaNotifier();

      expect(notifier.state.isLinked, isFalse);

      // Link invalid -> false
      final invalidLink = notifier.linkAbha(
        rawAbhaNumber: '123',
        abhaAddress: 'bad_address',
      );
      expect(invalidLink, isFalse);
      expect(notifier.state.isLinked, isFalse);

      // Link valid -> true
      final validLink = notifier.linkAbha(
        rawAbhaNumber: '91123456789012',
        abhaAddress: 'arjun.sharma@abdm',
      );
      expect(validLink, isTrue);
      expect(notifier.state.isLinked, isTrue);
      expect(notifier.state.abhaNumber, equals('91-1234-5678-9012'));
      expect(notifier.state.isKycVerified, isTrue);
      expect(notifier.state.encryptedToken, isNotNull);

      // Unlink
      notifier.unlinkAbha();
      expect(notifier.state.isLinked, isFalse);
      expect(notifier.state.abhaNumber, isEmpty);
    });
  });
}
