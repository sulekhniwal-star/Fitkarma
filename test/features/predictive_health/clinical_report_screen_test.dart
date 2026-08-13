import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/brain/clinical_report_parser.dart';
import 'package:fitkarma/features/predictive_health/screens/clinical_report_screen.dart';

void main() {
  group('§P10-F Clinical Report Intelligence Tests', () {
    const parser = ClinicalReportParser();

    test('identifyReportType identifies CBC and Lipid Profile reports from raw text', () {
      expect(parser.identifyReportType('Patient Hemoglobin count: 12.5 g/dL'), equals(LabReportType.cbc));
      expect(parser.identifyReportType('Lipid Panel: Total Cholesterol 210 mg/dL, LDL 148 mg/dL'), equals(LabReportType.lipidProfile));
      expect(parser.identifyReportType('Liver Function ALT 45 U/L'), equals(LabReportType.lft));
      expect(parser.identifyReportType('Serum Creatinine 1.1 mg/dL'), equals(LabReportType.kft));
    });

    test('parseText extracts low Hemoglobin and generates mild anemia clinical insight', () async {
      const sampleText = 'Complete Blood Count: Hemoglobin 10.8 g/dL.';
      final result = await parser.parseText(sampleText);

      expect(result.reportType, equals(LabReportType.cbc));
      expect(result.values.first.name, equals('Hemoglobin'));
      expect(result.values.first.status, equals(BiomarkerStatus.low));
      expect(result.insights.first.title, contains('Mild Anemia Detected'));
      expect(result.isProcessedOnDeviceOnly, isTrue);
    });

    // ── Widget Tests ────────────────────────────────────────────────────────

    testWidgets('ClinicalReportScreen renders Privacy Shield banner, Key Findings, and Insights', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ClinicalReportScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Lab Report Intelligence'), findsOneWidget);
      expect(find.textContaining('On-Device Privacy Guaranteed'), findsOneWidget);
      expect(find.text('Lab Report Uploaded: CBC + Lipid Profile'), findsOneWidget);
      expect(find.text('Hemoglobin'), findsOneWidget);
      expect(find.text('LDL Cholesterol'), findsOneWidget);
      expect(find.textContaining('Mild Anemia Detected'), findsOneWidget);
    });
  });
}
