import 'dart:math';

/// Cryptographically Secure Key Vault for SQLCipher Database Encryption
class SecurityVault {
  const SecurityVault();

  /// Generate a 256-bit (32-byte) hex key using Random.secure()
  String generateSecureEncryptionKey() {
    final secureRandom = Random.secure();
    final bytes = List<int>.generate(32, (i) => secureRandom.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
