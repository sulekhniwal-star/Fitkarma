// §P16-C ABHA Health ID Integration & FHIR-Lite Export Engine (Pure Dart)
// Cross-reference: §P16-C, §P10-J, §P10-K, §P10-M in Fitkarma_documentation.md

import 'doctor_sharing_service.dart';

/// ABHA Profile Model
class AbhaHealthProfile {
  final String abhaNumber; // 14-digit format: 91-XXXX-XXXX-XXXX
  final String abhaAddress; // format: name@abdm
  final bool isLinked;
  final bool isKycVerified;
  final DateTime? linkedAt;
  final String? encryptedToken;

  const AbhaHealthProfile({
    this.abhaNumber = '',
    this.abhaAddress = '',
    this.isLinked = false,
    this.isKycVerified = false,
    this.linkedAt,
    this.encryptedToken,
  });

  AbhaHealthProfile copyWith({
    String? abhaNumber,
    String? abhaAddress,
    bool? isLinked,
    bool? isKycVerified,
    DateTime? linkedAt,
    String? encryptedToken,
  }) {
    return AbhaHealthProfile(
      abhaNumber: abhaNumber ?? this.abhaNumber,
      abhaAddress: abhaAddress ?? this.abhaAddress,
      isLinked: isLinked ?? this.isLinked,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      linkedAt: linkedAt ?? this.linkedAt,
      encryptedToken: encryptedToken ?? this.encryptedToken,
    );
  }
}

/// FHIR-Lite Structured Clinical Health Bundle
class FhirLiteBundle {
  final String bundleId;
  final String patientAbhaId;
  final String patientName;
  final DateTime generatedAt;
  final Map<String, dynamic> patientResource;
  final List<Map<String, dynamic>> observations;
  final String clinicalDisclaimer;

  const FhirLiteBundle({
    required this.bundleId,
    required this.patientAbhaId,
    required this.patientName,
    required this.generatedAt,
    required this.patientResource,
    required this.observations,
    required this.clinicalDisclaimer,
  });

  Map<String, dynamic> toJson() => {
        'resourceType': 'Bundle',
        'id': bundleId,
        'type': 'document',
        'timestamp': generatedAt.toIso8601String(),
        'entry': [
          {
            'resource': patientResource,
          },
          ...observations.map((obs) => {'resource': obs}),
        ],
        'complianceDisclaimer': clinicalDisclaimer,
      };
}

/// Pure Dart ABHA Integration & FHIR-Lite Generation Engine
class AbhaIntegrationEngine {
  const AbhaIntegrationEngine();

  /// Validates ABHA 14-digit format (e.g. "91-1234-5678-9012" or 14 continuous digits)
  bool validateAbhaNumber(String input) {
    final cleaned = input.replaceAll('-', '').trim();
    if (cleaned.length != 14) return false;
    return RegExp(r'^\d{14}$').hasMatch(cleaned);
  }

  /// Validates ABHA Address (e.g. "user@abdm" or "user@sbx")
  bool validateAbhaAddress(String input) {
    final trimmed = input.trim();
    return RegExp(r'^[a-zA-Z0-9._-]+@(abdm|sbx|ndhm)$').hasMatch(trimmed);
  }

  /// Formats 14-digit continuous string into standard "XX-XXXX-XXXX-XXXX" display
  String formatAbhaNumber(String raw) {
    final digits = raw.replaceAll('-', '').trim();
    if (digits.length != 14) return raw;
    return '${digits.substring(0, 2)}-${digits.substring(2, 6)}-${digits.substring(6, 10)}-${digits.substring(10, 14)}';
  }

  /// Generates FHIR-Lite structured bundle for NDHM network doctors (§P16-C)
  FhirLiteBundle generateFhirLiteBundle({
    required AbhaHealthProfile profile,
    required DoctorReportSummary reportSummary,
  }) {
    final now = DateTime.now();
    final bundleId = 'fhir-bundle-${now.millisecondsSinceEpoch}';

    final patientResource = {
      'resourceType': 'Patient',
      'id': 'pat-${profile.abhaNumber.replaceAll("-", "")}',
      'identifier': [
        {
          'system': 'https://healthid.ndhm.gov.in',
          'value': profile.abhaNumber,
        },
        {
          'system': 'https://abdm.gov.in/address',
          'value': profile.abhaAddress,
        },
      ],
      'name': [
        {'text': reportSummary.patientName}
      ],
    };

    final observations = <Map<String, dynamic>>[
      // Blood Pressure Observation
      {
        'resourceType': 'Observation',
        'id': 'obs-bp',
        'status': 'final',
        'code': {
          'coding': [
            {
              'system': 'http://loinc.org',
              'code': '85354-9',
              'display': 'Blood pressure panel'
            }
          ]
        },
        'component': [
          {
            'code': {'text': 'Systolic'},
            'valueQuantity': {
              'value': reportSummary.averageSystolicBp,
              'unit': 'mmHg'
            }
          },
          {
            'code': {'text': 'Diastolic'},
            'valueQuantity': {
              'value': reportSummary.averageDiastolicBp,
              'unit': 'mmHg'
            }
          },
        ],
      },
      // Fasting Glucose Observation
      {
        'resourceType': 'Observation',
        'id': 'obs-glucose',
        'status': 'final',
        'code': {
          'coding': [
            {
              'system': 'http://loinc.org',
              'code': '1558-6',
              'display': 'Fasting Glucose'
            }
          ]
        },
        'valueQuantity': {
          'value': reportSummary.averageFastingGlucoseMgDl,
          'unit': 'mg/dL',
        },
      },
      // 90-Day Adherence & Consistency Observation
      {
        'resourceType': 'Observation',
        'id': 'obs-adherence',
        'status': 'final',
        'code': {'text': '90-Day Lifestyle Adherence'},
        'valueQuantity': {
          'value': reportSummary.adherencePct90Days,
          'unit': '%',
        },
      },
    ];

    const disclaimer =
        'NON-DIAGNOSTIC NOTICE (§P10-K/M): This structured health summary is generated for informational and lifestyle tracking purposes only. It does not constitute a clinical diagnosis or prescription.';

    return FhirLiteBundle(
      bundleId: bundleId,
      patientAbhaId: profile.abhaNumber,
      patientName: reportSummary.patientName,
      generatedAt: now,
      patientResource: patientResource,
      observations: observations,
      clinicalDisclaimer: disclaimer,
    );
  }
}
