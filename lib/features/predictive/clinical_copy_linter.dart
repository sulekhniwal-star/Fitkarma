/// §P10-M Clinical Copy Linter (§P10-I & §P10-K Compliance)
///
/// Lints and sanitizes all generated clinical/medication warning copy to enforce strict
/// non-diagnostic, informational phrasing matching §P10-M & §P10-K specifications.
library;

class ClinicalCopyLinter {
  const ClinicalCopyLinter();

  /// Prohibited diagnostic terms and their non-diagnostic replacements (§P10-M spec).
  static const Map<String, String> _replacements = {
    'you are diagnosed with': 'observations indicate potential markers for',
    'diagnosed with': 'associated with',
    'prescribe': 'suggest discussing with your physician',
    'prescription': 'medication protocol',
    'cures': 'supports wellness around',
    'cure': 'support',
    'treatment for': 'wellness support for',
  };

  /// Lints and sanitizes raw copy to ensure compliance with non-diagnostic standards.
  String lintAndSanitize(String rawCopy) {
    String sanitized = rawCopy;

    _replacements.forEach((prohibited, approved) {
      final pattern = RegExp(prohibited, caseSensitive: false);
      sanitized = sanitized.replaceAll(pattern, approved);
    });

    // Ensure non-diagnostic advisory footer notice is present if not already contained
    if (!sanitized.contains('Informational only')) {
      sanitized = '$sanitized (Informational only: consult your physician for medical guidance)';
    }

    return sanitized;
  }
}
