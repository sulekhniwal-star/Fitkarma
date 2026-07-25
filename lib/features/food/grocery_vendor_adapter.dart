/// §P16-E Grocery Vendor Checkout Integration — Vendor Adapter Interface & Implementations
///
/// Pluggable GroceryVendorAdapter interface with Blinkit, Zepto, and BigBasket vendor implementations,
/// generic catalog to vendor SKU mapping, and deep-link checkout with affiliate tag matching §P16-E spec.
library;

class GroceryItemInput {
  const GroceryItemInput({
    required this.name,
    required this.quantity,
    required this.unit,
    this.estimatedPriceInr = 100.0,
  });

  final String name;
  final double quantity;
  final String unit;
  final double estimatedPriceInr;
}

class VendorMappedSku {
  const VendorMappedSku({
    required this.genericName,
    required this.vendorSku,
    required this.vendorItemTitle,
    required this.priceInr,
  });

  final String genericName;
  final String vendorSku;
  final String vendorItemTitle;
  final double priceInr;
}

abstract class GroceryVendorAdapter {
  String get vendorName;
  String get vendorId;
  String get deliveryEstimate;

  /// Maps generic FitKarma grocery items to vendor product catalog SKUs (§P16-E spec).
  Future<List<VendorMappedSku>> mapToVendorCatalog(List<GroceryItemInput> items);

  /// Builds deep-link checkout URL with pre-filled cart and affiliate tag (§P16-E spec).
  Future<Uri> buildCheckoutDeepLink({
    required List<GroceryItemInput> items,
    required String userId,
    String affiliateTag = 'fitkarma_grocery',
  });
}

class BlinkitAdapter implements GroceryVendorAdapter {
  const BlinkitAdapter();

  @override
  String get vendorName => 'Blinkit';
  @override
  String get vendorId => 'blinkit';
  @override
  String get deliveryEstimate => '10 mins';

  @override
  Future<List<VendorMappedSku>> mapToVendorCatalog(List<GroceryItemInput> items) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return items.map((item) {
      final nameLower = item.name.toLowerCase();
      if (nameLower.contains('paneer')) {
        return VendorMappedSku(
          genericName: item.name,
          vendorSku: 'BLK-PNR-200',
          vendorItemTitle: 'Amul Fresh Paneer 200g',
          priceInr: 92.0,
        );
      }
      if (nameLower.contains('tofu')) {
        return VendorMappedSku(
          genericName: item.name,
          vendorSku: 'BLK-TFU-250',
          vendorItemTitle: 'Organic Soya Tofu 250g',
          priceInr: 85.0,
        );
      }
      if (nameLower.contains('bread') || nameLower.contains('wheat')) {
        return VendorMappedSku(
          genericName: item.name,
          vendorSku: 'BLK-WWB-400',
          vendorItemTitle: 'Britannia 100% Whole Wheat Bread 400g',
          priceInr: 55.0,
        );
      }
      return VendorMappedSku(
        genericName: item.name,
        vendorSku: 'BLK-GEN-${item.name.hashCode.abs()}',
        vendorItemTitle: 'Fresh ${item.name} (${item.quantity.toInt()} ${item.unit})',
        priceInr: item.estimatedPriceInr,
      );
    }).toList();
  }

  @override
  Future<Uri> buildCheckoutDeepLink({
    required List<GroceryItemInput> items,
    required String userId,
    String affiliateTag = 'fitkarma_grocery',
  }) async {
    final skus = await mapToVendorCatalog(items);
    final skuParam = skus.map((s) => s.vendorSku).join(',');
    return Uri.parse(
      'https://blinkit.com/cart/add?skus=$skuParam&ref=$affiliateTag&user_ref=$userId',
    );
  }
}

class ZeptoAdapter implements GroceryVendorAdapter {
  const ZeptoAdapter();

  @override
  String get vendorName => 'Zepto';
  @override
  String get vendorId => 'zepto';
  @override
  String get deliveryEstimate => '10 mins';

  @override
  Future<List<VendorMappedSku>> mapToVendorCatalog(List<GroceryItemInput> items) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return items.map((item) {
      return VendorMappedSku(
        genericName: item.name,
        vendorSku: 'ZEP-SKU-${item.name.hashCode.abs()}',
        vendorItemTitle: 'Zepto Fresh ${item.name}',
        priceInr: item.estimatedPriceInr,
      );
    }).toList();
  }

  @override
  Future<Uri> buildCheckoutDeepLink({
    required List<GroceryItemInput> items,
    required String userId,
    String affiliateTag = 'fitkarma_grocery',
  }) async {
    final skus = await mapToVendorCatalog(items);
    final skuParam = skus.map((s) => s.vendorSku).join(',');
    return Uri.parse(
      'https://zepto.in/checkout?items=$skuParam&affiliate=$affiliateTag&sub_id=$userId',
    );
  }
}

class BigBasketAdapter implements GroceryVendorAdapter {
  const BigBasketAdapter();

  @override
  String get vendorName => 'BigBasket';
  @override
  String get vendorId => 'bigbasket';
  @override
  String get deliveryEstimate => 'Same day';

  @override
  Future<List<VendorMappedSku>> mapToVendorCatalog(List<GroceryItemInput> items) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return items.map((item) {
      return VendorMappedSku(
        genericName: item.name,
        vendorSku: 'BB-SKU-${item.name.hashCode.abs()}',
        vendorItemTitle: 'bb Popular ${item.name}',
        priceInr: item.estimatedPriceInr,
      );
    }).toList();
  }

  @override
  Future<Uri> buildCheckoutDeepLink({
    required List<GroceryItemInput> items,
    required String userId,
    String affiliateTag = 'fitkarma_grocery',
  }) async {
    final skus = await mapToVendorCatalog(items);
    final skuParam = skus.map((s) => s.vendorSku).join(',');
    return Uri.parse(
      'https://bigbasket.com/basket/add?skus=$skuParam&ref=$affiliateTag',
    );
  }
}
