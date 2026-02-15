// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodItem {

 String get id; String get name; String? get nameHindi; String? get nameTamil; String? get nameTelugu; String? get nameBengali; String? get nameMarathi; String? get nameGujarati; String? get nameKannada; String? get nameMalayalam; String? get namePunjabi; String get category;// breakfast, lunch, dinner, snack
 String? get cuisineType;// north_indian, south_indian, etc.
 String get servingSize; double get calories; double get protein; double get carbs; double get fats; double? get fiber; double? get sugar; double? get sodium; bool get isVegetarian; bool get isVegan; List<String> get tags;// low-gi, high-protein, etc.
 String? get barcode; String? get source;// curated, openfoodfacts, user
 bool get verified; String? get addedBy; String? get image;
/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodItemCopyWith<FoodItem> get copyWith => _$FoodItemCopyWithImpl<FoodItem>(this as FoodItem, _$identity);

  /// Serializes this FoodItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.nameTamil, nameTamil) || other.nameTamil == nameTamil)&&(identical(other.nameTelugu, nameTelugu) || other.nameTelugu == nameTelugu)&&(identical(other.nameBengali, nameBengali) || other.nameBengali == nameBengali)&&(identical(other.nameMarathi, nameMarathi) || other.nameMarathi == nameMarathi)&&(identical(other.nameGujarati, nameGujarati) || other.nameGujarati == nameGujarati)&&(identical(other.nameKannada, nameKannada) || other.nameKannada == nameKannada)&&(identical(other.nameMalayalam, nameMalayalam) || other.nameMalayalam == nameMalayalam)&&(identical(other.namePunjabi, namePunjabi) || other.namePunjabi == namePunjabi)&&(identical(other.category, category) || other.category == category)&&(identical(other.cuisineType, cuisineType) || other.cuisineType == cuisineType)&&(identical(other.servingSize, servingSize) || other.servingSize == servingSize)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fats, fats) || other.fats == fats)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.isVegetarian, isVegetarian) || other.isVegetarian == isVegetarian)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.source, source) || other.source == source)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nameHindi,nameTamil,nameTelugu,nameBengali,nameMarathi,nameGujarati,nameKannada,nameMalayalam,namePunjabi,category,cuisineType,servingSize,calories,protein,carbs,fats,fiber,sugar,sodium,isVegetarian,isVegan,const DeepCollectionEquality().hash(tags),barcode,source,verified,addedBy,image]);

@override
String toString() {
  return 'FoodItem(id: $id, name: $name, nameHindi: $nameHindi, nameTamil: $nameTamil, nameTelugu: $nameTelugu, nameBengali: $nameBengali, nameMarathi: $nameMarathi, nameGujarati: $nameGujarati, nameKannada: $nameKannada, nameMalayalam: $nameMalayalam, namePunjabi: $namePunjabi, category: $category, cuisineType: $cuisineType, servingSize: $servingSize, calories: $calories, protein: $protein, carbs: $carbs, fats: $fats, fiber: $fiber, sugar: $sugar, sodium: $sodium, isVegetarian: $isVegetarian, isVegan: $isVegan, tags: $tags, barcode: $barcode, source: $source, verified: $verified, addedBy: $addedBy, image: $image)';
}


}

