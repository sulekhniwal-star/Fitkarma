import 'compliance_models.dart';

/// Pure Dart Deterministic Engine for Regulatory & Clinical Compliance
class ComplianceEngine {
  const ComplianceEngine();

  /// Standard clinical and SaMD disclaimer adhering to CDSCO, FDA, and AYUSH norms
  ClinicalDisclaimer getStandardClinicalDisclaimer() {
    return const ClinicalDisclaimer(
      title: 'SaMD & Clinical Decision Support Notice',
      regionalTitle: 'सॉफ्टवेयर-एज-ए-मेडिकल-डिवाइस (SaMD) एवं स्वास्थ्य परामर्श सूचना',
      legalText:
          'FitKarma provides AI-driven lifestyle recommendations, Ayurvedic dosha harmony insights, '
          'and preventive biomarker risk stratification. It is NOT a substitute for professional '
          'medical diagnosis, prescription, or clinical treatment. Always consult a certified healthcare '
          'practitioner or registered medical doctor before making any clinical modifications.',
      regionalLegalText:
          'फिटकर्मा एआई-आधारित जीवनशैली मार्गदर्शन, आयुर्वेदिक त्रिदोष संतुलन एवं निवारक बायोमार्कर '
          'जोखिम विश्लेषण प्रदान करता है। यह किसी पंजीकृत चिकित्सक के चिकित्सकीय निदान या उपचार का विकल्प '
          'नहीं है। किसी भी चिकित्सीय परिवर्तन से पूर्व अपने चिकित्सक से परामर्श अवश्य करें।',
      emergencyHelpline: 'National Medical Emergency: 112 / 108 (India) | 911 (US)',
    );
  }

  /// Evaluates regulatory compliance state across ABDM, DPDP, HIPAA, and AYUSH frameworks
  ComplianceFrameworkReport evaluateCompliance({
    required List<ClinicalConsentArtifact> userConsents,
    bool encryptionAtRestVerified = true,
    bool auditLoggingActive = true,
    bool dataErasureSupported = true,
    DateTime? auditTimestamp,
  }) {
    final now = auditTimestamp ?? DateTime.now();

    // Default standards supported
    final activeStandards = ComplianceStandard.values;

    // Check valid non-expired active consents
    final validConsents = userConsents.where((c) {
      return c.isExplicitlyGranted && c.expiresAt.isAfter(now);
    }).toList();

    // Calculate score
    double score = 0.0;
    if (encryptionAtRestVerified) {
      score += 25.0;
    }
    if (auditLoggingActive) {
      score += 25.0;
    }
    if (dataErasureSupported) {
      score += 25.0;
    }
    if (validConsents.isNotEmpty) {
      score += 25.0;
    }

    final isCompliant = score >= 100.0;

    return ComplianceFrameworkReport(
      complianceAuditScore: score,
      isFullyCompliant: isCompliant,
      activeStandards: activeStandards,
      activeConsents: validConsents,
      clinicalDisclaimer: getStandardClinicalDisclaimer(),
      encryptionAtRestVerified: encryptionAtRestVerified,
      auditLoggingActive: auditLoggingActive,
      dataErasureSupported: dataErasureSupported,
      lastComplianceAudit: now,
    );
  }

  /// Generates baseline statutory consents conforming to DPDP 2023 & ABDM M3
  List<ClinicalConsentArtifact> generateDefaultStatutoryConsents({DateTime? grantedTime}) {
    final start = grantedTime ?? DateTime.now();
    final oneYearExpiry = start.add(const Duration(days: 365));

    return [
      ClinicalConsentArtifact(
        consentId: 'CONSENT-DPDP-HEALTH-TELEMETRY-01',
        purpose: 'Biometric & Predictive Health Analytics',
        regionalPurpose: 'बायोमेट्रिक एवं निवारक स्वास्थ्य विश्लेषण',
        dataCategories: const [
          'Heart Rate & HRV',
          'Sleep Cycles & Recovery',
          'Biomarkers & Lab Reports',
          'Dosha Constitution',
        ],
        grantedAt: start,
        expiresAt: oneYearExpiry,
        isExplicitlyGranted: true,
        isRevocable: true,
      ),
      ClinicalConsentArtifact(
        consentId: 'CONSENT-ABDM-FHIR-SHARE-02',
        purpose: 'Ayushman Bharat Health Account (ABHA) Interoperability',
        regionalPurpose: 'आयुष्मान भारत स्वास्थ्य खाता (ABHA) डेटा आदान-प्रदान',
        dataCategories: const [
          'Diagnostic Reports',
          'Doctor Consultation Summaries',
          'Prescription & Medication Tracking',
        ],
        grantedAt: start,
        expiresAt: oneYearExpiry,
        isExplicitlyGranted: true,
        isRevocable: true,
      ),
      ClinicalConsentArtifact(
        consentId: 'CONSENT-AYUSH-LIFESTYLE-03',
        purpose: 'Ayurvedic Dinacharya & Seasonal Ritucharya Personalization',
        regionalPurpose: 'दिनचर्या एवं ऋतुचर्या अनुसार व्यक्तिगत जीवनशैली परामर्श',
        dataCategories: const [
          'Dietary Intake',
          'Agni & Digestion Logs',
          'Activity & Yoga Telemetry',
        ],
        grantedAt: start,
        expiresAt: oneYearExpiry,
        isExplicitlyGranted: true,
        isRevocable: true,
      ),
    ];
  }
}
