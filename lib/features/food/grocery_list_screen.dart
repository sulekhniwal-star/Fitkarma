/// §P5-F Grocery List Screen
///
/// Budget-optimized grocery list UI with monthly budget card, budget edit modal,
/// optimization alert status banner, categorized item accordions with checkboxes,
/// protein swap suggestions card, and Quick-Commerce vendor checkout bar (§P16-E).
library;

import 'package:fitkarma/features/food/grocery_controller.dart';
import 'package:fitkarma/features/food/grocery_optimization_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _bgColor = Color(0xFF0E0F14);
const _surfaceColor = Color(0xFF1A1C26);
const _cardColor = Color(0xFF222434);
const _accentOrange = Color(0xFFFF6B35);
const _accentGreen = Color(0xFF4ADE80);
const _accentRed = Color(0xFFF87171);
const _accentYellow = Color(0xFFFBBF24);
const _textPrimary = Color(0xFFEFF0F7);
const _textSecondary = Color(0xFF9095B3);
const _borderColor = Color(0xFF2D2F45);

class GroceryListScreen extends ConsumerWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groceryProvider);
    final list = state.optimizedList;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Grocery Optimization 2.0',
          style: TextStyle(
            color: _textPrimary,
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: list == null
            ? const Center(
                child: CircularProgressIndicator(color: _accentOrange),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Monthly Budget Card ──
                    _BudgetCard(
                      monthlyBudgetInr: state.monthlyBudgetInr,
                      weeklyLimitInr: list.weeklyCostLimitInr,
                      totalCostInr: list.totalCostInr,
                      isWithinBudget: list.isWithinBudget,
                      onEditBudget: () => _showBudgetEditModal(
                        context,
                        ref,
                        state.monthlyBudgetInr,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Optimization Alert Banner ──
                    _OptimizationBanner(list: list),

                    const SizedBox(height: 16),

                    // ── Protein Swap Suggestions Card ──
                    if (list.hasSwaps) ...[
                      _ProteinSwapsCard(list: list),
                      const SizedBox(height: 16),
                    ],

                    // ── Categorized Shopping List ──
                    const Text(
                      'Aggregated Shopping List (7 Days)',
                      style: TextStyle(
                        color: _textPrimary,
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _CategoryGroup(
                      title: '🥦 Produce & Fresh Veggies',
                      category: GroceryCategory.produceAndVeggies,
                      items: list.items,
                    ),
                    const SizedBox(height: 8),
                    _CategoryGroup(
                      title: '🥚 Dairy & Eggs',
                      category: GroceryCategory.dairyAndEggs,
                      items: list.items,
                    ),
                    const SizedBox(height: 8),
                    _CategoryGroup(
                      title: '🥩 High-Yield Protein',
                      category: GroceryCategory.protein,
                      items: list.items,
                    ),
                    const SizedBox(height: 8),
                    _CategoryGroup(
                      title: '🌾 Grains & Pulses',
                      category: GroceryCategory.grainsAndLegumes,
                      items: list.items,
                    ),
                    const SizedBox(height: 8),
                    _CategoryGroup(
                      title: '🏺 Oils & Pantry',
                      category: GroceryCategory.pantryAndOils,
                      items: list.items,
                    ),

                    const SizedBox(height: 20),

                    // ── Quick-Commerce Checkout Section (§P16-E) ──
                    _VendorCheckoutSection(state: state),
                  ],
                ),
              ),
      ),
    );
  }

  void _showBudgetEditModal(
    BuildContext context,
    WidgetRef ref,
    double currentBudget,
  ) {
    final textCtrl = TextEditingController(
      text: currentBudget.round().toString(),
    );
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Set Monthly Grocery Budget (INR)',
                style: TextStyle(
                  color: _textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We calculate weekly cost limits & swap protein sources to stay within budget.',
                style: TextStyle(color: _textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('grocery_budget_input_modal'),
                controller: textCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: _textPrimary, fontSize: 16),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    color: _accentOrange,
                    fontWeight: FontWeight.w700,
                  ),
                  filled: true,
                  fillColor: _surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('grocery_save_budget_btn'),
                onPressed: () {
                  final newBudget =
                      double.tryParse(textCtrl.text) ?? currentBudget;
                  ref
                      .read(groceryProvider.notifier)
                      .setMonthlyBudget(newBudget);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save & Optimize List',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.monthlyBudgetInr,
    required this.weeklyLimitInr,
    required this.totalCostInr,
    required this.isWithinBudget,
    required this.onEditBudget,
  });

  final double monthlyBudgetInr;
  final double weeklyLimitInr;
  final double totalCostInr;
  final bool isWithinBudget;
  final VoidCallback onEditBudget;

  @override
  Widget build(BuildContext context) {
    final progress = (totalCostInr / (weeklyLimitInr > 0 ? weeklyLimitInr : 1))
        .clamp(0.0, 1.0);
    final statusColor = isWithinBudget ? _accentGreen : _accentRed;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Grocery Budget',
                    style: TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${monthlyBudgetInr.round()} / mo',
                    key: const Key('grocery_monthly_budget_text'),
                    style: const TextStyle(
                      color: _textPrimary,
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              IconButton(
                key: const Key('grocery_edit_budget_btn'),
                icon: const Icon(Icons.edit_rounded, color: _accentOrange),
                onPressed: onEditBudget,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Est. Cost: ₹${totalCostInr.round()}',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              Text(
                'Weekly Limit: ₹${weeklyLimitInr.round()}',
                style: const TextStyle(color: _textSecondary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _borderColor,
              valueColor: AlwaysStoppedAnimation(statusColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptimizationBanner extends StatelessWidget {
  const _OptimizationBanner({required this.list});

  final OptimizedGroceryList list;

  @override
  Widget build(BuildContext context) {
    if (!list.hasSwaps && list.isWithinBudget) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _accentGreen.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _accentGreen.withAlpha(80)),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: _accentGreen, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Within Budget ✓  No food swaps required.',
                style: TextStyle(
                  color: _accentGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final color = list.isWithinBudget ? _accentYellow : _accentRed;
    final icon = list.isWithinBudget
        ? Icons.bolt_rounded
        : Icons.warning_amber_rounded;

    return Container(
      key: const Key('grocery_optimization_banner'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.isWithinBudget
                      ? 'Protein-per-Rupee Swaps Applied ⚡'
                      : 'Budget Override Warning ⚠️',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  list.budgetWarning ?? '',
                  style: const TextStyle(color: _textPrimary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProteinSwapsCard extends StatelessWidget {
  const _ProteinSwapsCard({required this.list});

  final OptimizedGroceryList list;

  @override
  Widget build(BuildContext context) {
    final swappedItems = list.items
        .where((i) => i.isSwappedSubstitute)
        .toList();

    return Container(
      key: const Key('grocery_protein_swaps_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentOrange.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.swap_horiz_rounded,
                    color: _accentOrange,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Protein Swap Suggestions',
                    style: TextStyle(
                      color: _accentOrange,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentGreen.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Saved ~₹${list.totalSavedInr.round()}/wk',
                  style: const TextStyle(
                    color: _accentGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final item in swappedItems)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text('⚡ ', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${item.originalItemName ?? "Premium Item"} ',
                            style: const TextStyle(
                              color: _textSecondary,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                          const TextSpan(
                            text: ' → ',
                            style: TextStyle(
                              color: _accentOrange,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: '${item.name} ',
                            style: const TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: '(₹${item.priceInr.round()})',
                            style: const TextStyle(
                              color: _accentGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryGroup extends ConsumerWidget {
  const _CategoryGroup({
    required this.title,
    required this.category,
    required this.items,
  });

  final String title;
  final GroceryCategory category;
  final List<GroceryItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catItems = items.where((i) => i.category == category).toList();
    if (catItems.isEmpty) return const SizedBox.shrink();

    return Card(
      color: _surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: _borderColor),
      ),
      margin: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            '$title (${catItems.length})',
            style: const TextStyle(
              color: _textPrimary,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          children: catItems.map((item) {
            return ListTile(
              leading: Checkbox(
                key: Key('grocery_checkbox_${item.id}'),
                value: item.isPurchased,
                activeColor: _accentOrange,
                onChanged: (_) {
                  ref
                      .read(groceryProvider.notifier)
                      .toggleItemPurchased(item.id);
                },
              ),
              title: Text(
                item.name,
                style: TextStyle(
                  color: item.isPurchased ? _textSecondary : _textPrimary,
                  decoration: item.isPurchased
                      ? TextDecoration.lineThrough
                      : null,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${item.unit} · ${item.proteinG.round()}g protein',
                style: const TextStyle(color: _textSecondary, fontSize: 11),
              ),
              trailing: Text(
                '₹${item.priceInr.round()}',
                style: const TextStyle(
                  color: _accentOrange,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _VendorCheckoutSection extends ConsumerWidget {
  const _VendorCheckoutSection({required this.state});

  final GroceryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(groceryProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_bag_rounded, color: _accentOrange, size: 20),
              SizedBox(width: 8),
              Text(
                'Quick-Commerce Vendor Checkout (§P16-E)',
                style: TextStyle(
                  color: _textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Export optimized shopping list basket directly to delivery app:',
            style: TextStyle(color: _textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Vendor selector tabs
          Row(
            children: [
              _VendorChip(
                vendor: VendorPartner.blinkit,
                label: 'Blinkit',
                isSelected: state.selectedVendor == VendorPartner.blinkit,
                onTap: () => notifier.setSelectedVendor(VendorPartner.blinkit),
              ),
              const SizedBox(width: 8),
              _VendorChip(
                vendor: VendorPartner.zepto,
                label: 'Zepto',
                isSelected: state.selectedVendor == VendorPartner.zepto,
                onTap: () => notifier.setSelectedVendor(VendorPartner.zepto),
              ),
              const SizedBox(width: 8),
              _VendorChip(
                vendor: VendorPartner.swiggyInstamart,
                label: 'Instamart',
                isSelected:
                    state.selectedVendor == VendorPartner.swiggyInstamart,
                onTap: () =>
                    notifier.setSelectedVendor(VendorPartner.swiggyInstamart),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Checkout Action Button
          ElevatedButton.icon(
            key: const Key('grocery_checkout_vendor_btn'),
            onPressed: () => notifier.simulateVendorCheckout(),
            icon: const Icon(Icons.rocket_launch_rounded),
            label: Text(
              'Checkout on ${switch (state.selectedVendor) {
                VendorPartner.blinkit => 'Blinkit',
                VendorPartner.zepto => 'Zepto',
                VendorPartner.swiggyInstamart => 'Swiggy Instamart',
              }}',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (state.isCheckoutSimulated) ...[
            const SizedBox(height: 14),
            Container(
              key: const Key('grocery_checkout_payload_box'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _accentGreen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: _accentGreen,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '1-Tap Checkout Payload Generated (Simulated)',
                        style: TextStyle(
                          color: _accentGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.checkoutPayload,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VendorChip extends StatelessWidget {
  const _VendorChip({
    required this.vendor,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final VendorPartner vendor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        key: Key('grocery_vendor_chip_${vendor.name}'),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? _accentOrange.withAlpha(40) : _surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? _accentOrange : _borderColor,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? _accentOrange : _textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
