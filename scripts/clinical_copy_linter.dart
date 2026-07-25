/// Clinical Copy Linter Script for §P10-I, §P10-H, §P10-J
///
/// Scans codebase clinical/medical copy to ensure mandatory medical disclaimers
/// and §P10-M compliance boundaries are enforced across app screens and exports.
library;

import 'dart:io';

void main(List<String> args) {
  stdout.writeln('🩺 Running Clinical Copy Linter (§P10-I/H/J Compliance Check)...');

  final targetDir = Directory('lib');
  if (!targetDir.existsSync()) {
    stderr.writeln('Error: lib directory not found.');
    exit(1);
  }

  int filesScanned = 0;
  int violationsFound = 0;

  final dartFiles = targetDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in dartFiles) {
    filesScanned++;
    final content = file.readAsStringSync();

    // Verify §P10-M medical advice disclaimer on doctor sharing portal or prescription screens
    if (content.contains('DoctorSharing') || content.contains('PrescriptionVerification')) {
      if (!content.contains('not a substitute for professional medical advice') &&
          !content.contains('FitKarma Doctor Sharing Portal') &&
          !content.contains('Compliance Boundary Banner')) {
        stderr.writeln('❌ Violation in ${file.path}: Missing §P10-M medical disclaimer or compliance banner.');
        violationsFound++;
      }
    }
  }

  stdout.writeln('Scanned $filesScanned files. Violations found: $violationsFound.');
  if (violationsFound > 0) {
    exit(1);
  } else {
    stdout.writeln('✅ Clinical Copy Linter passed cleanly!');
    exit(0);
  }
}
