/// §P13-C Creator Affiliate Dashboard UI Screen
///
/// Route: `/affiliate/dashboard`
/// Glassmorphic UI (`0xFF0F172A`) providing referral link generation, click/conversion analytics,
/// recurring payout ledger history, and 🆕 §P16-E Grocery Vendor Checkout affiliate tracking matching §P13-C spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'affiliate_controller.dart';
import 'affiliate_models.dart';

class AffiliateDashboardScreen extends ConsumerStatefulWidget {
  const AffiliateDashboardScreen({super.key});

  static const routeName = '/affiliate/dashboard';

  @override
  ConsumerState<AffiliateDashboardScreen> createState() => _AffiliateDashboardScreenState();
}

class _AffiliateDashboardScreenState extends ConsumerState<AffiliateDashboardScreen> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliateProvider);
    final notifier = ref.read(affiliateProvider.notifier);
    final link = state.activeLink;

    ref.listen<AffiliateState>(affiliateProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF10B981),
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
          '💰 Creator Earnings Center',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Balance & Payout Header Card
            _buildBalanceHeroCard(state, notifier),
            const SizedBox(height: 20),

            // 2. Referral Code & Share Link Card
            _buildReferralLinkCard(link, context, notifier),
            const SizedBox(height: 20),

            // 3. Lifetime Analytics Grid
            const Text(
              '📈 Lifetime Referral Performance',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildAnalyticsGrid(link),
            const SizedBox(height: 24),

            // 4. Ledger History & Grocery Affiliate Orders (Reused by §P16-E)
            const Text(
              '💵 Payout Ledger & Revenue Stream History',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildLedgerSection(state),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceHeroCard(AffiliateState state, AffiliateNotifier notifier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF047857), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.monetization_on_rounded, color: Color(0xFF10B981), size: 24),
              SizedBox(width: 8),
              Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '₹${state.availableBalanceInr.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32),
          ),
          const SizedBox(height: 2),
          Text(
            'Lifetime Earnings: ₹${state.lifetimeEarningsInr.toStringAsFixed(2)} • Next Payout: June 15, 2026',
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            icon: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 16),
            label: const Text('Request Instant Bank Transfer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: state.availableBalanceInr > 0 ? () => notifier.requestInstantPayout() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralLinkCard(ReferralLink link, BuildContext context, AffiliateNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR CODE: ${link.referralCode}',
                style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${link.creatorCommissionPct.toInt()}% RECURRING',
                  style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Followers get ${link.clientDiscountPct.toInt()}% off FitKarma Pro. You earn ${link.creatorCommissionPct.toInt()}% recurring monthly revenue.',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    link.shareUrl,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
                icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 16),
                label: const Text('Copy Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: link.shareUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Referral link copied to clipboard!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsGrid(ReferralLink link) {
    final conversionRateStr = link.conversionRate.toStringAsFixed(1);

    return Row(
      children: [
        Expanded(child: _statCard('Total Clicks', '${link.totalClicks}', Icons.touch_app_rounded, const Color(0xFF38BDF8))),
        const SizedBox(width: 8),
        Expanded(child: _statCard('Free Signups', '${link.freeSignups}', Icons.person_add_rounded, const Color(0xFFA259FF))),
        const SizedBox(width: 8),
        Expanded(child: _statCard('Pro Conversions', '${link.proConversions}\n($conversionRateStr%)', Icons.bolt_rounded, const Color(0xFF22C55E))),
      ],
    );
  }

  Widget _statCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(val, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, height: 1.1)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildLedgerSection(AffiliateState state) {
    return Column(
      children: [
        ...state.ledgerEntries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildGlassCard(
              child: Row(
                children: [
                  Icon(
                    e.source == AffiliateSource.groceryCheckout ? Icons.shopping_cart_rounded : Icons.star_rounded,
                    color: e.source == AffiliateSource.groceryCheckout ? const Color(0xFFF59E0B) : const Color(0xFF38BDF8),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text('Gross Order: ₹${e.grossAmountInr.toInt()}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                      ],
                    ),
                  ),
                  Text(
                    '+₹${e.commissionAmountInr.toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
