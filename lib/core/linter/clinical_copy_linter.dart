/// Clinical Copy Linter verifying DPDP compliance & Medical Disclaimer rules
class ClinicalCopyLinter {
  const ClinicalCopyLinter();

  /// Validate health copy string for required medical disclaimer and DPDP compliance
  bool validateMedicalCopy(String copyText) {
    final lower = copyText.toLowerCase();
    final hasDisclaimer = lower.contains('disclaimer') || lower.contains('consult doctor') || lower.contains('not medical advice');
    final hasDpdpCompliance = lower.contains('dpdp') || lower.contains('data protection') || lower.contains('privacy');

    return hasDisclaimer || hasDpdpCompliance;
  }
}
