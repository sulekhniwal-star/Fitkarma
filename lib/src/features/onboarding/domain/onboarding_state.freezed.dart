// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 int get currentStep; String get name; int get age; String get gender; double get height; double get weight; String get goal; String get activityLevel; String get dietaryPreference; String get language; List<String> get healthConditions; List<String> get workoutPreferences; String? get dosha;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.dietaryPreference, dietaryPreference) || other.dietaryPreference == dietaryPreference)&&(identical(other.language, language) || other.language == language)&&const DeepCollectionEquality().equals(other.healthConditions, healthConditions)&&const DeepCollectionEquality().equals(other.workoutPreferences, workoutPreferences)&&(identical(other.dosha, dosha) || other.dosha == dosha));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,name,age,gender,height,weight,goal,activityLevel,dietaryPreference,language,const DeepCollectionEquality().hash(healthConditions),const DeepCollectionEquality().hash(workoutPreferences),dosha);

@override
String toString() {
  return 'OnboardingState(currentStep: $currentStep, name: $name, age: $age, gender: $gender, height: $height, weight: $weight, goal: $goal, activityLevel: $activityLevel, dietaryPreference: $dietaryPreference, language: $language, healthConditions: $healthConditions, workoutPreferences: $workoutPreferences, dosha: $dosha)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int currentStep, String name, int age, String gender, double height, double weight, String goal, String activityLevel, String dietaryPreference, String language, List<String> healthConditions, List<String> workoutPreferences, String? dosha
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? name = null,Object? age = null,Object? gender = null,Object? height = null,Object? weight = null,Object? goal = null,Object? activityLevel = null,Object? dietaryPreference = null,Object? language = null,Object? healthConditions = null,Object? workoutPreferences = null,Object? dosha = freezed,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String,dietaryPreference: null == dietaryPreference ? _self.dietaryPreference : dietaryPreference // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,healthConditions: null == healthConditions ? _self.healthConditions : healthConditions // ignore: cast_nullable_to_non_nullable
as List<String>,workoutPreferences: null == workoutPreferences ? _self.workoutPreferences : workoutPreferences // ignore: cast_nullable_to_non_nullable
as List<String>,dosha: freezed == dosha ? _self.dosha : dosha // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStep,  String name,  int age,  String gender,  double height,  double weight,  String goal,  String activityLevel,  String dietaryPreference,  String language,  List<String> healthConditions,  List<String> workoutPreferences,  String? dosha)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentStep,_that.name,_that.age,_that.gender,_that.height,_that.weight,_that.goal,_that.activityLevel,_that.dietaryPreference,_that.language,_that.healthConditions,_that.workoutPreferences,_that.dosha);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStep,  String name,  int age,  String gender,  double height,  double weight,  String goal,  String activityLevel,  String dietaryPreference,  String language,  List<String> healthConditions,  List<String> workoutPreferences,  String? dosha)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.currentStep,_that.name,_that.age,_that.gender,_that.height,_that.weight,_that.goal,_that.activityLevel,_that.dietaryPreference,_that.language,_that.healthConditions,_that.workoutPreferences,_that.dosha);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStep,  String name,  int age,  String gender,  double height,  double weight,  String goal,  String activityLevel,  String dietaryPreference,  String language,  List<String> healthConditions,  List<String> workoutPreferences,  String? dosha)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentStep,_that.name,_that.age,_that.gender,_that.height,_that.weight,_that.goal,_that.activityLevel,_that.dietaryPreference,_that.language,_that.healthConditions,_that.workoutPreferences,_that.dosha);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.currentStep = 0, this.name = '', this.age = 18, this.gender = 'Male', this.height = 170.0, this.weight = 70.0, this.goal = 'Weight Loss', this.activityLevel = 'Sedentary', this.dietaryPreference = 'Vegetarian', this.language = 'English', final  List<String> healthConditions = const [], final  List<String> workoutPreferences = const [], this.dosha}): _healthConditions = healthConditions,_workoutPreferences = workoutPreferences;
  

@override@JsonKey() final  int currentStep;
@override@JsonKey() final  String name;
@override@JsonKey() final  int age;
@override@JsonKey() final  String gender;
@override@JsonKey() final  double height;
@override@JsonKey() final  double weight;
@override@JsonKey() final  String goal;
@override@JsonKey() final  String activityLevel;
@override@JsonKey() final  String dietaryPreference;
@override@JsonKey() final  String language;
 final  List<String> _healthConditions;
@override@JsonKey() List<String> get healthConditions {
  if (_healthConditions is EqualUnmodifiableListView) return _healthConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_healthConditions);
}

 final  List<String> _workoutPreferences;
@override@JsonKey() List<String> get workoutPreferences {
  if (_workoutPreferences is EqualUnmodifiableListView) return _workoutPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workoutPreferences);
}

@override final  String? dosha;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.dietaryPreference, dietaryPreference) || other.dietaryPreference == dietaryPreference)&&(identical(other.language, language) || other.language == language)&&const DeepCollectionEquality().equals(other._healthConditions, _healthConditions)&&const DeepCollectionEquality().equals(other._workoutPreferences, _workoutPreferences)&&(identical(other.dosha, dosha) || other.dosha == dosha));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,name,age,gender,height,weight,goal,activityLevel,dietaryPreference,language,const DeepCollectionEquality().hash(_healthConditions),const DeepCollectionEquality().hash(_workoutPreferences),dosha);

@override
String toString() {
  return 'OnboardingState(currentStep: $currentStep, name: $name, age: $age, gender: $gender, height: $height, weight: $weight, goal: $goal, activityLevel: $activityLevel, dietaryPreference: $dietaryPreference, language: $language, healthConditions: $healthConditions, workoutPreferences: $workoutPreferences, dosha: $dosha)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, String name, int age, String gender, double height, double weight, String goal, String activityLevel, String dietaryPreference, String language, List<String> healthConditions, List<String> workoutPreferences, String? dosha
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? name = null,Object? age = null,Object? gender = null,Object? height = null,Object? weight = null,Object? goal = null,Object? activityLevel = null,Object? dietaryPreference = null,Object? language = null,Object? healthConditions = null,Object? workoutPreferences = null,Object? dosha = freezed,}) {
  return _then(_OnboardingState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String,activityLevel: null == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String,dietaryPreference: null == dietaryPreference ? _self.dietaryPreference : dietaryPreference // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,healthConditions: null == healthConditions ? _self._healthConditions : healthConditions // ignore: cast_nullable_to_non_nullable
as List<String>,workoutPreferences: null == workoutPreferences ? _self._workoutPreferences : workoutPreferences // ignore: cast_nullable_to_non_nullable
as List<String>,dosha: freezed == dosha ? _self.dosha : dosha // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
