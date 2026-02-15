// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeightLog {

 String get id; String get userId; DateTime get date; double get weight;// in kg
 String? get note; String? get photo; double? get bodyFatPercentage; double? get muscleMass; BodyMeasurements? get measurements; String? get mood;// happy, neutral, sad, motivated, frustrated
 bool get isSynced;
/// Create a copy of WeightLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightLogCopyWith<WeightLog> get copyWith => _$WeightLogCopyWithImpl<WeightLog>(this as WeightLog, _$identity);

  /// Serializes this WeightLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.note, note) || other.note == note)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.bodyFatPercentage, bodyFatPercentage) || other.bodyFatPercentage == bodyFatPercentage)&&(identical(other.muscleMass, muscleMass) || other.muscleMass == muscleMass)&&(identical(other.measurements, measurements) || other.measurements == measurements)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,weight,note,photo,bodyFatPercentage,muscleMass,measurements,mood,isSynced);

@override
String toString() {
  return 'WeightLog(id: $id, userId: $userId, date: $date, weight: $weight, note: $note, photo: $photo, bodyFatPercentage: $bodyFatPercentage, muscleMass: $muscleMass, measurements: $measurements, mood: $mood, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class $WeightLogCopyWith<$Res>  {
  factory $WeightLogCopyWith(WeightLog value, $Res Function(WeightLog) _then) = _$WeightLogCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime date, double weight, String? note, String? photo, double? bodyFatPercentage, double? muscleMass, BodyMeasurements? measurements, String? mood, bool isSynced
});


