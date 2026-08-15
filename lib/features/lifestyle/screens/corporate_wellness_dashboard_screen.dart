// §P16-D Corporate Wellness & Insurer Dashboard Screen
// Cross-reference: §P16-D, §P7-F in Fitkarma_documentation.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../providers/corporate_wellness_provider.dart';

/// §P16-D Corporate Wellness Dashboard Screen
/// Route: /corporate/dashboard
class CorporateWellnessDashboardScreen extends ConsumerWidget {
  const CorporateWellnessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(corporateWellnessProvider);
    final notifier = ref.read(corporateWellnessProvider.notifier);
    final report = state.activeReport;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('🏢 Corporate Wellness & Insurer Portal', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Organization Header BentoCard
              if (state.selectedOrganization != null)
                BentoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.selectedOrganization!.organizationName, style: AppTypography.h3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withAlpha(40),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CORPORATE PLUS',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Tier: B2B2C Employer Program · Seats: ${state.selectedOrganization!.seatLimit}',
                        style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // Privacy Boundary Callout
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface1,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.teal, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Strict Privacy Boundary: Individual health data is NEVER exposed. Only anonymized cohort aggregates (min 10 users) are shown.',
                        style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Report Section
              if (report != null) ...[
                if (!report.isPrivacyThresholdMet) ...[
                  // Below-Threshold Privacy Alert Banner
                  Container(
                    key: const Key('below_threshold_banner'),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.warning.withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lock_outline, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Text('Privacy Threshold Notice', style: AppTypography.labelLg.copyWith(color: AppColors.warning)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          report.privacyStatusMessage,
                          style: AppTypography.bodySm,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Enrolled Active: ${report.enrolledActiveCount} / 10 required',
                          style: AppTypography.labelMd.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Above-Threshold Metrics Cards
                  Row(
                    children: [
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Enrollment', style: AppTypography.labelSmall),
                              const SizedBox(height: 4),
                              Text('${report.enrollmentRatePct}%', style: AppTypography.h1.copyWith(color: AppColors.primary)),
                              Text('${report.enrolledActiveCount} active participants', style: AppTypography.bodySm.copyWith(fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: BentoCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Avg Adherence', style: AppTypography.labelSmall),
                              const SizedBox(height: 4),
                              Text('${report.averageAdherenceScore}%', style: AppTypography.h1.copyWith(color: AppColors.teal)),
                              Text('${report.weeklyActivePct}% weekly active', style: AppTypography.bodySm.copyWith(fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Distribution Card
                  if (report.adherenceDistribution != null)
                    BentoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aggregate Adherence Distribution', style: AppTypography.h3),
                          const SizedBox(height: AppSpacing.sm),
                          for (final entry in report.adherenceDistribution!.entries) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key, style: AppTypography.bodySm),
                                  Text('${entry.value}%', style: AppTypography.labelLg.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ],
              const SizedBox(height: AppSpacing.xl),

              // Cohort Simulation Toggle for Testing / Demo
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('btn_simulate_below_threshold'),
                      onPressed: () => notifier.setSimulatedCohort(4),
                      child: const Text('Simulate Small Team (4 Users)'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('btn_simulate_above_threshold'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.bg0,
                      ),
                      onPressed: () => notifier.setSimulatedCohort(18),
                      child: const Text('Simulate Cohort (18 Users)'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
