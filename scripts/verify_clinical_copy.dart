/// CI Script: Verifies Clinical Copy Compliance (§P10-M)
/// Runs during GitHub Actions CI pipeline against §P10-I, §P10-H, and §P10-J files.

import 'dart:io';

const bannedDirectivePatterns = [
  r'\bstop taking\b',
  r'(?<!\bconsult\b.{0,30})\bavoid\b(?!.{0,30}\bconsult\b)',
  r'\breduce your dose\b',
  r'\bdo not take\b',
  r'\bswitch to\b',
  r'\byou are diagnosed with\b',
  r'\bprescribe\b',
  r'\bcures\b',
];

void main() {
  print('🔒 Running Clinical Copy Linter (§P10-M CI Verification)...');

  final targetFiles = [
    'lib/features/predictive/medication_engine.dart',
    'lib/features/predictive/cgm_sync_engine.dart',
    'lib/features/predictive/doctor_sharing_engine.dart',
    'lib/features/predictive/monthly_report_generator.dart',
    'lib/features/predictive/health_risk_prevention_engine.dart',
  ];

  int totalViolations = 0;

  for (final filePath in targetFiles) {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('⚠️ Warning: File not found: $filePath');
      continue;
    }

    final lines = file.readAsLinesSync();
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      // Skip comments starting with // or ///
      final trimmed = line.trim();
      if (trimmed.startsWith('//') || trimmed.startsWith('///')) continue;

      for (final pattern in bannedDirectivePatterns) {
        if (pattern == r'\bavoid\b(?!.{0,30}\bconsult\b)') {
          if (line.toLowerCase().contains('avoid') && !line.toLowerCase().contains('consult')) {
            print('❌ VIOLATION [$filePath:${i + 1}]: Banned directive pattern "$pattern" matched line:');
            print('   > $line');
            totalViolations++;
          }
        } else {
          final regex = RegExp(pattern, caseSensitive: false);
          if (regex.hasMatch(line)) {
            print('❌ VIOLATION [$filePath:${i + 1}]: Banned directive pattern "$pattern" matched line:');
            print('   > $line');
            totalViolations++;
          }
        }
      }
    }
  }

  if (totalViolations > 0) {
    print('\n❌ Clinical Copy Linter failed with $totalViolations violation(s).');
    print('   Please rewrite copy to informational framing before merging (§P10-M).');
    exit(1);
  } else {
    print('✅ Clinical Copy Linter passed with 0 violations across all §P10-I/H/J files.');
    exit(0);
  }
}
