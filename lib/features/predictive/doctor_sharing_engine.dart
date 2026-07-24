/// §P10-J Doctor Sharing Portal — Sharing Engine
///
/// Core logic layer responsible for:
///   • Creating and revoking passcode-protected sharing tokens
///   • Building plain-text report content for PDF/share-sheet (passcode mode)
///   • Generating FHIR-lite JSON payloads (§P16-C ABHA mode)
///   • "Revoke All Clinical Access" single-tap operation (§P10-K)
///   • Routing anonymized cohort-sync data through privacy-safe channels (§P10-K)
///   • Maintaining an in-memory access-log for the session
library;

import 'clinical_sharing_models.dart';
import 'monthly_report_models.dart';
import 'clinical_copy_linter.dart';

class DoctorSharingEngine {
  DoctorSharingEngine({ClinicalCopyLinter? linter})
      : _linter = linter ?? const ClinicalCopyLinter();

  final ClinicalCopyLinter _linter;

  // ─── Token Store (in-memory; persisted via Notifier / Hive in real app) ──

  final List<SharingToken> _tokens = [];
  final List<ShareAccessLogEntry> _accessLog = [];

  // ─── Token Management ─────────────────────────────────────────────────────

  /// Creates a new sharing token for the given [mode].
  SharingToken createToken({
    required SharingMode mode,
    String? recipientLabel,
    Duration validity = const Duration(days: 7),
  }) {
    final token = SharingToken.create(
      mode: mode,
      recipientLabel: recipientLabel,
      validity: validity,
    );
    _tokens.add(token);
    _log(token.tokenId, 'created', 'mode: ${mode.name}');
    return token;
  }

  /// Revokes a specific token by ID.
  bool revokeToken(String tokenId) {
    final idx = _tokens.indexWhere((t) => t.tokenId == tokenId);
    if (idx == -1) return false;
    _tokens[idx] = _tokens[idx].revoke();
    _log(tokenId, 'revoked');
    return true;
  }

  /// §P10-K — "Revoke All Clinical Access" single-tap operation.
  /// Revokes every active token regardless of mode.
  int revokeAllClinicalAccess() {
    int count = 0;
    for (int i = 0; i < _tokens.length; i++) {
      if (_tokens[i].isActive) {
        _tokens[i] = _tokens[i].revoke();
        _log(_tokens[i].tokenId, 'revoked', 'batch: revokeAll');
        count++;
      }
    }
    return count;
  }

  /// All tokens (active, revoked, expired).
  List<SharingToken> get allTokens => List.unmodifiable(_tokens);

  /// Only currently active (non-revoked, non-expired) tokens.
  List<SharingToken> get activeTokens =>
      _tokens.where((t) => t.isActive).toList();

  // ─── PDF / Share-Sheet Content (Passcode Mode) ────────────────────────────

  /// Builds the human-readable text content for a passcode-protected report.
  /// All strings are linted through [ClinicalCopyLinter] (§P10-M / §P10-K).
  SharableReportContent buildPdfContent({
    required MonthlyReportPayload report,
    required SharingToken token,
  }) {
    assert(
      token.mode == SharingMode.passcodeProtectedPdf,
      'buildPdfContent requires a passcode-protected token',
    );

    final headline = _linter.lintAndSanitize(
      'Monthly Wellness Summary — ${report.reportMonthPeriod}',
    );

    final riskLines = report.detectedRisks.isEmpty
        ? 'No wellness flags this period.'
        : report.detectedRisks
            .map((r) => _linter.lintAndSanitize(
                  '• [${r.severity.displayName}] ${r.riskCategory.displayName}: '
                  '${r.triggerDescription}',
                ))
            .join('\n');

    final strategyLines = report.focusStrategyItems
        .map((s) => _linter.lintAndSanitize('• $s'))
        .join('\n');

    final sections = <String, String>{
      'Biomarker Averages': _linter.lintAndSanitize(
        'HRV Avg: ${report.hrvAvgMs.toStringAsFixed(1)} ms  |  '
        'HRV Trend: +${report.hrvTrendPercent.toStringAsFixed(1)}%  |  '
        'BP: ${report.systolicBpAvg.round()}/${report.diastolicBpAvg.round()} mmHg  |  '
        'Fasting Glucose: ${report.fastingGlucoseAvg.round()} mg/dL',
      ),
      'Biological Age': _linter.lintAndSanitize(
        'Chronological: ${report.biologicalAgeResult.chronologicalAge} yrs  |  '
        'Estimated Wellness Age: ${report.biologicalAgeResult.estimatedBiologicalAge} yrs  |  '
        'Delta: ${report.biologicalAgeResult.ageDeltaYears} yrs  |  '
        'Drivers: ${report.biologicalAgeResult.primaryDrivers.join(", ")}',
      ),
      'Wellness Flags': riskLines,
      'Focus Strategy': strategyLines,
      'Disclaimer': FhirLitePayload.kDisclaimerFooter,
    };

    return SharableReportContent(
      token: token,
      headline: headline,
      sections: sections,
      generatedAt: DateTime.now(),
    );
  }

