// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dosha_quiz_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DoshaQuizState {

 List<DoshaQuestion> get questions; int get currentIndex; Map<String, String> get answers;// questionId -> dosha (vata/pitta/kapha)
 bool get isLoading; String? get resultDosha;
/// Create a copy of DoshaQuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoshaQuizStateCopyWith<DoshaQuizState> get copyWith => _$DoshaQuizStateCopyWithImpl<DoshaQuizState>(this as DoshaQuizState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoshaQuizState&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.resultDosha, resultDosha) || other.resultDosha == resultDosha));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(questions),currentIndex,const DeepCollectionEquality().hash(answers),isLoading,resultDosha);

@override
String toString() {
  return 'DoshaQuizState(questions: $questions, currentIndex: $currentIndex, answers: $answers, isLoading: $isLoading, resultDosha: $resultDosha)';
}


}

/// @nodoc
abstract mixin class $DoshaQuizStateCopyWith<$Res>  {
  factory $DoshaQuizStateCopyWith(DoshaQuizState value, $Res Function(DoshaQuizState) _then) = _$DoshaQuizStateCopyWithImpl;
@useResult
$Res call({
 List<DoshaQuestion> questions, int currentIndex, Map<String, String> answers, bool isLoading, String? resultDosha
});




}
/// @nodoc
class _$DoshaQuizStateCopyWithImpl<$Res>
    implements $DoshaQuizStateCopyWith<$Res> {
  _$DoshaQuizStateCopyWithImpl(this._self, this._then);

  final DoshaQuizState _self;
  final $Res Function(DoshaQuizState) _then;

/// Create a copy of DoshaQuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? currentIndex = null,Object? answers = null,Object? isLoading = null,Object? resultDosha = freezed,}) {
  return _then(_self.copyWith(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<DoshaQuestion>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,resultDosha: freezed == resultDosha ? _self.resultDosha : resultDosha // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DoshaQuizState].
extension DoshaQuizStatePatterns on DoshaQuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DoshaQuizState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DoshaQuizState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DoshaQuizState value)  $default,){
final _that = this;
switch (_that) {
case _DoshaQuizState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DoshaQuizState value)?  $default,){
final _that = this;
switch (_that) {
case _DoshaQuizState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DoshaQuestion> questions,  int currentIndex,  Map<String, String> answers,  bool isLoading,  String? resultDosha)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DoshaQuizState() when $default != null:
return $default(_that.questions,_that.currentIndex,_that.answers,_that.isLoading,_that.resultDosha);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DoshaQuestion> questions,  int currentIndex,  Map<String, String> answers,  bool isLoading,  String? resultDosha)  $default,) {final _that = this;
switch (_that) {
case _DoshaQuizState():
return $default(_that.questions,_that.currentIndex,_that.answers,_that.isLoading,_that.resultDosha);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DoshaQuestion> questions,  int currentIndex,  Map<String, String> answers,  bool isLoading,  String? resultDosha)?  $default,) {final _that = this;
switch (_that) {
case _DoshaQuizState() when $default != null:
return $default(_that.questions,_that.currentIndex,_that.answers,_that.isLoading,_that.resultDosha);case _:
  return null;

}
}

}

/// @nodoc


class _DoshaQuizState implements DoshaQuizState {
  const _DoshaQuizState({final  List<DoshaQuestion> questions = const [], this.currentIndex = 0, final  Map<String, String> answers = const {}, this.isLoading = false, this.resultDosha}): _questions = questions,_answers = answers;
  

 final  List<DoshaQuestion> _questions;
@override@JsonKey() List<DoshaQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override@JsonKey() final  int currentIndex;
 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

// questionId -> dosha (vata/pitta/kapha)
@override@JsonKey() final  bool isLoading;
@override final  String? resultDosha;

/// Create a copy of DoshaQuizState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoshaQuizStateCopyWith<_DoshaQuizState> get copyWith => __$DoshaQuizStateCopyWithImpl<_DoshaQuizState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DoshaQuizState&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other._answers, _answers)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.resultDosha, resultDosha) || other.resultDosha == resultDosha));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions),currentIndex,const DeepCollectionEquality().hash(_answers),isLoading,resultDosha);

@override
String toString() {
  return 'DoshaQuizState(questions: $questions, currentIndex: $currentIndex, answers: $answers, isLoading: $isLoading, resultDosha: $resultDosha)';
}


}

/// @nodoc
abstract mixin class _$DoshaQuizStateCopyWith<$Res> implements $DoshaQuizStateCopyWith<$Res> {
  factory _$DoshaQuizStateCopyWith(_DoshaQuizState value, $Res Function(_DoshaQuizState) _then) = __$DoshaQuizStateCopyWithImpl;
@override @useResult
$Res call({
 List<DoshaQuestion> questions, int currentIndex, Map<String, String> answers, bool isLoading, String? resultDosha
});




}
/// @nodoc
class __$DoshaQuizStateCopyWithImpl<$Res>
    implements _$DoshaQuizStateCopyWith<$Res> {
  __$DoshaQuizStateCopyWithImpl(this._self, this._then);

  final _DoshaQuizState _self;
  final $Res Function(_DoshaQuizState) _then;

/// Create a copy of DoshaQuizState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? currentIndex = null,Object? answers = null,Object? isLoading = null,Object? resultDosha = freezed,}) {
  return _then(_DoshaQuizState(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<DoshaQuestion>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,resultDosha: freezed == resultDosha ? _self.resultDosha : resultDosha // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
