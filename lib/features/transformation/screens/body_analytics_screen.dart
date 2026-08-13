import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/body_analytics_provider.dart';

/// §P11-A Body Analytics & Visual Body Screen
/// Route: /analytics/body
class BodyAnalyticsScreen extends ConsumerWidget {
  const BodyAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(bodyAnalyticsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          children: [
            Text('Body Analytics ', style: AppTypography.h2),
            const Icon(Icons.lock_outline, color: AppColors.teal, size: 18),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Body Fat & Composition BentoCard (§P11-C UI Card)
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Body Fat Range', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(analytics.categoryLabel, style: AppTypography.labelSmall.copyWith(color: AppColors.teal, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${analytics.bodyFatPct}% ', style: AppTypography.h1.copyWith(color: AppColors.primary)),
                        Text('Body Fat', style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Progress Bar Indicator
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (analytics.bodyFatPct / 40.0).clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: AppColors.bg1,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('Lean Mass', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                            Text('${analytics.leanMassKg} kg', style: AppTypography.h3.copyWith(color: AppColors.success)),
                          ],
                        ),
                        Container(width: 1, height: 30, color: AppColors.textMuted.withValues(alpha: 0.3)),
                        Column(
                          children: [
                            Text('Fat Mass', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                            Text('${analytics.fatMassKg} kg', style: AppTypography.h3.copyWith(color: AppColors.warning)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Confidence: ${analytics.confidence} (${analytics.estimationMethod})', style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3-Month Trend Deltas Section
              Text('3-Month Trend (Deltas)', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Body Fat %', style: AppTypography.bodySm),
                        Text(
                          '${analytics.bodyFatDelta3Months}% ✓',
                          style: AppTypography.labelLg.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lean Mass', style: AppTypography.bodySm),
                        Text(
                          '+${analytics.leanMassDelta3Months} kg ✓',
                          style: AppTypography.labelLg.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Anthropometric Checkpoints
              Text('Anthropometric Checkpoints', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CheckMetric(label: 'Neck', value: '${analytics.neckCm} cm'),
                    _CheckMetric(label: 'Waist', value: '${analytics.waistCm} cm'),
                    if (analytics.hipCm != null) _CheckMetric(label: 'Hips', value: '${analytics.hipCm} cm'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Progress Photo System (§P11-B) Biometric Photo Lock Card
              Text('§P11-B Progress Photo System 🔒', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: analytics.isBiometricUnlocked
                      ? AppColors.teal.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: analytics.isBiometricUnlocked
                        ? AppColors.teal.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          analytics.isBiometricUnlocked ? Icons.lock_open : Icons.fingerprint,
                          color: analytics.isBiometricUnlocked ? AppColors.teal : AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            analytics.isBiometricUnlocked
                                ? 'Encrypted Progress Photos Unlocked'
                                : 'Encrypted Local Storage (Biometric Lock)',
                            style: AppTypography.labelLg,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Photos are stored encrypted on-device only. Auto-cropping face safeguards photos during side-by-side comparison.',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    if (!analytics.isBiometricUnlocked)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.fingerprint, color: AppColors.bg0, size: 18),
                        label: Text('Authenticate to Unlock Photos', style: AppTypography.labelLg.copyWith(color: AppColors.bg0)),
                        onPressed: () {
                          ref.read(bodyAnalyticsProvider.notifier).unlockBiometrics();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Biometric authentication successful! Progress photos unlocked.')),
                          );
                        },
                      ),
                  ],
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

class _CheckMetric extends StatelessWidget {
  final String label;
  final String value;

  const _CheckMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.labelLg),
      ],
    );
  }
}