  // ─── FHIR-lite Export (§P16-C ABHA Mode) ─────────────────────────────────

  /// Builds a FHIR-lite R4 Bundle from a [MonthlyReportPayload].
  FhirLitePayload buildFhirLitePayload({
    required MonthlyReportPayload report,
    required String patientId,
  }) {
    final entries = <Map<String, dynamic>>[
      _obs('hrv-avg', '80404000', 'Heart rate variability',
          report.hrvAvgMs, 'ms'),
      _obs('systolic-bp', '271649006', 'Systolic blood pressure',
          report.systolicBpAvg, 'mmHg'),
      _obs('diastolic-bp', '271650006', 'Diastolic blood pressure',
          report.diastolicBpAvg, 'mmHg'),
      _obs('fasting-glucose', '271062006', 'Fasting plasma glucose',
          report.fastingGlucoseAvg, 'mg/dL'),
      {
        'resource': {
          'resourceType': 'Condition',
          'id': 'wellness-flags',
          'note': report.detectedRisks
              .map((r) => {
                    'text': _linter.lintAndSanitize(
                      '${r.riskCategory.displayName}: ${r.triggerDescription}',
                    ),
                  })
              .toList(),
        },
      },
      {
        'resource': {
          'resourceType': 'CarePlan',
          'id': 'focus-strategy',
          'activity': report.focusStrategyItems
              .map((s) => {
                    'detail': {
                      'description': _linter.lintAndSanitize(s),
                    },
                  })
              .toList(),
        },
      },
    ];

    return FhirLitePayload.create(patientId: patientId, entries: entries);
  }

  // ─── §P10-K Anonymized Cohort Sync Routing ────────────────────────────────

  /// Returns an anonymized cohort-sync payload.
  /// PII is stripped — only aggregated wellness statistics are included.
  Map<String, dynamic> buildAnonymizedCohortPayload({
    required MonthlyReportPayload report,
    required String cohortSegment, // e.g. 'india-30-45-m'
  }) {
    return {
      'cohort': cohortSegment,
      'period': report.reportMonthPeriod,
      'hrvAvgMs': report.hrvAvgMs.roundToDouble(),
      'systolicBpAvg': report.systolicBpAvg.roundToDouble(),
      'fastingGlucoseAvg': report.fastingGlucoseAvg.roundToDouble(),
      'riskFlagCount': report.detectedRisks.length,
      // No patientId, name, DOB, or raw measurements — §P10-K compliance.
      '_privacyLevel': 'anonymous-aggregate',
    };
  }

  // ─── Access Log ───────────────────────────────────────────────────────────

  List<ShareAccessLogEntry> get accessLog => List.unmodifiable(_accessLog);

  void _log(String tokenId, String event, [String? note]) {
    _accessLog.add(ShareAccessLogEntry(
      tokenId: tokenId,
      event: event,
      timestamp: DateTime.now(),
      note: note,
    ));
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

  Map<String, dynamic> _obs(
    String id,
    String code,
    String display,
    double value,
    String unit,
  ) =>
      {
        'resource': {
          'resourceType': 'Observation',
          'id': id,
          'status': 'final',
          'code': {
            'coding': [
              {
                'system': 'http://snomed.info/sct',
                'code': code,
                'display': display,
              },
            ],
          },
          'valueQuantity': {
            'value': value,
            'unit': unit,
          },
        },
      };
}

// ─── Sharable Report Content ──────────────────────────────────────────────────

/// Structured content ready for PDF rendering or share-sheet text output.
class SharableReportContent {
  const SharableReportContent({
    required this.token,
    required this.headline,
    required this.sections,
    required this.generatedAt,
  });

  final SharingToken token;
  final String headline;

  /// Ordered section title → body text.
  final Map<String, String> sections;
  final DateTime generatedAt;

  /// Plain-text form suitable for share-sheet / clipboard copy.
  String toPlainText() {
    final buf = StringBuffer()
      ..writeln('══════════════════════════════════')
      ..writeln(headline)
      ..writeln('══════════════════════════════════')
      ..writeln('🔑 Access Passcode : ${token.passcode}')
      ..writeln(
        'Valid until        : ${token.expiresAt?.toLocal().toString().substring(0, 16) ?? '—'}',
      )
      ..writeln();

    for (final entry in sections.entries) {
      buf
        ..writeln('── ${entry.key} ──')
        ..writeln(entry.value)
        ..writeln();
    }
    return buf.toString();
  }
}
