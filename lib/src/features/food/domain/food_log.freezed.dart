// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodLog {

 String get id; String get userId; String get foodItemId; String? get foodItemName;// Cached for display
 String get mealType;// breakfast, lunch, dinner, snack
 double get servings; DateTime get date; String? get photo; String? get note;// Cached nutrition values (in case food item changes later)
 double? get calories; double? get protein; double? get carbs; double? get fats; double? get fiber; double? get sugar; double? get sodium;
/// Create a copy of FoodLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodLogCopyWith<FoodLog> get copyWith => _$FoodLogCopyWithImpl<FoodLog>(this as FoodLog, _$identity);

  /// Serializes this FoodLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.foodItemId, foodItemId) || other.foodItemId == foodItemId)&&(identical(other.foodItemName, foodItemName) || other.foodItemName == foodItemName)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.date, date) || other.date == date)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.note, note) || other.note == note)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fats, fats) || other.fats == fats)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.sodium, sodium) || other.sodium == sodium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,foodItemId,foodItemName,mealType,servings,date,photo,note,calories,protein,carbs,fats,fiber,sugar,sodium);

@override
String toString() {
  return 'FoodLog(id: $id, userId: $userId, foodItemId: $foodItemId, foodItemName: $foodItemName, mealType: $mealType, servings: $servings, date: $date, photo: $photo, note: $note, calories: $calories, protein: $protein, carbs: $carbs, fats: $fats, fiber: $fiber, sugar: $sugar, sodium: $sodium)';
}


}

