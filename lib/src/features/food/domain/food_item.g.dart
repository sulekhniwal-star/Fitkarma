// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => _FoodItem(
  id: json['id'] as String,
  name: json['name'] as String,
  nameHindi: json['name_hindi'] as String?,
  nameTamil: json['name_tamil'] as String?,
  nameTelugu: json['name_telugu'] as String?,
  nameBengali: json['name_bengali'] as String?,
  nameMarathi: json['name_marathi'] as String?,
  nameGujarati: json['name_gujarati'] as String?,
  nameKannada: json['name_kannada'] as String?,
  nameMalayalam: json['name_malayalam'] as String?,
  namePunjabi: json['name_punjabi'] as String?,
  category: json['category'] as String,
  cuisineType: json['cuisine_type'] as String?,
  servingSize: json['serving_size'] as String,
  calories: (json['calories'] as num).toDouble(),
  protein: (json['protein'] as num).toDouble(),
  carbs: (json['carbs'] as num).toDouble(),
  fats: (json['fats'] as num).toDouble(),
  fiber: (json['fiber'] as num?)?.toDouble(),
  sugar: (json['sugar'] as num?)?.toDouble(),
  sodium: (json['sodium'] as num?)?.toDouble(),
  isVegetarian: json['is_vegetarian'] as bool? ?? false,
  isVegan: json['is_vegan'] as bool? ?? false,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  barcode: json['barcode'] as String?,
  source: json['source'] as String?,
  verified: json['verified'] as bool? ?? false,
  addedBy: json['added_by'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$FoodItemToJson(_FoodItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_hindi': instance.nameHindi,
  'name_tamil': instance.nameTamil,
  'name_telugu': instance.nameTelugu,
  'name_bengali': instance.nameBengali,
  'name_marathi': instance.nameMarathi,
  'name_gujarati': instance.nameGujarati,
  'name_kannada': instance.nameKannada,
  'name_malayalam': instance.nameMalayalam,
  'name_punjabi': instance.namePunjabi,
  'category': instance.category,
  'cuisine_type': instance.cuisineType,
  'serving_size': instance.servingSize,
  'calories': instance.calories,
  'protein': instance.protein,
  'carbs': instance.carbs,
  'fats': instance.fats,
  'fiber': instance.fiber,
  'sugar': instance.sugar,
  'sodium': instance.sodium,
  'is_vegetarian': instance.isVegetarian,
  'is_vegan': instance.isVegan,
  'tags': instance.tags,
  'barcode': instance.barcode,
  'source': instance.source,
  'verified': instance.verified,
  'added_by': instance.addedBy,
  'image': instance.image,
};
