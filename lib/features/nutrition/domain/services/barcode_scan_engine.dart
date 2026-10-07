/// FitKarma — Barcode Scanner Engine
/// Scans packaged Indian food barcodes and resolves nutritional data.
/// Uses Open Food Facts database supplemented with India-specific products.
library;

class BarcodeScanResult {
  final String barcode;
  final String productName;
  final String brand;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double fiberPer100g;
  final String? servingSizeLabel;
  final double servingSizeG;
  final bool isIndianProduct;
  final String? nutriscore;
  final List<String> allergens;

  const BarcodeScanResult({
    required this.barcode,
    required this.productName,
    required this.brand,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.fiberPer100g,
    this.servingSizeLabel,
    this.servingSizeG = 100,
    this.isIndianProduct = false,
    this.nutriscore,
    this.allergens = const [],
  });

  double get caloriesPerServing =>
      (caloriesPer100g * servingSizeG / 100).roundToDouble();
  double get proteinPerServing =>
      double.parse((proteinPer100g * servingSizeG / 100).toStringAsFixed(1));
  double get carbsPerServing =>
      double.parse((carbsPer100g * servingSizeG / 100).toStringAsFixed(1));
  double get fatPerServing =>
      double.parse((fatPer100g * servingSizeG / 100).toStringAsFixed(1));

  String get healthLabel {
    if (caloriesPer100g < 100 && proteinPer100g > 10) return 'High Protein ✅';
    if (caloriesPer100g > 400) return 'High Calorie ⚠️';
    if (fatPer100g > 25) return 'High Fat ⚠️';
    if (fiberPer100g > 5) return 'High Fiber 🌿';
    return 'Moderate';
  }
}

/// Mock Indian packaged food database — seed for offline scan
/// Real implementation: Open Food Facts API + India-specific database
class BarcodeScanEngine {
  const BarcodeScanEngine();

