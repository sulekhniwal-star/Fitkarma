import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/monthly_report_provider.dart';

/// §P10-C Monthly Health Report Screen
/// Route: /reports/monthly
class MonthlyReportScreen extends ConsumerWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(monthlyReportProvider);

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
        title: Text('Monthly Health Report', style: AppTypography.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
            onPressed: () {
              ref.read(monthlyReportProvider.notifier).triggerExportPdf();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Exporting Monthly Health Report PDF...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.teal),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Sharing Monthly Health Report...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Report Period: May 2026',
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.md),

              // Biological Age vs Chronological Age BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Biological Age vs. Chronological Age',
                        style: AppTypography.h3),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Chronological Age: ${report.biologicalAgeResult.chronologicalAge} Years',
                            style: AppTypography.bodySm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Bio Age: ${report.biologicalAgeResult.biologicalAge.round()} Yrs (${report.biologicalAgeResult.ageDeltaYears.round()} yrs)',
                            style: AppTypography.labelSmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Summary: Excellent cardiovascular recovery trends & high HRV.',
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Biomarkers & Vitals Averages BentoCard
              Text('Biomarkers & Vitals Averages', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Systolic BP:', style: AppTypography.bodySm),
                        Text(
                            '${report.averageSystolicBp.round()} mmHg (Normal)',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.success)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fasting Glucose:', style: AppTypography.bodySm),
                        Text(
                            '${report.averageFastingGlucoseMgDl.round()} mg/dL (Normal)',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.success)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('HRV Average:', style: AppTypography.bodySm),
                        Text(
                            '${report.averageHrvMs.round()} ms (+8% vs last month)',
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Detected Health Risks Section
              Text('⚠️ Detected Health Risks', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              for (final risk in report.detectedRisks)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(risk.patternName,
                            style: AppTypography.labelLg
                                .copyWith(color: AppColors.warning)),
                        const SizedBox(height: 2),
                        Text(risk.description, style: AppTypography.bodySm),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),

              // Focus Strategy Section
              Text('Next Month\'s Focus Strategy', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  report.nextMonthFocusStrategy,
                  style:
                      AppTypography.bodySm.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
