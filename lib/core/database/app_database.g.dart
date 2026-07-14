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
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _targetWeightMeta = const VerificationMeta(
    'targetWeight',
  );
  @override
  late final GeneratedColumn<double> targetWeight = GeneratedColumn<double>(
    'target_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyCalorieTargetMeta =
      const VerificationMeta('dailyCalorieTarget');
  @override
  late final GeneratedColumn<int> dailyCalorieTarget = GeneratedColumn<int>(
    'daily_calorie_target',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doshaMeta = const VerificationMeta('dosha');
  @override
  late final GeneratedColumn<String> dosha = GeneratedColumn<String>(
    'dosha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentProgramMeta = const VerificationMeta(
    'currentProgram',
  );
  @override
  late final GeneratedColumn<String> currentProgram = GeneratedColumn<String>(
    'current_program',
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
    gender,
    weight,
    height,
    activityLevel,
    goals,
    targetWeight,
    dailyCalorieTarget,
    dosha,
    currentProgram,
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
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
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
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('goals')) {
      context.handle(
        _goalsMeta,
        goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta),
      );
    }
    if (data.containsKey('target_weight')) {
      context.handle(
        _targetWeightMeta,
        targetWeight.isAcceptableOrUnknown(
          data['target_weight']!,
          _targetWeightMeta,
        ),
      );
    }
    if (data.containsKey('daily_calorie_target')) {
      context.handle(
        _dailyCalorieTargetMeta,
        dailyCalorieTarget.isAcceptableOrUnknown(
          data['daily_calorie_target']!,
          _dailyCalorieTargetMeta,
        ),
      );
    }
    if (data.containsKey('dosha')) {
      context.handle(
        _doshaMeta,
        dosha.isAcceptableOrUnknown(data['dosha']!, _doshaMeta),
      );
    }
    if (data.containsKey('current_program')) {
      context.handle(
        _currentProgramMeta,
        currentProgram.isAcceptableOrUnknown(
          data['current_program']!,
          _currentProgramMeta,
        ),
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
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      ),
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      ),
      goals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goals'],
      ),
      targetWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight'],
      ),
      dailyCalorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_calorie_target'],
      ),
      dosha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosha'],
      ),
      currentProgram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_program'],
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
  final String? gender;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? goals;
  final double? targetWeight;
  final int? dailyCalorieTarget;
  final String? dosha;
  final String? currentProgram;
  const User({
    required this.id,
    this.name,
    this.email,
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.activityLevel,
    this.goals,
    this.targetWeight,
    this.dailyCalorieTarget,
    this.dosha,
    this.currentProgram,
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
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    if (!nullToAbsent || activityLevel != null) {
      map['activity_level'] = Variable<String>(activityLevel);
    }
    if (!nullToAbsent || goals != null) {
      map['goals'] = Variable<String>(goals);
    }
    if (!nullToAbsent || targetWeight != null) {
      map['target_weight'] = Variable<double>(targetWeight);
    }
    if (!nullToAbsent || dailyCalorieTarget != null) {
      map['daily_calorie_target'] = Variable<int>(dailyCalorieTarget);
    }
    if (!nullToAbsent || dosha != null) {
      map['dosha'] = Variable<String>(dosha);
    }
    if (!nullToAbsent || currentProgram != null) {
      map['current_program'] = Variable<String>(currentProgram);
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
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      activityLevel: activityLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(activityLevel),
      goals: goals == null && nullToAbsent
          ? const Value.absent()
          : Value(goals),
      targetWeight: targetWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeight),
      dailyCalorieTarget: dailyCalorieTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyCalorieTarget),
      dosha: dosha == null && nullToAbsent
          ? const Value.absent()
          : Value(dosha),
      currentProgram: currentProgram == null && nullToAbsent
          ? const Value.absent()
          : Value(currentProgram),
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
      gender: serializer.fromJson<String?>(json['gender']),
      weight: serializer.fromJson<double?>(json['weight']),
      height: serializer.fromJson<double?>(json['height']),
      activityLevel: serializer.fromJson<String?>(json['activityLevel']),
      goals: serializer.fromJson<String?>(json['goals']),
      targetWeight: serializer.fromJson<double?>(json['targetWeight']),
      dailyCalorieTarget: serializer.fromJson<int?>(json['dailyCalorieTarget']),
      dosha: serializer.fromJson<String?>(json['dosha']),
      currentProgram: serializer.fromJson<String?>(json['currentProgram']),
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
      'gender': serializer.toJson<String?>(gender),
      'weight': serializer.toJson<double?>(weight),
      'height': serializer.toJson<double?>(height),
      'activityLevel': serializer.toJson<String?>(activityLevel),
      'goals': serializer.toJson<String?>(goals),
      'targetWeight': serializer.toJson<double?>(targetWeight),
      'dailyCalorieTarget': serializer.toJson<int?>(dailyCalorieTarget),
      'dosha': serializer.toJson<String?>(dosha),
      'currentProgram': serializer.toJson<String?>(currentProgram),
    };
  }

  User copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<double?> height = const Value.absent(),
    Value<String?> activityLevel = const Value.absent(),
    Value<String?> goals = const Value.absent(),
    Value<double?> targetWeight = const Value.absent(),
    Value<int?> dailyCalorieTarget = const Value.absent(),
    Value<String?> dosha = const Value.absent(),
    Value<String?> currentProgram = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    email: email.present ? email.value : this.email,
    age: age.present ? age.value : this.age,
    gender: gender.present ? gender.value : this.gender,
    weight: weight.present ? weight.value : this.weight,
    height: height.present ? height.value : this.height,
    activityLevel: activityLevel.present
        ? activityLevel.value
        : this.activityLevel,
    goals: goals.present ? goals.value : this.goals,
    targetWeight: targetWeight.present ? targetWeight.value : this.targetWeight,
    dailyCalorieTarget: dailyCalorieTarget.present
        ? dailyCalorieTarget.value
        : this.dailyCalorieTarget,
    dosha: dosha.present ? dosha.value : this.dosha,
    currentProgram: currentProgram.present
        ? currentProgram.value
        : this.currentProgram,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      weight: data.weight.present ? data.weight.value : this.weight,
      height: data.height.present ? data.height.value : this.height,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      goals: data.goals.present ? data.goals.value : this.goals,
      targetWeight: data.targetWeight.present
          ? data.targetWeight.value
          : this.targetWeight,
      dailyCalorieTarget: data.dailyCalorieTarget.present
          ? data.dailyCalorieTarget.value
          : this.dailyCalorieTarget,
      dosha: data.dosha.present ? data.dosha.value : this.dosha,
      currentProgram: data.currentProgram.present
          ? data.currentProgram.value
          : this.currentProgram,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goals: $goals, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('dailyCalorieTarget: $dailyCalorieTarget, ')
          ..write('dosha: $dosha, ')
          ..write('currentProgram: $currentProgram')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    age,
    gender,
    weight,
    height,
    activityLevel,
    goals,
    targetWeight,
    dailyCalorieTarget,
    dosha,
    currentProgram,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.weight == this.weight &&
          other.height == this.height &&
          other.activityLevel == this.activityLevel &&
          other.goals == this.goals &&
          other.targetWeight == this.targetWeight &&
          other.dailyCalorieTarget == this.dailyCalorieTarget &&
          other.dosha == this.dosha &&
          other.currentProgram == this.currentProgram);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> email;
  final Value<int?> age;
  final Value<String?> gender;
  final Value<double?> weight;
  final Value<double?> height;
  final Value<String?> activityLevel;
  final Value<String?> goals;
  final Value<double?> targetWeight;
  final Value<int?> dailyCalorieTarget;
  final Value<String?> dosha;
  final Value<String?> currentProgram;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goals = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.dailyCalorieTarget = const Value.absent(),
    this.dosha = const Value.absent(),
    this.currentProgram = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.weight = const Value.absent(),
    this.height = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goals = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.dailyCalorieTarget = const Value.absent(),
    this.dosha = const Value.absent(),
    this.currentProgram = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<double>? weight,
    Expression<double>? height,
    Expression<String>? activityLevel,
    Expression<String>? goals,
    Expression<double>? targetWeight,
    Expression<int>? dailyCalorieTarget,
    Expression<String>? dosha,
    Expression<String>? currentProgram,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (weight != null) 'weight': weight,
      if (height != null) 'height': height,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (goals != null) 'goals': goals,
      if (targetWeight != null) 'target_weight': targetWeight,
      if (dailyCalorieTarget != null)
        'daily_calorie_target': dailyCalorieTarget,
      if (dosha != null) 'dosha': dosha,
      if (currentProgram != null) 'current_program': currentProgram,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<String?>? email,
    Value<int?>? age,
    Value<String?>? gender,
    Value<double?>? weight,
    Value<double?>? height,
    Value<String?>? activityLevel,
    Value<String?>? goals,
    Value<double?>? targetWeight,
    Value<int?>? dailyCalorieTarget,
    Value<String?>? dosha,
    Value<String?>? currentProgram,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      goals: goals ?? this.goals,
      targetWeight: targetWeight ?? this.targetWeight,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dosha: dosha ?? this.dosha,
      currentProgram: currentProgram ?? this.currentProgram,
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
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (targetWeight.present) {
      map['target_weight'] = Variable<double>(targetWeight.value);
    }
    if (dailyCalorieTarget.present) {
      map['daily_calorie_target'] = Variable<int>(dailyCalorieTarget.value);
    }
    if (dosha.present) {
      map['dosha'] = Variable<String>(dosha.value);
    }
    if (currentProgram.present) {
      map['current_program'] = Variable<String>(currentProgram.value);
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
          ..write('gender: $gender, ')
          ..write('weight: $weight, ')
          ..write('height: $height, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goals: $goals, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('dailyCalorieTarget: $dailyCalorieTarget, ')
          ..write('dosha: $dosha, ')
          ..write('currentProgram: $currentProgram, ')
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

class $DailyIntelligencePackagesTable extends DailyIntelligencePackages
    with TableInfo<$DailyIntelligencePackagesTable, DailyIntelligencePackage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyIntelligencePackagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packageDateMeta = const VerificationMeta(
    'packageDate',
  );
  @override
  late final GeneratedColumn<DateTime> packageDate = GeneratedColumn<DateTime>(
    'package_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryInsightMeta = const VerificationMeta(
    'primaryInsight',
  );
  @override
  late final GeneratedColumn<String> primaryInsight = GeneratedColumn<String>(
    'primary_insight',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _todaysMissionMeta = const VerificationMeta(
    'todaysMission',
  );
  @override
  late final GeneratedColumn<String> todaysMission = GeneratedColumn<String>(
    'todays_mission',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nutritionFocusMeta = const VerificationMeta(
    'nutritionFocus',
  );
  @override
  late final GeneratedColumn<String> nutritionFocus = GeneratedColumn<String>(
    'nutrition_focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recoveryFocusMeta = const VerificationMeta(
    'recoveryFocus',
  );
  @override
  late final GeneratedColumn<String> recoveryFocus = GeneratedColumn<String>(
    'recovery_focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivationMessageMeta = const VerificationMeta(
    'motivationMessage',
  );
  @override
  late final GeneratedColumn<String> motivationMessage =
      GeneratedColumn<String>(
        'motivation_message',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _adjustedCaloriesMeta = const VerificationMeta(
    'adjustedCalories',
  );
  @override
  late final GeneratedColumn<int> adjustedCalories = GeneratedColumn<int>(
    'adjusted_calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adjustedProteinMeta = const VerificationMeta(
    'adjustedProtein',
  );
  @override
  late final GeneratedColumn<int> adjustedProtein = GeneratedColumn<int>(
    'adjusted_protein',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adjustedHydrationLMeta =
      const VerificationMeta('adjustedHydrationL');
  @override
  late final GeneratedColumn<double> adjustedHydrationL =
      GeneratedColumn<double>(
        'adjusted_hydration_l',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _recommendedIntensityMeta =
      const VerificationMeta('recommendedIntensity');
  @override
  late final GeneratedColumn<String> recommendedIntensity =
      GeneratedColumn<String>(
        'recommended_intensity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isRestDayMeta = const VerificationMeta(
    'isRestDay',
  );
  @override
  late final GeneratedColumn<bool> isRestDay = GeneratedColumn<bool>(
    'is_rest_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_rest_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeRisksMeta = const VerificationMeta(
    'activeRisks',
  );
  @override
  late final GeneratedColumn<String> activeRisks = GeneratedColumn<String>(
    'active_risks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _showFestivalBannerMeta =
      const VerificationMeta('showFestivalBanner');
  @override
  late final GeneratedColumn<bool> showFestivalBanner = GeneratedColumn<bool>(
    'show_festival_banner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_festival_banner" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _festivalAdaptationMeta =
      const VerificationMeta('festivalAdaptation');
  @override
  late final GeneratedColumn<String> festivalAdaptation =
      GeneratedColumn<String>(
        'festival_adaptation',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dietBreakActiveMeta = const VerificationMeta(
    'dietBreakActive',
  );
  @override
  late final GeneratedColumn<bool> dietBreakActive = GeneratedColumn<bool>(
    'diet_break_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("diet_break_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _proteinTimingTargetMeta =
      const VerificationMeta('proteinTimingTarget');
  @override
  late final GeneratedColumn<int> proteinTimingTarget = GeneratedColumn<int>(
    'protein_timing_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _loggingReliabilityStatusMeta =
      const VerificationMeta('loggingReliabilityStatus');
  @override
  late final GeneratedColumn<String> loggingReliabilityStatus =
      GeneratedColumn<String>(
        'logging_reliability_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('high'),
      );
  static const VerificationMeta _satietyTargetScoreMeta =
      const VerificationMeta('satietyTargetScore');
  @override
  late final GeneratedColumn<int> satietyTargetScore = GeneratedColumn<int>(
    'satiety_target_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(70),
  );
  static const VerificationMeta _aiCallsUsedMeta = const VerificationMeta(
    'aiCallsUsed',
  );
  @override
  late final GeneratedColumn<int> aiCallsUsed = GeneratedColumn<int>(
    'ai_calls_used',
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
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    userId,
    packageDate,
    primaryInsight,
    todaysMission,
    nutritionFocus,
    recoveryFocus,
    motivationMessage,
    adjustedCalories,
    adjustedProtein,
    adjustedHydrationL,
    recommendedIntensity,
    isRestDay,
    activeRisks,
    showFestivalBanner,
    festivalAdaptation,
    dietBreakActive,
    proteinTimingTarget,
    loggingReliabilityStatus,
    satietyTargetScore,
    aiCallsUsed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_intelligence_packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyIntelligencePackage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('package_date')) {
      context.handle(
        _packageDateMeta,
        packageDate.isAcceptableOrUnknown(
          data['package_date']!,
          _packageDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageDateMeta);
    }
    if (data.containsKey('primary_insight')) {
      context.handle(
        _primaryInsightMeta,
        primaryInsight.isAcceptableOrUnknown(
          data['primary_insight']!,
          _primaryInsightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryInsightMeta);
    }
    if (data.containsKey('todays_mission')) {
      context.handle(
        _todaysMissionMeta,
        todaysMission.isAcceptableOrUnknown(
          data['todays_mission']!,
          _todaysMissionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_todaysMissionMeta);
    }
    if (data.containsKey('nutrition_focus')) {
      context.handle(
        _nutritionFocusMeta,
        nutritionFocus.isAcceptableOrUnknown(
          data['nutrition_focus']!,
          _nutritionFocusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nutritionFocusMeta);
    }
    if (data.containsKey('recovery_focus')) {
      context.handle(
        _recoveryFocusMeta,
        recoveryFocus.isAcceptableOrUnknown(
          data['recovery_focus']!,
          _recoveryFocusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recoveryFocusMeta);
    }
    if (data.containsKey('motivation_message')) {
      context.handle(
        _motivationMessageMeta,
        motivationMessage.isAcceptableOrUnknown(
          data['motivation_message']!,
          _motivationMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_motivationMessageMeta);
    }
    if (data.containsKey('adjusted_calories')) {
      context.handle(
        _adjustedCaloriesMeta,
        adjustedCalories.isAcceptableOrUnknown(
          data['adjusted_calories']!,
          _adjustedCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adjustedCaloriesMeta);
    }
    if (data.containsKey('adjusted_protein')) {
      context.handle(
        _adjustedProteinMeta,
        adjustedProtein.isAcceptableOrUnknown(
          data['adjusted_protein']!,
          _adjustedProteinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adjustedProteinMeta);
    }
    if (data.containsKey('adjusted_hydration_l')) {
      context.handle(
        _adjustedHydrationLMeta,
        adjustedHydrationL.isAcceptableOrUnknown(
          data['adjusted_hydration_l']!,
          _adjustedHydrationLMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adjustedHydrationLMeta);
    }
    if (data.containsKey('recommended_intensity')) {
      context.handle(
        _recommendedIntensityMeta,
        recommendedIntensity.isAcceptableOrUnknown(
          data['recommended_intensity']!,
          _recommendedIntensityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendedIntensityMeta);
    }
    if (data.containsKey('is_rest_day')) {
      context.handle(
        _isRestDayMeta,
        isRestDay.isAcceptableOrUnknown(data['is_rest_day']!, _isRestDayMeta),
      );
    }
    if (data.containsKey('active_risks')) {
      context.handle(
        _activeRisksMeta,
        activeRisks.isAcceptableOrUnknown(
          data['active_risks']!,
          _activeRisksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeRisksMeta);
    }
    if (data.containsKey('show_festival_banner')) {
      context.handle(
        _showFestivalBannerMeta,
        showFestivalBanner.isAcceptableOrUnknown(
          data['show_festival_banner']!,
          _showFestivalBannerMeta,
        ),
      );
    }
    if (data.containsKey('festival_adaptation')) {
      context.handle(
        _festivalAdaptationMeta,
        festivalAdaptation.isAcceptableOrUnknown(
          data['festival_adaptation']!,
          _festivalAdaptationMeta,
        ),
      );
    }
    if (data.containsKey('diet_break_active')) {
      context.handle(
        _dietBreakActiveMeta,
        dietBreakActive.isAcceptableOrUnknown(
          data['diet_break_active']!,
          _dietBreakActiveMeta,
        ),
      );
    }
    if (data.containsKey('protein_timing_target')) {
      context.handle(
        _proteinTimingTargetMeta,
        proteinTimingTarget.isAcceptableOrUnknown(
          data['protein_timing_target']!,
          _proteinTimingTargetMeta,
        ),
      );
    }
    if (data.containsKey('logging_reliability_status')) {
      context.handle(
        _loggingReliabilityStatusMeta,
        loggingReliabilityStatus.isAcceptableOrUnknown(
          data['logging_reliability_status']!,
          _loggingReliabilityStatusMeta,
        ),
      );
    }
    if (data.containsKey('satiety_target_score')) {
      context.handle(
        _satietyTargetScoreMeta,
        satietyTargetScore.isAcceptableOrUnknown(
          data['satiety_target_score']!,
          _satietyTargetScoreMeta,
        ),
      );
    }
    if (data.containsKey('ai_calls_used')) {
      context.handle(
        _aiCallsUsedMeta,
        aiCallsUsed.isAcceptableOrUnknown(
          data['ai_calls_used']!,
          _aiCallsUsedMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  DailyIntelligencePackage map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyIntelligencePackage(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      packageDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}package_date'],
      )!,
      primaryInsight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_insight'],
      )!,
      todaysMission: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}todays_mission'],
      )!,
      nutritionFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrition_focus'],
      )!,
      recoveryFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_focus'],
      )!,
      motivationMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivation_message'],
      )!,
      adjustedCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adjusted_calories'],
      )!,
      adjustedProtein: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}adjusted_protein'],
      )!,
      adjustedHydrationL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}adjusted_hydration_l'],
      )!,
      recommendedIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommended_intensity'],
      )!,
      isRestDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_rest_day'],
      )!,
      activeRisks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_risks'],
      )!,
      showFestivalBanner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_festival_banner'],
      )!,
      festivalAdaptation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}festival_adaptation'],
      ),
      dietBreakActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}diet_break_active'],
      )!,
      proteinTimingTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_timing_target'],
      )!,
      loggingReliabilityStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logging_reliability_status'],
      )!,
      satietyTargetScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}satiety_target_score'],
      )!,
      aiCallsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ai_calls_used'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyIntelligencePackagesTable createAlias(String alias) {
    return $DailyIntelligencePackagesTable(attachedDatabase, alias);
  }
}

