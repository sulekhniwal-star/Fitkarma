// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'karma_tier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KarmaTier {

 String get id; String get name; int get minPoints; List<String> get benefits; String? get badgeIcon;
/// Create a copy of KarmaTier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KarmaTierCopyWith<KarmaTier> get copyWith => _$KarmaTierCopyWithImpl<KarmaTier>(this as KarmaTier, _$identity);

  /// Serializes this KarmaTier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KarmaTier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minPoints, minPoints) || other.minPoints == minPoints)&&const DeepCollectionEquality().equals(other.benefits, benefits)&&(identical(other.badgeIcon, badgeIcon) || other.badgeIcon == badgeIcon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,minPoints,const DeepCollectionEquality().hash(benefits),badgeIcon);

@override
String toString() {
  return 'KarmaTier(id: $id, name: $name, minPoints: $minPoints, benefits: $benefits, badgeIcon: $badgeIcon)';
}


}

/// @nodoc
abstract mixin class $KarmaTierCopyWith<$Res>  {
  factory $KarmaTierCopyWith(KarmaTier value, $Res Function(KarmaTier) _then) = _$KarmaTierCopyWithImpl;
@useResult
$Res call({
 String id, String name, int minPoints, List<String> benefits, String? badgeIcon
});




}
/// @nodoc
class _$KarmaTierCopyWithImpl<$Res>
    implements $KarmaTierCopyWith<$Res> {
  _$KarmaTierCopyWithImpl(this._self, this._then);

  final KarmaTier _self;
  final $Res Function(KarmaTier) _then;

/// Create a copy of KarmaTier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? minPoints = null,Object? benefits = null,Object? badgeIcon = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minPoints: null == minPoints ? _self.minPoints : minPoints // ignore: cast_nullable_to_non_nullable
as int,benefits: null == benefits ? _self.benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,badgeIcon: freezed == badgeIcon ? _self.badgeIcon : badgeIcon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [KarmaTier].
extension KarmaTierPatterns on KarmaTier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KarmaTier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KarmaTier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KarmaTier value)  $default,){
final _that = this;
switch (_that) {
case _KarmaTier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KarmaTier value)?  $default,){
final _that = this;
switch (_that) {
case _KarmaTier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int minPoints,  List<String> benefits,  String? badgeIcon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KarmaTier() when $default != null:
return $default(_that.id,_that.name,_that.minPoints,_that.benefits,_that.badgeIcon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int minPoints,  List<String> benefits,  String? badgeIcon)  $default,) {final _that = this;
switch (_that) {
case _KarmaTier():
return $default(_that.id,_that.name,_that.minPoints,_that.benefits,_that.badgeIcon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int minPoints,  List<String> benefits,  String? badgeIcon)?  $default,) {final _that = this;
switch (_that) {
case _KarmaTier() when $default != null:
return $default(_that.id,_that.name,_that.minPoints,_that.benefits,_that.badgeIcon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KarmaTier implements KarmaTier {
  const _KarmaTier({required this.id, required this.name, required this.minPoints, required final  List<String> benefits, this.badgeIcon}): _benefits = benefits;
  factory _KarmaTier.fromJson(Map<String, dynamic> json) => _$KarmaTierFromJson(json);

@override final  String id;
@override final  String name;
@override final  int minPoints;
 final  List<String> _benefits;
@override List<String> get benefits {
  if (_benefits is EqualUnmodifiableListView) return _benefits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_benefits);
}

@override final  String? badgeIcon;

/// Create a copy of KarmaTier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KarmaTierCopyWith<_KarmaTier> get copyWith => __$KarmaTierCopyWithImpl<_KarmaTier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KarmaTierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KarmaTier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minPoints, minPoints) || other.minPoints == minPoints)&&const DeepCollectionEquality().equals(other._benefits, _benefits)&&(identical(other.badgeIcon, badgeIcon) || other.badgeIcon == badgeIcon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,minPoints,const DeepCollectionEquality().hash(_benefits),badgeIcon);

@override
String toString() {
  return 'KarmaTier(id: $id, name: $name, minPoints: $minPoints, benefits: $benefits, badgeIcon: $badgeIcon)';
}


}

/// @nodoc
abstract mixin class _$KarmaTierCopyWith<$Res> implements $KarmaTierCopyWith<$Res> {
  factory _$KarmaTierCopyWith(_KarmaTier value, $Res Function(_KarmaTier) _then) = __$KarmaTierCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int minPoints, List<String> benefits, String? badgeIcon
});




}
/// @nodoc
class __$KarmaTierCopyWithImpl<$Res>
    implements _$KarmaTierCopyWith<$Res> {
  __$KarmaTierCopyWithImpl(this._self, this._then);

  final _KarmaTier _self;
  final $Res Function(_KarmaTier) _then;

/// Create a copy of KarmaTier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? minPoints = null,Object? benefits = null,Object? badgeIcon = freezed,}) {
  return _then(_KarmaTier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minPoints: null == minPoints ? _self.minPoints : minPoints // ignore: cast_nullable_to_non_nullable
as int,benefits: null == benefits ? _self._benefits : benefits // ignore: cast_nullable_to_non_nullable
as List<String>,badgeIcon: freezed == badgeIcon ? _self.badgeIcon : badgeIcon // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
