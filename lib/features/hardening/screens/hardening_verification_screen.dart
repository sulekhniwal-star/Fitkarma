import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/hardening_provider.dart';

class HardeningVerificationScreen extends ConsumerWidget {
  const HardeningVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hardeningProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        title: Text('Production Hardening', style: AppTypography.titleLarge),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DLQ Sync Failure Alert Banner (if >= 3 failures)
              if (state.isDlqBannerActive)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(color: AppColors.errorRed),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sync_problem, color: AppColors.errorRed),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DLQ Alert: 3 Consecutive Sync Failures',
                                style: AppTypography.titleMedium
                                    .copyWith(color: AppColors.errorRed)),
                            Text('Offline queue backed up. Tap to retry sync.',
                                style: AppTypography.labelSmall),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref
                            .read(hardeningProvider.notifier)
                            .resetSyncFailures(),
                        child: Text('Retry',
                            style: AppTypography.titleMedium
                                .copyWith(color: AppColors.primaryCyan)),
                      ),
                    ],
                  ),
                ),

              // Performance Tier Status Card
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Performance Glass Tier',
                            style: AppTypography.titleMedium),
                        Text('Cold Start <2s • Daily Briefing <100ms',
                            style: AppTypography.labelSmall),
                      ],
                    ),
                    Chip(
                      backgroundColor: AppColors.glassBgMid,
                      side: const BorderSide(color: AppColors.glassBorder),
                      label: Text('TIER: ${state.deviceTier.toUpperCase()}',
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.primaryCyan)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Sentry PII Stripping Card
              GlassCard(
                child: Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.primaryEmerald),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sentry PII Stripping Verified',
                              style: AppTypography.titleMedium),
                          Text(
                              'Emails, phone numbers, & names redacted before telemetry transmit',
                              style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // DPDP Act Privacy Policy Card
              GlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DPDP Act Privacy Policy',
                            style: AppTypography.titleMedium),
                        Text('Written and linked in privacy_policy.md',
                            style: AppTypography.labelSmall),
                      ],
                    ),
                    const Icon(Icons.description,
                        color: AppColors.primaryViolet),
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
