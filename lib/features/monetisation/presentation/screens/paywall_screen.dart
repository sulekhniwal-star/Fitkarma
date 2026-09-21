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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Subscribed to ${_selectedTier.name.toUpperCase()} tier!'),
                      backgroundColor: AppColors.primaryEmerald,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Upgrade to ${_selectedTier.name.toUpperCase()}',
                  style: AppTypography.h3.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Secured by Razorpay & RevenueCat. Auto-renews. Cancel anytime.',
              style: AppTypography.bilingualSub,
              textAlign: TextAlign.center,
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
