import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
abstract class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String name,
    String? nameHindi,
    String? nameTamil,
    String? nameTelugu,
    String? nameBengali,
    String? nameMarathi,
    String? nameGujarati,
    String? nameKannada,
    String? nameMalayalam,
    String? namePunjabi,
    required String category, // breakfast, lunch, dinner, snack
    String? cuisineType, // north_indian, south_indian, etc.
    required String servingSize,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    double? fiber,
    double? sugar,
    double? sodium,
    @Default(false) bool isVegetarian,
    @Default(false) bool isVegan,
    @Default([]) List<String> tags, // low-gi, high-protein, etc.
    String? barcode,
    String? source, // curated, openfoodfacts, user
    @Default(false) bool verified,
    String? addedBy,
    String? image,
  }) = _FoodItem;

  const FoodItem._();

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  // Helper method to get name in specific language
  String getLocalizedName(String language) {
    return switch (language.toLowerCase()) {
      'hindi' => nameHindi ?? name,
      'tamil' => nameTamil ?? name,
      'telugu' => nameTelugu ?? name,
      'bengali' => nameBengali ?? name,
      'marathi' => nameMarathi ?? name,
      'gujarati' => nameGujarati ?? name,
      'kannada' => nameKannada ?? name,
      'malayalam' => nameMalayalam ?? name,
      'punjabi' => namePunjabi ?? name,
      _ => name,
    };
  }

  // Calculate nutrition for given servings
  Map<String, double> calculateNutrition(double servings) {
    return {
      'calories': calories * servings,
      'protein': protein * servings,
      'carbs': carbs * servings,
      'fats': fats * servings,
      'fiber': (fiber ?? 0) * servings,
      'sugar': (sugar ?? 0) * servings,
      'sodium': (sodium ?? 0) * servings,
    };
  }
}
