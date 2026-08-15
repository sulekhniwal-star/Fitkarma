// §P16-E Grocery Vendor Checkout Integration & Adapters (Pure Dart)
// Cross-reference: §P16-E, §P5-F, §P13-C in Fitkarma_documentation.md

import '../../features/nutrition/models/grocery_models.dart';
import '../../features/premium/models/creator_affiliate_models.dart';

/// Pluggable interface for grocery vendor partners per §P16-E
abstract class GroceryVendorAdapter {
  String get vendorName;
  String get logoKey;
  Future<Uri> buildCheckoutDeepLink(List<GroceryItem> items);
}

/// Blinkit Quick-Commerce Cart Adapter
class BlinkitAdapter implements GroceryVendorAdapter {
  const BlinkitAdapter();

  @override
  String get vendorName => 'Blinkit';

  @override
  String get logoKey => 'blinkit_logo';

  @override
  Future<Uri> buildCheckoutDeepLink(List<GroceryItem> items) async {
    final vendorItems = _mapToVendorCatalog(items);
    const affiliateTag = 'fitkarma_grocery';
    final encoded = _encodeItems(vendorItems);
    return Uri.parse(
      'https://blinkit.com/cart/add?items=$encoded&ref=$affiliateTag',
    );
  }

  List<String> _mapToVendorCatalog(List<GroceryItem> items) {
    // Maps generic grocery items to Blinkit product identifiers
    return items.map((item) {
      final sanitized = item.name.toLowerCase().replaceAll(' ', '_');
      return 'bl_${sanitized}_${item.quantityGrams.toInt()}g';
    }).toList();
  }

  String _encodeItems(List<String> vendorItems) => Uri.encodeComponent(vendorItems.join(','));
}

/// BigBasket Slotted / Instant Delivery Adapter
class BigBasketAdapter implements GroceryVendorAdapter {
  const BigBasketAdapter();

  @override
  String get vendorName => 'BigBasket';

  @override
  String get logoKey => 'bigbasket_logo';

  @override
  Future<Uri> buildCheckoutDeepLink(List<GroceryItem> items) async {
    final vendorItems = items.map((e) => 'bb_${e.id}_${e.quantityGrams.toInt()}').toList();
    const affiliateTag = 'fitkarma_grocery';
    final encoded = Uri.encodeComponent(vendorItems.join(','));
    return Uri.parse(
      'https://bigbasket.com/cart/add?items=$encoded&ref=$affiliateTag',
    );
  }
}

/// Zepto 10-Minute Grocery Delivery Adapter
class ZeptoAdapter implements GroceryVendorAdapter {
  const ZeptoAdapter();

  @override
  String get vendorName => 'Zepto';

  @override
  String get logoKey => 'zepto_logo';

  @override
  Future<Uri> buildCheckoutDeepLink(List<GroceryItem> items) async {
    final vendorItems = items.map((e) => 'zp_${e.id}').toList();
    const affiliateTag = 'fitkarma_grocery';
    final encoded = Uri.encodeComponent(vendorItems.join(','));
    return Uri.parse(
      'https://zeptonow.com/cart/add?items=$encoded&ref=$affiliateTag',
    );
  }
}

/// Grocery Checkout Service with Affiliate Ledger Re-use (§P16-E & §P13-C)
class GroceryCheckoutService {
  final List<GroceryVendorAdapter> supportedAdapters;

  const GroceryCheckoutService({
    this.supportedAdapters = const [
      BlinkitAdapter(),
      BigBasketAdapter(),
      ZeptoAdapter(),
    ],
  });

  /// Constructs affiliate order commission record reusing §P13-C ledger schema
  AffiliatePayout createAffiliateCommissionRecord({
    required String vendorName,
    required double cartTotalInr,
    double commissionRate = 0.05, // 5% affiliate kickback
  }) {
    final commissionAmount = cartTotalInr * commissionRate;
    final now = DateTime.now();
    return AffiliatePayout(
      payoutId: 'aff_groc_${vendorName.toLowerCase()}_${now.millisecondsSinceEpoch}',
      creatorId: 'fitkarma_affiliate_ledger',
      amountInr: double.parse(commissionAmount.toStringAsFixed(2)),
      periodStart: now,
      periodEnd: now,
      status: PayoutStatus.paid,
    );
  }
}