/// @nodoc
abstract mixin class $FoodItemCopyWith<$Res>  {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) _then) = _$FoodItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? nameHindi, String? nameTamil, String? nameTelugu, String? nameBengali, String? nameMarathi, String? nameGujarati, String? nameKannada, String? nameMalayalam, String? namePunjabi, String category, String? cuisineType, String servingSize, double calories, double protein, double carbs, double fats, double? fiber, double? sugar, double? sodium, bool isVegetarian, bool isVegan, List<String> tags, String? barcode, String? source, bool verified, String? addedBy, String? image
});




}
/// @nodoc
class _$FoodItemCopyWithImpl<$Res>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._self, this._then);

  final FoodItem _self;
  final $Res Function(FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameHindi = freezed,Object? nameTamil = freezed,Object? nameTelugu = freezed,Object? nameBengali = freezed,Object? nameMarathi = freezed,Object? nameGujarati = freezed,Object? nameKannada = freezed,Object? nameMalayalam = freezed,Object? namePunjabi = freezed,Object? category = null,Object? cuisineType = freezed,Object? servingSize = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fats = null,Object? fiber = freezed,Object? sugar = freezed,Object? sodium = freezed,Object? isVegetarian = null,Object? isVegan = null,Object? tags = null,Object? barcode = freezed,Object? source = freezed,Object? verified = null,Object? addedBy = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,nameTamil: freezed == nameTamil ? _self.nameTamil : nameTamil // ignore: cast_nullable_to_non_nullable
as String?,nameTelugu: freezed == nameTelugu ? _self.nameTelugu : nameTelugu // ignore: cast_nullable_to_non_nullable
as String?,nameBengali: freezed == nameBengali ? _self.nameBengali : nameBengali // ignore: cast_nullable_to_non_nullable
as String?,nameMarathi: freezed == nameMarathi ? _self.nameMarathi : nameMarathi // ignore: cast_nullable_to_non_nullable
as String?,nameGujarati: freezed == nameGujarati ? _self.nameGujarati : nameGujarati // ignore: cast_nullable_to_non_nullable
as String?,nameKannada: freezed == nameKannada ? _self.nameKannada : nameKannada // ignore: cast_nullable_to_non_nullable
as String?,nameMalayalam: freezed == nameMalayalam ? _self.nameMalayalam : nameMalayalam // ignore: cast_nullable_to_non_nullable
as String?,namePunjabi: freezed == namePunjabi ? _self.namePunjabi : namePunjabi // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,cuisineType: freezed == cuisineType ? _self.cuisineType : cuisineType // ignore: cast_nullable_to_non_nullable
as String?,servingSize: null == servingSize ? _self.servingSize : servingSize // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fats: null == fats ? _self.fats : fats // ignore: cast_nullable_to_non_nullable
as double,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,isVegetarian: null == isVegetarian ? _self.isVegetarian : isVegetarian // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodItem].
extension FoodItemPatterns on FoodItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodItem value)  $default,){
final _that = this;
switch (_that) {
case _FoodItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodItem value)?  $default,){
final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? nameHindi,  String? nameTamil,  String? nameTelugu,  String? nameBengali,  String? nameMarathi,  String? nameGujarati,  String? nameKannada,  String? nameMalayalam,  String? namePunjabi,  String category,  String? cuisineType,  String servingSize,  double calories,  double protein,  double carbs,  double fats,  double? fiber,  double? sugar,  double? sodium,  bool isVegetarian,  bool isVegan,  List<String> tags,  String? barcode,  String? source,  bool verified,  String? addedBy,  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.nameHindi,_that.nameTamil,_that.nameTelugu,_that.nameBengali,_that.nameMarathi,_that.nameGujarati,_that.nameKannada,_that.nameMalayalam,_that.namePunjabi,_that.category,_that.cuisineType,_that.servingSize,_that.calories,_that.protein,_that.carbs,_that.fats,_that.fiber,_that.sugar,_that.sodium,_that.isVegetarian,_that.isVegan,_that.tags,_that.barcode,_that.source,_that.verified,_that.addedBy,_that.image);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? nameHindi,  String? nameTamil,  String? nameTelugu,  String? nameBengali,  String? nameMarathi,  String? nameGujarati,  String? nameKannada,  String? nameMalayalam,  String? namePunjabi,  String category,  String? cuisineType,  String servingSize,  double calories,  double protein,  double carbs,  double fats,  double? fiber,  double? sugar,  double? sodium,  bool isVegetarian,  bool isVegan,  List<String> tags,  String? barcode,  String? source,  bool verified,  String? addedBy,  String? image)  $default,) {final _that = this;
switch (_that) {
case _FoodItem():
return $default(_that.id,_that.name,_that.nameHindi,_that.nameTamil,_that.nameTelugu,_that.nameBengali,_that.nameMarathi,_that.nameGujarati,_that.nameKannada,_that.nameMalayalam,_that.namePunjabi,_that.category,_that.cuisineType,_that.servingSize,_that.calories,_that.protein,_that.carbs,_that.fats,_that.fiber,_that.sugar,_that.sodium,_that.isVegetarian,_that.isVegan,_that.tags,_that.barcode,_that.source,_that.verified,_that.addedBy,_that.image);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? nameHindi,  String? nameTamil,  String? nameTelugu,  String? nameBengali,  String? nameMarathi,  String? nameGujarati,  String? nameKannada,  String? nameMalayalam,  String? namePunjabi,  String category,  String? cuisineType,  String servingSize,  double calories,  double protein,  double carbs,  double fats,  double? fiber,  double? sugar,  double? sodium,  bool isVegetarian,  bool isVegan,  List<String> tags,  String? barcode,  String? source,  bool verified,  String? addedBy,  String? image)?  $default,) {final _that = this;
switch (_that) {
case _FoodItem() when $default != null:
return $default(_that.id,_that.name,_that.nameHindi,_that.nameTamil,_that.nameTelugu,_that.nameBengali,_that.nameMarathi,_that.nameGujarati,_that.nameKannada,_that.nameMalayalam,_that.namePunjabi,_that.category,_that.cuisineType,_that.servingSize,_that.calories,_that.protein,_that.carbs,_that.fats,_that.fiber,_that.sugar,_that.sodium,_that.isVegetarian,_that.isVegan,_that.tags,_that.barcode,_that.source,_that.verified,_that.addedBy,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodItem extends FoodItem {
  const _FoodItem({required this.id, required this.name, this.nameHindi, this.nameTamil, this.nameTelugu, this.nameBengali, this.nameMarathi, this.nameGujarati, this.nameKannada, this.nameMalayalam, this.namePunjabi, required this.category, this.cuisineType, required this.servingSize, required this.calories, required this.protein, required this.carbs, required this.fats, this.fiber, this.sugar, this.sodium, this.isVegetarian = false, this.isVegan = false, final  List<String> tags = const [], this.barcode, this.source, this.verified = false, this.addedBy, this.image}): _tags = tags,super._();
  factory _FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? nameHindi;
@override final  String? nameTamil;
@override final  String? nameTelugu;
@override final  String? nameBengali;
@override final  String? nameMarathi;
@override final  String? nameGujarati;
@override final  String? nameKannada;
@override final  String? nameMalayalam;
@override final  String? namePunjabi;
@override final  String category;
// breakfast, lunch, dinner, snack
@override final  String? cuisineType;
// north_indian, south_indian, etc.
@override final  String servingSize;
@override final  double calories;
@override final  double protein;
@override final  double carbs;
@override final  double fats;
@override final  double? fiber;
@override final  double? sugar;
@override final  double? sodium;
@override@JsonKey() final  bool isVegetarian;
@override@JsonKey() final  bool isVegan;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

// low-gi, high-protein, etc.
@override final  String? barcode;
@override final  String? source;
// curated, openfoodfacts, user
@override@JsonKey() final  bool verified;
@override final  String? addedBy;
@override final  String? image;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodItemCopyWith<_FoodItem> get copyWith => __$FoodItemCopyWithImpl<_FoodItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameHindi, nameHindi) || other.nameHindi == nameHindi)&&(identical(other.nameTamil, nameTamil) || other.nameTamil == nameTamil)&&(identical(other.nameTelugu, nameTelugu) || other.nameTelugu == nameTelugu)&&(identical(other.nameBengali, nameBengali) || other.nameBengali == nameBengali)&&(identical(other.nameMarathi, nameMarathi) || other.nameMarathi == nameMarathi)&&(identical(other.nameGujarati, nameGujarati) || other.nameGujarati == nameGujarati)&&(identical(other.nameKannada, nameKannada) || other.nameKannada == nameKannada)&&(identical(other.nameMalayalam, nameMalayalam) || other.nameMalayalam == nameMalayalam)&&(identical(other.namePunjabi, namePunjabi) || other.namePunjabi == namePunjabi)&&(identical(other.category, category) || other.category == category)&&(identical(other.cuisineType, cuisineType) || other.cuisineType == cuisineType)&&(identical(other.servingSize, servingSize) || other.servingSize == servingSize)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fats, fats) || other.fats == fats)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.sodium, sodium) || other.sodium == sodium)&&(identical(other.isVegetarian, isVegetarian) || other.isVegetarian == isVegetarian)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.source, source) || other.source == source)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,nameHindi,nameTamil,nameTelugu,nameBengali,nameMarathi,nameGujarati,nameKannada,nameMalayalam,namePunjabi,category,cuisineType,servingSize,calories,protein,carbs,fats,fiber,sugar,sodium,isVegetarian,isVegan,const DeepCollectionEquality().hash(_tags),barcode,source,verified,addedBy,image]);

