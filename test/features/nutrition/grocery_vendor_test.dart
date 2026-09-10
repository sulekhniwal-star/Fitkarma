import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/nutrition/domain/grocery_vendor_models.dart';
import 'package:fitkarma/features/nutrition/domain/grocery_vendor_engine.dart';

void main() {
  group('GroceryVendorEngine Unit Tests', () {
    test(
        'generateDefaultCart generates vegetarian cart with ayurvedic essentials',
        () {
      final cart = GroceryVendorEngine.generateDefaultCart(
        isVegetarian: true,
        includeAyurvedicPantry: true,
      );

      expect(cart.isNotEmpty, isTrue);
      // Verify no chicken/eggs in vegetarian
      expect(cart.any((item) => item.id == 'chicken_breast'), isFalse);
      expect(cart.any((item) => item.id == 'fresh_eggs'), isFalse);

      // Verify Ayurvedic items present
      expect(cart.any((item) => item.id == 'a2_ghee'), isTrue);
      expect(cart.any((item) => item.id == 'sendha_namak'), isTrue);
      expect(cart.any((item) => item.id == 'lakadong_turmeric'), isTrue);
    });

    test(
        'generateDefaultCart includes non-veg protein sources when isVegetarian is false',
        () {
      final nonVegCart = GroceryVendorEngine.generateDefaultCart(
        isVegetarian: false,
        includeAyurvedicPantry: false,
      );

      expect(nonVegCart.any((item) => item.id == 'chicken_breast'), isTrue);
      expect(nonVegCart.any((item) => item.id == 'fresh_eggs'), isTrue);
      expect(nonVegCart.any((item) => item.id == 'a2_ghee'), isFalse);
    });

    test('compileCheckoutPayload compiles quotes for all 6 vendors', () {
      final items = GroceryVendorEngine.generateDefaultCart();
      final payload = GroceryVendorEngine.compileCheckoutPayload(
        items: items,
        pincode: '560001',
      );

      expect(payload.vendorQuotes.length, equals(6));
      expect(payload.pincode, equals('560001'));
      expect(payload.totalProteinYieldGrams, greaterThan(0));

      final blinkitQuote = payload.vendorQuotes
          .firstWhere((q) => q.vendor == GroceryVendorType.blinkit);
      final zeptoQuote = payload.vendorQuotes
          .firstWhere((q) => q.vendor == GroceryVendorType.zepto);
      final bbQuote = payload.vendorQuotes
          .firstWhere((q) => q.vendor == GroceryVendorType.bigBasket);

      expect(blinkitQuote.eta, equals('10-12 mins'));
      expect(
          blinkitQuote.deepLinkUrl.startsWith('blinkit://search?q='), isTrue);
      expect(
          zeptoQuote.deepLinkUrl.startsWith('zepto://search?query='), isTrue);
      expect(bbQuote.deepLinkUrl.startsWith('bigbasket://search?q='), isTrue);
    });

    test('compileCheckoutPayload correctly marks cheapest and fastest options',
        () {
      final items = GroceryVendorEngine.generateDefaultCart();
      final payload = GroceryVendorEngine.compileCheckoutPayload(items: items);

      final cheapestCount =
          payload.vendorQuotes.where((q) => q.isCheapest).length;
      expect(cheapestCount, greaterThanOrEqualTo(1));

      final fastestQuotes =
          payload.vendorQuotes.where((q) => q.isFastest).toList();
      expect(fastestQuotes.isNotEmpty, isTrue);
      expect(fastestQuotes.any((q) => q.vendor == GroceryVendorType.blinkit),
          isTrue);
    });

    test(
        'compileCheckoutPayload generates bilingual WhatsApp Kirana share text',
        () {
      final items = GroceryVendorEngine.generateDefaultCart();
      final payload = GroceryVendorEngine.compileCheckoutPayload(
          items: items, pincode: '110001');

      expect(
          payload.whatsappShareText, contains('FitKarma Smart Grocery List'));
      expect(payload.whatsappShareText, contains('*Pincode:* 110001'));
      expect(payload.whatsappShareText, contains('सोया बड़ी'));
      expect(payload.whatsappShareText, contains('अनुमानित कुल योग'));
    });

    test('VendorCartItem costPerGramProtein calculates accurately', () {
      const item = VendorCartItem(
        id: 'soya_test',
        name: 'Soya Chunks',
        regionalName: 'सोया',
        quantity: '500g',
        basePriceInr: 50,
        totalProteinGrams: 250.0,
        category: 'Protein',
      );

      expect(item.costPerGramProtein, equals(0.20));
    });

    test('Toggle items updates activeItemCount and protein totals correctly',
        () {
      final items = GroceryVendorEngine.generateDefaultCart();
      final originalPayload =
          GroceryVendorEngine.compileCheckoutPayload(items: items);

      final toggledItems = items
          .map((i) => i.id == 'soya_chunks' ? i.copyWith(isChecked: false) : i)
          .toList();
      final newPayload =
          GroceryVendorEngine.compileCheckoutPayload(items: toggledItems);

      expect(newPayload.activeItemCount,
          equals(originalPayload.activeItemCount - 1));
      expect(newPayload.totalProteinYieldGrams,
          lessThan(originalPayload.totalProteinYieldGrams));
    });
  });
}
