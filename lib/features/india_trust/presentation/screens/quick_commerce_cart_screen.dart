import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma/core/theme/app_colors.dart';
import 'package:fitkarma/core/theme/app_typography.dart';
import 'package:fitkarma/core/widgets/bento_card.dart';
import 'package:fitkarma/features/india_trust/domain/models/india_trust_models.dart';
import 'package:fitkarma/features/india_trust/domain/services/quick_commerce_engine.dart';

class QuickCommerceCartScreen extends ConsumerStatefulWidget {
  const QuickCommerceCartScreen({super.key});

  @override
  ConsumerState<QuickCommerceCartScreen> createState() => _QuickCommerceCartScreenState();
}

class _QuickCommerceCartScreenState extends ConsumerState<QuickCommerceCartScreen> {
  final _engine = const QuickCommerceEngine();
  late List<QuickCommerceBasketItem> _items;

  @override
  void initState() {
    super.initState();
    _items = _engine.getComparativeBasket(['paneer', 'tofu', 'curd', 'makhana', 'sprouts']);
  }

  @override
  Widget build(BuildContext context) {
    final cheapest = _engine.findCheapestPlatform(_items);

    int totalBlinkit = _items.fold(0, (sum, i) => sum + i.blinkitPriceInr);
    int totalZepto = _items.fold(0, (sum, i) => sum + i.zeptoPriceInr);
    int totalInstamart = _items.fold(0, (sum, i) => sum + i.instamartPriceInr);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Quick-Commerce Grocery Cart', style: AppTypography.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Best Price Comparative Header
            BentoCard(
              padding: const EdgeInsets.all(20),
              glowColor: AppColors.primaryEmerald,
              isGlowing: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RECOMMENDED STORE', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryEmerald.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('LOWEST PRICE', style: AppTypography.label.copyWith(color: AppColors.primaryEmerald, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cheapest.name.toUpperCase(), style: AppTypography.heroMetric.copyWith(fontSize: 32, color: AppColors.primaryCyan)),
                      Text('₹${cheapest == GroceryPlatform.zepto ? totalZepto : (cheapest == GroceryPlatform.instamart ? totalInstamart : totalBlinkit)}', style: AppTypography.heroMetric.copyWith(fontSize: 32)),
                    ],
                  ),
                  const Divider(color: AppColors.borderGlass, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStorePrice('Blinkit', '₹$totalBlinkit', cheapest == GroceryPlatform.blinkit),
                      _buildStorePrice('Zepto', '₹$totalZepto', cheapest == GroceryPlatform.zepto),
                      _buildStorePrice('Instamart', '₹$totalInstamart', cheapest == GroceryPlatform.instamart),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grocery Item List
            Text('Smart Grocery Ingredients (${_items.length} items)', style: AppTypography.h2),
            const SizedBox(height: 12),
            ..._items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BentoCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryEmerald, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.itemName, style: AppTypography.h3),
                            Text(item.quantityString, style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('₹${item.zeptoPriceInr}', style: AppTypography.h3.copyWith(color: AppColors.primaryEmerald)),
                          Text('Zepto', style: AppTypography.bilingualSub),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Export to App Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Exporting cart to ${cheapest.name.toUpperCase()}...'),
                      backgroundColor: AppColors.primaryEmerald,
                    ),
                  );
                },
                child: Text(
                  '1-Click Export Cart to ${cheapest.name.toUpperCase()}',
                  style: AppTypography.h3.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorePrice(String store, String price, bool isCheapest) {
    return Column(
      children: [
        Text(price, style: AppTypography.h3.copyWith(color: isCheapest ? AppColors.primaryEmerald : AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(store, style: AppTypography.label.copyWith(color: isCheapest ? AppColors.primaryEmerald : AppColors.textSecondary)),
      ],
    );
  }
}
