import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../core/brain/clinical_report_parser.dart';

final clinicalReportParserProvider =
    Provider<ClinicalReportParser>((ref) => const ClinicalReportParser());

final clinicalReportStateProvider =
    FutureProvider<ClinicalReportResult>((ref) async {
  final parser = ref.watch(clinicalReportParserProvider);
  const sampleText =
      'Complete Blood Count: Hemoglobin 10.8 g/dL. Lipid Profile: LDL Cholesterol 148 mg/dL, HDL Cholesterol 52 mg/dL.';
  return parser.parseText(sampleText);
});

/// §P10-F Clinical Report Intelligence Screen
/// Route: /reports/clinical
class ClinicalReportScreen extends ConsumerWidget {
  const ClinicalReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(clinicalReportStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Lab Report Intelligence', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Simulating local Lab PDF upload & on-device extraction...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: reportAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(
              child: Text('Error loading report: $err',
                  style: AppTypography.bodySm)),
          data: (report) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Privacy Shield Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.security,
                          color: AppColors.teal, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'On-Device Privacy Guaranteed: Raw PDF never leaves your phone. Only numeric biomarker values sync securely.',
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.teal, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Report Summary Header Card
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lab Report Uploaded: CBC + Lipid Profile',
                          style: AppTypography.h3),
                      const SizedBox(height: 4),
                      Text('Date: 15 May 2026',
                          style: AppTypography.bodySm
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Key Findings Section
                Text('━━━ Key Findings ━━━', style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                for (final bio in report.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bio.name, style: AppTypography.labelLg),
                                Text(
                                  'Value: ${bio.value} ${bio.unit} (Ref: ${bio.minReference}–${bio.maxReference})',
                                  style: AppTypography.bodySm
                                      .copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: bio.status == BiomarkerStatus.normal
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              bio.status == BiomarkerStatus.normal
                                  ? '✓ Normal'
                                  : '⚠️ ${bio.status.name.toUpperCase()}',
                              style: AppTypography.labelSmall.copyWith(
                                color: bio.status == BiomarkerStatus.normal
                                    ? AppColors.success
                                    : AppColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.lg),

                // Clinical Insights & Plan Adjustments Section
                Text('━━━ Clinical Insights & Plan Adjustments ━━━',
                    style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                for (final insight in report.insights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(insight.title,
                              style: AppTypography.labelLg.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(insight.description,
                              style: AppTypography.bodySm),
                          const SizedBox(height: 6),
                          Text(insight.impactMessage,
                              style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic)),
                          const SizedBox(height: 8),
                          Text('Recommended Actions:',
                              style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          for (final action in insight.recommendedActions)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('→ ',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12)),
                                Expanded(
                                  child: Text(action,
                                      style: AppTypography.bodySm.copyWith(
                                          color: AppColors.textPrimary,
                                          fontSize: 12)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
