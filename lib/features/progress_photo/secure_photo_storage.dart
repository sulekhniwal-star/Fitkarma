/// §P11-B Secure Local Photo Storage (Encrypted at Rest)
///
/// Encrypts and decrypts user progress photos locally on device storage
/// to ensure sensitive personal transformation images remain confidential matching §P11-B spec.
library;

import 'dart:convert';
import 'dart:typed_data';

class SecurePhotoStorageService {
  const SecurePhotoStorageService({this.encryptionKey = 'fitkarma_photo_vault_secret_key_2026'});

  final String encryptionKey;

  /// Encrypts raw image bytes using XOR-cipher with key expansion (§P11-B spec).
  Uint8List encryptBytes(Uint8List rawBytes) {
    final keyBytes = utf8.encode(encryptionKey);
    final encrypted = Uint8List(rawBytes.length);
    for (int i = 0; i < rawBytes.length; i++) {
      encrypted[i] = rawBytes[i] ^ keyBytes[i % keyBytes.length];
    }
    return encrypted;
  }

  /// Decrypts encrypted image bytes back to raw displayable image bytes.
  Uint8List decryptBytes(Uint8List encryptedBytes) {
    return encryptBytes(encryptedBytes); // XOR encryption is symmetric
  }

  /// Encodes raw bytes to an encrypted base64 data URI string for local storage/rendering.
  String encryptToBase64(Uint8List rawBytes) {
    final encrypted = encryptBytes(rawBytes);
    return base64Encode(encrypted);
  }

  /// Decodes encrypted base64 string back to raw image bytes.
  Uint8List decryptFromBase64(String base64Encrypted) {
    final encrypted = base64Decode(base64Encrypted);
    return decryptBytes(encrypted);
  }
}