  static const Map<String, BarcodeScanResult> _indianFoodDatabase = {
    // Amul Products
    '8901058000102': BarcodeScanResult(
      barcode: '8901058000102',
      productName: 'Amul Butter',
      brand: 'Amul',
      caloriesPer100g: 720,
      proteinPer100g: 0.5,
      carbsPer100g: 0.5,
      fatPer100g: 80,
      fiberPer100g: 0,
      servingSizeLabel: '1 tbsp',
      servingSizeG: 14,
      isIndianProduct: true,
      allergens: ['milk'],
    ),
    '8901058025082': BarcodeScanResult(
      barcode: '8901058025082',
      productName: 'Amul Paneer',
      brand: 'Amul',
      caloriesPer100g: 265,
      proteinPer100g: 20,
      carbsPer100g: 3,
      fatPer100g: 20,
      fiberPer100g: 0,
      servingSizeLabel: '100g block',
      servingSizeG: 100,
      isIndianProduct: true,
      allergens: ['milk'],
      nutriscore: 'B',
    ),
    // Britannia
    '8901063020002': BarcodeScanResult(
      barcode: '8901063020002',
      productName: 'Britannia Marie Gold',
      brand: 'Britannia',
      caloriesPer100g: 420,
      proteinPer100g: 8.5,
      carbsPer100g: 74,
      fatPer100g: 10,
      fiberPer100g: 1.5,
      servingSizeLabel: '3 biscuits',
      servingSizeG: 30,
      isIndianProduct: true,
      allergens: ['gluten', 'milk'],
    ),
    // Haldiram
    '8902040000078': BarcodeScanResult(
      barcode: '8902040000078',
      productName: 'Haldiram Bhujia Sev',
      brand: 'Haldiram',
      caloriesPer100g: 530,
      proteinPer100g: 12,
      carbsPer100g: 58,
      fatPer100g: 28,
      fiberPer100g: 6,
      servingSizeLabel: '1 small pack',
      servingSizeG: 40,
      isIndianProduct: true,
    ),
    // MDH
    '8904001000145': BarcodeScanResult(
      barcode: '8904001000145',
      productName: 'MDH Chhole Masala',
      brand: 'MDH',
      caloriesPer100g: 320,
      proteinPer100g: 12,
      carbsPer100g: 50,
      fatPer100g: 8,
      fiberPer100g: 18,
      servingSizeLabel: '1 tsp',
      servingSizeG: 5,
      isIndianProduct: true,
    ),
    // Maggi
    '8901058001154': BarcodeScanResult(
      barcode: '8901058001154',
      productName: 'Maggi 2-Minute Noodles',
      brand: 'Nestlé',
      caloriesPer100g: 376,
      proteinPer100g: 10.3,
      carbsPer100g: 56,
      fatPer100g: 12,
      fiberPer100g: 2.0,
      servingSizeLabel: '1 packet',
      servingSizeG: 70,
      isIndianProduct: true,
      allergens: ['gluten'],
    ),
    // Parle-G
    '8901052000108': BarcodeScanResult(
      barcode: '8901052000108',
      productName: 'Parle-G Glucose Biscuits',
      brand: 'Parle',
      caloriesPer100g: 452,
      proteinPer100g: 6.7,
      carbsPer100g: 76,
      fatPer100g: 13,
      fiberPer100g: 0.5,
      servingSizeLabel: '2 biscuits',
      servingSizeG: 22,
      isIndianProduct: true,
      allergens: ['gluten', 'milk'],
    ),
    // Tata Tea
    '8901272000104': BarcodeScanResult(
      barcode: '8901272000104',
      productName: 'Tata Tea Premium',
      brand: 'Tata',
      caloriesPer100g: 0,
      proteinPer100g: 0,
      carbsPer100g: 0,
      fatPer100g: 0,
      fiberPer100g: 0,
      servingSizeLabel: '1 cup brewed',
      servingSizeG: 200,
      isIndianProduct: true,
    ),
    // Complan
    '8901072000017': BarcodeScanResult(
      barcode: '8901072000017',
      productName: 'Complan Chocolate',
      brand: 'Heinz',
      caloriesPer100g: 397,
      proteinPer100g: 18,
      carbsPer100g: 66,
      fatPer100g: 7.5,
      fiberPer100g: 0,
      servingSizeLabel: '3 tbsp in 200ml milk',
      servingSizeG: 35,
      isIndianProduct: true,
      allergens: ['milk', 'gluten'],
    ),
  };

  /// Looks up a barcode in the offline Indian food database.
  /// Returns null if not found (app should then call Open Food Facts API).
  BarcodeScanResult? lookupOffline(String barcode) {
    return _indianFoodDatabase[barcode];
  }

  BarcodeScanResult? lookupBarcode(String barcode) => lookupOffline(barcode);

  /// Parses an Open Food Facts API response JSON into a BarcodeScanResult.
  BarcodeScanResult? parseOpenFoodFactsResponse(Map<String, dynamic> json) {
    try {
      final product = json['product'] as Map<String, dynamic>?;
      if (product == null) return null;
      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
      return BarcodeScanResult(
        barcode: (product['code'] ?? '') as String,
        productName: (product['product_name_en'] ?? product['product_name'] ?? 'Unknown') as String,
        brand: (product['brands'] ?? 'Unknown Brand') as String,
        caloriesPer100g: _toDouble(nutriments['energy-kcal_100g']),
        proteinPer100g: _toDouble(nutriments['proteins_100g']),
        carbsPer100g: _toDouble(nutriments['carbohydrates_100g']),
        fatPer100g: _toDouble(nutriments['fat_100g']),
        fiberPer100g: _toDouble(nutriments['fiber_100g']),
        servingSizeLabel: product['serving_size'] as String?,
        servingSizeG: _toDouble(nutriments['serving_size']).clamp(10, 500),
        nutriscore: product['nutriscore_grade'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  double _toDouble(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0;
  }
}
