import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/brain/grocery_vendor_adapter.dart';
import 'package:fitkarma/features/nutrition/models/grocery_models.dart';
import 'package:fitkarma/features/premium/models/creator_affiliate_models.dart';

void main() {
  group('§P16-E Grocery Vendor Checkout Integration Tests', () {
    const blinkitAdapter = BlinkitAdapter();
    const bigBasketAdapter = BigBasketAdapter();
    const zeptoAdapter = ZeptoAdapter();
    const checkoutService = GroceryCheckoutService();

    final sampleItems = [
      const GroceryItem(
        id: 'paneer_200g',
        name: 'Fresh Malai Paneer',
        quantityGrams: 200,
        price: 120.0,
        proteinG: 36.0,
        category: FoodCategory.dairy,
      ),
      const GroceryItem(
        id: 'oats_500g',
        name: 'Rolled Oats',
        quantityGrams: 500,
        price: 180.0,
        proteinG: 65.0,
        category: FoodCategory.staples,
      ),
    ];

    test('Blinkit adapter builds valid pre-filled cart deep-link with affiliate tag', () async {
      final uri = await blinkitAdapter.buildCheckoutDeepLink(sampleItems);

      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('blinkit.com'));
      expect(uri.path, equals('/cart/add'));
      expect(uri.queryParameters['ref'], equals('fitkarma_grocery'));
      expect(uri.queryParameters['items'], contains('bl_fresh_malai_paneer_200g'));
      expect(uri.queryParameters['items'], contains('bl_rolled_oats_500g'));
    });

    test('BigBasket adapter builds valid pre-filled cart deep-link with affiliate tag', () async {
      final uri = await bigBasketAdapter.buildCheckoutDeepLink(sampleItems);

      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('bigbasket.com'));
      expect(uri.queryParameters['ref'], equals('fitkarma_grocery'));
      expect(uri.queryParameters['items'], contains('bb_paneer_200g_200'));
    });

    test('Zepto adapter builds valid pre-filled cart deep-link with affiliate tag', () async {
      final uri = await zeptoAdapter.buildCheckoutDeepLink(sampleItems);

      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('zeptonow.com'));
      expect(uri.queryParameters['ref'], equals('fitkarma_grocery'));
      expect(uri.queryParameters['items'], contains('zp_paneer_200g'));
    });

    test('CheckoutService records commission into §P13-C affiliate ledger schema', () {
      final payout = checkoutService.createAffiliateCommissionRecord(
        vendorName: 'Blinkit',
        cartTotalInr: 1000.0, // 5% = 50 INR
        commissionRate: 0.05,
      );

      expect(payout.amountInr, equals(50.0));
      expect(payout.status, equals(PayoutStatus.paid));
      expect(payout.payoutId, startsWith('aff_groc_blinkit_'));
    });
  });
}
