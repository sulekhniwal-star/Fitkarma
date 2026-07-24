import 'package:fitkarma/features/predictive/clinical_disclaimer_shield.dart';
import 'package:fitkarma/features/predictive/clinical_report_models.dart';
import 'package:fitkarma/features/predictive/clinical_report_parser.dart';
import 'package:fitkarma/features/predictive/clinical_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = ClinicalReportParser();

  group('§P10-F ClinicalReportParser Unit Tests', () {
    test('Parses CBC report text and extracts Hemoglobin value correctly', () {
      const cbcText = 'Complete Blood Count Report: Hemoglobin = 10.8 g/dL, RBC 4.2';
      final result = parser.parseReportText(
        text: cbcText,
        reportType: ClinicalReportType.cbc,
      );

      expect(result.reportType, ClinicalReportType.cbc);
      expect(result.values.length, 1);

      final hb = result.values.first;
      expect(hb.markerName, 'Hemoglobin');
      expect(hb.numericValue, 10.8);
      expect(hb.classification, LabValueClassification.abnormalLow);
      expect(result.keyFindings.first, contains('Hemoglobin: 10.8 g/dL'));
    });

    test('Parses Lipid Profile text and extracts LDL & HDL values correctly', () {
      const lipidText = 'Lipid Profile: LDL-C: 148.0 mg/dL, HDL: 52.0 mg/dL';
      final result = parser.parseReportText(
        text: lipidText,
        reportType: ClinicalReportType.lipidProfile,
      );

      expect(result.reportType, ClinicalReportType.lipidProfile);
      expect(result.values.length, 2);

      final ldl = result.values.firstWhere((v) => v.markerName == 'LDL Cholesterol');
      expect(ldl.numericValue, 148.0);
      expect(ldl.classification, LabValueClassification.borderline);
    });

    test('Synthesizes workout intensity reduction & iron-rich food plan adjustments for low Hb', () {
      const cbcText = 'Hemoglobin: 10.5 g/dL';
      final result = parser.parseReportText(
        text: cbcText,
        reportType: ClinicalReportType.cbc,
      );

      expect(result.planAdjustments, contains(contains('Workout intensity: Reduced by 15%')));
      expect(result.planAdjustments, contains(contains('iron-rich foods')));
    });

    test('Validates protein intake safety when KFT creatinine is normal', () {
      const kftText = 'Serum Creatinine: 0.9 mg/dL';
      final result = parser.parseReportText(
        text: kftText,
        reportType: ClinicalReportType.kft,
      );

      expect(result.planAdjustments, contains(contains('Protein Intake: Target is safe')));
    });
  });

  group('§P10-F & §P10-K ClinicalReportScreen Widget Tests', () {
    testWidgets('Renders Non-Diagnostic Shield disclaimer, report tabs, biomarkers, and plan adjustments', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ClinicalReportScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. App Bar & Upload Button
      expect(find.text('Clinical Intelligence'), findsOneWidget);
      expect(find.text('Upload PDF'), findsOneWidget);

      // 2. Non-Diagnostic Shield Banner (§P10-K requirement)
      expect(find.byType(NonDiagnosticShieldBanner), findsOneWidget);
      expect(find.textContaining('Non-Diagnostic Health Insights Disclaimer'), findsOneWidget);

      // 3. Biomarkers Card
      expect(find.textContaining('Extracted CBC (Complete Blood Count) Biomarkers'), findsOneWidget);
      expect(find.text('Hemoglobin'), findsOneWidget);

      // 4. Key Findings & Plan Adjustments Cards
      expect(find.text('━━━ Key Lab Findings ━━━'), findsOneWidget);
      expect(find.text('━━━ Plan Adjustments ━━━'), findsOneWidget);
    });
  });
}
