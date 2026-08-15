import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../providers/affiliate_provider.dart';

/// §P13-C Creator Earnings Dashboard UI (Route: /affiliate/dashboard)
class CreatorEarningsDashboardScreen extends ConsumerWidget {
  const CreatorEarningsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(affiliateProvider);
    final notifier = ref.read(affiliateProvider.notifier);
    final stats = state.stats;
    final referral = state.referralLink;

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg0,
        elevation: 0,
        title: const Text('Creator Earnings & Referral Center', style: AppTypography.h2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title with Icon: 💰 Creator Earnings & Referral Center
              Row(
                children: [
                  const Text('💰 ', style: TextStyle(fontSize: 22)),
                  Expanded(
                    child: Text(
                      'Creator Earnings & Referral Center',
                      style: AppTypography.h1.copyWith(color: AppColors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // 1. Available Balance & Next Payout Card
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Balance:',
                              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stats.formattedBalance,
                              style: AppTypography.metricLg.copyWith(color: AppColors.success),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.glassBgMid,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Next Payout Date:',
                                style: AppTypography.labelMd.copyWith(fontSize: 10, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'June 15, 2026',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '15% recurring creator commission on every active Pro referral',
                      style: AppTypography.labelMd.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // 2. Lifetime Referrals Bento Card: 📈 Lifetime Referrals
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📈 ', style: TextStyle(fontSize: 16)),
                        Text('Lifetime Referrals:', style: AppTypography.h3),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _MetricRow(
                      label: 'Total Clicks:',
                      value: stats.totalClicks.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          ),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 12),
                    _MetricRow(
                      label: 'Free Signups:',
                      value: stats.freeSignups.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          ),
                    ),
                    const Divider(color: AppColors.glassBorder, height: 12),
                    _MetricRow(
                      label: 'Pro Conversions:',
                      value: '${stats.proConversions}  (11.7% conversion rate)',
                      valueColor: AppColors.teal,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // 3. Monthly Payout History: 💵 Monthly Payout History
              BentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('💵 ', style: TextStyle(fontSize: 16)),
                        Text('Monthly Payout History:', style: AppTypography.h3),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...stats.payoutHistory.map((payout) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '• ${payout.periodLabel}:   ${payout.formattedAmount}',
                              style: AppTypography.bodySm.copyWith(color: AppColors.textPrimary),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '[${payout.status.displayName}]',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 4. Action Buttons matching wireframe
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    notifier.requestInstantBankTransfer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🎉 Instant Bank Transfer requested!'),
                        backgroundColor: AppColors.teal,
                      ),
                    );
                  },
                  child: const Text(
                    'Request Instant Bank Transfer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.teal,
                    side: const BorderSide(color: AppColors.teal),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: referral.fullUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied referral link: ${referral.fullUrl}'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                  },
                  child: Text(
                    'Share Referral Link: ${referral.fullUrl}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySm.copyWith(color: AppColors.textMuted)),
        Text(
          value,
          style: AppTypography.bodySm.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
