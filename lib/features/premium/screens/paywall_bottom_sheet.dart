import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../providers/premium_provider.dart';

class PaywallBottomSheet extends ConsumerWidget {
  const PaywallBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(premiumProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Unlock FitKarma Pro', style: AppTypography.displayLarge),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Get 7-day free trial. Unlimited AI Coach, CGM Analytics, and Premium Readiness Tiers.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),

          ...state.packages.map(
            (pkg) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                onTap: () {
                  ref.read(premiumProvider.notifier).startFreeTrial();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pkg.name, style: AppTypography.titleMedium),
                        Text(pkg.priceFormatted, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryEmerald)),
                      ],
                    ),
                    const Icon(Icons.arrow_forward, color: AppColors.primaryCyan),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Mandatory "Continue Free" Option
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Continue Free',
                style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
