import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityAuditService {
  const SecurityAuditService();

  /// Scrubs PII from Sentry/analytics log payloads before transmission
  Map<String, dynamic> sanitizeLogPayload(Map<String, dynamic> rawPayload) {
    final sanitized = Map<String, dynamic>.from(rawPayload);

    final piiKeys = {
      'name',
      'email',
      'phone',
      'phonenumber',
      'abhaid',
      'accesspin',
      'pin',
      'password',
      'token',
      'jwt',
      'authheader',
    };

    for (final key in sanitized.keys.toList()) {
      final keyLower = key.toLowerCase();
      if (piiKeys.contains(keyLower)) {
        sanitized[key] = '[REDACTED_PII]';
      } else if (sanitized[key] is Map<String, dynamic>) {
        sanitized[key] = sanitizeLogPayload(sanitized[key] as Map<String, dynamic>);
      } else if (sanitized[key] is String) {
        var val = sanitized[key] as String;
        // Scrub 10-digit Indian phone numbers
        val = val.replaceAll(RegExp(r'(\+91[\-\s]?)?[6789]\d{9}'), '[REDACTED_PHONE]');
        // Scrub 14-digit ABHA numbers (XX-XXXX-XXXX-XXXX)
        val = val.replaceAll(RegExp(r'\d{2}-\d{4}-\d{4}-\d{4}'), '[REDACTED_ABHA]');
        sanitized[key] = val;
      }
    }

    return sanitized;
  }

  /// Hashes identifier with SHA-256 for anonymized analytics cohorts
  String anonymizeIdentifier(String identifier, {String salt = 'fitkarma_cohort_salt'}) {
    final bytes = utf8.encode('$identifier:$salt');
    return sha256.convert(bytes).toString();
  }

  /// Verifies whether a token format conforms to standard Supabase JWT format
  bool isValidJwtFormat(String? token) {
    if (token == null || token.isEmpty) return false;
    final parts = token.split('.');
    return parts.length == 3;
  }
}
