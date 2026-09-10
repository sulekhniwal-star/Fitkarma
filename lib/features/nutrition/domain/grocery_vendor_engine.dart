import 'grocery_vendor_models.dart';

class GroceryVendorEngine {
  /// Pure Dart deterministic generator for quick-commerce grocery carts
  static List<VendorCartItem> generateDefaultCart({
    bool isVegetarian = true,
    bool includeAyurvedicPantry = true,
  }) {
    final List<VendorCartItem> items = [
      // 1. High-Density Protein Staples
      const VendorCartItem(
        id: 'soya_chunks',
        name: 'Soya Chunks (Nutrela)',
        regionalName: 'सोया बड़ी',
        quantity: '500g',
        basePriceInr: 55,
        totalProteinGrams: 260.0,
        category: 'Protein Staples',
      ),
      const VendorCartItem(
        id: 'chana_sattu',
        name: 'Roasted Chana Sattu',
        regionalName: 'भुना चना सत्तू',
        quantity: '1 kg',
        basePriceInr: 120,
        totalProteinGrams: 250.0,
        category: 'Protein Staples',
        isAyurvedicEssential: true,
        ayurvedicBenefit: 'शीतल (Pitta pacifying) natural high-fiber cooling protein',
      ),
      const VendorCartItem(
        id: 'moong_sprouts',
        name: 'Whole Green Moong (Sprouting)',
        regionalName: 'साबुत हरा मूंग',
        quantity: '1 kg',
        basePriceInr: 140,
        totalProteinGrams: 240.0,
        category: 'Protein Staples',
        isAyurvedicEssential: true,
        ayurvedicBenefit: 'लघु (Light to digest), Tridosha balancing clean protein',
      ),
      const VendorCartItem(
        id: 'paneer_curd',
        name: 'Low-Fat Fresh Paneer & Dahi',
        regionalName: 'ताजा पनीर व दही',
        quantity: '1 kg paneer + 1 kg curd',
        basePriceInr: 450,
        totalProteinGrams: 250.0,
        category: 'Protein Staples',
      ),

      if (!isVegetarian) ...[
        const VendorCartItem(
          id: 'fresh_eggs',
          name: 'Farm Fresh Brown Eggs',
          regionalName: 'देसी अंडे',
          quantity: '30 pcs',
          basePriceInr: 220,
          totalProteinGrams: 180.0,
          category: 'Protein Staples',
        ),
        const VendorCartItem(
          id: 'chicken_breast',
          name: 'Fresh Chicken Breast (Boneless)',
          regionalName: 'चिकन ब्रेस्ट',
          quantity: '1 kg',
          basePriceInr: 280,
          totalProteinGrams: 300.0,
          category: 'Protein Staples',
        ),
      ],

      // 2. Fresh Produce & Greens
      const VendorCartItem(
        id: 'palak_methi',
        name: 'Fresh Spinach (Palak) & Methi',
        regionalName: 'पालक व मेथी साग',
        quantity: '1 kg',
        basePriceInr: 60,
        totalProteinGrams: 28.0,
        category: 'Produce & Greens',
      ),
      const VendorCartItem(
        id: 'cucumbers_tomatoes',
        name: 'Salad Cucumbers & Desi Tomatoes',
        regionalName: 'खीरा व देशी टमाटर',
        quantity: '2 kg',
        basePriceInr: 80,
        totalProteinGrams: 15.0,
        category: 'Produce & Greens',
      ),

      // 3. Whole Grains & Millets
      const VendorCartItem(
        id: 'multigrain_atta',
        name: 'Multigrain / Khapli Wheat Atta',
        regionalName: 'खपली गेहूं / मल्टीग्रेन आटा',
        quantity: '5 kg',
        basePriceInr: 240,
        totalProteinGrams: 600.0,
        category: 'Grains & Carbs',
      ),
      const VendorCartItem(
        id: 'foxtail_millet',
        name: 'Foxtail Millet (Kangni)',
        regionalName: 'कंगनी बाजरा / श्रीअन्न',
        quantity: '1 kg',
        basePriceInr: 110,
        totalProteinGrams: 110.0,
        category: 'Grains & Carbs',
        isAyurvedicEssential: true,
        ayurvedicBenefit: 'मधुर-कषाय (Low Glycemic), Rich in Magnesium and micronutrients',
      ),

      // 4. Ayurvedic Seasonal & Healing Pantry (Optional toggled)
      if (includeAyurvedicPantry) ...[
        const VendorCartItem(
          id: 'a2_ghee',
          name: 'A2 Desi Cow Bilona Ghee',
          regionalName: 'ए2 बिलोना देसी घी',
          quantity: '500 ml',
          basePriceInr: 580,
          totalProteinGrams: 0.0,
          category: 'Ayurvedic Superfoods',
          isAyurvedicEssential: true,
          ayurvedicBenefit: 'ओजस वर्धक (Strengthens Ojas & Fat-soluble Vitamin transport)',
        ),
        const VendorCartItem(
          id: 'sendha_namak',
          name: 'Pink Himalayan Rock Salt (Sendha Namak)',
          regionalName: 'सेंधा नमक',
          quantity: '1 kg',
          basePriceInr: 65,
          totalProteinGrams: 0.0,
          category: 'Ayurvedic Superfoods',
          isAyurvedicEssential: true,
          ayurvedicBenefit: 'दीपन-पाचन (Enhances digestive fire, non-bloating sodium)',
        ),
        const VendorCartItem(
          id: 'lakadong_turmeric',
          name: 'Organic Lakadong Turmeric (High Curcumin)',
          regionalName: 'लकाडोंग हल्दी चूर्ण',
          quantity: '200g',
          basePriceInr: 110,
          totalProteinGrams: 16.0,
          category: 'Ayurvedic Superfoods',
          isAyurvedicEssential: true,
          ayurvedicBenefit: 'शोथहर (Potent Anti-inflammatory & Recovery Accelerator)',
        ),
      ],
    ];

    return items;
  }

