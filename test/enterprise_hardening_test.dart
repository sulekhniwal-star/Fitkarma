import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/security/security_audit_service.dart';
import 'package:fitkarma/core/performance/performance_monitor.dart';

void main() {
  group('Enterprise Hardening - SecurityAuditService Tests', () {
    const service = SecurityAuditService();

    test('Sanitizes PII keys (phone, email, password, pin) from log payload', () {
      final rawLog = {
        'event': 'user_login',
        'email': 'rahul.sharma@example.com',
        'phone': '+919876543210',
        'accessPin': '9841',
        'metadata': {
          'jwt': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          'device': 'Pixel 8',
        },
      };

      final sanitized = service.sanitizeLogPayload(rawLog);
      expect(sanitized['email'], equals('[REDACTED_PII]'));
      expect(sanitized['phone'], equals('[REDACTED_PII]'));
      expect(sanitized['accessPin'], equals('[REDACTED_PII]'));
      expect((sanitized['metadata'] as Map)['jwt'], equals('[REDACTED_PII]'));
      expect((sanitized['metadata'] as Map)['device'], equals('Pixel 8'));
    });

    test('Sanitizes embedded Indian phone numbers and ABHA IDs inside strings', () {
      final rawLog = {
        'message': 'Failed verification for phone 9876543210 and ABHA 12-3456-7890-1234',
        'status': 'error',
      };

      final sanitized = service.sanitizeLogPayload(rawLog);
      expect(sanitized['message'], contains('[REDACTED_PHONE]'));
    });

    test('Anonymizes user ID deterministically with SHA-256 hash', () {
      final hash1 = service.anonymizeIdentifier('user_123');
      final hash2 = service.anonymizeIdentifier('user_123');
      final hash3 = service.anonymizeIdentifier('user_456');

      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(hash3)));
      expect(hash1.length, equals(64));
    });

    test('Validates JWT structure', () {
      expect(service.isValidJwtFormat('header.payload.signature'), isTrue);
      expect(service.isValidJwtFormat('invalid-token'), isFalse);
      expect(service.isValidJwtFormat(null), isFalse);
    });
  });

  group('Enterprise Hardening - PerformanceMonitor Tests', () {
    test('Tracks trace duration and evaluates budget thresholds', () async {
      final monitor = PerformanceMonitor();

      monitor.startTrace('db_query_readiness');
      await Future.delayed(const Duration(milliseconds: 10));
      final metric = monitor.stopTrace('db_query_readiness');

      expect(metric, isNotNull);
      expect(metric!.traceName, equals('db_query_readiness'));
      expect(metric.durationMs, greaterThanOrEqualTo(5));
      expect(metric.isWithinBudget, isTrue);
    });

    test('Calculates average query latency across multiple db traces', () async {
      final monitor = PerformanceMonitor();

      monitor.startTrace('db_fetch_meals');
      await Future.delayed(const Duration(milliseconds: 10));
      monitor.stopTrace('db_fetch_meals');

      monitor.startTrace('db_fetch_workouts');
      await Future.delayed(const Duration(milliseconds: 10));
      monitor.stopTrace('db_fetch_workouts');

      final avg = monitor.getAverageQueryLatencyMs();
      expect(avg, greaterThan(0));
      expect(monitor.isPerformanceHealthy(), isTrue);
    });
  });
}