@override
String toString() {
  return 'FoodItem(id: $id, name: $name, nameHindi: $nameHindi, nameTamil: $nameTamil, nameTelugu: $nameTelugu, nameBengali: $nameBengali, nameMarathi: $nameMarathi, nameGujarati: $nameGujarati, nameKannada: $nameKannada, nameMalayalam: $nameMalayalam, namePunjabi: $namePunjabi, category: $category, cuisineType: $cuisineType, servingSize: $servingSize, calories: $calories, protein: $protein, carbs: $carbs, fats: $fats, fiber: $fiber, sugar: $sugar, sodium: $sodium, isVegetarian: $isVegetarian, isVegan: $isVegan, tags: $tags, barcode: $barcode, source: $source, verified: $verified, addedBy: $addedBy, image: $image)';
}


}

/// @nodoc
abstract mixin class _$FoodItemCopyWith<$Res> implements $FoodItemCopyWith<$Res> {
  factory _$FoodItemCopyWith(_FoodItem value, $Res Function(_FoodItem) _then) = __$FoodItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? nameHindi, String? nameTamil, String? nameTelugu, String? nameBengali, String? nameMarathi, String? nameGujarati, String? nameKannada, String? nameMalayalam, String? namePunjabi, String category, String? cuisineType, String servingSize, double calories, double protein, double carbs, double fats, double? fiber, double? sugar, double? sodium, bool isVegetarian, bool isVegan, List<String> tags, String? barcode, String? source, bool verified, String? addedBy, String? image
});




}
/// @nodoc
class __$FoodItemCopyWithImpl<$Res>
    implements _$FoodItemCopyWith<$Res> {
  __$FoodItemCopyWithImpl(this._self, this._then);

  final _FoodItem _self;
  final $Res Function(_FoodItem) _then;

/// Create a copy of FoodItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameHindi = freezed,Object? nameTamil = freezed,Object? nameTelugu = freezed,Object? nameBengali = freezed,Object? nameMarathi = freezed,Object? nameGujarati = freezed,Object? nameKannada = freezed,Object? nameMalayalam = freezed,Object? namePunjabi = freezed,Object? category = null,Object? cuisineType = freezed,Object? servingSize = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fats = null,Object? fiber = freezed,Object? sugar = freezed,Object? sodium = freezed,Object? isVegetarian = null,Object? isVegan = null,Object? tags = null,Object? barcode = freezed,Object? source = freezed,Object? verified = null,Object? addedBy = freezed,Object? image = freezed,}) {
  return _then(_FoodItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameHindi: freezed == nameHindi ? _self.nameHindi : nameHindi // ignore: cast_nullable_to_non_nullable
as String?,nameTamil: freezed == nameTamil ? _self.nameTamil : nameTamil // ignore: cast_nullable_to_non_nullable
as String?,nameTelugu: freezed == nameTelugu ? _self.nameTelugu : nameTelugu // ignore: cast_nullable_to_non_nullable
as String?,nameBengali: freezed == nameBengali ? _self.nameBengali : nameBengali // ignore: cast_nullable_to_non_nullable
as String?,nameMarathi: freezed == nameMarathi ? _self.nameMarathi : nameMarathi // ignore: cast_nullable_to_non_nullable
as String?,nameGujarati: freezed == nameGujarati ? _self.nameGujarati : nameGujarati // ignore: cast_nullable_to_non_nullable
as String?,nameKannada: freezed == nameKannada ? _self.nameKannada : nameKannada // ignore: cast_nullable_to_non_nullable
as String?,nameMalayalam: freezed == nameMalayalam ? _self.nameMalayalam : nameMalayalam // ignore: cast_nullable_to_non_nullable
as String?,namePunjabi: freezed == namePunjabi ? _self.namePunjabi : namePunjabi // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,cuisineType: freezed == cuisineType ? _self.cuisineType : cuisineType // ignore: cast_nullable_to_non_nullable
as String?,servingSize: null == servingSize ? _self.servingSize : servingSize // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fats: null == fats ? _self.fats : fats // ignore: cast_nullable_to_non_nullable
as double,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,isVegetarian: null == isVegetarian ? _self.isVegetarian : isVegetarian // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