class DailyIntelligencePackage extends DataClass
    implements Insertable<DailyIntelligencePackage> {
  final String localId;
  final String userId;
  final DateTime packageDate;
  final String primaryInsight;
  final String todaysMission;
  final String nutritionFocus;
  final String recoveryFocus;
  final String motivationMessage;
  final int adjustedCalories;
  final int adjustedProtein;
  final double adjustedHydrationL;
  final String recommendedIntensity;
  final bool isRestDay;
  final String activeRisks;
  final bool showFestivalBanner;
  final String? festivalAdaptation;
  final bool dietBreakActive;
  final int proteinTimingTarget;
  final String loggingReliabilityStatus;
  final int satietyTargetScore;
  final int aiCallsUsed;
  final DateTime createdAt;
  const DailyIntelligencePackage({
    required this.localId,
    required this.userId,
    required this.packageDate,
    required this.primaryInsight,
    required this.todaysMission,
    required this.nutritionFocus,
    required this.recoveryFocus,
    required this.motivationMessage,
    required this.adjustedCalories,
    required this.adjustedProtein,
    required this.adjustedHydrationL,
    required this.recommendedIntensity,
    required this.isRestDay,
    required this.activeRisks,
    required this.showFestivalBanner,
    this.festivalAdaptation,
    required this.dietBreakActive,
    required this.proteinTimingTarget,
    required this.loggingReliabilityStatus,
    required this.satietyTargetScore,
    required this.aiCallsUsed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['user_id'] = Variable<String>(userId);
    map['package_date'] = Variable<DateTime>(packageDate);
    map['primary_insight'] = Variable<String>(primaryInsight);
    map['todays_mission'] = Variable<String>(todaysMission);
    map['nutrition_focus'] = Variable<String>(nutritionFocus);
    map['recovery_focus'] = Variable<String>(recoveryFocus);
    map['motivation_message'] = Variable<String>(motivationMessage);
    map['adjusted_calories'] = Variable<int>(adjustedCalories);
    map['adjusted_protein'] = Variable<int>(adjustedProtein);
    map['adjusted_hydration_l'] = Variable<double>(adjustedHydrationL);
    map['recommended_intensity'] = Variable<String>(recommendedIntensity);
    map['is_rest_day'] = Variable<bool>(isRestDay);
    map['active_risks'] = Variable<String>(activeRisks);
    map['show_festival_banner'] = Variable<bool>(showFestivalBanner);
    if (!nullToAbsent || festivalAdaptation != null) {
      map['festival_adaptation'] = Variable<String>(festivalAdaptation);
    }
    map['diet_break_active'] = Variable<bool>(dietBreakActive);
    map['protein_timing_target'] = Variable<int>(proteinTimingTarget);
    map['logging_reliability_status'] = Variable<String>(
      loggingReliabilityStatus,
    );
    map['satiety_target_score'] = Variable<int>(satietyTargetScore);
    map['ai_calls_used'] = Variable<int>(aiCallsUsed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyIntelligencePackagesCompanion toCompanion(bool nullToAbsent) {
    return DailyIntelligencePackagesCompanion(
      localId: Value(localId),
      userId: Value(userId),
      packageDate: Value(packageDate),
      primaryInsight: Value(primaryInsight),
      todaysMission: Value(todaysMission),
      nutritionFocus: Value(nutritionFocus),
      recoveryFocus: Value(recoveryFocus),
      motivationMessage: Value(motivationMessage),
      adjustedCalories: Value(adjustedCalories),
      adjustedProtein: Value(adjustedProtein),
      adjustedHydrationL: Value(adjustedHydrationL),
      recommendedIntensity: Value(recommendedIntensity),
      isRestDay: Value(isRestDay),
      activeRisks: Value(activeRisks),
      showFestivalBanner: Value(showFestivalBanner),
      festivalAdaptation: festivalAdaptation == null && nullToAbsent
          ? const Value.absent()
          : Value(festivalAdaptation),
      dietBreakActive: Value(dietBreakActive),
      proteinTimingTarget: Value(proteinTimingTarget),
      loggingReliabilityStatus: Value(loggingReliabilityStatus),
      satietyTargetScore: Value(satietyTargetScore),
      aiCallsUsed: Value(aiCallsUsed),
      createdAt: Value(createdAt),
    );
  }

  factory DailyIntelligencePackage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyIntelligencePackage(
      localId: serializer.fromJson<String>(json['localId']),
      userId: serializer.fromJson<String>(json['userId']),
      packageDate: serializer.fromJson<DateTime>(json['packageDate']),
      primaryInsight: serializer.fromJson<String>(json['primaryInsight']),
      todaysMission: serializer.fromJson<String>(json['todaysMission']),
      nutritionFocus: serializer.fromJson<String>(json['nutritionFocus']),
      recoveryFocus: serializer.fromJson<String>(json['recoveryFocus']),
      motivationMessage: serializer.fromJson<String>(json['motivationMessage']),
      adjustedCalories: serializer.fromJson<int>(json['adjustedCalories']),
      adjustedProtein: serializer.fromJson<int>(json['adjustedProtein']),
      adjustedHydrationL: serializer.fromJson<double>(
        json['adjustedHydrationL'],
      ),
      recommendedIntensity: serializer.fromJson<String>(
        json['recommendedIntensity'],
      ),
      isRestDay: serializer.fromJson<bool>(json['isRestDay']),
      activeRisks: serializer.fromJson<String>(json['activeRisks']),
      showFestivalBanner: serializer.fromJson<bool>(json['showFestivalBanner']),
      festivalAdaptation: serializer.fromJson<String?>(
        json['festivalAdaptation'],
      ),
      dietBreakActive: serializer.fromJson<bool>(json['dietBreakActive']),
      proteinTimingTarget: serializer.fromJson<int>(
        json['proteinTimingTarget'],
      ),
      loggingReliabilityStatus: serializer.fromJson<String>(
        json['loggingReliabilityStatus'],
      ),
      satietyTargetScore: serializer.fromJson<int>(json['satietyTargetScore']),
      aiCallsUsed: serializer.fromJson<int>(json['aiCallsUsed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'userId': serializer.toJson<String>(userId),
      'packageDate': serializer.toJson<DateTime>(packageDate),
      'primaryInsight': serializer.toJson<String>(primaryInsight),
      'todaysMission': serializer.toJson<String>(todaysMission),
      'nutritionFocus': serializer.toJson<String>(nutritionFocus),
      'recoveryFocus': serializer.toJson<String>(recoveryFocus),
      'motivationMessage': serializer.toJson<String>(motivationMessage),
      'adjustedCalories': serializer.toJson<int>(adjustedCalories),
      'adjustedProtein': serializer.toJson<int>(adjustedProtein),
      'adjustedHydrationL': serializer.toJson<double>(adjustedHydrationL),
      'recommendedIntensity': serializer.toJson<String>(recommendedIntensity),
      'isRestDay': serializer.toJson<bool>(isRestDay),
      'activeRisks': serializer.toJson<String>(activeRisks),
      'showFestivalBanner': serializer.toJson<bool>(showFestivalBanner),
      'festivalAdaptation': serializer.toJson<String?>(festivalAdaptation),
      'dietBreakActive': serializer.toJson<bool>(dietBreakActive),
      'proteinTimingTarget': serializer.toJson<int>(proteinTimingTarget),
      'loggingReliabilityStatus': serializer.toJson<String>(
        loggingReliabilityStatus,
      ),
      'satietyTargetScore': serializer.toJson<int>(satietyTargetScore),
      'aiCallsUsed': serializer.toJson<int>(aiCallsUsed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyIntelligencePackage copyWith({
    String? localId,
    String? userId,
    DateTime? packageDate,
    String? primaryInsight,
    String? todaysMission,
    String? nutritionFocus,
    String? recoveryFocus,
    String? motivationMessage,
    int? adjustedCalories,
    int? adjustedProtein,
    double? adjustedHydrationL,
    String? recommendedIntensity,
    bool? isRestDay,
    String? activeRisks,
    bool? showFestivalBanner,
    Value<String?> festivalAdaptation = const Value.absent(),
    bool? dietBreakActive,
    int? proteinTimingTarget,
    String? loggingReliabilityStatus,
    int? satietyTargetScore,
    int? aiCallsUsed,
    DateTime? createdAt,
  }) => DailyIntelligencePackage(
    localId: localId ?? this.localId,
    userId: userId ?? this.userId,
    packageDate: packageDate ?? this.packageDate,
    primaryInsight: primaryInsight ?? this.primaryInsight,
    todaysMission: todaysMission ?? this.todaysMission,
    nutritionFocus: nutritionFocus ?? this.nutritionFocus,
    recoveryFocus: recoveryFocus ?? this.recoveryFocus,
    motivationMessage: motivationMessage ?? this.motivationMessage,
    adjustedCalories: adjustedCalories ?? this.adjustedCalories,
    adjustedProtein: adjustedProtein ?? this.adjustedProtein,
    adjustedHydrationL: adjustedHydrationL ?? this.adjustedHydrationL,
    recommendedIntensity: recommendedIntensity ?? this.recommendedIntensity,
    isRestDay: isRestDay ?? this.isRestDay,
    activeRisks: activeRisks ?? this.activeRisks,
    showFestivalBanner: showFestivalBanner ?? this.showFestivalBanner,
    festivalAdaptation: festivalAdaptation.present
        ? festivalAdaptation.value
        : this.festivalAdaptation,
    dietBreakActive: dietBreakActive ?? this.dietBreakActive,
    proteinTimingTarget: proteinTimingTarget ?? this.proteinTimingTarget,
    loggingReliabilityStatus:
        loggingReliabilityStatus ?? this.loggingReliabilityStatus,
    satietyTargetScore: satietyTargetScore ?? this.satietyTargetScore,
    aiCallsUsed: aiCallsUsed ?? this.aiCallsUsed,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyIntelligencePackage copyWithCompanion(
    DailyIntelligencePackagesCompanion data,
  ) {
    return DailyIntelligencePackage(
      localId: data.localId.present ? data.localId.value : this.localId,
      userId: data.userId.present ? data.userId.value : this.userId,
      packageDate: data.packageDate.present
          ? data.packageDate.value
          : this.packageDate,
      primaryInsight: data.primaryInsight.present
          ? data.primaryInsight.value
          : this.primaryInsight,
      todaysMission: data.todaysMission.present
          ? data.todaysMission.value
          : this.todaysMission,
      nutritionFocus: data.nutritionFocus.present
          ? data.nutritionFocus.value
          : this.nutritionFocus,
      recoveryFocus: data.recoveryFocus.present
          ? data.recoveryFocus.value
          : this.recoveryFocus,
      motivationMessage: data.motivationMessage.present
          ? data.motivationMessage.value
          : this.motivationMessage,
      adjustedCalories: data.adjustedCalories.present
          ? data.adjustedCalories.value
          : this.adjustedCalories,
      adjustedProtein: data.adjustedProtein.present
          ? data.adjustedProtein.value
          : this.adjustedProtein,
      adjustedHydrationL: data.adjustedHydrationL.present
          ? data.adjustedHydrationL.value
          : this.adjustedHydrationL,
      recommendedIntensity: data.recommendedIntensity.present
          ? data.recommendedIntensity.value
          : this.recommendedIntensity,
      isRestDay: data.isRestDay.present ? data.isRestDay.value : this.isRestDay,
      activeRisks: data.activeRisks.present
          ? data.activeRisks.value
          : this.activeRisks,
      showFestivalBanner: data.showFestivalBanner.present
          ? data.showFestivalBanner.value
          : this.showFestivalBanner,
      festivalAdaptation: data.festivalAdaptation.present
          ? data.festivalAdaptation.value
          : this.festivalAdaptation,
      dietBreakActive: data.dietBreakActive.present
          ? data.dietBreakActive.value
          : this.dietBreakActive,
      proteinTimingTarget: data.proteinTimingTarget.present
          ? data.proteinTimingTarget.value
          : this.proteinTimingTarget,
      loggingReliabilityStatus: data.loggingReliabilityStatus.present
          ? data.loggingReliabilityStatus.value
          : this.loggingReliabilityStatus,
      satietyTargetScore: data.satietyTargetScore.present
          ? data.satietyTargetScore.value
          : this.satietyTargetScore,
      aiCallsUsed: data.aiCallsUsed.present
          ? data.aiCallsUsed.value
          : this.aiCallsUsed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyIntelligencePackage(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('packageDate: $packageDate, ')
          ..write('primaryInsight: $primaryInsight, ')
          ..write('todaysMission: $todaysMission, ')
          ..write('nutritionFocus: $nutritionFocus, ')
          ..write('recoveryFocus: $recoveryFocus, ')
          ..write('motivationMessage: $motivationMessage, ')
          ..write('adjustedCalories: $adjustedCalories, ')
          ..write('adjustedProtein: $adjustedProtein, ')
          ..write('adjustedHydrationL: $adjustedHydrationL, ')
          ..write('recommendedIntensity: $recommendedIntensity, ')
          ..write('isRestDay: $isRestDay, ')
          ..write('activeRisks: $activeRisks, ')
          ..write('showFestivalBanner: $showFestivalBanner, ')
          ..write('festivalAdaptation: $festivalAdaptation, ')
          ..write('dietBreakActive: $dietBreakActive, ')
          ..write('proteinTimingTarget: $proteinTimingTarget, ')
          ..write('loggingReliabilityStatus: $loggingReliabilityStatus, ')
          ..write('satietyTargetScore: $satietyTargetScore, ')
          ..write('aiCallsUsed: $aiCallsUsed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    userId,
    packageDate,
    primaryInsight,
    todaysMission,
    nutritionFocus,
    recoveryFocus,
    motivationMessage,
    adjustedCalories,
    adjustedProtein,
    adjustedHydrationL,
    recommendedIntensity,
    isRestDay,
    activeRisks,
    showFestivalBanner,
    festivalAdaptation,
    dietBreakActive,
    proteinTimingTarget,
    loggingReliabilityStatus,
    satietyTargetScore,
    aiCallsUsed,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyIntelligencePackage &&
          other.localId == this.localId &&
          other.userId == this.userId &&
          other.packageDate == this.packageDate &&
          other.primaryInsight == this.primaryInsight &&
          other.todaysMission == this.todaysMission &&
          other.nutritionFocus == this.nutritionFocus &&
          other.recoveryFocus == this.recoveryFocus &&
          other.motivationMessage == this.motivationMessage &&
          other.adjustedCalories == this.adjustedCalories &&
          other.adjustedProtein == this.adjustedProtein &&
          other.adjustedHydrationL == this.adjustedHydrationL &&
          other.recommendedIntensity == this.recommendedIntensity &&
          other.isRestDay == this.isRestDay &&
          other.activeRisks == this.activeRisks &&
          other.showFestivalBanner == this.showFestivalBanner &&
          other.festivalAdaptation == this.festivalAdaptation &&
          other.dietBreakActive == this.dietBreakActive &&
          other.proteinTimingTarget == this.proteinTimingTarget &&
          other.loggingReliabilityStatus == this.loggingReliabilityStatus &&
          other.satietyTargetScore == this.satietyTargetScore &&
          other.aiCallsUsed == this.aiCallsUsed &&
          other.createdAt == this.createdAt);
}

class DailyIntelligencePackagesCompanion
    extends UpdateCompanion<DailyIntelligencePackage> {
  final Value<String> localId;
  final Value<String> userId;
  final Value<DateTime> packageDate;
  final Value<String> primaryInsight;
  final Value<String> todaysMission;
  final Value<String> nutritionFocus;
  final Value<String> recoveryFocus;
  final Value<String> motivationMessage;
  final Value<int> adjustedCalories;
  final Value<int> adjustedProtein;
  final Value<double> adjustedHydrationL;
  final Value<String> recommendedIntensity;
  final Value<bool> isRestDay;
  final Value<String> activeRisks;
  final Value<bool> showFestivalBanner;
  final Value<String?> festivalAdaptation;
  final Value<bool> dietBreakActive;
  final Value<int> proteinTimingTarget;
  final Value<String> loggingReliabilityStatus;
  final Value<int> satietyTargetScore;
  final Value<int> aiCallsUsed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DailyIntelligencePackagesCompanion({
    this.localId = const Value.absent(),
    this.userId = const Value.absent(),
    this.packageDate = const Value.absent(),
    this.primaryInsight = const Value.absent(),
    this.todaysMission = const Value.absent(),
    this.nutritionFocus = const Value.absent(),
    this.recoveryFocus = const Value.absent(),
    this.motivationMessage = const Value.absent(),
    this.adjustedCalories = const Value.absent(),
    this.adjustedProtein = const Value.absent(),
    this.adjustedHydrationL = const Value.absent(),
    this.recommendedIntensity = const Value.absent(),
    this.isRestDay = const Value.absent(),
    this.activeRisks = const Value.absent(),
    this.showFestivalBanner = const Value.absent(),
    this.festivalAdaptation = const Value.absent(),
    this.dietBreakActive = const Value.absent(),
    this.proteinTimingTarget = const Value.absent(),
    this.loggingReliabilityStatus = const Value.absent(),
    this.satietyTargetScore = const Value.absent(),
    this.aiCallsUsed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyIntelligencePackagesCompanion.insert({
    required String localId,
    required String userId,
    required DateTime packageDate,
    required String primaryInsight,
    required String todaysMission,
    required String nutritionFocus,
    required String recoveryFocus,
    required String motivationMessage,
    required int adjustedCalories,
    required int adjustedProtein,
    required double adjustedHydrationL,
    required String recommendedIntensity,
    this.isRestDay = const Value.absent(),
    required String activeRisks,
    this.showFestivalBanner = const Value.absent(),
    this.festivalAdaptation = const Value.absent(),
    this.dietBreakActive = const Value.absent(),
    this.proteinTimingTarget = const Value.absent(),
    this.loggingReliabilityStatus = const Value.absent(),
    this.satietyTargetScore = const Value.absent(),
    this.aiCallsUsed = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       userId = Value(userId),
       packageDate = Value(packageDate),
       primaryInsight = Value(primaryInsight),
       todaysMission = Value(todaysMission),
       nutritionFocus = Value(nutritionFocus),
       recoveryFocus = Value(recoveryFocus),
       motivationMessage = Value(motivationMessage),
       adjustedCalories = Value(adjustedCalories),
       adjustedProtein = Value(adjustedProtein),
       adjustedHydrationL = Value(adjustedHydrationL),
       recommendedIntensity = Value(recommendedIntensity),
       activeRisks = Value(activeRisks),
       createdAt = Value(createdAt);
  static Insertable<DailyIntelligencePackage> custom({
    Expression<String>? localId,
    Expression<String>? userId,
    Expression<DateTime>? packageDate,
    Expression<String>? primaryInsight,
    Expression<String>? todaysMission,
    Expression<String>? nutritionFocus,
    Expression<String>? recoveryFocus,
    Expression<String>? motivationMessage,
    Expression<int>? adjustedCalories,
    Expression<int>? adjustedProtein,
    Expression<double>? adjustedHydrationL,
    Expression<String>? recommendedIntensity,
    Expression<bool>? isRestDay,
    Expression<String>? activeRisks,
    Expression<bool>? showFestivalBanner,
    Expression<String>? festivalAdaptation,
    Expression<bool>? dietBreakActive,
    Expression<int>? proteinTimingTarget,
    Expression<String>? loggingReliabilityStatus,
    Expression<int>? satietyTargetScore,
    Expression<int>? aiCallsUsed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (userId != null) 'user_id': userId,
      if (packageDate != null) 'package_date': packageDate,
      if (primaryInsight != null) 'primary_insight': primaryInsight,
      if (todaysMission != null) 'todays_mission': todaysMission,
      if (nutritionFocus != null) 'nutrition_focus': nutritionFocus,
      if (recoveryFocus != null) 'recovery_focus': recoveryFocus,
      if (motivationMessage != null) 'motivation_message': motivationMessage,
      if (adjustedCalories != null) 'adjusted_calories': adjustedCalories,
      if (adjustedProtein != null) 'adjusted_protein': adjustedProtein,
      if (adjustedHydrationL != null)
        'adjusted_hydration_l': adjustedHydrationL,
      if (recommendedIntensity != null)
        'recommended_intensity': recommendedIntensity,
      if (isRestDay != null) 'is_rest_day': isRestDay,
      if (activeRisks != null) 'active_risks': activeRisks,
      if (showFestivalBanner != null)
        'show_festival_banner': showFestivalBanner,
      if (festivalAdaptation != null) 'festival_adaptation': festivalAdaptation,
      if (dietBreakActive != null) 'diet_break_active': dietBreakActive,
      if (proteinTimingTarget != null)
        'protein_timing_target': proteinTimingTarget,
      if (loggingReliabilityStatus != null)
        'logging_reliability_status': loggingReliabilityStatus,
      if (satietyTargetScore != null)
        'satiety_target_score': satietyTargetScore,
      if (aiCallsUsed != null) 'ai_calls_used': aiCallsUsed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyIntelligencePackagesCompanion copyWith({
    Value<String>? localId,
    Value<String>? userId,
    Value<DateTime>? packageDate,
    Value<String>? primaryInsight,
    Value<String>? todaysMission,
    Value<String>? nutritionFocus,
    Value<String>? recoveryFocus,
    Value<String>? motivationMessage,
    Value<int>? adjustedCalories,
    Value<int>? adjustedProtein,
    Value<double>? adjustedHydrationL,
    Value<String>? recommendedIntensity,
    Value<bool>? isRestDay,
    Value<String>? activeRisks,
    Value<bool>? showFestivalBanner,
    Value<String?>? festivalAdaptation,
    Value<bool>? dietBreakActive,
    Value<int>? proteinTimingTarget,
    Value<String>? loggingReliabilityStatus,
    Value<int>? satietyTargetScore,
    Value<int>? aiCallsUsed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DailyIntelligencePackagesCompanion(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      packageDate: packageDate ?? this.packageDate,
      primaryInsight: primaryInsight ?? this.primaryInsight,
      todaysMission: todaysMission ?? this.todaysMission,
      nutritionFocus: nutritionFocus ?? this.nutritionFocus,
      recoveryFocus: recoveryFocus ?? this.recoveryFocus,
      motivationMessage: motivationMessage ?? this.motivationMessage,
      adjustedCalories: adjustedCalories ?? this.adjustedCalories,
      adjustedProtein: adjustedProtein ?? this.adjustedProtein,
      adjustedHydrationL: adjustedHydrationL ?? this.adjustedHydrationL,
      recommendedIntensity: recommendedIntensity ?? this.recommendedIntensity,
      isRestDay: isRestDay ?? this.isRestDay,
      activeRisks: activeRisks ?? this.activeRisks,
      showFestivalBanner: showFestivalBanner ?? this.showFestivalBanner,
      festivalAdaptation: festivalAdaptation ?? this.festivalAdaptation,
      dietBreakActive: dietBreakActive ?? this.dietBreakActive,
      proteinTimingTarget: proteinTimingTarget ?? this.proteinTimingTarget,
      loggingReliabilityStatus:
          loggingReliabilityStatus ?? this.loggingReliabilityStatus,
      satietyTargetScore: satietyTargetScore ?? this.satietyTargetScore,
      aiCallsUsed: aiCallsUsed ?? this.aiCallsUsed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (packageDate.present) {
      map['package_date'] = Variable<DateTime>(packageDate.value);
    }
    if (primaryInsight.present) {
      map['primary_insight'] = Variable<String>(primaryInsight.value);
    }
    if (todaysMission.present) {
      map['todays_mission'] = Variable<String>(todaysMission.value);
    }
    if (nutritionFocus.present) {
      map['nutrition_focus'] = Variable<String>(nutritionFocus.value);
    }
    if (recoveryFocus.present) {
      map['recovery_focus'] = Variable<String>(recoveryFocus.value);
    }
    if (motivationMessage.present) {
      map['motivation_message'] = Variable<String>(motivationMessage.value);
    }
    if (adjustedCalories.present) {
      map['adjusted_calories'] = Variable<int>(adjustedCalories.value);
    }
    if (adjustedProtein.present) {
      map['adjusted_protein'] = Variable<int>(adjustedProtein.value);
    }
    if (adjustedHydrationL.present) {
      map['adjusted_hydration_l'] = Variable<double>(adjustedHydrationL.value);
    }
    if (recommendedIntensity.present) {
      map['recommended_intensity'] = Variable<String>(
        recommendedIntensity.value,
      );
    }
    if (isRestDay.present) {
      map['is_rest_day'] = Variable<bool>(isRestDay.value);
    }
    if (activeRisks.present) {
      map['active_risks'] = Variable<String>(activeRisks.value);
    }
    if (showFestivalBanner.present) {
      map['show_festival_banner'] = Variable<bool>(showFestivalBanner.value);
    }
    if (festivalAdaptation.present) {
      map['festival_adaptation'] = Variable<String>(festivalAdaptation.value);
    }
    if (dietBreakActive.present) {
      map['diet_break_active'] = Variable<bool>(dietBreakActive.value);
    }
    if (proteinTimingTarget.present) {
      map['protein_timing_target'] = Variable<int>(proteinTimingTarget.value);
    }
    if (loggingReliabilityStatus.present) {
      map['logging_reliability_status'] = Variable<String>(
        loggingReliabilityStatus.value,
      );
    }
    if (satietyTargetScore.present) {
      map['satiety_target_score'] = Variable<int>(satietyTargetScore.value);
    }
    if (aiCallsUsed.present) {
      map['ai_calls_used'] = Variable<int>(aiCallsUsed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyIntelligencePackagesCompanion(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('packageDate: $packageDate, ')
          ..write('primaryInsight: $primaryInsight, ')
          ..write('todaysMission: $todaysMission, ')
          ..write('nutritionFocus: $nutritionFocus, ')
          ..write('recoveryFocus: $recoveryFocus, ')
          ..write('motivationMessage: $motivationMessage, ')
          ..write('adjustedCalories: $adjustedCalories, ')
          ..write('adjustedProtein: $adjustedProtein, ')
          ..write('adjustedHydrationL: $adjustedHydrationL, ')
          ..write('recommendedIntensity: $recommendedIntensity, ')
          ..write('isRestDay: $isRestDay, ')
          ..write('activeRisks: $activeRisks, ')
          ..write('showFestivalBanner: $showFestivalBanner, ')
          ..write('festivalAdaptation: $festivalAdaptation, ')
          ..write('dietBreakActive: $dietBreakActive, ')
          ..write('proteinTimingTarget: $proteinTimingTarget, ')
          ..write('loggingReliabilityStatus: $loggingReliabilityStatus, ')
          ..write('satietyTargetScore: $satietyTargetScore, ')
          ..write('aiCallsUsed: $aiCallsUsed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AICacheEntriesTable extends AICacheEntries
    with TableInfo<$AICacheEntriesTable, AICacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AICacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptHashMeta = const VerificationMeta(
    'promptHash',
  );
  @override
  late final GeneratedColumn<String> promptHash = GeneratedColumn<String>(
    'prompt_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseMeta = const VerificationMeta(
    'response',
  );
  @override
  late final GeneratedColumn<String> response = GeneratedColumn<String>(
    'response',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    promptHash,
    response,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'a_i_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AICacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('prompt_hash')) {
      context.handle(
        _promptHashMeta,
        promptHash.isAcceptableOrUnknown(data['prompt_hash']!, _promptHashMeta),
      );
    } else if (isInserting) {
      context.missing(_promptHashMeta);
    }
    if (data.containsKey('response')) {
      context.handle(
        _responseMeta,
        response.isAcceptableOrUnknown(data['response']!, _responseMeta),
      );
    } else if (isInserting) {
      context.missing(_responseMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, promptHash};
  @override
  AICacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AICacheEntry(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      promptHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_hash'],
      )!,
      response: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $AICacheEntriesTable createAlias(String alias) {
    return $AICacheEntriesTable(attachedDatabase, alias);
  }
}

class AICacheEntry extends DataClass implements Insertable<AICacheEntry> {
  final String userId;
  final String promptHash;
  final String response;
  final DateTime expiresAt;
  const AICacheEntry({
    required this.userId,
    required this.promptHash,
    required this.response,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['prompt_hash'] = Variable<String>(promptHash);
    map['response'] = Variable<String>(response);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  AICacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return AICacheEntriesCompanion(
      userId: Value(userId),
      promptHash: Value(promptHash),
      response: Value(response),
      expiresAt: Value(expiresAt),
    );
  }

  factory AICacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AICacheEntry(
      userId: serializer.fromJson<String>(json['userId']),
      promptHash: serializer.fromJson<String>(json['promptHash']),
      response: serializer.fromJson<String>(json['response']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'promptHash': serializer.toJson<String>(promptHash),
      'response': serializer.toJson<String>(response),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  AICacheEntry copyWith({
    String? userId,
    String? promptHash,
    String? response,
    DateTime? expiresAt,
  }) => AICacheEntry(
    userId: userId ?? this.userId,
    promptHash: promptHash ?? this.promptHash,
    response: response ?? this.response,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  AICacheEntry copyWithCompanion(AICacheEntriesCompanion data) {
    return AICacheEntry(
      userId: data.userId.present ? data.userId.value : this.userId,
      promptHash: data.promptHash.present
          ? data.promptHash.value
          : this.promptHash,
      response: data.response.present ? data.response.value : this.response,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AICacheEntry(')
          ..write('userId: $userId, ')
          ..write('promptHash: $promptHash, ')
          ..write('response: $response, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, promptHash, response, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AICacheEntry &&
          other.userId == this.userId &&
          other.promptHash == this.promptHash &&
          other.response == this.response &&
          other.expiresAt == this.expiresAt);
}

class AICacheEntriesCompanion extends UpdateCompanion<AICacheEntry> {
  final Value<String> userId;
  final Value<String> promptHash;
  final Value<String> response;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const AICacheEntriesCompanion({
    this.userId = const Value.absent(),
    this.promptHash = const Value.absent(),
    this.response = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AICacheEntriesCompanion.insert({
    required String userId,
    required String promptHash,
    required String response,
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       promptHash = Value(promptHash),
       response = Value(response),
       expiresAt = Value(expiresAt);
  static Insertable<AICacheEntry> custom({
    Expression<String>? userId,
    Expression<String>? promptHash,
    Expression<String>? response,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (promptHash != null) 'prompt_hash': promptHash,
      if (response != null) 'response': response,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AICacheEntriesCompanion copyWith({
    Value<String>? userId,
    Value<String>? promptHash,
    Value<String>? response,
    Value<DateTime>? expiresAt,
    Value<int>? rowid,
  }) {
    return AICacheEntriesCompanion(
      userId: userId ?? this.userId,
      promptHash: promptHash ?? this.promptHash,
      response: response ?? this.response,
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
    if (promptHash.present) {
      map['prompt_hash'] = Variable<String>(promptHash.value);
    }
    if (response.present) {
      map['response'] = Variable<String>(response.value);
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
    return (StringBuffer('AICacheEntriesCompanion(')
          ..write('userId: $userId, ')
          ..write('promptHash: $promptHash, ')
          ..write('response: $response, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransformationMemoriesTable extends TransformationMemories
    with TableInfo<$TransformationMemoriesTable, TransformationMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransformationMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightHistoryJsonMeta = const VerificationMeta(
    'weightHistoryJson',
  );
  @override
  late final GeneratedColumn<String> weightHistoryJson =
      GeneratedColumn<String>(
        'weight_history_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _majorStrugglesMeta = const VerificationMeta(
    'majorStruggles',
  );
  @override
  late final GeneratedColumn<String> majorStruggles = GeneratedColumn<String>(
    'major_struggles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _injuriesJsonMeta = const VerificationMeta(
    'injuriesJson',
  );
  @override
  late final GeneratedColumn<String> injuriesJson = GeneratedColumn<String>(
    'injuries_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successPatternsMeta = const VerificationMeta(
    'successPatterns',
  );
  @override
  late final GeneratedColumn<String> successPatterns = GeneratedColumn<String>(
    'success_patterns',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivationTriggersMeta =
      const VerificationMeta('motivationTriggers');
  @override
  late final GeneratedColumn<String> motivationTriggers =
      GeneratedColumn<String>(
        'motivation_triggers',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _primaryPersonalityMeta =
      const VerificationMeta('primaryPersonality');
  @override
  late final GeneratedColumn<String> primaryPersonality =
      GeneratedColumn<String>(
        'primary_personality',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _conversationSummaryMeta =
      const VerificationMeta('conversationSummary');
  @override
  late final GeneratedColumn<String> conversationSummary =
      GeneratedColumn<String>(
        'conversation_summary',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    userId,
    weightHistoryJson,
    majorStruggles,
    injuriesJson,
    successPatterns,
    motivationTriggers,
    primaryPersonality,
    conversationSummary,
    lastUpdated,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transformation_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransformationMemory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('weight_history_json')) {
      context.handle(
        _weightHistoryJsonMeta,
        weightHistoryJson.isAcceptableOrUnknown(
          data['weight_history_json']!,
          _weightHistoryJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightHistoryJsonMeta);
    }
    if (data.containsKey('major_struggles')) {
      context.handle(
        _majorStrugglesMeta,
        majorStruggles.isAcceptableOrUnknown(
          data['major_struggles']!,
          _majorStrugglesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_majorStrugglesMeta);
    }
    if (data.containsKey('injuries_json')) {
      context.handle(
        _injuriesJsonMeta,
        injuriesJson.isAcceptableOrUnknown(
          data['injuries_json']!,
          _injuriesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_injuriesJsonMeta);
    }
    if (data.containsKey('success_patterns')) {
      context.handle(
        _successPatternsMeta,
        successPatterns.isAcceptableOrUnknown(
          data['success_patterns']!,
          _successPatternsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_successPatternsMeta);
    }
    if (data.containsKey('motivation_triggers')) {
      context.handle(
        _motivationTriggersMeta,
        motivationTriggers.isAcceptableOrUnknown(
          data['motivation_triggers']!,
          _motivationTriggersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_motivationTriggersMeta);
    }
    if (data.containsKey('primary_personality')) {
      context.handle(
        _primaryPersonalityMeta,
        primaryPersonality.isAcceptableOrUnknown(
          data['primary_personality']!,
          _primaryPersonalityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryPersonalityMeta);
    }
    if (data.containsKey('conversation_summary')) {
      context.handle(
        _conversationSummaryMeta,
        conversationSummary.isAcceptableOrUnknown(
          data['conversation_summary']!,
          _conversationSummaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationSummaryMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  TransformationMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransformationMemory(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      weightHistoryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_history_json'],
      )!,
      majorStruggles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}major_struggles'],
      )!,
      injuriesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}injuries_json'],
      )!,
      successPatterns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}success_patterns'],
      )!,
      motivationTriggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivation_triggers'],
      )!,
      primaryPersonality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_personality'],
      )!,
      conversationSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_summary'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TransformationMemoriesTable createAlias(String alias) {
    return $TransformationMemoriesTable(attachedDatabase, alias);
  }
}

class TransformationMemory extends DataClass
    implements Insertable<TransformationMemory> {
  final String localId;
  final String userId;
  final String weightHistoryJson;
  final String majorStruggles;
  final String injuriesJson;
  final String successPatterns;
  final String motivationTriggers;
  final String primaryPersonality;
  final String conversationSummary;
  final DateTime lastUpdated;
  final String syncStatus;
  const TransformationMemory({
    required this.localId,
    required this.userId,
    required this.weightHistoryJson,
    required this.majorStruggles,
    required this.injuriesJson,
    required this.successPatterns,
    required this.motivationTriggers,
    required this.primaryPersonality,
    required this.conversationSummary,
    required this.lastUpdated,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['user_id'] = Variable<String>(userId);
    map['weight_history_json'] = Variable<String>(weightHistoryJson);
    map['major_struggles'] = Variable<String>(majorStruggles);
    map['injuries_json'] = Variable<String>(injuriesJson);
    map['success_patterns'] = Variable<String>(successPatterns);
    map['motivation_triggers'] = Variable<String>(motivationTriggers);
    map['primary_personality'] = Variable<String>(primaryPersonality);
    map['conversation_summary'] = Variable<String>(conversationSummary);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TransformationMemoriesCompanion toCompanion(bool nullToAbsent) {
    return TransformationMemoriesCompanion(
      localId: Value(localId),
      userId: Value(userId),
      weightHistoryJson: Value(weightHistoryJson),
      majorStruggles: Value(majorStruggles),
      injuriesJson: Value(injuriesJson),
      successPatterns: Value(successPatterns),
      motivationTriggers: Value(motivationTriggers),
      primaryPersonality: Value(primaryPersonality),
      conversationSummary: Value(conversationSummary),
      lastUpdated: Value(lastUpdated),
      syncStatus: Value(syncStatus),
    );
  }

  factory TransformationMemory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransformationMemory(
      localId: serializer.fromJson<String>(json['localId']),
      userId: serializer.fromJson<String>(json['userId']),
      weightHistoryJson: serializer.fromJson<String>(json['weightHistoryJson']),
      majorStruggles: serializer.fromJson<String>(json['majorStruggles']),
      injuriesJson: serializer.fromJson<String>(json['injuriesJson']),
      successPatterns: serializer.fromJson<String>(json['successPatterns']),
      motivationTriggers: serializer.fromJson<String>(
        json['motivationTriggers'],
      ),
      primaryPersonality: serializer.fromJson<String>(
        json['primaryPersonality'],
      ),
      conversationSummary: serializer.fromJson<String>(
        json['conversationSummary'],
      ),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'userId': serializer.toJson<String>(userId),
      'weightHistoryJson': serializer.toJson<String>(weightHistoryJson),
      'majorStruggles': serializer.toJson<String>(majorStruggles),
      'injuriesJson': serializer.toJson<String>(injuriesJson),
      'successPatterns': serializer.toJson<String>(successPatterns),
      'motivationTriggers': serializer.toJson<String>(motivationTriggers),
      'primaryPersonality': serializer.toJson<String>(primaryPersonality),
      'conversationSummary': serializer.toJson<String>(conversationSummary),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  TransformationMemory copyWith({
    String? localId,
    String? userId,
    String? weightHistoryJson,
    String? majorStruggles,
    String? injuriesJson,
    String? successPatterns,
    String? motivationTriggers,
    String? primaryPersonality,
    String? conversationSummary,
    DateTime? lastUpdated,
    String? syncStatus,
  }) => TransformationMemory(
    localId: localId ?? this.localId,
    userId: userId ?? this.userId,
    weightHistoryJson: weightHistoryJson ?? this.weightHistoryJson,
    majorStruggles: majorStruggles ?? this.majorStruggles,
    injuriesJson: injuriesJson ?? this.injuriesJson,
    successPatterns: successPatterns ?? this.successPatterns,
    motivationTriggers: motivationTriggers ?? this.motivationTriggers,
    primaryPersonality: primaryPersonality ?? this.primaryPersonality,
    conversationSummary: conversationSummary ?? this.conversationSummary,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  TransformationMemory copyWithCompanion(TransformationMemoriesCompanion data) {
    return TransformationMemory(
      localId: data.localId.present ? data.localId.value : this.localId,
      userId: data.userId.present ? data.userId.value : this.userId,
      weightHistoryJson: data.weightHistoryJson.present
          ? data.weightHistoryJson.value
          : this.weightHistoryJson,
      majorStruggles: data.majorStruggles.present
          ? data.majorStruggles.value
          : this.majorStruggles,
      injuriesJson: data.injuriesJson.present
          ? data.injuriesJson.value
          : this.injuriesJson,
      successPatterns: data.successPatterns.present
          ? data.successPatterns.value
          : this.successPatterns,
      motivationTriggers: data.motivationTriggers.present
          ? data.motivationTriggers.value
          : this.motivationTriggers,
      primaryPersonality: data.primaryPersonality.present
          ? data.primaryPersonality.value
          : this.primaryPersonality,
      conversationSummary: data.conversationSummary.present
          ? data.conversationSummary.value
          : this.conversationSummary,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransformationMemory(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('weightHistoryJson: $weightHistoryJson, ')
          ..write('majorStruggles: $majorStruggles, ')
          ..write('injuriesJson: $injuriesJson, ')
          ..write('successPatterns: $successPatterns, ')
          ..write('motivationTriggers: $motivationTriggers, ')
          ..write('primaryPersonality: $primaryPersonality, ')
          ..write('conversationSummary: $conversationSummary, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    userId,
    weightHistoryJson,
    majorStruggles,
    injuriesJson,
    successPatterns,
    motivationTriggers,
    primaryPersonality,
    conversationSummary,
    lastUpdated,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransformationMemory &&
          other.localId == this.localId &&
          other.userId == this.userId &&
          other.weightHistoryJson == this.weightHistoryJson &&
          other.majorStruggles == this.majorStruggles &&
          other.injuriesJson == this.injuriesJson &&
          other.successPatterns == this.successPatterns &&
          other.motivationTriggers == this.motivationTriggers &&
          other.primaryPersonality == this.primaryPersonality &&
          other.conversationSummary == this.conversationSummary &&
          other.lastUpdated == this.lastUpdated &&
          other.syncStatus == this.syncStatus);
}

class TransformationMemoriesCompanion
    extends UpdateCompanion<TransformationMemory> {
  final Value<String> localId;
  final Value<String> userId;
  final Value<String> weightHistoryJson;
  final Value<String> majorStruggles;
  final Value<String> injuriesJson;
  final Value<String> successPatterns;
  final Value<String> motivationTriggers;
  final Value<String> primaryPersonality;
  final Value<String> conversationSummary;
  final Value<DateTime> lastUpdated;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const TransformationMemoriesCompanion({
    this.localId = const Value.absent(),
    this.userId = const Value.absent(),
    this.weightHistoryJson = const Value.absent(),
    this.majorStruggles = const Value.absent(),
    this.injuriesJson = const Value.absent(),
    this.successPatterns = const Value.absent(),
    this.motivationTriggers = const Value.absent(),
    this.primaryPersonality = const Value.absent(),
    this.conversationSummary = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransformationMemoriesCompanion.insert({
    required String localId,
    required String userId,
    required String weightHistoryJson,
    required String majorStruggles,
    required String injuriesJson,
    required String successPatterns,
    required String motivationTriggers,
    required String primaryPersonality,
    required String conversationSummary,
    required DateTime lastUpdated,
    required String syncStatus,
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       userId = Value(userId),
       weightHistoryJson = Value(weightHistoryJson),
       majorStruggles = Value(majorStruggles),
       injuriesJson = Value(injuriesJson),
       successPatterns = Value(successPatterns),
       motivationTriggers = Value(motivationTriggers),
       primaryPersonality = Value(primaryPersonality),
       conversationSummary = Value(conversationSummary),
       lastUpdated = Value(lastUpdated),
       syncStatus = Value(syncStatus);
  static Insertable<TransformationMemory> custom({
    Expression<String>? localId,
    Expression<String>? userId,
    Expression<String>? weightHistoryJson,
    Expression<String>? majorStruggles,
    Expression<String>? injuriesJson,
    Expression<String>? successPatterns,
    Expression<String>? motivationTriggers,
    Expression<String>? primaryPersonality,
    Expression<String>? conversationSummary,
    Expression<DateTime>? lastUpdated,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (userId != null) 'user_id': userId,
      if (weightHistoryJson != null) 'weight_history_json': weightHistoryJson,
      if (majorStruggles != null) 'major_struggles': majorStruggles,
      if (injuriesJson != null) 'injuries_json': injuriesJson,
      if (successPatterns != null) 'success_patterns': successPatterns,
      if (motivationTriggers != null) 'motivation_triggers': motivationTriggers,
      if (primaryPersonality != null) 'primary_personality': primaryPersonality,
      if (conversationSummary != null)
        'conversation_summary': conversationSummary,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransformationMemoriesCompanion copyWith({
    Value<String>? localId,
    Value<String>? userId,
    Value<String>? weightHistoryJson,
    Value<String>? majorStruggles,
    Value<String>? injuriesJson,
    Value<String>? successPatterns,
    Value<String>? motivationTriggers,
    Value<String>? primaryPersonality,
    Value<String>? conversationSummary,
    Value<DateTime>? lastUpdated,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return TransformationMemoriesCompanion(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      weightHistoryJson: weightHistoryJson ?? this.weightHistoryJson,
      majorStruggles: majorStruggles ?? this.majorStruggles,
      injuriesJson: injuriesJson ?? this.injuriesJson,
      successPatterns: successPatterns ?? this.successPatterns,
      motivationTriggers: motivationTriggers ?? this.motivationTriggers,
      primaryPersonality: primaryPersonality ?? this.primaryPersonality,
      conversationSummary: conversationSummary ?? this.conversationSummary,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (weightHistoryJson.present) {
      map['weight_history_json'] = Variable<String>(weightHistoryJson.value);
    }
    if (majorStruggles.present) {
      map['major_struggles'] = Variable<String>(majorStruggles.value);
    }
    if (injuriesJson.present) {
      map['injuries_json'] = Variable<String>(injuriesJson.value);
    }
    if (successPatterns.present) {
      map['success_patterns'] = Variable<String>(successPatterns.value);
    }
    if (motivationTriggers.present) {
      map['motivation_triggers'] = Variable<String>(motivationTriggers.value);
    }
    if (primaryPersonality.present) {
      map['primary_personality'] = Variable<String>(primaryPersonality.value);
    }
    if (conversationSummary.present) {
      map['conversation_summary'] = Variable<String>(conversationSummary.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransformationMemoriesCompanion(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('weightHistoryJson: $weightHistoryJson, ')
          ..write('majorStruggles: $majorStruggles, ')
          ..write('injuriesJson: $injuriesJson, ')
          ..write('successPatterns: $successPatterns, ')
          ..write('motivationTriggers: $motivationTriggers, ')
          ..write('primaryPersonality: $primaryPersonality, ')
          ..write('conversationSummary: $conversationSummary, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedDietPlansTable extends CachedDietPlans
    with TableInfo<$CachedDietPlansTable, CachedDietPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDietPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planJsonMeta = const VerificationMeta(
    'planJson',
  );
  @override
  late final GeneratedColumn<String> planJson = GeneratedColumn<String>(
    'plan_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calorieTargetMeta = const VerificationMeta(
    'calorieTarget',
  );
  @override
  late final GeneratedColumn<int> calorieTarget = GeneratedColumn<int>(
    'calorie_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinTargetGMeta = const VerificationMeta(
    'proteinTargetG',
  );
  @override
  late final GeneratedColumn<int> proteinTargetG = GeneratedColumn<int>(
    'protein_target_g',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAiGeneratedMeta = const VerificationMeta(
    'isAiGenerated',
  );
  @override
  late final GeneratedColumn<bool> isAiGenerated = GeneratedColumn<bool>(
    'is_ai_generated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ai_generated" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    planJson,
    calorieTarget,
    proteinTargetG,
    isAiGenerated,
    generatedAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_diet_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDietPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('plan_json')) {
      context.handle(
        _planJsonMeta,
        planJson.isAcceptableOrUnknown(data['plan_json']!, _planJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_planJsonMeta);
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
        _calorieTargetMeta,
        calorieTarget.isAcceptableOrUnknown(
          data['calorie_target']!,
          _calorieTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calorieTargetMeta);
    }
    if (data.containsKey('protein_target_g')) {
      context.handle(
        _proteinTargetGMeta,
        proteinTargetG.isAcceptableOrUnknown(
          data['protein_target_g']!,
          _proteinTargetGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinTargetGMeta);
    }
    if (data.containsKey('is_ai_generated')) {
      context.handle(
        _isAiGeneratedMeta,
        isAiGenerated.isAcceptableOrUnknown(
          data['is_ai_generated']!,
          _isAiGeneratedMeta,
        ),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  CachedDietPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDietPlan(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      planJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_json'],
      )!,
      calorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_target'],
      )!,
      proteinTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_target_g'],
      )!,
      isAiGenerated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ai_generated'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $CachedDietPlansTable createAlias(String alias) {
    return $CachedDietPlansTable(attachedDatabase, alias);
  }
}

class CachedDietPlan extends DataClass implements Insertable<CachedDietPlan> {
  final String userId;

  /// Full plan serialized as JSON ({"days":[...]}).
  final String planJson;
  final int calorieTarget;
  final int proteinTargetG;
  final bool isAiGenerated;
  final DateTime generatedAt;

  /// Plan is valid for 7 days; re-generate when expired or BMI shifts > 1.0.
  final DateTime expiresAt;
  const CachedDietPlan({
    required this.userId,
    required this.planJson,
    required this.calorieTarget,
    required this.proteinTargetG,
    required this.isAiGenerated,
    required this.generatedAt,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['plan_json'] = Variable<String>(planJson);
    map['calorie_target'] = Variable<int>(calorieTarget);
    map['protein_target_g'] = Variable<int>(proteinTargetG);
    map['is_ai_generated'] = Variable<bool>(isAiGenerated);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  CachedDietPlansCompanion toCompanion(bool nullToAbsent) {
    return CachedDietPlansCompanion(
      userId: Value(userId),
      planJson: Value(planJson),
      calorieTarget: Value(calorieTarget),
      proteinTargetG: Value(proteinTargetG),
      isAiGenerated: Value(isAiGenerated),
      generatedAt: Value(generatedAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory CachedDietPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDietPlan(
      userId: serializer.fromJson<String>(json['userId']),
      planJson: serializer.fromJson<String>(json['planJson']),
      calorieTarget: serializer.fromJson<int>(json['calorieTarget']),
      proteinTargetG: serializer.fromJson<int>(json['proteinTargetG']),
      isAiGenerated: serializer.fromJson<bool>(json['isAiGenerated']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'planJson': serializer.toJson<String>(planJson),
      'calorieTarget': serializer.toJson<int>(calorieTarget),
      'proteinTargetG': serializer.toJson<int>(proteinTargetG),
      'isAiGenerated': serializer.toJson<bool>(isAiGenerated),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  CachedDietPlan copyWith({
    String? userId,
    String? planJson,
    int? calorieTarget,
    int? proteinTargetG,
    bool? isAiGenerated,
    DateTime? generatedAt,
    DateTime? expiresAt,
  }) => CachedDietPlan(
    userId: userId ?? this.userId,
    planJson: planJson ?? this.planJson,
    calorieTarget: calorieTarget ?? this.calorieTarget,
    proteinTargetG: proteinTargetG ?? this.proteinTargetG,
    isAiGenerated: isAiGenerated ?? this.isAiGenerated,
    generatedAt: generatedAt ?? this.generatedAt,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  CachedDietPlan copyWithCompanion(CachedDietPlansCompanion data) {
    return CachedDietPlan(
      userId: data.userId.present ? data.userId.value : this.userId,
      planJson: data.planJson.present ? data.planJson.value : this.planJson,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinTargetG: data.proteinTargetG.present
          ? data.proteinTargetG.value
          : this.proteinTargetG,
      isAiGenerated: data.isAiGenerated.present
          ? data.isAiGenerated.value
          : this.isAiGenerated,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDietPlan(')
          ..write('userId: $userId, ')
          ..write('planJson: $planJson, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTargetG: $proteinTargetG, ')
          ..write('isAiGenerated: $isAiGenerated, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    planJson,
    calorieTarget,
    proteinTargetG,
    isAiGenerated,
    generatedAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDietPlan &&
          other.userId == this.userId &&
          other.planJson == this.planJson &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinTargetG == this.proteinTargetG &&
          other.isAiGenerated == this.isAiGenerated &&
          other.generatedAt == this.generatedAt &&
          other.expiresAt == this.expiresAt);
}

class CachedDietPlansCompanion extends UpdateCompanion<CachedDietPlan> {
  final Value<String> userId;
  final Value<String> planJson;
  final Value<int> calorieTarget;
  final Value<int> proteinTargetG;
  final Value<bool> isAiGenerated;
  final Value<DateTime> generatedAt;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const CachedDietPlansCompanion({
    this.userId = const Value.absent(),
    this.planJson = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTargetG = const Value.absent(),
    this.isAiGenerated = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDietPlansCompanion.insert({
    required String userId,
    required String planJson,
    required int calorieTarget,
    required int proteinTargetG,
    this.isAiGenerated = const Value.absent(),
    required DateTime generatedAt,
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       planJson = Value(planJson),
       calorieTarget = Value(calorieTarget),
       proteinTargetG = Value(proteinTargetG),
       generatedAt = Value(generatedAt),
       expiresAt = Value(expiresAt);
  static Insertable<CachedDietPlan> custom({
    Expression<String>? userId,
    Expression<String>? planJson,
    Expression<int>? calorieTarget,
    Expression<int>? proteinTargetG,
    Expression<bool>? isAiGenerated,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (planJson != null) 'plan_json': planJson,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinTargetG != null) 'protein_target_g': proteinTargetG,
      if (isAiGenerated != null) 'is_ai_generated': isAiGenerated,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDietPlansCompanion copyWith({
    Value<String>? userId,
    Value<String>? planJson,
    Value<int>? calorieTarget,
    Value<int>? proteinTargetG,
    Value<bool>? isAiGenerated,
    Value<DateTime>? generatedAt,
    Value<DateTime>? expiresAt,
    Value<int>? rowid,
  }) {
    return CachedDietPlansCompanion(
      userId: userId ?? this.userId,
      planJson: planJson ?? this.planJson,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
      generatedAt: generatedAt ?? this.generatedAt,
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
    if (planJson.present) {
      map['plan_json'] = Variable<String>(planJson.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<int>(calorieTarget.value);
    }
    if (proteinTargetG.present) {
      map['protein_target_g'] = Variable<int>(proteinTargetG.value);
    }
    if (isAiGenerated.present) {
      map['is_ai_generated'] = Variable<bool>(isAiGenerated.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
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
    return (StringBuffer('CachedDietPlansCompanion(')
          ..write('userId: $userId, ')
          ..write('planJson: $planJson, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTargetG: $proteinTargetG, ')
          ..write('isAiGenerated: $isAiGenerated, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
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
  late final $DailyIntelligencePackagesTable dailyIntelligencePackages =
      $DailyIntelligencePackagesTable(this);
  late final $AICacheEntriesTable aICacheEntries = $AICacheEntriesTable(this);
  late final $TransformationMemoriesTable transformationMemories =
      $TransformationMemoriesTable(this);
  late final $CachedDietPlansTable cachedDietPlans = $CachedDietPlansTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    waterLogs,
    syncQueueItems,
    deadLetterQueueItems,
    dailyIntelligencePackages,
    aICacheEntries,
    transformationMemories,
    cachedDietPlans,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      Value<String?> name,
      Value<String?> email,
      Value<int?> age,
      Value<String?> gender,
      Value<double?> weight,
      Value<double?> height,
      Value<String?> activityLevel,
      Value<String?> goals,
      Value<double?> targetWeight,
      Value<int?> dailyCalorieTarget,
      Value<String?> dosha,
      Value<String?> currentProgram,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<String?> email,
      Value<int?> age,
      Value<String?> gender,
      Value<double?> weight,
      Value<double?> height,
      Value<String?> activityLevel,
      Value<String?> goals,
      Value<double?> targetWeight,
      Value<int?> dailyCalorieTarget,
      Value<String?> dosha,
      Value<String?> currentProgram,
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

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
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

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyCalorieTarget => $composableBuilder(
    column: $table.dailyCalorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosha => $composableBuilder(
    column: $table.dosha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentProgram => $composableBuilder(
    column: $table.currentProgram,
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

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
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

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyCalorieTarget => $composableBuilder(
    column: $table.dailyCalorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosha => $composableBuilder(
    column: $table.dosha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentProgram => $composableBuilder(
    column: $table.currentProgram,
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

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyCalorieTarget => $composableBuilder(
    column: $table.dailyCalorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosha =>
      $composableBuilder(column: $table.dosha, builder: (column) => column);

  GeneratedColumn<String> get currentProgram => $composableBuilder(
    column: $table.currentProgram,
    builder: (column) => column,
  );
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
                Value<String?> gender = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<double?> targetWeight = const Value.absent(),
                Value<int?> dailyCalorieTarget = const Value.absent(),
                Value<String?> dosha = const Value.absent(),
                Value<String?> currentProgram = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                age: age,
                gender: gender,
                weight: weight,
                height: height,
                activityLevel: activityLevel,
                goals: goals,
                targetWeight: targetWeight,
                dailyCalorieTarget: dailyCalorieTarget,
                dosha: dosha,
                currentProgram: currentProgram,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<double?> height = const Value.absent(),
                Value<String?> activityLevel = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<double?> targetWeight = const Value.absent(),
                Value<int?> dailyCalorieTarget = const Value.absent(),
                Value<String?> dosha = const Value.absent(),
                Value<String?> currentProgram = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                age: age,
                gender: gender,
                weight: weight,
                height: height,
                activityLevel: activityLevel,
                goals: goals,
                targetWeight: targetWeight,
                dailyCalorieTarget: dailyCalorieTarget,
                dosha: dosha,
                currentProgram: currentProgram,
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
typedef $$DailyIntelligencePackagesTableCreateCompanionBuilder =
    DailyIntelligencePackagesCompanion Function({
      required String localId,
      required String userId,
      required DateTime packageDate,
      required String primaryInsight,
      required String todaysMission,
      required String nutritionFocus,
      required String recoveryFocus,
      required String motivationMessage,
      required int adjustedCalories,
      required int adjustedProtein,
      required double adjustedHydrationL,
      required String recommendedIntensity,
      Value<bool> isRestDay,
      required String activeRisks,
      Value<bool> showFestivalBanner,
      Value<String?> festivalAdaptation,
      Value<bool> dietBreakActive,
      Value<int> proteinTimingTarget,
      Value<String> loggingReliabilityStatus,
      Value<int> satietyTargetScore,
      Value<int> aiCallsUsed,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DailyIntelligencePackagesTableUpdateCompanionBuilder =
    DailyIntelligencePackagesCompanion Function({
      Value<String> localId,
      Value<String> userId,
      Value<DateTime> packageDate,
      Value<String> primaryInsight,
      Value<String> todaysMission,
      Value<String> nutritionFocus,
      Value<String> recoveryFocus,
      Value<String> motivationMessage,
      Value<int> adjustedCalories,
      Value<int> adjustedProtein,
      Value<double> adjustedHydrationL,
      Value<String> recommendedIntensity,
      Value<bool> isRestDay,
      Value<String> activeRisks,
      Value<bool> showFestivalBanner,
      Value<String?> festivalAdaptation,
      Value<bool> dietBreakActive,
      Value<int> proteinTimingTarget,
      Value<String> loggingReliabilityStatus,
      Value<int> satietyTargetScore,
      Value<int> aiCallsUsed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DailyIntelligencePackagesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyIntelligencePackagesTable> {
  $$DailyIntelligencePackagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get packageDate => $composableBuilder(
    column: $table.packageDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryInsight => $composableBuilder(
    column: $table.primaryInsight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get todaysMission => $composableBuilder(
    column: $table.todaysMission,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutritionFocus => $composableBuilder(
    column: $table.nutritionFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recoveryFocus => $composableBuilder(
    column: $table.recoveryFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivationMessage => $composableBuilder(
    column: $table.motivationMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adjustedCalories => $composableBuilder(
    column: $table.adjustedCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get adjustedProtein => $composableBuilder(
    column: $table.adjustedProtein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get adjustedHydrationL => $composableBuilder(
    column: $table.adjustedHydrationL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendedIntensity => $composableBuilder(
    column: $table.recommendedIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRestDay => $composableBuilder(
    column: $table.isRestDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeRisks => $composableBuilder(
    column: $table.activeRisks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showFestivalBanner => $composableBuilder(
    column: $table.showFestivalBanner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get festivalAdaptation => $composableBuilder(
    column: $table.festivalAdaptation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dietBreakActive => $composableBuilder(
    column: $table.dietBreakActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proteinTimingTarget => $composableBuilder(
    column: $table.proteinTimingTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loggingReliabilityStatus => $composableBuilder(
    column: $table.loggingReliabilityStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get satietyTargetScore => $composableBuilder(
    column: $table.satietyTargetScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aiCallsUsed => $composableBuilder(
    column: $table.aiCallsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyIntelligencePackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyIntelligencePackagesTable> {
  $$DailyIntelligencePackagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get packageDate => $composableBuilder(
    column: $table.packageDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryInsight => $composableBuilder(
    column: $table.primaryInsight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get todaysMission => $composableBuilder(
    column: $table.todaysMission,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutritionFocus => $composableBuilder(
    column: $table.nutritionFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recoveryFocus => $composableBuilder(
    column: $table.recoveryFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivationMessage => $composableBuilder(
    column: $table.motivationMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adjustedCalories => $composableBuilder(
    column: $table.adjustedCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get adjustedProtein => $composableBuilder(
    column: $table.adjustedProtein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get adjustedHydrationL => $composableBuilder(
    column: $table.adjustedHydrationL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendedIntensity => $composableBuilder(
    column: $table.recommendedIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRestDay => $composableBuilder(
    column: $table.isRestDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeRisks => $composableBuilder(
    column: $table.activeRisks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showFestivalBanner => $composableBuilder(
    column: $table.showFestivalBanner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get festivalAdaptation => $composableBuilder(
    column: $table.festivalAdaptation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dietBreakActive => $composableBuilder(
    column: $table.dietBreakActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proteinTimingTarget => $composableBuilder(
    column: $table.proteinTimingTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loggingReliabilityStatus => $composableBuilder(
    column: $table.loggingReliabilityStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get satietyTargetScore => $composableBuilder(
    column: $table.satietyTargetScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aiCallsUsed => $composableBuilder(
    column: $table.aiCallsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyIntelligencePackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyIntelligencePackagesTable> {
  $$DailyIntelligencePackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get packageDate => $composableBuilder(
    column: $table.packageDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryInsight => $composableBuilder(
    column: $table.primaryInsight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get todaysMission => $composableBuilder(
    column: $table.todaysMission,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nutritionFocus => $composableBuilder(
    column: $table.nutritionFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recoveryFocus => $composableBuilder(
    column: $table.recoveryFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motivationMessage => $composableBuilder(
    column: $table.motivationMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get adjustedCalories => $composableBuilder(
    column: $table.adjustedCalories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get adjustedProtein => $composableBuilder(
    column: $table.adjustedProtein,
    builder: (column) => column,
  );

  GeneratedColumn<double> get adjustedHydrationL => $composableBuilder(
    column: $table.adjustedHydrationL,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendedIntensity => $composableBuilder(
    column: $table.recommendedIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRestDay =>
      $composableBuilder(column: $table.isRestDay, builder: (column) => column);

  GeneratedColumn<String> get activeRisks => $composableBuilder(
    column: $table.activeRisks,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showFestivalBanner => $composableBuilder(
    column: $table.showFestivalBanner,
    builder: (column) => column,
  );

  GeneratedColumn<String> get festivalAdaptation => $composableBuilder(
    column: $table.festivalAdaptation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dietBreakActive => $composableBuilder(
    column: $table.dietBreakActive,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proteinTimingTarget => $composableBuilder(
    column: $table.proteinTimingTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loggingReliabilityStatus => $composableBuilder(
    column: $table.loggingReliabilityStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get satietyTargetScore => $composableBuilder(
    column: $table.satietyTargetScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get aiCallsUsed => $composableBuilder(
    column: $table.aiCallsUsed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyIntelligencePackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyIntelligencePackagesTable,
          DailyIntelligencePackage,
          $$DailyIntelligencePackagesTableFilterComposer,
          $$DailyIntelligencePackagesTableOrderingComposer,
          $$DailyIntelligencePackagesTableAnnotationComposer,
          $$DailyIntelligencePackagesTableCreateCompanionBuilder,
          $$DailyIntelligencePackagesTableUpdateCompanionBuilder,
          (
            DailyIntelligencePackage,
            BaseReferences<
              _$AppDatabase,
              $DailyIntelligencePackagesTable,
              DailyIntelligencePackage
            >,
          ),
          DailyIntelligencePackage,
          PrefetchHooks Function()
        > {
  $$DailyIntelligencePackagesTableTableManager(
    _$AppDatabase db,
    $DailyIntelligencePackagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyIntelligencePackagesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DailyIntelligencePackagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyIntelligencePackagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> packageDate = const Value.absent(),
                Value<String> primaryInsight = const Value.absent(),
                Value<String> todaysMission = const Value.absent(),
                Value<String> nutritionFocus = const Value.absent(),
                Value<String> recoveryFocus = const Value.absent(),
                Value<String> motivationMessage = const Value.absent(),
                Value<int> adjustedCalories = const Value.absent(),
                Value<int> adjustedProtein = const Value.absent(),
                Value<double> adjustedHydrationL = const Value.absent(),
                Value<String> recommendedIntensity = const Value.absent(),
                Value<bool> isRestDay = const Value.absent(),
                Value<String> activeRisks = const Value.absent(),
                Value<bool> showFestivalBanner = const Value.absent(),
                Value<String?> festivalAdaptation = const Value.absent(),
                Value<bool> dietBreakActive = const Value.absent(),
                Value<int> proteinTimingTarget = const Value.absent(),
                Value<String> loggingReliabilityStatus = const Value.absent(),
                Value<int> satietyTargetScore = const Value.absent(),
                Value<int> aiCallsUsed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyIntelligencePackagesCompanion(
                localId: localId,
                userId: userId,
                packageDate: packageDate,
                primaryInsight: primaryInsight,
                todaysMission: todaysMission,
                nutritionFocus: nutritionFocus,
                recoveryFocus: recoveryFocus,
                motivationMessage: motivationMessage,
                adjustedCalories: adjustedCalories,
                adjustedProtein: adjustedProtein,
                adjustedHydrationL: adjustedHydrationL,
                recommendedIntensity: recommendedIntensity,
                isRestDay: isRestDay,
                activeRisks: activeRisks,
                showFestivalBanner: showFestivalBanner,
                festivalAdaptation: festivalAdaptation,
                dietBreakActive: dietBreakActive,
                proteinTimingTarget: proteinTimingTarget,
                loggingReliabilityStatus: loggingReliabilityStatus,
                satietyTargetScore: satietyTargetScore,
                aiCallsUsed: aiCallsUsed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String userId,
                required DateTime packageDate,
                required String primaryInsight,
                required String todaysMission,
                required String nutritionFocus,
                required String recoveryFocus,
                required String motivationMessage,
                required int adjustedCalories,
                required int adjustedProtein,
                required double adjustedHydrationL,
                required String recommendedIntensity,
                Value<bool> isRestDay = const Value.absent(),
                required String activeRisks,
                Value<bool> showFestivalBanner = const Value.absent(),
                Value<String?> festivalAdaptation = const Value.absent(),
                Value<bool> dietBreakActive = const Value.absent(),
                Value<int> proteinTimingTarget = const Value.absent(),
                Value<String> loggingReliabilityStatus = const Value.absent(),
                Value<int> satietyTargetScore = const Value.absent(),
                Value<int> aiCallsUsed = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyIntelligencePackagesCompanion.insert(
                localId: localId,
                userId: userId,
                packageDate: packageDate,
                primaryInsight: primaryInsight,
                todaysMission: todaysMission,
                nutritionFocus: nutritionFocus,
                recoveryFocus: recoveryFocus,
                motivationMessage: motivationMessage,
                adjustedCalories: adjustedCalories,
                adjustedProtein: adjustedProtein,
                adjustedHydrationL: adjustedHydrationL,
                recommendedIntensity: recommendedIntensity,
                isRestDay: isRestDay,
                activeRisks: activeRisks,
                showFestivalBanner: showFestivalBanner,
                festivalAdaptation: festivalAdaptation,
                dietBreakActive: dietBreakActive,
                proteinTimingTarget: proteinTimingTarget,
                loggingReliabilityStatus: loggingReliabilityStatus,
                satietyTargetScore: satietyTargetScore,
                aiCallsUsed: aiCallsUsed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyIntelligencePackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyIntelligencePackagesTable,
      DailyIntelligencePackage,
      $$DailyIntelligencePackagesTableFilterComposer,
      $$DailyIntelligencePackagesTableOrderingComposer,
      $$DailyIntelligencePackagesTableAnnotationComposer,
      $$DailyIntelligencePackagesTableCreateCompanionBuilder,
      $$DailyIntelligencePackagesTableUpdateCompanionBuilder,
      (
        DailyIntelligencePackage,
        BaseReferences<
          _$AppDatabase,
          $DailyIntelligencePackagesTable,
          DailyIntelligencePackage
        >,
      ),
      DailyIntelligencePackage,
      PrefetchHooks Function()
    >;
typedef $$AICacheEntriesTableCreateCompanionBuilder =
    AICacheEntriesCompanion Function({
      required String userId,
      required String promptHash,
      required String response,
      required DateTime expiresAt,
      Value<int> rowid,
    });
typedef $$AICacheEntriesTableUpdateCompanionBuilder =
    AICacheEntriesCompanion Function({
      Value<String> userId,
      Value<String> promptHash,
      Value<String> response,
      Value<DateTime> expiresAt,
      Value<int> rowid,
    });

class $$AICacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AICacheEntriesTable> {
  $$AICacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptHash => $composableBuilder(
    column: $table.promptHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get response => $composableBuilder(
    column: $table.response,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AICacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AICacheEntriesTable> {
  $$AICacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptHash => $composableBuilder(
    column: $table.promptHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get response => $composableBuilder(
    column: $table.response,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AICacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AICacheEntriesTable> {
  $$AICacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get promptHash => $composableBuilder(
    column: $table.promptHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get response =>
      $composableBuilder(column: $table.response, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$AICacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AICacheEntriesTable,
          AICacheEntry,
          $$AICacheEntriesTableFilterComposer,
          $$AICacheEntriesTableOrderingComposer,
          $$AICacheEntriesTableAnnotationComposer,
          $$AICacheEntriesTableCreateCompanionBuilder,
          $$AICacheEntriesTableUpdateCompanionBuilder,
          (
            AICacheEntry,
            BaseReferences<_$AppDatabase, $AICacheEntriesTable, AICacheEntry>,
          ),
          AICacheEntry,
          PrefetchHooks Function()
        > {
  $$AICacheEntriesTableTableManager(
    _$AppDatabase db,
    $AICacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AICacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AICacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AICacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> promptHash = const Value.absent(),
                Value<String> response = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AICacheEntriesCompanion(
                userId: userId,
                promptHash: promptHash,
                response: response,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String promptHash,
                required String response,
                required DateTime expiresAt,
                Value<int> rowid = const Value.absent(),
              }) => AICacheEntriesCompanion.insert(
                userId: userId,
                promptHash: promptHash,
                response: response,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AICacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AICacheEntriesTable,
      AICacheEntry,
      $$AICacheEntriesTableFilterComposer,
      $$AICacheEntriesTableOrderingComposer,
      $$AICacheEntriesTableAnnotationComposer,
      $$AICacheEntriesTableCreateCompanionBuilder,
      $$AICacheEntriesTableUpdateCompanionBuilder,
      (
        AICacheEntry,
        BaseReferences<_$AppDatabase, $AICacheEntriesTable, AICacheEntry>,
      ),
      AICacheEntry,
      PrefetchHooks Function()
    >;
typedef $$TransformationMemoriesTableCreateCompanionBuilder =
    TransformationMemoriesCompanion Function({
      required String localId,
      required String userId,
      required String weightHistoryJson,
      required String majorStruggles,
      required String injuriesJson,
      required String successPatterns,
      required String motivationTriggers,
      required String primaryPersonality,
      required String conversationSummary,
      required DateTime lastUpdated,
      required String syncStatus,
      Value<int> rowid,
    });
typedef $$TransformationMemoriesTableUpdateCompanionBuilder =
    TransformationMemoriesCompanion Function({
      Value<String> localId,
      Value<String> userId,
      Value<String> weightHistoryJson,
      Value<String> majorStruggles,
      Value<String> injuriesJson,
      Value<String> successPatterns,
      Value<String> motivationTriggers,
      Value<String> primaryPersonality,
      Value<String> conversationSummary,
      Value<DateTime> lastUpdated,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$TransformationMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $TransformationMemoriesTable> {
  $$TransformationMemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightHistoryJson => $composableBuilder(
    column: $table.weightHistoryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get majorStruggles => $composableBuilder(
    column: $table.majorStruggles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get successPatterns => $composableBuilder(
    column: $table.successPatterns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivationTriggers => $composableBuilder(
    column: $table.motivationTriggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryPersonality => $composableBuilder(
    column: $table.primaryPersonality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationSummary => $composableBuilder(
    column: $table.conversationSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransformationMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransformationMemoriesTable> {
  $$TransformationMemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightHistoryJson => $composableBuilder(
    column: $table.weightHistoryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get majorStruggles => $composableBuilder(
    column: $table.majorStruggles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get successPatterns => $composableBuilder(
    column: $table.successPatterns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivationTriggers => $composableBuilder(
    column: $table.motivationTriggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryPersonality => $composableBuilder(
    column: $table.primaryPersonality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationSummary => $composableBuilder(
    column: $table.conversationSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransformationMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransformationMemoriesTable> {
  $$TransformationMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get weightHistoryJson => $composableBuilder(
    column: $table.weightHistoryJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get majorStruggles => $composableBuilder(
    column: $table.majorStruggles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get injuriesJson => $composableBuilder(
    column: $table.injuriesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get successPatterns => $composableBuilder(
    column: $table.successPatterns,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motivationTriggers => $composableBuilder(
    column: $table.motivationTriggers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryPersonality => $composableBuilder(
    column: $table.primaryPersonality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conversationSummary => $composableBuilder(
    column: $table.conversationSummary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$TransformationMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransformationMemoriesTable,
          TransformationMemory,
          $$TransformationMemoriesTableFilterComposer,
          $$TransformationMemoriesTableOrderingComposer,
          $$TransformationMemoriesTableAnnotationComposer,
          $$TransformationMemoriesTableCreateCompanionBuilder,
          $$TransformationMemoriesTableUpdateCompanionBuilder,
          (
            TransformationMemory,
            BaseReferences<
              _$AppDatabase,
              $TransformationMemoriesTable,
              TransformationMemory
            >,
          ),
          TransformationMemory,
          PrefetchHooks Function()
        > {
  $$TransformationMemoriesTableTableManager(
    _$AppDatabase db,
    $TransformationMemoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransformationMemoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransformationMemoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransformationMemoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> weightHistoryJson = const Value.absent(),
                Value<String> majorStruggles = const Value.absent(),
                Value<String> injuriesJson = const Value.absent(),
                Value<String> successPatterns = const Value.absent(),
                Value<String> motivationTriggers = const Value.absent(),
                Value<String> primaryPersonality = const Value.absent(),
                Value<String> conversationSummary = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransformationMemoriesCompanion(
                localId: localId,
                userId: userId,
                weightHistoryJson: weightHistoryJson,
                majorStruggles: majorStruggles,
                injuriesJson: injuriesJson,
                successPatterns: successPatterns,
                motivationTriggers: motivationTriggers,
                primaryPersonality: primaryPersonality,
                conversationSummary: conversationSummary,
                lastUpdated: lastUpdated,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String userId,
                required String weightHistoryJson,
                required String majorStruggles,
                required String injuriesJson,
                required String successPatterns,
                required String motivationTriggers,
                required String primaryPersonality,
                required String conversationSummary,
                required DateTime lastUpdated,
                required String syncStatus,
                Value<int> rowid = const Value.absent(),
              }) => TransformationMemoriesCompanion.insert(
                localId: localId,
                userId: userId,
                weightHistoryJson: weightHistoryJson,
                majorStruggles: majorStruggles,
                injuriesJson: injuriesJson,
                successPatterns: successPatterns,
                motivationTriggers: motivationTriggers,
                primaryPersonality: primaryPersonality,
                conversationSummary: conversationSummary,
                lastUpdated: lastUpdated,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransformationMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransformationMemoriesTable,
      TransformationMemory,
      $$TransformationMemoriesTableFilterComposer,
      $$TransformationMemoriesTableOrderingComposer,
      $$TransformationMemoriesTableAnnotationComposer,
      $$TransformationMemoriesTableCreateCompanionBuilder,
      $$TransformationMemoriesTableUpdateCompanionBuilder,
      (
        TransformationMemory,
        BaseReferences<
          _$AppDatabase,
          $TransformationMemoriesTable,
          TransformationMemory
        >,
      ),
      TransformationMemory,
      PrefetchHooks Function()
    >;
typedef $$CachedDietPlansTableCreateCompanionBuilder =
    CachedDietPlansCompanion Function({
      required String userId,
      required String planJson,
      required int calorieTarget,
      required int proteinTargetG,
      Value<bool> isAiGenerated,
      required DateTime generatedAt,
      required DateTime expiresAt,
      Value<int> rowid,
    });
typedef $$CachedDietPlansTableUpdateCompanionBuilder =
    CachedDietPlansCompanion Function({
      Value<String> userId,
      Value<String> planJson,
      Value<int> calorieTarget,
      Value<int> proteinTargetG,
      Value<bool> isAiGenerated,
      Value<DateTime> generatedAt,
      Value<DateTime> expiresAt,
      Value<int> rowid,
    });

class $$CachedDietPlansTableFilterComposer
    extends Composer<_$AppDatabase, $CachedDietPlansTable> {
  $$CachedDietPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planJson => $composableBuilder(
    column: $table.planJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAiGenerated => $composableBuilder(
    column: $table.isAiGenerated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDietPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedDietPlansTable> {
  $$CachedDietPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planJson => $composableBuilder(
    column: $table.planJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAiGenerated => $composableBuilder(
    column: $table.isAiGenerated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDietPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedDietPlansTable> {
  $$CachedDietPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get planJson =>
      $composableBuilder(column: $table.planJson, builder: (column) => column);

  GeneratedColumn<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAiGenerated => $composableBuilder(
    column: $table.isAiGenerated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$CachedDietPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedDietPlansTable,
          CachedDietPlan,
          $$CachedDietPlansTableFilterComposer,
          $$CachedDietPlansTableOrderingComposer,
          $$CachedDietPlansTableAnnotationComposer,
          $$CachedDietPlansTableCreateCompanionBuilder,
          $$CachedDietPlansTableUpdateCompanionBuilder,
          (
            CachedDietPlan,
            BaseReferences<
              _$AppDatabase,
              $CachedDietPlansTable,
              CachedDietPlan
            >,
          ),
          CachedDietPlan,
          PrefetchHooks Function()
        > {
  $$CachedDietPlansTableTableManager(
    _$AppDatabase db,
    $CachedDietPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDietPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDietPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDietPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> planJson = const Value.absent(),
                Value<int> calorieTarget = const Value.absent(),
                Value<int> proteinTargetG = const Value.absent(),
                Value<bool> isAiGenerated = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDietPlansCompanion(
                userId: userId,
                planJson: planJson,
                calorieTarget: calorieTarget,
                proteinTargetG: proteinTargetG,
                isAiGenerated: isAiGenerated,
                generatedAt: generatedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String planJson,
                required int calorieTarget,
                required int proteinTargetG,
                Value<bool> isAiGenerated = const Value.absent(),
                required DateTime generatedAt,
                required DateTime expiresAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedDietPlansCompanion.insert(
                userId: userId,
                planJson: planJson,
                calorieTarget: calorieTarget,
                proteinTargetG: proteinTargetG,
                isAiGenerated: isAiGenerated,
                generatedAt: generatedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDietPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedDietPlansTable,
      CachedDietPlan,
      $$CachedDietPlansTableFilterComposer,
      $$CachedDietPlansTableOrderingComposer,
      $$CachedDietPlansTableAnnotationComposer,
      $$CachedDietPlansTableCreateCompanionBuilder,
      $$CachedDietPlansTableUpdateCompanionBuilder,
      (
        CachedDietPlan,
        BaseReferences<_$AppDatabase, $CachedDietPlansTable, CachedDietPlan>,
      ),
      CachedDietPlan,
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
  $$DailyIntelligencePackagesTableTableManager get dailyIntelligencePackages =>
      $$DailyIntelligencePackagesTableTableManager(
        _db,
        _db.dailyIntelligencePackages,
      );
  $$AICacheEntriesTableTableManager get aICacheEntries =>
      $$AICacheEntriesTableTableManager(_db, _db.aICacheEntries);
  $$TransformationMemoriesTableTableManager get transformationMemories =>
      $$TransformationMemoriesTableTableManager(
        _db,
        _db.transformationMemories,
      );
  $$CachedDietPlansTableTableManager get cachedDietPlans =>
      $$CachedDietPlansTableTableManager(_db, _db.cachedDietPlans);
}
