import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/predictive_health_provider.dart';

class PredictiveHealthScreen extends ConsumerWidget {
  const PredictiveHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(predictiveHealthProvider);
    final bioAge = state.bioAge;
    final cgm = state.latestCgmSpike;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Predictive Health & CGM', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Biological Age Estimation Gauge Card
              GlassCard(
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: CircularProgressIndicator(
                            value: 0.85,
                            strokeWidth: 8.0,
                            backgroundColor: AppColors.bgSecondary,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        Text(
                          '${bioAge.biologicalAge.round()}',
                          style: AppTypography.displayLarge
                              .copyWith(color: AppColors.primaryEmerald),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Biological Age',
                              style: AppTypography.titleLarge),
                          Text(
                            'Chrono: ${bioAge.chronologicalAge.round()} yrs (${bioAge.ageDeltaYears >= 0 ? "${bioAge.ageDeltaYears.toStringAsFixed(1)} yrs younger!" : "Elevated"})',
                            style: AppTypography.titleMedium
                                .copyWith(color: AppColors.primaryEmerald),
                          ),
                          Text(bioAge.primaryContributor,
                              style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // CGM Live Spike Detection Banner
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CGM Spike Detection',
                            style: AppTypography.titleMedium),
                        Chip(
                          backgroundColor: AppColors.glassBgMid,
                          side: const BorderSide(color: AppColors.glassBorder),
                          label: Text(cgm.severity,
                              style: AppTypography.labelSmall
                                  .copyWith(color: AppColors.warningAmber)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Glucose Spike +${cgm.glucoseDeltaMgDl.round()} mg/dL detected within 35min window.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 4.0),
                    Text('Rec: ${cgm.recommendation}',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.primaryCyan)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Drug-Nutrient Warning Banner (if active)
              if (state.activeDrugWarning != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.warningAmber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.warningAmber),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.medication_liquid,
                          color: AppColors.warningAmber),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(state.activeDrugWarning!,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.warningAmber)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),

              // Passcode-Protected Doctor Sharing Portal PDF Card
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Passcode Doctor Share PDF',
                            style: AppTypography.titleMedium),
                        Text('DPDP Act & Medical Disclaimer Compliant',
                            style: AppTypography.labelSmall),
                      ],
                    ),
                    Chip(
                      backgroundColor: AppColors.glassBgMid,
                      side: const BorderSide(color: AppColors.glassBorder),
                      label: Text(state.doctorPortalPasscode,
                          style: AppTypography.titleMedium
                              .copyWith(color: AppColors.primaryCyan)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
