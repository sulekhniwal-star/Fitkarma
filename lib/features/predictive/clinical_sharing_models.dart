/// §P10-J Doctor Sharing Portal — Data Models
///
/// Defines the data structures for passcode-protected PDF sharing tokens,
/// FHIR-lite export payloads, and access-log entries used by the Doctor
/// Sharing Portal.  All exported reports carry a mandatory non-diagnostic
/// disclaimer footer (§P10-K).
library;

import 'dart:math';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum SharingMode {
  /// Default: passcode-locked PDF sent directly (no server link).
  passcodeProtectedPdf,

  /// FHIR-lite JSON export for ABHA-compatible integrations (§P16-C).
  fhirLiteExport,
}

enum ShareStatus {
  active,
  revoked,
  expired,
}

// ─── Sharing Token ────────────────────────────────────────────────────────────

/// Represents a single doctor-sharing grant.  Each grant has a unique token,
/// an optional expiry, and records the mode used.
class SharingToken {
  const SharingToken({
    required this.tokenId,
    required this.passcode,
    required this.createdAt,
    required this.mode,
    this.expiresAt,
    this.recipientLabel,
    this.status = ShareStatus.active,
  });

  factory SharingToken.create({
    required SharingMode mode,
    String? recipientLabel,
    Duration validity = const Duration(days: 7),
  }) {
    final now = DateTime.now();
    return SharingToken(
      tokenId: _generateTokenId(),
      passcode: _generatePasscode(),
      createdAt: now,
      expiresAt: now.add(validity),
      mode: mode,
      recipientLabel: recipientLabel,
    );
  }

  final String tokenId;
  final String passcode;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final SharingMode mode;
  final String? recipientLabel;
  final ShareStatus status;

  bool get isActive =>
      status == ShareStatus.active &&
      (expiresAt == null || DateTime.now().isBefore(expiresAt!));

  SharingToken revoke() => SharingToken(
        tokenId: tokenId,
        passcode: passcode,
        createdAt: createdAt,
        expiresAt: expiresAt,
        mode: mode,
        recipientLabel: recipientLabel,
        status: ShareStatus.revoked,
      );

  SharingToken copyWith({ShareStatus? status}) => SharingToken(
        tokenId: tokenId,
        passcode: passcode,
        createdAt: createdAt,
        expiresAt: expiresAt,
        mode: mode,
        recipientLabel: recipientLabel,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'tokenId': tokenId,
        'passcode': passcode,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'mode': mode.name,
        'recipientLabel': recipientLabel,
        'status': status.name,
      };

  factory SharingToken.fromJson(Map<String, dynamic> json) => SharingToken(
        tokenId: json['tokenId'] as String,
        passcode: json['passcode'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
        mode: SharingMode.values.byName(json['mode'] as String),
        recipientLabel: json['recipientLabel'] as String?,
        status: ShareStatus.values.byName(json['status'] as String),
      );

  // ── Helpers ──────────────────────────────────────────────────────────────

  static String _generateTokenId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(16, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  static String _generatePasscode() {
    final rng = Random.secure();
    return List.generate(6, (_) => rng.nextInt(10).toString()).join();
  }
}

// ─── Access Log Entry ─────────────────────────────────────────────────────────

/// Immutable record of each share/revoke event for audit purposes.
class ShareAccessLogEntry {
  const ShareAccessLogEntry({
    required this.tokenId,
    required this.event,
    required this.timestamp,
    this.note,
  });

  final String tokenId;
  final String event; // 'created' | 'revoked' | 'expired' | 'viewed'
  final DateTime timestamp;
  final String? note;

  Map<String, dynamic> toJson() => {
        'tokenId': tokenId,
        'event': event,
        'timestamp': timestamp.toIso8601String(),
        'note': note,
      };
}

// ─── FHIR-lite Payload (§P16-C) ──────────────────────────────────────────────

/// Lightweight FHIR-compatible export for ABHA / health-locker integration.
/// Contains only the data the user explicitly chooses to include.
class FhirLitePayload {
  const FhirLitePayload({
    required this.patientId,
    required this.generatedAt,
    required this.resourceType,
    required this.entries,
    required this.disclaimerFooter,
  });

  /// Always 'Bundle' per FHIR R4 spec.
  final String resourceType;
  final String patientId;
  final DateTime generatedAt;
  final List<Map<String, dynamic>> entries;

  /// §P10-K mandatory disclaimer, embedded in the FHIR narrative text.
  final String disclaimerFooter;

  static const kDisclaimerFooter =
      'This document is generated by FitKarma for informational wellness '
      'purposes only. It does not constitute a medical diagnosis or clinical '
      'report. Consult a qualified healthcare professional for medical advice. '
      '(§P10-K Non-Diagnostic Shield)';

  factory FhirLitePayload.create({
    required String patientId,
    required List<Map<String, dynamic>> entries,
  }) =>
      FhirLitePayload(
        patientId: patientId,
        generatedAt: DateTime.now(),
        resourceType: 'Bundle',
        entries: entries,
        disclaimerFooter: kDisclaimerFooter,
      );

  Map<String, dynamic> toJson() => {
        'resourceType': resourceType,
        'id': patientId,
        'timestamp': generatedAt.toIso8601String(),
        'meta': {
          'tag': [
            {'system': 'fitkarma', 'code': 'wellness-export'},
          ],
        },
        'entry': entries,
        '_disclaimer': disclaimerFooter,
      };
}
