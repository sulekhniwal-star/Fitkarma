// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get email; String? get fullName; int? get age; String? get gender; double? get height; double? get currentWeight; double? get goalWeight; String? get activityLevel; String? get goalType; String? get dietaryPreference; String? get language; String? get dosha; List<String> get healthConditions; List<String> get workoutPreferences; int get karmaPoints; String get karmaTier; int get streakDays; DateTime? get lastActiveDate; String get subscriptionStatus; DateTime? get subscriptionExpires; String? get profilePhoto; bool get onboardingCompleted;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.height, height) || other.height == height)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.dietaryPreference, dietaryPreference) || other.dietaryPreference == dietaryPreference)&&(identical(other.language, language) || other.language == language)&&(identical(other.dosha, dosha) || other.dosha == dosha)&&const DeepCollectionEquality().equals(other.healthConditions, healthConditions)&&const DeepCollectionEquality().equals(other.workoutPreferences, workoutPreferences)&&(identical(other.karmaPoints, karmaPoints) || other.karmaPoints == karmaPoints)&&(identical(other.karmaTier, karmaTier) || other.karmaTier == karmaTier)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.subscriptionStatus, subscriptionStatus) || other.subscriptionStatus == subscriptionStatus)&&(identical(other.subscriptionExpires, subscriptionExpires) || other.subscriptionExpires == subscriptionExpires)&&(identical(other.profilePhoto, profilePhoto) || other.profilePhoto == profilePhoto)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,fullName,age,gender,height,currentWeight,goalWeight,activityLevel,goalType,dietaryPreference,language,dosha,const DeepCollectionEquality().hash(healthConditions),const DeepCollectionEquality().hash(workoutPreferences),karmaPoints,karmaTier,streakDays,lastActiveDate,subscriptionStatus,subscriptionExpires,profilePhoto,onboardingCompleted]);

