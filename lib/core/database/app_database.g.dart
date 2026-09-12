// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PendingMutationsTable extends PendingMutations
    with TableInfo<$PendingMutationsTable, PendingMutation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingMutationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'target_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, targetTable, action, payload, createdAt, retryCount, lastError];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_mutations';
  @override
  VerificationContext validateIntegrity(Insertable<PendingMutation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['target_table']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingMutation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingMutation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_table'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $PendingMutationsTable createAlias(String alias) {
    return $PendingMutationsTable(attachedDatabase, alias);
  }
}

class PendingMutation extends DataClass implements Insertable<PendingMutation> {
  final String id;
  final String targetTable;
  final String action;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  const PendingMutation(
      {required this.id,
      required this.targetTable,
      required this.action,
      required this.payload,
      required this.createdAt,
      required this.retryCount,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  PendingMutationsCompanion toCompanion(bool nullToAbsent) {
    return PendingMutationsCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      action: Value(action),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory PendingMutation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingMutation(
      id: serializer.fromJson<String>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  PendingMutation copyWith(
          {String? id,
          String? targetTable,
          String? action,
          String? payload,
          DateTime? createdAt,
          int? retryCount,
          Value<String?> lastError = const Value.absent()}) =>
      PendingMutation(
        id: id ?? this.id,
        targetTable: targetTable ?? this.targetTable,
        action: action ?? this.action,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  PendingMutation copyWithCompanion(PendingMutationsCompanion data) {
    return PendingMutation(
      id: data.id.present ? data.id.value : this.id,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingMutation(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, targetTable, action, payload, createdAt, retryCount, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingMutation &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError);
}

class PendingMutationsCompanion extends UpdateCompanion<PendingMutation> {
  final Value<String> id;
  final Value<String> targetTable;
  final Value<String> action;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<int> rowid;
  const PendingMutationsCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingMutationsCompanion.insert({
    required String id,
    required String targetTable,
    required String action,
    required String payload,
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        targetTable = Value(targetTable),
        action = Value(action),
        payload = Value(payload);
  static Insertable<PendingMutation> custom({
    Expression<String>? id,
    Expression<String>? targetTable,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingMutationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? targetTable,
      Value<String>? action,
      Value<String>? payload,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<String?>? lastError,
      Value<int>? rowid}) {
    return PendingMutationsCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingMutationsCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _primaryGoalMeta =
      const VerificationMeta('primaryGoal');
  @override
  late final GeneratedColumn<String> primaryGoal = GeneratedColumn<String>(
      'primary_goal', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, name, age, gender, heightCm, weightKg, primaryGoal, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    }
    if (data.containsKey('primary_goal')) {
      context.handle(
          _primaryGoalMeta,
          primaryGoal.isAcceptableOrUnknown(
              data['primary_goal']!, _primaryGoalMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm']),
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg']),
      primaryGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}primary_goal']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
  final String userId;
  final String? name;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? primaryGoal;
  final DateTime updatedAt;
  const LocalProfile(
      {required this.userId,
      this.name,
      this.age,
      this.gender,
      this.heightCm,
      this.weightKg,
      this.primaryGoal,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || primaryGoal != null) {
      map['primary_goal'] = Variable<String>(primaryGoal);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      userId: Value(userId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      primaryGoal: primaryGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryGoal),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String?>(json['name']),
      age: serializer.fromJson<int?>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      primaryGoal: serializer.fromJson<String?>(json['primaryGoal']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String?>(name),
      'age': serializer.toJson<int?>(age),
      'gender': serializer.toJson<String?>(gender),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'primaryGoal': serializer.toJson<String?>(primaryGoal),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalProfile copyWith(
          {String? userId,
          Value<String?> name = const Value.absent(),
          Value<int?> age = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<double?> heightCm = const Value.absent(),
          Value<double?> weightKg = const Value.absent(),
          Value<String?> primaryGoal = const Value.absent(),
          DateTime? updatedAt}) =>
      LocalProfile(
        userId: userId ?? this.userId,
        name: name.present ? name.value : this.name,
        age: age.present ? age.value : this.age,
        gender: gender.present ? gender.value : this.gender,
        heightCm: heightCm.present ? heightCm.value : this.heightCm,
        weightKg: weightKg.present ? weightKg.value : this.weightKg,
        primaryGoal: primaryGoal.present ? primaryGoal.value : this.primaryGoal,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalProfile copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      primaryGoal:
          data.primaryGoal.present ? data.primaryGoal.value : this.primaryGoal,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId, name, age, gender, heightCm, weightKg, primaryGoal, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.primaryGoal == this.primaryGoal &&
          other.updatedAt == this.updatedAt);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<String> userId;
  final Value<String?> name;
  final Value<int?> age;
  final Value<String?> gender;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<String?> primaryGoal;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalProfilesCompanion({
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    required String userId,
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<LocalProfile> custom({
    Expression<String>? userId,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? primaryGoal,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProfilesCompanion copyWith(
      {Value<String>? userId,
      Value<String?>? name,
      Value<int?>? age,
      Value<String?>? gender,
      Value<double?>? heightCm,
      Value<double?>? weightKg,
      Value<String?>? primaryGoal,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LocalProfilesCompanion(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<String>(primaryGoal.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalReadinessScoresTable extends LocalReadinessScores
    with TableInfo<$LocalReadinessScoresTable, LocalReadinessScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalReadinessScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _confidenceTierMeta =
      const VerificationMeta('confidenceTier');
  @override
  late final GeneratedColumn<String> confidenceTier = GeneratedColumn<String>(
      'confidence_tier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _calculatedAtMeta =
      const VerificationMeta('calculatedAt');
  @override
  late final GeneratedColumn<DateTime> calculatedAt = GeneratedColumn<DateTime>(
      'calculated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, score, confidenceTier, calculatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_readiness_scores';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalReadinessScore> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('confidence_tier')) {
      context.handle(
          _confidenceTierMeta,
          confidenceTier.isAcceptableOrUnknown(
              data['confidence_tier']!, _confidenceTierMeta));
    } else if (isInserting) {
      context.missing(_confidenceTierMeta);
    }
    if (data.containsKey('calculated_at')) {
      context.handle(
          _calculatedAtMeta,
          calculatedAt.isAcceptableOrUnknown(
              data['calculated_at']!, _calculatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalReadinessScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalReadinessScore(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      confidenceTier: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}confidence_tier'])!,
      calculatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}calculated_at'])!,
    );
  }

  @override
  $LocalReadinessScoresTable createAlias(String alias) {
    return $LocalReadinessScoresTable(attachedDatabase, alias);
  }
}

class LocalReadinessScore extends DataClass
    implements Insertable<LocalReadinessScore> {
  final String id;
  final String userId;
  final int score;
  final String confidenceTier;
  final DateTime calculatedAt;
  const LocalReadinessScore(
      {required this.id,
      required this.userId,
      required this.score,
      required this.confidenceTier,
      required this.calculatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['score'] = Variable<int>(score);
    map['confidence_tier'] = Variable<String>(confidenceTier);
    map['calculated_at'] = Variable<DateTime>(calculatedAt);
    return map;
  }

  LocalReadinessScoresCompanion toCompanion(bool nullToAbsent) {
    return LocalReadinessScoresCompanion(
      id: Value(id),
      userId: Value(userId),
      score: Value(score),
      confidenceTier: Value(confidenceTier),
      calculatedAt: Value(calculatedAt),
    );
  }

  factory LocalReadinessScore.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalReadinessScore(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      score: serializer.fromJson<int>(json['score']),
      confidenceTier: serializer.fromJson<String>(json['confidenceTier']),
      calculatedAt: serializer.fromJson<DateTime>(json['calculatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'score': serializer.toJson<int>(score),
      'confidenceTier': serializer.toJson<String>(confidenceTier),
      'calculatedAt': serializer.toJson<DateTime>(calculatedAt),
    };
  }

  LocalReadinessScore copyWith(
          {String? id,
          String? userId,
          int? score,
          String? confidenceTier,
          DateTime? calculatedAt}) =>
      LocalReadinessScore(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        score: score ?? this.score,
        confidenceTier: confidenceTier ?? this.confidenceTier,
        calculatedAt: calculatedAt ?? this.calculatedAt,
      );
  LocalReadinessScore copyWithCompanion(LocalReadinessScoresCompanion data) {
    return LocalReadinessScore(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      score: data.score.present ? data.score.value : this.score,
      confidenceTier: data.confidenceTier.present
          ? data.confidenceTier.value
          : this.confidenceTier,
      calculatedAt: data.calculatedAt.present
          ? data.calculatedAt.value
          : this.calculatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalReadinessScore(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('score: $score, ')
          ..write('confidenceTier: $confidenceTier, ')
          ..write('calculatedAt: $calculatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, score, confidenceTier, calculatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalReadinessScore &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.score == this.score &&
          other.confidenceTier == this.confidenceTier &&
          other.calculatedAt == this.calculatedAt);
}

class LocalReadinessScoresCompanion
    extends UpdateCompanion<LocalReadinessScore> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> score;
  final Value<String> confidenceTier;
  final Value<DateTime> calculatedAt;
  final Value<int> rowid;
  const LocalReadinessScoresCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.score = const Value.absent(),
    this.confidenceTier = const Value.absent(),
    this.calculatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalReadinessScoresCompanion.insert({
    required String id,
    required String userId,
    required int score,
    required String confidenceTier,
    this.calculatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        score = Value(score),
        confidenceTier = Value(confidenceTier);
  static Insertable<LocalReadinessScore> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? score,
    Expression<String>? confidenceTier,
    Expression<DateTime>? calculatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (score != null) 'score': score,
      if (confidenceTier != null) 'confidence_tier': confidenceTier,
      if (calculatedAt != null) 'calculated_at': calculatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalReadinessScoresCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? score,
      Value<String>? confidenceTier,
      Value<DateTime>? calculatedAt,
      Value<int>? rowid}) {
    return LocalReadinessScoresCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      score: score ?? this.score,
      confidenceTier: confidenceTier ?? this.confidenceTier,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (confidenceTier.present) {
      map['confidence_tier'] = Variable<String>(confidenceTier.value);
    }
    if (calculatedAt.present) {
      map['calculated_at'] = Variable<DateTime>(calculatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalReadinessScoresCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('score: $score, ')
          ..write('confidenceTier: $confidenceTier, ')
          ..write('calculatedAt: $calculatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDipCacheTable extends LocalDipCache
    with TableInfo<$LocalDipCacheTable, LocalDipCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDipCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [userId, date, payloadJson, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_dip_cache';
  @override
  VerificationContext validateIntegrity(Insertable<LocalDipCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, date};
  @override
  LocalDipCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDipCacheData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
    );
  }

  @override
  $LocalDipCacheTable createAlias(String alias) {
    return $LocalDipCacheTable(attachedDatabase, alias);
  }
}

class LocalDipCacheData extends DataClass
    implements Insertable<LocalDipCacheData> {
  final String userId;
  final String date;
  final String payloadJson;
  final DateTime expiresAt;
  const LocalDipCacheData(
      {required this.userId,
      required this.date,
      required this.payloadJson,
      required this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<String>(date);
    map['payload_json'] = Variable<String>(payloadJson);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  LocalDipCacheCompanion toCompanion(bool nullToAbsent) {
    return LocalDipCacheCompanion(
      userId: Value(userId),
      date: Value(date),
      payloadJson: Value(payloadJson),
      expiresAt: Value(expiresAt),
    );
  }

  factory LocalDipCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDipCacheData(
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<String>(json['date']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<String>(date),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  LocalDipCacheData copyWith(
          {String? userId,
          String? date,
          String? payloadJson,
          DateTime? expiresAt}) =>
      LocalDipCacheData(
        userId: userId ?? this.userId,
        date: date ?? this.date,
        payloadJson: payloadJson ?? this.payloadJson,
        expiresAt: expiresAt ?? this.expiresAt,
      );
  LocalDipCacheData copyWithCompanion(LocalDipCacheCompanion data) {
    return LocalDipCacheData(
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDipCacheData(')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, date, payloadJson, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDipCacheData &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.payloadJson == this.payloadJson &&
          other.expiresAt == this.expiresAt);
}

class LocalDipCacheCompanion extends UpdateCompanion<LocalDipCacheData> {
  final Value<String> userId;
  final Value<String> date;
  final Value<String> payloadJson;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const LocalDipCacheCompanion({
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDipCacheCompanion.insert({
    required String userId,
    required String date,
    required String payloadJson,
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        date = Value(date),
        payloadJson = Value(payloadJson),
        expiresAt = Value(expiresAt);
  static Insertable<LocalDipCacheData> custom({
    Expression<String>? userId,
    Expression<String>? date,
    Expression<String>? payloadJson,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDipCacheCompanion copyWith(
      {Value<String>? userId,
      Value<String>? date,
      Value<String>? payloadJson,
      Value<DateTime>? expiresAt,
      Value<int>? rowid}) {
    return LocalDipCacheCompanion(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      payloadJson: payloadJson ?? this.payloadJson,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDipCacheCompanion(')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDoshaScoresTable extends LocalDoshaScores
    with TableInfo<$LocalDoshaScoresTable, LocalDoshaScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDoshaScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vataScoreMeta =
      const VerificationMeta('vataScore');
  @override
  late final GeneratedColumn<int> vataScore = GeneratedColumn<int>(
      'vata_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pittaScoreMeta =
      const VerificationMeta('pittaScore');
  @override
  late final GeneratedColumn<int> pittaScore = GeneratedColumn<int>(
      'pitta_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kaphaScoreMeta =
      const VerificationMeta('kaphaScore');
  @override
  late final GeneratedColumn<int> kaphaScore = GeneratedColumn<int>(
      'kapha_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dominantDoshaMeta =
      const VerificationMeta('dominantDosha');
  @override
  late final GeneratedColumn<String> dominantDosha = GeneratedColumn<String>(
      'dominant_dosha', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assessedAtMeta =
      const VerificationMeta('assessedAt');
  @override
  late final GeneratedColumn<DateTime> assessedAt = GeneratedColumn<DateTime>(
      'assessed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        vataScore,
        pittaScore,
        kaphaScore,
        dominantDosha,
        assessedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_dosha_scores';
  @override
  VerificationContext validateIntegrity(Insertable<LocalDoshaScore> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('vata_score')) {
      context.handle(_vataScoreMeta,
          vataScore.isAcceptableOrUnknown(data['vata_score']!, _vataScoreMeta));
    } else if (isInserting) {
      context.missing(_vataScoreMeta);
    }
    if (data.containsKey('pitta_score')) {
      context.handle(
          _pittaScoreMeta,
          pittaScore.isAcceptableOrUnknown(
              data['pitta_score']!, _pittaScoreMeta));
    } else if (isInserting) {
      context.missing(_pittaScoreMeta);
    }
    if (data.containsKey('kapha_score')) {
      context.handle(
          _kaphaScoreMeta,
          kaphaScore.isAcceptableOrUnknown(
              data['kapha_score']!, _kaphaScoreMeta));
    } else if (isInserting) {
      context.missing(_kaphaScoreMeta);
    }
    if (data.containsKey('dominant_dosha')) {
      context.handle(
          _dominantDoshaMeta,
          dominantDosha.isAcceptableOrUnknown(
              data['dominant_dosha']!, _dominantDoshaMeta));
    } else if (isInserting) {
      context.missing(_dominantDoshaMeta);
    }
    if (data.containsKey('assessed_at')) {
      context.handle(
          _assessedAtMeta,
          assessedAt.isAcceptableOrUnknown(
              data['assessed_at']!, _assessedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDoshaScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDoshaScore(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      vataScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vata_score'])!,
      pittaScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pitta_score'])!,
      kaphaScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kapha_score'])!,
      dominantDosha: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dominant_dosha'])!,
      assessedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}assessed_at'])!,
    );
  }

  @override
  $LocalDoshaScoresTable createAlias(String alias) {
    return $LocalDoshaScoresTable(attachedDatabase, alias);
  }
}

class LocalDoshaScore extends DataClass implements Insertable<LocalDoshaScore> {
  final String id;
  final String userId;
  final int vataScore;
  final int pittaScore;
  final int kaphaScore;
  final String dominantDosha;
  final DateTime assessedAt;
  const LocalDoshaScore(
      {required this.id,
      required this.userId,
      required this.vataScore,
      required this.pittaScore,
      required this.kaphaScore,
      required this.dominantDosha,
      required this.assessedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['vata_score'] = Variable<int>(vataScore);
    map['pitta_score'] = Variable<int>(pittaScore);
    map['kapha_score'] = Variable<int>(kaphaScore);
    map['dominant_dosha'] = Variable<String>(dominantDosha);
    map['assessed_at'] = Variable<DateTime>(assessedAt);
    return map;
  }

  LocalDoshaScoresCompanion toCompanion(bool nullToAbsent) {
    return LocalDoshaScoresCompanion(
      id: Value(id),
      userId: Value(userId),
      vataScore: Value(vataScore),
      pittaScore: Value(pittaScore),
      kaphaScore: Value(kaphaScore),
      dominantDosha: Value(dominantDosha),
      assessedAt: Value(assessedAt),
    );
  }

  factory LocalDoshaScore.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDoshaScore(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      vataScore: serializer.fromJson<int>(json['vataScore']),
      pittaScore: serializer.fromJson<int>(json['pittaScore']),
      kaphaScore: serializer.fromJson<int>(json['kaphaScore']),
      dominantDosha: serializer.fromJson<String>(json['dominantDosha']),
      assessedAt: serializer.fromJson<DateTime>(json['assessedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'vataScore': serializer.toJson<int>(vataScore),
      'pittaScore': serializer.toJson<int>(pittaScore),
      'kaphaScore': serializer.toJson<int>(kaphaScore),
      'dominantDosha': serializer.toJson<String>(dominantDosha),
      'assessedAt': serializer.toJson<DateTime>(assessedAt),
    };
  }

  LocalDoshaScore copyWith(
          {String? id,
          String? userId,
          int? vataScore,
          int? pittaScore,
          int? kaphaScore,
          String? dominantDosha,
          DateTime? assessedAt}) =>
      LocalDoshaScore(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        vataScore: vataScore ?? this.vataScore,
        pittaScore: pittaScore ?? this.pittaScore,
        kaphaScore: kaphaScore ?? this.kaphaScore,
        dominantDosha: dominantDosha ?? this.dominantDosha,
        assessedAt: assessedAt ?? this.assessedAt,
      );
  LocalDoshaScore copyWithCompanion(LocalDoshaScoresCompanion data) {
    return LocalDoshaScore(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      vataScore: data.vataScore.present ? data.vataScore.value : this.vataScore,
      pittaScore:
          data.pittaScore.present ? data.pittaScore.value : this.pittaScore,
      kaphaScore:
          data.kaphaScore.present ? data.kaphaScore.value : this.kaphaScore,
      dominantDosha: data.dominantDosha.present
          ? data.dominantDosha.value
          : this.dominantDosha,
      assessedAt:
          data.assessedAt.present ? data.assessedAt.value : this.assessedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDoshaScore(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('vataScore: $vataScore, ')
          ..write('pittaScore: $pittaScore, ')
          ..write('kaphaScore: $kaphaScore, ')
          ..write('dominantDosha: $dominantDosha, ')
          ..write('assessedAt: $assessedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, vataScore, pittaScore, kaphaScore, dominantDosha, assessedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDoshaScore &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.vataScore == this.vataScore &&
          other.pittaScore == this.pittaScore &&
          other.kaphaScore == this.kaphaScore &&
          other.dominantDosha == this.dominantDosha &&
          other.assessedAt == this.assessedAt);
}

class LocalDoshaScoresCompanion extends UpdateCompanion<LocalDoshaScore> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> vataScore;
  final Value<int> pittaScore;
  final Value<int> kaphaScore;
  final Value<String> dominantDosha;
  final Value<DateTime> assessedAt;
  final Value<int> rowid;
  const LocalDoshaScoresCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.vataScore = const Value.absent(),
    this.pittaScore = const Value.absent(),
    this.kaphaScore = const Value.absent(),
    this.dominantDosha = const Value.absent(),
    this.assessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDoshaScoresCompanion.insert({
    required String id,
    required String userId,
    required int vataScore,
    required int pittaScore,
    required int kaphaScore,
    required String dominantDosha,
    this.assessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        vataScore = Value(vataScore),
        pittaScore = Value(pittaScore),
        kaphaScore = Value(kaphaScore),
        dominantDosha = Value(dominantDosha);
  static Insertable<LocalDoshaScore> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? vataScore,
    Expression<int>? pittaScore,
    Expression<int>? kaphaScore,
    Expression<String>? dominantDosha,
    Expression<DateTime>? assessedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (vataScore != null) 'vata_score': vataScore,
      if (pittaScore != null) 'pitta_score': pittaScore,
      if (kaphaScore != null) 'kapha_score': kaphaScore,
      if (dominantDosha != null) 'dominant_dosha': dominantDosha,
      if (assessedAt != null) 'assessed_at': assessedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDoshaScoresCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? vataScore,
      Value<int>? pittaScore,
      Value<int>? kaphaScore,
      Value<String>? dominantDosha,
      Value<DateTime>? assessedAt,
      Value<int>? rowid}) {
    return LocalDoshaScoresCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vataScore: vataScore ?? this.vataScore,
      pittaScore: pittaScore ?? this.pittaScore,
      kaphaScore: kaphaScore ?? this.kaphaScore,
      dominantDosha: dominantDosha ?? this.dominantDosha,
      assessedAt: assessedAt ?? this.assessedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (vataScore.present) {
      map['vata_score'] = Variable<int>(vataScore.value);
    }
    if (pittaScore.present) {
      map['pitta_score'] = Variable<int>(pittaScore.value);
    }
    if (kaphaScore.present) {
      map['kapha_score'] = Variable<int>(kaphaScore.value);
    }
    if (dominantDosha.present) {
      map['dominant_dosha'] = Variable<String>(dominantDosha.value);
    }
    if (assessedAt.present) {
      map['assessed_at'] = Variable<DateTime>(assessedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDoshaScoresCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('vataScore: $vataScore, ')
          ..write('pittaScore: $pittaScore, ')
          ..write('kaphaScore: $kaphaScore, ')
          ..write('dominantDosha: $dominantDosha, ')
          ..write('assessedAt: $assessedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCycleTrackingTable extends LocalCycleTracking
    with TableInfo<$LocalCycleTrackingTable, LocalCycleTrackingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCycleTrackingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cycleLengthDaysMeta =
      const VerificationMeta('cycleLengthDays');
  @override
  late final GeneratedColumn<int> cycleLengthDays = GeneratedColumn<int>(
      'cycle_length_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentCycleDayMeta =
      const VerificationMeta('currentCycleDay');
  @override
  late final GeneratedColumn<int> currentCycleDay = GeneratedColumn<int>(
      'current_cycle_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentPhaseMeta =
      const VerificationMeta('currentPhase');
  @override
  late final GeneratedColumn<String> currentPhase = GeneratedColumn<String>(
      'current_phase', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hasPcosMeta =
      const VerificationMeta('hasPcos');
  @override
  late final GeneratedColumn<bool> hasPcos = GeneratedColumn<bool>(
      'has_pcos', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("has_pcos" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        cycleLengthDays,
        currentCycleDay,
        currentPhase,
        hasPcos,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_cycle_tracking';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalCycleTrackingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('cycle_length_days')) {
      context.handle(
          _cycleLengthDaysMeta,
          cycleLengthDays.isAcceptableOrUnknown(
              data['cycle_length_days']!, _cycleLengthDaysMeta));
    } else if (isInserting) {
      context.missing(_cycleLengthDaysMeta);
    }
    if (data.containsKey('current_cycle_day')) {
      context.handle(
          _currentCycleDayMeta,
          currentCycleDay.isAcceptableOrUnknown(
              data['current_cycle_day']!, _currentCycleDayMeta));
    } else if (isInserting) {
      context.missing(_currentCycleDayMeta);
    }
    if (data.containsKey('current_phase')) {
      context.handle(
          _currentPhaseMeta,
          currentPhase.isAcceptableOrUnknown(
              data['current_phase']!, _currentPhaseMeta));
    } else if (isInserting) {
      context.missing(_currentPhaseMeta);
    }
    if (data.containsKey('has_pcos')) {
      context.handle(_hasPcosMeta,
          hasPcos.isAcceptableOrUnknown(data['has_pcos']!, _hasPcosMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalCycleTrackingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCycleTrackingData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      cycleLengthDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycle_length_days'])!,
      currentCycleDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_cycle_day'])!,
      currentPhase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_phase'])!,
      hasPcos: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_pcos'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LocalCycleTrackingTable createAlias(String alias) {
    return $LocalCycleTrackingTable(attachedDatabase, alias);
  }
}

class LocalCycleTrackingData extends DataClass
    implements Insertable<LocalCycleTrackingData> {
  final String userId;
  final int cycleLengthDays;
  final int currentCycleDay;
  final String currentPhase;
  final bool hasPcos;
  final DateTime updatedAt;
  const LocalCycleTrackingData(
      {required this.userId,
      required this.cycleLengthDays,
      required this.currentCycleDay,
      required this.currentPhase,
      required this.hasPcos,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['cycle_length_days'] = Variable<int>(cycleLengthDays);
    map['current_cycle_day'] = Variable<int>(currentCycleDay);
    map['current_phase'] = Variable<String>(currentPhase);
    map['has_pcos'] = Variable<bool>(hasPcos);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalCycleTrackingCompanion toCompanion(bool nullToAbsent) {
    return LocalCycleTrackingCompanion(
      userId: Value(userId),
      cycleLengthDays: Value(cycleLengthDays),
      currentCycleDay: Value(currentCycleDay),
      currentPhase: Value(currentPhase),
      hasPcos: Value(hasPcos),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalCycleTrackingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCycleTrackingData(
      userId: serializer.fromJson<String>(json['userId']),
      cycleLengthDays: serializer.fromJson<int>(json['cycleLengthDays']),
      currentCycleDay: serializer.fromJson<int>(json['currentCycleDay']),
      currentPhase: serializer.fromJson<String>(json['currentPhase']),
      hasPcos: serializer.fromJson<bool>(json['hasPcos']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'cycleLengthDays': serializer.toJson<int>(cycleLengthDays),
      'currentCycleDay': serializer.toJson<int>(currentCycleDay),
      'currentPhase': serializer.toJson<String>(currentPhase),
      'hasPcos': serializer.toJson<bool>(hasPcos),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalCycleTrackingData copyWith(
          {String? userId,
          int? cycleLengthDays,
          int? currentCycleDay,
          String? currentPhase,
          bool? hasPcos,
          DateTime? updatedAt}) =>
      LocalCycleTrackingData(
        userId: userId ?? this.userId,
        cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
        currentCycleDay: currentCycleDay ?? this.currentCycleDay,
        currentPhase: currentPhase ?? this.currentPhase,
        hasPcos: hasPcos ?? this.hasPcos,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalCycleTrackingData copyWithCompanion(LocalCycleTrackingCompanion data) {
    return LocalCycleTrackingData(
      userId: data.userId.present ? data.userId.value : this.userId,
      cycleLengthDays: data.cycleLengthDays.present
          ? data.cycleLengthDays.value
          : this.cycleLengthDays,
      currentCycleDay: data.currentCycleDay.present
          ? data.currentCycleDay.value
          : this.currentCycleDay,
      currentPhase: data.currentPhase.present
          ? data.currentPhase.value
          : this.currentPhase,
      hasPcos: data.hasPcos.present ? data.hasPcos.value : this.hasPcos,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCycleTrackingData(')
          ..write('userId: $userId, ')
          ..write('cycleLengthDays: $cycleLengthDays, ')
          ..write('currentCycleDay: $currentCycleDay, ')
          ..write('currentPhase: $currentPhase, ')
          ..write('hasPcos: $hasPcos, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, cycleLengthDays, currentCycleDay,
      currentPhase, hasPcos, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCycleTrackingData &&
          other.userId == this.userId &&
          other.cycleLengthDays == this.cycleLengthDays &&
          other.currentCycleDay == this.currentCycleDay &&
          other.currentPhase == this.currentPhase &&
          other.hasPcos == this.hasPcos &&
          other.updatedAt == this.updatedAt);
}

class LocalCycleTrackingCompanion
    extends UpdateCompanion<LocalCycleTrackingData> {
  final Value<String> userId;
  final Value<int> cycleLengthDays;
  final Value<int> currentCycleDay;
  final Value<String> currentPhase;
  final Value<bool> hasPcos;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalCycleTrackingCompanion({
    this.userId = const Value.absent(),
    this.cycleLengthDays = const Value.absent(),
    this.currentCycleDay = const Value.absent(),
    this.currentPhase = const Value.absent(),
    this.hasPcos = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCycleTrackingCompanion.insert({
    required String userId,
    required int cycleLengthDays,
    required int currentCycleDay,
    required String currentPhase,
    this.hasPcos = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        cycleLengthDays = Value(cycleLengthDays),
        currentCycleDay = Value(currentCycleDay),
        currentPhase = Value(currentPhase);
  static Insertable<LocalCycleTrackingData> custom({
    Expression<String>? userId,
    Expression<int>? cycleLengthDays,
    Expression<int>? currentCycleDay,
    Expression<String>? currentPhase,
    Expression<bool>? hasPcos,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (cycleLengthDays != null) 'cycle_length_days': cycleLengthDays,
      if (currentCycleDay != null) 'current_cycle_day': currentCycleDay,
      if (currentPhase != null) 'current_phase': currentPhase,
      if (hasPcos != null) 'has_pcos': hasPcos,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCycleTrackingCompanion copyWith(
      {Value<String>? userId,
      Value<int>? cycleLengthDays,
      Value<int>? currentCycleDay,
      Value<String>? currentPhase,
      Value<bool>? hasPcos,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LocalCycleTrackingCompanion(
      userId: userId ?? this.userId,
      cycleLengthDays: cycleLengthDays ?? this.cycleLengthDays,
      currentCycleDay: currentCycleDay ?? this.currentCycleDay,
      currentPhase: currentPhase ?? this.currentPhase,
      hasPcos: hasPcos ?? this.hasPcos,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cycleLengthDays.present) {
      map['cycle_length_days'] = Variable<int>(cycleLengthDays.value);
    }
    if (currentCycleDay.present) {
      map['current_cycle_day'] = Variable<int>(currentCycleDay.value);
    }
    if (currentPhase.present) {
      map['current_phase'] = Variable<String>(currentPhase.value);
    }
    if (hasPcos.present) {
      map['has_pcos'] = Variable<bool>(hasPcos.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCycleTrackingCompanion(')
          ..write('userId: $userId, ')
          ..write('cycleLengthDays: $cycleLengthDays, ')
          ..write('currentCycleDay: $currentCycleDay, ')
          ..write('currentPhase: $currentPhase, ')
          ..write('hasPcos: $hasPcos, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSorenessLogsTable extends LocalSorenessLogs
    with TableInfo<$LocalSorenessLogsTable, LocalSorenessLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSorenessLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _muscleGroupMeta =
      const VerificationMeta('muscleGroup');
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
      'muscle_group', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
      'severity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, muscleGroup, severity, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_soreness_logs';
  @override
  VerificationContext validateIntegrity(Insertable<LocalSorenessLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
          _muscleGroupMeta,
          muscleGroup.isAcceptableOrUnknown(
              data['muscle_group']!, _muscleGroupMeta));
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSorenessLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSorenessLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      muscleGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}muscle_group'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}severity'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}logged_at'])!,
    );
  }

  @override
  $LocalSorenessLogsTable createAlias(String alias) {
    return $LocalSorenessLogsTable(attachedDatabase, alias);
  }
}

class LocalSorenessLog extends DataClass
    implements Insertable<LocalSorenessLog> {
  final String id;
  final String userId;
  final String muscleGroup;
  final int severity;
  final DateTime loggedAt;
  const LocalSorenessLog(
      {required this.id,
      required this.userId,
      required this.muscleGroup,
      required this.severity,
      required this.loggedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['muscle_group'] = Variable<String>(muscleGroup);
    map['severity'] = Variable<int>(severity);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  LocalSorenessLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalSorenessLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      muscleGroup: Value(muscleGroup),
      severity: Value(severity),
      loggedAt: Value(loggedAt),
    );
  }

  factory LocalSorenessLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSorenessLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
      severity: serializer.fromJson<int>(json['severity']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
      'severity': serializer.toJson<int>(severity),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  LocalSorenessLog copyWith(
          {String? id,
          String? userId,
          String? muscleGroup,
          int? severity,
          DateTime? loggedAt}) =>
      LocalSorenessLog(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        muscleGroup: muscleGroup ?? this.muscleGroup,
        severity: severity ?? this.severity,
        loggedAt: loggedAt ?? this.loggedAt,
      );
  LocalSorenessLog copyWithCompanion(LocalSorenessLogsCompanion data) {
    return LocalSorenessLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      muscleGroup:
          data.muscleGroup.present ? data.muscleGroup.value : this.muscleGroup,
      severity: data.severity.present ? data.severity.value : this.severity,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSorenessLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('severity: $severity, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, muscleGroup, severity, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSorenessLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.muscleGroup == this.muscleGroup &&
          other.severity == this.severity &&
          other.loggedAt == this.loggedAt);
}

class LocalSorenessLogsCompanion extends UpdateCompanion<LocalSorenessLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> muscleGroup;
  final Value<int> severity;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const LocalSorenessLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.severity = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSorenessLogsCompanion.insert({
    required String id,
    required String userId,
    required String muscleGroup,
    required int severity,
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        muscleGroup = Value(muscleGroup),
        severity = Value(severity);
  static Insertable<LocalSorenessLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? muscleGroup,
    Expression<int>? severity,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (severity != null) 'severity': severity,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSorenessLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? muscleGroup,
      Value<int>? severity,
      Value<DateTime>? loggedAt,
      Value<int>? rowid}) {
    return LocalSorenessLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      severity: severity ?? this.severity,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSorenessLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('severity: $severity, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCoachSessionsTable extends LocalCoachSessions
    with TableInfo<$LocalCoachSessionsTable, LocalCoachSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCoachSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Daily Coaching Session'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, title, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_coach_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<LocalCoachSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCoachSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCoachSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LocalCoachSessionsTable createAlias(String alias) {
    return $LocalCoachSessionsTable(attachedDatabase, alias);
  }
}

class LocalCoachSession extends DataClass
    implements Insertable<LocalCoachSession> {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalCoachSession(
      {required this.id,
      required this.userId,
      required this.title,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalCoachSessionsCompanion toCompanion(bool nullToAbsent) {
    return LocalCoachSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalCoachSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCoachSession(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalCoachSession copyWith(
          {String? id,
          String? userId,
          String? title,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      LocalCoachSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalCoachSession copyWithCompanion(LocalCoachSessionsCompanion data) {
    return LocalCoachSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCoachSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCoachSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalCoachSessionsCompanion extends UpdateCompanion<LocalCoachSession> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalCoachSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCoachSessionsCompanion.insert({
    required String id,
    required String userId,
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId);
  static Insertable<LocalCoachSession> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCoachSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LocalCoachSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCoachSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCoachMessagesTable extends LocalCoachMessages
    with TableInfo<$LocalCoachMessagesTable, LocalCoachMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCoachMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
      'sender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelUsedMeta =
      const VerificationMeta('modelUsed');
  @override
  late final GeneratedColumn<String> modelUsed = GeneratedColumn<String>(
      'model_used', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessionId, sender, content, modelUsed, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_coach_messages';
  @override
  VerificationContext validateIntegrity(Insertable<LocalCoachMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta,
          sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('model_used')) {
      context.handle(_modelUsedMeta,
          modelUsed.isAcceptableOrUnknown(data['model_used']!, _modelUsedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCoachMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCoachMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      sender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      modelUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_used']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $LocalCoachMessagesTable createAlias(String alias) {
    return $LocalCoachMessagesTable(attachedDatabase, alias);
  }
}

class LocalCoachMessage extends DataClass
    implements Insertable<LocalCoachMessage> {
  final String id;
  final String sessionId;
  final String sender;
  final String content;
  final String? modelUsed;
  final DateTime timestamp;
  const LocalCoachMessage(
      {required this.id,
      required this.sessionId,
      required this.sender,
      required this.content,
      this.modelUsed,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['sender'] = Variable<String>(sender);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || modelUsed != null) {
      map['model_used'] = Variable<String>(modelUsed);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  LocalCoachMessagesCompanion toCompanion(bool nullToAbsent) {
    return LocalCoachMessagesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      sender: Value(sender),
      content: Value(content),
      modelUsed: modelUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(modelUsed),
      timestamp: Value(timestamp),
    );
  }

  factory LocalCoachMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCoachMessage(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sender: serializer.fromJson<String>(json['sender']),
      content: serializer.fromJson<String>(json['content']),
      modelUsed: serializer.fromJson<String?>(json['modelUsed']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'sender': serializer.toJson<String>(sender),
      'content': serializer.toJson<String>(content),
      'modelUsed': serializer.toJson<String?>(modelUsed),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  LocalCoachMessage copyWith(
          {String? id,
          String? sessionId,
          String? sender,
          String? content,
          Value<String?> modelUsed = const Value.absent(),
          DateTime? timestamp}) =>
      LocalCoachMessage(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        sender: sender ?? this.sender,
        content: content ?? this.content,
        modelUsed: modelUsed.present ? modelUsed.value : this.modelUsed,
        timestamp: timestamp ?? this.timestamp,
      );
  LocalCoachMessage copyWithCompanion(LocalCoachMessagesCompanion data) {
    return LocalCoachMessage(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sender: data.sender.present ? data.sender.value : this.sender,
      content: data.content.present ? data.content.value : this.content,
      modelUsed: data.modelUsed.present ? data.modelUsed.value : this.modelUsed,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCoachMessage(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('modelUsed: $modelUsed, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, sender, content, modelUsed, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCoachMessage &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.sender == this.sender &&
          other.content == this.content &&
          other.modelUsed == this.modelUsed &&
          other.timestamp == this.timestamp);
}

class LocalCoachMessagesCompanion extends UpdateCompanion<LocalCoachMessage> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> sender;
  final Value<String> content;
  final Value<String?> modelUsed;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const LocalCoachMessagesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sender = const Value.absent(),
    this.content = const Value.absent(),
    this.modelUsed = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCoachMessagesCompanion.insert({
    required String id,
    required String sessionId,
    required String sender,
    required String content,
    this.modelUsed = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        sender = Value(sender),
        content = Value(content);
  static Insertable<LocalCoachMessage> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? sender,
    Expression<String>? content,
    Expression<String>? modelUsed,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (sender != null) 'sender': sender,
      if (content != null) 'content': content,
      if (modelUsed != null) 'model_used': modelUsed,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCoachMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String>? sender,
      Value<String>? content,
      Value<String?>? modelUsed,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return LocalCoachMessagesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      modelUsed: modelUsed ?? this.modelUsed,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (modelUsed.present) {
      map['model_used'] = Variable<String>(modelUsed.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCoachMessagesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('modelUsed: $modelUsed, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PendingMutationsTable pendingMutations =
      $PendingMutationsTable(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $LocalReadinessScoresTable localReadinessScores =
      $LocalReadinessScoresTable(this);
  late final $LocalDipCacheTable localDipCache = $LocalDipCacheTable(this);
  late final $LocalDoshaScoresTable localDoshaScores =
      $LocalDoshaScoresTable(this);
  late final $LocalCycleTrackingTable localCycleTracking =
      $LocalCycleTrackingTable(this);
  late final $LocalSorenessLogsTable localSorenessLogs =
      $LocalSorenessLogsTable(this);
  late final $LocalCoachSessionsTable localCoachSessions =
      $LocalCoachSessionsTable(this);
  late final $LocalCoachMessagesTable localCoachMessages =
      $LocalCoachMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        pendingMutations,
        localProfiles,
        localReadinessScores,
        localDipCache,
        localDoshaScores,
        localCycleTracking,
        localSorenessLogs,
        localCoachSessions,
        localCoachMessages
      ];
}

typedef $$PendingMutationsTableCreateCompanionBuilder
    = PendingMutationsCompanion Function({
  required String id,
  required String targetTable,
  required String action,
  required String payload,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<int> rowid,
});
typedef $$PendingMutationsTableUpdateCompanionBuilder
    = PendingMutationsCompanion Function({
  Value<String> id,
  Value<String> targetTable,
  Value<String> action,
  Value<String> payload,
  Value<DateTime> createdAt,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<int> rowid,
});

class $$PendingMutationsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingMutationsTable> {
  $$PendingMutationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));
}

class $$PendingMutationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingMutationsTable> {
  $$PendingMutationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));
}

class $$PendingMutationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingMutationsTable> {
  $$PendingMutationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$PendingMutationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingMutationsTable,
    PendingMutation,
    $$PendingMutationsTableFilterComposer,
    $$PendingMutationsTableOrderingComposer,
    $$PendingMutationsTableAnnotationComposer,
    $$PendingMutationsTableCreateCompanionBuilder,
    $$PendingMutationsTableUpdateCompanionBuilder,
    (
      PendingMutation,
      BaseReferences<_$AppDatabase, $PendingMutationsTable, PendingMutation>
    ),
    PendingMutation,
    PrefetchHooks Function()> {
  $$PendingMutationsTableTableManager(
      _$AppDatabase db, $PendingMutationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingMutationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingMutationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingMutationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendingMutationsCompanion(
            id: id,
            targetTable: targetTable,
            action: action,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            lastError: lastError,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String targetTable,
            required String action,
            required String payload,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PendingMutationsCompanion.insert(
            id: id,
            targetTable: targetTable,
            action: action,
            payload: payload,
            createdAt: createdAt,
            retryCount: retryCount,
            lastError: lastError,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PendingMutationsTable, PendingMutation>(table),
                    BaseReferences<_$AppDatabase, $PendingMutationsTable,
                        PendingMutation>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PendingMutationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PendingMutationsTable,
    PendingMutation,
    $$PendingMutationsTableFilterComposer,
    $$PendingMutationsTableOrderingComposer,
    $$PendingMutationsTableAnnotationComposer,
    $$PendingMutationsTableCreateCompanionBuilder,
    $$PendingMutationsTableUpdateCompanionBuilder,
    (
      PendingMutation,
      BaseReferences<_$AppDatabase, $PendingMutationsTable, PendingMutation>
    ),
    PendingMutation,
    PrefetchHooks Function()>;
typedef $$LocalProfilesTableCreateCompanionBuilder = LocalProfilesCompanion
    Function({
  required String userId,
  Value<String?> name,
  Value<int?> age,
  Value<String?> gender,
  Value<double?> heightCm,
  Value<double?> weightKg,
  Value<String?> primaryGoal,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LocalProfilesTableUpdateCompanionBuilder = LocalProfilesCompanion
    Function({
  Value<String> userId,
  Value<String?> name,
  Value<int?> age,
  Value<String?> gender,
  Value<double?> heightCm,
  Value<double?> weightKg,
  Value<String?> primaryGoal,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryGoal => $composableBuilder(
      column: $table.primaryGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryGoal => $composableBuilder(
      column: $table.primaryGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get primaryGoal => $composableBuilder(
      column: $table.primaryGoal, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalProfilesTable,
    LocalProfile,
    $$LocalProfilesTableFilterComposer,
    $$LocalProfilesTableOrderingComposer,
    $$LocalProfilesTableAnnotationComposer,
    $$LocalProfilesTableCreateCompanionBuilder,
    $$LocalProfilesTableUpdateCompanionBuilder,
    (
      LocalProfile,
      BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>
    ),
    LocalProfile,
    PrefetchHooks Function()> {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<String?> primaryGoal = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProfilesCompanion(
            userId: userId,
            name: name,
            age: age,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            primaryGoal: primaryGoal,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            Value<String?> name = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<double?> weightKg = const Value.absent(),
            Value<String?> primaryGoal = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProfilesCompanion.insert(
            userId: userId,
            name: name,
            age: age,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            primaryGoal: primaryGoal,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalProfilesTable, LocalProfile>(table),
                    BaseReferences<_$AppDatabase, $LocalProfilesTable,
                        LocalProfile>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalProfilesTable,
    LocalProfile,
    $$LocalProfilesTableFilterComposer,
    $$LocalProfilesTableOrderingComposer,
    $$LocalProfilesTableAnnotationComposer,
    $$LocalProfilesTableCreateCompanionBuilder,
    $$LocalProfilesTableUpdateCompanionBuilder,
    (
      LocalProfile,
      BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>
    ),
    LocalProfile,
    PrefetchHooks Function()>;
typedef $$LocalReadinessScoresTableCreateCompanionBuilder
    = LocalReadinessScoresCompanion Function({
  required String id,
  required String userId,
  required int score,
  required String confidenceTier,
  Value<DateTime> calculatedAt,
  Value<int> rowid,
});
typedef $$LocalReadinessScoresTableUpdateCompanionBuilder
    = LocalReadinessScoresCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<int> score,
  Value<String> confidenceTier,
  Value<DateTime> calculatedAt,
  Value<int> rowid,
});

class $$LocalReadinessScoresTableFilterComposer
    extends Composer<_$AppDatabase, $LocalReadinessScoresTable> {
  $$LocalReadinessScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get confidenceTier => $composableBuilder(
      column: $table.confidenceTier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get calculatedAt => $composableBuilder(
      column: $table.calculatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalReadinessScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalReadinessScoresTable> {
  $$LocalReadinessScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get confidenceTier => $composableBuilder(
      column: $table.confidenceTier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get calculatedAt => $composableBuilder(
      column: $table.calculatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$LocalReadinessScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalReadinessScoresTable> {
  $$LocalReadinessScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get confidenceTier => $composableBuilder(
      column: $table.confidenceTier, builder: (column) => column);

  GeneratedColumn<DateTime> get calculatedAt => $composableBuilder(
      column: $table.calculatedAt, builder: (column) => column);
}

class $$LocalReadinessScoresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalReadinessScoresTable,
    LocalReadinessScore,
    $$LocalReadinessScoresTableFilterComposer,
    $$LocalReadinessScoresTableOrderingComposer,
    $$LocalReadinessScoresTableAnnotationComposer,
    $$LocalReadinessScoresTableCreateCompanionBuilder,
    $$LocalReadinessScoresTableUpdateCompanionBuilder,
    (
      LocalReadinessScore,
      BaseReferences<_$AppDatabase, $LocalReadinessScoresTable,
          LocalReadinessScore>
    ),
    LocalReadinessScore,
    PrefetchHooks Function()> {
  $$LocalReadinessScoresTableTableManager(
      _$AppDatabase db, $LocalReadinessScoresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalReadinessScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalReadinessScoresTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalReadinessScoresTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> confidenceTier = const Value.absent(),
            Value<DateTime> calculatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalReadinessScoresCompanion(
            id: id,
            userId: userId,
            score: score,
            confidenceTier: confidenceTier,
            calculatedAt: calculatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required int score,
            required String confidenceTier,
            Value<DateTime> calculatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalReadinessScoresCompanion.insert(
            id: id,
            userId: userId,
            score: score,
            confidenceTier: confidenceTier,
            calculatedAt: calculatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalReadinessScoresTable,
                        LocalReadinessScore>(table),
                    BaseReferences<_$AppDatabase, $LocalReadinessScoresTable,
                        LocalReadinessScore>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalReadinessScoresTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LocalReadinessScoresTable,
        LocalReadinessScore,
        $$LocalReadinessScoresTableFilterComposer,
        $$LocalReadinessScoresTableOrderingComposer,
        $$LocalReadinessScoresTableAnnotationComposer,
        $$LocalReadinessScoresTableCreateCompanionBuilder,
        $$LocalReadinessScoresTableUpdateCompanionBuilder,
        (
          LocalReadinessScore,
          BaseReferences<_$AppDatabase, $LocalReadinessScoresTable,
              LocalReadinessScore>
        ),
        LocalReadinessScore,
        PrefetchHooks Function()>;
typedef $$LocalDipCacheTableCreateCompanionBuilder = LocalDipCacheCompanion
    Function({
  required String userId,
  required String date,
  required String payloadJson,
  required DateTime expiresAt,
  Value<int> rowid,
});
typedef $$LocalDipCacheTableUpdateCompanionBuilder = LocalDipCacheCompanion
    Function({
  Value<String> userId,
  Value<String> date,
  Value<String> payloadJson,
  Value<DateTime> expiresAt,
  Value<int> rowid,
});

class $$LocalDipCacheTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDipCacheTable> {
  $$LocalDipCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));
}

class $$LocalDipCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDipCacheTable> {
  $$LocalDipCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalDipCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDipCacheTable> {
  $$LocalDipCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$LocalDipCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalDipCacheTable,
    LocalDipCacheData,
    $$LocalDipCacheTableFilterComposer,
    $$LocalDipCacheTableOrderingComposer,
    $$LocalDipCacheTableAnnotationComposer,
    $$LocalDipCacheTableCreateCompanionBuilder,
    $$LocalDipCacheTableUpdateCompanionBuilder,
    (
      LocalDipCacheData,
      BaseReferences<_$AppDatabase, $LocalDipCacheTable, LocalDipCacheData>
    ),
    LocalDipCacheData,
    PrefetchHooks Function()> {
  $$LocalDipCacheTableTableManager(_$AppDatabase db, $LocalDipCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDipCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDipCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDipCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalDipCacheCompanion(
            userId: userId,
            date: date,
            payloadJson: payloadJson,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String date,
            required String payloadJson,
            required DateTime expiresAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalDipCacheCompanion.insert(
            userId: userId,
            date: date,
            payloadJson: payloadJson,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalDipCacheTable, LocalDipCacheData>(table),
                    BaseReferences<_$AppDatabase, $LocalDipCacheTable,
                        LocalDipCacheData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalDipCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalDipCacheTable,
    LocalDipCacheData,
    $$LocalDipCacheTableFilterComposer,
    $$LocalDipCacheTableOrderingComposer,
    $$LocalDipCacheTableAnnotationComposer,
    $$LocalDipCacheTableCreateCompanionBuilder,
    $$LocalDipCacheTableUpdateCompanionBuilder,
    (
      LocalDipCacheData,
      BaseReferences<_$AppDatabase, $LocalDipCacheTable, LocalDipCacheData>
    ),
    LocalDipCacheData,
    PrefetchHooks Function()>;
typedef $$LocalDoshaScoresTableCreateCompanionBuilder
    = LocalDoshaScoresCompanion Function({
  required String id,
  required String userId,
  required int vataScore,
  required int pittaScore,
  required int kaphaScore,
  required String dominantDosha,
  Value<DateTime> assessedAt,
  Value<int> rowid,
});
typedef $$LocalDoshaScoresTableUpdateCompanionBuilder
    = LocalDoshaScoresCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<int> vataScore,
  Value<int> pittaScore,
  Value<int> kaphaScore,
  Value<String> dominantDosha,
  Value<DateTime> assessedAt,
  Value<int> rowid,
});

class $$LocalDoshaScoresTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDoshaScoresTable> {
  $$LocalDoshaScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vataScore => $composableBuilder(
      column: $table.vataScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pittaScore => $composableBuilder(
      column: $table.pittaScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kaphaScore => $composableBuilder(
      column: $table.kaphaScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dominantDosha => $composableBuilder(
      column: $table.dominantDosha, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get assessedAt => $composableBuilder(
      column: $table.assessedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalDoshaScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDoshaScoresTable> {
  $$LocalDoshaScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vataScore => $composableBuilder(
      column: $table.vataScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pittaScore => $composableBuilder(
      column: $table.pittaScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kaphaScore => $composableBuilder(
      column: $table.kaphaScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dominantDosha => $composableBuilder(
      column: $table.dominantDosha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get assessedAt => $composableBuilder(
      column: $table.assessedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalDoshaScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDoshaScoresTable> {
  $$LocalDoshaScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get vataScore =>
      $composableBuilder(column: $table.vataScore, builder: (column) => column);

  GeneratedColumn<int> get pittaScore => $composableBuilder(
      column: $table.pittaScore, builder: (column) => column);

  GeneratedColumn<int> get kaphaScore => $composableBuilder(
      column: $table.kaphaScore, builder: (column) => column);

  GeneratedColumn<String> get dominantDosha => $composableBuilder(
      column: $table.dominantDosha, builder: (column) => column);

  GeneratedColumn<DateTime> get assessedAt => $composableBuilder(
      column: $table.assessedAt, builder: (column) => column);
}

class $$LocalDoshaScoresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalDoshaScoresTable,
    LocalDoshaScore,
    $$LocalDoshaScoresTableFilterComposer,
    $$LocalDoshaScoresTableOrderingComposer,
    $$LocalDoshaScoresTableAnnotationComposer,
    $$LocalDoshaScoresTableCreateCompanionBuilder,
    $$LocalDoshaScoresTableUpdateCompanionBuilder,
    (
      LocalDoshaScore,
      BaseReferences<_$AppDatabase, $LocalDoshaScoresTable, LocalDoshaScore>
    ),
    LocalDoshaScore,
    PrefetchHooks Function()> {
  $$LocalDoshaScoresTableTableManager(
      _$AppDatabase db, $LocalDoshaScoresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDoshaScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDoshaScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDoshaScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> vataScore = const Value.absent(),
            Value<int> pittaScore = const Value.absent(),
            Value<int> kaphaScore = const Value.absent(),
            Value<String> dominantDosha = const Value.absent(),
            Value<DateTime> assessedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalDoshaScoresCompanion(
            id: id,
            userId: userId,
            vataScore: vataScore,
            pittaScore: pittaScore,
            kaphaScore: kaphaScore,
            dominantDosha: dominantDosha,
            assessedAt: assessedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required int vataScore,
            required int pittaScore,
            required int kaphaScore,
            required String dominantDosha,
            Value<DateTime> assessedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalDoshaScoresCompanion.insert(
            id: id,
            userId: userId,
            vataScore: vataScore,
            pittaScore: pittaScore,
            kaphaScore: kaphaScore,
            dominantDosha: dominantDosha,
            assessedAt: assessedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalDoshaScoresTable, LocalDoshaScore>(table),
                    BaseReferences<_$AppDatabase, $LocalDoshaScoresTable,
                        LocalDoshaScore>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalDoshaScoresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalDoshaScoresTable,
    LocalDoshaScore,
    $$LocalDoshaScoresTableFilterComposer,
    $$LocalDoshaScoresTableOrderingComposer,
    $$LocalDoshaScoresTableAnnotationComposer,
    $$LocalDoshaScoresTableCreateCompanionBuilder,
    $$LocalDoshaScoresTableUpdateCompanionBuilder,
    (
      LocalDoshaScore,
      BaseReferences<_$AppDatabase, $LocalDoshaScoresTable, LocalDoshaScore>
    ),
    LocalDoshaScore,
    PrefetchHooks Function()>;
typedef $$LocalCycleTrackingTableCreateCompanionBuilder
    = LocalCycleTrackingCompanion Function({
  required String userId,
  required int cycleLengthDays,
  required int currentCycleDay,
  required String currentPhase,
  Value<bool> hasPcos,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LocalCycleTrackingTableUpdateCompanionBuilder
    = LocalCycleTrackingCompanion Function({
  Value<String> userId,
  Value<int> cycleLengthDays,
  Value<int> currentCycleDay,
  Value<String> currentPhase,
  Value<bool> hasPcos,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalCycleTrackingTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCycleTrackingTable> {
  $$LocalCycleTrackingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cycleLengthDays => $composableBuilder(
      column: $table.cycleLengthDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentCycleDay => $composableBuilder(
      column: $table.currentCycleDay,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentPhase => $composableBuilder(
      column: $table.currentPhase, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasPcos => $composableBuilder(
      column: $table.hasPcos, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalCycleTrackingTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCycleTrackingTable> {
  $$LocalCycleTrackingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cycleLengthDays => $composableBuilder(
      column: $table.cycleLengthDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentCycleDay => $composableBuilder(
      column: $table.currentCycleDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentPhase => $composableBuilder(
      column: $table.currentPhase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasPcos => $composableBuilder(
      column: $table.hasPcos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalCycleTrackingTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCycleTrackingTable> {
  $$LocalCycleTrackingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get cycleLengthDays => $composableBuilder(
      column: $table.cycleLengthDays, builder: (column) => column);

  GeneratedColumn<int> get currentCycleDay => $composableBuilder(
      column: $table.currentCycleDay, builder: (column) => column);

  GeneratedColumn<String> get currentPhase => $composableBuilder(
      column: $table.currentPhase, builder: (column) => column);

  GeneratedColumn<bool> get hasPcos =>
      $composableBuilder(column: $table.hasPcos, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalCycleTrackingTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalCycleTrackingTable,
    LocalCycleTrackingData,
    $$LocalCycleTrackingTableFilterComposer,
    $$LocalCycleTrackingTableOrderingComposer,
    $$LocalCycleTrackingTableAnnotationComposer,
    $$LocalCycleTrackingTableCreateCompanionBuilder,
    $$LocalCycleTrackingTableUpdateCompanionBuilder,
    (
      LocalCycleTrackingData,
      BaseReferences<_$AppDatabase, $LocalCycleTrackingTable,
          LocalCycleTrackingData>
    ),
    LocalCycleTrackingData,
    PrefetchHooks Function()> {
  $$LocalCycleTrackingTableTableManager(
      _$AppDatabase db, $LocalCycleTrackingTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCycleTrackingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCycleTrackingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCycleTrackingTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> cycleLengthDays = const Value.absent(),
            Value<int> currentCycleDay = const Value.absent(),
            Value<String> currentPhase = const Value.absent(),
            Value<bool> hasPcos = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCycleTrackingCompanion(
            userId: userId,
            cycleLengthDays: cycleLengthDays,
            currentCycleDay: currentCycleDay,
            currentPhase: currentPhase,
            hasPcos: hasPcos,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int cycleLengthDays,
            required int currentCycleDay,
            required String currentPhase,
            Value<bool> hasPcos = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCycleTrackingCompanion.insert(
            userId: userId,
            cycleLengthDays: cycleLengthDays,
            currentCycleDay: currentCycleDay,
            currentPhase: currentPhase,
            hasPcos: hasPcos,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalCycleTrackingTable,
                        LocalCycleTrackingData>(table),
                    BaseReferences<_$AppDatabase, $LocalCycleTrackingTable,
                        LocalCycleTrackingData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalCycleTrackingTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalCycleTrackingTable,
    LocalCycleTrackingData,
    $$LocalCycleTrackingTableFilterComposer,
    $$LocalCycleTrackingTableOrderingComposer,
    $$LocalCycleTrackingTableAnnotationComposer,
    $$LocalCycleTrackingTableCreateCompanionBuilder,
    $$LocalCycleTrackingTableUpdateCompanionBuilder,
    (
      LocalCycleTrackingData,
      BaseReferences<_$AppDatabase, $LocalCycleTrackingTable,
          LocalCycleTrackingData>
    ),
    LocalCycleTrackingData,
    PrefetchHooks Function()>;
typedef $$LocalSorenessLogsTableCreateCompanionBuilder
    = LocalSorenessLogsCompanion Function({
  required String id,
  required String userId,
  required String muscleGroup,
  required int severity,
  Value<DateTime> loggedAt,
  Value<int> rowid,
});
typedef $$LocalSorenessLogsTableUpdateCompanionBuilder
    = LocalSorenessLogsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> muscleGroup,
  Value<int> severity,
  Value<DateTime> loggedAt,
  Value<int> rowid,
});

class $$LocalSorenessLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSorenessLogsTable> {
  $$LocalSorenessLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalSorenessLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSorenessLogsTable> {
  $$LocalSorenessLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalSorenessLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSorenessLogsTable> {
  $$LocalSorenessLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
      column: $table.muscleGroup, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$LocalSorenessLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalSorenessLogsTable,
    LocalSorenessLog,
    $$LocalSorenessLogsTableFilterComposer,
    $$LocalSorenessLogsTableOrderingComposer,
    $$LocalSorenessLogsTableAnnotationComposer,
    $$LocalSorenessLogsTableCreateCompanionBuilder,
    $$LocalSorenessLogsTableUpdateCompanionBuilder,
    (
      LocalSorenessLog,
      BaseReferences<_$AppDatabase, $LocalSorenessLogsTable, LocalSorenessLog>
    ),
    LocalSorenessLog,
    PrefetchHooks Function()> {
  $$LocalSorenessLogsTableTableManager(
      _$AppDatabase db, $LocalSorenessLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSorenessLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSorenessLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSorenessLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> muscleGroup = const Value.absent(),
            Value<int> severity = const Value.absent(),
            Value<DateTime> loggedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSorenessLogsCompanion(
            id: id,
            userId: userId,
            muscleGroup: muscleGroup,
            severity: severity,
            loggedAt: loggedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String muscleGroup,
            required int severity,
            Value<DateTime> loggedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSorenessLogsCompanion.insert(
            id: id,
            userId: userId,
            muscleGroup: muscleGroup,
            severity: severity,
            loggedAt: loggedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalSorenessLogsTable, LocalSorenessLog>(
                        table),
                    BaseReferences<_$AppDatabase, $LocalSorenessLogsTable,
                        LocalSorenessLog>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalSorenessLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalSorenessLogsTable,
    LocalSorenessLog,
    $$LocalSorenessLogsTableFilterComposer,
    $$LocalSorenessLogsTableOrderingComposer,
    $$LocalSorenessLogsTableAnnotationComposer,
    $$LocalSorenessLogsTableCreateCompanionBuilder,
    $$LocalSorenessLogsTableUpdateCompanionBuilder,
    (
      LocalSorenessLog,
      BaseReferences<_$AppDatabase, $LocalSorenessLogsTable, LocalSorenessLog>
    ),
    LocalSorenessLog,
    PrefetchHooks Function()>;
typedef $$LocalCoachSessionsTableCreateCompanionBuilder
    = LocalCoachSessionsCompanion Function({
  required String id,
  required String userId,
  Value<String> title,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LocalCoachSessionsTableUpdateCompanionBuilder
    = LocalCoachSessionsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> title,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalCoachSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCoachSessionsTable> {
  $$LocalCoachSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalCoachSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCoachSessionsTable> {
  $$LocalCoachSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalCoachSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCoachSessionsTable> {
  $$LocalCoachSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalCoachSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalCoachSessionsTable,
    LocalCoachSession,
    $$LocalCoachSessionsTableFilterComposer,
    $$LocalCoachSessionsTableOrderingComposer,
    $$LocalCoachSessionsTableAnnotationComposer,
    $$LocalCoachSessionsTableCreateCompanionBuilder,
    $$LocalCoachSessionsTableUpdateCompanionBuilder,
    (
      LocalCoachSession,
      BaseReferences<_$AppDatabase, $LocalCoachSessionsTable, LocalCoachSession>
    ),
    LocalCoachSession,
    PrefetchHooks Function()> {
  $$LocalCoachSessionsTableTableManager(
      _$AppDatabase db, $LocalCoachSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCoachSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCoachSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCoachSessionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCoachSessionsCompanion(
            id: id,
            userId: userId,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String> title = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCoachSessionsCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalCoachSessionsTable, LocalCoachSession>(
                        table),
                    BaseReferences<_$AppDatabase, $LocalCoachSessionsTable,
                        LocalCoachSession>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalCoachSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalCoachSessionsTable,
    LocalCoachSession,
    $$LocalCoachSessionsTableFilterComposer,
    $$LocalCoachSessionsTableOrderingComposer,
    $$LocalCoachSessionsTableAnnotationComposer,
    $$LocalCoachSessionsTableCreateCompanionBuilder,
    $$LocalCoachSessionsTableUpdateCompanionBuilder,
    (
      LocalCoachSession,
      BaseReferences<_$AppDatabase, $LocalCoachSessionsTable, LocalCoachSession>
    ),
    LocalCoachSession,
    PrefetchHooks Function()>;
typedef $$LocalCoachMessagesTableCreateCompanionBuilder
    = LocalCoachMessagesCompanion Function({
  required String id,
  required String sessionId,
  required String sender,
  required String content,
  Value<String?> modelUsed,
  Value<DateTime> timestamp,
  Value<int> rowid,
});
typedef $$LocalCoachMessagesTableUpdateCompanionBuilder
    = LocalCoachMessagesCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> sender,
  Value<String> content,
  Value<String?> modelUsed,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

class $$LocalCoachMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCoachMessagesTable> {
  $$LocalCoachMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelUsed => $composableBuilder(
      column: $table.modelUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$LocalCoachMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCoachMessagesTable> {
  $$LocalCoachMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelUsed => $composableBuilder(
      column: $table.modelUsed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$LocalCoachMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCoachMessagesTable> {
  $$LocalCoachMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get modelUsed =>
      $composableBuilder(column: $table.modelUsed, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$LocalCoachMessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalCoachMessagesTable,
    LocalCoachMessage,
    $$LocalCoachMessagesTableFilterComposer,
    $$LocalCoachMessagesTableOrderingComposer,
    $$LocalCoachMessagesTableAnnotationComposer,
    $$LocalCoachMessagesTableCreateCompanionBuilder,
    $$LocalCoachMessagesTableUpdateCompanionBuilder,
    (
      LocalCoachMessage,
      BaseReferences<_$AppDatabase, $LocalCoachMessagesTable, LocalCoachMessage>
    ),
    LocalCoachMessage,
    PrefetchHooks Function()> {
  $$LocalCoachMessagesTableTableManager(
      _$AppDatabase db, $LocalCoachMessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCoachMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCoachMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCoachMessagesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> sender = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> modelUsed = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCoachMessagesCompanion(
            id: id,
            sessionId: sessionId,
            sender: sender,
            content: content,
            modelUsed: modelUsed,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required String sender,
            required String content,
            Value<String?> modelUsed = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCoachMessagesCompanion.insert(
            id: id,
            sessionId: sessionId,
            sender: sender,
            content: content,
            modelUsed: modelUsed,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LocalCoachMessagesTable, LocalCoachMessage>(
                        table),
                    BaseReferences<_$AppDatabase, $LocalCoachMessagesTable,
                        LocalCoachMessage>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalCoachMessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalCoachMessagesTable,
    LocalCoachMessage,
    $$LocalCoachMessagesTableFilterComposer,
    $$LocalCoachMessagesTableOrderingComposer,
    $$LocalCoachMessagesTableAnnotationComposer,
    $$LocalCoachMessagesTableCreateCompanionBuilder,
    $$LocalCoachMessagesTableUpdateCompanionBuilder,
    (
      LocalCoachMessage,
      BaseReferences<_$AppDatabase, $LocalCoachMessagesTable, LocalCoachMessage>
    ),
    LocalCoachMessage,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PendingMutationsTableTableManager get pendingMutations =>
      $$PendingMutationsTableTableManager(_db, _db.pendingMutations);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$LocalReadinessScoresTableTableManager get localReadinessScores =>
      $$LocalReadinessScoresTableTableManager(_db, _db.localReadinessScores);
  $$LocalDipCacheTableTableManager get localDipCache =>
      $$LocalDipCacheTableTableManager(_db, _db.localDipCache);
  $$LocalDoshaScoresTableTableManager get localDoshaScores =>
      $$LocalDoshaScoresTableTableManager(_db, _db.localDoshaScores);
  $$LocalCycleTrackingTableTableManager get localCycleTracking =>
      $$LocalCycleTrackingTableTableManager(_db, _db.localCycleTracking);
  $$LocalSorenessLogsTableTableManager get localSorenessLogs =>
      $$LocalSorenessLogsTableTableManager(_db, _db.localSorenessLogs);
  $$LocalCoachSessionsTableTableManager get localCoachSessions =>
      $$LocalCoachSessionsTableTableManager(_db, _db.localCoachSessions);
  $$LocalCoachMessagesTableTableManager get localCoachMessages =>
      $$LocalCoachMessagesTableTableManager(_db, _db.localCoachMessages);
}
