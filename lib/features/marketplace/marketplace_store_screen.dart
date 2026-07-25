/// §P13-B Creator & Coach Marketplace UI Screen
///
/// Route: `/marketplace/store`
/// Glassmorphic UI (`0xFF0F172A`) providing certified coach matchmaking,
/// program store blueprint direct purchases, creator onboarding, and wallet 80/20 royalty payouts matching §P13-B spec.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'marketplace_controller.dart';
import 'marketplace_models.dart';

class MarketplaceStoreScreen extends ConsumerStatefulWidget {
  const MarketplaceStoreScreen({super.key});

  static const routeName = '/marketplace/store';

  @override
  ConsumerState<MarketplaceStoreScreen> createState() => _MarketplaceStoreScreenState();
}

class _MarketplaceStoreScreenState extends ConsumerState<MarketplaceStoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _certCtrl = TextEditingController();
  final _rateCtrl = TextEditingController(text: '2999');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _certCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceProvider);
    final notifier = ref.read(marketplaceProvider.notifier);

    ref.listen<MarketplaceState>(marketplaceProvider, (_, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF0EA5E9),
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
          '🏛️ Creator & Coach Marketplace',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF38BDF8),
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: '🎯 Coaches'),
            Tab(text: '📦 Program Store'),
            Tab(text: '💼 Wallet (80/20)'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0EA5E9),
        icon: const Icon(Icons.verified_user_rounded, color: Colors.white),
        label: const Text('Onboard as Coach', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showCreatorOnboardingDialog(context, notifier),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Matched Certified Coaches
          _buildCoachesTab(state, notifier),

          // Tab 2: Program Store (User-Generated Blueprints)
          _buildProgramStoreTab(state, notifier),

          // Tab 3: Creator Wallet Ledger (ADR-040 Split)
          _buildWalletTab(state, notifier),
        ],
      ),
    );
  }

  Widget _buildCoachesTab(MarketplaceState state, MarketplaceNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Top Matched Certified Coaches',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Matched with your health goals (PCOS, Weight Loss, Recomp).',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 14),

          ...state.matchedCoaches.map(
            (match) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCoachCard(match.coach, match.matchScore, notifier),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildCoachCard(CreatorProfile coach, double score, MarketplaceNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                child: Text(
                  coach.name.substring(0, 1),
                  style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          coach.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        if (coach.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Color(0xFF38BDF8), size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '⭐ ${coach.averageRating} (${coach.activeClientsCount} active clients)',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${score.toInt()}% MATCH',
                  style: const TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(coach.bio, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: coach.specialties
                .map(
                  (s) => Chip(
                    label: Text(s.displayName, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${coach.monthlyCoachingRateInr.toInt()} / month',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: Colors.white),
                label: const Text('Hire Coach', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () => notifier.hireCoach(coach.creatorId),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramStoreTab(MarketplaceState state, MarketplaceNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📦 Program Store (Creator Blueprints)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Curated multi-week blueprints created by verified health specialists.',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 14),

          ...state.programs.map(
            (prog) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildProgramCard(prog, notifier),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildProgramCard(ProgramBlueprint prog, MarketplaceNotifier notifier) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  prog.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${prog.durationWeeks} WEEKS',
                  style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('By ${prog.creatorName} • ⭐ ${prog.rating} (${prog.purchasedCount} sold)',
              style: const TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 8),
          Text(prog.description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${prog.priceInr.toInt()}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E)),
                icon: const Icon(Icons.shopping_bag_rounded, size: 16, color: Colors.white),
                label: Text('Buy Blueprint (₹${prog.priceInr.toInt()})',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () => notifier.purchaseProgram(prog),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTab(MarketplaceState state, MarketplaceNotifier notifier) {
    final w = state.creatorWallet;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Summary Header Card (ADR-040 80/20 Platform Fee Split)
          Container(
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
                    Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Creator Wallet & Double-Entry Ledger',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '₹${w.balanceInr.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                ),
                const Text('Available Balance (80% Royalty Share)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  icon: const Icon(Icons.payments_rounded, color: Colors.white, size: 16),
                  label: const Text('Request Payout via Razorpay Route', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () => notifier.requestPayout(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Ledger Transactions List
          const Text(
            '📜 Recent Royalty Transactions (80/20 Split)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          if (w.entries.isEmpty)
            const Text('No transaction entries recorded yet.', style: TextStyle(color: Colors.white54, fontSize: 12))
          else
            ...w.entries.map(
              (e) => _buildGlassCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.transactionType.toUpperCase(),
                          style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Gross: ₹${e.grossAmountInr.toInt()} • Platform (20%): ₹${e.platformFeeInr.toInt()}',
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                    Text(
                      '+₹${e.creatorEarningsInr.toInt()}',
                      style: const TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 60),
        ],
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

  void _showCreatorOnboardingDialog(BuildContext context, MarketplaceNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Onboard as Verified Creator Coach',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Full Name', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bioCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Bio & Experience', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _certCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Certifications (e.g. CSD, CSCS)', labelStyle: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _rateCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Monthly Coaching Rate (₹)', labelStyle: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
            onPressed: () {
              notifier.onboardCreator(
                name: _nameCtrl.text.trim().isEmpty ? 'Coach New' : _nameCtrl.text.trim(),
                bio: _bioCtrl.text.trim().isEmpty ? 'Certified Coach' : _bioCtrl.text.trim(),
                certifications: [_certCtrl.text.trim().isEmpty ? 'Certified' : _certCtrl.text.trim()],
                specialties: [CoachSpecialty.pcosManagement, CoachSpecialty.weightLoss],
                rateInr: double.tryParse(_rateCtrl.text) ?? 2999.0,
              );
              Navigator.pop(ctx);
            },
            child: const Text('Submit Verification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
