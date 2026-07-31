/// Vernacular Language Enum
enum VernacularLanguage { hindi, tamil, telugu, marathi, bengali, kannada, english }

/// ABHA Account Link Status
class AbhaAccount {
  final String abhaHealthId; // Encrypted storage
  final String abhaNumber;
  final bool isLinked;
  final String fhirLiteExportUrl;

  const AbhaAccount({
    required this.abhaHealthId,
    required this.abhaNumber,
    this.isLinked = false,
    required this.fhirLiteExportUrl,
  });
}

/// Grocery Vendor Partner Adapter Item
class GroceryVendorItem {
  final String partnerName; // e.g. "Blinkit", "BigBasket", "Zepto"
  final String cartExportUrl;
  final bool isConnected;

  const GroceryVendorItem({
    required this.partnerName,
    required this.cartExportUrl,
    this.isConnected = true,
  });
}