@override
String toString() {
  return 'UserProfile(id: $id, email: $email, fullName: $fullName, age: $age, gender: $gender, height: $height, currentWeight: $currentWeight, goalWeight: $goalWeight, activityLevel: $activityLevel, goalType: $goalType, dietaryPreference: $dietaryPreference, language: $language, dosha: $dosha, healthConditions: $healthConditions, workoutPreferences: $workoutPreferences, karmaPoints: $karmaPoints, karmaTier: $karmaTier, streakDays: $streakDays, lastActiveDate: $lastActiveDate, subscriptionStatus: $subscriptionStatus, subscriptionExpires: $subscriptionExpires, profilePhoto: $profilePhoto, onboardingCompleted: $onboardingCompleted)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? fullName, int? age, String? gender, double? height, double? currentWeight, double? goalWeight, String? activityLevel, String? goalType, String? dietaryPreference, String? language, String? dosha, List<String> healthConditions, List<String> workoutPreferences, int karmaPoints, String karmaTier, int streakDays, DateTime? lastActiveDate, String subscriptionStatus, DateTime? subscriptionExpires, String? profilePhoto, bool onboardingCompleted
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? age = freezed,Object? gender = freezed,Object? height = freezed,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? activityLevel = freezed,Object? goalType = freezed,Object? dietaryPreference = freezed,Object? language = freezed,Object? dosha = freezed,Object? healthConditions = null,Object? workoutPreferences = null,Object? karmaPoints = null,Object? karmaTier = null,Object? streakDays = null,Object? lastActiveDate = freezed,Object? subscriptionStatus = null,Object? subscriptionExpires = freezed,Object? profilePhoto = freezed,Object? onboardingCompleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String?,goalType: freezed == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String?,dietaryPreference: freezed == dietaryPreference ? _self.dietaryPreference : dietaryPreference // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,dosha: freezed == dosha ? _self.dosha : dosha // ignore: cast_nullable_to_non_nullable
as String?,healthConditions: null == healthConditions ? _self.healthConditions : healthConditions // ignore: cast_nullable_to_non_nullable
as List<String>,workoutPreferences: null == workoutPreferences ? _self.workoutPreferences : workoutPreferences // ignore: cast_nullable_to_non_nullable
as List<String>,karmaPoints: null == karmaPoints ? _self.karmaPoints : karmaPoints // ignore: cast_nullable_to_non_nullable
as int,karmaTier: null == karmaTier ? _self.karmaTier : karmaTier // ignore: cast_nullable_to_non_nullable
as String,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,subscriptionStatus: null == subscriptionStatus ? _self.subscriptionStatus : subscriptionStatus // ignore: cast_nullable_to_non_nullable
as String,subscriptionExpires: freezed == subscriptionExpires ? _self.subscriptionExpires : subscriptionExpires // ignore: cast_nullable_to_non_nullable
as DateTime?,profilePhoto: freezed == profilePhoto ? _self.profilePhoto : profilePhoto // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  int? age,  String? gender,  double? height,  double? currentWeight,  double? goalWeight,  String? activityLevel,  String? goalType,  String? dietaryPreference,  String? language,  String? dosha,  List<String> healthConditions,  List<String> workoutPreferences,  int karmaPoints,  String karmaTier,  int streakDays,  DateTime? lastActiveDate,  String subscriptionStatus,  DateTime? subscriptionExpires,  String? profilePhoto,  bool onboardingCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.age,_that.gender,_that.height,_that.currentWeight,_that.goalWeight,_that.activityLevel,_that.goalType,_that.dietaryPreference,_that.language,_that.dosha,_that.healthConditions,_that.workoutPreferences,_that.karmaPoints,_that.karmaTier,_that.streakDays,_that.lastActiveDate,_that.subscriptionStatus,_that.subscriptionExpires,_that.profilePhoto,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? fullName,  int? age,  String? gender,  double? height,  double? currentWeight,  double? goalWeight,  String? activityLevel,  String? goalType,  String? dietaryPreference,  String? language,  String? dosha,  List<String> healthConditions,  List<String> workoutPreferences,  int karmaPoints,  String karmaTier,  int streakDays,  DateTime? lastActiveDate,  String subscriptionStatus,  DateTime? subscriptionExpires,  String? profilePhoto,  bool onboardingCompleted)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.email,_that.fullName,_that.age,_that.gender,_that.height,_that.currentWeight,_that.goalWeight,_that.activityLevel,_that.goalType,_that.dietaryPreference,_that.language,_that.dosha,_that.healthConditions,_that.workoutPreferences,_that.karmaPoints,_that.karmaTier,_that.streakDays,_that.lastActiveDate,_that.subscriptionStatus,_that.subscriptionExpires,_that.profilePhoto,_that.onboardingCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? fullName,  int? age,  String? gender,  double? height,  double? currentWeight,  double? goalWeight,  String? activityLevel,  String? goalType,  String? dietaryPreference,  String? language,  String? dosha,  List<String> healthConditions,  List<String> workoutPreferences,  int karmaPoints,  String karmaTier,  int streakDays,  DateTime? lastActiveDate,  String subscriptionStatus,  DateTime? subscriptionExpires,  String? profilePhoto,  bool onboardingCompleted)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.age,_that.gender,_that.height,_that.currentWeight,_that.goalWeight,_that.activityLevel,_that.goalType,_that.dietaryPreference,_that.language,_that.dosha,_that.healthConditions,_that.workoutPreferences,_that.karmaPoints,_that.karmaTier,_that.streakDays,_that.lastActiveDate,_that.subscriptionStatus,_that.subscriptionExpires,_that.profilePhoto,_that.onboardingCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile extends UserProfile {
  const _UserProfile({required this.id, required this.email, this.fullName, this.age, this.gender, this.height, this.currentWeight, this.goalWeight, this.activityLevel, this.goalType, this.dietaryPreference, this.language, this.dosha, final  List<String> healthConditions = const [], final  List<String> workoutPreferences = const [], this.karmaPoints = 0, this.karmaTier = 'Bronze', this.streakDays = 0, this.lastActiveDate, this.subscriptionStatus = 'free', this.subscriptionExpires, this.profilePhoto, this.onboardingCompleted = false}): _healthConditions = healthConditions,_workoutPreferences = workoutPreferences,super._();
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? fullName;
@override final  int? age;
@override final  String? gender;
@override final  double? height;
@override final  double? currentWeight;
@override final  double? goalWeight;
@override final  String? activityLevel;
@override final  String? goalType;
@override final  String? dietaryPreference;
@override final  String? language;
@override final  String? dosha;
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

@override@JsonKey() final  int karmaPoints;
@override@JsonKey() final  String karmaTier;
@override@JsonKey() final  int streakDays;
@override final  DateTime? lastActiveDate;
@override@JsonKey() final  String subscriptionStatus;
@override final  DateTime? subscriptionExpires;
@override final  String? profilePhoto;
@override@JsonKey() final  bool onboardingCompleted;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.height, height) || other.height == height)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.dietaryPreference, dietaryPreference) || other.dietaryPreference == dietaryPreference)&&(identical(other.language, language) || other.language == language)&&(identical(other.dosha, dosha) || other.dosha == dosha)&&const DeepCollectionEquality().equals(other._healthConditions, _healthConditions)&&const DeepCollectionEquality().equals(other._workoutPreferences, _workoutPreferences)&&(identical(other.karmaPoints, karmaPoints) || other.karmaPoints == karmaPoints)&&(identical(other.karmaTier, karmaTier) || other.karmaTier == karmaTier)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.subscriptionStatus, subscriptionStatus) || other.subscriptionStatus == subscriptionStatus)&&(identical(other.subscriptionExpires, subscriptionExpires) || other.subscriptionExpires == subscriptionExpires)&&(identical(other.profilePhoto, profilePhoto) || other.profilePhoto == profilePhoto)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,fullName,age,gender,height,currentWeight,goalWeight,activityLevel,goalType,dietaryPreference,language,dosha,const DeepCollectionEquality().hash(_healthConditions),const DeepCollectionEquality().hash(_workoutPreferences),karmaPoints,karmaTier,streakDays,lastActiveDate,subscriptionStatus,subscriptionExpires,profilePhoto,onboardingCompleted]);

