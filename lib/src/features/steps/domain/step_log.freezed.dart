// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StepLog {

 String get id; String get userId; DateTime get date; int get steps; int get goal; double? get distanceKm; double? get calories; List<int> get hourlyData;// Steps per hour (24 hours)
 String get source; bool get isSynced;
/// Create a copy of StepLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepLogCopyWith<StepLog> get copyWith => _$StepLogCopyWithImpl<StepLog>(this as StepLog, _$identity);

  /// Serializes this StepLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.calories, calories) || other.calories == calories)&&const DeepCollectionEquality().equals(other.hourlyData, hourlyData)&&(identical(other.source, source) || other.source == source)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,steps,goal,distanceKm,calories,const DeepCollectionEquality().hash(hourlyData),source,isSynced);

@override
String toString() {
  return 'StepLog(id: $id, userId: $userId, date: $date, steps: $steps, goal: $goal, distanceKm: $distanceKm, calories: $calories, hourlyData: $hourlyData, source: $source, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class $StepLogCopyWith<$Res>  {
  factory $StepLogCopyWith(StepLog value, $Res Function(StepLog) _then) = _$StepLogCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime date, int steps, int goal, double? distanceKm, double? calories, List<int> hourlyData, String source, bool isSynced
});




}
/// @nodoc
class _$StepLogCopyWithImpl<$Res>
    implements $StepLogCopyWith<$Res> {
  _$StepLogCopyWithImpl(this._self, this._then);

  final StepLog _self;
  final $Res Function(StepLog) _then;

/// Create a copy of StepLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? steps = null,Object? goal = null,Object? distanceKm = freezed,Object? calories = freezed,Object? hourlyData = null,Object? source = null,Object? isSynced = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,hourlyData: null == hourlyData ? _self.hourlyData : hourlyData // ignore: cast_nullable_to_non_nullable
as List<int>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StepLog].
extension StepLogPatterns on StepLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepLog value)  $default,){
final _that = this;
switch (_that) {
case _StepLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepLog value)?  $default,){
final _that = this;
switch (_that) {
case _StepLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  int steps,  int goal,  double? distanceKm,  double? calories,  List<int> hourlyData,  String source,  bool isSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepLog() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.steps,_that.goal,_that.distanceKm,_that.calories,_that.hourlyData,_that.source,_that.isSynced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  int steps,  int goal,  double? distanceKm,  double? calories,  List<int> hourlyData,  String source,  bool isSynced)  $default,) {final _that = this;
switch (_that) {
case _StepLog():
return $default(_that.id,_that.userId,_that.date,_that.steps,_that.goal,_that.distanceKm,_that.calories,_that.hourlyData,_that.source,_that.isSynced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime date,  int steps,  int goal,  double? distanceKm,  double? calories,  List<int> hourlyData,  String source,  bool isSynced)?  $default,) {final _that = this;
switch (_that) {
case _StepLog() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.steps,_that.goal,_that.distanceKm,_that.calories,_that.hourlyData,_that.source,_that.isSynced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepLog extends StepLog {
  const _StepLog({required this.id, required this.userId, required this.date, this.steps = 0, this.goal = 8000, this.distanceKm, this.calories, final  List<int> hourlyData = const [], this.source = 'pedometer', this.isSynced = false}): _hourlyData = hourlyData,super._();
  factory _StepLog.fromJson(Map<String, dynamic> json) => _$StepLogFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime date;
@override@JsonKey() final  int steps;
@override@JsonKey() final  int goal;
@override final  double? distanceKm;
@override final  double? calories;
 final  List<int> _hourlyData;
@override@JsonKey() List<int> get hourlyData {
  if (_hourlyData is EqualUnmodifiableListView) return _hourlyData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyData);
}

// Steps per hour (24 hours)
@override@JsonKey() final  String source;
@override@JsonKey() final  bool isSynced;

/// Create a copy of StepLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepLogCopyWith<_StepLog> get copyWith => __$StepLogCopyWithImpl<_StepLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.calories, calories) || other.calories == calories)&&const DeepCollectionEquality().equals(other._hourlyData, _hourlyData)&&(identical(other.source, source) || other.source == source)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,steps,goal,distanceKm,calories,const DeepCollectionEquality().hash(_hourlyData),source,isSynced);

@override
String toString() {
  return 'StepLog(id: $id, userId: $userId, date: $date, steps: $steps, goal: $goal, distanceKm: $distanceKm, calories: $calories, hourlyData: $hourlyData, source: $source, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class _$StepLogCopyWith<$Res> implements $StepLogCopyWith<$Res> {
  factory _$StepLogCopyWith(_StepLog value, $Res Function(_StepLog) _then) = __$StepLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime date, int steps, int goal, double? distanceKm, double? calories, List<int> hourlyData, String source, bool isSynced
});




}
/// @nodoc
class __$StepLogCopyWithImpl<$Res>
    implements _$StepLogCopyWith<$Res> {
  __$StepLogCopyWithImpl(this._self, this._then);

  final _StepLog _self;
  final $Res Function(_StepLog) _then;

/// Create a copy of StepLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? steps = null,Object? goal = null,Object? distanceKm = freezed,Object? calories = freezed,Object? hourlyData = null,Object? source = null,Object? isSynced = null,}) {
  return _then(_StepLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,hourlyData: null == hourlyData ? _self._hourlyData : hourlyData // ignore: cast_nullable_to_non_nullable
as List<int>,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StepSettings {

 String get id; String get userId; int get dailyGoal; bool get reminderEnabled; String get reminderTime; bool get cricketMode; bool get notificationsEnabled;
/// Create a copy of StepSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepSettingsCopyWith<StepSettings> get copyWith => _$StepSettingsCopyWithImpl<StepSettings>(this as StepSettings, _$identity);

  /// Serializes this StepSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime)&&(identical(other.cricketMode, cricketMode) || other.cricketMode == cricketMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,dailyGoal,reminderEnabled,reminderTime,cricketMode,notificationsEnabled);

@override
String toString() {
  return 'StepSettings(id: $id, userId: $userId, dailyGoal: $dailyGoal, reminderEnabled: $reminderEnabled, reminderTime: $reminderTime, cricketMode: $cricketMode, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $StepSettingsCopyWith<$Res>  {
  factory $StepSettingsCopyWith(StepSettings value, $Res Function(StepSettings) _then) = _$StepSettingsCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int dailyGoal, bool reminderEnabled, String reminderTime, bool cricketMode, bool notificationsEnabled
});




}
/// @nodoc
class _$StepSettingsCopyWithImpl<$Res>
    implements $StepSettingsCopyWith<$Res> {
  _$StepSettingsCopyWithImpl(this._self, this._then);

  final StepSettings _self;
  final $Res Function(StepSettings) _then;

/// Create a copy of StepSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? dailyGoal = null,Object? reminderEnabled = null,Object? reminderTime = null,Object? cricketMode = null,Object? notificationsEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as int,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderTime: null == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as String,cricketMode: null == cricketMode ? _self.cricketMode : cricketMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StepSettings].
extension StepSettingsPatterns on StepSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepSettings value)  $default,){
final _that = this;
switch (_that) {
case _StepSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepSettings value)?  $default,){
final _that = this;
switch (_that) {
case _StepSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int dailyGoal,  bool reminderEnabled,  String reminderTime,  bool cricketMode,  bool notificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepSettings() when $default != null:
return $default(_that.id,_that.userId,_that.dailyGoal,_that.reminderEnabled,_that.reminderTime,_that.cricketMode,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int dailyGoal,  bool reminderEnabled,  String reminderTime,  bool cricketMode,  bool notificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _StepSettings():
return $default(_that.id,_that.userId,_that.dailyGoal,_that.reminderEnabled,_that.reminderTime,_that.cricketMode,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int dailyGoal,  bool reminderEnabled,  String reminderTime,  bool cricketMode,  bool notificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _StepSettings() when $default != null:
return $default(_that.id,_that.userId,_that.dailyGoal,_that.reminderEnabled,_that.reminderTime,_that.cricketMode,_that.notificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepSettings implements StepSettings {
  const _StepSettings({required this.id, required this.userId, this.dailyGoal = 8000, this.reminderEnabled = true, this.reminderTime = '18:00', this.cricketMode = false, this.notificationsEnabled = true});
  factory _StepSettings.fromJson(Map<String, dynamic> json) => _$StepSettingsFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  int dailyGoal;
@override@JsonKey() final  bool reminderEnabled;
@override@JsonKey() final  String reminderTime;
@override@JsonKey() final  bool cricketMode;
@override@JsonKey() final  bool notificationsEnabled;

/// Create a copy of StepSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepSettingsCopyWith<_StepSettings> get copyWith => __$StepSettingsCopyWithImpl<_StepSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderTime, reminderTime) || other.reminderTime == reminderTime)&&(identical(other.cricketMode, cricketMode) || other.cricketMode == cricketMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,dailyGoal,reminderEnabled,reminderTime,cricketMode,notificationsEnabled);

@override
String toString() {
  return 'StepSettings(id: $id, userId: $userId, dailyGoal: $dailyGoal, reminderEnabled: $reminderEnabled, reminderTime: $reminderTime, cricketMode: $cricketMode, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$StepSettingsCopyWith<$Res> implements $StepSettingsCopyWith<$Res> {
  factory _$StepSettingsCopyWith(_StepSettings value, $Res Function(_StepSettings) _then) = __$StepSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int dailyGoal, bool reminderEnabled, String reminderTime, bool cricketMode, bool notificationsEnabled
});




}
/// @nodoc
class __$StepSettingsCopyWithImpl<$Res>
    implements _$StepSettingsCopyWith<$Res> {
  __$StepSettingsCopyWithImpl(this._self, this._then);

  final _StepSettings _self;
  final $Res Function(_StepSettings) _then;

/// Create a copy of StepSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? dailyGoal = null,Object? reminderEnabled = null,Object? reminderTime = null,Object? cricketMode = null,Object? notificationsEnabled = null,}) {
  return _then(_StepSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as int,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderTime: null == reminderTime ? _self.reminderTime : reminderTime // ignore: cast_nullable_to_non_nullable
as String,cricketMode: null == cricketMode ? _self.cricketMode : cricketMode // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StepEntry {

 DateTime get timestamp; int get steps; String? get source;
/// Create a copy of StepEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepEntryCopyWith<StepEntry> get copyWith => _$StepEntryCopyWithImpl<StepEntry>(this as StepEntry, _$identity);

  /// Serializes this StepEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,steps,source);

@override
String toString() {
  return 'StepEntry(timestamp: $timestamp, steps: $steps, source: $source)';
}


}

/// @nodoc
abstract mixin class $StepEntryCopyWith<$Res>  {
  factory $StepEntryCopyWith(StepEntry value, $Res Function(StepEntry) _then) = _$StepEntryCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, int steps, String? source
});




}
/// @nodoc
class _$StepEntryCopyWithImpl<$Res>
    implements $StepEntryCopyWith<$Res> {
  _$StepEntryCopyWithImpl(this._self, this._then);

  final StepEntry _self;
  final $Res Function(StepEntry) _then;

/// Create a copy of StepEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? steps = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StepEntry].
extension StepEntryPatterns on StepEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepEntry value)  $default,){
final _that = this;
switch (_that) {
case _StepEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepEntry value)?  $default,){
final _that = this;
switch (_that) {
case _StepEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  int steps,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepEntry() when $default != null:
return $default(_that.timestamp,_that.steps,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  int steps,  String? source)  $default,) {final _that = this;
switch (_that) {
case _StepEntry():
return $default(_that.timestamp,_that.steps,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  int steps,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _StepEntry() when $default != null:
return $default(_that.timestamp,_that.steps,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StepEntry implements StepEntry {
  const _StepEntry({required this.timestamp, required this.steps, this.source});
  factory _StepEntry.fromJson(Map<String, dynamic> json) => _$StepEntryFromJson(json);

@override final  DateTime timestamp;
@override final  int steps;
@override final  String? source;

/// Create a copy of StepEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepEntryCopyWith<_StepEntry> get copyWith => __$StepEntryCopyWithImpl<_StepEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StepEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.steps, steps) || other.steps == steps)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,steps,source);

@override
String toString() {
  return 'StepEntry(timestamp: $timestamp, steps: $steps, source: $source)';
}


}

/// @nodoc
abstract mixin class _$StepEntryCopyWith<$Res> implements $StepEntryCopyWith<$Res> {
  factory _$StepEntryCopyWith(_StepEntry value, $Res Function(_StepEntry) _then) = __$StepEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, int steps, String? source
});




}
/// @nodoc
class __$StepEntryCopyWithImpl<$Res>
    implements _$StepEntryCopyWith<$Res> {
  __$StepEntryCopyWithImpl(this._self, this._then);

  final _StepEntry _self;
  final $Res Function(_StepEntry) _then;

/// Create a copy of StepEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? steps = null,Object? source = freezed,}) {
  return _then(_StepEntry(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as int,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
