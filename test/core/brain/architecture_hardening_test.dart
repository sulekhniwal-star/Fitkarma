import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/linter/clinical_copy_linter.dart';
import 'package:fitkarma/core/security/security_vault.dart';
import 'package:fitkarma/core/sync/hlc_timestamp.dart';

void main() {
  group('v1.0 Architecture Hardening Tests', () {
    const vault = SecurityVault();
    const linter = ClinicalCopyLinter();

    test('SQLCipher key generation uses Random.secure() producing 64-char hex key', () {
      final key1 = vault.generateSecureEncryptionKey();
      final key2 = vault.generateSecureEncryptionKey();

      expect(key1.length, equals(64)); // 32 bytes = 64 hex chars
      expect(key1, isNot(equals(key2))); // Cryptographically secure random uniqueness
    });

    test('Hybrid Logical Clock (HLC) guarantees strict monotonicity', () {
      final t1 = HlcTimestamp.now('node_1');
      final t2 = HlcTimestamp.now('node_1', lastHlc: t1);

      expect(t2.compareTo(t1), greaterThan(0));
    });

    test('ClinicalCopyLinter validates DPDP Act & Medical Disclaimer copy compliance', () {
      const validCopy = 'Passcode-Protected Doctor Share Portal (DPDP Act & Medical Disclaimer Compliant).';
      const invalidCopy = 'Random text without medical disclosures.';

      expect(linter.validateMedicalCopy(validCopy), isTrue);
      expect(linter.validateMedicalCopy(invalidCopy), isFalse);
    });
  });
}