  /// Compile quotes and comparison matrix for all major Indian grocery vendors
  static GroceryVendorCheckoutPayload compileCheckoutPayload({
    required List<VendorCartItem> items,
    String pincode = '110001',
    String? planId,
  }) {
    final activeItems = items.where((i) => i.isChecked).toList();

    final int baseSubtotal = activeItems.fold<int>(0, (sum, i) => sum + i.basePriceInr);
    final double totalProtein = activeItems.fold<double>(0.0, (sum, i) => sum + i.totalProteinGrams);

    // Build unified search query string
    final itemQueryTokens = activeItems.map((e) => e.name.split(' ').first).take(6).join(', ');
    final encodedQuery = Uri.encodeComponent(itemQueryTokens.isNotEmpty ? itemQueryTokens : 'groceries');

    final quotes = <VendorPriceQuote>[];

    for (final vendor in GroceryVendorType.values) {
      int itemSubtotal = baseSubtotal;
      int deliveryFee = 0;
      int handlingFee = 0;
      int discount = 0;

      switch (vendor) {
        case GroceryVendorType.blinkit:
          itemSubtotal = baseSubtotal;
          handlingFee = 4;
          deliveryFee = itemSubtotal > 499 ? 0 : 15;
          discount = itemSubtotal >= 800 ? 30 : 0;
          break;

        case GroceryVendorType.zepto:
          itemSubtotal = (baseSubtotal * 0.98).round(); // 2% quick-commerce promo
          handlingFee = 5;
          deliveryFee = itemSubtotal > 499 ? 0 : 15;
          discount = itemSubtotal >= 750 ? 25 : 0;
          break;

        case GroceryVendorType.instamart:
          itemSubtotal = (baseSubtotal * 1.01).round();
          handlingFee = 4;
          deliveryFee = itemSubtotal > 599 ? 0 : 20;
          discount = itemSubtotal >= 900 ? 40 : 0;
          break;

        case GroceryVendorType.bigBasket:
          itemSubtotal = (baseSubtotal * 0.91).round(); // ~9% bulk staple savings
          handlingFee = 0;
          deliveryFee = itemSubtotal > 999 ? 0 : 30;
          discount = itemSubtotal >= 1200 ? 50 : 0;
          break;

        case GroceryVendorType.amazonFresh:
          itemSubtotal = (baseSubtotal * 0.93).round(); // ~7% competitive savings
          handlingFee = 0;
          deliveryFee = itemSubtotal > 799 ? 0 : 40;
          discount = itemSubtotal >= 1500 ? 60 : 0;
          break;

        case GroceryVendorType.localKirana:
          itemSubtotal = (baseSubtotal * 0.95).round(); // 5% direct mandi rate
          handlingFee = 0;
          deliveryFee = 0; // Free neighborhood delivery
          discount = 0;
          break;
      }

      final totalPayable = (itemSubtotal + deliveryFee + handlingFee - discount).clamp(0, 999999);

      final deepLink = '${vendor.appDeepLinkPrefix}$encodedQuery';
      final fallbackUrl = '${vendor.fallbackWebUrlPrefix}$encodedQuery';

      quotes.add(VendorPriceQuote(
        vendor: vendor,
        itemsSubtotalInr: itemSubtotal,
        deliveryFeeInr: deliveryFee,
        handlingFeeInr: handlingFee,
        discountInr: discount,
        totalPayableInr: totalPayable,
        eta: vendor.deliveryEta,
        isFastest: vendor == GroceryVendorType.blinkit || vendor == GroceryVendorType.zepto,
        isCheapest: false, // Calculated after finding min
        searchCartQuery: itemQueryTokens,
        deepLinkUrl: deepLink,
        webFallbackUrl: fallbackUrl,
      ));
    }

    // Determine cheapest vendor
    if (quotes.isNotEmpty) {
      final minPayable = quotes.map((q) => q.totalPayableInr).reduce((a, b) => a < b ? a : b);
      for (int i = 0; i < quotes.length; i++) {
        if (quotes[i].totalPayableInr == minPayable) {
          quotes[i] = VendorPriceQuote(
            vendor: quotes[i].vendor,
            itemsSubtotalInr: quotes[i].itemsSubtotalInr,
            deliveryFeeInr: quotes[i].deliveryFeeInr,
            handlingFeeInr: quotes[i].handlingFeeInr,
            discountInr: quotes[i].discountInr,
            totalPayableInr: quotes[i].totalPayableInr,
            eta: quotes[i].eta,
            isFastest: quotes[i].isFastest,
            isCheapest: true,
            searchCartQuery: quotes[i].searchCartQuery,
            deepLinkUrl: quotes[i].deepLinkUrl,
            webFallbackUrl: quotes[i].webFallbackUrl,
          );
        }
      }
    }

    // Build WhatsApp Kirana Shopping List
    final whatsappBuffer = StringBuffer();
    whatsappBuffer.writeln('🛒 *FitKarma Smart Grocery List (किराना पर्ची)*');
    whatsappBuffer.writeln('📍 *Pincode:* $pincode | *Items:* ${activeItems.length}');
    whatsappBuffer.writeln('--------------------------------');
    for (final item in activeItems) {
      final ayurvedicTag = item.isAyurvedicEssential ? ' 🌿 (आयुर्वेदिक)' : '';
      whatsappBuffer.writeln('▫️ *${item.name}* (${item.regionalName})');
      whatsappBuffer.writeln('   👉 मात्रा: ${item.quantity} | ₹${item.basePriceInr}$ayurvedicTag');
    }
    whatsappBuffer.writeln('--------------------------------');
    whatsappBuffer.writeln('💰 *अनुमानित कुल योग:* ₹$baseSubtotal');
    whatsappBuffer.writeln('💪 *कुल प्रोटीन:* ${totalProtein.round()}g');
    whatsappBuffer.writeln('\n_Generated via FitKarma Nutrition Optimizer_ 🇮🇳');

    // Default recommended vendor: Zepto or BigBasket based on cart size
    final recommended = activeItems.length > 7 ? GroceryVendorType.bigBasket : GroceryVendorType.blinkit;

    return GroceryVendorCheckoutPayload(
      planId: planId ?? 'gvp_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      items: items,
      activeItemCount: activeItems.length,
      totalProteinYieldGrams: double.parse(totalProtein.toStringAsFixed(1)),
      vendorQuotes: quotes,
      recommendedVendor: recommended,
      whatsappShareText: whatsappBuffer.toString(),
      pincode: pincode,
    );
  }
}
