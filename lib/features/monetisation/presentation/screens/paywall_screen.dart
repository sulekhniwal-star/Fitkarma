import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/monetisation/domain/models/monetisation_models.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  final String? sourceFeatureKey;

  const PaywallScreen({super.key, this.sourceFeatureKey});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  AppSubscriptionTier _selectedTier = AppSubscriptionTier.pro;
  bool _isAnnual = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('FitKarma Memberships', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hero Title & Value Proposition
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.readinessGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, color: Colors.black, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'Elevate Your Longevity & Vitality',
                    style: AppTypography.h2.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'India\'s most advanced AI-powered health OS with personalized metabolic intelligence.',
                    style: AppTypography.bodySmall.copyWith(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Annual vs Monthly Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Monthly', style: _isAnnual ? AppTypography.bodySmall : AppTypography.label.copyWith(color: AppColors.primaryCyan)),
                Switch(
                  value: _isAnnual,
                  activeThumbColor: AppColors.primaryCyan,
                  onChanged: (val) => setState(() => _isAnnual = val),
                ),
                Text('Annual (Save 35%)', style: _isAnnual ? AppTypography.label.copyWith(color: AppColors.primaryCyan) : AppTypography.bodySmall),
              ],
            ),
            const SizedBox(height: 16),

            // Tier Cards
            _buildTierCard(
              tier: AppSubscriptionTier.free,
              title: 'Yogi Free',
              price: '₹0',
              period: 'Forever',
              features: [
                'Daily Missions & Activity Rings',
                'Ayurvedic Dosha Profile',
                'Standard Nutrition & Desi Workouts',
                'Community Squads (View only)',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 12),

            _buildTierCard(
              tier: AppSubscriptionTier.pro,
              title: 'FitKarma Pro',
              price: _isAnnual ? '₹1,999' : '₹299',
              period: _isAnnual ? 'per year (₹166/mo)' : 'per month',
              features: [
                'Unlimited AI Adaptive Coach & Sharma Ji Roasts',
                'CGM Telemetry & Spike Analytics',
                'Biological Age & Cardiometabolic Risk Engine',
                'Clinical Lab & Doctor Dossier PDF Export',
                'Visual Body Composition Analytics',
                'Shaadi & Festival Intelligence Modes',
                'Ad-Free Pure Health OS Experience',
              ],
              isPopular: true,
            ),
            const SizedBox(height: 12),

            _buildTierCard(
              tier: AppSubscriptionTier.elite,
              title: 'FitKarma Elite',
              price: _isAnnual ? '₹7,999' : '₹999',
              period: _isAnnual ? 'per year' : 'per month',
              features: [
                'Everything in Pro included',
                'Monthly 1-on-1 Consultation with Certified Indian Coach',
                'Personalized Blood Biomarker Prescription Review',
                'Priority AI Voice & WhatsApp Chat Logging',
                'Dedicated Concierge Support',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.flash_on, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => _openIndianPaymentSheet(context),
                label: Text(
                  _selectedTier == AppSubscriptionTier.free
                      ? 'Continue with Yogi Free'
                      : 'Pay via UPI / Card • ${_selectedTier.name.toUpperCase()}',
                  style: AppTypography.h3.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.primaryEmerald, size: 16),
                const SizedBox(width: 6),
                Text(
                  '100% Secure • Razorpay UPI • Instant Activation',
                  style: AppTypography.label.copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'GPay • PhonePe • Paytm • BHIM • Cards • No-Cost EMI',
              style: AppTypography.label.copyWith(color: AppColors.textMuted, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openIndianPaymentSheet(BuildContext context) {
    if (_selectedTier == AppSubscriptionTier.free) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Switched to Yogi Free tier'),
          backgroundColor: AppColors.primaryCyan,
        ),
      );
      Navigator.pop(context);
      return;
    }

    final priceStr = _selectedTier == AppSubscriptionTier.pro
        ? (_isAnnual ? '₹1,999' : '₹299')
        : (_isAnnual ? '₹7,999' : '₹999');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String selectedPaymentMethod = 'gpay';
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Razorpay Fast Checkout', style: AppTypography.h3),
                            Text('Pay $priceStr for ${_selectedTier.name.toUpperCase()}', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryCyan)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textMuted),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.borderGlass, height: 24),
                    Text('Select Preferred UPI / Payment Rail', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    
                    // UPI Apps
                    _buildPaymentOptionTile(
                      id: 'gpay',
                      title: 'Google Pay (UPI)',
                      subtitle: 'Fast 1-tap checkout via GPay UPI',
                      icon: Icons.account_balance_wallet_outlined,
                      selected: selectedPaymentMethod == 'gpay',
                      badge: 'FASTEST',
                      onTap: () => setSheetState(() => selectedPaymentMethod = 'gpay'),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOptionTile(
                      id: 'phonepe',
                      title: 'PhonePe',
                      subtitle: 'UPI payment via PhonePe app',
                      icon: Icons.mobile_friendly,
                      selected: selectedPaymentMethod == 'phonepe',
                      onTap: () => setSheetState(() => selectedPaymentMethod = 'phonepe'),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOptionTile(
                      id: 'paytm',
                      title: 'Paytm UPI / Wallet',
                      subtitle: 'Paytm balance, Postpaid & UPI',
                      icon: Icons.payment,
                      selected: selectedPaymentMethod == 'paytm',
                      onTap: () => setSheetState(() => selectedPaymentMethod = 'paytm'),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOptionTile(
                      id: 'emi',
                      title: 'No-Cost EMI (3/6 Months)',
                      subtitle: 'Bajaj Finserv, HDFC, ICICI, SBI',
                      icon: Icons.credit_score,
                      selected: selectedPaymentMethod == 'emi',
                      badge: '0% INTEREST',
                      onTap: () => setSheetState(() => selectedPaymentMethod = 'emi'),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentOptionTile(
                      id: 'card',
                      title: 'Cards & NetBanking',
                      subtitle: 'All Indian Debit/Credit cards',
                      icon: Icons.credit_card,
                      selected: selectedPaymentMethod == 'card',
                      onTap: () => setSheetState(() => selectedPaymentMethod = 'card'),
                    ),
                    const SizedBox(height: 20),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryEmerald,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Payment Successful ($priceStr via ${selectedPaymentMethod.toUpperCase()})! Welcome to ${_selectedTier.name.toUpperCase()}!'),
                              backgroundColor: AppColors.primaryEmerald,
                              duration: const Duration(seconds: 4),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Authorize & Pay $priceStr',
                          style: AppTypography.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentOptionTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryCyan.withAlpha(20) : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primaryCyan : AppColors.borderGlass,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primaryCyan : AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryEmerald.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(badge, style: AppTypography.label.copyWith(fontSize: 9, color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  Text(subtitle, style: AppTypography.label.copyWith(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? AppColors.primaryCyan : AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required AppSubscriptionTier tier,
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isPopular,
  }) {
    final isSelected = _selectedTier == tier;

    return BentoCard(
      onTap: () => setState(() => _selectedTier = tier),
      padding: const EdgeInsets.all(16),
      glowColor: isPopular ? AppColors.primaryCyan : null,
      isGlowing: isSelected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primaryCyan : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: AppTypography.h3),
                ],
              ),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryEmerald.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('MOST POPULAR', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price, style: AppTypography.heroMetric.copyWith(fontSize: 28, color: AppColors.primaryCyan)),
              const SizedBox(width: 6),
              Text(period, style: AppTypography.bodySmall),
            ],
          ),
          const Divider(color: AppColors.borderGlass, height: 20),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, color: AppColors.primaryEmerald, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(f, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
