/// §P16-E Grocery Vendor Checkout Service & Affiliate Webhook Handler
///
/// Manages vendor deep-link checkout creation and processes affiliate order confirmation webhooks,
/// reusing the §P13-C affiliate ledger for 3% grocery revenue tracking matching §P16-E spec.
library;

import 'package:fitkarma/features/affiliate/affiliate_models.dart';
import 'package:fitkarma/features/affiliate/affiliate_tracking_engine.dart';
import 'grocery_vendor_adapter.dart';

class GroceryCheckoutPayload {
  const GroceryCheckoutPayload({
    required this.vendorName,
    required this.deepLinkUri,
    required this.mappedSkus,
    required this.totalPriceInr,
  });

  final String vendorName;
  final Uri deepLinkUri;
  final List<VendorMappedSku> mappedSkus;
  final double totalPriceInr;
}

class GroceryVendorCheckoutService {
  const GroceryVendorCheckoutService({
    this.affiliateEngine = const AffiliateTrackingEngine(),
  });

  final AffiliateTrackingEngine affiliateEngine;

  /// Executes catalog mapping and generates pre-filled cart deep-link with affiliate tag (§P16-E spec).
  Future<GroceryCheckoutPayload> prepareCheckout({
    required List<GroceryItemInput> items,
    required GroceryVendorAdapter adapter,
    required String userId,
  }) async {
    final mappedSkus = await adapter.mapToVendorCatalog(items);
    final deepLink = await adapter.buildCheckoutDeepLink(items: items, userId: userId);

    final totalPrice = mappedSkus.fold(0.0, (sum, s) => sum + s.priceInr);

    return GroceryCheckoutPayload(
      vendorName: adapter.vendorName,
      deepLinkUri: deepLink,
      mappedSkus: mappedSkus,
      totalPriceInr: totalPrice,
    );
  }

  /// Processes affiliate order confirmation webhook (§P16-E spec).
  /// Reuses §P13-C affiliate ledger for revenue tracking (3% commission rate).
  AffiliateLedgerEntry processAffiliateOrderWebhook({
    required String orderId,
    required String vendorName,
    required double orderAmountInr,
    required String referralCode,
  }) {
    final entry = affiliateEngine.trackGroceryAffiliateOrder(
      affiliateId: referralCode,
      vendorName: vendorName,
      orderId: orderId,
      orderTotalInr: orderAmountInr,
    );

    assert(entry.source == AffiliateSource.groceryCheckout, 'Must use groceryCheckout source');
    return entry;
  }
}
