// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterLog {

 String get id; String get userId; DateTime get date; int get glasses; int get goal; int get mlTotal; List<WaterEntry> get entries; int get streakDays; DateTime? get lastEntryTime; bool get isSynced;
/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterLogCopyWith<WaterLog> get copyWith => _$WaterLogCopyWithImpl<WaterLog>(this as WaterLog, _$identity);

  /// Serializes this WaterLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.glasses, glasses) || other.glasses == glasses)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.mlTotal, mlTotal) || other.mlTotal == mlTotal)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.lastEntryTime, lastEntryTime) || other.lastEntryTime == lastEntryTime)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,glasses,goal,mlTotal,const DeepCollectionEquality().hash(entries),streakDays,lastEntryTime,isSynced);

@override
String toString() {
  return 'WaterLog(id: $id, userId: $userId, date: $date, glasses: $glasses, goal: $goal, mlTotal: $mlTotal, entries: $entries, streakDays: $streakDays, lastEntryTime: $lastEntryTime, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class $WaterLogCopyWith<$Res>  {
  factory $WaterLogCopyWith(WaterLog value, $Res Function(WaterLog) _then) = _$WaterLogCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime date, int glasses, int goal, int mlTotal, List<WaterEntry> entries, int streakDays, DateTime? lastEntryTime, bool isSynced
});




}
/// @nodoc
class _$WaterLogCopyWithImpl<$Res>
    implements $WaterLogCopyWith<$Res> {
  _$WaterLogCopyWithImpl(this._self, this._then);

  final WaterLog _self;
  final $Res Function(WaterLog) _then;

/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? glasses = null,Object? goal = null,Object? mlTotal = null,Object? entries = null,Object? streakDays = null,Object? lastEntryTime = freezed,Object? isSynced = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,glasses: null == glasses ? _self.glasses : glasses // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,mlTotal: null == mlTotal ? _self.mlTotal : mlTotal // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<WaterEntry>,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,lastEntryTime: freezed == lastEntryTime ? _self.lastEntryTime : lastEntryTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterLog].
extension WaterLogPatterns on WaterLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterLog value)  $default,){
final _that = this;
switch (_that) {
case _WaterLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterLog value)?  $default,){
final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  int glasses,  int goal,  int mlTotal,  List<WaterEntry> entries,  int streakDays,  DateTime? lastEntryTime,  bool isSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.glasses,_that.goal,_that.mlTotal,_that.entries,_that.streakDays,_that.lastEntryTime,_that.isSynced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  int glasses,  int goal,  int mlTotal,  List<WaterEntry> entries,  int streakDays,  DateTime? lastEntryTime,  bool isSynced)  $default,) {final _that = this;
switch (_that) {
case _WaterLog():
return $default(_that.id,_that.userId,_that.date,_that.glasses,_that.goal,_that.mlTotal,_that.entries,_that.streakDays,_that.lastEntryTime,_that.isSynced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime date,  int glasses,  int goal,  int mlTotal,  List<WaterEntry> entries,  int streakDays,  DateTime? lastEntryTime,  bool isSynced)?  $default,) {final _that = this;
switch (_that) {
case _WaterLog() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.glasses,_that.goal,_that.mlTotal,_that.entries,_that.streakDays,_that.lastEntryTime,_that.isSynced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterLog extends WaterLog {
  const _WaterLog({required this.id, required this.userId, required this.date, this.glasses = 0, this.goal = 8, this.mlTotal = 0, final  List<WaterEntry> entries = const [], this.streakDays = 0, this.lastEntryTime, this.isSynced = false}): _entries = entries,super._();
  factory _WaterLog.fromJson(Map<String, dynamic> json) => _$WaterLogFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime date;
@override@JsonKey() final  int glasses;
@override@JsonKey() final  int goal;
@override@JsonKey() final  int mlTotal;
 final  List<WaterEntry> _entries;
@override@JsonKey() List<WaterEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  int streakDays;
@override final  DateTime? lastEntryTime;
@override@JsonKey() final  bool isSynced;

/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterLogCopyWith<_WaterLog> get copyWith => __$WaterLogCopyWithImpl<_WaterLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.glasses, glasses) || other.glasses == glasses)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.mlTotal, mlTotal) || other.mlTotal == mlTotal)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.lastEntryTime, lastEntryTime) || other.lastEntryTime == lastEntryTime)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,glasses,goal,mlTotal,const DeepCollectionEquality().hash(_entries),streakDays,lastEntryTime,isSynced);

