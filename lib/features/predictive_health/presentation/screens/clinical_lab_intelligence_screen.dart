import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../domain/models/predictive_health_models.dart';
import '../../domain/services/clinical_lab_intelligence_engine.dart';

class ClinicalLabIntelligenceScreen extends StatefulWidget {
  final String userId;

  const ClinicalLabIntelligenceScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ClinicalLabIntelligenceScreen> createState() =>
      _ClinicalLabIntelligenceScreenState();
}

class _ClinicalLabIntelligenceScreenState
    extends State<ClinicalLabIntelligenceScreen> {
  final _labEngine = const ClinicalLabIntelligenceEngine();
  late ClinicalLabReport _report;

  @override
  void initState() {
    super.initState();
    final results = [
      _labEngine.evaluateBiomarker(
        markerKey: 'hba1c',
        name: 'HbA1c (Glycated Hemoglobin)',
        nameHindi: 'ग्लाइकेटेड हीमोग्लोबिन',
        value: 5.4,
        unit: '%',
        referenceMin: 4.0,
        referenceMax: 5.6,
      ),
      _labEngine.evaluateBiomarker(
        markerKey: 'fasting_glucose',
        name: 'Fasting Plasma Glucose',
        nameHindi: 'फास्टिंग ब्लड शुगर',
        value: 92.0,
        unit: 'mg/dL',
        referenceMin: 70.0,
        referenceMax: 99.0,
      ),
      _labEngine.evaluateBiomarker(
        markerKey: 'total_cholesterol',
        name: 'Total Cholesterol',
        nameHindi: 'कुल कोलेस्ट्रॉल',
        value: 178.0,
        unit: 'mg/dL',
        referenceMin: 125.0,
        referenceMax: 200.0,
      ),
      _labEngine.evaluateBiomarker(
        markerKey: 'ldl_cholesterol',
        name: 'LDL (Atherogenic Lipoprotein)',
        nameHindi: 'एलडीएल खराब कोलेस्ट्रॉल',
        value: 96.0,
        unit: 'mg/dL',
        referenceMin: 50.0,
        referenceMax: 100.0,
      ),
      _labEngine.evaluateBiomarker(
        markerKey: 'vitamin_d3',
        name: '25-Hydroxy Vitamin D3',
        nameHindi: 'विटामिन डी३',
        value: 36.5,
        unit: 'ng/mL',
        referenceMin: 30.0,
        referenceMax: 100.0,
      ),
      _labEngine.evaluateBiomarker(
        markerKey: 'vitamin_b12',
        name: 'Serum Vitamin B12',
        nameHindi: 'विटामिन बी१२',
        value: 410.0,
        unit: 'pg/mL',
        referenceMin: 211.0,
        referenceMax: 911.0,
      ),
    ];

    _report = _labEngine.analyzeLabReport(
      id: 'rep-1',
      userId: widget.userId,
      labName: 'Thyrocare Comprehensive Metabolic Panel',
      testDate: DateTime.now().subtract(const Duration(days: 14)),
      results: results,
      uploadedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceCard,
        elevation: 0,
        title: Text('Clinical Lab Intelligence', style: AppTypography.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Summary Card
            BentoCard(
              isGlowing: true,
              glowColor: AppColors.primaryEmerald,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_report.labName, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primaryEmerald.withAlpha(25), borderRadius: BorderRadius.circular(6)),
                        child: Text('All Optimal ✨', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_report.executiveSummary, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Text(_report.executiveSummaryHindi, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryEmerald, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Biomarker Panel Breakdown', style: AppTypography.h3),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _report.results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final r = _report.results[index];
                return BentoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text(r.nameHindi, style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
                          Row(
                            children: [
                              Text('${r.value} ${r.unit}', style: AppTypography.h3.copyWith(color: AppColors.primaryEmerald)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Ref: ${r.referenceMin} - ${r.referenceMax} ${r.unit}', style: AppTypography.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
