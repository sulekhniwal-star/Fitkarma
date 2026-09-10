import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_typography.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/glowing_metric.dart';
import '../domain/grocery_vendor_models.dart';
import '../providers/grocery_vendor_provider.dart';

class GroceryVendorCheckoutScreen extends ConsumerStatefulWidget {
  const GroceryVendorCheckoutScreen({super.key});

  @override
  ConsumerState<GroceryVendorCheckoutScreen> createState() => _GroceryVendorCheckoutScreenState();
}

class _GroceryVendorCheckoutScreenState extends ConsumerState<GroceryVendorCheckoutScreen> {
  final TextEditingController _pincodeController = TextEditingController(text: '110001');

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  void _showCheckoutDialog(BuildContext context, VendorPriceQuote quote, String whatsappText) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order on ${quote.vendor.displayName}',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Estimated Total: ₹${quote.totalPayableInr} (${quote.eta})',
                style: const TextStyle(color: AppColors.karmaGreen, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                quote.vendor == GroceryVendorType.localKirana
                    ? 'FitKarma generated a formatted WhatsApp shopping list. You can share it directly with your neighborhood Kirana store or family.'
                    : 'FitKarma creates a direct deep-link pre-loaded with your nutrition cart query for instant checkout in the ${quote.vendor.displayName} app.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.glassBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copy Payload'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: whatsappText));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cart details & list copied to clipboard!')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.karmaGreen,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: Icon(quote.vendor == GroceryVendorType.localKirana ? Icons.share : Icons.shopping_bag_outlined, size: 18),
                      label: Text(quote.vendor == GroceryVendorType.localKirana ? 'Share WhatsApp' : 'Open App'),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              quote.vendor == GroceryVendorType.localKirana
                                  ? 'Dispatching shopping list to WhatsApp...'
                                  : 'Dispatching deep-link to ${quote.vendor.displayName} (${quote.deepLinkUrl})...',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groceryVendorProvider);
    final notifier = ref.read(groceryVendorProvider.notifier);
    final currentQuote = notifier.selectedVendorQuote;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const BilingualLabel(
          primaryText: 'Quick Grocery & Quick-Commerce',
          regionalText: 'क्विक-कॉमर्स एवं किराना चेकआउट',
          alignment: CrossAxisAlignment.center,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.karmaGreen),
            tooltip: 'Share WhatsApp Kirana List',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: state.payload.whatsappShareText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bilingual WhatsApp Kirana list copied!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Pincode & Delivery Area Bento
              BentoCard(
                backgroundColor: AppColors.surfaceElevated,
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.karmaGreen, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Delivery Pincode: ${state.pincode}',
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: const Text('Change Pincode', style: TextStyle(color: AppColors.textPrimary)),
                            content: TextField(
                              controller: _pincodeController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Enter 6-digit Pincode (e.g. 560001, 110001)',
                                hintStyle: TextStyle(color: AppColors.textMuted),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.karmaGreen),
                                onPressed: () {
                                  if (_pincodeController.text.isNotEmpty) {
                                    notifier.updatePincode(_pincodeController.text.trim());
                                  }
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Save', style: TextStyle(color: AppColors.background)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Change',
                        style: TextStyle(color: AppColors.focusBlue, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // 2. Preference Toggles (Veg / Ayurvedic)
              Row(
                children: [
                  Expanded(
                    child: FilterChip(
                      selected: state.isVegetarian,
                      label: const Text('🌱 100% शाकाहारी'),
                      selectedColor: AppColors.karmaGreen.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.karmaGreen,
                      onSelected: (val) => notifier.setDietaryPreference(val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilterChip(
                      selected: state.includeAyurvedicPantry,
                      label: const Text('🌿 आयुर्वेदिक सुपरफूड'),
                      selectedColor: AppColors.focusBlue.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.focusBlue,
                      onSelected: (val) => notifier.toggleAyurvedicPantry(val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Multi-Vendor Price & Speed Matrix Bento Card
              BentoCard(
                hasGlow: true,
                glowColor: AppColors.karmaGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BilingualLabel(
                          primaryText: 'Live Vendor Price Matrix',
                          regionalText: 'कीमत एवं डिलीवरी समय तुलना',
                        ),
                        Icon(Icons.compare_arrows_rounded, color: AppColors.karmaGreen, size: 20),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.payload.vendorQuotes.map((quote) {
                          final isSelected = quote.vendor == state.selectedVendor;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => notifier.selectVendor(quote.vendor),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.surfaceElevated : AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColors.karmaGreen : AppColors.glassBorder,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          quote.vendor.displayName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                          ),
                                        ),
                                        if (quote.isCheapest) ...[
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppColors.karmaGreen,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('BEST PRICE', style: TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.w900)),
                                          ),
                                        ],
                                        if (quote.isFastest && !quote.isCheapest) ...[
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: AppColors.energyOrange,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text('10 MINS', style: TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.w900)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${quote.totalPayableInr}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected ? AppColors.karmaGreen : AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      quote.eta,
                                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Hero Summary & Checkout Action Banner
              if (currentQuote != null)
                BentoCard(
                  backgroundColor: AppColors.surfaceElevated,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GlowingMetric(
                            label: 'Selected Vendor',
                            value: currentQuote.vendor.displayName,
                            unit: currentQuote.eta,
                            accentColor: AppColors.focusBlue,
                          ),
                          GlowingMetric(
                            label: 'Total Payable',
                            value: '₹${currentQuote.totalPayableInr}',
                            unit: 'incl. taxes',
                            isHero: true,
                            accentColor: AppColors.karmaGreen,
                          ),
                          GlowingMetric(
                            label: 'Protein Yield',
                            value: '${state.payload.totalProteinYieldGrams.round()}g',
                            unit: '${state.payload.activeItemCount} items',
                            accentColor: AppColors.energyOrange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.karmaGreen,
                            foregroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: Icon(
                            currentQuote.vendor == GroceryVendorType.localKirana ? Icons.share : Icons.shopping_cart_checkout_rounded,
                            size: 20,
                          ),
                          label: Text(
                            currentQuote.vendor == GroceryVendorType.localKirana
                                ? 'Send Order to Local Kirana (WhatsApp)'
                                : '1-Tap Checkout on ${currentQuote.vendor.displayName}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _showCheckoutDialog(context, currentQuote, state.payload.whatsappShareText),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // 5. Categorized Grocery Checklist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CART ITEMS (${state.payload.activeItemCount})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '₹${state.payload.items.where((i) => i.isChecked).fold<int>(0, (s, i) => s + i.basePriceInr)} Estimated Base',
                    style: const TextStyle(fontSize: 11, color: AppColors.karmaGreen, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = state.items[index];

                  return BentoCard(
                    onTap: () => notifier.toggleItem(item.id),
                    backgroundColor: item.isChecked ? AppColors.surface : AppColors.surfaceElevated.withValues(alpha: 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: item.isChecked,
                              activeColor: AppColors.karmaGreen,
                              onChanged: (_) => notifier.toggleItem(item.id),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: AppTypography.titleSmall.copyWith(
                                            fontSize: 13,
                                            decoration: item.isChecked ? null : TextDecoration.lineThrough,
                                            color: item.isChecked ? AppColors.textPrimary : AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                      if (item.isAyurvedicEssential)
                                        Container(
                                          margin: const EdgeInsets.only(left: 4),
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.focusBlue.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('🌿 AYURVEDIC', style: TextStyle(fontSize: 8, color: AppColors.focusBlue, fontWeight: FontWeight.w800)),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    '${item.regionalName} • ${item.quantity}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${item.basePriceInr}',
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.karmaGreen, fontSize: 13),
                                ),
                                if (item.totalProteinGrams > 0)
                                  Text(
                                    '+${item.totalProteinGrams.round()}g P',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (item.ayurvedicBenefit.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.only(left: 44),
                            child: Text(
                              '• ${item.ayurvedicBenefit}',
                              style: TextStyle(fontSize: 10, color: AppColors.textMuted.withValues(alpha: 0.8), fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
