// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalsMeta = const VerificationMeta('goals');
  @override
  late final GeneratedColumn<String> goals = GeneratedColumn<String>(
    'goals',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    age,
    weight,
    height,
    goals,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('goals')) {
      context.handle(
        _goalsMeta,
        goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      ),
      goals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goals'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String? name;
  final String? email;
  final int? age;
  final double? weight;
  final double? height;
  final String? goals;
  const User({
    required this.id,
    this.name,
    this.email,
    this.age,
    this.weight,
    this.height,
    this.goals,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    if (!nullToAbsent || goals != null) {
      map['goals'] = Variable<String>(goals);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      goals: goals == null && nullToAbsent
          ? const Value.absent()
          : Value(goals),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      age: serializer.fromJson<int?>(json['age']),
      weight: serializer.fromJson<double?>(json['weight']),
      height: serializer.fromJson<double?>(json['height']),
      goals: serializer.fromJson<String?>(json['goals']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'age': serializer.toJson<int?>(age),
      'weight': serializer.toJson<double?>(weight),
      'height': serializer.toJson<double?>(height),
      'goals': serializer.toJson<String?>(goals),
    };
  }

  User copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<double?> height = const Value.absent(),
    Value<String?> goals = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    email: email.present ? email.value : this.email,
    age: age.present ? age.value : this.age,
    weight: weight.present ? weight.value : this.weight,
    height: height.present ? height.value : this.height,
    goals: goals.present ? goals.value : this.goals,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      age: data.age.present ? data.age.value : this.age,
      weight: data.weight.present ? data.weight.value : this.weight,
      height: data.height.present ? data.height.value : this.height,
      goals: data.goals.present ? data.goals.value : this.goals,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('age: $age, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('goals: $goals')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, age, weight, height, goals);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.age == this.age &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.goals == this.goals);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> email;
  final Value<int?> age;
  final Value<double?> weight;
  final Value<double?> height;
  final Value<String?> goals;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.goals = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.goals = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<int>? age,
    Expression<double>? weight,
    Expression<double>? height,
    Expression<String>? goals,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (goals != null) 'goals': goals,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? email,
    Value<int?>? age,
    Value<double?>? weight,
    Value<double?>? height,
    Value<String?>? goals,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goals: goals ?? this.goals,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('age: $age, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('goals: $goals, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterLogsTable extends WaterLogs
    with TableInfo<$WaterLogsTable, WaterLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cupsMeta = const VerificationMeta('cups');
  @override
  late final GeneratedColumn<int> cups = GeneratedColumn<int>(
    'cups',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncBatchIdMeta = const VerificationMeta(
    'syncBatchId',
  );
  @override
  late final GeneratedColumn<String> syncBatchId = GeneratedColumn<String>(
    'sync_batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcPhysicalTimeMeta = const VerificationMeta(
    'hlcPhysicalTime',
  );
  @override
  late final GeneratedColumn<DateTime> hlcPhysicalTime =
      GeneratedColumn<DateTime>(
        'hlc_physical_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _hlcLogicalCounterMeta = const VerificationMeta(
    'hlcLogicalCounter',
  );
  @override
  late final GeneratedColumn<int> hlcLogicalCounter = GeneratedColumn<int>(
    'hlc_logical_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcNodeIdMeta = const VerificationMeta(
    'hlcNodeId',
  );
  @override
  late final GeneratedColumn<String> hlcNodeId = GeneratedColumn<String>(
    'hlc_node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cups,
    syncBatchId,
    loggedAt,
    hlcPhysicalTime,
    hlcLogicalCounter,
    hlcNodeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cups')) {
      context.handle(
        _cupsMeta,
        cups.isAcceptableOrUnknown(data['cups']!, _cupsMeta),
      );
    } else if (isInserting) {
      context.missing(_cupsMeta);
    }
    if (data.containsKey('sync_batch_id')) {
      context.handle(
        _syncBatchIdMeta,
        syncBatchId.isAcceptableOrUnknown(
          data['sync_batch_id']!,
          _syncBatchIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncBatchIdMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('hlc_physical_time')) {
      context.handle(
        _hlcPhysicalTimeMeta,
        hlcPhysicalTime.isAcceptableOrUnknown(
          data['hlc_physical_time']!,
          _hlcPhysicalTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hlcPhysicalTimeMeta);
    }
    if (data.containsKey('hlc_logical_counter')) {
      context.handle(
        _hlcLogicalCounterMeta,
        hlcLogicalCounter.isAcceptableOrUnknown(
          data['hlc_logical_counter']!,
          _hlcLogicalCounterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hlcLogicalCounterMeta);
    }
    if (data.containsKey('hlc_node_id')) {
      context.handle(
        _hlcNodeIdMeta,
        hlcNodeId.isAcceptableOrUnknown(data['hlc_node_id']!, _hlcNodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcNodeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cups: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cups'],
      )!,
      syncBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_batch_id'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      hlcPhysicalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hlc_physical_time'],
      )!,
      hlcLogicalCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hlc_logical_counter'],
      )!,
      hlcNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc_node_id'],
      )!,
    );
  }

  @override
  $WaterLogsTable createAlias(String alias) {
    return $WaterLogsTable(attachedDatabase, alias);
  }
}

class WaterLog extends DataClass implements Insertable<WaterLog> {
  final int id;
  final int cups;
  final String syncBatchId;
  final DateTime loggedAt;
  final DateTime hlcPhysicalTime;
  final int hlcLogicalCounter;
  final String hlcNodeId;
  const WaterLog({
    required this.id,
    required this.cups,
    required this.syncBatchId,
    required this.loggedAt,
    required this.hlcPhysicalTime,
    required this.hlcLogicalCounter,
    required this.hlcNodeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cups'] = Variable<int>(cups);
    map['sync_batch_id'] = Variable<String>(syncBatchId);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['hlc_physical_time'] = Variable<DateTime>(hlcPhysicalTime);
    map['hlc_logical_counter'] = Variable<int>(hlcLogicalCounter);
    map['hlc_node_id'] = Variable<String>(hlcNodeId);
    return map;
  }

  WaterLogsCompanion toCompanion(bool nullToAbsent) {
    return WaterLogsCompanion(
      id: Value(id),
      cups: Value(cups),
      syncBatchId: Value(syncBatchId),
      loggedAt: Value(loggedAt),
      hlcPhysicalTime: Value(hlcPhysicalTime),
      hlcLogicalCounter: Value(hlcLogicalCounter),
      hlcNodeId: Value(hlcNodeId),
    );
  }

  factory WaterLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterLog(
      id: serializer.fromJson<int>(json['id']),
      cups: serializer.fromJson<int>(json['cups']),
      syncBatchId: serializer.fromJson<String>(json['syncBatchId']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      hlcPhysicalTime: serializer.fromJson<DateTime>(json['hlcPhysicalTime']),
      hlcLogicalCounter: serializer.fromJson<int>(json['hlcLogicalCounter']),
      hlcNodeId: serializer.fromJson<String>(json['hlcNodeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cups': serializer.toJson<int>(cups),
      'syncBatchId': serializer.toJson<String>(syncBatchId),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'hlcPhysicalTime': serializer.toJson<DateTime>(hlcPhysicalTime),
      'hlcLogicalCounter': serializer.toJson<int>(hlcLogicalCounter),
      'hlcNodeId': serializer.toJson<String>(hlcNodeId),
    };
  }

  WaterLog copyWith({
    int? id,
    int? cups,
    String? syncBatchId,
    DateTime? loggedAt,
    DateTime? hlcPhysicalTime,
    int? hlcLogicalCounter,
    String? hlcNodeId,
  }) => WaterLog(
    id: id ?? this.id,
    cups: cups ?? this.cups,
    syncBatchId: syncBatchId ?? this.syncBatchId,
    loggedAt: loggedAt ?? this.loggedAt,
    hlcPhysicalTime: hlcPhysicalTime ?? this.hlcPhysicalTime,
    hlcLogicalCounter: hlcLogicalCounter ?? this.hlcLogicalCounter,
    hlcNodeId: hlcNodeId ?? this.hlcNodeId,
  );
  WaterLog copyWithCompanion(WaterLogsCompanion data) {
    return WaterLog(
      id: data.id.present ? data.id.value : this.id,
      cups: data.cups.present ? data.cups.value : this.cups,
      syncBatchId: data.syncBatchId.present
          ? data.syncBatchId.value
          : this.syncBatchId,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      hlcPhysicalTime: data.hlcPhysicalTime.present
          ? data.hlcPhysicalTime.value
          : this.hlcPhysicalTime,
      hlcLogicalCounter: data.hlcLogicalCounter.present
          ? data.hlcLogicalCounter.value
          : this.hlcLogicalCounter,
      hlcNodeId: data.hlcNodeId.present ? data.hlcNodeId.value : this.hlcNodeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterLog(')
          ..write('id: $id, ')
          ..write('cups: $cups, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('hlcPhysicalTime: $hlcPhysicalTime, ')
          ..write('hlcLogicalCounter: $hlcLogicalCounter, ')
          ..write('hlcNodeId: $hlcNodeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cups,
    syncBatchId,
    loggedAt,
    hlcPhysicalTime,
    hlcLogicalCounter,
    hlcNodeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterLog &&
          other.id == this.id &&
          other.cups == this.cups &&
          other.syncBatchId == this.syncBatchId &&
          other.loggedAt == this.loggedAt &&
          other.hlcPhysicalTime == this.hlcPhysicalTime &&
          other.hlcLogicalCounter == this.hlcLogicalCounter &&
          other.hlcNodeId == this.hlcNodeId);
}

class WaterLogsCompanion extends UpdateCompanion<WaterLog> {
  final Value<int> id;
  final Value<int> cups;
  final Value<String> syncBatchId;
  final Value<DateTime> loggedAt;
  final Value<DateTime> hlcPhysicalTime;
  final Value<int> hlcLogicalCounter;
  final Value<String> hlcNodeId;
  const WaterLogsCompanion({
    this.id = const Value.absent(),
    this.cups = const Value.absent(),
    this.syncBatchId = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.hlcPhysicalTime = const Value.absent(),
    this.hlcLogicalCounter = const Value.absent(),
    this.hlcNodeId = const Value.absent(),
  });
  WaterLogsCompanion.insert({
    this.id = const Value.absent(),
    required int cups,
    required String syncBatchId,
    required DateTime loggedAt,
    required DateTime hlcPhysicalTime,
    required int hlcLogicalCounter,
    required String hlcNodeId,
  }) : cups = Value(cups),
       syncBatchId = Value(syncBatchId),
       loggedAt = Value(loggedAt),
       hlcPhysicalTime = Value(hlcPhysicalTime),
       hlcLogicalCounter = Value(hlcLogicalCounter),
       hlcNodeId = Value(hlcNodeId);
  static Insertable<WaterLog> custom({
    Expression<int>? id,
    Expression<int>? cups,
    Expression<String>? syncBatchId,
    Expression<DateTime>? loggedAt,
    Expression<DateTime>? hlcPhysicalTime,
    Expression<int>? hlcLogicalCounter,
    Expression<String>? hlcNodeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cups != null) 'cups': cups,
      if (syncBatchId != null) 'sync_batch_id': syncBatchId,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (hlcPhysicalTime != null) 'hlc_physical_time': hlcPhysicalTime,
      if (hlcLogicalCounter != null) 'hlc_logical_counter': hlcLogicalCounter,
      if (hlcNodeId != null) 'hlc_node_id': hlcNodeId,
    });
  }

  WaterLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? cups,
    Value<String>? syncBatchId,
    Value<DateTime>? loggedAt,
    Value<DateTime>? hlcPhysicalTime,
    Value<int>? hlcLogicalCounter,
    Value<String>? hlcNodeId,
  }) {
    return WaterLogsCompanion(
      id: id ?? this.id,
      cups: cups ?? this.cups,
      syncBatchId: syncBatchId ?? this.syncBatchId,
      loggedAt: loggedAt ?? this.loggedAt,
      hlcPhysicalTime: hlcPhysicalTime ?? this.hlcPhysicalTime,
      hlcLogicalCounter: hlcLogicalCounter ?? this.hlcLogicalCounter,
      hlcNodeId: hlcNodeId ?? this.hlcNodeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cups.present) {
      map['cups'] = Variable<int>(cups.value);
    }
    if (syncBatchId.present) {
      map['sync_batch_id'] = Variable<String>(syncBatchId.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (hlcPhysicalTime.present) {
      map['hlc_physical_time'] = Variable<DateTime>(hlcPhysicalTime.value);
    }
    if (hlcLogicalCounter.present) {
      map['hlc_logical_counter'] = Variable<int>(hlcLogicalCounter.value);
    }
    if (hlcNodeId.present) {
      map['hlc_node_id'] = Variable<String>(hlcNodeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('cups: $cups, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('hlcPhysicalTime: $hlcPhysicalTime, ')
          ..write('hlcLogicalCounter: $hlcLogicalCounter, ')
          ..write('hlcNodeId: $hlcNodeId')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueItemsTable extends SyncQueueItems
    with TableInfo<$SyncQueueItemsTable, SyncQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serializedPayloadMeta = const VerificationMeta(
    'serializedPayload',
  );
  @override
  late final GeneratedColumn<String> serializedPayload =
      GeneratedColumn<String>(
        'serialized_payload',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncBatchIdMeta = const VerificationMeta(
    'syncBatchId',
  );
  @override
  late final GeneratedColumn<String> syncBatchId = GeneratedColumn<String>(
    'sync_batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    serializedPayload,
    retryCount,
    createdAt,
    syncBatchId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('serialized_payload')) {
      context.handle(
        _serializedPayloadMeta,
        serializedPayload.isAcceptableOrUnknown(
          data['serialized_payload']!,
          _serializedPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serializedPayloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_batch_id')) {
      context.handle(
        _syncBatchIdMeta,
        syncBatchId.isAcceptableOrUnknown(
          data['sync_batch_id']!,
          _syncBatchIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncBatchIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      serializedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serialized_payload'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_batch_id'],
      )!,
    );
  }

  @override
  $SyncQueueItemsTable createAlias(String alias) {
    return $SyncQueueItemsTable(attachedDatabase, alias);
  }
}

class SyncQueueItem extends DataClass implements Insertable<SyncQueueItem> {
  final int id;
  final String entityType;
  final String entityId;
  final String serializedPayload;
  final int retryCount;
  final DateTime createdAt;
  final String syncBatchId;
  const SyncQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.serializedPayload,
    required this.retryCount,
    required this.createdAt,
    required this.syncBatchId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['serialized_payload'] = Variable<String>(serializedPayload);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_batch_id'] = Variable<String>(syncBatchId);
    return map;
  }

  SyncQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueItemsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      serializedPayload: Value(serializedPayload),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      syncBatchId: Value(syncBatchId),
    );
  }

  factory SyncQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueItem(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      serializedPayload: serializer.fromJson<String>(json['serializedPayload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncBatchId: serializer.fromJson<String>(json['syncBatchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'serializedPayload': serializer.toJson<String>(serializedPayload),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncBatchId': serializer.toJson<String>(syncBatchId),
    };
  }

  SyncQueueItem copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? serializedPayload,
    int? retryCount,
    DateTime? createdAt,
    String? syncBatchId,
  }) => SyncQueueItem(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    serializedPayload: serializedPayload ?? this.serializedPayload,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
    syncBatchId: syncBatchId ?? this.syncBatchId,
  );
  SyncQueueItem copyWithCompanion(SyncQueueItemsCompanion data) {
    return SyncQueueItem(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      serializedPayload: data.serializedPayload.present
          ? data.serializedPayload.value
          : this.serializedPayload,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncBatchId: data.syncBatchId.present
          ? data.syncBatchId.value
          : this.syncBatchId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItem(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('serializedPayload: $serializedPayload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncBatchId: $syncBatchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    serializedPayload,
    retryCount,
    createdAt,
    syncBatchId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueItem &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.serializedPayload == this.serializedPayload &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.syncBatchId == this.syncBatchId);
}

class SyncQueueItemsCompanion extends UpdateCompanion<SyncQueueItem> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> serializedPayload;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<String> syncBatchId;
  const SyncQueueItemsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.serializedPayload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncBatchId = const Value.absent(),
  });
  SyncQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String serializedPayload,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
    required String syncBatchId,
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       serializedPayload = Value(serializedPayload),
       createdAt = Value(createdAt),
       syncBatchId = Value(syncBatchId);
  static Insertable<SyncQueueItem> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? serializedPayload,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<String>? syncBatchId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (serializedPayload != null) 'serialized_payload': serializedPayload,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (syncBatchId != null) 'sync_batch_id': syncBatchId,
    });
  }

  SyncQueueItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? serializedPayload,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
    Value<String>? syncBatchId,
  }) {
    return SyncQueueItemsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      serializedPayload: serializedPayload ?? this.serializedPayload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      syncBatchId: syncBatchId ?? this.syncBatchId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (serializedPayload.present) {
      map['serialized_payload'] = Variable<String>(serializedPayload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncBatchId.present) {
      map['sync_batch_id'] = Variable<String>(syncBatchId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('serializedPayload: $serializedPayload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncBatchId: $syncBatchId')
          ..write(')'))
        .toString();
  }
}

class $DeadLetterQueueItemsTable extends DeadLetterQueueItems
    with TableInfo<$DeadLetterQueueItemsTable, DeadLetterQueueItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeadLetterQueueItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serializedPayloadMeta = const VerificationMeta(
    'serializedPayload',
  );
  @override
  late final GeneratedColumn<String> serializedPayload =
      GeneratedColumn<String>(
        'serialized_payload',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _syncBatchIdMeta = const VerificationMeta(
    'syncBatchId',
  );
  @override
  late final GeneratedColumn<String> syncBatchId = GeneratedColumn<String>(
    'sync_batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failureReasonMeta = const VerificationMeta(
    'failureReason',
  );
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
    'failure_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failedAtMeta = const VerificationMeta(
    'failedAt',
  );
  @override
  late final GeneratedColumn<DateTime> failedAt = GeneratedColumn<DateTime>(
    'failed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    serializedPayload,
    syncBatchId,
    failureReason,
    failedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dead_letter_queue_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeadLetterQueueItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('serialized_payload')) {
      context.handle(
        _serializedPayloadMeta,
        serializedPayload.isAcceptableOrUnknown(
          data['serialized_payload']!,
          _serializedPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serializedPayloadMeta);
    }
    if (data.containsKey('sync_batch_id')) {
      context.handle(
        _syncBatchIdMeta,
        syncBatchId.isAcceptableOrUnknown(
          data['sync_batch_id']!,
          _syncBatchIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncBatchIdMeta);
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
        _failureReasonMeta,
        failureReason.isAcceptableOrUnknown(
          data['failure_reason']!,
          _failureReasonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_failureReasonMeta);
    }
    if (data.containsKey('failed_at')) {
      context.handle(
        _failedAtMeta,
        failedAt.isAcceptableOrUnknown(data['failed_at']!, _failedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_failedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeadLetterQueueItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeadLetterQueueItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      serializedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serialized_payload'],
      )!,
      syncBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_batch_id'],
      )!,
      failureReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_reason'],
      )!,
      failedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}failed_at'],
      )!,
    );
  }

  @override
  $DeadLetterQueueItemsTable createAlias(String alias) {
    return $DeadLetterQueueItemsTable(attachedDatabase, alias);
  }
}

class DeadLetterQueueItem extends DataClass
    implements Insertable<DeadLetterQueueItem> {
  final int id;
  final String entityType;
  final String entityId;
  final String serializedPayload;
  final String syncBatchId;
  final String failureReason;
  final DateTime failedAt;
  const DeadLetterQueueItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.serializedPayload,
    required this.syncBatchId,
    required this.failureReason,
    required this.failedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['serialized_payload'] = Variable<String>(serializedPayload);
    map['sync_batch_id'] = Variable<String>(syncBatchId);
    map['failure_reason'] = Variable<String>(failureReason);
    map['failed_at'] = Variable<DateTime>(failedAt);
    return map;
  }

  DeadLetterQueueItemsCompanion toCompanion(bool nullToAbsent) {
    return DeadLetterQueueItemsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      serializedPayload: Value(serializedPayload),
      syncBatchId: Value(syncBatchId),
      failureReason: Value(failureReason),
      failedAt: Value(failedAt),
    );
  }

  factory DeadLetterQueueItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeadLetterQueueItem(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      serializedPayload: serializer.fromJson<String>(json['serializedPayload']),
      syncBatchId: serializer.fromJson<String>(json['syncBatchId']),
      failureReason: serializer.fromJson<String>(json['failureReason']),
      failedAt: serializer.fromJson<DateTime>(json['failedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'serializedPayload': serializer.toJson<String>(serializedPayload),
      'syncBatchId': serializer.toJson<String>(syncBatchId),
      'failureReason': serializer.toJson<String>(failureReason),
      'failedAt': serializer.toJson<DateTime>(failedAt),
    };
  }

  DeadLetterQueueItem copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? serializedPayload,
    String? syncBatchId,
    String? failureReason,
    DateTime? failedAt,
  }) => DeadLetterQueueItem(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    serializedPayload: serializedPayload ?? this.serializedPayload,
    syncBatchId: syncBatchId ?? this.syncBatchId,
    failureReason: failureReason ?? this.failureReason,
    failedAt: failedAt ?? this.failedAt,
  );
  DeadLetterQueueItem copyWithCompanion(DeadLetterQueueItemsCompanion data) {
    return DeadLetterQueueItem(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      serializedPayload: data.serializedPayload.present
          ? data.serializedPayload.value
          : this.serializedPayload,
      syncBatchId: data.syncBatchId.present
          ? data.syncBatchId.value
          : this.syncBatchId,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
      failedAt: data.failedAt.present ? data.failedAt.value : this.failedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeadLetterQueueItem(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('serializedPayload: $serializedPayload, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('failureReason: $failureReason, ')
          ..write('failedAt: $failedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    serializedPayload,
    syncBatchId,
    failureReason,
    failedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeadLetterQueueItem &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.serializedPayload == this.serializedPayload &&
          other.syncBatchId == this.syncBatchId &&
          other.failureReason == this.failureReason &&
          other.failedAt == this.failedAt);
}

class DeadLetterQueueItemsCompanion
    extends UpdateCompanion<DeadLetterQueueItem> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> serializedPayload;
  final Value<String> syncBatchId;
  final Value<String> failureReason;
  final Value<DateTime> failedAt;
  const DeadLetterQueueItemsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.serializedPayload = const Value.absent(),
    this.syncBatchId = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.failedAt = const Value.absent(),
  });
  DeadLetterQueueItemsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String serializedPayload,
    required String syncBatchId,
    required String failureReason,
    required DateTime failedAt,
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       serializedPayload = Value(serializedPayload),
       syncBatchId = Value(syncBatchId),
       failureReason = Value(failureReason),
       failedAt = Value(failedAt);
  static Insertable<DeadLetterQueueItem> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? serializedPayload,
    Expression<String>? syncBatchId,
    Expression<String>? failureReason,
    Expression<DateTime>? failedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (serializedPayload != null) 'serialized_payload': serializedPayload,
      if (syncBatchId != null) 'sync_batch_id': syncBatchId,
      if (failureReason != null) 'failure_reason': failureReason,
      if (failedAt != null) 'failed_at': failedAt,
    });
  }

  DeadLetterQueueItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? serializedPayload,
    Value<String>? syncBatchId,
    Value<String>? failureReason,
    Value<DateTime>? failedAt,
  }) {
    return DeadLetterQueueItemsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      serializedPayload: serializedPayload ?? this.serializedPayload,
      syncBatchId: syncBatchId ?? this.syncBatchId,
      failureReason: failureReason ?? this.failureReason,
      failedAt: failedAt ?? this.failedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (serializedPayload.present) {
      map['serialized_payload'] = Variable<String>(serializedPayload.value);
    }
    if (syncBatchId.present) {
      map['sync_batch_id'] = Variable<String>(syncBatchId.value);
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    if (failedAt.present) {
      map['failed_at'] = Variable<DateTime>(failedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeadLetterQueueItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('serializedPayload: $serializedPayload, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('failureReason: $failureReason, ')
          ..write('failedAt: $failedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $WaterLogsTable waterLogs = $WaterLogsTable(this);
  late final $SyncQueueItemsTable syncQueueItems = $SyncQueueItemsTable(this);
  late final $DeadLetterQueueItemsTable deadLetterQueueItems =
      $DeadLetterQueueItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    waterLogs,
    syncQueueItems,
    deadLetterQueueItems,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      Value<String?> name,
      Value<String?> email,
      Value<int?> age,
      Value<double?> weight,
      Value<double?> height,
      Value<String?> goals,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String?> email,
      Value<int?> age,
      Value<double?> weight,
      Value<double?> height,
      Value<String?> goals,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                age: age,
                weight: weight,
                height: height,
                goals: goals,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                age: age,
                weight: weight,
                height: height,
                goals: goals,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$WaterLogsTableCreateCompanionBuilder =
    WaterLogsCompanion Function({
      Value<int> id,
      required int cups,
      required String syncBatchId,
      required DateTime loggedAt,
      required DateTime hlcPhysicalTime,
      required int hlcLogicalCounter,
      required String hlcNodeId,
    });
typedef $$WaterLogsTableUpdateCompanionBuilder =
    WaterLogsCompanion Function({
      Value<int> id,
      Value<int> cups,
      Value<String> syncBatchId,
      Value<DateTime> loggedAt,
      Value<DateTime> hlcPhysicalTime,
      Value<int> hlcLogicalCounter,
      Value<String> hlcNodeId,
    });

class $$WaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cups => $composableBuilder(
    column: $table.cups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get hlcPhysicalTime => $composableBuilder(
    column: $table.hlcPhysicalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hlcLogicalCounter => $composableBuilder(
    column: $table.hlcLogicalCounter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlcNodeId => $composableBuilder(
    column: $table.hlcNodeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cups => $composableBuilder(
    column: $table.cups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get hlcPhysicalTime => $composableBuilder(
    column: $table.hlcPhysicalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hlcLogicalCounter => $composableBuilder(
    column: $table.hlcLogicalCounter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlcNodeId => $composableBuilder(
    column: $table.hlcNodeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterLogsTable> {
  $$WaterLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cups =>
      $composableBuilder(column: $table.cups, builder: (column) => column);

  GeneratedColumn<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get hlcPhysicalTime => $composableBuilder(
    column: $table.hlcPhysicalTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hlcLogicalCounter => $composableBuilder(
    column: $table.hlcLogicalCounter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hlcNodeId =>
      $composableBuilder(column: $table.hlcNodeId, builder: (column) => column);
}

class $$WaterLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterLogsTable,
          WaterLog,
          $$WaterLogsTableFilterComposer,
          $$WaterLogsTableOrderingComposer,
          $$WaterLogsTableAnnotationComposer,
          $$WaterLogsTableCreateCompanionBuilder,
          $$WaterLogsTableUpdateCompanionBuilder,
          (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
          WaterLog,
          PrefetchHooks Function()
        > {
  $$WaterLogsTableTableManager(_$AppDatabase db, $WaterLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cups = const Value.absent(),
                Value<String> syncBatchId = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<DateTime> hlcPhysicalTime = const Value.absent(),
                Value<int> hlcLogicalCounter = const Value.absent(),
                Value<String> hlcNodeId = const Value.absent(),
              }) => WaterLogsCompanion(
                id: id,
                cups: cups,
                syncBatchId: syncBatchId,
                loggedAt: loggedAt,
                hlcPhysicalTime: hlcPhysicalTime,
                hlcLogicalCounter: hlcLogicalCounter,
                hlcNodeId: hlcNodeId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cups,
                required String syncBatchId,
                required DateTime loggedAt,
                required DateTime hlcPhysicalTime,
                required int hlcLogicalCounter,
                required String hlcNodeId,
              }) => WaterLogsCompanion.insert(
                id: id,
                cups: cups,
                syncBatchId: syncBatchId,
                loggedAt: loggedAt,
                hlcPhysicalTime: hlcPhysicalTime,
                hlcLogicalCounter: hlcLogicalCounter,
                hlcNodeId: hlcNodeId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterLogsTable,
      WaterLog,
      $$WaterLogsTableFilterComposer,
      $$WaterLogsTableOrderingComposer,
      $$WaterLogsTableAnnotationComposer,
      $$WaterLogsTableCreateCompanionBuilder,
      $$WaterLogsTableUpdateCompanionBuilder,
      (WaterLog, BaseReferences<_$AppDatabase, $WaterLogsTable, WaterLog>),
      WaterLog,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueItemsTableCreateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityId,
      required String serializedPayload,
      Value<int> retryCount,
      required DateTime createdAt,
      required String syncBatchId,
    });
typedef $$SyncQueueItemsTableUpdateCompanionBuilder =
    SyncQueueItemsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> serializedPayload,
      Value<int> retryCount,
      Value<DateTime> createdAt,
      Value<String> syncBatchId,
    });

class $$SyncQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serializedPayload => $composableBuilder(
    column: $table.serializedPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serializedPayload => $composableBuilder(
    column: $table.serializedPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueItemsTable> {
  $$SyncQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get serializedPayload => $composableBuilder(
    column: $table.serializedPayload,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => column,
  );
}

class $$SyncQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueItemsTable,
          SyncQueueItem,
          $$SyncQueueItemsTableFilterComposer,
          $$SyncQueueItemsTableOrderingComposer,
          $$SyncQueueItemsTableAnnotationComposer,
          $$SyncQueueItemsTableCreateCompanionBuilder,
          $$SyncQueueItemsTableUpdateCompanionBuilder,
          (
            SyncQueueItem,
            BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
          ),
          SyncQueueItem,
          PrefetchHooks Function()
        > {
  $$SyncQueueItemsTableTableManager(
    _$AppDatabase db,
    $SyncQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> serializedPayload = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncBatchId = const Value.absent(),
              }) => SyncQueueItemsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                serializedPayload: serializedPayload,
                retryCount: retryCount,
                createdAt: createdAt,
                syncBatchId: syncBatchId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required String serializedPayload,
                Value<int> retryCount = const Value.absent(),
                required DateTime createdAt,
                required String syncBatchId,
              }) => SyncQueueItemsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                serializedPayload: serializedPayload,
                retryCount: retryCount,
                createdAt: createdAt,
                syncBatchId: syncBatchId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueItemsTable,
      SyncQueueItem,
      $$SyncQueueItemsTableFilterComposer,
      $$SyncQueueItemsTableOrderingComposer,
      $$SyncQueueItemsTableAnnotationComposer,
      $$SyncQueueItemsTableCreateCompanionBuilder,
      $$SyncQueueItemsTableUpdateCompanionBuilder,
      (
        SyncQueueItem,
        BaseReferences<_$AppDatabase, $SyncQueueItemsTable, SyncQueueItem>,
      ),
      SyncQueueItem,
      PrefetchHooks Function()
    >;
typedef $$DeadLetterQueueItemsTableCreateCompanionBuilder =
    DeadLetterQueueItemsCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityId,
      required String serializedPayload,
      required String syncBatchId,
      required String failureReason,
      required DateTime failedAt,
    });
typedef $$DeadLetterQueueItemsTableUpdateCompanionBuilder =
    DeadLetterQueueItemsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> serializedPayload,
      Value<String> syncBatchId,
      Value<String> failureReason,
      Value<DateTime> failedAt,
    });

class $$DeadLetterQueueItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DeadLetterQueueItemsTable> {
  $$DeadLetterQueueItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serializedPayload => $composableBuilder(
    column: $table.serializedPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get failedAt => $composableBuilder(
    column: $table.failedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeadLetterQueueItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeadLetterQueueItemsTable> {
  $$DeadLetterQueueItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serializedPayload => $composableBuilder(
    column: $table.serializedPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get failedAt => $composableBuilder(
    column: $table.failedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeadLetterQueueItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeadLetterQueueItemsTable> {
  $$DeadLetterQueueItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get serializedPayload => $composableBuilder(
    column: $table.serializedPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get failedAt =>
      $composableBuilder(column: $table.failedAt, builder: (column) => column);
}

class $$DeadLetterQueueItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeadLetterQueueItemsTable,
          DeadLetterQueueItem,
          $$DeadLetterQueueItemsTableFilterComposer,
          $$DeadLetterQueueItemsTableOrderingComposer,
          $$DeadLetterQueueItemsTableAnnotationComposer,
          $$DeadLetterQueueItemsTableCreateCompanionBuilder,
          $$DeadLetterQueueItemsTableUpdateCompanionBuilder,
          (
            DeadLetterQueueItem,
            BaseReferences<
              _$AppDatabase,
              $DeadLetterQueueItemsTable,
              DeadLetterQueueItem
            >,
          ),
          DeadLetterQueueItem,
          PrefetchHooks Function()
        > {
  $$DeadLetterQueueItemsTableTableManager(
    _$AppDatabase db,
    $DeadLetterQueueItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeadLetterQueueItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeadLetterQueueItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DeadLetterQueueItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> serializedPayload = const Value.absent(),
                Value<String> syncBatchId = const Value.absent(),
                Value<String> failureReason = const Value.absent(),
                Value<DateTime> failedAt = const Value.absent(),
              }) => DeadLetterQueueItemsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                serializedPayload: serializedPayload,
                syncBatchId: syncBatchId,
                failureReason: failureReason,
                failedAt: failedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required String serializedPayload,
                required String syncBatchId,
                required String failureReason,
                required DateTime failedAt,
              }) => DeadLetterQueueItemsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                serializedPayload: serializedPayload,
                syncBatchId: syncBatchId,
                failureReason: failureReason,
                failedAt: failedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeadLetterQueueItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeadLetterQueueItemsTable,
      DeadLetterQueueItem,
      $$DeadLetterQueueItemsTableFilterComposer,
      $$DeadLetterQueueItemsTableOrderingComposer,
      $$DeadLetterQueueItemsTableAnnotationComposer,
      $$DeadLetterQueueItemsTableCreateCompanionBuilder,
      $$DeadLetterQueueItemsTableUpdateCompanionBuilder,
      (
        DeadLetterQueueItem,
        BaseReferences<
          _$AppDatabase,
          $DeadLetterQueueItemsTable,
          DeadLetterQueueItem
        >,
      ),
      DeadLetterQueueItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WaterLogsTableTableManager get waterLogs =>
      $$WaterLogsTableTableManager(_db, _db.waterLogs);
  $$SyncQueueItemsTableTableManager get syncQueueItems =>
      $$SyncQueueItemsTableTableManager(_db, _db.syncQueueItems);
  $$DeadLetterQueueItemsTableTableManager get deadLetterQueueItems =>
      $$DeadLetterQueueItemsTableTableManager(_db, _db.deadLetterQueueItems);
}
