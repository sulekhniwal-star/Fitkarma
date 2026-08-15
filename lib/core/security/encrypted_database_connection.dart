// §P14-A SQLCipher Secure Database Initialization
// Cross-reference: §P14-A in Fitkarma_documentation.md

import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class EncryptedDatabaseConnection {
  static const String keyName = 'fitkarma_db_cipher_key';
  static const FlutterSecureStorage _defaultStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Generates a 256-bit passphrase using the OS-level CSPRNG.
  /// `Random.secure()` reads from `/dev/urandom` on Android / `SecRandomCopyBytes` on iOS.
  static String generateSecureKey() {
    final secureRandom = Random.secure();
    final bytes = List<int>.generate(32, (_) => secureRandom.nextInt(256));
    return bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Lazily opens connection and applies page-level encryption key via SQLCipher PRAGMA
  static LazyDatabase getDatabaseConnection({
    FlutterSecureStorage? storage,
    Future<Directory> Function()? getDirectory,
  }) {
    final secureStore = storage ?? _defaultStorage;

    return LazyDatabase(() async {
      final dbFolder = getDirectory != null
          ? await getDirectory()
          : await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'fitkarma_secure.db'));

      // Retrieve or generate key
      String? key = await secureStore.read(key: keyName);
      if (key == null) {
        key = generateSecureKey();
        await secureStore.write(key: keyName, value: key);
      }

      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          // SQLCipher page-level key assignment
          rawDb.execute("PRAGMA key = '$key';");

          // Verify encryption by querying schema
          try {
            rawDb.execute("SELECT count(*) FROM sqlite_master;");
          } catch (e) {
            throw Exception("SQLCipher Database initialization failed or invalid password.");
          }
        },
      );
    });
  }
}
