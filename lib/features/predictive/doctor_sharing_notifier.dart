/// §P10-J Doctor Sharing Portal — Riverpod Notifier
///
/// Manages doctor-sharing state: active tokens, access log,
/// and exposes the §P10-K "Revoke All" action.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'clinical_sharing_models.dart';
import 'doctor_sharing_engine.dart';
import 'monthly_report_models.dart';
import 'monthly_report_notifier.dart' show monthlyReportProvider;

// ─── State ────────────────────────────────────────────────────────────────────

class DoctorSharingState {
  const DoctorSharingState({
    required this.tokens,
    required this.accessLog,
    this.lastReportContent,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  final List<SharingToken> tokens;
  final List<ShareAccessLogEntry> accessLog;
  final SharableReportContent? lastReportContent;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  List<SharingToken> get activeTokens =>
      tokens.where((t) => t.isActive).toList();

  DoctorSharingState copyWith({
    List<SharingToken>? tokens,
    List<ShareAccessLogEntry>? accessLog,
    SharableReportContent? lastReportContent,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) =>
      DoctorSharingState(
        tokens: tokens ?? this.tokens,
        accessLog: accessLog ?? this.accessLog,
        lastReportContent: lastReportContent ?? this.lastReportContent,
        isLoading: isLoading ?? this.isLoading,
        successMessage:
            clearMessages ? null : (successMessage ?? this.successMessage),
        errorMessage:
            clearMessages ? null : (errorMessage ?? this.errorMessage),
      );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class DoctorSharingNotifier extends Notifier<DoctorSharingState> {
  late final DoctorSharingEngine _engine;

  @override
  DoctorSharingState build() {
    _engine = DoctorSharingEngine();
    return const DoctorSharingState(tokens: [], accessLog: []);
  }

  // ── Token Management ─────────────────────────────────────────────────────

  /// Creates a passcode-protected PDF share token.
  SharingToken createPdfToken({String? recipientLabel}) {
    final token = _engine.createToken(
      mode: SharingMode.passcodeProtectedPdf,
      recipientLabel: recipientLabel,
    );
    _refreshState();
    return token;
  }

  /// Creates a FHIR-lite export token for ABHA integration (§P16-C).
  SharingToken createFhirToken({String? recipientLabel}) {
    final token = _engine.createToken(
      mode: SharingMode.fhirLiteExport,
      recipientLabel: recipientLabel,
    );
    _refreshState();
    return token;
  }

  /// Revokes a single token by ID.
  void revokeToken(String tokenId) {
    _engine.revokeToken(tokenId);
    _refreshState(
      success:
          'Access revoked for token …${tokenId.substring(tokenId.length - 4)}',
    );
  }

  /// §P10-K — Revoke ALL active clinical access tokens with single tap.
  void revokeAll() {
    final count = _engine.revokeAllClinicalAccess();
    _refreshState(
      success: count == 0
          ? 'No active shares to revoke.'
          : '$count clinical access grant${count == 1 ? '' : 's'} revoked.',
    );
  }

  // ── Report Content Builders ──────────────────────────────────────────────

  /// Builds share-text content from [payload] using a fresh PDF token.
  SharableReportContent buildPdfContent({
    required MonthlyReportPayload payload,
    String? recipientLabel,
  }) {
    final token = createPdfToken(recipientLabel: recipientLabel);
    final content = _engine.buildPdfContent(report: payload, token: token);
    state = state.copyWith(lastReportContent: content);
    return content;
  }

  /// Builds a FHIR-lite payload from [payload] for ABHA-compatible export.
  FhirLitePayload buildFhirPayload({
    required MonthlyReportPayload payload,
    required String patientId,
  }) {
    createFhirToken();
    return _engine.buildFhirLitePayload(report: payload, patientId: patientId);
  }

  /// §P10-K — Builds anonymized cohort sync payload (no PII).
  Map<String, dynamic> buildCohortPayload({
    required MonthlyReportPayload payload,
    required String cohortSegment,
  }) =>
      _engine.buildAnonymizedCohortPayload(
        report: payload,
        cohortSegment: cohortSegment,
      );

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _refreshState({String? success}) {
    state = state.copyWith(
      tokens: List<SharingToken>.from(_engine.allTokens),
      accessLog: List<ShareAccessLogEntry>.from(_engine.accessLog),
      successMessage: success,
    );
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final doctorSharingNotifierProvider =
    NotifierProvider<DoctorSharingNotifier, DoctorSharingState>(
  DoctorSharingNotifier.new,
);

/// Convenience provider — expose latest monthly report from §P10-C notifier.
final latestMonthlyReportProvider = Provider<MonthlyReportPayload?>((ref) {
  return ref.watch(monthlyReportProvider);
});
