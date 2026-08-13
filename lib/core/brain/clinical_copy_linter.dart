/// Clinical Copy Directive-Language Linter per §P10-M spec
/// Enforces non-directive informational copy on interaction warnings.
class ClinicalCopyLinter {
  static const List<String> bannedDirectivePatterns = [
    r'\bstop taking\b',
    r'(?<!consult.{0,20})\bavoid\b(?!.{0,20}consult)', // "avoid" without "consult" anywhere within 20 chars before or after
    r'\breduce your dose\b',
    r'\bdo not take\b',
    r'\bswitch to\b',
  ];

  const ClinicalCopyLinter();

  /// Returns list of directive violations found. Empty list means copy is compliant.
  List<String> lint(String copy) {
    final violations = <String>[];
    for (final pattern in bannedDirectivePatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(copy)) {
        violations.add('Directive pattern matched: $pattern in "$copy"');
      }
    }
    return violations;
  }

  /// Verifies a collection of copy strings (e.g. interaction rule databases)
  Map<String, List<String>> lintAll(Map<String, String> copyMap) {
    final results = <String, List<String>>{};
    copyMap.forEach((key, copy) {
      final violations = lint(copy);
      if (violations.isNotEmpty) {
        results[key] = violations;
      }
    });
    return results;
  }
}