/// @nodoc
abstract mixin class $FoodLogCopyWith<$Res>  {
  factory $FoodLogCopyWith(FoodLog value, $Res Function(FoodLog) _then) = _$FoodLogCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String foodItemId, String? foodItemName, String mealType, double servings, DateTime date, String? photo, String? note, double? calories, double? protein, double? carbs, double? fats, double? fiber, double? sugar, double? sodium
});




}
/// @nodoc
class _$FoodLogCopyWithImpl<$Res>
    implements $FoodLogCopyWith<$Res> {
  _$FoodLogCopyWithImpl(this._self, this._then);

  final FoodLog _self;
  final $Res Function(FoodLog) _then;

/// Create a copy of FoodLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? foodItemId = null,Object? foodItemName = freezed,Object? mealType = null,Object? servings = null,Object? date = null,Object? photo = freezed,Object? note = freezed,Object? calories = freezed,Object? protein = freezed,Object? carbs = freezed,Object? fats = freezed,Object? fiber = freezed,Object? sugar = freezed,Object? sodium = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,foodItemId: null == foodItemId ? _self.foodItemId : foodItemId // ignore: cast_nullable_to_non_nullable
as String,foodItemName: freezed == foodItemName ? _self.foodItemName : foodItemName // ignore: cast_nullable_to_non_nullable
as String?,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,carbs: freezed == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double?,fats: freezed == fats ? _self.fats : fats // ignore: cast_nullable_to_non_nullable
as double?,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodLog].
extension FoodLogPatterns on FoodLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodLog value)  $default,){
final _that = this;
switch (_that) {
case _FoodLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodLog value)?  $default,){
final _that = this;
switch (_that) {
case _FoodLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String foodItemId,  String? foodItemName,  String mealType,  double servings,  DateTime date,  String? photo,  String? note,  double? calories,  double? protein,  double? carbs,  double? fats,  double? fiber,  double? sugar,  double? sodium)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodLog() when $default != null:
return $default(_that.id,_that.userId,_that.foodItemId,_that.foodItemName,_that.mealType,_that.servings,_that.date,_that.photo,_that.note,_that.calories,_that.protein,_that.carbs,_that.fats,_that.fiber,_that.sugar,_that.sodium);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String foodItemId,  String? foodItemName,  String mealType,  double servings,  DateTime date,  String? photo,  String? note,  double? calories,  double? protein,  double? carbs,  double? fats,  double? fiber,  double? sugar,  double? sodium)  $default,) {final _that = this;
switch (_that) {
case _FoodLog():
return $default(_that.id,_that.userId,_that.foodItemId,_that.foodItemName,_that.mealType,_that.servings,_that.date,_that.photo,_that.note,_that.calories,_that.protein,_that.carbs,_that.fats,_that.fiber,_that.sugar,_that.sodium);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String foodItemId,  String? foodItemName,  String mealType,  double servings,  DateTime date,  String? photo,  String? note,  double? calories,  double? protein,  double? carbs,  double? fats,  double? fiber,  double? sugar,  double? sodium)?  $default,) {final _that = this;
switch (_that) {
case _FoodLog() when $default != null:
return $default(_that.id,_that.userId,_that.foodItemId,_that.foodItemName,_that.mealType,_that.servings,_that.date,_that.photo,_that.note,_that.calories,_that.protein,_that.carbs,_that.fats,_that.fiber,_that.sugar,_that.sodium);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodLog extends FoodLog {
  const _FoodLog({required this.id, required this.userId, required this.foodItemId, this.foodItemName, required this.mealType, required this.servings, required this.date, this.photo, this.note, this.calories, this.protein, this.carbs, this.fats, this.fiber, this.sugar, this.sodium}): super._();
  factory _FoodLog.fromJson(Map<String, dynamic> json) => _$FoodLogFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String foodItemId;
@override final  String? foodItemName;
// Cached for display
@override final  String mealType;
// breakfast, lunch, dinner, snack
@override final  double servings;
@override final  DateTime date;
@override final  String? photo;
@override final  String? note;
// Cached nutrition values (in case food item changes later)
@override final  double? calories;
@override final  double? protein;
@override final  double? carbs;
@override final  double? fats;
@override final  double? fiber;
@override final  double? sugar;
@override final  double? sodium;

/// Create a copy of FoodLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodLogCopyWith<_FoodLog> get copyWith => __$FoodLogCopyWithImpl<_FoodLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.foodItemId, foodItemId) || other.foodItemId == foodItemId)&&(identical(other.foodItemName, foodItemName) || other.foodItemName == foodItemName)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.date, date) || other.date == date)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.note, note) || other.note == note)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fats, fats) || other.fats == fats)&&(identical(other.fiber, fiber) || other.fiber == fiber)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.sodium, sodium) || other.sodium == sodium));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,foodItemId,foodItemName,mealType,servings,date,photo,note,calories,protein,carbs,fats,fiber,sugar,sodium);

@override
String toString() {
  return 'FoodLog(id: $id, userId: $userId, foodItemId: $foodItemId, foodItemName: $foodItemName, mealType: $mealType, servings: $servings, date: $date, photo: $photo, note: $note, calories: $calories, protein: $protein, carbs: $carbs, fats: $fats, fiber: $fiber, sugar: $sugar, sodium: $sodium)';
}


}

/// @nodoc
abstract mixin class _$FoodLogCopyWith<$Res> implements $FoodLogCopyWith<$Res> {
  factory _$FoodLogCopyWith(_FoodLog value, $Res Function(_FoodLog) _then) = __$FoodLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String foodItemId, String? foodItemName, String mealType, double servings, DateTime date, String? photo, String? note, double? calories, double? protein, double? carbs, double? fats, double? fiber, double? sugar, double? sodium
});




}
/// @nodoc
class __$FoodLogCopyWithImpl<$Res>
    implements _$FoodLogCopyWith<$Res> {
  __$FoodLogCopyWithImpl(this._self, this._then);

  final _FoodLog _self;
  final $Res Function(_FoodLog) _then;

/// Create a copy of FoodLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? foodItemId = null,Object? foodItemName = freezed,Object? mealType = null,Object? servings = null,Object? date = null,Object? photo = freezed,Object? note = freezed,Object? calories = freezed,Object? protein = freezed,Object? carbs = freezed,Object? fats = freezed,Object? fiber = freezed,Object? sugar = freezed,Object? sodium = freezed,}) {
  return _then(_FoodLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,foodItemId: null == foodItemId ? _self.foodItemId : foodItemId // ignore: cast_nullable_to_non_nullable
as String,foodItemName: freezed == foodItemName ? _self.foodItemName : foodItemName // ignore: cast_nullable_to_non_nullable
as String?,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,carbs: freezed == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double?,fats: freezed == fats ? _self.fats : fats // ignore: cast_nullable_to_non_nullable
as double?,fiber: freezed == fiber ? _self.fiber : fiber // ignore: cast_nullable_to_non_nullable
as double?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as double?,sodium: freezed == sodium ? _self.sodium : sodium // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