@override
String toString() {
  return 'UserProfile(id: $id, email: $email, fullName: $fullName, age: $age, gender: $gender, height: $height, currentWeight: $currentWeight, goalWeight: $goalWeight, activityLevel: $activityLevel, goalType: $goalType, dietaryPreference: $dietaryPreference, language: $language, dosha: $dosha, healthConditions: $healthConditions, workoutPreferences: $workoutPreferences, karmaPoints: $karmaPoints, karmaTier: $karmaTier, streakDays: $streakDays, lastActiveDate: $lastActiveDate, subscriptionStatus: $subscriptionStatus, subscriptionExpires: $subscriptionExpires, profilePhoto: $profilePhoto, onboardingCompleted: $onboardingCompleted)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? fullName, int? age, String? gender, double? height, double? currentWeight, double? goalWeight, String? activityLevel, String? goalType, String? dietaryPreference, String? language, String? dosha, List<String> healthConditions, List<String> workoutPreferences, int karmaPoints, String karmaTier, int streakDays, DateTime? lastActiveDate, String subscriptionStatus, DateTime? subscriptionExpires, String? profilePhoto, bool onboardingCompleted
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = freezed,Object? age = freezed,Object? gender = freezed,Object? height = freezed,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? activityLevel = freezed,Object? goalType = freezed,Object? dietaryPreference = freezed,Object? language = freezed,Object? dosha = freezed,Object? healthConditions = null,Object? workoutPreferences = null,Object? karmaPoints = null,Object? karmaTier = null,Object? streakDays = null,Object? lastActiveDate = freezed,Object? subscriptionStatus = null,Object? subscriptionExpires = freezed,Object? profilePhoto = freezed,Object? onboardingCompleted = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String?,goalType: freezed == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String?,dietaryPreference: freezed == dietaryPreference ? _self.dietaryPreference : dietaryPreference // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,dosha: freezed == dosha ? _self.dosha : dosha // ignore: cast_nullable_to_non_nullable
as String?,healthConditions: null == healthConditions ? _self._healthConditions : healthConditions // ignore: cast_nullable_to_non_nullable
as List<String>,workoutPreferences: null == workoutPreferences ? _self._workoutPreferences : workoutPreferences // ignore: cast_nullable_to_non_nullable
as List<String>,karmaPoints: null == karmaPoints ? _self.karmaPoints : karmaPoints // ignore: cast_nullable_to_non_nullable
as int,karmaTier: null == karmaTier ? _self.karmaTier : karmaTier // ignore: cast_nullable_to_non_nullable
as String,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,subscriptionStatus: null == subscriptionStatus ? _self.subscriptionStatus : subscriptionStatus // ignore: cast_nullable_to_non_nullable
as String,subscriptionExpires: freezed == subscriptionExpires ? _self.subscriptionExpires : subscriptionExpires // ignore: cast_nullable_to_non_nullable
as DateTime?,profilePhoto: freezed == profilePhoto ? _self.profilePhoto : profilePhoto // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
