/// §P14-A Security Hardening — Unit & Security Verification Tests

import 'package:fitkarma/core/security/security_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('§P14-A 🔒 SQLCipher CSPRNG Key Generation Tests', () {
    test('generateSecureKey creates 256-bit (64 hex char) entropy passkey via Random.secure()', () {
      final key = SqlCipherSecurity.generateSecureKey();

      expect(key, isNotEmpty);
      expect(key.length, equals(64)); // 32 bytes * 2 hex chars = 64 hex chars
      expect(RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(key), isTrue);
    });

    test('generateSecureKey produces distinct high-entropy keys across calls', () {
      final key1 = SqlCipherSecurity.generateSecureKey();
      final key2 = SqlCipherSecurity.generateSecureKey();

      expect(key1, isNot(equals(key2)));
    });
  });

  group('§P14-A Network TLS 1.3 & Certificate Pinning Tests', () {
    test('enforces TLS 1.3 compliance check', () {
      expect(TlsSecurityService.isTls13Compliant('TLSv1.3'), isTrue);
      expect(TlsSecurityService.isTls13Compliant('TLSv1.2'), isFalse);
    });

    test('verifies pinned SSL certificate fingerprints for Azure, Groq & RevenueCat', () {
      const azureHost = 'fitkarma-api.azurewebsites.net';
      final validFingerprint = TlsSecurityService.pinnedFingerprints[azureHost]!;

      expect(TlsSecurityService.verifyCertificatePin(azureHost, validFingerprint), isTrue);
      expect(TlsSecurityService.verifyCertificatePin(azureHost, 'INVALID_FINGERPRINT'), isFalse);
    });
  });

  group('§P14-A Azure Function Log Context Sanitization Tests', () {
    test('sanitizes Azure log payload so logs never contain raw user PII context', () {
      final rawLog = {
        'user_id': 'usr_998877',
        'name': 'Rahul Sharma',
        'email': 'rahul@example.com',
        'abhaId': '14-8899-1234-5678',
        'cgm_data': [110, 115, 120],
        'chat_message': 'My knee hurts in severe pain',
        'prompt': 'Suggest workout for knee pain',
        'status_code': 200,
      };

      final cleanLog = AzureLogSanitizer.sanitizeLogPayload(rawLog);

      expect(cleanLog['user_id'], contains('[ANONYMOUS_HASH_'));
      expect(cleanLog['name'], equals('[REDACTED_CONTEXT]'));
      expect(cleanLog['email'], equals('[REDACTED_CONTEXT]'));
      expect(cleanLog['abhaId'], equals('[REDACTED_CONTEXT]'));
      expect(cleanLog['cgm_data'], equals('[REDACTED_CONTEXT]'));
      expect(cleanLog['chat_message'], equals('[REDACTED_CONTEXT]'));
      expect(cleanLog['prompt'], equals('[REDACTED_CONTEXT]'));
      expect(cleanLog['status_code'], equals(200)); // Non-PII telemetry preserved
    });
  });

  group('§P14-A Sentry PII Stripping Tests', () {
    test('strips email addresses and phone numbers from error report messages', () {
      const rawMessage = 'Error sending email to user.rahul@domain.com or phone +919876543210 during sync.';
      final cleanMessage = SentryPiiSanitizer.sanitizeErrorMessage(rawMessage);

      expect(cleanMessage, contains('[REDACTED_EMAIL]'));
      expect(cleanMessage, contains('[REDACTED_PHONE]'));
      expect(cleanMessage, isNot(contains('user.rahul@domain.com')));
      expect(cleanMessage, isNot(contains('+919876543210')));
    });

    test('sanitizes Sentry user context metadata', () {
      final rawUser = {'id': 'user_123', 'email': 'sharma@test.com'};
      final cleanUser = SentryPiiSanitizer.sanitizeUserContext(rawUser);

      expect(cleanUser['id'], equals('[ANONYMOUS_CLIENT_ID]'));
      expect(cleanUser['is_authenticated'], isTrue);
      expect(cleanUser.containsKey('email'), isFalse);
    });
  });

  group('§P14-A 🔒 AI Cache User-Scoped Prompt Hash Security Tests', () {
    test('generates user-scoped SHA-256 prompt hash cache key without plain-text PII', () {
      const userId = 'usr_sharma_1001';
      const prompt = 'Patient exhibits 140 mg/dL glucose spike after eating 2 gulab jamuns';

      final cacheKey = AiCacheManager.generateCacheKey(
        userId: userId,
        promptPayload: prompt,
      );

      expect(cacheKey, startsWith('ai_cache:'));
      expect(cacheKey, isNot(contains(userId))); // User ID is salted and hashed!
      expect(cacheKey, isNot(contains('glucose'))); // No prompt plain text!
      expect(cacheKey, isNot(contains('jamuns')));

      expect(AiCacheManager.verifyCacheKeySecurity(cacheKey, prompt), isTrue);
    });
  });
}