@override
String toString() {
  return 'WaterLog(id: $id, userId: $userId, date: $date, glasses: $glasses, goal: $goal, mlTotal: $mlTotal, entries: $entries, streakDays: $streakDays, lastEntryTime: $lastEntryTime, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class _$WaterLogCopyWith<$Res> implements $WaterLogCopyWith<$Res> {
  factory _$WaterLogCopyWith(_WaterLog value, $Res Function(_WaterLog) _then) = __$WaterLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime date, int glasses, int goal, int mlTotal, List<WaterEntry> entries, int streakDays, DateTime? lastEntryTime, bool isSynced
});




}
/// @nodoc
class __$WaterLogCopyWithImpl<$Res>
    implements _$WaterLogCopyWith<$Res> {
  __$WaterLogCopyWithImpl(this._self, this._then);

  final _WaterLog _self;
  final $Res Function(_WaterLog) _then;

/// Create a copy of WaterLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? glasses = null,Object? goal = null,Object? mlTotal = null,Object? entries = null,Object? streakDays = null,Object? lastEntryTime = freezed,Object? isSynced = null,}) {
  return _then(_WaterLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,glasses: null == glasses ? _self.glasses : glasses // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,mlTotal: null == mlTotal ? _self.mlTotal : mlTotal // ignore: cast_nullable_to_non_nullable
as int,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<WaterEntry>,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,lastEntryTime: freezed == lastEntryTime ? _self.lastEntryTime : lastEntryTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WaterSettings {

 String get id; String get userId; int get dailyGoal; int get glassSizeMl; int? get bottleSizeMl; int? get chaiSizeMl; bool get reminderEnabled; int get reminderIntervalHours; String get reminderStartTime; String get reminderEndTime; bool get smartReminders; bool get notificationsEnabled;
/// Create a copy of WaterSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterSettingsCopyWith<WaterSettings> get copyWith => _$WaterSettingsCopyWithImpl<WaterSettings>(this as WaterSettings, _$identity);

  /// Serializes this WaterSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal)&&(identical(other.glassSizeMl, glassSizeMl) || other.glassSizeMl == glassSizeMl)&&(identical(other.bottleSizeMl, bottleSizeMl) || other.bottleSizeMl == bottleSizeMl)&&(identical(other.chaiSizeMl, chaiSizeMl) || other.chaiSizeMl == chaiSizeMl)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderIntervalHours, reminderIntervalHours) || other.reminderIntervalHours == reminderIntervalHours)&&(identical(other.reminderStartTime, reminderStartTime) || other.reminderStartTime == reminderStartTime)&&(identical(other.reminderEndTime, reminderEndTime) || other.reminderEndTime == reminderEndTime)&&(identical(other.smartReminders, smartReminders) || other.smartReminders == smartReminders)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,dailyGoal,glassSizeMl,bottleSizeMl,chaiSizeMl,reminderEnabled,reminderIntervalHours,reminderStartTime,reminderEndTime,smartReminders,notificationsEnabled);

@override
String toString() {
  return 'WaterSettings(id: $id, userId: $userId, dailyGoal: $dailyGoal, glassSizeMl: $glassSizeMl, bottleSizeMl: $bottleSizeMl, chaiSizeMl: $chaiSizeMl, reminderEnabled: $reminderEnabled, reminderIntervalHours: $reminderIntervalHours, reminderStartTime: $reminderStartTime, reminderEndTime: $reminderEndTime, smartReminders: $smartReminders, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $WaterSettingsCopyWith<$Res>  {
  factory $WaterSettingsCopyWith(WaterSettings value, $Res Function(WaterSettings) _then) = _$WaterSettingsCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int dailyGoal, int glassSizeMl, int? bottleSizeMl, int? chaiSizeMl, bool reminderEnabled, int reminderIntervalHours, String reminderStartTime, String reminderEndTime, bool smartReminders, bool notificationsEnabled
});




}
/// @nodoc
class _$WaterSettingsCopyWithImpl<$Res>
    implements $WaterSettingsCopyWith<$Res> {
  _$WaterSettingsCopyWithImpl(this._self, this._then);

  final WaterSettings _self;
  final $Res Function(WaterSettings) _then;

/// Create a copy of WaterSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? dailyGoal = null,Object? glassSizeMl = null,Object? bottleSizeMl = freezed,Object? chaiSizeMl = freezed,Object? reminderEnabled = null,Object? reminderIntervalHours = null,Object? reminderStartTime = null,Object? reminderEndTime = null,Object? smartReminders = null,Object? notificationsEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as int,glassSizeMl: null == glassSizeMl ? _self.glassSizeMl : glassSizeMl // ignore: cast_nullable_to_non_nullable
as int,bottleSizeMl: freezed == bottleSizeMl ? _self.bottleSizeMl : bottleSizeMl // ignore: cast_nullable_to_non_nullable
as int?,chaiSizeMl: freezed == chaiSizeMl ? _self.chaiSizeMl : chaiSizeMl // ignore: cast_nullable_to_non_nullable
as int?,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderIntervalHours: null == reminderIntervalHours ? _self.reminderIntervalHours : reminderIntervalHours // ignore: cast_nullable_to_non_nullable
as int,reminderStartTime: null == reminderStartTime ? _self.reminderStartTime : reminderStartTime // ignore: cast_nullable_to_non_nullable
as String,reminderEndTime: null == reminderEndTime ? _self.reminderEndTime : reminderEndTime // ignore: cast_nullable_to_non_nullable
as String,smartReminders: null == smartReminders ? _self.smartReminders : smartReminders // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterSettings].
extension WaterSettingsPatterns on WaterSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterSettings value)  $default,){
final _that = this;
switch (_that) {
case _WaterSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterSettings value)?  $default,){
final _that = this;
switch (_that) {
case _WaterSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int dailyGoal,  int glassSizeMl,  int? bottleSizeMl,  int? chaiSizeMl,  bool reminderEnabled,  int reminderIntervalHours,  String reminderStartTime,  String reminderEndTime,  bool smartReminders,  bool notificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterSettings() when $default != null:
return $default(_that.id,_that.userId,_that.dailyGoal,_that.glassSizeMl,_that.bottleSizeMl,_that.chaiSizeMl,_that.reminderEnabled,_that.reminderIntervalHours,_that.reminderStartTime,_that.reminderEndTime,_that.smartReminders,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int dailyGoal,  int glassSizeMl,  int? bottleSizeMl,  int? chaiSizeMl,  bool reminderEnabled,  int reminderIntervalHours,  String reminderStartTime,  String reminderEndTime,  bool smartReminders,  bool notificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _WaterSettings():
return $default(_that.id,_that.userId,_that.dailyGoal,_that.glassSizeMl,_that.bottleSizeMl,_that.chaiSizeMl,_that.reminderEnabled,_that.reminderIntervalHours,_that.reminderStartTime,_that.reminderEndTime,_that.smartReminders,_that.notificationsEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int dailyGoal,  int glassSizeMl,  int? bottleSizeMl,  int? chaiSizeMl,  bool reminderEnabled,  int reminderIntervalHours,  String reminderStartTime,  String reminderEndTime,  bool smartReminders,  bool notificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _WaterSettings() when $default != null:
return $default(_that.id,_that.userId,_that.dailyGoal,_that.glassSizeMl,_that.bottleSizeMl,_that.chaiSizeMl,_that.reminderEnabled,_that.reminderIntervalHours,_that.reminderStartTime,_that.reminderEndTime,_that.smartReminders,_that.notificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterSettings implements WaterSettings {
  const _WaterSettings({required this.id, required this.userId, this.dailyGoal = 8, this.glassSizeMl = 250, this.bottleSizeMl = 500, this.chaiSizeMl = 150, this.reminderEnabled = true, this.reminderIntervalHours = 2, this.reminderStartTime = '08:00', this.reminderEndTime = '20:00', this.smartReminders = true, this.notificationsEnabled = true});
  factory _WaterSettings.fromJson(Map<String, dynamic> json) => _$WaterSettingsFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  int dailyGoal;
@override@JsonKey() final  int glassSizeMl;
@override@JsonKey() final  int? bottleSizeMl;
@override@JsonKey() final  int? chaiSizeMl;
@override@JsonKey() final  bool reminderEnabled;
@override@JsonKey() final  int reminderIntervalHours;
@override@JsonKey() final  String reminderStartTime;
@override@JsonKey() final  String reminderEndTime;
@override@JsonKey() final  bool smartReminders;
@override@JsonKey() final  bool notificationsEnabled;

/// Create a copy of WaterSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterSettingsCopyWith<_WaterSettings> get copyWith => __$WaterSettingsCopyWithImpl<_WaterSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.dailyGoal, dailyGoal) || other.dailyGoal == dailyGoal)&&(identical(other.glassSizeMl, glassSizeMl) || other.glassSizeMl == glassSizeMl)&&(identical(other.bottleSizeMl, bottleSizeMl) || other.bottleSizeMl == bottleSizeMl)&&(identical(other.chaiSizeMl, chaiSizeMl) || other.chaiSizeMl == chaiSizeMl)&&(identical(other.reminderEnabled, reminderEnabled) || other.reminderEnabled == reminderEnabled)&&(identical(other.reminderIntervalHours, reminderIntervalHours) || other.reminderIntervalHours == reminderIntervalHours)&&(identical(other.reminderStartTime, reminderStartTime) || other.reminderStartTime == reminderStartTime)&&(identical(other.reminderEndTime, reminderEndTime) || other.reminderEndTime == reminderEndTime)&&(identical(other.smartReminders, smartReminders) || other.smartReminders == smartReminders)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,dailyGoal,glassSizeMl,bottleSizeMl,chaiSizeMl,reminderEnabled,reminderIntervalHours,reminderStartTime,reminderEndTime,smartReminders,notificationsEnabled);

@override
String toString() {
  return 'WaterSettings(id: $id, userId: $userId, dailyGoal: $dailyGoal, glassSizeMl: $glassSizeMl, bottleSizeMl: $bottleSizeMl, chaiSizeMl: $chaiSizeMl, reminderEnabled: $reminderEnabled, reminderIntervalHours: $reminderIntervalHours, reminderStartTime: $reminderStartTime, reminderEndTime: $reminderEndTime, smartReminders: $smartReminders, notificationsEnabled: $notificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$WaterSettingsCopyWith<$Res> implements $WaterSettingsCopyWith<$Res> {
  factory _$WaterSettingsCopyWith(_WaterSettings value, $Res Function(_WaterSettings) _then) = __$WaterSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int dailyGoal, int glassSizeMl, int? bottleSizeMl, int? chaiSizeMl, bool reminderEnabled, int reminderIntervalHours, String reminderStartTime, String reminderEndTime, bool smartReminders, bool notificationsEnabled
});




}
/// @nodoc
class __$WaterSettingsCopyWithImpl<$Res>
    implements _$WaterSettingsCopyWith<$Res> {
  __$WaterSettingsCopyWithImpl(this._self, this._then);

  final _WaterSettings _self;
  final $Res Function(_WaterSettings) _then;

/// Create a copy of WaterSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? dailyGoal = null,Object? glassSizeMl = null,Object? bottleSizeMl = freezed,Object? chaiSizeMl = freezed,Object? reminderEnabled = null,Object? reminderIntervalHours = null,Object? reminderStartTime = null,Object? reminderEndTime = null,Object? smartReminders = null,Object? notificationsEnabled = null,}) {
  return _then(_WaterSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,dailyGoal: null == dailyGoal ? _self.dailyGoal : dailyGoal // ignore: cast_nullable_to_non_nullable
as int,glassSizeMl: null == glassSizeMl ? _self.glassSizeMl : glassSizeMl // ignore: cast_nullable_to_non_nullable
as int,bottleSizeMl: freezed == bottleSizeMl ? _self.bottleSizeMl : bottleSizeMl // ignore: cast_nullable_to_non_nullable
as int?,chaiSizeMl: freezed == chaiSizeMl ? _self.chaiSizeMl : chaiSizeMl // ignore: cast_nullable_to_non_nullable
as int?,reminderEnabled: null == reminderEnabled ? _self.reminderEnabled : reminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,reminderIntervalHours: null == reminderIntervalHours ? _self.reminderIntervalHours : reminderIntervalHours // ignore: cast_nullable_to_non_nullable
as int,reminderStartTime: null == reminderStartTime ? _self.reminderStartTime : reminderStartTime // ignore: cast_nullable_to_non_nullable
as String,reminderEndTime: null == reminderEndTime ? _self.reminderEndTime : reminderEndTime // ignore: cast_nullable_to_non_nullable
as String,smartReminders: null == smartReminders ? _self.smartReminders : smartReminders // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WaterEntry {

 DateTime get time; int get amountMl; String get type;// glass, bottle, chai, custom
 String? get note;
/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterEntryCopyWith<WaterEntry> get copyWith => _$WaterEntryCopyWithImpl<WaterEntry>(this as WaterEntry, _$identity);

  /// Serializes this WaterEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,amountMl,type,note);

@override
String toString() {
  return 'WaterEntry(time: $time, amountMl: $amountMl, type: $type, note: $note)';
}


}

/// @nodoc
abstract mixin class $WaterEntryCopyWith<$Res>  {
  factory $WaterEntryCopyWith(WaterEntry value, $Res Function(WaterEntry) _then) = _$WaterEntryCopyWithImpl;
@useResult
$Res call({
 DateTime time, int amountMl, String type, String? note
});




}
/// @nodoc
class _$WaterEntryCopyWithImpl<$Res>
    implements $WaterEntryCopyWith<$Res> {
  _$WaterEntryCopyWithImpl(this._self, this._then);

  final WaterEntry _self;
  final $Res Function(WaterEntry) _then;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? amountMl = null,Object? type = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,amountMl: null == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterEntry].
extension WaterEntryPatterns on WaterEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterEntry value)  $default,){
final _that = this;
switch (_that) {
case _WaterEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  int amountMl,  String type,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
return $default(_that.time,_that.amountMl,_that.type,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  int amountMl,  String type,  String? note)  $default,) {final _that = this;
switch (_that) {
case _WaterEntry():
return $default(_that.time,_that.amountMl,_that.type,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  int amountMl,  String type,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
return $default(_that.time,_that.amountMl,_that.type,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterEntry extends WaterEntry {
  const _WaterEntry({required this.time, required this.amountMl, this.type = 'glass', this.note}): super._();
  factory _WaterEntry.fromJson(Map<String, dynamic> json) => _$WaterEntryFromJson(json);

@override final  DateTime time;
@override final  int amountMl;
@override@JsonKey() final  String type;
// glass, bottle, chai, custom
@override final  String? note;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterEntryCopyWith<_WaterEntry> get copyWith => __$WaterEntryCopyWithImpl<_WaterEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,amountMl,type,note);

@override
String toString() {
  return 'WaterEntry(time: $time, amountMl: $amountMl, type: $type, note: $note)';
}


}

/// @nodoc
abstract mixin class _$WaterEntryCopyWith<$Res> implements $WaterEntryCopyWith<$Res> {
  factory _$WaterEntryCopyWith(_WaterEntry value, $Res Function(_WaterEntry) _then) = __$WaterEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, int amountMl, String type, String? note
});




}
/// @nodoc
class __$WaterEntryCopyWithImpl<$Res>
    implements _$WaterEntryCopyWith<$Res> {
  __$WaterEntryCopyWithImpl(this._self, this._then);

  final _WaterEntry _self;
  final $Res Function(_WaterEntry) _then;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? amountMl = null,Object? type = null,Object? note = freezed,}) {
  return _then(_WaterEntry(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,amountMl: null == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
