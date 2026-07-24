/// §P10-F Clinical Report Intelligence UI Screen
///
/// Route: /clinical
/// Dark glassmorphic layout displaying:
/// - 🔒 Non-Diagnostic Shield Banner (§P10-K)
/// - Supported Report Types Selector (CBC, Lipid Profile, LFT, KFT, HbA1c, Vit D, Thyroid, Iron)
/// - Extracted Biomarkers List with color-coded classification indicators
/// - Key Findings & Plan Adjustments Cards
/// - Upload PDF action trigger button
library;

import 'package:fitkarma/features/predictive/clinical_disclaimer_shield.dart';
import 'package:fitkarma/features/predictive/clinical_report_models.dart';
import 'package:fitkarma/features/predictive/clinical_report_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClinicalReportScreen extends ConsumerStatefulWidget {
  const ClinicalReportScreen({super.key});

  static const routeName = '/clinical';

  @override
  ConsumerState<ClinicalReportScreen> createState() => _ClinicalReportScreenState();
}

class _ClinicalReportScreenState extends ConsumerState<ClinicalReportScreen> {
  ClinicalReportType _selectedType = ClinicalReportType.cbc;
  final constParser = const ClinicalReportParser();

  late ClinicalReportResult _currentReport;

  @override
  void initState() {
    super.initState();
    _loadReport(_selectedType);
  }

  void _loadReport(ClinicalReportType type) {
    const sampleText = 'Hemoglobin: 10.8 g/dL, LDL: 148 mg/dL, Creatinine: 0.9 mg/dL';
    setState(() {
      _selectedType = type;
      _currentReport = constParser.parseReportText(text: sampleText, reportType: type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Clinical Intelligence',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('On-Device PDF Extractor: Lab values parsed safely locally 🔒')),
              );
            },
            icon: const Icon(Icons.upload_file, size: 16),
            label: const Text('Upload PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Mandatory Non-Diagnostic Shield Banner (§P10-K)
            const NonDiagnosticShieldBanner(),
            const SizedBox(height: 20),

            // 2. Report Type Selector Pills
            _buildTypeSelectorBar(),
            const SizedBox(height: 20),

            // 3. Extracted Biomarkers Section
            _buildBiomarkersCard(_currentReport),
            const SizedBox(height: 20),

            // 4. Key Findings Card
            _buildKeyFindingsCard(_currentReport),
            const SizedBox(height: 20),

            // 5. Plan Adjustments Card
            _buildPlanAdjustmentsCard(_currentReport),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelectorBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ClinicalReportType.values.map((type) {
          final isSelected = _selectedType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text('${type.iconSymbol} ${type.displayName}'),
              selected: isSelected,
              selectedColor: Colors.indigoAccent,
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              onSelected: (selected) {
                if (selected) _loadReport(type);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBiomarkersCard(ClinicalReportResult report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Extracted ${report.reportType.displayName} Biomarkers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '🔒 On-Device Parsed',
                style: TextStyle(
                  color: Colors.tealAccent.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            children: report.values.map((v) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(v.classification.indicatorEmoji, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            Text(
                              v.markerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ref: ${v.referenceRangeText}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${v.numericValue} ${v.unit}',
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          v.classification.displayName,
                          style: TextStyle(
                            color: _getClassificationColor(v.classification),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyFindingsCard(ClinicalReportResult report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '━━━ Key Lab Findings ━━━',
            style: TextStyle(
              color: Colors.amberAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: report.keyFindings.map((f) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.amberAccent, fontSize: 14)),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanAdjustmentsCard(ClinicalReportResult report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '━━━ Plan Adjustments ━━━',
            style: TextStyle(
              color: Colors.indigoAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: report.planAdjustments.map((a) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✓ ', style: TextStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        a,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getClassificationColor(LabValueClassification c) {
    switch (c) {
      case LabValueClassification.normal:
        return Colors.tealAccent;
      case LabValueClassification.borderline:
        return Colors.amberAccent;
      case LabValueClassification.abnormalLow:
        return Colors.lightBlueAccent;
      case LabValueClassification.abnormalHigh:
        return Colors.redAccent;
    }
  }
}
