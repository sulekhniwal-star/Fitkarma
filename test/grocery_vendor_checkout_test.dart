/// §P16-E Grocery Vendor Checkout Integration — Unit, Integration & Widget Tests

import 'package:fitkarma/features/affiliate/affiliate_models.dart';
import 'package:fitkarma/features/food/grocery_controller.dart';
import 'package:fitkarma/features/food/grocery_list_screen.dart';
import 'package:fitkarma/features/food/grocery_vendor_adapter.dart';
import 'package:fitkarma/features/food/grocery_vendor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const checkoutService = GroceryVendorCheckoutService();
  const blinkit = BlinkitAdapter();
  const zepto = ZeptoAdapter();
  const bigBasket = BigBasketAdapter();

  const items = [
    GroceryItemInput(name: 'Paneer (200g)', quantity: 1, unit: 'pack', estimatedPriceInr: 92.0),
    GroceryItemInput(name: 'Whole Wheat Bread', quantity: 1, unit: 'loaf', estimatedPriceInr: 55.0),
    GroceryItemInput(name: 'Tofu (250g)', quantity: 1, unit: 'pack', estimatedPriceInr: 85.0),
  ];

  Widget buildSubject() {
    return const ProviderScope(
      child: MaterialApp(
        home: GroceryListScreen(),
      ),
    );
  }

  group('§P16-E GroceryVendorAdapter Interface & Catalog Mapping Tests', () {
    test('BlinkitAdapter maps generic items to Blinkit SKUs', () async {
      final skus = await blinkit.mapToVendorCatalog(items);

      expect(skus, hasLength(3));
      expect(skus[0].vendorSku, equals('BLK-PNR-200'));
      expect(skus[0].vendorItemTitle, contains('Amul Fresh Paneer'));
      expect(skus[1].vendorSku, equals('BLK-WWB-400'));
    });

    test('BlinkitAdapter generates deep-link with pre-filled cart and ref=fitkarma_grocery', () async {
      final uri = await blinkit.buildCheckoutDeepLink(items: items, userId: 'usr_sharma');

      expect(uri.toString(), contains('https://blinkit.com/cart/add'));
      expect(uri.toString(), contains('skus=BLK-PNR-200,BLK-WWB-400,BLK-TFU-250'));
      expect(uri.toString(), contains('ref=fitkarma_grocery'));
      expect(uri.toString(), contains('user_ref=usr_sharma'));
    });

    test('ZeptoAdapter and BigBasketAdapter build vendor-specific deep links', () async {
      final zeptoUri = await zepto.buildCheckoutDeepLink(items: items, userId: 'usr_sharma');
      final bbUri = await bigBasket.buildCheckoutDeepLink(items: items, userId: 'usr_sharma');

      expect(zeptoUri.toString(), contains('https://zepto.in/checkout'));
      expect(zeptoUri.toString(), contains('affiliate=fitkarma_grocery'));

      expect(bbUri.toString(), contains('https://bigbasket.com/basket/add'));
      expect(bbUri.toString(), contains('ref=fitkarma_grocery'));
    });
  });

  group('§P16-E GroceryVendorCheckoutService & §P13-C Affiliate Ledger Reuse', () {
    test('prepareCheckout constructs complete checkout payload with calculated prices', () async {
      final payload = await checkoutService.prepareCheckout(
        items: items,
        adapter: blinkit,
        userId: 'usr_sharma',
      );

      expect(payload.vendorName, equals('Blinkit'));
      expect(payload.totalPriceInr, equals(232.0)); // 92 + 55 + 85 = 232
      expect(payload.deepLinkUri.toString(), contains('ref=fitkarma_grocery'));
    });

    test('processAffiliateOrderWebhook reuses §P13-C affiliate ledger (3% commission)', () {
      final ledgerEntry = checkoutService.processAffiliateOrderWebhook(
        orderId: 'ord_blk_9988',
        vendorName: 'Blinkit',
        orderAmountInr: 1000.0,
        referralCode: 'sharma10',
      );

      expect(ledgerEntry.source, equals(AffiliateSource.groceryCheckout));
      expect(ledgerEntry.commissionAmountInr, equals(30.0)); // 3% of ₹1000 = ₹30
      expect(ledgerEntry.grossAmountInr, equals(1000.0));
      expect(ledgerEntry.description, contains('Blinkit Grocery Checkout Order'));
    });
  });

  group('§P16-E Grocery Optimization UI "Order Groceries" CTA Widget Tests', () {
    testWidgets('renders Grocery Optimization screen and vendor checkout CTA section', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final headerFinder = find.textContaining('Grocery Optimization');
      await tester.ensureVisible(headerFinder);

      expect(headerFinder, findsOneWidget);
      expect(find.textContaining('Quick-Commerce Vendor Checkout'), findsOneWidget);
    });

    testWidgets('selects Zepto vendor and triggers vendor checkout simulation', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final zeptoFinder = find.text('Zepto');
      await tester.ensureVisible(zeptoFinder);
      await tester.tap(zeptoFinder);
      await tester.pumpAndSettle();

      final checkoutBtn = find.byKey(const Key('grocery_checkout_vendor_btn'));
      await tester.ensureVisible(checkoutBtn);
      await tester.tap(checkoutBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('Checkout on Zepto'), findsOneWidget);
    });
  });
}
