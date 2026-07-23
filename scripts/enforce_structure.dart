// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final directory = Directory('lib');
  if (!directory.existsSync()) {
    print('Error: lib/ directory not found.');
    exit(1);
  }

  final allowedTopLevelDirs = {
    'core',
    'features',
    'data',
    'services',
    'shared',
    'screens',
  };

  print('Verifying Fitkarma folder structure enforcement...');
  bool hasErrors = false;

  final files = directory.listSync(recursive: true);
  for (var entity in files) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Normalize path separating characters for split operations
      final relativePath = entity.path.replaceFirst(
        'lib${Platform.pathSeparator}',
        '',
      );
      final pathParts = relativePath.split(Platform.pathSeparator);

      // If it is directly in lib/ (e.g. lib/main.dart)
      if (pathParts.length == 1) {
        if (pathParts[0] == 'main.dart') {
          continue;
        } else {
          print(
            '❌ ERROR: File located directly in lib/ root is not allowed: ${entity.path}',
          );
          hasErrors = true;
        }
      } else {
        final topLevelDir = pathParts[0];
        if (!allowedTopLevelDirs.contains(topLevelDir)) {
          print(
            '❌ ERROR: File resides in unapproved top-level folder "$topLevelDir": ${entity.path}',
          );
          hasErrors = true;
        }
      }
    }
  }

  if (hasErrors) {
    print('Failed: Folder structure validation failed with errors.');
    exit(1);
  }

  print('✅ Success: Folder structure enforcement passed.');
}
