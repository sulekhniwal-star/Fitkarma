/// §COMPLIANCE — DPDP Act Privacy Policy & Cohort Anonymization Verifier
///
/// Implements the DPDP Act compliance service: privacy policy linking,
/// anonymized cohort sync exclusion rules, and data principal consent management.
library;

class DpdpActPrivacyPolicy {
  const DpdpActPrivacyPolicy();

  static const String privacyPolicyUrl = 'https://fitkarma.in/privacy-policy';
  static const String termsOfServiceUrl = 'https://fitkarma.in/terms-of-service';
  static const String grievanceOfficerEmail = 'privacy@fitkarma.in';

  // DPDP Act §6 — Consent purpose declarations
  static const List<String> consentPurposes = [
    'Health and fitness data processing for personalized wellness recommendations',
    'Biometric data processing for activity and recovery analysis',
    'Aggregate anonymized cohort analytics (minimum cohort size ≥ 5)',
    'WhatsApp Business messaging (opt-in only, revocable at any time)',
    'ABHA Health ID linking for Doctor Sharing Portal',
    'Corporate/employer wellness program enrollment (opt-in, reversible)',
  ];

  // DPDP Act §12 — Nominated Data Fiduciary
  static const String dataFiduciaryName = 'FitKarma Health Technologies Pvt. Ltd.';
  static const String dataFiduciaryAddress = 'Bengaluru, Karnataka, India';

  String get policyVersion => 'v1.0 — July 2026';
}

class AnonymizedCohortSyncVerifier {
  const AnonymizedCohortSyncVerifier();

  /// Verifies an aggregate cohort payload contains NO individual identifiers
  /// that would violate §COMPLIANCE — specifically:
  /// - No individual lab dates (only date ranges or aggregated periods)
  /// - No medication brand names (only generic therapeutic class)
  /// - No individual userId keys
  /// - No ABHA Health IDs
  CohortSyncVerificationResult verifyCohortPayload(Map<String, dynamic> payload) {
    final violations = <String>[];

    // 1. No individual user IDs
    if (_containsUserIdKeys(payload)) {
      violations.add('Payload contains individual userId fields — prohibited in cohort sync');
    }

    // 2. No lab dates for individuals
    if (_containsLabDates(payload)) {
      violations.add('Payload contains individual lab_date fields — must aggregate to date ranges');
    }

    // 3. No medication brand names
    if (_containsMedicationBrandNames(payload)) {
      violations.add('Payload contains medication brand names — use generic therapeutic class only');
    }

    // 4. No ABHA Health IDs
    if (_containsAbhaIds(payload)) {
      violations.add('Payload contains ABHA Health IDs — prohibited in any cohort sync');
    }

    return CohortSyncVerificationResult(
      isCompliant: violations.isEmpty,
      violations: violations,
    );
  }

  bool _containsUserIdKeys(Map<String, dynamic> payload) {
    // Check top-level keys directly (Dart toString uses {key: value} not {"key": value})
    return payload.keys.any((k) {
      final lower = k.toLowerCase();
      return lower == 'userid' || lower == 'user_id' || lower == 'sub';
    });
  }

  bool _containsLabDates(Map<String, dynamic> payload) {
    final serialized = payload.toString();
    return serialized.contains('labDate') || serialized.contains('lab_date');
  }

  bool _containsMedicationBrandNames(Map<String, dynamic> payload) {
    // Known brand name keywords that must not appear in cohort payloads
    const prohibitedBrandTerms = ['metformin', 'januvia', 'galvus', 'pioglitazone'];
    final serialized = payload.toString().toLowerCase();
    return prohibitedBrandTerms.any((brand) => serialized.contains(brand));
  }

  bool _containsAbhaIds(Map<String, dynamic> payload) {
    final serialized = payload.toString();
    return serialized.contains('abhaHealthId') || serialized.contains('abha_health_id');
  }
}

class CohortSyncVerificationResult {
  const CohortSyncVerificationResult({
    required this.isCompliant,
    required this.violations,
  });

  final bool isCompliant;
  final List<String> violations;
}
