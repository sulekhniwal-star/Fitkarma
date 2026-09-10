enum GroceryVendorType {
  blinkit,
  zepto,
  instamart,
  bigBasket,
  amazonFresh,
  localKirana,
}

extension GroceryVendorTypeExtension on GroceryVendorType {
  String get displayName {
    switch (this) {
      case GroceryVendorType.blinkit:
        return 'Blinkit';
      case GroceryVendorType.zepto:
        return 'Zepto';
      case GroceryVendorType.instamart:
        return 'Swiggy Instamart';
      case GroceryVendorType.bigBasket:
        return 'Tata BigBasket';
      case GroceryVendorType.amazonFresh:
        return 'Amazon Fresh';
      case GroceryVendorType.localKirana:
        return 'Local Kirana (किराना)';
    }
  }

  String get hindiName {
    switch (this) {
      case GroceryVendorType.blinkit:
        return 'ब्लिंकिट (10 मिनट)';
      case GroceryVendorType.zepto:
        return 'ज़ेप्टो (10 मिनट)';
      case GroceryVendorType.instamart:
        return 'स्विगी इंस्टामार्ट';
      case GroceryVendorType.bigBasket:
        return 'टाटा बिगबास्केट (बचत)';
      case GroceryVendorType.amazonFresh:
        return 'अमेज़न फ्रेश';
      case GroceryVendorType.localKirana:
        return 'नजदीकी किराना दुकान';
    }
  }

  String get deliveryEta {
    switch (this) {
      case GroceryVendorType.blinkit:
        return '10-12 mins';
      case GroceryVendorType.zepto:
        return '10-15 mins';
      case GroceryVendorType.instamart:
        return '12-18 mins';
      case GroceryVendorType.bigBasket:
        return 'Same Day / 2 hrs';
      case GroceryVendorType.amazonFresh:
        return 'Next Morning Slot';
      case GroceryVendorType.localKirana:
        return 'Instant Pickup / Call';
    }
  }

  String get brandColorHex {
    switch (this) {
      case GroceryVendorType.blinkit:
        return '#F8CB46'; // Yellow
      case GroceryVendorType.zepto:
        return '#8A2BE2'; // Purple
      case GroceryVendorType.instamart:
        return '#FC8019'; // Swiggy Orange
      case GroceryVendorType.bigBasket:
        return '#84C225'; // BB Green
      case GroceryVendorType.amazonFresh:
        return '#007185'; // Amazon Teal
      case GroceryVendorType.localKirana:
        return '#2E7D32'; // Kirana Green
    }
  }

  String get appDeepLinkPrefix {
    switch (this) {
      case GroceryVendorType.blinkit:
        return 'blinkit://search?q=';
      case GroceryVendorType.zepto:
        return 'zepto://search?query=';
      case GroceryVendorType.instamart:
        return 'swiggy://instamart/search?query=';
      case GroceryVendorType.bigBasket:
        return 'bigbasket://search?q=';
      case GroceryVendorType.amazonFresh:
        return 'https://www.amazon.in/s?k=';
      case GroceryVendorType.localKirana:
        return 'https://wa.me/?text=';
    }
  }

  String get fallbackWebUrlPrefix {
    switch (this) {
      case GroceryVendorType.blinkit:
        return 'https://blinkit.com/s/?q=';
      case GroceryVendorType.zepto:
        return 'https://zeptonow.com/search?query=';
      case GroceryVendorType.instamart:
        return 'https://www.swiggy.com/instamart/search?query=';
      case GroceryVendorType.bigBasket:
        return 'https://www.bigbasket.com/ps/?q=';
      case GroceryVendorType.amazonFresh:
        return 'https://www.amazon.in/s?k=';
      case GroceryVendorType.localKirana:
        return 'https://api.whatsapp.com/send?text=';
    }
  }
}

class VendorCartItem {
  final String id;
  final String name;
  final String regionalName;
  final String quantity;
  final int basePriceInr;
  final double totalProteinGrams;
  final String category;
  final bool isAyurvedicEssential;
  final String ayurvedicBenefit;
  final bool isChecked;

  const VendorCartItem({
    required this.id,
    required this.name,
    required this.regionalName,
    required this.quantity,
    required this.basePriceInr,
    required this.totalProteinGrams,
    required this.category,
    this.isAyurvedicEssential = false,
    this.ayurvedicBenefit = '',
    this.isChecked = true,
  });

  double get costPerGramProtein => totalProteinGrams > 0
      ? double.parse((basePriceInr / totalProteinGrams).toStringAsFixed(2))
      : 0.0;

  VendorCartItem copyWith({
    bool? isChecked,
    int? basePriceInr,
    String? quantity,
  }) {
    return VendorCartItem(
      id: id,
      name: name,
      regionalName: regionalName,
      quantity: quantity ?? this.quantity,
      basePriceInr: basePriceInr ?? this.basePriceInr,
      totalProteinGrams: totalProteinGrams,
      category: category,
      isAyurvedicEssential: isAyurvedicEssential,
      ayurvedicBenefit: ayurvedicBenefit,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

class VendorPriceQuote {
  final GroceryVendorType vendor;
  final int itemsSubtotalInr;
  final int deliveryFeeInr;
  final int handlingFeeInr;
  final int discountInr;
  final int totalPayableInr;
  final String eta;
  final bool isFastest;
  final bool isCheapest;
  final String searchCartQuery;
  final String deepLinkUrl;
  final String webFallbackUrl;

  const VendorPriceQuote({
    required this.vendor,
    required this.itemsSubtotalInr,
    required this.deliveryFeeInr,
    required this.handlingFeeInr,
    required this.discountInr,
    required this.totalPayableInr,
    required this.eta,
    this.isFastest = false,
    this.isCheapest = false,
    required this.searchCartQuery,
    required this.deepLinkUrl,
    required this.webFallbackUrl,
  });
}

class GroceryVendorCheckoutPayload {
  final String planId;
  final DateTime timestamp;
  final List<VendorCartItem> items;
  final int activeItemCount;
  final double totalProteinYieldGrams;
  final List<VendorPriceQuote> vendorQuotes;
  final GroceryVendorType recommendedVendor;
  final String whatsappShareText;
  final String pincode;

  const GroceryVendorCheckoutPayload({
    required this.planId,
    required this.timestamp,
    required this.items,
    required this.activeItemCount,
    required this.totalProteinYieldGrams,
    required this.vendorQuotes,
    required this.recommendedVendor,
    required this.whatsappShareText,
    required this.pincode,
  });
}
