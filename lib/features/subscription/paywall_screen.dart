/// §P13-A Paywall & Upgrade UI Screen
///
/// Route: `/subscription/paywall`
/// Glassmorphic UI (`0xFF0F172A`) rendering feature comparison, package selection,
/// RevenueCat IAP triggers, trial activation, and "Continue with Free Plan" option matching §P13-A spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'revenuecat_subscription_service.dart';
import 'subscription_models.dart';
import 'subscription_notifier.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.trigger});

  static const routeName = '/subscription/paywall';
  final PaywallTrigger? trigger;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedPackageId = 'pro_yearly_1999'; // Default best value option

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);

    ref.listen<SubscriptionState>(subscriptionProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF22C55E),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '⚡ Unlock FitKarma Pro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Paywall Header Hero Card
            _buildHeroCard(),
            const SizedBox(height: 20),

            // 2. Pro Features Included Card
            const Text(
              '⭐ Included with FitKarma Pro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeaturesCard(),
            const SizedBox(height: 24),

            // 3. Subscription Plan Option Cards
            const Text(
              '💳 Select Your Plan (7-Day Free Trial)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            ...RevenueCatSubscriptionService.defaultPackages
                .map((pkg) => _buildPackageCard(pkg)),
            const SizedBox(height: 24),

            // 4. Action Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0EA5E9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: state.isLoading
                    ? null
                    : () => notifier.purchaseRevenueCatPackage(_selectedPackageId),
                child: state.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Start 7-Day Free Trial ✨',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => notifier.restorePurchases(),
                  child: const Text(
                    'Restore Purchases',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ),
                const Text(' • ', style: TextStyle(color: Colors.white38)),
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text(
                    'Continue with Free Plan',
                    style: TextStyle(color: Color(0xFF38BDF8), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0369A1), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: Color(0xFF38BDF8), size: 28),
              SizedBox(width: 8),
              Text(
                'Supercharge Your Transformation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Get 24/7 unlimited AI coaching, instant vision meal scanning, predictive body composition, and doctor-ready reports.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return _buildGlassCard(
      child: const Column(
        children: [
          _FeatureRow(text: '✓ Unlimited AI Coach Chats & 24/7 Guidance'),
          _FeatureRow(text: '✓ Unlimited Instant Vision Meal Photo Scanning'),
          _FeatureRow(text: '✓ 90-Day Predictive Health Insights & Body Composition'),
          _FeatureRow(text: '✓ Doctor Sharing Portal (Passcode PDF & FHIR-lite)'),
          _FeatureRow(text: '✓ Life Events & Travel Mode Adaptations'),
          _FeatureRow(text: '✓ Create & Lead Private Accountability Squads'),
        ],
      ),
    );
  }

  Widget _buildPackageCard(RevenueCatPackage pkg) {
    final isSelected = _selectedPackageId == pkg.identifier;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => _selectedPackageId = pkg.identifier),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0EA5E9).withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0EA5E9) : Colors.white.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: pkg.identifier,
                groupValue: _selectedPackageId,
                activeColor: const Color(0xFF0EA5E9),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPackageId = val);
                },
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pkg.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        if (pkg.savingsPercentage != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SAVE ${pkg.savingsPercentage}%',
                              style: const TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.w800, fontSize: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '7-Day Free Trial, then ${pkg.priceString} / ${pkg.period}',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                pkg.priceString,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: child,
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
