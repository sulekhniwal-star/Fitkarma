import '../models/india_trust_models.dart';

class QuickCommerceEngine {
  const QuickCommerceEngine();

  /// Curated comparative grocery pricing basket across Blinkit, Zepto, and Instamart
  List<QuickCommerceBasketItem> getComparativeBasket(List<String> ingredientNames) {
    final Map<String, QuickCommerceBasketItem> catalog = {
      'paneer': const QuickCommerceBasketItem(
        itemName: 'Amul Malai Fresh Paneer (200g)',
        quantityString: '200g',
        blinkitPriceInr: 92,
        zeptoPriceInr: 89,
        instamartPriceInr: 90,
      ),
      'tofu': const QuickCommerceBasketItem(
        itemName: 'Organic Soya Tofu (200g)',
        quantityString: '200g',
        blinkitPriceInr: 75,
        zeptoPriceInr: 72,
        instamartPriceInr: 74,
      ),
      'curd': const QuickCommerceBasketItem(
        itemName: 'Epigamia High Protein Greek Yogurt (100g)',
        quantityString: '100g',
        blinkitPriceInr: 60,
        zeptoPriceInr: 60,
        instamartPriceInr: 58,
      ),
      'atta': const QuickCommerceBasketItem(
        itemName: 'Aashirvaad Shudh Chakki Atta (5kg)',
        quantityString: '5kg',
        blinkitPriceInr: 245,
        zeptoPriceInr: 239,
        instamartPriceInr: 242,
      ),
      'makhana': const QuickCommerceBasketItem(
        itemName: 'Premium Phool Makhana (Foxnuts 200g)',
        quantityString: '200g',
        blinkitPriceInr: 185,
        zeptoPriceInr: 179,
        instamartPriceInr: 180,
      ),
      'sprouts': const QuickCommerceBasketItem(
        itemName: 'Fresh Mixed Moong & Chana Sprouts (200g)',
        quantityString: '200g',
        blinkitPriceInr: 45,
        zeptoPriceInr: 42,
        instamartPriceInr: 44,
      ),
    };

    final List<QuickCommerceBasketItem> result = [];
    for (final name in ingredientNames) {
      final key = name.toLowerCase();
      final found = catalog.entries.firstWhere(
        (entry) => key.contains(entry.key),
        orElse: () => MapEntry(
          'generic',
          QuickCommerceBasketItem(
            itemName: name,
            quantityString: '1 pack',
            blinkitPriceInr: 80,
            zeptoPriceInr: 78,
            instamartPriceInr: 79,
          ),
        ),
      );
      result.add(found.value);
    }

    return result.isEmpty ? catalog.values.toList() : result;
  }

  /// Calculates lowest cost platform for given basket
  GroceryPlatform findCheapestPlatform(List<QuickCommerceBasketItem> items) {
    int totalBlinkit = 0;
    int totalZepto = 0;
    int totalInstamart = 0;

    for (final item in items) {
      totalBlinkit += item.blinkitPriceInr;
      totalZepto += item.zeptoPriceInr;
      totalInstamart += item.instamartPriceInr;
    }

    if (totalZepto <= totalBlinkit && totalZepto <= totalInstamart) {
      return GroceryPlatform.zepto;
    } else if (totalInstamart <= totalBlinkit) {
      return GroceryPlatform.instamart;
    } else {
      return GroceryPlatform.blinkit;
    }
  }

  /// Generates deep link URI for 1-click cart addition
  String generateDeepLink({
    required GroceryPlatform platform,
    required List<QuickCommerceBasketItem> items,
  }) {
    final query = items.map((i) => Uri.encodeComponent(i.itemName)).join(',');
    switch (platform) {
      case GroceryPlatform.blinkit:
        return 'blinkit://cart/add?items=$query';
      case GroceryPlatform.zepto:
        return 'zepto://search?query=$query';
      case GroceryPlatform.instamart:
        return 'swiggy://instamart/search?query=$query';
    }
  }
}
