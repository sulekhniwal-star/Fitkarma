import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/security/encrypted_database_connection.dart';
import 'package:fitkarma/core/security/security_vault.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('§P14-A SQLCipher Secure Database Initialization Tests', () {
    test('Random.secure() generates 256-bit (64 hex characters) encryption keys', () {
      final key = EncryptedDatabaseConnection.generateSecureKey();

      // 32 bytes = 256 bits = 64 hex characters
      expect(key.length, equals(64));
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(key), isTrue);
    });

    test('SecurityVault and EncryptedDatabaseConnection produce high-entropy non-repeating keys', () {
      final keys = <String>{};
      const vault = SecurityVault();

      for (int i = 0; i < 100; i++) {
        final key1 = EncryptedDatabaseConnection.generateSecureKey();
        final key2 = vault.generateSecureEncryptionKey();

        expect(keys.contains(key1), isFalse);
        keys.add(key1);

        expect(keys.contains(key2), isFalse);
        keys.add(key2);
      }

      expect(keys.length, equals(200));
    });

    test('EncryptedDatabaseConnection.getDatabaseConnection creates LazyDatabase without error', () {
      final db = EncryptedDatabaseConnection.getDatabaseConnection(
        getDirectory: () async => Directory.systemTemp,
      );

      expect(db, isNotNull);
    });
  });
}
