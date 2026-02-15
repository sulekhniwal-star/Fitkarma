// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dosha_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DoshaQuestion {

 String get id; String get question; Map<String, String> get options; String get category; int get order;
/// Create a copy of DoshaQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoshaQuestionCopyWith<DoshaQuestion> get copyWith => _$DoshaQuestionCopyWithImpl<DoshaQuestion>(this as DoshaQuestion, _$identity);

  /// Serializes this DoshaQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoshaQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(options),category,order);

@override
String toString() {
  return 'DoshaQuestion(id: $id, question: $question, options: $options, category: $category, order: $order)';
}


}

/// @nodoc
abstract mixin class $DoshaQuestionCopyWith<$Res>  {
  factory $DoshaQuestionCopyWith(DoshaQuestion value, $Res Function(DoshaQuestion) _then) = _$DoshaQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String question, Map<String, String> options, String category, int order
});




}
/// @nodoc
class _$DoshaQuestionCopyWithImpl<$Res>
    implements $DoshaQuestionCopyWith<$Res> {
  _$DoshaQuestionCopyWithImpl(this._self, this._then);

  final DoshaQuestion _self;
  final $Res Function(DoshaQuestion) _then;

/// Create a copy of DoshaQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? options = null,Object? category = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Map<String, String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DoshaQuestion].
extension DoshaQuestionPatterns on DoshaQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoshaQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoshaQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoshaQuestion value)  $default,){
final _that = this;
switch (_that) {
case _DoshaQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoshaQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _DoshaQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String question,  Map<String, String> options,  String category,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoshaQuestion() when $default != null:
return $default(_that.id,_that.question,_that.options,_that.category,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String question,  Map<String, String> options,  String category,  int order)  $default,) {final _that = this;
switch (_that) {
case _DoshaQuestion():
return $default(_that.id,_that.question,_that.options,_that.category,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String question,  Map<String, String> options,  String category,  int order)?  $default,) {final _that = this;
switch (_that) {
case _DoshaQuestion() when $default != null:
return $default(_that.id,_that.question,_that.options,_that.category,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DoshaQuestion implements DoshaQuestion {
  const _DoshaQuestion({required this.id, required this.question, required final  Map<String, String> options, required this.category, required this.order}): _options = options;
  factory _DoshaQuestion.fromJson(Map<String, dynamic> json) => _$DoshaQuestionFromJson(json);

@override final  String id;
@override final  String question;
 final  Map<String, String> _options;
@override Map<String, String> get options {
  if (_options is EqualUnmodifiableMapView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_options);
}

@override final  String category;
@override final  int order;

/// Create a copy of DoshaQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoshaQuestionCopyWith<_DoshaQuestion> get copyWith => __$DoshaQuestionCopyWithImpl<_DoshaQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoshaQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoshaQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.category, category) || other.category == category)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(_options),category,order);

@override
String toString() {
  return 'DoshaQuestion(id: $id, question: $question, options: $options, category: $category, order: $order)';
}


}

/// @nodoc
abstract mixin class _$DoshaQuestionCopyWith<$Res> implements $DoshaQuestionCopyWith<$Res> {
  factory _$DoshaQuestionCopyWith(_DoshaQuestion value, $Res Function(_DoshaQuestion) _then) = __$DoshaQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, Map<String, String> options, String category, int order
});




}
/// @nodoc
class __$DoshaQuestionCopyWithImpl<$Res>
    implements _$DoshaQuestionCopyWith<$Res> {
  __$DoshaQuestionCopyWithImpl(this._self, this._then);

  final _DoshaQuestion _self;
  final $Res Function(_DoshaQuestion) _then;

/// Create a copy of DoshaQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? options = null,Object? category = null,Object? order = null,}) {
  return _then(_DoshaQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as Map<String, String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
