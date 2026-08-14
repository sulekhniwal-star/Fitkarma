import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../models/subscription_model.dart';
import '../providers/premium_provider.dart';

/// §P13-A Paywall Bottom Sheet (Bottom-sheet only, no dark patterns)
class PaywallBottomSheet extends ConsumerWidget {
  final PaywallTrigger? trigger;

  const PaywallBottomSheet({
    super.key,
    this.trigger,
  });

  static Future<void> show(BuildContext context, {PaywallTrigger? trigger}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => PaywallBottomSheet(trigger: trigger),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(premiumProvider);
    final notifier = ref.read(premiumProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: AppColors.warning, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text('Unlock FitKarma Pro', style: AppTypography.h2),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              // Trigger-specific callout if provided
              if (trigger != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.teal, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          trigger!.triggerDescription,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.sm),
              Text(
                'Supercharge your health journey with Pro:',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Feature Matrix Card (§P13-A checkmarks)
              BentoCard(
                child: Column(
                  children: [
                    _FeatureRow(text: 'Unlimited AI Coach Chats'),
                    _FeatureRow(text: '90-Day Predictive Health Insights & Charts'),
                    _FeatureRow(text: 'Comprehensive Monthly Health Reports'),
                    _FeatureRow(text: 'Advanced Body Composition & Measurements Engine'),
                    _FeatureRow(text: 'Unlimited Meal Photo Analyses'),
                    _FeatureRow(text: 'Squad Creation & Challenge Host'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),
              Text('Select Plan (7-Day Free Trial):', style: AppTypography.labelLg),
              const SizedBox(height: AppSpacing.xs),

              // Plan Selection Grid
              Row(
                children: state.packages
                    .where((pkg) => pkg.tier == SubscriptionTier.pro)
                    .map((pkg) {
                  final isSelected = state.selectedPackage.productId == pkg.productId;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => notifier.selectPackage(pkg),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.teal.withValues(alpha: 0.18)
                              : AppColors.glassBgMid,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.teal : AppColors.glassBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (pkg.savingsBadge != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  pkg.savingsBadge!,
                                  style: AppTypography.labelMd.copyWith(
                                    color: AppColors.success,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              const SizedBox(height: 16),
                            Text(
                              pkg.period,
                              style: AppTypography.labelMd.copyWith(
                                color: isSelected ? AppColors.teal : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pkg.priceFormatted,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Primary CTA: [ Start Free Trial ]
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    notifier.startFreeTrial();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 7-Day FitKarma Pro Trial Activated!'),
                        backgroundColor: AppColors.teal,
                      ),
                    );
                  },
                  child: Text(
                    'Start Free Trial (${state.selectedPackage.priceFormatted})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Secondary Non-Coercive Option: [ Continue with Free Plan ] (§P13-A requirement)
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Continue with Free Plan',
                    style: AppTypography.labelLg.copyWith(
                      color: AppColors.textMuted,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.teal, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
