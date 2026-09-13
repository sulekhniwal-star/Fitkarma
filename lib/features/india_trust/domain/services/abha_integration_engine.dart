class AbhaIntegrationEngine {
  const AbhaIntegrationEngine();

  /// Validates 14-digit ABHA Number format (e.g. 14-1234-5678-9012 or 14 digits)
  bool validateAbhaNumber(String abhaNumber) {
    final clean = abhaNumber.replaceAll(RegExp(r'[\s\-]'), '');
    if (clean.length != 14) return false;
    return RegExp(r'^\d{14}$').hasMatch(clean);
  }

  /// Formats raw 14-digit string to standard XX-XXXX-XXXX-XXXX display
  String formatAbhaNumber(String rawDigits) {
    final clean = rawDigits.replaceAll(RegExp(r'[\s\-]'), '');
    if (clean.length != 14) return rawDigits;
    return '${clean.substring(0, 2)}-${clean.substring(2, 6)}-${clean.substring(6, 10)}-${clean.substring(10, 14)}';
  }

  /// Validates ABHA Address (PHR Address) format (e.g. rahul@abdm or sharma123@sbx)
  bool validateAbhaAddress(String address) {
    return RegExp(r'^[a-zA-Z0-9_\.]{3,32}@(abdm|sbx|abdm_sandbox)$').hasMatch(address.toLowerCase());
  }

  /// Generates FHIR DiagnosticReport bundle payload for clinical syncing
  Map<String, dynamic> generateFhirDiagnosticReport({
    required String abhaNumber,
    required String patientName,
    required double fastingGlucose,
    required double systolicBp,
    required double diastolicBp,
    required int biologicalAge,
  }) {
    return {
      'resourceType': 'DiagnosticReport',
      'id': 'fitkarma-dr-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'final',
      'category': [
        {
          'coding': [
            {
              'system': 'http://terminology.hl7.org/CodeSystem/v2-0074',
              'code': 'LAB',
              'display': 'Laboratory & Vitals',
            }
          ]
        }
      ],
      'subject': {
        'identifier': {
          'system': 'https://healthid.abdm.gov.in',
          'value': abhaNumber,
        },
        'display': patientName,
      },
      'effectiveDateTime': DateTime.now().toIso8601String(),
      'result': [
        {
          'display': 'Fasting Blood Glucose',
          'valueQuantity': {'value': fastingGlucose, 'unit': 'mg/dL'}
        },
        {
          'display': 'Blood Pressure',
          'valueString': '${systolicBp.toInt()}/${diastolicBp.toInt()} mmHg'
        },
        {
          'display': 'Cellular Biological Age',
          'valueQuantity': {'value': biologicalAge, 'unit': 'years'}
        },
      ],
    };
  }
}