$BodyMeasurementsCopyWith<$Res>? get measurements;

}
/// @nodoc
class _$WeightLogCopyWithImpl<$Res>
    implements $WeightLogCopyWith<$Res> {
  _$WeightLogCopyWithImpl(this._self, this._then);

  final WeightLog _self;
  final $Res Function(WeightLog) _then;

/// Create a copy of WeightLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? weight = null,Object? note = freezed,Object? photo = freezed,Object? bodyFatPercentage = freezed,Object? muscleMass = freezed,Object? measurements = freezed,Object? mood = freezed,Object? isSynced = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,bodyFatPercentage: freezed == bodyFatPercentage ? _self.bodyFatPercentage : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
as double?,muscleMass: freezed == muscleMass ? _self.muscleMass : muscleMass // ignore: cast_nullable_to_non_nullable
as double?,measurements: freezed == measurements ? _self.measurements : measurements // ignore: cast_nullable_to_non_nullable
as BodyMeasurements?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of WeightLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyMeasurementsCopyWith<$Res>? get measurements {
    if (_self.measurements == null) {
    return null;
  }

  return $BodyMeasurementsCopyWith<$Res>(_self.measurements!, (value) {
    return _then(_self.copyWith(measurements: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeightLog].
extension WeightLogPatterns on WeightLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightLog value)  $default,){
final _that = this;
switch (_that) {
case _WeightLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightLog value)?  $default,){
final _that = this;
switch (_that) {
case _WeightLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  double weight,  String? note,  String? photo,  double? bodyFatPercentage,  double? muscleMass,  BodyMeasurements? measurements,  String? mood,  bool isSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightLog() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.weight,_that.note,_that.photo,_that.bodyFatPercentage,_that.muscleMass,_that.measurements,_that.mood,_that.isSynced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  double weight,  String? note,  String? photo,  double? bodyFatPercentage,  double? muscleMass,  BodyMeasurements? measurements,  String? mood,  bool isSynced)  $default,) {final _that = this;
switch (_that) {
case _WeightLog():
return $default(_that.id,_that.userId,_that.date,_that.weight,_that.note,_that.photo,_that.bodyFatPercentage,_that.muscleMass,_that.measurements,_that.mood,_that.isSynced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime date,  double weight,  String? note,  String? photo,  double? bodyFatPercentage,  double? muscleMass,  BodyMeasurements? measurements,  String? mood,  bool isSynced)?  $default,) {final _that = this;
switch (_that) {
case _WeightLog() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.weight,_that.note,_that.photo,_that.bodyFatPercentage,_that.muscleMass,_that.measurements,_that.mood,_that.isSynced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightLog extends WeightLog {
  const _WeightLog({required this.id, required this.userId, required this.date, required this.weight, this.note, this.photo, this.bodyFatPercentage, this.muscleMass, this.measurements, this.mood, this.isSynced = false}): super._();
  factory _WeightLog.fromJson(Map<String, dynamic> json) => _$WeightLogFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime date;
@override final  double weight;
// in kg
@override final  String? note;
@override final  String? photo;
@override final  double? bodyFatPercentage;
@override final  double? muscleMass;
@override final  BodyMeasurements? measurements;
@override final  String? mood;
// happy, neutral, sad, motivated, frustrated
@override@JsonKey() final  bool isSynced;

/// Create a copy of WeightLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightLogCopyWith<_WeightLog> get copyWith => __$WeightLogCopyWithImpl<_WeightLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.note, note) || other.note == note)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.bodyFatPercentage, bodyFatPercentage) || other.bodyFatPercentage == bodyFatPercentage)&&(identical(other.muscleMass, muscleMass) || other.muscleMass == muscleMass)&&(identical(other.measurements, measurements) || other.measurements == measurements)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,weight,note,photo,bodyFatPercentage,muscleMass,measurements,mood,isSynced);

@override
String toString() {
  return 'WeightLog(id: $id, userId: $userId, date: $date, weight: $weight, note: $note, photo: $photo, bodyFatPercentage: $bodyFatPercentage, muscleMass: $muscleMass, measurements: $measurements, mood: $mood, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class _$WeightLogCopyWith<$Res> implements $WeightLogCopyWith<$Res> {
  factory _$WeightLogCopyWith(_WeightLog value, $Res Function(_WeightLog) _then) = __$WeightLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime date, double weight, String? note, String? photo, double? bodyFatPercentage, double? muscleMass, BodyMeasurements? measurements, String? mood, bool isSynced
});


@override $BodyMeasurementsCopyWith<$Res>? get measurements;

}
/// @nodoc
class __$WeightLogCopyWithImpl<$Res>
    implements _$WeightLogCopyWith<$Res> {
  __$WeightLogCopyWithImpl(this._self, this._then);

  final _WeightLog _self;
  final $Res Function(_WeightLog) _then;

/// Create a copy of WeightLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? weight = null,Object? note = freezed,Object? photo = freezed,Object? bodyFatPercentage = freezed,Object? muscleMass = freezed,Object? measurements = freezed,Object? mood = freezed,Object? isSynced = null,}) {
  return _then(_WeightLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,bodyFatPercentage: freezed == bodyFatPercentage ? _self.bodyFatPercentage : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
as double?,muscleMass: freezed == muscleMass ? _self.muscleMass : muscleMass // ignore: cast_nullable_to_non_nullable
as double?,measurements: freezed == measurements ? _self.measurements : measurements // ignore: cast_nullable_to_non_nullable
as BodyMeasurements?,mood: freezed == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of WeightLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyMeasurementsCopyWith<$Res>? get measurements {
    if (_self.measurements == null) {
    return null;
  }

  return $BodyMeasurementsCopyWith<$Res>(_self.measurements!, (value) {
    return _then(_self.copyWith(measurements: value));
  });
}
}


/// @nodoc
mixin _$WeightGoals {

 String get id; String get userId; double? get startWeight; double? get currentWeight; double? get goalWeight; String get goalType;// lose, maintain, gain
 double get weeklyGoalKg; bool get reminderEnabled; String get reminderDay;// daily, weekly
 String get reminderTime; bool get photoReminders; bool get notificationsEnabled;
/// Create a copy of WeightGoals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightGoalsCopyWith<WeightGoals> get copyWith => _$WeightGoalsCopyWithImpl<WeightGoals>(this as WeightGoals, _$identity);

  /// Serializes this WeightGoals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightGoals&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startWeight, startWeight) || other.startWeight == startWeight)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.weeklyGoalKg, weeklyGoalKg) || other.weeklyGoalKg == weeklyGoalKg)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderDay, reminderDay) || other.reminderDay == reminderDay)&&(identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime)&&(identical(other.photoReminders, photoReminders) || other.photoReminders == photoReminders)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startWeight,currentWeight,goalWeight,goalType,weeklyGoalKg,reminderEnabled,reminderDay,reminderTime,photoReminders,notificationsEnabled);

@override
String toString() {
  return 'WeightGoals(id: $id, userId: $userId, startWeight: $startWeight, currentWeight: $currentWeight, goalWeight: $goalWeight, goalType: $goalType, weeklyGoalKg: $weeklyGoalKg, reminderEnabled: $reminderEnabled, reminderDay: $reminderDay, reminderTime: $reminderTime, photoReminders: $photoReminders, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $WeightGoalsCopyWith<$Res>  {
  factory $WeightGoalsCopyWith(WeightGoals value, $Res Function(WeightGoals) _then) = _$WeightGoalsCopyWithImpl;
@useResult
$Res call({
 String id, String userId, double? startWeight, double? currentWeight, double? goalWeight, String goalType, double weeklyGoalKg, bool reminderEnabled, String reminderDay, String reminderTime, bool photoReminders, bool notificationsEnabled
});




}
/// @nodoc
class _$WeightGoalsCopyWithImpl<$Res>
    implements $WeightGoalsCopyWith<$Res> {
  _$WeightGoalsCopyWithImpl(this._self, this._then);

  final WeightGoals _self;
  final $Res Function(WeightGoals) _then;

/// Create a copy of WeightGoals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? startWeight = freezed,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? goalType = null,Object? weeklyGoalKg = null,Object? reminderEnabled = null,Object? reminderDay = null,Object? reminderTime = null,Object? photoReminders = null,Object? notificationsEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startWeight: freezed == startWeight ? _self.startWeight : startWeight // ignore: cast_nullable_to_non_nullable
as double?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,weeklyGoalKg: null == weeklyGoalKg ? _self.weeklyGoalKg : weeklyGoalKg // ignore: cast_nullable_to_non_nullable
as double,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderDay: null == reminderDay ? _self.reminderDay : reminderDay // ignore: cast_nullable_to_non_nullable
as String,reminderTime: null == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as String,photoReminders: null == photoReminders ? _self.photoReminders : photoReminders // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightGoals].
extension WeightGoalsPatterns on WeightGoals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightGoals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightGoals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightGoals value)  $default,){
final _that = this;
switch (_that) {
case _WeightGoals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightGoals value)?  $default,){
final _that = this;
switch (_that) {
case _WeightGoals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  double? startWeight,  double? currentWeight,  double? goalWeight,  String goalType,  double weeklyGoalKg,  bool reminderEnabled,  String reminderDay,  String reminderTime,  bool photoReminders,  bool notificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightGoals() when $default != null:
return $default(_that.id,_that.userId,_that.startWeight,_that.currentWeight,_that.goalWeight,_that.goalType,_that.weeklyGoalKg,_that.reminderEnabled,_that.reminderDay,_that.reminderTime,_that.photoReminders,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  double? startWeight,  double? currentWeight,  double? goalWeight,  String goalType,  double weeklyGoalKg,  bool reminderEnabled,  String reminderDay,  String reminderTime,  bool photoReminders,  bool notificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _WeightGoals():
return $default(_that.id,_that.userId,_that.startWeight,_that.currentWeight,_that.goalWeight,_that.goalType,_that.weeklyGoalKg,_that.reminderEnabled,_that.reminderDay,_that.reminderTime,_that.photoReminders,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  double? startWeight,  double? currentWeight,  double? goalWeight,  String goalType,  double weeklyGoalKg,  bool reminderEnabled,  String reminderDay,  String reminderTime,  bool photoReminders,  bool notificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _WeightGoals() when $default != null:
return $default(_that.id,_that.userId,_that.startWeight,_that.currentWeight,_that.goalWeight,_that.goalType,_that.weeklyGoalKg,_that.reminderEnabled,_that.reminderDay,_that.reminderTime,_that.photoReminders,_that.notificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightGoals extends WeightGoals {
  const _WeightGoals({required this.id, required this.userId, this.startWeight, this.currentWeight, this.goalWeight, this.goalType = 'maintain', this.weeklyGoalKg = 0.5, this.reminderEnabled = true, this.reminderDay = 'weekly', this.reminderTime = '08:00', this.photoReminders = true, this.notificationsEnabled = true}): super._();
  factory _WeightGoals.fromJson(Map<String, dynamic> json) => _$WeightGoalsFromJson(json);

@override final  String id;
@override final  String userId;
@override final  double? startWeight;
@override final  double? currentWeight;
@override final  double? goalWeight;
@override@JsonKey() final  String goalType;
// lose, maintain, gain
@override@JsonKey() final  double weeklyGoalKg;
@override@JsonKey() final  bool reminderEnabled;
@override@JsonKey() final  String reminderDay;
// daily, weekly
@override@JsonKey() final  String reminderTime;
@override@JsonKey() final  bool photoReminders;
@override@JsonKey() final  bool notificationsEnabled;

/// Create a copy of WeightGoals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightGoalsCopyWith<_WeightGoals> get copyWith => __$WeightGoalsCopyWithImpl<_WeightGoals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightGoalsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightGoals&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startWeight, startWeight) || other.startWeight == startWeight)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.goalType, goalType) || other.goalType == goalType)&&(identical(other.weeklyGoalKg, weeklyGoalKg) || other.weeklyGoalKg == weeklyGoalKg)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderDay, reminderDay) || other.reminderDay == reminderDay)&&(identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime)&&(identical(other.photoReminders, photoReminders) || other.photoReminders == photoReminders)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,startWeight,currentWeight,goalWeight,goalType,weeklyGoalKg,reminderEnabled,reminderDay,reminderTime,photoReminders,notificationsEnabled);

@override
String toString() {
  return 'WeightGoals(id: $id, userId: $userId, startWeight: $startWeight, currentWeight: $currentWeight, goalWeight: $goalWeight, goalType: $goalType, weeklyGoalKg: $weeklyGoalKg, reminderEnabled: $reminderEnabled, reminderDay: $reminderDay, reminderTime: $reminderTime, photoReminders: $photoReminders, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$WeightGoalsCopyWith<$Res> implements $WeightGoalsCopyWith<$Res> {
  factory _$WeightGoalsCopyWith(_WeightGoals value, $Res Function(_WeightGoals) _then) = __$WeightGoalsCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, double? startWeight, double? currentWeight, double? goalWeight, String goalType, double weeklyGoalKg, bool reminderEnabled, String reminderDay, String reminderTime, bool photoReminders, bool notificationsEnabled
});




}
/// @nodoc
class __$WeightGoalsCopyWithImpl<$Res>
    implements _$WeightGoalsCopyWith<$Res> {
  __$WeightGoalsCopyWithImpl(this._self, this._then);

  final _WeightGoals _self;
  final $Res Function(_WeightGoals) _then;

/// Create a copy of WeightGoals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? startWeight = freezed,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? goalType = null,Object? weeklyGoalKg = null,Object? reminderEnabled = null,Object? reminderDay = null,Object? reminderTime = null,Object? photoReminders = null,Object? notificationsEnabled = null,}) {
  return _then(_WeightGoals(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startWeight: freezed == startWeight ? _self.startWeight : startWeight // ignore: cast_nullable_to_non_nullable
as double?,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,goalType: null == goalType ? _self.goalType : goalType // ignore: cast_nullable_to_non_nullable
as String,weeklyGoalKg: null == weeklyGoalKg ? _self.weeklyGoalKg : weeklyGoalKg // ignore: cast_nullable_to_non_nullable
as double,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderDay: null == reminderDay ? _self.reminderDay : reminderDay // ignore: cast_nullable_to_non_nullable
as String,reminderTime: null == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as String,photoReminders: null == photoReminders ? _self.photoReminders : photoReminders // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BodyMeasurements {

 double? get chest; double? get waist; double? get hips; double? get arms; double? get thighs;
/// Create a copy of BodyMeasurements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyMeasurementsCopyWith<BodyMeasurements> get copyWith => _$BodyMeasurementsCopyWithImpl<BodyMeasurements>(this as BodyMeasurements, _$identity);

  /// Serializes this BodyMeasurements to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BodyMeasurements&&(identical(other.chest, chest) || other.chest == chest)&&(identical(other.waist, waist) || other.waist == waist)&&(identical(other.hips, hips) || other.hips == hips)&&(identical(other.arms, arms) || other.arms == arms)&&(identical(other.thighs, thighs) || other.thighs == thighs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chest,waist,hips,arms,thighs);

@override
String toString() {
  return 'BodyMeasurements(chest: $chest, waist: $waist, hips: $hips, arms: $arms, thighs: $thighs)';
}


}

/// @nodoc
abstract mixin class $BodyMeasurementsCopyWith<$Res>  {
  factory $BodyMeasurementsCopyWith(BodyMeasurements value, $Res Function(BodyMeasurements) _then) = _$BodyMeasurementsCopyWithImpl;
@useResult
$Res call({
 double? chest, double? waist, double? hips, double? arms, double? thighs
});




}
/// @nodoc
class _$BodyMeasurementsCopyWithImpl<$Res>
    implements $BodyMeasurementsCopyWith<$Res> {
  _$BodyMeasurementsCopyWithImpl(this._self, this._then);

  final BodyMeasurements _self;
  final $Res Function(BodyMeasurements) _then;

/// Create a copy of BodyMeasurements
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chest = freezed,Object? waist = freezed,Object? hips = freezed,Object? arms = freezed,Object? thighs = freezed,}) {
  return _then(_self.copyWith(
chest: freezed == chest ? _self.chest : chest // ignore: cast_nullable_to_non_nullable
as double?,waist: freezed == waist ? _self.waist : waist // ignore: cast_nullable_to_non_nullable
as double?,hips: freezed == hips ? _self.hips : hips // ignore: cast_nullable_to_non_nullable
as double?,arms: freezed == arms ? _self.arms : arms // ignore: cast_nullable_to_non_nullable
as double?,thighs: freezed == thighs ? _self.thighs : thighs // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BodyMeasurements].
extension BodyMeasurementsPatterns on BodyMeasurements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BodyMeasurements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BodyMeasurements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BodyMeasurements value)  $default,){
final _that = this;
switch (_that) {
case _BodyMeasurements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BodyMeasurements value)?  $default,){
final _that = this;
switch (_that) {
case _BodyMeasurements() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? chest,  double? waist,  double? hips,  double? arms,  double? thighs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BodyMeasurements() when $default != null:
return $default(_that.chest,_that.waist,_that.hips,_that.arms,_that.thighs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? chest,  double? waist,  double? hips,  double? arms,  double? thighs)  $default,) {final _that = this;
switch (_that) {
case _BodyMeasurements():
return $default(_that.chest,_that.waist,_that.hips,_that.arms,_that.thighs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? chest,  double? waist,  double? hips,  double? arms,  double? thighs)?  $default,) {final _that = this;
switch (_that) {
case _BodyMeasurements() when $default != null:
return $default(_that.chest,_that.waist,_that.hips,_that.arms,_that.thighs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BodyMeasurements extends BodyMeasurements {
  const _BodyMeasurements({this.chest, this.waist, this.hips, this.arms, this.thighs}): super._();
  factory _BodyMeasurements.fromJson(Map<String, dynamic> json) => _$BodyMeasurementsFromJson(json);

@override final  double? chest;
@override final  double? waist;
@override final  double? hips;
@override final  double? arms;
@override final  double? thighs;

/// Create a copy of BodyMeasurements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyMeasurementsCopyWith<_BodyMeasurements> get copyWith => __$BodyMeasurementsCopyWithImpl<_BodyMeasurements>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BodyMeasurementsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BodyMeasurements&&(identical(other.chest, chest) || other.chest == chest)&&(identical(other.waist, waist) || other.waist == waist)&&(identical(other.hips, hips) || other.hips == hips)&&(identical(other.arms, arms) || other.arms == arms)&&(identical(other.thighs, thighs) || other.thighs == thighs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chest,waist,hips,arms,thighs);

@override
String toString() {
  return 'BodyMeasurements(chest: $chest, waist: $waist, hips: $hips, arms: $arms, thighs: $thighs)';
}


}

/// @nodoc
abstract mixin class _$BodyMeasurementsCopyWith<$Res> implements $BodyMeasurementsCopyWith<$Res> {
  factory _$BodyMeasurementsCopyWith(_BodyMeasurements value, $Res Function(_BodyMeasurements) _then) = __$BodyMeasurementsCopyWithImpl;
@override @useResult
$Res call({
 double? chest, double? waist, double? hips, double? arms, double? thighs
});




}
/// @nodoc
class __$BodyMeasurementsCopyWithImpl<$Res>
    implements _$BodyMeasurementsCopyWith<$Res> {
  __$BodyMeasurementsCopyWithImpl(this._self, this._then);

  final _BodyMeasurements _self;
  final $Res Function(_BodyMeasurements) _then;

/// Create a copy of BodyMeasurements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chest = freezed,Object? waist = freezed,Object? hips = freezed,Object? arms = freezed,Object? thighs = freezed,}) {
  return _then(_BodyMeasurements(
chest: freezed == chest ? _self.chest : chest // ignore: cast_nullable_to_non_nullable
as double?,waist: freezed == waist ? _self.waist : waist // ignore: cast_nullable_to_non_nullable
as double?,hips: freezed == hips ? _self.hips : hips // ignore: cast_nullable_to_non_nullable
as double?,arms: freezed == arms ? _self.arms : arms // ignore: cast_nullable_to_non_nullable
as double?,thighs: freezed == thighs ? _self.thighs : thighs // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$WeightTrend {

 DateTime get date; double get weight; double? get movingAverage; double? get changeFromPrevious;
/// Create a copy of WeightTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightTrendCopyWith<WeightTrend> get copyWith => _$WeightTrendCopyWithImpl<WeightTrend>(this as WeightTrend, _$identity);

  /// Serializes this WeightTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightTrend&&(identical(other.date, date) || other.date == date)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.movingAverage, movingAverage) || other.movingAverage == movingAverage)&&(identical(other.changeFromPrevious, changeFromPrevious) || other.changeFromPrevious == changeFromPrevious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,weight,movingAverage,changeFromPrevious);

@override
String toString() {
  return 'WeightTrend(date: $date, weight: $weight, movingAverage: $movingAverage, changeFromPrevious: $changeFromPrevious)';
}


}

/// @nodoc
abstract mixin class $WeightTrendCopyWith<$Res>  {
  factory $WeightTrendCopyWith(WeightTrend value, $Res Function(WeightTrend) _then) = _$WeightTrendCopyWithImpl;
@useResult
$Res call({
 DateTime date, double weight, double? movingAverage, double? changeFromPrevious
});




}
/// @nodoc
class _$WeightTrendCopyWithImpl<$Res>
    implements $WeightTrendCopyWith<$Res> {
  _$WeightTrendCopyWithImpl(this._self, this._then);

  final WeightTrend _self;
  final $Res Function(WeightTrend) _then;

/// Create a copy of WeightTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? weight = null,Object? movingAverage = freezed,Object? changeFromPrevious = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,movingAverage: freezed == movingAverage ? _self.movingAverage : movingAverage // ignore: cast_nullable_to_non_nullable
as double?,changeFromPrevious: freezed == changeFromPrevious ? _self.changeFromPrevious : changeFromPrevious // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightTrend].
extension WeightTrendPatterns on WeightTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightTrend value)  $default,){
final _that = this;
switch (_that) {
case _WeightTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightTrend value)?  $default,){
final _that = this;
switch (_that) {
case _WeightTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double weight,  double? movingAverage,  double? changeFromPrevious)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightTrend() when $default != null:
return $default(_that.date,_that.weight,_that.movingAverage,_that.changeFromPrevious);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double weight,  double? movingAverage,  double? changeFromPrevious)  $default,) {final _that = this;
switch (_that) {
case _WeightTrend():
return $default(_that.date,_that.weight,_that.movingAverage,_that.changeFromPrevious);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double weight,  double? movingAverage,  double? changeFromPrevious)?  $default,) {final _that = this;
switch (_that) {
case _WeightTrend() when $default != null:
return $default(_that.date,_that.weight,_that.movingAverage,_that.changeFromPrevious);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightTrend implements WeightTrend {
  const _WeightTrend({required this.date, required this.weight, this.movingAverage, this.changeFromPrevious});
  factory _WeightTrend.fromJson(Map<String, dynamic> json) => _$WeightTrendFromJson(json);

@override final  DateTime date;
@override final  double weight;
@override final  double? movingAverage;
@override final  double? changeFromPrevious;

/// Create a copy of WeightTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightTrendCopyWith<_WeightTrend> get copyWith => __$WeightTrendCopyWithImpl<_WeightTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightTrend&&(identical(other.date, date) || other.date == date)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.movingAverage, movingAverage) || other.movingAverage == movingAverage)&&(identical(other.changeFromPrevious, changeFromPrevious) || other.changeFromPrevious == changeFromPrevious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,weight,movingAverage,changeFromPrevious);

@override
String toString() {
  return 'WeightTrend(date: $date, weight: $weight, movingAverage: $movingAverage, changeFromPrevious: $changeFromPrevious)';
}


}

/// @nodoc
abstract mixin class _$WeightTrendCopyWith<$Res> implements $WeightTrendCopyWith<$Res> {
  factory _$WeightTrendCopyWith(_WeightTrend value, $Res Function(_WeightTrend) _then) = __$WeightTrendCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double weight, double? movingAverage, double? changeFromPrevious
});




}
/// @nodoc
class __$WeightTrendCopyWithImpl<$Res>
    implements _$WeightTrendCopyWith<$Res> {
  __$WeightTrendCopyWithImpl(this._self, this._then);

  final _WeightTrend _self;
  final $Res Function(_WeightTrend) _then;

/// Create a copy of WeightTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? weight = null,Object? movingAverage = freezed,Object? changeFromPrevious = freezed,}) {
  return _then(_WeightTrend(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,movingAverage: freezed == movingAverage ? _self.movingAverage : movingAverage // ignore: cast_nullable_to_non_nullable
as double?,changeFromPrevious: freezed == changeFromPrevious ? _self.changeFromPrevious : changeFromPrevious // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
