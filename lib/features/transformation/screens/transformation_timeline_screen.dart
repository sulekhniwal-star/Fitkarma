import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/transformation_journey_provider.dart';

/// §P8-B Transformation Timeline Screen
/// Route: /transformation
class TransformationTimelineScreen extends ConsumerWidget {
  const TransformationTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transformationJourneyProvider);
    final currentWeight = state.weightHistory.isNotEmpty ? state.weightHistory.last.weightKg : 72.0;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Transformation Journey', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Weight Projection & 90-Day Range BentoCard
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weight Projection & 90-Day Range', style: AppTypography.h3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Current: ${currentWeight.toStringAsFixed(1)} kg',
                            style: AppTypography.labelLg.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Custom Graphical Prediction Channel ASCII/Visual Chart Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bg0,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('80 kg', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted)),
                              Text('Month 1', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted)),
                              Text('Month 2', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted)),
                              Text('Month 3 (Forecast Range)', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Stack(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.1),
                                      AppColors.teal.withValues(alpha: 0.25),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Projected Zone: ${state.projectedWeightMin} kg - ${state.projectedWeightMax} kg',
                                    style: AppTypography.labelLg.copyWith(color: AppColors.teal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Text('Target Prediction (At Current Pace):', style: AppTypography.labelLg),
                    const SizedBox(height: 4),
                    Text('  • Projected Weight (90 days): ${state.projectedWeightMin} kg - ${state.projectedWeightMax} kg', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                    Text('  • Projected Body Fat: ${state.projectedBodyFatMin}% - ${state.projectedBodyFatMax}%', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                    Text('  • Program Target: Week ${state.completedProgramWeeks} of 12 complete', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Biometric Locked Secure Progress Photos Section
              Text('🔒 Secure Progress Photos (Biometric Locked)', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              if (!state.arePhotosUnlocked) ...[
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      const Icon(Icons.fingerprint, color: AppColors.primary, size: 48),
                      const SizedBox(height: 8),
                      Text('Photos are Biometric Encrypted', style: AppTypography.labelLg),
                      const SizedBox(height: 4),
                      Text(
                        'Unlock with FaceID / TouchID to view locked progress snapshots.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ref.read(transformationJourneyProvider.notifier).authenticateBiometrics(mockSuccess: true);
                        },
                        child: Text('Tap to Unlock Photos', style: AppTypography.labelLg.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    for (final photo in state.progressPhotos)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GlassCard(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const Icon(Icons.photo, color: AppColors.accent, size: 36),
                                const SizedBox(height: 4),
                                Text(photo.weekLabel, style: AppTypography.labelLg),
                                Text('Unlocked', style: AppTypography.bodySm.copyWith(color: AppColors.success, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
