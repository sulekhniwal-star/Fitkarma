import 'dart:convert';
import 'abha_models.dart';

/// Pure Dart Deterministic Engine for ABDM ABHA Number Validation,
/// FHIR R4 Bundle Serialization, KYC Verification, and Consent Management.
class AbhaEngine {
  const AbhaEngine();

  /// Validates 14-digit ABHA ID format (e.g. 14-8822-4912-8734 or 14882249128734)
  static bool isValidAbhaNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 14) return false;

    // First two digits of Indian ABHA are typically between 10 and 99
    final firstTwo = int.tryParse(cleaned.substring(0, 2)) ?? 0;
    return firstTwo >= 10 && firstTwo <= 99;
  }

  /// Formats 14 raw digits into standard hyphenated ABHA display format: XX-XXXX-XXXX-XXXX
  static String formatAbhaNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 14) return input;
    return '${cleaned.substring(0, 2)}-${cleaned.substring(2, 6)}-${cleaned.substring(6, 10)}-${cleaned.substring(10, 14)}';
  }

  /// Validates ABHA PHR Address Handle format (e.g. rahul.sharma@abdm)
  static bool isValidAbhaAddress(String address) {
    final pattern = RegExp(r'^[a-zA-Z0-9._]{3,32}@(abdm|sbx|fitkarma|aarogyasetu|ndhm)$');
    return pattern.hasMatch(address.trim().toLowerCase());
  }

  /// Generates deterministic 6-digit OTP for Aadhaar/Mobile KYC verification
  String generateKycOtp(String idToken) {
    int hash = 5381;
    for (int i = 0; i < idToken.length; i++) {
      hash = ((hash << 5) + hash) + idToken.codeUnitAt(i);
    }
    final int otp = (hash.abs() % 900000) + 100000;
    return otp.toString();
  }

  /// Verifies entered OTP against expected KYC OTP
  bool verifyKycOtp({required String enteredOtp, required String expectedOtp}) {
    return enteredOtp.trim() == expectedOtp.trim();
  }

  /// Synthesizes verified ABHA Profile upon successful Aadhaar KYC
  AbhaProfile synthesizeVerifiedProfile({
    required String aadhaarOrAbhaNumber,
    required String fullName,
    required String mobileNumber,
    String? preferredAbhaAddress,
    String gender = 'M',
    String dateOfBirth = '1992-06-15',
    String pincode = '560001',
    String stateName = 'Karnataka',
    String districtName = 'Bengaluru Urban',
  }) {
    final formattedNumber = formatAbhaNumber(
      isValidAbhaNumber(aadhaarOrAbhaNumber)
          ? aadhaarOrAbhaNumber
          : '14882249128734',
    );

    final cleanName = fullName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '.');
    final phrAddress = preferredAbhaAddress ?? '$cleanName@abdm';

    final qrPayload = jsonEncode({
      'hidn': formattedNumber,
      'hid': phrAddress,
      'name': fullName,
      'gender': gender,
      'dob': dateOfBirth,
      'mobile': mobileNumber,
      'state': stateName,
      'dist': districtName,
      'nha_v': '0.5_ABDM',
    });

    return AbhaProfile(
      abhaNumber: formattedNumber,
      abhaAddress: phrAddress,
      fullName: fullName,
      gender: gender,
      dateOfBirth: dateOfBirth,
      mobileNumber: mobileNumber,
      pincode: pincode,
      stateName: stateName,
      districtName: districtName,
      verificationStatus: AbhaVerificationStatus.verifiedAadhaar,
      qrCodePayload: qrPayload,
      linkedAt: DateTime.now(),
    );
  }

  /// Serializes FitKarma health biometrics into ABDM FHIR R4 Bundle JSON
  Map<String, dynamic> generateFhirR4Bundle({
    required AbhaProfile profile,
    required double biologicalAge,
    required double longevityScore,
    required String prakritiConstitution,
    required double vo2Max,
    required int weeklyStepsAverage,
  }) {
    final nowIso = DateTime.now().toIso8601String();
    final bundleId = 'fitkarma-fhir-bundle-${DateTime.now().millisecondsSinceEpoch}';

    return {
      'resourceType': 'Bundle',
      'id': bundleId,
      'meta': {
        'versionId': '1',
        'lastUpdated': nowIso,
        'profile': ['https://nrces.in/ndhm/fhir/r4/StructureDefinition/DocumentBundle'],
      },
      'type': 'document',
      'timestamp': nowIso,
      'entry': [
        // 1. Patient Resource
        {
          'resource': {
            'resourceType': 'Patient',
            'id': 'patient-01',
            'identifier': [
              {
                'system': 'https://healthid.ndhm.gov.in',
                'value': profile.abhaNumber,
              },
              {
                'system': 'https://abdm.gov.in/phr',
                'value': profile.abhaAddress,
              },
            ],
            'name': [
              {'text': profile.fullName}
            ],
            'gender': profile.gender == 'M' ? 'male' : (profile.gender == 'F' ? 'female' : 'other'),
            'birthDate': profile.dateOfBirth,
          }
        },
        // 2. Longevity Score & Biological Age Observation
        {
          'resource': {
            'resourceType': 'Observation',
            'id': 'obs-longevity-01',
            'status': 'final',
            'code': {
              'coding': [
                {
                  'system': 'https://fitkarma.com/codes/longevity',
                  'code': 'FK-LONGEVITY-SCORE',
                  'display': 'FitKarma Composite Longevity Resilience Score',
                }
              ]
            },
            'subject': {'reference': 'Patient/patient-01'},
            'valueQuantity': {
              'value': longevityScore,
              'unit': 'score',
              'system': 'http://unitsofmeasure.org',
            },
            'component': [
              {
                'code': {'text': 'Biological Age Estimate'},
                'valueQuantity': {'value': biologicalAge, 'unit': 'years'},
              },
              {
                'code': {'text': 'Estimated VO2 Max'},
                'valueQuantity': {'value': vo2Max, 'unit': 'ml/kg/min'},
              },
            ],
          }
        },
        // 3. Ayurvedic Prakriti Constitution Observation
        {
          'resource': {
            'resourceType': 'Observation',
            'id': 'obs-prakriti-01',
            'status': 'final',
            'code': {
              'coding': [
                {
                  'system': 'https://ayush.gov.in/prakriti',
                  'code': 'AYUSH-PRAKRITI',
                  'display': 'Ayurvedic Prakriti Dosha Balance',
                }
              ]
            },
            'subject': {'reference': 'Patient/patient-01'},
            'valueString': prakritiConstitution,
          }
        },
        // 4. Physical Activity & Step Cadence Observation
        {
          'resource': {
            'resourceType': 'Observation',
            'id': 'obs-steps-01',
            'status': 'final',
            'code': {
              'coding': [
                {
                  'system': 'http://loinc.org',
                  'code': '41950-7',
                  'display': 'Number of steps in 24 hour Measured',
                }
              ]
            },
            'subject': {'reference': 'Patient/patient-01'},
            'valueQuantity': {
              'value': weeklyStepsAverage,
              'unit': 'steps/day',
            },
          }
        },
      ],
    };
  }
}
