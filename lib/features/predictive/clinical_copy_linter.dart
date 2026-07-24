/// §P10-M Clinical Copy Linter (§P10-I & §P10-K Compliance)
///
/// Lints and sanitizes all generated clinical/medication warning copy to enforce strict
/// non-diagnostic, informational phrasing matching §P10-M & §P10-K specifications.
library;

class ClinicalCopyLinter {
  const ClinicalCopyLinter();

  /// Banned directive-pattern regexes (§P10-M spec).
  /// Rejects imperative medical directives ("stop taking", "avoid" without "consult", "reduce your dose").
  static const List<String> bannedDirectivePatterns = [
    r'\bstop taking\b',
    r'\bavoid\b(?!.{0,30}\bconsult\b)',
    r'\breduce your dose\b',
    r'\bdo not take\b',
    r'\bswitch to\b',
    r'\byou are diagnosed with\b',
    r'\bprescribe\b',
    r'\bcures\b',
  ];

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

  /// Returns violations found in [copy]. Returns an empty list if compliant (§P10-M).
  List<String> lint(String copy) {
    final violations = <String>[];
    final copyLower = copy.toLowerCase();

    for (final pattern in bannedDirectivePatterns) {
      if (pattern == r'\bavoid\b(?!.{0,30}\bconsult\b)') {
        if (copyLower.contains('avoid') && !copyLower.contains('consult')) {
          violations.add('Directive pattern matched: "avoid without consult" in "$copy"');
        }
      } else {
        final regex = RegExp(pattern, caseSensitive: false);
        if (regex.hasMatch(copy)) {
          violations.add('Directive pattern matched: "$pattern" in "$copy"');
        }
      }
    }
    return violations;
  }

  /// Returns true if [copy] contains zero directive violations (§P10-M).
  bool isCompliant(String copy) => lint(copy).isEmpty;

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
