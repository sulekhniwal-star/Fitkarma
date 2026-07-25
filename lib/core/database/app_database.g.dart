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
  static const VerificationMeta _isCycleTrackingEnabledMeta =
      const VerificationMeta('isCycleTrackingEnabled');
  @override
  late final GeneratedColumn<bool> isCycleTrackingEnabled =
      GeneratedColumn<bool>(
        'is_cycle_tracking_enabled',
        aliasedName,
        true,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_cycle_tracking_enabled" IN (0, 1))',
        ),
      );
  static const VerificationMeta _averageCycleLengthMeta =
      const VerificationMeta('averageCycleLength');
  @override
  late final GeneratedColumn<int> averageCycleLength = GeneratedColumn<int>(
    'average_cycle_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPeriodDateMeta = const VerificationMeta(
    'lastPeriodDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastPeriodDate =
      GeneratedColumn<DateTime>(
        'last_period_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _subscriptionTierMeta = const VerificationMeta(
    'subscriptionTier',
  );
  @override
  late final GeneratedColumn<String> subscriptionTier = GeneratedColumn<String>(
    'subscription_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  static const VerificationMeta _monthlyGroceryBudgetInrMeta =
      const VerificationMeta('monthlyGroceryBudgetInr');
  @override
  late final GeneratedColumn<double> monthlyGroceryBudgetInr =
      GeneratedColumn<double>(
        'monthly_grocery_budget_inr',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3000.0),
      );
  static const VerificationMeta _nutritionPeriodizationPhaseMeta =
      const VerificationMeta('nutritionPeriodizationPhase');
  @override
  late final GeneratedColumn<String> nutritionPeriodizationPhase =
      GeneratedColumn<String>(
        'nutrition_periodization_phase',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('maintenance'),
      );
  static const VerificationMeta _periodizationPhaseStartedAtMeta =
      const VerificationMeta('periodizationPhaseStartedAt');
  @override
  late final GeneratedColumn<DateTime> periodizationPhaseStartedAt =
      GeneratedColumn<DateTime>(
        'periodization_phase_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timezoneOffsetMinutesMeta =
      const VerificationMeta('timezoneOffsetMinutes');
  @override
  late final GeneratedColumn<int> timezoneOffsetMinutes = GeneratedColumn<int>(
    'timezone_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(330),
  );
  static const VerificationMeta _preferredDIPHourMeta = const VerificationMeta(
    'preferredDIPHour',
  );
  @override
  late final GeneratedColumn<int> preferredDIPHour = GeneratedColumn<int>(
    'preferred_d_i_p_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(6),
  );
  static const VerificationMeta _whatsAppOptInMeta = const VerificationMeta(
    'whatsAppOptIn',
  );
  @override
  late final GeneratedColumn<bool> whatsAppOptIn = GeneratedColumn<bool>(
    'whats_app_opt_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("whats_app_opt_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _abhaHealthIdMeta = const VerificationMeta(
    'abhaHealthId',
  );
  @override
  late final GeneratedColumn<String> abhaHealthId = GeneratedColumn<String>(
    'abha_health_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredInputLanguageMeta =
      const VerificationMeta('preferredInputLanguage');
  @override
  late final GeneratedColumn<String> preferredInputLanguage =
      GeneratedColumn<String>(
        'preferred_input_language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('en'),
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
    isCycleTrackingEnabled,
    averageCycleLength,
    lastPeriodDate,
    subscriptionTier,
    monthlyGroceryBudgetInr,
    nutritionPeriodizationPhase,
    periodizationPhaseStartedAt,
    timezoneOffsetMinutes,
    preferredDIPHour,
    whatsAppOptIn,
    abhaHealthId,
    preferredInputLanguage,
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
    if (data.containsKey('is_cycle_tracking_enabled')) {
      context.handle(
        _isCycleTrackingEnabledMeta,
        isCycleTrackingEnabled.isAcceptableOrUnknown(
          data['is_cycle_tracking_enabled']!,
          _isCycleTrackingEnabledMeta,
        ),
      );
    }
    if (data.containsKey('average_cycle_length')) {
      context.handle(
        _averageCycleLengthMeta,
        averageCycleLength.isAcceptableOrUnknown(
          data['average_cycle_length']!,
          _averageCycleLengthMeta,
        ),
      );
    }
    if (data.containsKey('last_period_date')) {
      context.handle(
        _lastPeriodDateMeta,
        lastPeriodDate.isAcceptableOrUnknown(
          data['last_period_date']!,
          _lastPeriodDateMeta,
        ),
      );
    }
    if (data.containsKey('subscription_tier')) {
      context.handle(
        _subscriptionTierMeta,
        subscriptionTier.isAcceptableOrUnknown(
          data['subscription_tier']!,
          _subscriptionTierMeta,
        ),
      );
    }
    if (data.containsKey('monthly_grocery_budget_inr')) {
      context.handle(
        _monthlyGroceryBudgetInrMeta,
        monthlyGroceryBudgetInr.isAcceptableOrUnknown(
          data['monthly_grocery_budget_inr']!,
          _monthlyGroceryBudgetInrMeta,
        ),
      );
    }
    if (data.containsKey('nutrition_periodization_phase')) {
      context.handle(
        _nutritionPeriodizationPhaseMeta,
        nutritionPeriodizationPhase.isAcceptableOrUnknown(
          data['nutrition_periodization_phase']!,
          _nutritionPeriodizationPhaseMeta,
        ),
      );
    }
    if (data.containsKey('periodization_phase_started_at')) {
      context.handle(
        _periodizationPhaseStartedAtMeta,
        periodizationPhaseStartedAt.isAcceptableOrUnknown(
          data['periodization_phase_started_at']!,
          _periodizationPhaseStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('timezone_offset_minutes')) {
      context.handle(
        _timezoneOffsetMinutesMeta,
        timezoneOffsetMinutes.isAcceptableOrUnknown(
          data['timezone_offset_minutes']!,
          _timezoneOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('preferred_d_i_p_hour')) {
      context.handle(
        _preferredDIPHourMeta,
        preferredDIPHour.isAcceptableOrUnknown(
          data['preferred_d_i_p_hour']!,
          _preferredDIPHourMeta,
        ),
      );
    }
    if (data.containsKey('whats_app_opt_in')) {
      context.handle(
        _whatsAppOptInMeta,
        whatsAppOptIn.isAcceptableOrUnknown(
          data['whats_app_opt_in']!,
          _whatsAppOptInMeta,
        ),
      );
    }
    if (data.containsKey('abha_health_id')) {
      context.handle(
        _abhaHealthIdMeta,
        abhaHealthId.isAcceptableOrUnknown(
          data['abha_health_id']!,
          _abhaHealthIdMeta,
        ),
      );
    }
    if (data.containsKey('preferred_input_language')) {
      context.handle(
        _preferredInputLanguageMeta,
        preferredInputLanguage.isAcceptableOrUnknown(
          data['preferred_input_language']!,
          _preferredInputLanguageMeta,
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
      isCycleTrackingEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_cycle_tracking_enabled'],
      ),
      averageCycleLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_cycle_length'],
      ),
      lastPeriodDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_period_date'],
      ),
      subscriptionTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_tier'],
      )!,
      monthlyGroceryBudgetInr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_grocery_budget_inr'],
      )!,
      nutritionPeriodizationPhase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrition_periodization_phase'],
      )!,
      periodizationPhaseStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}periodization_phase_started_at'],
      ),
      timezoneOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timezone_offset_minutes'],
      )!,
      preferredDIPHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preferred_d_i_p_hour'],
      )!,
      whatsAppOptIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}whats_app_opt_in'],
      )!,
      abhaHealthId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abha_health_id'],
      ),
      preferredInputLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_input_language'],
      )!,
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
  final bool? isCycleTrackingEnabled;
  final int? averageCycleLength;
  final DateTime? lastPeriodDate;
  final String subscriptionTier;
  final double monthlyGroceryBudgetInr;
  final String nutritionPeriodizationPhase;
  final DateTime? periodizationPhaseStartedAt;
  final int timezoneOffsetMinutes;
  final int preferredDIPHour;
  final bool whatsAppOptIn;
  final String? abhaHealthId;
  final String preferredInputLanguage;
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
    this.isCycleTrackingEnabled,
    this.averageCycleLength,
    this.lastPeriodDate,
    required this.subscriptionTier,
    required this.monthlyGroceryBudgetInr,
    required this.nutritionPeriodizationPhase,
    this.periodizationPhaseStartedAt,
    required this.timezoneOffsetMinutes,
    required this.preferredDIPHour,
    required this.whatsAppOptIn,
    this.abhaHealthId,
    required this.preferredInputLanguage,
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
    if (!nullToAbsent || isCycleTrackingEnabled != null) {
      map['is_cycle_tracking_enabled'] = Variable<bool>(isCycleTrackingEnabled);
    }
    if (!nullToAbsent || averageCycleLength != null) {
      map['average_cycle_length'] = Variable<int>(averageCycleLength);
    }
    if (!nullToAbsent || lastPeriodDate != null) {
      map['last_period_date'] = Variable<DateTime>(lastPeriodDate);
    }
    map['subscription_tier'] = Variable<String>(subscriptionTier);
    map['monthly_grocery_budget_inr'] = Variable<double>(
      monthlyGroceryBudgetInr,
    );
    map['nutrition_periodization_phase'] = Variable<String>(
      nutritionPeriodizationPhase,
    );
    if (!nullToAbsent || periodizationPhaseStartedAt != null) {
      map['periodization_phase_started_at'] = Variable<DateTime>(
        periodizationPhaseStartedAt,
      );
    }
    map['timezone_offset_minutes'] = Variable<int>(timezoneOffsetMinutes);
    map['preferred_d_i_p_hour'] = Variable<int>(preferredDIPHour);
    map['whats_app_opt_in'] = Variable<bool>(whatsAppOptIn);
    if (!nullToAbsent || abhaHealthId != null) {
      map['abha_health_id'] = Variable<String>(abhaHealthId);
    }
    map['preferred_input_language'] = Variable<String>(preferredInputLanguage);
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
      isCycleTrackingEnabled: isCycleTrackingEnabled == null && nullToAbsent
          ? const Value.absent()
          : Value(isCycleTrackingEnabled),
      averageCycleLength: averageCycleLength == null && nullToAbsent
          ? const Value.absent()
          : Value(averageCycleLength),
      lastPeriodDate: lastPeriodDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPeriodDate),
      subscriptionTier: Value(subscriptionTier),
      monthlyGroceryBudgetInr: Value(monthlyGroceryBudgetInr),
      nutritionPeriodizationPhase: Value(nutritionPeriodizationPhase),
      periodizationPhaseStartedAt:
          periodizationPhaseStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(periodizationPhaseStartedAt),
      timezoneOffsetMinutes: Value(timezoneOffsetMinutes),
      preferredDIPHour: Value(preferredDIPHour),
      whatsAppOptIn: Value(whatsAppOptIn),
      abhaHealthId: abhaHealthId == null && nullToAbsent
          ? const Value.absent()
          : Value(abhaHealthId),
      preferredInputLanguage: Value(preferredInputLanguage),
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
      isCycleTrackingEnabled: serializer.fromJson<bool?>(
        json['isCycleTrackingEnabled'],
      ),
      averageCycleLength: serializer.fromJson<int?>(json['averageCycleLength']),
      lastPeriodDate: serializer.fromJson<DateTime?>(json['lastPeriodDate']),
      subscriptionTier: serializer.fromJson<String>(json['subscriptionTier']),
      monthlyGroceryBudgetInr: serializer.fromJson<double>(
        json['monthlyGroceryBudgetInr'],
      ),
      nutritionPeriodizationPhase: serializer.fromJson<String>(
        json['nutritionPeriodizationPhase'],
      ),
      periodizationPhaseStartedAt: serializer.fromJson<DateTime?>(
        json['periodizationPhaseStartedAt'],
      ),
      timezoneOffsetMinutes: serializer.fromJson<int>(
        json['timezoneOffsetMinutes'],
      ),
      preferredDIPHour: serializer.fromJson<int>(json['preferredDIPHour']),
      whatsAppOptIn: serializer.fromJson<bool>(json['whatsAppOptIn']),
      abhaHealthId: serializer.fromJson<String?>(json['abhaHealthId']),
      preferredInputLanguage: serializer.fromJson<String>(
        json['preferredInputLanguage'],
      ),
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
      'isCycleTrackingEnabled': serializer.toJson<bool?>(
        isCycleTrackingEnabled,
      ),
      'averageCycleLength': serializer.toJson<int?>(averageCycleLength),
      'lastPeriodDate': serializer.toJson<DateTime?>(lastPeriodDate),
      'subscriptionTier': serializer.toJson<String>(subscriptionTier),
      'monthlyGroceryBudgetInr': serializer.toJson<double>(
        monthlyGroceryBudgetInr,
      ),
      'nutritionPeriodizationPhase': serializer.toJson<String>(
        nutritionPeriodizationPhase,
      ),
      'periodizationPhaseStartedAt': serializer.toJson<DateTime?>(
        periodizationPhaseStartedAt,
      ),
      'timezoneOffsetMinutes': serializer.toJson<int>(timezoneOffsetMinutes),
      'preferredDIPHour': serializer.toJson<int>(preferredDIPHour),
      'whatsAppOptIn': serializer.toJson<bool>(whatsAppOptIn),
      'abhaHealthId': serializer.toJson<String?>(abhaHealthId),
      'preferredInputLanguage': serializer.toJson<String>(
        preferredInputLanguage,
      ),
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
    Value<bool?> isCycleTrackingEnabled = const Value.absent(),
    Value<int?> averageCycleLength = const Value.absent(),
    Value<DateTime?> lastPeriodDate = const Value.absent(),
    String? subscriptionTier,
    double? monthlyGroceryBudgetInr,
    String? nutritionPeriodizationPhase,
    Value<DateTime?> periodizationPhaseStartedAt = const Value.absent(),
    int? timezoneOffsetMinutes,
    int? preferredDIPHour,
    bool? whatsAppOptIn,
    Value<String?> abhaHealthId = const Value.absent(),
    String? preferredInputLanguage,
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
    isCycleTrackingEnabled: isCycleTrackingEnabled.present
        ? isCycleTrackingEnabled.value
        : this.isCycleTrackingEnabled,
    averageCycleLength: averageCycleLength.present
        ? averageCycleLength.value
        : this.averageCycleLength,
    lastPeriodDate: lastPeriodDate.present
        ? lastPeriodDate.value
        : this.lastPeriodDate,
    subscriptionTier: subscriptionTier ?? this.subscriptionTier,
    monthlyGroceryBudgetInr:
        monthlyGroceryBudgetInr ?? this.monthlyGroceryBudgetInr,
    nutritionPeriodizationPhase:
        nutritionPeriodizationPhase ?? this.nutritionPeriodizationPhase,
    periodizationPhaseStartedAt: periodizationPhaseStartedAt.present
        ? periodizationPhaseStartedAt.value
        : this.periodizationPhaseStartedAt,
    timezoneOffsetMinutes: timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
    preferredDIPHour: preferredDIPHour ?? this.preferredDIPHour,
    whatsAppOptIn: whatsAppOptIn ?? this.whatsAppOptIn,
    abhaHealthId: abhaHealthId.present ? abhaHealthId.value : this.abhaHealthId,
    preferredInputLanguage:
        preferredInputLanguage ?? this.preferredInputLanguage,
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
      isCycleTrackingEnabled: data.isCycleTrackingEnabled.present
          ? data.isCycleTrackingEnabled.value
          : this.isCycleTrackingEnabled,
      averageCycleLength: data.averageCycleLength.present
          ? data.averageCycleLength.value
          : this.averageCycleLength,
      lastPeriodDate: data.lastPeriodDate.present
          ? data.lastPeriodDate.value
          : this.lastPeriodDate,
      subscriptionTier: data.subscriptionTier.present
          ? data.subscriptionTier.value
          : this.subscriptionTier,
      monthlyGroceryBudgetInr: data.monthlyGroceryBudgetInr.present
          ? data.monthlyGroceryBudgetInr.value
          : this.monthlyGroceryBudgetInr,
      nutritionPeriodizationPhase: data.nutritionPeriodizationPhase.present
          ? data.nutritionPeriodizationPhase.value
          : this.nutritionPeriodizationPhase,
      periodizationPhaseStartedAt: data.periodizationPhaseStartedAt.present
          ? data.periodizationPhaseStartedAt.value
          : this.periodizationPhaseStartedAt,
      timezoneOffsetMinutes: data.timezoneOffsetMinutes.present
          ? data.timezoneOffsetMinutes.value
          : this.timezoneOffsetMinutes,
      preferredDIPHour: data.preferredDIPHour.present
          ? data.preferredDIPHour.value
          : this.preferredDIPHour,
      whatsAppOptIn: data.whatsAppOptIn.present
          ? data.whatsAppOptIn.value
          : this.whatsAppOptIn,
      abhaHealthId: data.abhaHealthId.present
          ? data.abhaHealthId.value
          : this.abhaHealthId,
      preferredInputLanguage: data.preferredInputLanguage.present
          ? data.preferredInputLanguage.value
          : this.preferredInputLanguage,
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
          ..write('currentProgram: $currentProgram, ')
          ..write('isCycleTrackingEnabled: $isCycleTrackingEnabled, ')
          ..write('averageCycleLength: $averageCycleLength, ')
          ..write('lastPeriodDate: $lastPeriodDate, ')
          ..write('subscriptionTier: $subscriptionTier, ')
          ..write('monthlyGroceryBudgetInr: $monthlyGroceryBudgetInr, ')
          ..write('nutritionPeriodizationPhase: $nutritionPeriodizationPhase, ')
          ..write('periodizationPhaseStartedAt: $periodizationPhaseStartedAt, ')
          ..write('timezoneOffsetMinutes: $timezoneOffsetMinutes, ')
          ..write('preferredDIPHour: $preferredDIPHour, ')
          ..write('whatsAppOptIn: $whatsAppOptIn, ')
          ..write('abhaHealthId: $abhaHealthId, ')
          ..write('preferredInputLanguage: $preferredInputLanguage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    isCycleTrackingEnabled,
    averageCycleLength,
    lastPeriodDate,
    subscriptionTier,
    monthlyGroceryBudgetInr,
    nutritionPeriodizationPhase,
    periodizationPhaseStartedAt,
    timezoneOffsetMinutes,
    preferredDIPHour,
    whatsAppOptIn,
    abhaHealthId,
    preferredInputLanguage,
  ]);
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
          other.currentProgram == this.currentProgram &&
          other.isCycleTrackingEnabled == this.isCycleTrackingEnabled &&
          other.averageCycleLength == this.averageCycleLength &&
          other.lastPeriodDate == this.lastPeriodDate &&
          other.subscriptionTier == this.subscriptionTier &&
          other.monthlyGroceryBudgetInr == this.monthlyGroceryBudgetInr &&
          other.nutritionPeriodizationPhase ==
              this.nutritionPeriodizationPhase &&
          other.periodizationPhaseStartedAt ==
              this.periodizationPhaseStartedAt &&
          other.timezoneOffsetMinutes == this.timezoneOffsetMinutes &&
          other.preferredDIPHour == this.preferredDIPHour &&
          other.whatsAppOptIn == this.whatsAppOptIn &&
          other.abhaHealthId == this.abhaHealthId &&
          other.preferredInputLanguage == this.preferredInputLanguage);
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
  final Value<bool?> isCycleTrackingEnabled;
  final Value<int?> averageCycleLength;
  final Value<DateTime?> lastPeriodDate;
  final Value<String> subscriptionTier;
  final Value<double> monthlyGroceryBudgetInr;
  final Value<String> nutritionPeriodizationPhase;
  final Value<DateTime?> periodizationPhaseStartedAt;
  final Value<int> timezoneOffsetMinutes;
  final Value<int> preferredDIPHour;
  final Value<bool> whatsAppOptIn;
  final Value<String?> abhaHealthId;
  final Value<String> preferredInputLanguage;
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
    this.isCycleTrackingEnabled = const Value.absent(),
    this.averageCycleLength = const Value.absent(),
    this.lastPeriodDate = const Value.absent(),
    this.subscriptionTier = const Value.absent(),
    this.monthlyGroceryBudgetInr = const Value.absent(),
    this.nutritionPeriodizationPhase = const Value.absent(),
    this.periodizationPhaseStartedAt = const Value.absent(),
    this.timezoneOffsetMinutes = const Value.absent(),
    this.preferredDIPHour = const Value.absent(),
    this.whatsAppOptIn = const Value.absent(),
    this.abhaHealthId = const Value.absent(),
    this.preferredInputLanguage = const Value.absent(),
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
    this.isCycleTrackingEnabled = const Value.absent(),
    this.averageCycleLength = const Value.absent(),
    this.lastPeriodDate = const Value.absent(),
    this.subscriptionTier = const Value.absent(),
    this.monthlyGroceryBudgetInr = const Value.absent(),
    this.nutritionPeriodizationPhase = const Value.absent(),
    this.periodizationPhaseStartedAt = const Value.absent(),
    this.timezoneOffsetMinutes = const Value.absent(),
    this.preferredDIPHour = const Value.absent(),
    this.whatsAppOptIn = const Value.absent(),
    this.abhaHealthId = const Value.absent(),
    this.preferredInputLanguage = const Value.absent(),
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
    Expression<bool>? isCycleTrackingEnabled,
    Expression<int>? averageCycleLength,
    Expression<DateTime>? lastPeriodDate,
    Expression<String>? subscriptionTier,
    Expression<double>? monthlyGroceryBudgetInr,
    Expression<String>? nutritionPeriodizationPhase,
    Expression<DateTime>? periodizationPhaseStartedAt,
    Expression<int>? timezoneOffsetMinutes,
    Expression<int>? preferredDIPHour,
    Expression<bool>? whatsAppOptIn,
    Expression<String>? abhaHealthId,
    Expression<String>? preferredInputLanguage,
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
      if (isCycleTrackingEnabled != null)
        'is_cycle_tracking_enabled': isCycleTrackingEnabled,
      if (averageCycleLength != null)
        'average_cycle_length': averageCycleLength,
      if (lastPeriodDate != null) 'last_period_date': lastPeriodDate,
      if (subscriptionTier != null) 'subscription_tier': subscriptionTier,
      if (monthlyGroceryBudgetInr != null)
        'monthly_grocery_budget_inr': monthlyGroceryBudgetInr,
      if (nutritionPeriodizationPhase != null)
        'nutrition_periodization_phase': nutritionPeriodizationPhase,
      if (periodizationPhaseStartedAt != null)
        'periodization_phase_started_at': periodizationPhaseStartedAt,
      if (timezoneOffsetMinutes != null)
        'timezone_offset_minutes': timezoneOffsetMinutes,
      if (preferredDIPHour != null) 'preferred_d_i_p_hour': preferredDIPHour,
      if (whatsAppOptIn != null) 'whats_app_opt_in': whatsAppOptIn,
      if (abhaHealthId != null) 'abha_health_id': abhaHealthId,
      if (preferredInputLanguage != null)
        'preferred_input_language': preferredInputLanguage,
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
    Value<bool?>? isCycleTrackingEnabled,
    Value<int?>? averageCycleLength,
    Value<DateTime?>? lastPeriodDate,
    Value<String>? subscriptionTier,
    Value<double>? monthlyGroceryBudgetInr,
    Value<String>? nutritionPeriodizationPhase,
    Value<DateTime?>? periodizationPhaseStartedAt,
    Value<int>? timezoneOffsetMinutes,
    Value<int>? preferredDIPHour,
    Value<bool>? whatsAppOptIn,
    Value<String?>? abhaHealthId,
    Value<String>? preferredInputLanguage,
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
      isCycleTrackingEnabled:
          isCycleTrackingEnabled ?? this.isCycleTrackingEnabled,
      averageCycleLength: averageCycleLength ?? this.averageCycleLength,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      monthlyGroceryBudgetInr:
          monthlyGroceryBudgetInr ?? this.monthlyGroceryBudgetInr,
      nutritionPeriodizationPhase:
          nutritionPeriodizationPhase ?? this.nutritionPeriodizationPhase,
      periodizationPhaseStartedAt:
          periodizationPhaseStartedAt ?? this.periodizationPhaseStartedAt,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
      preferredDIPHour: preferredDIPHour ?? this.preferredDIPHour,
      whatsAppOptIn: whatsAppOptIn ?? this.whatsAppOptIn,
      abhaHealthId: abhaHealthId ?? this.abhaHealthId,
      preferredInputLanguage:
          preferredInputLanguage ?? this.preferredInputLanguage,
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
    if (isCycleTrackingEnabled.present) {
      map['is_cycle_tracking_enabled'] = Variable<bool>(
        isCycleTrackingEnabled.value,
      );
    }
    if (averageCycleLength.present) {
      map['average_cycle_length'] = Variable<int>(averageCycleLength.value);
    }
    if (lastPeriodDate.present) {
      map['last_period_date'] = Variable<DateTime>(lastPeriodDate.value);
    }
    if (subscriptionTier.present) {
      map['subscription_tier'] = Variable<String>(subscriptionTier.value);
    }
    if (monthlyGroceryBudgetInr.present) {
      map['monthly_grocery_budget_inr'] = Variable<double>(
        monthlyGroceryBudgetInr.value,
      );
    }
    if (nutritionPeriodizationPhase.present) {
      map['nutrition_periodization_phase'] = Variable<String>(
        nutritionPeriodizationPhase.value,
      );
    }
    if (periodizationPhaseStartedAt.present) {
      map['periodization_phase_started_at'] = Variable<DateTime>(
        periodizationPhaseStartedAt.value,
      );
    }
    if (timezoneOffsetMinutes.present) {
      map['timezone_offset_minutes'] = Variable<int>(
        timezoneOffsetMinutes.value,
      );
    }
    if (preferredDIPHour.present) {
      map['preferred_d_i_p_hour'] = Variable<int>(preferredDIPHour.value);
    }
    if (whatsAppOptIn.present) {
      map['whats_app_opt_in'] = Variable<bool>(whatsAppOptIn.value);
    }
    if (abhaHealthId.present) {
      map['abha_health_id'] = Variable<String>(abhaHealthId.value);
    }
    if (preferredInputLanguage.present) {
      map['preferred_input_language'] = Variable<String>(
        preferredInputLanguage.value,
      );
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
          ..write('isCycleTrackingEnabled: $isCycleTrackingEnabled, ')
          ..write('averageCycleLength: $averageCycleLength, ')
          ..write('lastPeriodDate: $lastPeriodDate, ')
          ..write('subscriptionTier: $subscriptionTier, ')
          ..write('monthlyGroceryBudgetInr: $monthlyGroceryBudgetInr, ')
          ..write('nutritionPeriodizationPhase: $nutritionPeriodizationPhase, ')
          ..write('periodizationPhaseStartedAt: $periodizationPhaseStartedAt, ')
          ..write('timezoneOffsetMinutes: $timezoneOffsetMinutes, ')
          ..write('preferredDIPHour: $preferredDIPHour, ')
          ..write('whatsAppOptIn: $whatsAppOptIn, ')
          ..write('abhaHealthId: $abhaHealthId, ')
          ..write('preferredInputLanguage: $preferredInputLanguage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserScoresTable extends UserScores
    with TableInfo<$UserScoresTable, UserScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserScoresTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _scoreTypeMeta = const VerificationMeta(
    'scoreType',
  );
  @override
  late final GeneratedColumn<String> scoreType = GeneratedColumn<String>(
    'score_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _computedAtMeta = const VerificationMeta(
    'computedAt',
  );
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
    'computed_at',
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
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    userId,
    scoreType,
    value,
    computedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserScore> instance, {
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
    if (data.containsKey('score_type')) {
      context.handle(
        _scoreTypeMeta,
        scoreType.isAcceptableOrUnknown(data['score_type']!, _scoreTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('computed_at')) {
      context.handle(
        _computedAtMeta,
        computedAt.isAcceptableOrUnknown(data['computed_at']!, _computedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  UserScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserScore(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      scoreType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}score_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      computedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}computed_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $UserScoresTable createAlias(String alias) {
    return $UserScoresTable(attachedDatabase, alias);
  }
}

class UserScore extends DataClass implements Insertable<UserScore> {
  final String localId;
  final String userId;
  final String scoreType;
  final double value;
  final DateTime computedAt;
  final String syncStatus;
  const UserScore({
    required this.localId,
    required this.userId,
    required this.scoreType,
    required this.value,
    required this.computedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['user_id'] = Variable<String>(userId);
    map['score_type'] = Variable<String>(scoreType);
    map['value'] = Variable<double>(value);
    map['computed_at'] = Variable<DateTime>(computedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  UserScoresCompanion toCompanion(bool nullToAbsent) {
    return UserScoresCompanion(
      localId: Value(localId),
      userId: Value(userId),
      scoreType: Value(scoreType),
      value: Value(value),
      computedAt: Value(computedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory UserScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserScore(
      localId: serializer.fromJson<String>(json['localId']),
      userId: serializer.fromJson<String>(json['userId']),
      scoreType: serializer.fromJson<String>(json['scoreType']),
      value: serializer.fromJson<double>(json['value']),
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'userId': serializer.toJson<String>(userId),
      'scoreType': serializer.toJson<String>(scoreType),
      'value': serializer.toJson<double>(value),
      'computedAt': serializer.toJson<DateTime>(computedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  UserScore copyWith({
    String? localId,
    String? userId,
    String? scoreType,
    double? value,
    DateTime? computedAt,
    String? syncStatus,
  }) => UserScore(
    localId: localId ?? this.localId,
    userId: userId ?? this.userId,
    scoreType: scoreType ?? this.scoreType,
    value: value ?? this.value,
    computedAt: computedAt ?? this.computedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  UserScore copyWithCompanion(UserScoresCompanion data) {
    return UserScore(
      localId: data.localId.present ? data.localId.value : this.localId,
      userId: data.userId.present ? data.userId.value : this.userId,
      scoreType: data.scoreType.present ? data.scoreType.value : this.scoreType,
      value: data.value.present ? data.value.value : this.value,
      computedAt: data.computedAt.present
          ? data.computedAt.value
          : this.computedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserScore(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('scoreType: $scoreType, ')
          ..write('value: $value, ')
          ..write('computedAt: $computedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localId, userId, scoreType, value, computedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserScore &&
          other.localId == this.localId &&
          other.userId == this.userId &&
          other.scoreType == this.scoreType &&
          other.value == this.value &&
          other.computedAt == this.computedAt &&
          other.syncStatus == this.syncStatus);
}

class UserScoresCompanion extends UpdateCompanion<UserScore> {
  final Value<String> localId;
  final Value<String> userId;
  final Value<String> scoreType;
  final Value<double> value;
  final Value<DateTime> computedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const UserScoresCompanion({
    this.localId = const Value.absent(),
    this.userId = const Value.absent(),
    this.scoreType = const Value.absent(),
    this.value = const Value.absent(),
    this.computedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserScoresCompanion.insert({
    required String localId,
    required String userId,
    required String scoreType,
    required double value,
    required DateTime computedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       userId = Value(userId),
       scoreType = Value(scoreType),
       value = Value(value),
       computedAt = Value(computedAt);
  static Insertable<UserScore> custom({
    Expression<String>? localId,
    Expression<String>? userId,
    Expression<String>? scoreType,
    Expression<double>? value,
    Expression<DateTime>? computedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (userId != null) 'user_id': userId,
      if (scoreType != null) 'score_type': scoreType,
      if (value != null) 'value': value,
      if (computedAt != null) 'computed_at': computedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserScoresCompanion copyWith({
    Value<String>? localId,
    Value<String>? userId,
    Value<String>? scoreType,
    Value<double>? value,
    Value<DateTime>? computedAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return UserScoresCompanion(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      scoreType: scoreType ?? this.scoreType,
      value: value ?? this.value,
      computedAt: computedAt ?? this.computedAt,
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
    if (scoreType.present) {
      map['score_type'] = Variable<String>(scoreType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
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
    return (StringBuffer('UserScoresCompanion(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('scoreType: $scoreType, ')
          ..write('value: $value, ')
          ..write('computedAt: $computedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrganizationAccountsTable extends OrganizationAccounts
    with TableInfo<$OrganizationAccountsTable, OrganizationAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrganizationAccountsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _azureIdMeta = const VerificationMeta(
    'azureId',
  );
  @override
  late final GeneratedColumn<String> azureId = GeneratedColumn<String>(
    'azure_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _organizationNameMeta = const VerificationMeta(
    'organizationName',
  );
  @override
  late final GeneratedColumn<String> organizationName = GeneratedColumn<String>(
    'organization_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTierMeta = const VerificationMeta(
    'planTier',
  );
  @override
  late final GeneratedColumn<String> planTier = GeneratedColumn<String>(
    'plan_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seatLimitMeta = const VerificationMeta(
    'seatLimit',
  );
  @override
  late final GeneratedColumn<int> seatLimit = GeneratedColumn<int>(
    'seat_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    azureId,
    organizationName,
    accountType,
    planTier,
    seatLimit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'organization_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrganizationAccount> instance, {
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
    if (data.containsKey('azure_id')) {
      context.handle(
        _azureIdMeta,
        azureId.isAcceptableOrUnknown(data['azure_id']!, _azureIdMeta),
      );
    }
    if (data.containsKey('organization_name')) {
      context.handle(
        _organizationNameMeta,
        organizationName.isAcceptableOrUnknown(
          data['organization_name']!,
          _organizationNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationNameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('plan_tier')) {
      context.handle(
        _planTierMeta,
        planTier.isAcceptableOrUnknown(data['plan_tier']!, _planTierMeta),
      );
    } else if (isInserting) {
      context.missing(_planTierMeta);
    }
    if (data.containsKey('seat_limit')) {
      context.handle(
        _seatLimitMeta,
        seatLimit.isAcceptableOrUnknown(data['seat_limit']!, _seatLimitMeta),
      );
    } else if (isInserting) {
      context.missing(_seatLimitMeta);
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
  OrganizationAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrganizationAccount(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      azureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}azure_id'],
      ),
      organizationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_name'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      planTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_tier'],
      )!,
      seatLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seat_limit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OrganizationAccountsTable createAlias(String alias) {
    return $OrganizationAccountsTable(attachedDatabase, alias);
  }
}

class OrganizationAccount extends DataClass
    implements Insertable<OrganizationAccount> {
  final String localId;
  final String? azureId;
  final String organizationName;
  final String accountType;
  final String planTier;
  final int seatLimit;
  final DateTime createdAt;
  const OrganizationAccount({
    required this.localId,
    this.azureId,
    required this.organizationName,
    required this.accountType,
    required this.planTier,
    required this.seatLimit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || azureId != null) {
      map['azure_id'] = Variable<String>(azureId);
    }
    map['organization_name'] = Variable<String>(organizationName);
    map['account_type'] = Variable<String>(accountType);
    map['plan_tier'] = Variable<String>(planTier);
    map['seat_limit'] = Variable<int>(seatLimit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrganizationAccountsCompanion toCompanion(bool nullToAbsent) {
    return OrganizationAccountsCompanion(
      localId: Value(localId),
      azureId: azureId == null && nullToAbsent
          ? const Value.absent()
          : Value(azureId),
      organizationName: Value(organizationName),
      accountType: Value(accountType),
      planTier: Value(planTier),
      seatLimit: Value(seatLimit),
      createdAt: Value(createdAt),
    );
  }

  factory OrganizationAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrganizationAccount(
      localId: serializer.fromJson<String>(json['localId']),
      azureId: serializer.fromJson<String?>(json['azureId']),
      organizationName: serializer.fromJson<String>(json['organizationName']),
      accountType: serializer.fromJson<String>(json['accountType']),
      planTier: serializer.fromJson<String>(json['planTier']),
      seatLimit: serializer.fromJson<int>(json['seatLimit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'azureId': serializer.toJson<String?>(azureId),
      'organizationName': serializer.toJson<String>(organizationName),
      'accountType': serializer.toJson<String>(accountType),
      'planTier': serializer.toJson<String>(planTier),
      'seatLimit': serializer.toJson<int>(seatLimit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OrganizationAccount copyWith({
    String? localId,
    Value<String?> azureId = const Value.absent(),
    String? organizationName,
    String? accountType,
    String? planTier,
    int? seatLimit,
    DateTime? createdAt,
  }) => OrganizationAccount(
    localId: localId ?? this.localId,
    azureId: azureId.present ? azureId.value : this.azureId,
    organizationName: organizationName ?? this.organizationName,
    accountType: accountType ?? this.accountType,
    planTier: planTier ?? this.planTier,
    seatLimit: seatLimit ?? this.seatLimit,
    createdAt: createdAt ?? this.createdAt,
  );
  OrganizationAccount copyWithCompanion(OrganizationAccountsCompanion data) {
    return OrganizationAccount(
      localId: data.localId.present ? data.localId.value : this.localId,
      azureId: data.azureId.present ? data.azureId.value : this.azureId,
      organizationName: data.organizationName.present
          ? data.organizationName.value
          : this.organizationName,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      planTier: data.planTier.present ? data.planTier.value : this.planTier,
      seatLimit: data.seatLimit.present ? data.seatLimit.value : this.seatLimit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrganizationAccount(')
          ..write('localId: $localId, ')
          ..write('azureId: $azureId, ')
          ..write('organizationName: $organizationName, ')
          ..write('accountType: $accountType, ')
          ..write('planTier: $planTier, ')
          ..write('seatLimit: $seatLimit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    azureId,
    organizationName,
    accountType,
    planTier,
    seatLimit,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrganizationAccount &&
          other.localId == this.localId &&
          other.azureId == this.azureId &&
          other.organizationName == this.organizationName &&
          other.accountType == this.accountType &&
          other.planTier == this.planTier &&
          other.seatLimit == this.seatLimit &&
          other.createdAt == this.createdAt);
}

class OrganizationAccountsCompanion
    extends UpdateCompanion<OrganizationAccount> {
  final Value<String> localId;
  final Value<String?> azureId;
  final Value<String> organizationName;
  final Value<String> accountType;
  final Value<String> planTier;
  final Value<int> seatLimit;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OrganizationAccountsCompanion({
    this.localId = const Value.absent(),
    this.azureId = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.accountType = const Value.absent(),
    this.planTier = const Value.absent(),
    this.seatLimit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrganizationAccountsCompanion.insert({
    required String localId,
    this.azureId = const Value.absent(),
    required String organizationName,
    required String accountType,
    required String planTier,
    required int seatLimit,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       organizationName = Value(organizationName),
       accountType = Value(accountType),
       planTier = Value(planTier),
       seatLimit = Value(seatLimit),
       createdAt = Value(createdAt);
  static Insertable<OrganizationAccount> custom({
    Expression<String>? localId,
    Expression<String>? azureId,
    Expression<String>? organizationName,
    Expression<String>? accountType,
    Expression<String>? planTier,
    Expression<int>? seatLimit,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (azureId != null) 'azure_id': azureId,
      if (organizationName != null) 'organization_name': organizationName,
      if (accountType != null) 'account_type': accountType,
      if (planTier != null) 'plan_tier': planTier,
      if (seatLimit != null) 'seat_limit': seatLimit,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrganizationAccountsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? azureId,
    Value<String>? organizationName,
    Value<String>? accountType,
    Value<String>? planTier,
    Value<int>? seatLimit,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OrganizationAccountsCompanion(
      localId: localId ?? this.localId,
      azureId: azureId ?? this.azureId,
      organizationName: organizationName ?? this.organizationName,
      accountType: accountType ?? this.accountType,
      planTier: planTier ?? this.planTier,
      seatLimit: seatLimit ?? this.seatLimit,
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
    if (azureId.present) {
      map['azure_id'] = Variable<String>(azureId.value);
    }
    if (organizationName.present) {
      map['organization_name'] = Variable<String>(organizationName.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (planTier.present) {
      map['plan_tier'] = Variable<String>(planTier.value);
    }
    if (seatLimit.present) {
      map['seat_limit'] = Variable<int>(seatLimit.value);
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
    return (StringBuffer('OrganizationAccountsCompanion(')
          ..write('localId: $localId, ')
          ..write('azureId: $azureId, ')
          ..write('organizationName: $organizationName, ')
          ..write('accountType: $accountType, ')
          ..write('planTier: $planTier, ')
          ..write('seatLimit: $seatLimit, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeEnrollmentsTable extends EmployeeEnrollments
    with TableInfo<$EmployeeEnrollmentsTable, EmployeeEnrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeEnrollmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enrolledAtMeta = const VerificationMeta(
    'enrolledAt',
  );
  @override
  late final GeneratedColumn<DateTime> enrolledAt = GeneratedColumn<DateTime>(
    'enrolled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    userId,
    organizationId,
    enrolledAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_enrollments';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeEnrollment> instance, {
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
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('enrolled_at')) {
      context.handle(
        _enrolledAtMeta,
        enrolledAt.isAcceptableOrUnknown(data['enrolled_at']!, _enrolledAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enrolledAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  EmployeeEnrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeEnrollment(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      enrolledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}enrolled_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $EmployeeEnrollmentsTable createAlias(String alias) {
    return $EmployeeEnrollmentsTable(attachedDatabase, alias);
  }
}

class EmployeeEnrollment extends DataClass
    implements Insertable<EmployeeEnrollment> {
  final String localId;
  final String userId;
  final String organizationId;
  final DateTime enrolledAt;
  final bool isActive;
  const EmployeeEnrollment({
    required this.localId,
    required this.userId,
    required this.organizationId,
    required this.enrolledAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['user_id'] = Variable<String>(userId);
    map['organization_id'] = Variable<String>(organizationId);
    map['enrolled_at'] = Variable<DateTime>(enrolledAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  EmployeeEnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return EmployeeEnrollmentsCompanion(
      localId: Value(localId),
      userId: Value(userId),
      organizationId: Value(organizationId),
      enrolledAt: Value(enrolledAt),
      isActive: Value(isActive),
    );
  }

  factory EmployeeEnrollment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeEnrollment(
      localId: serializer.fromJson<String>(json['localId']),
      userId: serializer.fromJson<String>(json['userId']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      enrolledAt: serializer.fromJson<DateTime>(json['enrolledAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'userId': serializer.toJson<String>(userId),
      'organizationId': serializer.toJson<String>(organizationId),
      'enrolledAt': serializer.toJson<DateTime>(enrolledAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  EmployeeEnrollment copyWith({
    String? localId,
    String? userId,
    String? organizationId,
    DateTime? enrolledAt,
    bool? isActive,
  }) => EmployeeEnrollment(
    localId: localId ?? this.localId,
    userId: userId ?? this.userId,
    organizationId: organizationId ?? this.organizationId,
    enrolledAt: enrolledAt ?? this.enrolledAt,
    isActive: isActive ?? this.isActive,
  );
  EmployeeEnrollment copyWithCompanion(EmployeeEnrollmentsCompanion data) {
    return EmployeeEnrollment(
      localId: data.localId.present ? data.localId.value : this.localId,
      userId: data.userId.present ? data.userId.value : this.userId,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      enrolledAt: data.enrolledAt.present
          ? data.enrolledAt.value
          : this.enrolledAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEnrollment(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('organizationId: $organizationId, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localId, userId, organizationId, enrolledAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeEnrollment &&
          other.localId == this.localId &&
          other.userId == this.userId &&
          other.organizationId == this.organizationId &&
          other.enrolledAt == this.enrolledAt &&
          other.isActive == this.isActive);
}

class EmployeeEnrollmentsCompanion extends UpdateCompanion<EmployeeEnrollment> {
  final Value<String> localId;
  final Value<String> userId;
  final Value<String> organizationId;
  final Value<DateTime> enrolledAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const EmployeeEnrollmentsCompanion({
    this.localId = const Value.absent(),
    this.userId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.enrolledAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeEnrollmentsCompanion.insert({
    required String localId,
    required String userId,
    required String organizationId,
    required DateTime enrolledAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       userId = Value(userId),
       organizationId = Value(organizationId),
       enrolledAt = Value(enrolledAt);
  static Insertable<EmployeeEnrollment> custom({
    Expression<String>? localId,
    Expression<String>? userId,
    Expression<String>? organizationId,
    Expression<DateTime>? enrolledAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (userId != null) 'user_id': userId,
      if (organizationId != null) 'organization_id': organizationId,
      if (enrolledAt != null) 'enrolled_at': enrolledAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeEnrollmentsCompanion copyWith({
    Value<String>? localId,
    Value<String>? userId,
    Value<String>? organizationId,
    Value<DateTime>? enrolledAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return EmployeeEnrollmentsCompanion(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      isActive: isActive ?? this.isActive,
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
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (enrolledAt.present) {
      map['enrolled_at'] = Variable<DateTime>(enrolledAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEnrollmentsCompanion(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('organizationId: $organizationId, ')
          ..write('enrolledAt: $enrolledAt, ')
          ..write('isActive: $isActive, ')
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

class $MenstrualSymptomLogsTable extends MenstrualSymptomLogs
    with TableInfo<$MenstrualSymptomLogsTable, MenstrualSymptomLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenstrualSymptomLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasMenstrualFlowMeta = const VerificationMeta(
    'hasMenstrualFlow',
  );
  @override
  late final GeneratedColumn<bool> hasMenstrualFlow = GeneratedColumn<bool>(
    'has_menstrual_flow',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_menstrual_flow" IN (0, 1))',
    ),
  );
  static const VerificationMeta _basalBodyTemperatureMeta =
      const VerificationMeta('basalBodyTemperature');
  @override
  late final GeneratedColumn<double> basalBodyTemperature =
      GeneratedColumn<double>(
        'basal_body_temperature',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _positiveLhTestMeta = const VerificationMeta(
    'positiveLhTest',
  );
  @override
  late final GeneratedColumn<bool> positiveLhTest = GeneratedColumn<bool>(
    'positive_lh_test',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("positive_lh_test" IN (0, 1))',
    ),
  );
  static const VerificationMeta _physicalSymptomsMeta = const VerificationMeta(
    'physicalSymptoms',
  );
  @override
  late final GeneratedColumn<String> physicalSymptoms = GeneratedColumn<String>(
    'physical_symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restingHeartRateMeta = const VerificationMeta(
    'restingHeartRate',
  );
  @override
  late final GeneratedColumn<int> restingHeartRate = GeneratedColumn<int>(
    'resting_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrvMsMeta = const VerificationMeta('hrvMs');
  @override
  late final GeneratedColumn<double> hrvMs = GeneratedColumn<double>(
    'hrv_ms',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    logDate,
    hasMenstrualFlow,
    basalBodyTemperature,
    positiveLhTest,
    physicalSymptoms,
    restingHeartRate,
    hrvMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menstrual_symptom_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenstrualSymptomLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('has_menstrual_flow')) {
      context.handle(
        _hasMenstrualFlowMeta,
        hasMenstrualFlow.isAcceptableOrUnknown(
          data['has_menstrual_flow']!,
          _hasMenstrualFlowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasMenstrualFlowMeta);
    }
    if (data.containsKey('basal_body_temperature')) {
      context.handle(
        _basalBodyTemperatureMeta,
        basalBodyTemperature.isAcceptableOrUnknown(
          data['basal_body_temperature']!,
          _basalBodyTemperatureMeta,
        ),
      );
    }
    if (data.containsKey('positive_lh_test')) {
      context.handle(
        _positiveLhTestMeta,
        positiveLhTest.isAcceptableOrUnknown(
          data['positive_lh_test']!,
          _positiveLhTestMeta,
        ),
      );
    }
    if (data.containsKey('physical_symptoms')) {
      context.handle(
        _physicalSymptomsMeta,
        physicalSymptoms.isAcceptableOrUnknown(
          data['physical_symptoms']!,
          _physicalSymptomsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_physicalSymptomsMeta);
    }
    if (data.containsKey('resting_heart_rate')) {
      context.handle(
        _restingHeartRateMeta,
        restingHeartRate.isAcceptableOrUnknown(
          data['resting_heart_rate']!,
          _restingHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('hrv_ms')) {
      context.handle(
        _hrvMsMeta,
        hrvMs.isAcceptableOrUnknown(data['hrv_ms']!, _hrvMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenstrualSymptomLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenstrualSymptomLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      hasMenstrualFlow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_menstrual_flow'],
      )!,
      basalBodyTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}basal_body_temperature'],
      ),
      positiveLhTest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}positive_lh_test'],
      ),
      physicalSymptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}physical_symptoms'],
      )!,
      restingHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resting_heart_rate'],
      ),
      hrvMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hrv_ms'],
      ),
    );
  }

  @override
  $MenstrualSymptomLogsTable createAlias(String alias) {
    return $MenstrualSymptomLogsTable(attachedDatabase, alias);
  }
}

class MenstrualSymptomLog extends DataClass
    implements Insertable<MenstrualSymptomLog> {
  final int id;
  final String userId;
  final DateTime logDate;
  final bool hasMenstrualFlow;
  final double? basalBodyTemperature;
  final bool? positiveLhTest;
  final String physicalSymptoms;
  final int? restingHeartRate;
  final double? hrvMs;
  const MenstrualSymptomLog({
    required this.id,
    required this.userId,
    required this.logDate,
    required this.hasMenstrualFlow,
    this.basalBodyTemperature,
    this.positiveLhTest,
    required this.physicalSymptoms,
    this.restingHeartRate,
    this.hrvMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['log_date'] = Variable<DateTime>(logDate);
    map['has_menstrual_flow'] = Variable<bool>(hasMenstrualFlow);
    if (!nullToAbsent || basalBodyTemperature != null) {
      map['basal_body_temperature'] = Variable<double>(basalBodyTemperature);
    }
    if (!nullToAbsent || positiveLhTest != null) {
      map['positive_lh_test'] = Variable<bool>(positiveLhTest);
    }
    map['physical_symptoms'] = Variable<String>(physicalSymptoms);
    if (!nullToAbsent || restingHeartRate != null) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate);
    }
    if (!nullToAbsent || hrvMs != null) {
      map['hrv_ms'] = Variable<double>(hrvMs);
    }
    return map;
  }

  MenstrualSymptomLogsCompanion toCompanion(bool nullToAbsent) {
    return MenstrualSymptomLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      logDate: Value(logDate),
      hasMenstrualFlow: Value(hasMenstrualFlow),
      basalBodyTemperature: basalBodyTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(basalBodyTemperature),
      positiveLhTest: positiveLhTest == null && nullToAbsent
          ? const Value.absent()
          : Value(positiveLhTest),
      physicalSymptoms: Value(physicalSymptoms),
      restingHeartRate: restingHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(restingHeartRate),
      hrvMs: hrvMs == null && nullToAbsent
          ? const Value.absent()
          : Value(hrvMs),
    );
  }

  factory MenstrualSymptomLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenstrualSymptomLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      hasMenstrualFlow: serializer.fromJson<bool>(json['hasMenstrualFlow']),
      basalBodyTemperature: serializer.fromJson<double?>(
        json['basalBodyTemperature'],
      ),
      positiveLhTest: serializer.fromJson<bool?>(json['positiveLhTest']),
      physicalSymptoms: serializer.fromJson<String>(json['physicalSymptoms']),
      restingHeartRate: serializer.fromJson<int?>(json['restingHeartRate']),
      hrvMs: serializer.fromJson<double?>(json['hrvMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'logDate': serializer.toJson<DateTime>(logDate),
      'hasMenstrualFlow': serializer.toJson<bool>(hasMenstrualFlow),
      'basalBodyTemperature': serializer.toJson<double?>(basalBodyTemperature),
      'positiveLhTest': serializer.toJson<bool?>(positiveLhTest),
      'physicalSymptoms': serializer.toJson<String>(physicalSymptoms),
      'restingHeartRate': serializer.toJson<int?>(restingHeartRate),
      'hrvMs': serializer.toJson<double?>(hrvMs),
    };
  }

  MenstrualSymptomLog copyWith({
    int? id,
    String? userId,
    DateTime? logDate,
    bool? hasMenstrualFlow,
    Value<double?> basalBodyTemperature = const Value.absent(),
    Value<bool?> positiveLhTest = const Value.absent(),
    String? physicalSymptoms,
    Value<int?> restingHeartRate = const Value.absent(),
    Value<double?> hrvMs = const Value.absent(),
  }) => MenstrualSymptomLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    logDate: logDate ?? this.logDate,
    hasMenstrualFlow: hasMenstrualFlow ?? this.hasMenstrualFlow,
    basalBodyTemperature: basalBodyTemperature.present
        ? basalBodyTemperature.value
        : this.basalBodyTemperature,
    positiveLhTest: positiveLhTest.present
        ? positiveLhTest.value
        : this.positiveLhTest,
    physicalSymptoms: physicalSymptoms ?? this.physicalSymptoms,
    restingHeartRate: restingHeartRate.present
        ? restingHeartRate.value
        : this.restingHeartRate,
    hrvMs: hrvMs.present ? hrvMs.value : this.hrvMs,
  );
  MenstrualSymptomLog copyWithCompanion(MenstrualSymptomLogsCompanion data) {
    return MenstrualSymptomLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      hasMenstrualFlow: data.hasMenstrualFlow.present
          ? data.hasMenstrualFlow.value
          : this.hasMenstrualFlow,
      basalBodyTemperature: data.basalBodyTemperature.present
          ? data.basalBodyTemperature.value
          : this.basalBodyTemperature,
      positiveLhTest: data.positiveLhTest.present
          ? data.positiveLhTest.value
          : this.positiveLhTest,
      physicalSymptoms: data.physicalSymptoms.present
          ? data.physicalSymptoms.value
          : this.physicalSymptoms,
      restingHeartRate: data.restingHeartRate.present
          ? data.restingHeartRate.value
          : this.restingHeartRate,
      hrvMs: data.hrvMs.present ? data.hrvMs.value : this.hrvMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenstrualSymptomLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('logDate: $logDate, ')
          ..write('hasMenstrualFlow: $hasMenstrualFlow, ')
          ..write('basalBodyTemperature: $basalBodyTemperature, ')
          ..write('positiveLhTest: $positiveLhTest, ')
          ..write('physicalSymptoms: $physicalSymptoms, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('hrvMs: $hrvMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    logDate,
    hasMenstrualFlow,
    basalBodyTemperature,
    positiveLhTest,
    physicalSymptoms,
    restingHeartRate,
    hrvMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenstrualSymptomLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.logDate == this.logDate &&
          other.hasMenstrualFlow == this.hasMenstrualFlow &&
          other.basalBodyTemperature == this.basalBodyTemperature &&
          other.positiveLhTest == this.positiveLhTest &&
          other.physicalSymptoms == this.physicalSymptoms &&
          other.restingHeartRate == this.restingHeartRate &&
          other.hrvMs == this.hrvMs);
}

class MenstrualSymptomLogsCompanion
    extends UpdateCompanion<MenstrualSymptomLog> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> logDate;
  final Value<bool> hasMenstrualFlow;
  final Value<double?> basalBodyTemperature;
  final Value<bool?> positiveLhTest;
  final Value<String> physicalSymptoms;
  final Value<int?> restingHeartRate;
  final Value<double?> hrvMs;
  const MenstrualSymptomLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.hasMenstrualFlow = const Value.absent(),
    this.basalBodyTemperature = const Value.absent(),
    this.positiveLhTest = const Value.absent(),
    this.physicalSymptoms = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.hrvMs = const Value.absent(),
  });
  MenstrualSymptomLogsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime logDate,
    required bool hasMenstrualFlow,
    this.basalBodyTemperature = const Value.absent(),
    this.positiveLhTest = const Value.absent(),
    required String physicalSymptoms,
    this.restingHeartRate = const Value.absent(),
    this.hrvMs = const Value.absent(),
  }) : userId = Value(userId),
       logDate = Value(logDate),
       hasMenstrualFlow = Value(hasMenstrualFlow),
       physicalSymptoms = Value(physicalSymptoms);
  static Insertable<MenstrualSymptomLog> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? logDate,
    Expression<bool>? hasMenstrualFlow,
    Expression<double>? basalBodyTemperature,
    Expression<bool>? positiveLhTest,
    Expression<String>? physicalSymptoms,
    Expression<int>? restingHeartRate,
    Expression<double>? hrvMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (logDate != null) 'log_date': logDate,
      if (hasMenstrualFlow != null) 'has_menstrual_flow': hasMenstrualFlow,
      if (basalBodyTemperature != null)
        'basal_body_temperature': basalBodyTemperature,
      if (positiveLhTest != null) 'positive_lh_test': positiveLhTest,
      if (physicalSymptoms != null) 'physical_symptoms': physicalSymptoms,
      if (restingHeartRate != null) 'resting_heart_rate': restingHeartRate,
      if (hrvMs != null) 'hrv_ms': hrvMs,
    });
  }

  MenstrualSymptomLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? logDate,
    Value<bool>? hasMenstrualFlow,
    Value<double?>? basalBodyTemperature,
    Value<bool?>? positiveLhTest,
    Value<String>? physicalSymptoms,
    Value<int?>? restingHeartRate,
    Value<double?>? hrvMs,
  }) {
    return MenstrualSymptomLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      hasMenstrualFlow: hasMenstrualFlow ?? this.hasMenstrualFlow,
      basalBodyTemperature: basalBodyTemperature ?? this.basalBodyTemperature,
      positiveLhTest: positiveLhTest ?? this.positiveLhTest,
      physicalSymptoms: physicalSymptoms ?? this.physicalSymptoms,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      hrvMs: hrvMs ?? this.hrvMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (hasMenstrualFlow.present) {
      map['has_menstrual_flow'] = Variable<bool>(hasMenstrualFlow.value);
    }
    if (basalBodyTemperature.present) {
      map['basal_body_temperature'] = Variable<double>(
        basalBodyTemperature.value,
      );
    }
    if (positiveLhTest.present) {
      map['positive_lh_test'] = Variable<bool>(positiveLhTest.value);
    }
    if (physicalSymptoms.present) {
      map['physical_symptoms'] = Variable<String>(physicalSymptoms.value);
    }
    if (restingHeartRate.present) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate.value);
    }
    if (hrvMs.present) {
      map['hrv_ms'] = Variable<double>(hrvMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenstrualSymptomLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('logDate: $logDate, ')
          ..write('hasMenstrualFlow: $hasMenstrualFlow, ')
          ..write('basalBodyTemperature: $basalBodyTemperature, ')
          ..write('positiveLhTest: $positiveLhTest, ')
          ..write('physicalSymptoms: $physicalSymptoms, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('hrvMs: $hrvMs')
          ..write(')'))
        .toString();
  }
}

class $RecoveryLogsTable extends RecoveryLogs
    with TableInfo<$RecoveryLogsTable, RecoveryLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecoveryLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readinessScoreMeta = const VerificationMeta(
    'readinessScore',
  );
  @override
  late final GeneratedColumn<int> readinessScore = GeneratedColumn<int>(
    'readiness_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceTierMeta = const VerificationMeta(
    'confidenceTier',
  );
  @override
  late final GeneratedColumn<String> confidenceTier = GeneratedColumn<String>(
    'confidence_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sorenessLevelMeta = const VerificationMeta(
    'sorenessLevel',
  );
  @override
  late final GeneratedColumn<int> sorenessLevel = GeneratedColumn<int>(
    'soreness_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stressLevelMeta = const VerificationMeta(
    'stressLevel',
  );
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
    'stress_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyLevelMeta = const VerificationMeta(
    'energyLevel',
  );
  @override
  late final GeneratedColumn<int> energyLevel = GeneratedColumn<int>(
    'energy_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restingHRMeta = const VerificationMeta(
    'restingHR',
  );
  @override
  late final GeneratedColumn<double> restingHR = GeneratedColumn<double>(
    'resting_h_r',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrvMeta = const VerificationMeta('hrv');
  @override
  late final GeneratedColumn<double> hrv = GeneratedColumn<double>(
    'hrv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sorenessRegionsMeta = const VerificationMeta(
    'sorenessRegions',
  );
  @override
  late final GeneratedColumn<String> sorenessRegions = GeneratedColumn<String>(
    'soreness_regions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepNeedMinutesMeta = const VerificationMeta(
    'sleepNeedMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepNeedMinutes = GeneratedColumn<int>(
    'sleep_need_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(480),
  );
  static const VerificationMeta _sleepPerformanceScoreMeta =
      const VerificationMeta('sleepPerformanceScore');
  @override
  late final GeneratedColumn<int> sleepPerformanceScore = GeneratedColumn<int>(
    'sleep_performance_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _dailyStrainScoreMeta = const VerificationMeta(
    'dailyStrainScore',
  );
  @override
  late final GeneratedColumn<double> dailyStrainScore = GeneratedColumn<double>(
    'daily_strain_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _illnessRiskStatusMeta = const VerificationMeta(
    'illnessRiskStatus',
  );
  @override
  late final GeneratedColumn<String> illnessRiskStatus =
      GeneratedColumn<String>(
        'illness_risk_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('low'),
      );
  static const VerificationMeta _prescribedActionsJsonMeta =
      const VerificationMeta('prescribedActionsJson');
  @override
  late final GeneratedColumn<String> prescribedActionsJson =
      GeneratedColumn<String>(
        'prescribed_actions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _recoveryDriversJsonMeta =
      const VerificationMeta('recoveryDriversJson');
  @override
  late final GeneratedColumn<String> recoveryDriversJson =
      GeneratedColumn<String>(
        'recovery_drivers_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
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
    logDate,
    readinessScore,
    confidenceTier,
    sleepQuality,
    sorenessLevel,
    stressLevel,
    energyLevel,
    restingHR,
    hrv,
    sorenessRegions,
    sleepNeedMinutes,
    sleepPerformanceScore,
    dailyStrainScore,
    illnessRiskStatus,
    prescribedActionsJson,
    recoveryDriversJson,
    syncStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recovery_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecoveryLog> instance, {
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
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('readiness_score')) {
      context.handle(
        _readinessScoreMeta,
        readinessScore.isAcceptableOrUnknown(
          data['readiness_score']!,
          _readinessScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_readinessScoreMeta);
    }
    if (data.containsKey('confidence_tier')) {
      context.handle(
        _confidenceTierMeta,
        confidenceTier.isAcceptableOrUnknown(
          data['confidence_tier']!,
          _confidenceTierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confidenceTierMeta);
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sleepQualityMeta);
    }
    if (data.containsKey('soreness_level')) {
      context.handle(
        _sorenessLevelMeta,
        sorenessLevel.isAcceptableOrUnknown(
          data['soreness_level']!,
          _sorenessLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sorenessLevelMeta);
    }
    if (data.containsKey('stress_level')) {
      context.handle(
        _stressLevelMeta,
        stressLevel.isAcceptableOrUnknown(
          data['stress_level']!,
          _stressLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stressLevelMeta);
    }
    if (data.containsKey('energy_level')) {
      context.handle(
        _energyLevelMeta,
        energyLevel.isAcceptableOrUnknown(
          data['energy_level']!,
          _energyLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_energyLevelMeta);
    }
    if (data.containsKey('resting_h_r')) {
      context.handle(
        _restingHRMeta,
        restingHR.isAcceptableOrUnknown(data['resting_h_r']!, _restingHRMeta),
      );
    }
    if (data.containsKey('hrv')) {
      context.handle(
        _hrvMeta,
        hrv.isAcceptableOrUnknown(data['hrv']!, _hrvMeta),
      );
    }
    if (data.containsKey('soreness_regions')) {
      context.handle(
        _sorenessRegionsMeta,
        sorenessRegions.isAcceptableOrUnknown(
          data['soreness_regions']!,
          _sorenessRegionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sorenessRegionsMeta);
    }
    if (data.containsKey('sleep_need_minutes')) {
      context.handle(
        _sleepNeedMinutesMeta,
        sleepNeedMinutes.isAcceptableOrUnknown(
          data['sleep_need_minutes']!,
          _sleepNeedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sleep_performance_score')) {
      context.handle(
        _sleepPerformanceScoreMeta,
        sleepPerformanceScore.isAcceptableOrUnknown(
          data['sleep_performance_score']!,
          _sleepPerformanceScoreMeta,
        ),
      );
    }
    if (data.containsKey('daily_strain_score')) {
      context.handle(
        _dailyStrainScoreMeta,
        dailyStrainScore.isAcceptableOrUnknown(
          data['daily_strain_score']!,
          _dailyStrainScoreMeta,
        ),
      );
    }
    if (data.containsKey('illness_risk_status')) {
      context.handle(
        _illnessRiskStatusMeta,
        illnessRiskStatus.isAcceptableOrUnknown(
          data['illness_risk_status']!,
          _illnessRiskStatusMeta,
        ),
      );
    }
    if (data.containsKey('prescribed_actions_json')) {
      context.handle(
        _prescribedActionsJsonMeta,
        prescribedActionsJson.isAcceptableOrUnknown(
          data['prescribed_actions_json']!,
          _prescribedActionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prescribedActionsJsonMeta);
    }
    if (data.containsKey('recovery_drivers_json')) {
      context.handle(
        _recoveryDriversJsonMeta,
        recoveryDriversJson.isAcceptableOrUnknown(
          data['recovery_drivers_json']!,
          _recoveryDriversJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recoveryDriversJsonMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
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
  RecoveryLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecoveryLog(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      readinessScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}readiness_score'],
      )!,
      confidenceTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence_tier'],
      )!,
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      )!,
      sorenessLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}soreness_level'],
      )!,
      stressLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_level'],
      )!,
      energyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_level'],
      )!,
      restingHR: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}resting_h_r'],
      ),
      hrv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hrv'],
      ),
      sorenessRegions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}soreness_regions'],
      )!,
      sleepNeedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_need_minutes'],
      )!,
      sleepPerformanceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_performance_score'],
      )!,
      dailyStrainScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_strain_score'],
      )!,
      illnessRiskStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illness_risk_status'],
      )!,
      prescribedActionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescribed_actions_json'],
      )!,
      recoveryDriversJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_drivers_json'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecoveryLogsTable createAlias(String alias) {
    return $RecoveryLogsTable(attachedDatabase, alias);
  }
}

class RecoveryLog extends DataClass implements Insertable<RecoveryLog> {
  final String localId;
  final String userId;
  final DateTime logDate;
  final int readinessScore;
  final String confidenceTier;
  final int sleepQuality;
  final int sorenessLevel;
  final int stressLevel;
  final int energyLevel;
  final double? restingHR;
  final double? hrv;
  final String sorenessRegions;
  final int sleepNeedMinutes;
  final int sleepPerformanceScore;
  final double dailyStrainScore;
  final String illnessRiskStatus;
  final String prescribedActionsJson;
  final String recoveryDriversJson;
  final String syncStatus;
  final DateTime createdAt;
  const RecoveryLog({
    required this.localId,
    required this.userId,
    required this.logDate,
    required this.readinessScore,
    required this.confidenceTier,
    required this.sleepQuality,
    required this.sorenessLevel,
    required this.stressLevel,
    required this.energyLevel,
    this.restingHR,
    this.hrv,
    required this.sorenessRegions,
    required this.sleepNeedMinutes,
    required this.sleepPerformanceScore,
    required this.dailyStrainScore,
    required this.illnessRiskStatus,
    required this.prescribedActionsJson,
    required this.recoveryDriversJson,
    required this.syncStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['user_id'] = Variable<String>(userId);
    map['log_date'] = Variable<DateTime>(logDate);
    map['readiness_score'] = Variable<int>(readinessScore);
    map['confidence_tier'] = Variable<String>(confidenceTier);
    map['sleep_quality'] = Variable<int>(sleepQuality);
    map['soreness_level'] = Variable<int>(sorenessLevel);
    map['stress_level'] = Variable<int>(stressLevel);
    map['energy_level'] = Variable<int>(energyLevel);
    if (!nullToAbsent || restingHR != null) {
      map['resting_h_r'] = Variable<double>(restingHR);
    }
    if (!nullToAbsent || hrv != null) {
      map['hrv'] = Variable<double>(hrv);
    }
    map['soreness_regions'] = Variable<String>(sorenessRegions);
    map['sleep_need_minutes'] = Variable<int>(sleepNeedMinutes);
    map['sleep_performance_score'] = Variable<int>(sleepPerformanceScore);
    map['daily_strain_score'] = Variable<double>(dailyStrainScore);
    map['illness_risk_status'] = Variable<String>(illnessRiskStatus);
    map['prescribed_actions_json'] = Variable<String>(prescribedActionsJson);
    map['recovery_drivers_json'] = Variable<String>(recoveryDriversJson);
    map['sync_status'] = Variable<String>(syncStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecoveryLogsCompanion toCompanion(bool nullToAbsent) {
    return RecoveryLogsCompanion(
      localId: Value(localId),
      userId: Value(userId),
      logDate: Value(logDate),
      readinessScore: Value(readinessScore),
      confidenceTier: Value(confidenceTier),
      sleepQuality: Value(sleepQuality),
      sorenessLevel: Value(sorenessLevel),
      stressLevel: Value(stressLevel),
      energyLevel: Value(energyLevel),
      restingHR: restingHR == null && nullToAbsent
          ? const Value.absent()
          : Value(restingHR),
      hrv: hrv == null && nullToAbsent ? const Value.absent() : Value(hrv),
      sorenessRegions: Value(sorenessRegions),
      sleepNeedMinutes: Value(sleepNeedMinutes),
      sleepPerformanceScore: Value(sleepPerformanceScore),
      dailyStrainScore: Value(dailyStrainScore),
      illnessRiskStatus: Value(illnessRiskStatus),
      prescribedActionsJson: Value(prescribedActionsJson),
      recoveryDriversJson: Value(recoveryDriversJson),
      syncStatus: Value(syncStatus),
      createdAt: Value(createdAt),
    );
  }

  factory RecoveryLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecoveryLog(
      localId: serializer.fromJson<String>(json['localId']),
      userId: serializer.fromJson<String>(json['userId']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      readinessScore: serializer.fromJson<int>(json['readinessScore']),
      confidenceTier: serializer.fromJson<String>(json['confidenceTier']),
      sleepQuality: serializer.fromJson<int>(json['sleepQuality']),
      sorenessLevel: serializer.fromJson<int>(json['sorenessLevel']),
      stressLevel: serializer.fromJson<int>(json['stressLevel']),
      energyLevel: serializer.fromJson<int>(json['energyLevel']),
      restingHR: serializer.fromJson<double?>(json['restingHR']),
      hrv: serializer.fromJson<double?>(json['hrv']),
      sorenessRegions: serializer.fromJson<String>(json['sorenessRegions']),
      sleepNeedMinutes: serializer.fromJson<int>(json['sleepNeedMinutes']),
      sleepPerformanceScore: serializer.fromJson<int>(
        json['sleepPerformanceScore'],
      ),
      dailyStrainScore: serializer.fromJson<double>(json['dailyStrainScore']),
      illnessRiskStatus: serializer.fromJson<String>(json['illnessRiskStatus']),
      prescribedActionsJson: serializer.fromJson<String>(
        json['prescribedActionsJson'],
      ),
      recoveryDriversJson: serializer.fromJson<String>(
        json['recoveryDriversJson'],
      ),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'userId': serializer.toJson<String>(userId),
      'logDate': serializer.toJson<DateTime>(logDate),
      'readinessScore': serializer.toJson<int>(readinessScore),
      'confidenceTier': serializer.toJson<String>(confidenceTier),
      'sleepQuality': serializer.toJson<int>(sleepQuality),
      'sorenessLevel': serializer.toJson<int>(sorenessLevel),
      'stressLevel': serializer.toJson<int>(stressLevel),
      'energyLevel': serializer.toJson<int>(energyLevel),
      'restingHR': serializer.toJson<double?>(restingHR),
      'hrv': serializer.toJson<double?>(hrv),
      'sorenessRegions': serializer.toJson<String>(sorenessRegions),
      'sleepNeedMinutes': serializer.toJson<int>(sleepNeedMinutes),
      'sleepPerformanceScore': serializer.toJson<int>(sleepPerformanceScore),
      'dailyStrainScore': serializer.toJson<double>(dailyStrainScore),
      'illnessRiskStatus': serializer.toJson<String>(illnessRiskStatus),
      'prescribedActionsJson': serializer.toJson<String>(prescribedActionsJson),
      'recoveryDriversJson': serializer.toJson<String>(recoveryDriversJson),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecoveryLog copyWith({
    String? localId,
    String? userId,
    DateTime? logDate,
    int? readinessScore,
    String? confidenceTier,
    int? sleepQuality,
    int? sorenessLevel,
    int? stressLevel,
    int? energyLevel,
    Value<double?> restingHR = const Value.absent(),
    Value<double?> hrv = const Value.absent(),
    String? sorenessRegions,
    int? sleepNeedMinutes,
    int? sleepPerformanceScore,
    double? dailyStrainScore,
    String? illnessRiskStatus,
    String? prescribedActionsJson,
    String? recoveryDriversJson,
    String? syncStatus,
    DateTime? createdAt,
  }) => RecoveryLog(
    localId: localId ?? this.localId,
    userId: userId ?? this.userId,
    logDate: logDate ?? this.logDate,
    readinessScore: readinessScore ?? this.readinessScore,
    confidenceTier: confidenceTier ?? this.confidenceTier,
    sleepQuality: sleepQuality ?? this.sleepQuality,
    sorenessLevel: sorenessLevel ?? this.sorenessLevel,
    stressLevel: stressLevel ?? this.stressLevel,
    energyLevel: energyLevel ?? this.energyLevel,
    restingHR: restingHR.present ? restingHR.value : this.restingHR,
    hrv: hrv.present ? hrv.value : this.hrv,
    sorenessRegions: sorenessRegions ?? this.sorenessRegions,
    sleepNeedMinutes: sleepNeedMinutes ?? this.sleepNeedMinutes,
    sleepPerformanceScore: sleepPerformanceScore ?? this.sleepPerformanceScore,
    dailyStrainScore: dailyStrainScore ?? this.dailyStrainScore,
    illnessRiskStatus: illnessRiskStatus ?? this.illnessRiskStatus,
    prescribedActionsJson: prescribedActionsJson ?? this.prescribedActionsJson,
    recoveryDriversJson: recoveryDriversJson ?? this.recoveryDriversJson,
    syncStatus: syncStatus ?? this.syncStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  RecoveryLog copyWithCompanion(RecoveryLogsCompanion data) {
    return RecoveryLog(
      localId: data.localId.present ? data.localId.value : this.localId,
      userId: data.userId.present ? data.userId.value : this.userId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      readinessScore: data.readinessScore.present
          ? data.readinessScore.value
          : this.readinessScore,
      confidenceTier: data.confidenceTier.present
          ? data.confidenceTier.value
          : this.confidenceTier,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      sorenessLevel: data.sorenessLevel.present
          ? data.sorenessLevel.value
          : this.sorenessLevel,
      stressLevel: data.stressLevel.present
          ? data.stressLevel.value
          : this.stressLevel,
      energyLevel: data.energyLevel.present
          ? data.energyLevel.value
          : this.energyLevel,
      restingHR: data.restingHR.present ? data.restingHR.value : this.restingHR,
      hrv: data.hrv.present ? data.hrv.value : this.hrv,
      sorenessRegions: data.sorenessRegions.present
          ? data.sorenessRegions.value
          : this.sorenessRegions,
      sleepNeedMinutes: data.sleepNeedMinutes.present
          ? data.sleepNeedMinutes.value
          : this.sleepNeedMinutes,
      sleepPerformanceScore: data.sleepPerformanceScore.present
          ? data.sleepPerformanceScore.value
          : this.sleepPerformanceScore,
      dailyStrainScore: data.dailyStrainScore.present
          ? data.dailyStrainScore.value
          : this.dailyStrainScore,
      illnessRiskStatus: data.illnessRiskStatus.present
          ? data.illnessRiskStatus.value
          : this.illnessRiskStatus,
      prescribedActionsJson: data.prescribedActionsJson.present
          ? data.prescribedActionsJson.value
          : this.prescribedActionsJson,
      recoveryDriversJson: data.recoveryDriversJson.present
          ? data.recoveryDriversJson.value
          : this.recoveryDriversJson,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecoveryLog(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('logDate: $logDate, ')
          ..write('readinessScore: $readinessScore, ')
          ..write('confidenceTier: $confidenceTier, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('sorenessLevel: $sorenessLevel, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('restingHR: $restingHR, ')
          ..write('hrv: $hrv, ')
          ..write('sorenessRegions: $sorenessRegions, ')
          ..write('sleepNeedMinutes: $sleepNeedMinutes, ')
          ..write('sleepPerformanceScore: $sleepPerformanceScore, ')
          ..write('dailyStrainScore: $dailyStrainScore, ')
          ..write('illnessRiskStatus: $illnessRiskStatus, ')
          ..write('prescribedActionsJson: $prescribedActionsJson, ')
          ..write('recoveryDriversJson: $recoveryDriversJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    userId,
    logDate,
    readinessScore,
    confidenceTier,
    sleepQuality,
    sorenessLevel,
    stressLevel,
    energyLevel,
    restingHR,
    hrv,
    sorenessRegions,
    sleepNeedMinutes,
    sleepPerformanceScore,
    dailyStrainScore,
    illnessRiskStatus,
    prescribedActionsJson,
    recoveryDriversJson,
    syncStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecoveryLog &&
          other.localId == this.localId &&
          other.userId == this.userId &&
          other.logDate == this.logDate &&
          other.readinessScore == this.readinessScore &&
          other.confidenceTier == this.confidenceTier &&
          other.sleepQuality == this.sleepQuality &&
          other.sorenessLevel == this.sorenessLevel &&
          other.stressLevel == this.stressLevel &&
          other.energyLevel == this.energyLevel &&
          other.restingHR == this.restingHR &&
          other.hrv == this.hrv &&
          other.sorenessRegions == this.sorenessRegions &&
          other.sleepNeedMinutes == this.sleepNeedMinutes &&
          other.sleepPerformanceScore == this.sleepPerformanceScore &&
          other.dailyStrainScore == this.dailyStrainScore &&
          other.illnessRiskStatus == this.illnessRiskStatus &&
          other.prescribedActionsJson == this.prescribedActionsJson &&
          other.recoveryDriversJson == this.recoveryDriversJson &&
          other.syncStatus == this.syncStatus &&
          other.createdAt == this.createdAt);
}

class RecoveryLogsCompanion extends UpdateCompanion<RecoveryLog> {
  final Value<String> localId;
  final Value<String> userId;
  final Value<DateTime> logDate;
  final Value<int> readinessScore;
  final Value<String> confidenceTier;
  final Value<int> sleepQuality;
  final Value<int> sorenessLevel;
  final Value<int> stressLevel;
  final Value<int> energyLevel;
  final Value<double?> restingHR;
  final Value<double?> hrv;
  final Value<String> sorenessRegions;
  final Value<int> sleepNeedMinutes;
  final Value<int> sleepPerformanceScore;
  final Value<double> dailyStrainScore;
  final Value<String> illnessRiskStatus;
  final Value<String> prescribedActionsJson;
  final Value<String> recoveryDriversJson;
  final Value<String> syncStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecoveryLogsCompanion({
    this.localId = const Value.absent(),
    this.userId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.readinessScore = const Value.absent(),
    this.confidenceTier = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.sorenessLevel = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.energyLevel = const Value.absent(),
    this.restingHR = const Value.absent(),
    this.hrv = const Value.absent(),
    this.sorenessRegions = const Value.absent(),
    this.sleepNeedMinutes = const Value.absent(),
    this.sleepPerformanceScore = const Value.absent(),
    this.dailyStrainScore = const Value.absent(),
    this.illnessRiskStatus = const Value.absent(),
    this.prescribedActionsJson = const Value.absent(),
    this.recoveryDriversJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecoveryLogsCompanion.insert({
    required String localId,
    required String userId,
    required DateTime logDate,
    required int readinessScore,
    required String confidenceTier,
    required int sleepQuality,
    required int sorenessLevel,
    required int stressLevel,
    required int energyLevel,
    this.restingHR = const Value.absent(),
    this.hrv = const Value.absent(),
    required String sorenessRegions,
    this.sleepNeedMinutes = const Value.absent(),
    this.sleepPerformanceScore = const Value.absent(),
    this.dailyStrainScore = const Value.absent(),
    this.illnessRiskStatus = const Value.absent(),
    required String prescribedActionsJson,
    required String recoveryDriversJson,
    required String syncStatus,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       userId = Value(userId),
       logDate = Value(logDate),
       readinessScore = Value(readinessScore),
       confidenceTier = Value(confidenceTier),
       sleepQuality = Value(sleepQuality),
       sorenessLevel = Value(sorenessLevel),
       stressLevel = Value(stressLevel),
       energyLevel = Value(energyLevel),
       sorenessRegions = Value(sorenessRegions),
       prescribedActionsJson = Value(prescribedActionsJson),
       recoveryDriversJson = Value(recoveryDriversJson),
       syncStatus = Value(syncStatus),
       createdAt = Value(createdAt);
  static Insertable<RecoveryLog> custom({
    Expression<String>? localId,
    Expression<String>? userId,
    Expression<DateTime>? logDate,
    Expression<int>? readinessScore,
    Expression<String>? confidenceTier,
    Expression<int>? sleepQuality,
    Expression<int>? sorenessLevel,
    Expression<int>? stressLevel,
    Expression<int>? energyLevel,
    Expression<double>? restingHR,
    Expression<double>? hrv,
    Expression<String>? sorenessRegions,
    Expression<int>? sleepNeedMinutes,
    Expression<int>? sleepPerformanceScore,
    Expression<double>? dailyStrainScore,
    Expression<String>? illnessRiskStatus,
    Expression<String>? prescribedActionsJson,
    Expression<String>? recoveryDriversJson,
    Expression<String>? syncStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (userId != null) 'user_id': userId,
      if (logDate != null) 'log_date': logDate,
      if (readinessScore != null) 'readiness_score': readinessScore,
      if (confidenceTier != null) 'confidence_tier': confidenceTier,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (sorenessLevel != null) 'soreness_level': sorenessLevel,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (energyLevel != null) 'energy_level': energyLevel,
      if (restingHR != null) 'resting_h_r': restingHR,
      if (hrv != null) 'hrv': hrv,
      if (sorenessRegions != null) 'soreness_regions': sorenessRegions,
      if (sleepNeedMinutes != null) 'sleep_need_minutes': sleepNeedMinutes,
      if (sleepPerformanceScore != null)
        'sleep_performance_score': sleepPerformanceScore,
      if (dailyStrainScore != null) 'daily_strain_score': dailyStrainScore,
      if (illnessRiskStatus != null) 'illness_risk_status': illnessRiskStatus,
      if (prescribedActionsJson != null)
        'prescribed_actions_json': prescribedActionsJson,
      if (recoveryDriversJson != null)
        'recovery_drivers_json': recoveryDriversJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecoveryLogsCompanion copyWith({
    Value<String>? localId,
    Value<String>? userId,
    Value<DateTime>? logDate,
    Value<int>? readinessScore,
    Value<String>? confidenceTier,
    Value<int>? sleepQuality,
    Value<int>? sorenessLevel,
    Value<int>? stressLevel,
    Value<int>? energyLevel,
    Value<double?>? restingHR,
    Value<double?>? hrv,
    Value<String>? sorenessRegions,
    Value<int>? sleepNeedMinutes,
    Value<int>? sleepPerformanceScore,
    Value<double>? dailyStrainScore,
    Value<String>? illnessRiskStatus,
    Value<String>? prescribedActionsJson,
    Value<String>? recoveryDriversJson,
    Value<String>? syncStatus,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RecoveryLogsCompanion(
      localId: localId ?? this.localId,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      readinessScore: readinessScore ?? this.readinessScore,
      confidenceTier: confidenceTier ?? this.confidenceTier,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sorenessLevel: sorenessLevel ?? this.sorenessLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      restingHR: restingHR ?? this.restingHR,
      hrv: hrv ?? this.hrv,
      sorenessRegions: sorenessRegions ?? this.sorenessRegions,
      sleepNeedMinutes: sleepNeedMinutes ?? this.sleepNeedMinutes,
      sleepPerformanceScore:
          sleepPerformanceScore ?? this.sleepPerformanceScore,
      dailyStrainScore: dailyStrainScore ?? this.dailyStrainScore,
      illnessRiskStatus: illnessRiskStatus ?? this.illnessRiskStatus,
      prescribedActionsJson:
          prescribedActionsJson ?? this.prescribedActionsJson,
      recoveryDriversJson: recoveryDriversJson ?? this.recoveryDriversJson,
      syncStatus: syncStatus ?? this.syncStatus,
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
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (readinessScore.present) {
      map['readiness_score'] = Variable<int>(readinessScore.value);
    }
    if (confidenceTier.present) {
      map['confidence_tier'] = Variable<String>(confidenceTier.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (sorenessLevel.present) {
      map['soreness_level'] = Variable<int>(sorenessLevel.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (energyLevel.present) {
      map['energy_level'] = Variable<int>(energyLevel.value);
    }
    if (restingHR.present) {
      map['resting_h_r'] = Variable<double>(restingHR.value);
    }
    if (hrv.present) {
      map['hrv'] = Variable<double>(hrv.value);
    }
    if (sorenessRegions.present) {
      map['soreness_regions'] = Variable<String>(sorenessRegions.value);
    }
    if (sleepNeedMinutes.present) {
      map['sleep_need_minutes'] = Variable<int>(sleepNeedMinutes.value);
    }
    if (sleepPerformanceScore.present) {
      map['sleep_performance_score'] = Variable<int>(
        sleepPerformanceScore.value,
      );
    }
    if (dailyStrainScore.present) {
      map['daily_strain_score'] = Variable<double>(dailyStrainScore.value);
    }
    if (illnessRiskStatus.present) {
      map['illness_risk_status'] = Variable<String>(illnessRiskStatus.value);
    }
    if (prescribedActionsJson.present) {
      map['prescribed_actions_json'] = Variable<String>(
        prescribedActionsJson.value,
      );
    }
    if (recoveryDriversJson.present) {
      map['recovery_drivers_json'] = Variable<String>(
        recoveryDriversJson.value,
      );
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
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
    return (StringBuffer('RecoveryLogsCompanion(')
          ..write('localId: $localId, ')
          ..write('userId: $userId, ')
          ..write('logDate: $logDate, ')
          ..write('readinessScore: $readinessScore, ')
          ..write('confidenceTier: $confidenceTier, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('sorenessLevel: $sorenessLevel, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('restingHR: $restingHR, ')
          ..write('hrv: $hrv, ')
          ..write('sorenessRegions: $sorenessRegions, ')
          ..write('sleepNeedMinutes: $sleepNeedMinutes, ')
          ..write('sleepPerformanceScore: $sleepPerformanceScore, ')
          ..write('dailyStrainScore: $dailyStrainScore, ')
          ..write('illnessRiskStatus: $illnessRiskStatus, ')
          ..write('prescribedActionsJson: $prescribedActionsJson, ')
          ..write('recoveryDriversJson: $recoveryDriversJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderTypeMeta = const VerificationMeta(
    'senderType',
  );
  @override
  late final GeneratedColumn<String> senderType = GeneratedColumn<String>(
    'sender_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageContentMeta = const VerificationMeta(
    'messageContent',
  );
  @override
  late final GeneratedColumn<String> messageContent = GeneratedColumn<String>(
    'message_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _sourcesJsonMeta = const VerificationMeta(
    'sourcesJson',
  );
  @override
  late final GeneratedColumn<String> sourcesJson = GeneratedColumn<String>(
    'sources_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localAttachmentPathMeta =
      const VerificationMeta('localAttachmentPath');
  @override
  late final GeneratedColumn<String> localAttachmentPath =
      GeneratedColumn<String>(
        'local_attachment_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    senderType,
    messageContent,
    createdAt,
    sourcesJson,
    localAttachmentPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_type')) {
      context.handle(
        _senderTypeMeta,
        senderType.isAcceptableOrUnknown(data['sender_type']!, _senderTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_senderTypeMeta);
    }
    if (data.containsKey('message_content')) {
      context.handle(
        _messageContentMeta,
        messageContent.isAcceptableOrUnknown(
          data['message_content']!,
          _messageContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageContentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sources_json')) {
      context.handle(
        _sourcesJsonMeta,
        sourcesJson.isAcceptableOrUnknown(
          data['sources_json']!,
          _sourcesJsonMeta,
        ),
      );
    }
    if (data.containsKey('local_attachment_path')) {
      context.handle(
        _localAttachmentPathMeta,
        localAttachmentPath.isAcceptableOrUnknown(
          data['local_attachment_path']!,
          _localAttachmentPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      senderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_type'],
      )!,
      messageContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sourcesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sources_json'],
      ),
      localAttachmentPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_attachment_path'],
      ),
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final String conversationId;
  final String senderType;
  final String messageContent;
  final DateTime createdAt;
  final String? sourcesJson;
  final String? localAttachmentPath;
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderType,
    required this.messageContent,
    required this.createdAt,
    this.sourcesJson,
    this.localAttachmentPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_type'] = Variable<String>(senderType);
    map['message_content'] = Variable<String>(messageContent);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sourcesJson != null) {
      map['sources_json'] = Variable<String>(sourcesJson);
    }
    if (!nullToAbsent || localAttachmentPath != null) {
      map['local_attachment_path'] = Variable<String>(localAttachmentPath);
    }
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      senderType: Value(senderType),
      messageContent: Value(messageContent),
      createdAt: Value(createdAt),
      sourcesJson: sourcesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcesJson),
      localAttachmentPath: localAttachmentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localAttachmentPath),
    );
  }

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderType: serializer.fromJson<String>(json['senderType']),
      messageContent: serializer.fromJson<String>(json['messageContent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sourcesJson: serializer.fromJson<String?>(json['sourcesJson']),
      localAttachmentPath: serializer.fromJson<String?>(
        json['localAttachmentPath'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderType': serializer.toJson<String>(senderType),
      'messageContent': serializer.toJson<String>(messageContent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sourcesJson': serializer.toJson<String?>(sourcesJson),
      'localAttachmentPath': serializer.toJson<String?>(localAttachmentPath),
    };
  }

  ChatMessage copyWith({
    int? id,
    String? conversationId,
    String? senderType,
    String? messageContent,
    DateTime? createdAt,
    Value<String?> sourcesJson = const Value.absent(),
    Value<String?> localAttachmentPath = const Value.absent(),
  }) => ChatMessage(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    senderType: senderType ?? this.senderType,
    messageContent: messageContent ?? this.messageContent,
    createdAt: createdAt ?? this.createdAt,
    sourcesJson: sourcesJson.present ? sourcesJson.value : this.sourcesJson,
    localAttachmentPath: localAttachmentPath.present
        ? localAttachmentPath.value
        : this.localAttachmentPath,
  );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderType: data.senderType.present
          ? data.senderType.value
          : this.senderType,
      messageContent: data.messageContent.present
          ? data.messageContent.value
          : this.messageContent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sourcesJson: data.sourcesJson.present
          ? data.sourcesJson.value
          : this.sourcesJson,
      localAttachmentPath: data.localAttachmentPath.present
          ? data.localAttachmentPath.value
          : this.localAttachmentPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderType: $senderType, ')
          ..write('messageContent: $messageContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('localAttachmentPath: $localAttachmentPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    senderType,
    messageContent,
    createdAt,
    sourcesJson,
    localAttachmentPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.senderType == this.senderType &&
          other.messageContent == this.messageContent &&
          other.createdAt == this.createdAt &&
          other.sourcesJson == this.sourcesJson &&
          other.localAttachmentPath == this.localAttachmentPath);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<String> conversationId;
  final Value<String> senderType;
  final Value<String> messageContent;
  final Value<DateTime> createdAt;
  final Value<String?> sourcesJson;
  final Value<String?> localAttachmentPath;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderType = const Value.absent(),
    this.messageContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sourcesJson = const Value.absent(),
    this.localAttachmentPath = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required String conversationId,
    required String senderType,
    required String messageContent,
    required DateTime createdAt,
    this.sourcesJson = const Value.absent(),
    this.localAttachmentPath = const Value.absent(),
  }) : conversationId = Value(conversationId),
       senderType = Value(senderType),
       messageContent = Value(messageContent),
       createdAt = Value(createdAt);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<String>? conversationId,
    Expression<String>? senderType,
    Expression<String>? messageContent,
    Expression<DateTime>? createdAt,
    Expression<String>? sourcesJson,
    Expression<String>? localAttachmentPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderType != null) 'sender_type': senderType,
      if (messageContent != null) 'message_content': messageContent,
      if (createdAt != null) 'created_at': createdAt,
      if (sourcesJson != null) 'sources_json': sourcesJson,
      if (localAttachmentPath != null)
        'local_attachment_path': localAttachmentPath,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? id,
    Value<String>? conversationId,
    Value<String>? senderType,
    Value<String>? messageContent,
    Value<DateTime>? createdAt,
    Value<String?>? sourcesJson,
    Value<String?>? localAttachmentPath,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderType: senderType ?? this.senderType,
      messageContent: messageContent ?? this.messageContent,
      createdAt: createdAt ?? this.createdAt,
      sourcesJson: sourcesJson ?? this.sourcesJson,
      localAttachmentPath: localAttachmentPath ?? this.localAttachmentPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderType.present) {
      map['sender_type'] = Variable<String>(senderType.value);
    }
    if (messageContent.present) {
      map['message_content'] = Variable<String>(messageContent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sourcesJson.present) {
      map['sources_json'] = Variable<String>(sourcesJson.value);
    }
    if (localAttachmentPath.present) {
      map['local_attachment_path'] = Variable<String>(
        localAttachmentPath.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderType: $senderType, ')
          ..write('messageContent: $messageContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourcesJson: $sourcesJson, ')
          ..write('localAttachmentPath: $localAttachmentPath')
          ..write(')'))
        .toString();
  }
}

class $EscalationEventsTable extends EscalationEvents
    with TableInfo<$EscalationEventsTable, EscalationEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EscalationEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _briefingMeta = const VerificationMeta(
    'briefing',
  );
  @override
  late final GeneratedColumn<String> briefing = GeneratedColumn<String>(
    'briefing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _escalatedAtMeta = const VerificationMeta(
    'escalatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> escalatedAt = GeneratedColumn<DateTime>(
    'escalated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    reason,
    briefing,
    escalatedAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'escalation_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<EscalationEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('briefing')) {
      context.handle(
        _briefingMeta,
        briefing.isAcceptableOrUnknown(data['briefing']!, _briefingMeta),
      );
    } else if (isInserting) {
      context.missing(_briefingMeta);
    }
    if (data.containsKey('escalated_at')) {
      context.handle(
        _escalatedAtMeta,
        escalatedAt.isAcceptableOrUnknown(
          data['escalated_at']!,
          _escalatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_escalatedAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EscalationEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EscalationEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      briefing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}briefing'],
      )!,
      escalatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}escalated_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $EscalationEventsTable createAlias(String alias) {
    return $EscalationEventsTable(attachedDatabase, alias);
  }
}

class EscalationEvent extends DataClass implements Insertable<EscalationEvent> {
  final int id;
  final String userId;
  final String reason;
  final String briefing;
  final DateTime escalatedAt;
  final DateTime? resolvedAt;
  const EscalationEvent({
    required this.id,
    required this.userId,
    required this.reason,
    required this.briefing,
    required this.escalatedAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['reason'] = Variable<String>(reason);
    map['briefing'] = Variable<String>(briefing);
    map['escalated_at'] = Variable<DateTime>(escalatedAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  EscalationEventsCompanion toCompanion(bool nullToAbsent) {
    return EscalationEventsCompanion(
      id: Value(id),
      userId: Value(userId),
      reason: Value(reason),
      briefing: Value(briefing),
      escalatedAt: Value(escalatedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory EscalationEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EscalationEvent(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      reason: serializer.fromJson<String>(json['reason']),
      briefing: serializer.fromJson<String>(json['briefing']),
      escalatedAt: serializer.fromJson<DateTime>(json['escalatedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'reason': serializer.toJson<String>(reason),
      'briefing': serializer.toJson<String>(briefing),
      'escalatedAt': serializer.toJson<DateTime>(escalatedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  EscalationEvent copyWith({
    int? id,
    String? userId,
    String? reason,
    String? briefing,
    DateTime? escalatedAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => EscalationEvent(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    reason: reason ?? this.reason,
    briefing: briefing ?? this.briefing,
    escalatedAt: escalatedAt ?? this.escalatedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  EscalationEvent copyWithCompanion(EscalationEventsCompanion data) {
    return EscalationEvent(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      reason: data.reason.present ? data.reason.value : this.reason,
      briefing: data.briefing.present ? data.briefing.value : this.briefing,
      escalatedAt: data.escalatedAt.present
          ? data.escalatedAt.value
          : this.escalatedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EscalationEvent(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('reason: $reason, ')
          ..write('briefing: $briefing, ')
          ..write('escalatedAt: $escalatedAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, reason, briefing, escalatedAt, resolvedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EscalationEvent &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.reason == this.reason &&
          other.briefing == this.briefing &&
          other.escalatedAt == this.escalatedAt &&
          other.resolvedAt == this.resolvedAt);
}

class EscalationEventsCompanion extends UpdateCompanion<EscalationEvent> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> reason;
  final Value<String> briefing;
  final Value<DateTime> escalatedAt;
  final Value<DateTime?> resolvedAt;
  const EscalationEventsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.reason = const Value.absent(),
    this.briefing = const Value.absent(),
    this.escalatedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
  });
  EscalationEventsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String reason,
    required String briefing,
    required DateTime escalatedAt,
    this.resolvedAt = const Value.absent(),
  }) : userId = Value(userId),
       reason = Value(reason),
       briefing = Value(briefing),
       escalatedAt = Value(escalatedAt);
  static Insertable<EscalationEvent> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? reason,
    Expression<String>? briefing,
    Expression<DateTime>? escalatedAt,
    Expression<DateTime>? resolvedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (reason != null) 'reason': reason,
      if (briefing != null) 'briefing': briefing,
      if (escalatedAt != null) 'escalated_at': escalatedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
    });
  }

  EscalationEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? reason,
    Value<String>? briefing,
    Value<DateTime>? escalatedAt,
    Value<DateTime?>? resolvedAt,
  }) {
    return EscalationEventsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reason: reason ?? this.reason,
      briefing: briefing ?? this.briefing,
      escalatedAt: escalatedAt ?? this.escalatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (briefing.present) {
      map['briefing'] = Variable<String>(briefing.value);
    }
    if (escalatedAt.present) {
      map['escalated_at'] = Variable<DateTime>(escalatedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EscalationEventsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('reason: $reason, ')
          ..write('briefing: $briefing, ')
          ..write('escalatedAt: $escalatedAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }
}

class $StepLogsTable extends StepLogs with TableInfo<$StepLogsTable, StepLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
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
    steps,
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
  static const String $name = 'step_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsMeta);
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
  StepLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
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
  $StepLogsTable createAlias(String alias) {
    return $StepLogsTable(attachedDatabase, alias);
  }
}

class StepLog extends DataClass implements Insertable<StepLog> {
  final int id;
  final int steps;
  final String syncBatchId;
  final DateTime loggedAt;
  final DateTime hlcPhysicalTime;
  final int hlcLogicalCounter;
  final String hlcNodeId;
  const StepLog({
    required this.id,
    required this.steps,
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
    map['steps'] = Variable<int>(steps);
    map['sync_batch_id'] = Variable<String>(syncBatchId);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['hlc_physical_time'] = Variable<DateTime>(hlcPhysicalTime);
    map['hlc_logical_counter'] = Variable<int>(hlcLogicalCounter);
    map['hlc_node_id'] = Variable<String>(hlcNodeId);
    return map;
  }

  StepLogsCompanion toCompanion(bool nullToAbsent) {
    return StepLogsCompanion(
      id: Value(id),
      steps: Value(steps),
      syncBatchId: Value(syncBatchId),
      loggedAt: Value(loggedAt),
      hlcPhysicalTime: Value(hlcPhysicalTime),
      hlcLogicalCounter: Value(hlcLogicalCounter),
      hlcNodeId: Value(hlcNodeId),
    );
  }

  factory StepLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepLog(
      id: serializer.fromJson<int>(json['id']),
      steps: serializer.fromJson<int>(json['steps']),
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
      'steps': serializer.toJson<int>(steps),
      'syncBatchId': serializer.toJson<String>(syncBatchId),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'hlcPhysicalTime': serializer.toJson<DateTime>(hlcPhysicalTime),
      'hlcLogicalCounter': serializer.toJson<int>(hlcLogicalCounter),
      'hlcNodeId': serializer.toJson<String>(hlcNodeId),
    };
  }

  StepLog copyWith({
    int? id,
    int? steps,
    String? syncBatchId,
    DateTime? loggedAt,
    DateTime? hlcPhysicalTime,
    int? hlcLogicalCounter,
    String? hlcNodeId,
  }) => StepLog(
    id: id ?? this.id,
    steps: steps ?? this.steps,
    syncBatchId: syncBatchId ?? this.syncBatchId,
    loggedAt: loggedAt ?? this.loggedAt,
    hlcPhysicalTime: hlcPhysicalTime ?? this.hlcPhysicalTime,
    hlcLogicalCounter: hlcLogicalCounter ?? this.hlcLogicalCounter,
    hlcNodeId: hlcNodeId ?? this.hlcNodeId,
  );
  StepLog copyWithCompanion(StepLogsCompanion data) {
    return StepLog(
      id: data.id.present ? data.id.value : this.id,
      steps: data.steps.present ? data.steps.value : this.steps,
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
    return (StringBuffer('StepLog(')
          ..write('id: $id, ')
          ..write('steps: $steps, ')
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
    steps,
    syncBatchId,
    loggedAt,
    hlcPhysicalTime,
    hlcLogicalCounter,
    hlcNodeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepLog &&
          other.id == this.id &&
          other.steps == this.steps &&
          other.syncBatchId == this.syncBatchId &&
          other.loggedAt == this.loggedAt &&
          other.hlcPhysicalTime == this.hlcPhysicalTime &&
          other.hlcLogicalCounter == this.hlcLogicalCounter &&
          other.hlcNodeId == this.hlcNodeId);
}

class StepLogsCompanion extends UpdateCompanion<StepLog> {
  final Value<int> id;
  final Value<int> steps;
  final Value<String> syncBatchId;
  final Value<DateTime> loggedAt;
  final Value<DateTime> hlcPhysicalTime;
  final Value<int> hlcLogicalCounter;
  final Value<String> hlcNodeId;
  const StepLogsCompanion({
    this.id = const Value.absent(),
    this.steps = const Value.absent(),
    this.syncBatchId = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.hlcPhysicalTime = const Value.absent(),
    this.hlcLogicalCounter = const Value.absent(),
    this.hlcNodeId = const Value.absent(),
  });
  StepLogsCompanion.insert({
    this.id = const Value.absent(),
    required int steps,
    required String syncBatchId,
    required DateTime loggedAt,
    required DateTime hlcPhysicalTime,
    required int hlcLogicalCounter,
    required String hlcNodeId,
  }) : steps = Value(steps),
       syncBatchId = Value(syncBatchId),
       loggedAt = Value(loggedAt),
       hlcPhysicalTime = Value(hlcPhysicalTime),
       hlcLogicalCounter = Value(hlcLogicalCounter),
       hlcNodeId = Value(hlcNodeId);
  static Insertable<StepLog> custom({
    Expression<int>? id,
    Expression<int>? steps,
    Expression<String>? syncBatchId,
    Expression<DateTime>? loggedAt,
    Expression<DateTime>? hlcPhysicalTime,
    Expression<int>? hlcLogicalCounter,
    Expression<String>? hlcNodeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (steps != null) 'steps': steps,
      if (syncBatchId != null) 'sync_batch_id': syncBatchId,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (hlcPhysicalTime != null) 'hlc_physical_time': hlcPhysicalTime,
      if (hlcLogicalCounter != null) 'hlc_logical_counter': hlcLogicalCounter,
      if (hlcNodeId != null) 'hlc_node_id': hlcNodeId,
    });
  }

  StepLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? steps,
    Value<String>? syncBatchId,
    Value<DateTime>? loggedAt,
    Value<DateTime>? hlcPhysicalTime,
    Value<int>? hlcLogicalCounter,
    Value<String>? hlcNodeId,
  }) {
    return StepLogsCompanion(
      id: id ?? this.id,
      steps: steps ?? this.steps,
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
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
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
    return (StringBuffer('StepLogsCompanion(')
          ..write('id: $id, ')
          ..write('steps: $steps, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('hlcPhysicalTime: $hlcPhysicalTime, ')
          ..write('hlcLogicalCounter: $hlcLogicalCounter, ')
          ..write('hlcNodeId: $hlcNodeId')
          ..write(')'))
        .toString();
  }
}

class $SleepLogsTable extends SleepLogs
    with TableInfo<$SleepLogsTable, SleepLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepMinutesMeta = const VerificationMeta(
    'sleepMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepMinutes = GeneratedColumn<int>(
    'sleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awakeMinutesMeta = const VerificationMeta(
    'awakeMinutes',
  );
  @override
  late final GeneratedColumn<int> awakeMinutes = GeneratedColumn<int>(
    'awake_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remMinutesMeta = const VerificationMeta(
    'remMinutes',
  );
  @override
  late final GeneratedColumn<int> remMinutes = GeneratedColumn<int>(
    'rem_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lightMinutesMeta = const VerificationMeta(
    'lightMinutes',
  );
  @override
  late final GeneratedColumn<int> lightMinutes = GeneratedColumn<int>(
    'light_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deepMinutesMeta = const VerificationMeta(
    'deepMinutes',
  );
  @override
  late final GeneratedColumn<int> deepMinutes = GeneratedColumn<int>(
    'deep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hrvMsMeta = const VerificationMeta('hrvMs');
  @override
  late final GeneratedColumn<double> hrvMs = GeneratedColumn<double>(
    'hrv_ms',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepDateMeta = const VerificationMeta(
    'sleepDate',
  );
  @override
  late final GeneratedColumn<DateTime> sleepDate = GeneratedColumn<DateTime>(
    'sleep_date',
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
    userId,
    sleepMinutes,
    awakeMinutes,
    remMinutes,
    lightMinutes,
    deepMinutes,
    sleepQuality,
    hrvMs,
    sleepDate,
    syncBatchId,
    hlcPhysicalTime,
    hlcLogicalCounter,
    hlcNodeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('sleep_minutes')) {
      context.handle(
        _sleepMinutesMeta,
        sleepMinutes.isAcceptableOrUnknown(
          data['sleep_minutes']!,
          _sleepMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sleepMinutesMeta);
    }
    if (data.containsKey('awake_minutes')) {
      context.handle(
        _awakeMinutesMeta,
        awakeMinutes.isAcceptableOrUnknown(
          data['awake_minutes']!,
          _awakeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awakeMinutesMeta);
    }
    if (data.containsKey('rem_minutes')) {
      context.handle(
        _remMinutesMeta,
        remMinutes.isAcceptableOrUnknown(data['rem_minutes']!, _remMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_remMinutesMeta);
    }
    if (data.containsKey('light_minutes')) {
      context.handle(
        _lightMinutesMeta,
        lightMinutes.isAcceptableOrUnknown(
          data['light_minutes']!,
          _lightMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lightMinutesMeta);
    }
    if (data.containsKey('deep_minutes')) {
      context.handle(
        _deepMinutesMeta,
        deepMinutes.isAcceptableOrUnknown(
          data['deep_minutes']!,
          _deepMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deepMinutesMeta);
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sleepQualityMeta);
    }
    if (data.containsKey('hrv_ms')) {
      context.handle(
        _hrvMsMeta,
        hrvMs.isAcceptableOrUnknown(data['hrv_ms']!, _hrvMsMeta),
      );
    } else if (isInserting) {
      context.missing(_hrvMsMeta);
    }
    if (data.containsKey('sleep_date')) {
      context.handle(
        _sleepDateMeta,
        sleepDate.isAcceptableOrUnknown(data['sleep_date']!, _sleepDateMeta),
      );
    } else if (isInserting) {
      context.missing(_sleepDateMeta);
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
  SleepLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_minutes'],
      )!,
      awakeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}awake_minutes'],
      )!,
      remMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rem_minutes'],
      )!,
      lightMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}light_minutes'],
      )!,
      deepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deep_minutes'],
      )!,
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      )!,
      hrvMs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hrv_ms'],
      )!,
      sleepDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sleep_date'],
      )!,
      syncBatchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_batch_id'],
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
  $SleepLogsTable createAlias(String alias) {
    return $SleepLogsTable(attachedDatabase, alias);
  }
}

class SleepLog extends DataClass implements Insertable<SleepLog> {
  final int id;
  final String userId;
  final int sleepMinutes;
  final int awakeMinutes;
  final int remMinutes;
  final int lightMinutes;
  final int deepMinutes;
  final int sleepQuality;
  final double hrvMs;
  final DateTime sleepDate;
  final String syncBatchId;
  final DateTime hlcPhysicalTime;
  final int hlcLogicalCounter;
  final String hlcNodeId;
  const SleepLog({
    required this.id,
    required this.userId,
    required this.sleepMinutes,
    required this.awakeMinutes,
    required this.remMinutes,
    required this.lightMinutes,
    required this.deepMinutes,
    required this.sleepQuality,
    required this.hrvMs,
    required this.sleepDate,
    required this.syncBatchId,
    required this.hlcPhysicalTime,
    required this.hlcLogicalCounter,
    required this.hlcNodeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['sleep_minutes'] = Variable<int>(sleepMinutes);
    map['awake_minutes'] = Variable<int>(awakeMinutes);
    map['rem_minutes'] = Variable<int>(remMinutes);
    map['light_minutes'] = Variable<int>(lightMinutes);
    map['deep_minutes'] = Variable<int>(deepMinutes);
    map['sleep_quality'] = Variable<int>(sleepQuality);
    map['hrv_ms'] = Variable<double>(hrvMs);
    map['sleep_date'] = Variable<DateTime>(sleepDate);
    map['sync_batch_id'] = Variable<String>(syncBatchId);
    map['hlc_physical_time'] = Variable<DateTime>(hlcPhysicalTime);
    map['hlc_logical_counter'] = Variable<int>(hlcLogicalCounter);
    map['hlc_node_id'] = Variable<String>(hlcNodeId);
    return map;
  }

  SleepLogsCompanion toCompanion(bool nullToAbsent) {
    return SleepLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      sleepMinutes: Value(sleepMinutes),
      awakeMinutes: Value(awakeMinutes),
      remMinutes: Value(remMinutes),
      lightMinutes: Value(lightMinutes),
      deepMinutes: Value(deepMinutes),
      sleepQuality: Value(sleepQuality),
      hrvMs: Value(hrvMs),
      sleepDate: Value(sleepDate),
      syncBatchId: Value(syncBatchId),
      hlcPhysicalTime: Value(hlcPhysicalTime),
      hlcLogicalCounter: Value(hlcLogicalCounter),
      hlcNodeId: Value(hlcNodeId),
    );
  }

  factory SleepLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sleepMinutes: serializer.fromJson<int>(json['sleepMinutes']),
      awakeMinutes: serializer.fromJson<int>(json['awakeMinutes']),
      remMinutes: serializer.fromJson<int>(json['remMinutes']),
      lightMinutes: serializer.fromJson<int>(json['lightMinutes']),
      deepMinutes: serializer.fromJson<int>(json['deepMinutes']),
      sleepQuality: serializer.fromJson<int>(json['sleepQuality']),
      hrvMs: serializer.fromJson<double>(json['hrvMs']),
      sleepDate: serializer.fromJson<DateTime>(json['sleepDate']),
      syncBatchId: serializer.fromJson<String>(json['syncBatchId']),
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
      'userId': serializer.toJson<String>(userId),
      'sleepMinutes': serializer.toJson<int>(sleepMinutes),
      'awakeMinutes': serializer.toJson<int>(awakeMinutes),
      'remMinutes': serializer.toJson<int>(remMinutes),
      'lightMinutes': serializer.toJson<int>(lightMinutes),
      'deepMinutes': serializer.toJson<int>(deepMinutes),
      'sleepQuality': serializer.toJson<int>(sleepQuality),
      'hrvMs': serializer.toJson<double>(hrvMs),
      'sleepDate': serializer.toJson<DateTime>(sleepDate),
      'syncBatchId': serializer.toJson<String>(syncBatchId),
      'hlcPhysicalTime': serializer.toJson<DateTime>(hlcPhysicalTime),
      'hlcLogicalCounter': serializer.toJson<int>(hlcLogicalCounter),
      'hlcNodeId': serializer.toJson<String>(hlcNodeId),
    };
  }

  SleepLog copyWith({
    int? id,
    String? userId,
    int? sleepMinutes,
    int? awakeMinutes,
    int? remMinutes,
    int? lightMinutes,
    int? deepMinutes,
    int? sleepQuality,
    double? hrvMs,
    DateTime? sleepDate,
    String? syncBatchId,
    DateTime? hlcPhysicalTime,
    int? hlcLogicalCounter,
    String? hlcNodeId,
  }) => SleepLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sleepMinutes: sleepMinutes ?? this.sleepMinutes,
    awakeMinutes: awakeMinutes ?? this.awakeMinutes,
    remMinutes: remMinutes ?? this.remMinutes,
    lightMinutes: lightMinutes ?? this.lightMinutes,
    deepMinutes: deepMinutes ?? this.deepMinutes,
    sleepQuality: sleepQuality ?? this.sleepQuality,
    hrvMs: hrvMs ?? this.hrvMs,
    sleepDate: sleepDate ?? this.sleepDate,
    syncBatchId: syncBatchId ?? this.syncBatchId,
    hlcPhysicalTime: hlcPhysicalTime ?? this.hlcPhysicalTime,
    hlcLogicalCounter: hlcLogicalCounter ?? this.hlcLogicalCounter,
    hlcNodeId: hlcNodeId ?? this.hlcNodeId,
  );
  SleepLog copyWithCompanion(SleepLogsCompanion data) {
    return SleepLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sleepMinutes: data.sleepMinutes.present
          ? data.sleepMinutes.value
          : this.sleepMinutes,
      awakeMinutes: data.awakeMinutes.present
          ? data.awakeMinutes.value
          : this.awakeMinutes,
      remMinutes: data.remMinutes.present
          ? data.remMinutes.value
          : this.remMinutes,
      lightMinutes: data.lightMinutes.present
          ? data.lightMinutes.value
          : this.lightMinutes,
      deepMinutes: data.deepMinutes.present
          ? data.deepMinutes.value
          : this.deepMinutes,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      hrvMs: data.hrvMs.present ? data.hrvMs.value : this.hrvMs,
      sleepDate: data.sleepDate.present ? data.sleepDate.value : this.sleepDate,
      syncBatchId: data.syncBatchId.present
          ? data.syncBatchId.value
          : this.syncBatchId,
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
    return (StringBuffer('SleepLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sleepMinutes: $sleepMinutes, ')
          ..write('awakeMinutes: $awakeMinutes, ')
          ..write('remMinutes: $remMinutes, ')
          ..write('lightMinutes: $lightMinutes, ')
          ..write('deepMinutes: $deepMinutes, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('hrvMs: $hrvMs, ')
          ..write('sleepDate: $sleepDate, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('hlcPhysicalTime: $hlcPhysicalTime, ')
          ..write('hlcLogicalCounter: $hlcLogicalCounter, ')
          ..write('hlcNodeId: $hlcNodeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    sleepMinutes,
    awakeMinutes,
    remMinutes,
    lightMinutes,
    deepMinutes,
    sleepQuality,
    hrvMs,
    sleepDate,
    syncBatchId,
    hlcPhysicalTime,
    hlcLogicalCounter,
    hlcNodeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sleepMinutes == this.sleepMinutes &&
          other.awakeMinutes == this.awakeMinutes &&
          other.remMinutes == this.remMinutes &&
          other.lightMinutes == this.lightMinutes &&
          other.deepMinutes == this.deepMinutes &&
          other.sleepQuality == this.sleepQuality &&
          other.hrvMs == this.hrvMs &&
          other.sleepDate == this.sleepDate &&
          other.syncBatchId == this.syncBatchId &&
          other.hlcPhysicalTime == this.hlcPhysicalTime &&
          other.hlcLogicalCounter == this.hlcLogicalCounter &&
          other.hlcNodeId == this.hlcNodeId);
}

class SleepLogsCompanion extends UpdateCompanion<SleepLog> {
  final Value<int> id;
  final Value<String> userId;
  final Value<int> sleepMinutes;
  final Value<int> awakeMinutes;
  final Value<int> remMinutes;
  final Value<int> lightMinutes;
  final Value<int> deepMinutes;
  final Value<int> sleepQuality;
  final Value<double> hrvMs;
  final Value<DateTime> sleepDate;
  final Value<String> syncBatchId;
  final Value<DateTime> hlcPhysicalTime;
  final Value<int> hlcLogicalCounter;
  final Value<String> hlcNodeId;
  const SleepLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sleepMinutes = const Value.absent(),
    this.awakeMinutes = const Value.absent(),
    this.remMinutes = const Value.absent(),
    this.lightMinutes = const Value.absent(),
    this.deepMinutes = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.hrvMs = const Value.absent(),
    this.sleepDate = const Value.absent(),
    this.syncBatchId = const Value.absent(),
    this.hlcPhysicalTime = const Value.absent(),
    this.hlcLogicalCounter = const Value.absent(),
    this.hlcNodeId = const Value.absent(),
  });
  SleepLogsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required int sleepMinutes,
    required int awakeMinutes,
    required int remMinutes,
    required int lightMinutes,
    required int deepMinutes,
    required int sleepQuality,
    required double hrvMs,
    required DateTime sleepDate,
    required String syncBatchId,
    required DateTime hlcPhysicalTime,
    required int hlcLogicalCounter,
    required String hlcNodeId,
  }) : userId = Value(userId),
       sleepMinutes = Value(sleepMinutes),
       awakeMinutes = Value(awakeMinutes),
       remMinutes = Value(remMinutes),
       lightMinutes = Value(lightMinutes),
       deepMinutes = Value(deepMinutes),
       sleepQuality = Value(sleepQuality),
       hrvMs = Value(hrvMs),
       sleepDate = Value(sleepDate),
       syncBatchId = Value(syncBatchId),
       hlcPhysicalTime = Value(hlcPhysicalTime),
       hlcLogicalCounter = Value(hlcLogicalCounter),
       hlcNodeId = Value(hlcNodeId);
  static Insertable<SleepLog> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<int>? sleepMinutes,
    Expression<int>? awakeMinutes,
    Expression<int>? remMinutes,
    Expression<int>? lightMinutes,
    Expression<int>? deepMinutes,
    Expression<int>? sleepQuality,
    Expression<double>? hrvMs,
    Expression<DateTime>? sleepDate,
    Expression<String>? syncBatchId,
    Expression<DateTime>? hlcPhysicalTime,
    Expression<int>? hlcLogicalCounter,
    Expression<String>? hlcNodeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sleepMinutes != null) 'sleep_minutes': sleepMinutes,
      if (awakeMinutes != null) 'awake_minutes': awakeMinutes,
      if (remMinutes != null) 'rem_minutes': remMinutes,
      if (lightMinutes != null) 'light_minutes': lightMinutes,
      if (deepMinutes != null) 'deep_minutes': deepMinutes,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (hrvMs != null) 'hrv_ms': hrvMs,
      if (sleepDate != null) 'sleep_date': sleepDate,
      if (syncBatchId != null) 'sync_batch_id': syncBatchId,
      if (hlcPhysicalTime != null) 'hlc_physical_time': hlcPhysicalTime,
      if (hlcLogicalCounter != null) 'hlc_logical_counter': hlcLogicalCounter,
      if (hlcNodeId != null) 'hlc_node_id': hlcNodeId,
    });
  }

  SleepLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<int>? sleepMinutes,
    Value<int>? awakeMinutes,
    Value<int>? remMinutes,
    Value<int>? lightMinutes,
    Value<int>? deepMinutes,
    Value<int>? sleepQuality,
    Value<double>? hrvMs,
    Value<DateTime>? sleepDate,
    Value<String>? syncBatchId,
    Value<DateTime>? hlcPhysicalTime,
    Value<int>? hlcLogicalCounter,
    Value<String>? hlcNodeId,
  }) {
    return SleepLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sleepMinutes: sleepMinutes ?? this.sleepMinutes,
      awakeMinutes: awakeMinutes ?? this.awakeMinutes,
      remMinutes: remMinutes ?? this.remMinutes,
      lightMinutes: lightMinutes ?? this.lightMinutes,
      deepMinutes: deepMinutes ?? this.deepMinutes,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      hrvMs: hrvMs ?? this.hrvMs,
      sleepDate: sleepDate ?? this.sleepDate,
      syncBatchId: syncBatchId ?? this.syncBatchId,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sleepMinutes.present) {
      map['sleep_minutes'] = Variable<int>(sleepMinutes.value);
    }
    if (awakeMinutes.present) {
      map['awake_minutes'] = Variable<int>(awakeMinutes.value);
    }
    if (remMinutes.present) {
      map['rem_minutes'] = Variable<int>(remMinutes.value);
    }
    if (lightMinutes.present) {
      map['light_minutes'] = Variable<int>(lightMinutes.value);
    }
    if (deepMinutes.present) {
      map['deep_minutes'] = Variable<int>(deepMinutes.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (hrvMs.present) {
      map['hrv_ms'] = Variable<double>(hrvMs.value);
    }
    if (sleepDate.present) {
      map['sleep_date'] = Variable<DateTime>(sleepDate.value);
    }
    if (syncBatchId.present) {
      map['sync_batch_id'] = Variable<String>(syncBatchId.value);
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
    return (StringBuffer('SleepLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sleepMinutes: $sleepMinutes, ')
          ..write('awakeMinutes: $awakeMinutes, ')
          ..write('remMinutes: $remMinutes, ')
          ..write('lightMinutes: $lightMinutes, ')
          ..write('deepMinutes: $deepMinutes, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('hrvMs: $hrvMs, ')
          ..write('sleepDate: $sleepDate, ')
          ..write('syncBatchId: $syncBatchId, ')
          ..write('hlcPhysicalTime: $hlcPhysicalTime, ')
          ..write('hlcLogicalCounter: $hlcLogicalCounter, ')
          ..write('hlcNodeId: $hlcNodeId')
          ..write(')'))
        .toString();
  }
}

class $BpReadingsTable extends BpReadings
    with TableInfo<$BpReadingsTable, BpReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BpReadingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _systolicMeta = const VerificationMeta(
    'systolic',
  );
  @override
  late final GeneratedColumn<int> systolic = GeneratedColumn<int>(
    'systolic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diastolicMeta = const VerificationMeta(
    'diastolic',
  );
  @override
  late final GeneratedColumn<int> diastolic = GeneratedColumn<int>(
    'diastolic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordingMethodMeta = const VerificationMeta(
    'recordingMethod',
  );
  @override
  late final GeneratedColumn<String> recordingMethod = GeneratedColumn<String>(
    'recording_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    systolic,
    diastolic,
    measuredAt,
    recordingMethod,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bp_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BpReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('systolic')) {
      context.handle(
        _systolicMeta,
        systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta),
      );
    } else if (isInserting) {
      context.missing(_systolicMeta);
    }
    if (data.containsKey('diastolic')) {
      context.handle(
        _diastolicMeta,
        diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta),
      );
    } else if (isInserting) {
      context.missing(_diastolicMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('recording_method')) {
      context.handle(
        _recordingMethodMeta,
        recordingMethod.isAcceptableOrUnknown(
          data['recording_method']!,
          _recordingMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordingMethodMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BpReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BpReading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      systolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}systolic'],
      )!,
      diastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diastolic'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      recordingMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_method'],
      )!,
    );
  }

  @override
  $BpReadingsTable createAlias(String alias) {
    return $BpReadingsTable(attachedDatabase, alias);
  }
}

class BpReading extends DataClass implements Insertable<BpReading> {
  final int id;
  final int systolic;
  final int diastolic;
  final DateTime measuredAt;
  final String recordingMethod;
  const BpReading({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.measuredAt,
    required this.recordingMethod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['systolic'] = Variable<int>(systolic);
    map['diastolic'] = Variable<int>(diastolic);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['recording_method'] = Variable<String>(recordingMethod);
    return map;
  }

  BpReadingsCompanion toCompanion(bool nullToAbsent) {
    return BpReadingsCompanion(
      id: Value(id),
      systolic: Value(systolic),
      diastolic: Value(diastolic),
      measuredAt: Value(measuredAt),
      recordingMethod: Value(recordingMethod),
    );
  }

  factory BpReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BpReading(
      id: serializer.fromJson<int>(json['id']),
      systolic: serializer.fromJson<int>(json['systolic']),
      diastolic: serializer.fromJson<int>(json['diastolic']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      recordingMethod: serializer.fromJson<String>(json['recordingMethod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'systolic': serializer.toJson<int>(systolic),
      'diastolic': serializer.toJson<int>(diastolic),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'recordingMethod': serializer.toJson<String>(recordingMethod),
    };
  }

  BpReading copyWith({
    int? id,
    int? systolic,
    int? diastolic,
    DateTime? measuredAt,
    String? recordingMethod,
  }) => BpReading(
    id: id ?? this.id,
    systolic: systolic ?? this.systolic,
    diastolic: diastolic ?? this.diastolic,
    measuredAt: measuredAt ?? this.measuredAt,
    recordingMethod: recordingMethod ?? this.recordingMethod,
  );
  BpReading copyWithCompanion(BpReadingsCompanion data) {
    return BpReading(
      id: data.id.present ? data.id.value : this.id,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      recordingMethod: data.recordingMethod.present
          ? data.recordingMethod.value
          : this.recordingMethod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BpReading(')
          ..write('id: $id, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('recordingMethod: $recordingMethod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, systolic, diastolic, measuredAt, recordingMethod);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BpReading &&
          other.id == this.id &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.measuredAt == this.measuredAt &&
          other.recordingMethod == this.recordingMethod);
}

class BpReadingsCompanion extends UpdateCompanion<BpReading> {
  final Value<int> id;
  final Value<int> systolic;
  final Value<int> diastolic;
  final Value<DateTime> measuredAt;
  final Value<String> recordingMethod;
  const BpReadingsCompanion({
    this.id = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.recordingMethod = const Value.absent(),
  });
  BpReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int systolic,
    required int diastolic,
    required DateTime measuredAt,
    required String recordingMethod,
  }) : systolic = Value(systolic),
       diastolic = Value(diastolic),
       measuredAt = Value(measuredAt),
       recordingMethod = Value(recordingMethod);
  static Insertable<BpReading> custom({
    Expression<int>? id,
    Expression<int>? systolic,
    Expression<int>? diastolic,
    Expression<DateTime>? measuredAt,
    Expression<String>? recordingMethod,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (recordingMethod != null) 'recording_method': recordingMethod,
    });
  }

  BpReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? systolic,
    Value<int>? diastolic,
    Value<DateTime>? measuredAt,
    Value<String>? recordingMethod,
  }) {
    return BpReadingsCompanion(
      id: id ?? this.id,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      measuredAt: measuredAt ?? this.measuredAt,
      recordingMethod: recordingMethod ?? this.recordingMethod,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<int>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<int>(diastolic.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (recordingMethod.present) {
      map['recording_method'] = Variable<String>(recordingMethod.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BpReadingsCompanion(')
          ..write('id: $id, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('recordingMethod: $recordingMethod')
          ..write(')'))
        .toString();
  }
}

class $GlucoseReadingsTable extends GlucoseReadings
    with TableInfo<$GlucoseReadingsTable, GlucoseReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GlucoseReadingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _glucoseValueMeta = const VerificationMeta(
    'glucoseValue',
  );
  @override
  late final GeneratedColumn<double> glucoseValue = GeneratedColumn<double>(
    'glucose_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTagMeta = const VerificationMeta(
    'mealTag',
  );
  @override
  late final GeneratedColumn<String> mealTag = GeneratedColumn<String>(
    'meal_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, glucoseValue, mealTag, measuredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'glucose_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<GlucoseReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('glucose_value')) {
      context.handle(
        _glucoseValueMeta,
        glucoseValue.isAcceptableOrUnknown(
          data['glucose_value']!,
          _glucoseValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_glucoseValueMeta);
    }
    if (data.containsKey('meal_tag')) {
      context.handle(
        _mealTagMeta,
        mealTag.isAcceptableOrUnknown(data['meal_tag']!, _mealTagMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTagMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GlucoseReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GlucoseReading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      glucoseValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}glucose_value'],
      )!,
      mealTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_tag'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
    );
  }

  @override
  $GlucoseReadingsTable createAlias(String alias) {
    return $GlucoseReadingsTable(attachedDatabase, alias);
  }
}

class GlucoseReading extends DataClass implements Insertable<GlucoseReading> {
  final int id;
  final double glucoseValue;
  final String mealTag;
  final DateTime measuredAt;
  const GlucoseReading({
    required this.id,
    required this.glucoseValue,
    required this.mealTag,
    required this.measuredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['glucose_value'] = Variable<double>(glucoseValue);
    map['meal_tag'] = Variable<String>(mealTag);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    return map;
  }

  GlucoseReadingsCompanion toCompanion(bool nullToAbsent) {
    return GlucoseReadingsCompanion(
      id: Value(id),
      glucoseValue: Value(glucoseValue),
      mealTag: Value(mealTag),
      measuredAt: Value(measuredAt),
    );
  }

  factory GlucoseReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlucoseReading(
      id: serializer.fromJson<int>(json['id']),
      glucoseValue: serializer.fromJson<double>(json['glucoseValue']),
      mealTag: serializer.fromJson<String>(json['mealTag']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'glucoseValue': serializer.toJson<double>(glucoseValue),
      'mealTag': serializer.toJson<String>(mealTag),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
    };
  }

  GlucoseReading copyWith({
    int? id,
    double? glucoseValue,
    String? mealTag,
    DateTime? measuredAt,
  }) => GlucoseReading(
    id: id ?? this.id,
    glucoseValue: glucoseValue ?? this.glucoseValue,
    mealTag: mealTag ?? this.mealTag,
    measuredAt: measuredAt ?? this.measuredAt,
  );
  GlucoseReading copyWithCompanion(GlucoseReadingsCompanion data) {
    return GlucoseReading(
      id: data.id.present ? data.id.value : this.id,
      glucoseValue: data.glucoseValue.present
          ? data.glucoseValue.value
          : this.glucoseValue,
      mealTag: data.mealTag.present ? data.mealTag.value : this.mealTag,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GlucoseReading(')
          ..write('id: $id, ')
          ..write('glucoseValue: $glucoseValue, ')
          ..write('mealTag: $mealTag, ')
          ..write('measuredAt: $measuredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, glucoseValue, mealTag, measuredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GlucoseReading &&
          other.id == this.id &&
          other.glucoseValue == this.glucoseValue &&
          other.mealTag == this.mealTag &&
          other.measuredAt == this.measuredAt);
}

class GlucoseReadingsCompanion extends UpdateCompanion<GlucoseReading> {
  final Value<int> id;
  final Value<double> glucoseValue;
  final Value<String> mealTag;
  final Value<DateTime> measuredAt;
  const GlucoseReadingsCompanion({
    this.id = const Value.absent(),
    this.glucoseValue = const Value.absent(),
    this.mealTag = const Value.absent(),
    this.measuredAt = const Value.absent(),
  });
  GlucoseReadingsCompanion.insert({
    this.id = const Value.absent(),
    required double glucoseValue,
    required String mealTag,
    required DateTime measuredAt,
  }) : glucoseValue = Value(glucoseValue),
       mealTag = Value(mealTag),
       measuredAt = Value(measuredAt);
  static Insertable<GlucoseReading> custom({
    Expression<int>? id,
    Expression<double>? glucoseValue,
    Expression<String>? mealTag,
    Expression<DateTime>? measuredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (glucoseValue != null) 'glucose_value': glucoseValue,
      if (mealTag != null) 'meal_tag': mealTag,
      if (measuredAt != null) 'measured_at': measuredAt,
    });
  }

  GlucoseReadingsCompanion copyWith({
    Value<int>? id,
    Value<double>? glucoseValue,
    Value<String>? mealTag,
    Value<DateTime>? measuredAt,
  }) {
    return GlucoseReadingsCompanion(
      id: id ?? this.id,
      glucoseValue: glucoseValue ?? this.glucoseValue,
      mealTag: mealTag ?? this.mealTag,
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (glucoseValue.present) {
      map['glucose_value'] = Variable<double>(glucoseValue.value);
    }
    if (mealTag.present) {
      map['meal_tag'] = Variable<String>(mealTag.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GlucoseReadingsCompanion(')
          ..write('id: $id, ')
          ..write('glucoseValue: $glucoseValue, ')
          ..write('mealTag: $mealTag, ')
          ..write('measuredAt: $measuredAt')
          ..write(')'))
        .toString();
  }
}

class $FoodReferencesTable extends FoodReferences
    with TableInfo<$FoodReferencesTable, FoodReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultServingGMeta = const VerificationMeta(
    'defaultServingG',
  );
  @override
  late final GeneratedColumn<double> defaultServingG = GeneratedColumn<double>(
    'default_serving_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingDescriptionMeta =
      const VerificationMeta('servingDescription');
  @override
  late final GeneratedColumn<String> servingDescription =
      GeneratedColumn<String>(
        'serving_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glycemicIndexMeta = const VerificationMeta(
    'glycemicIndex',
  );
  @override
  late final GeneratedColumn<int> glycemicIndex = GeneratedColumn<int>(
    'glycemic_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberGMeta = const VerificationMeta('fiberG');
  @override
  late final GeneratedColumn<double> fiberG = GeneratedColumn<double>(
    'fiber_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _satietyIndexMeta = const VerificationMeta(
    'satietyIndex',
  );
  @override
  late final GeneratedColumn<int> satietyIndex = GeneratedColumn<int>(
    'satiety_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchTermsMeta = const VerificationMeta(
    'searchTerms',
  );
  @override
  late final GeneratedColumn<String> searchTerms = GeneratedColumn<String>(
    'search_terms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodName,
    defaultServingG,
    servingDescription,
    calories,
    proteinG,
    carbsG,
    fatG,
    glycemicIndex,
    fiberG,
    satietyIndex,
    searchTerms,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodReference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('default_serving_g')) {
      context.handle(
        _defaultServingGMeta,
        defaultServingG.isAcceptableOrUnknown(
          data['default_serving_g']!,
          _defaultServingGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultServingGMeta);
    }
    if (data.containsKey('serving_description')) {
      context.handle(
        _servingDescriptionMeta,
        servingDescription.isAcceptableOrUnknown(
          data['serving_description']!,
          _servingDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_servingDescriptionMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinGMeta);
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGMeta);
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGMeta);
    }
    if (data.containsKey('glycemic_index')) {
      context.handle(
        _glycemicIndexMeta,
        glycemicIndex.isAcceptableOrUnknown(
          data['glycemic_index']!,
          _glycemicIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_glycemicIndexMeta);
    }
    if (data.containsKey('fiber_g')) {
      context.handle(
        _fiberGMeta,
        fiberG.isAcceptableOrUnknown(data['fiber_g']!, _fiberGMeta),
      );
    } else if (isInserting) {
      context.missing(_fiberGMeta);
    }
    if (data.containsKey('satiety_index')) {
      context.handle(
        _satietyIndexMeta,
        satietyIndex.isAcceptableOrUnknown(
          data['satiety_index']!,
          _satietyIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_satietyIndexMeta);
    }
    if (data.containsKey('search_terms')) {
      context.handle(
        _searchTermsMeta,
        searchTerms.isAcceptableOrUnknown(
          data['search_terms']!,
          _searchTermsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_searchTermsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodReference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      defaultServingG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_serving_g'],
      )!,
      servingDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_description'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      glycemicIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}glycemic_index'],
      )!,
      fiberG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_g'],
      )!,
      satietyIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}satiety_index'],
      )!,
      searchTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_terms'],
      )!,
    );
  }

  @override
  $FoodReferencesTable createAlias(String alias) {
    return $FoodReferencesTable(attachedDatabase, alias);
  }
}

class FoodReference extends DataClass implements Insertable<FoodReference> {
  final String id;
  final String foodName;
  final double defaultServingG;
  final String servingDescription;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int glycemicIndex;
  final double fiberG;
  final int satietyIndex;
  final String searchTerms;
  const FoodReference({
    required this.id,
    required this.foodName,
    required this.defaultServingG,
    required this.servingDescription,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.glycemicIndex,
    required this.fiberG,
    required this.satietyIndex,
    required this.searchTerms,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['food_name'] = Variable<String>(foodName);
    map['default_serving_g'] = Variable<double>(defaultServingG);
    map['serving_description'] = Variable<String>(servingDescription);
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    map['glycemic_index'] = Variable<int>(glycemicIndex);
    map['fiber_g'] = Variable<double>(fiberG);
    map['satiety_index'] = Variable<int>(satietyIndex);
    map['search_terms'] = Variable<String>(searchTerms);
    return map;
  }

  FoodReferencesCompanion toCompanion(bool nullToAbsent) {
    return FoodReferencesCompanion(
      id: Value(id),
      foodName: Value(foodName),
      defaultServingG: Value(defaultServingG),
      servingDescription: Value(servingDescription),
      calories: Value(calories),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      glycemicIndex: Value(glycemicIndex),
      fiberG: Value(fiberG),
      satietyIndex: Value(satietyIndex),
      searchTerms: Value(searchTerms),
    );
  }

  factory FoodReference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodReference(
      id: serializer.fromJson<String>(json['id']),
      foodName: serializer.fromJson<String>(json['foodName']),
      defaultServingG: serializer.fromJson<double>(json['defaultServingG']),
      servingDescription: serializer.fromJson<String>(
        json['servingDescription'],
      ),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      glycemicIndex: serializer.fromJson<int>(json['glycemicIndex']),
      fiberG: serializer.fromJson<double>(json['fiberG']),
      satietyIndex: serializer.fromJson<int>(json['satietyIndex']),
      searchTerms: serializer.fromJson<String>(json['searchTerms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'foodName': serializer.toJson<String>(foodName),
      'defaultServingG': serializer.toJson<double>(defaultServingG),
      'servingDescription': serializer.toJson<String>(servingDescription),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'glycemicIndex': serializer.toJson<int>(glycemicIndex),
      'fiberG': serializer.toJson<double>(fiberG),
      'satietyIndex': serializer.toJson<int>(satietyIndex),
      'searchTerms': serializer.toJson<String>(searchTerms),
    };
  }

  FoodReference copyWith({
    String? id,
    String? foodName,
    double? defaultServingG,
    String? servingDescription,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    int? glycemicIndex,
    double? fiberG,
    int? satietyIndex,
    String? searchTerms,
  }) => FoodReference(
    id: id ?? this.id,
    foodName: foodName ?? this.foodName,
    defaultServingG: defaultServingG ?? this.defaultServingG,
    servingDescription: servingDescription ?? this.servingDescription,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    glycemicIndex: glycemicIndex ?? this.glycemicIndex,
    fiberG: fiberG ?? this.fiberG,
    satietyIndex: satietyIndex ?? this.satietyIndex,
    searchTerms: searchTerms ?? this.searchTerms,
  );
  FoodReference copyWithCompanion(FoodReferencesCompanion data) {
    return FoodReference(
      id: data.id.present ? data.id.value : this.id,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      defaultServingG: data.defaultServingG.present
          ? data.defaultServingG.value
          : this.defaultServingG,
      servingDescription: data.servingDescription.present
          ? data.servingDescription.value
          : this.servingDescription,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      glycemicIndex: data.glycemicIndex.present
          ? data.glycemicIndex.value
          : this.glycemicIndex,
      fiberG: data.fiberG.present ? data.fiberG.value : this.fiberG,
      satietyIndex: data.satietyIndex.present
          ? data.satietyIndex.value
          : this.satietyIndex,
      searchTerms: data.searchTerms.present
          ? data.searchTerms.value
          : this.searchTerms,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodReference(')
          ..write('id: $id, ')
          ..write('foodName: $foodName, ')
          ..write('defaultServingG: $defaultServingG, ')
          ..write('servingDescription: $servingDescription, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('glycemicIndex: $glycemicIndex, ')
          ..write('fiberG: $fiberG, ')
          ..write('satietyIndex: $satietyIndex, ')
          ..write('searchTerms: $searchTerms')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    foodName,
    defaultServingG,
    servingDescription,
    calories,
    proteinG,
    carbsG,
    fatG,
    glycemicIndex,
    fiberG,
    satietyIndex,
    searchTerms,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodReference &&
          other.id == this.id &&
          other.foodName == this.foodName &&
          other.defaultServingG == this.defaultServingG &&
          other.servingDescription == this.servingDescription &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.glycemicIndex == this.glycemicIndex &&
          other.fiberG == this.fiberG &&
          other.satietyIndex == this.satietyIndex &&
          other.searchTerms == this.searchTerms);
}

class FoodReferencesCompanion extends UpdateCompanion<FoodReference> {
  final Value<String> id;
  final Value<String> foodName;
  final Value<double> defaultServingG;
  final Value<String> servingDescription;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<int> glycemicIndex;
  final Value<double> fiberG;
  final Value<int> satietyIndex;
  final Value<String> searchTerms;
  final Value<int> rowid;
  const FoodReferencesCompanion({
    this.id = const Value.absent(),
    this.foodName = const Value.absent(),
    this.defaultServingG = const Value.absent(),
    this.servingDescription = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.glycemicIndex = const Value.absent(),
    this.fiberG = const Value.absent(),
    this.satietyIndex = const Value.absent(),
    this.searchTerms = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodReferencesCompanion.insert({
    required String id,
    required String foodName,
    required double defaultServingG,
    required String servingDescription,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required int glycemicIndex,
    required double fiberG,
    required int satietyIndex,
    required String searchTerms,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       foodName = Value(foodName),
       defaultServingG = Value(defaultServingG),
       servingDescription = Value(servingDescription),
       calories = Value(calories),
       proteinG = Value(proteinG),
       carbsG = Value(carbsG),
       fatG = Value(fatG),
       glycemicIndex = Value(glycemicIndex),
       fiberG = Value(fiberG),
       satietyIndex = Value(satietyIndex),
       searchTerms = Value(searchTerms);
  static Insertable<FoodReference> custom({
    Expression<String>? id,
    Expression<String>? foodName,
    Expression<double>? defaultServingG,
    Expression<String>? servingDescription,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<int>? glycemicIndex,
    Expression<double>? fiberG,
    Expression<int>? satietyIndex,
    Expression<String>? searchTerms,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodName != null) 'food_name': foodName,
      if (defaultServingG != null) 'default_serving_g': defaultServingG,
      if (servingDescription != null) 'serving_description': servingDescription,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (glycemicIndex != null) 'glycemic_index': glycemicIndex,
      if (fiberG != null) 'fiber_g': fiberG,
      if (satietyIndex != null) 'satiety_index': satietyIndex,
      if (searchTerms != null) 'search_terms': searchTerms,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodReferencesCompanion copyWith({
    Value<String>? id,
    Value<String>? foodName,
    Value<double>? defaultServingG,
    Value<String>? servingDescription,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<int>? glycemicIndex,
    Value<double>? fiberG,
    Value<int>? satietyIndex,
    Value<String>? searchTerms,
    Value<int>? rowid,
  }) {
    return FoodReferencesCompanion(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      defaultServingG: defaultServingG ?? this.defaultServingG,
      servingDescription: servingDescription ?? this.servingDescription,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      glycemicIndex: glycemicIndex ?? this.glycemicIndex,
      fiberG: fiberG ?? this.fiberG,
      satietyIndex: satietyIndex ?? this.satietyIndex,
      searchTerms: searchTerms ?? this.searchTerms,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (defaultServingG.present) {
      map['default_serving_g'] = Variable<double>(defaultServingG.value);
    }
    if (servingDescription.present) {
      map['serving_description'] = Variable<String>(servingDescription.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (glycemicIndex.present) {
      map['glycemic_index'] = Variable<int>(glycemicIndex.value);
    }
    if (fiberG.present) {
      map['fiber_g'] = Variable<double>(fiberG.value);
    }
    if (satietyIndex.present) {
      map['satiety_index'] = Variable<int>(satietyIndex.value);
    }
    if (searchTerms.present) {
      map['search_terms'] = Variable<String>(searchTerms.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodReferencesCompanion(')
          ..write('id: $id, ')
          ..write('foodName: $foodName, ')
          ..write('defaultServingG: $defaultServingG, ')
          ..write('servingDescription: $servingDescription, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('glycemicIndex: $glycemicIndex, ')
          ..write('fiberG: $fiberG, ')
          ..write('satietyIndex: $satietyIndex, ')
          ..write('searchTerms: $searchTerms, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MicronutrientLogsTable extends MicronutrientLogs
    with TableInfo<$MicronutrientLogsTable, MicronutrientLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MicronutrientLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ironMgMeta = const VerificationMeta('ironMg');
  @override
  late final GeneratedColumn<double> ironMg = GeneratedColumn<double>(
    'iron_mg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _vitaminB12McgMeta = const VerificationMeta(
    'vitaminB12Mcg',
  );
  @override
  late final GeneratedColumn<double> vitaminB12Mcg = GeneratedColumn<double>(
    'vitamin_b12_mcg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _vitaminD3IuMeta = const VerificationMeta(
    'vitaminD3Iu',
  );
  @override
  late final GeneratedColumn<double> vitaminD3Iu = GeneratedColumn<double>(
    'vitamin_d3_iu',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _calciumMgMeta = const VerificationMeta(
    'calciumMg',
  );
  @override
  late final GeneratedColumn<double> calciumMg = GeneratedColumn<double>(
    'calcium_mg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _magnesiumMgMeta = const VerificationMeta(
    'magnesiumMg',
  );
  @override
  late final GeneratedColumn<double> magnesiumMg = GeneratedColumn<double>(
    'magnesium_mg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _zincMgMeta = const VerificationMeta('zincMg');
  @override
  late final GeneratedColumn<double> zincMg = GeneratedColumn<double>(
    'zinc_mg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _folateMcgMeta = const VerificationMeta(
    'folateMcg',
  );
  @override
  late final GeneratedColumn<double> folateMcg = GeneratedColumn<double>(
    'folate_mcg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _omega3GMeta = const VerificationMeta(
    'omega3G',
  );
  @override
  late final GeneratedColumn<double> omega3G = GeneratedColumn<double>(
    'omega3_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    logDate,
    ironMg,
    vitaminB12Mcg,
    vitaminD3Iu,
    calciumMg,
    magnesiumMg,
    zincMg,
    folateMcg,
    omega3G,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'micronutrient_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MicronutrientLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('iron_mg')) {
      context.handle(
        _ironMgMeta,
        ironMg.isAcceptableOrUnknown(data['iron_mg']!, _ironMgMeta),
      );
    }
    if (data.containsKey('vitamin_b12_mcg')) {
      context.handle(
        _vitaminB12McgMeta,
        vitaminB12Mcg.isAcceptableOrUnknown(
          data['vitamin_b12_mcg']!,
          _vitaminB12McgMeta,
        ),
      );
    }
    if (data.containsKey('vitamin_d3_iu')) {
      context.handle(
        _vitaminD3IuMeta,
        vitaminD3Iu.isAcceptableOrUnknown(
          data['vitamin_d3_iu']!,
          _vitaminD3IuMeta,
        ),
      );
    }
    if (data.containsKey('calcium_mg')) {
      context.handle(
        _calciumMgMeta,
        calciumMg.isAcceptableOrUnknown(data['calcium_mg']!, _calciumMgMeta),
      );
    }
    if (data.containsKey('magnesium_mg')) {
      context.handle(
        _magnesiumMgMeta,
        magnesiumMg.isAcceptableOrUnknown(
          data['magnesium_mg']!,
          _magnesiumMgMeta,
        ),
      );
    }
    if (data.containsKey('zinc_mg')) {
      context.handle(
        _zincMgMeta,
        zincMg.isAcceptableOrUnknown(data['zinc_mg']!, _zincMgMeta),
      );
    }
    if (data.containsKey('folate_mcg')) {
      context.handle(
        _folateMcgMeta,
        folateMcg.isAcceptableOrUnknown(data['folate_mcg']!, _folateMcgMeta),
      );
    }
    if (data.containsKey('omega3_g')) {
      context.handle(
        _omega3GMeta,
        omega3G.isAcceptableOrUnknown(data['omega3_g']!, _omega3GMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MicronutrientLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MicronutrientLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      ironMg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}iron_mg'],
      )!,
      vitaminB12Mcg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_b12_mcg'],
      )!,
      vitaminD3Iu: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_d3_iu'],
      )!,
      calciumMg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calcium_mg'],
      )!,
      magnesiumMg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}magnesium_mg'],
      )!,
      zincMg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}zinc_mg'],
      )!,
      folateMcg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}folate_mcg'],
      )!,
      omega3G: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}omega3_g'],
      )!,
    );
  }

  @override
  $MicronutrientLogsTable createAlias(String alias) {
    return $MicronutrientLogsTable(attachedDatabase, alias);
  }
}

class MicronutrientLog extends DataClass
    implements Insertable<MicronutrientLog> {
  final int id;
  final String userId;
  final DateTime logDate;
  final double ironMg;
  final double vitaminB12Mcg;
  final double vitaminD3Iu;
  final double calciumMg;
  final double magnesiumMg;
  final double zincMg;
  final double folateMcg;
  final double omega3G;
  const MicronutrientLog({
    required this.id,
    required this.userId,
    required this.logDate,
    required this.ironMg,
    required this.vitaminB12Mcg,
    required this.vitaminD3Iu,
    required this.calciumMg,
    required this.magnesiumMg,
    required this.zincMg,
    required this.folateMcg,
    required this.omega3G,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['log_date'] = Variable<DateTime>(logDate);
    map['iron_mg'] = Variable<double>(ironMg);
    map['vitamin_b12_mcg'] = Variable<double>(vitaminB12Mcg);
    map['vitamin_d3_iu'] = Variable<double>(vitaminD3Iu);
    map['calcium_mg'] = Variable<double>(calciumMg);
    map['magnesium_mg'] = Variable<double>(magnesiumMg);
    map['zinc_mg'] = Variable<double>(zincMg);
    map['folate_mcg'] = Variable<double>(folateMcg);
    map['omega3_g'] = Variable<double>(omega3G);
    return map;
  }

  MicronutrientLogsCompanion toCompanion(bool nullToAbsent) {
    return MicronutrientLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      logDate: Value(logDate),
      ironMg: Value(ironMg),
      vitaminB12Mcg: Value(vitaminB12Mcg),
      vitaminD3Iu: Value(vitaminD3Iu),
      calciumMg: Value(calciumMg),
      magnesiumMg: Value(magnesiumMg),
      zincMg: Value(zincMg),
      folateMcg: Value(folateMcg),
      omega3G: Value(omega3G),
    );
  }

  factory MicronutrientLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MicronutrientLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      ironMg: serializer.fromJson<double>(json['ironMg']),
      vitaminB12Mcg: serializer.fromJson<double>(json['vitaminB12Mcg']),
      vitaminD3Iu: serializer.fromJson<double>(json['vitaminD3Iu']),
      calciumMg: serializer.fromJson<double>(json['calciumMg']),
      magnesiumMg: serializer.fromJson<double>(json['magnesiumMg']),
      zincMg: serializer.fromJson<double>(json['zincMg']),
      folateMcg: serializer.fromJson<double>(json['folateMcg']),
      omega3G: serializer.fromJson<double>(json['omega3G']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'logDate': serializer.toJson<DateTime>(logDate),
      'ironMg': serializer.toJson<double>(ironMg),
      'vitaminB12Mcg': serializer.toJson<double>(vitaminB12Mcg),
      'vitaminD3Iu': serializer.toJson<double>(vitaminD3Iu),
      'calciumMg': serializer.toJson<double>(calciumMg),
      'magnesiumMg': serializer.toJson<double>(magnesiumMg),
      'zincMg': serializer.toJson<double>(zincMg),
      'folateMcg': serializer.toJson<double>(folateMcg),
      'omega3G': serializer.toJson<double>(omega3G),
    };
  }

  MicronutrientLog copyWith({
    int? id,
    String? userId,
    DateTime? logDate,
    double? ironMg,
    double? vitaminB12Mcg,
    double? vitaminD3Iu,
    double? calciumMg,
    double? magnesiumMg,
    double? zincMg,
    double? folateMcg,
    double? omega3G,
  }) => MicronutrientLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    logDate: logDate ?? this.logDate,
    ironMg: ironMg ?? this.ironMg,
    vitaminB12Mcg: vitaminB12Mcg ?? this.vitaminB12Mcg,
    vitaminD3Iu: vitaminD3Iu ?? this.vitaminD3Iu,
    calciumMg: calciumMg ?? this.calciumMg,
    magnesiumMg: magnesiumMg ?? this.magnesiumMg,
    zincMg: zincMg ?? this.zincMg,
    folateMcg: folateMcg ?? this.folateMcg,
    omega3G: omega3G ?? this.omega3G,
  );
  MicronutrientLog copyWithCompanion(MicronutrientLogsCompanion data) {
    return MicronutrientLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      ironMg: data.ironMg.present ? data.ironMg.value : this.ironMg,
      vitaminB12Mcg: data.vitaminB12Mcg.present
          ? data.vitaminB12Mcg.value
          : this.vitaminB12Mcg,
      vitaminD3Iu: data.vitaminD3Iu.present
          ? data.vitaminD3Iu.value
          : this.vitaminD3Iu,
      calciumMg: data.calciumMg.present ? data.calciumMg.value : this.calciumMg,
      magnesiumMg: data.magnesiumMg.present
          ? data.magnesiumMg.value
          : this.magnesiumMg,
      zincMg: data.zincMg.present ? data.zincMg.value : this.zincMg,
      folateMcg: data.folateMcg.present ? data.folateMcg.value : this.folateMcg,
      omega3G: data.omega3G.present ? data.omega3G.value : this.omega3G,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MicronutrientLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('logDate: $logDate, ')
          ..write('ironMg: $ironMg, ')
          ..write('vitaminB12Mcg: $vitaminB12Mcg, ')
          ..write('vitaminD3Iu: $vitaminD3Iu, ')
          ..write('calciumMg: $calciumMg, ')
          ..write('magnesiumMg: $magnesiumMg, ')
          ..write('zincMg: $zincMg, ')
          ..write('folateMcg: $folateMcg, ')
          ..write('omega3G: $omega3G')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    logDate,
    ironMg,
    vitaminB12Mcg,
    vitaminD3Iu,
    calciumMg,
    magnesiumMg,
    zincMg,
    folateMcg,
    omega3G,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MicronutrientLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.logDate == this.logDate &&
          other.ironMg == this.ironMg &&
          other.vitaminB12Mcg == this.vitaminB12Mcg &&
          other.vitaminD3Iu == this.vitaminD3Iu &&
          other.calciumMg == this.calciumMg &&
          other.magnesiumMg == this.magnesiumMg &&
          other.zincMg == this.zincMg &&
          other.folateMcg == this.folateMcg &&
          other.omega3G == this.omega3G);
}

class MicronutrientLogsCompanion extends UpdateCompanion<MicronutrientLog> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> logDate;
  final Value<double> ironMg;
  final Value<double> vitaminB12Mcg;
  final Value<double> vitaminD3Iu;
  final Value<double> calciumMg;
  final Value<double> magnesiumMg;
  final Value<double> zincMg;
  final Value<double> folateMcg;
  final Value<double> omega3G;
  const MicronutrientLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.ironMg = const Value.absent(),
    this.vitaminB12Mcg = const Value.absent(),
    this.vitaminD3Iu = const Value.absent(),
    this.calciumMg = const Value.absent(),
    this.magnesiumMg = const Value.absent(),
    this.zincMg = const Value.absent(),
    this.folateMcg = const Value.absent(),
    this.omega3G = const Value.absent(),
  });
  MicronutrientLogsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime logDate,
    this.ironMg = const Value.absent(),
    this.vitaminB12Mcg = const Value.absent(),
    this.vitaminD3Iu = const Value.absent(),
    this.calciumMg = const Value.absent(),
    this.magnesiumMg = const Value.absent(),
    this.zincMg = const Value.absent(),
    this.folateMcg = const Value.absent(),
    this.omega3G = const Value.absent(),
  }) : userId = Value(userId),
       logDate = Value(logDate);
  static Insertable<MicronutrientLog> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? logDate,
    Expression<double>? ironMg,
    Expression<double>? vitaminB12Mcg,
    Expression<double>? vitaminD3Iu,
    Expression<double>? calciumMg,
    Expression<double>? magnesiumMg,
    Expression<double>? zincMg,
    Expression<double>? folateMcg,
    Expression<double>? omega3G,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (logDate != null) 'log_date': logDate,
      if (ironMg != null) 'iron_mg': ironMg,
      if (vitaminB12Mcg != null) 'vitamin_b12_mcg': vitaminB12Mcg,
      if (vitaminD3Iu != null) 'vitamin_d3_iu': vitaminD3Iu,
      if (calciumMg != null) 'calcium_mg': calciumMg,
      if (magnesiumMg != null) 'magnesium_mg': magnesiumMg,
      if (zincMg != null) 'zinc_mg': zincMg,
      if (folateMcg != null) 'folate_mcg': folateMcg,
      if (omega3G != null) 'omega3_g': omega3G,
    });
  }

  MicronutrientLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? logDate,
    Value<double>? ironMg,
    Value<double>? vitaminB12Mcg,
    Value<double>? vitaminD3Iu,
    Value<double>? calciumMg,
    Value<double>? magnesiumMg,
    Value<double>? zincMg,
    Value<double>? folateMcg,
    Value<double>? omega3G,
  }) {
    return MicronutrientLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      ironMg: ironMg ?? this.ironMg,
      vitaminB12Mcg: vitaminB12Mcg ?? this.vitaminB12Mcg,
      vitaminD3Iu: vitaminD3Iu ?? this.vitaminD3Iu,
      calciumMg: calciumMg ?? this.calciumMg,
      magnesiumMg: magnesiumMg ?? this.magnesiumMg,
      zincMg: zincMg ?? this.zincMg,
      folateMcg: folateMcg ?? this.folateMcg,
      omega3G: omega3G ?? this.omega3G,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (ironMg.present) {
      map['iron_mg'] = Variable<double>(ironMg.value);
    }
    if (vitaminB12Mcg.present) {
      map['vitamin_b12_mcg'] = Variable<double>(vitaminB12Mcg.value);
    }
    if (vitaminD3Iu.present) {
      map['vitamin_d3_iu'] = Variable<double>(vitaminD3Iu.value);
    }
    if (calciumMg.present) {
      map['calcium_mg'] = Variable<double>(calciumMg.value);
    }
    if (magnesiumMg.present) {
      map['magnesium_mg'] = Variable<double>(magnesiumMg.value);
    }
    if (zincMg.present) {
      map['zinc_mg'] = Variable<double>(zincMg.value);
    }
    if (folateMcg.present) {
      map['folate_mcg'] = Variable<double>(folateMcg.value);
    }
    if (omega3G.present) {
      map['omega3_g'] = Variable<double>(omega3G.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MicronutrientLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('logDate: $logDate, ')
          ..write('ironMg: $ironMg, ')
          ..write('vitaminB12Mcg: $vitaminB12Mcg, ')
          ..write('vitaminD3Iu: $vitaminD3Iu, ')
          ..write('calciumMg: $calciumMg, ')
          ..write('magnesiumMg: $magnesiumMg, ')
          ..write('zincMg: $zincMg, ')
          ..write('folateMcg: $folateMcg, ')
          ..write('omega3G: $omega3G')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserScoresTable userScores = $UserScoresTable(this);
  late final $OrganizationAccountsTable organizationAccounts =
      $OrganizationAccountsTable(this);
  late final $EmployeeEnrollmentsTable employeeEnrollments =
      $EmployeeEnrollmentsTable(this);
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
  late final $MenstrualSymptomLogsTable menstrualSymptomLogs =
      $MenstrualSymptomLogsTable(this);
  late final $RecoveryLogsTable recoveryLogs = $RecoveryLogsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  late final $EscalationEventsTable escalationEvents = $EscalationEventsTable(
    this,
  );
  late final $StepLogsTable stepLogs = $StepLogsTable(this);
  late final $SleepLogsTable sleepLogs = $SleepLogsTable(this);
  late final $BpReadingsTable bpReadings = $BpReadingsTable(this);
  late final $GlucoseReadingsTable glucoseReadings = $GlucoseReadingsTable(
    this,
  );
  late final $FoodReferencesTable foodReferences = $FoodReferencesTable(this);
  late final $MicronutrientLogsTable micronutrientLogs =
      $MicronutrientLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    userScores,
    organizationAccounts,
    employeeEnrollments,
    waterLogs,
    syncQueueItems,
    deadLetterQueueItems,
    dailyIntelligencePackages,
    aICacheEntries,
    transformationMemories,
    cachedDietPlans,
    menstrualSymptomLogs,
    recoveryLogs,
    chatMessages,
    escalationEvents,
    stepLogs,
    sleepLogs,
    bpReadings,
    glucoseReadings,
    foodReferences,
    micronutrientLogs,
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
      Value<bool?> isCycleTrackingEnabled,
      Value<int?> averageCycleLength,
      Value<DateTime?> lastPeriodDate,
      Value<String> subscriptionTier,
      Value<double> monthlyGroceryBudgetInr,
      Value<String> nutritionPeriodizationPhase,
      Value<DateTime?> periodizationPhaseStartedAt,
      Value<int> timezoneOffsetMinutes,
      Value<int> preferredDIPHour,
      Value<bool> whatsAppOptIn,
      Value<String?> abhaHealthId,
      Value<String> preferredInputLanguage,
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
      Value<bool?> isCycleTrackingEnabled,
      Value<int?> averageCycleLength,
      Value<DateTime?> lastPeriodDate,
      Value<String> subscriptionTier,
      Value<double> monthlyGroceryBudgetInr,
      Value<String> nutritionPeriodizationPhase,
      Value<DateTime?> periodizationPhaseStartedAt,
      Value<int> timezoneOffsetMinutes,
      Value<int> preferredDIPHour,
      Value<bool> whatsAppOptIn,
      Value<String?> abhaHealthId,
      Value<String> preferredInputLanguage,
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

  ColumnFilters<bool> get isCycleTrackingEnabled => $composableBuilder(
    column: $table.isCycleTrackingEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageCycleLength => $composableBuilder(
    column: $table.averageCycleLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPeriodDate => $composableBuilder(
    column: $table.lastPeriodDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionTier => $composableBuilder(
    column: $table.subscriptionTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyGroceryBudgetInr => $composableBuilder(
    column: $table.monthlyGroceryBudgetInr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutritionPeriodizationPhase => $composableBuilder(
    column: $table.nutritionPeriodizationPhase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodizationPhaseStartedAt => $composableBuilder(
    column: $table.periodizationPhaseStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timezoneOffsetMinutes => $composableBuilder(
    column: $table.timezoneOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferredDIPHour => $composableBuilder(
    column: $table.preferredDIPHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get whatsAppOptIn => $composableBuilder(
    column: $table.whatsAppOptIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abhaHealthId => $composableBuilder(
    column: $table.abhaHealthId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredInputLanguage => $composableBuilder(
    column: $table.preferredInputLanguage,
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

  ColumnOrderings<bool> get isCycleTrackingEnabled => $composableBuilder(
    column: $table.isCycleTrackingEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageCycleLength => $composableBuilder(
    column: $table.averageCycleLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPeriodDate => $composableBuilder(
    column: $table.lastPeriodDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionTier => $composableBuilder(
    column: $table.subscriptionTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyGroceryBudgetInr => $composableBuilder(
    column: $table.monthlyGroceryBudgetInr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutritionPeriodizationPhase => $composableBuilder(
    column: $table.nutritionPeriodizationPhase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodizationPhaseStartedAt =>
      $composableBuilder(
        column: $table.periodizationPhaseStartedAt,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get timezoneOffsetMinutes => $composableBuilder(
    column: $table.timezoneOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferredDIPHour => $composableBuilder(
    column: $table.preferredDIPHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get whatsAppOptIn => $composableBuilder(
    column: $table.whatsAppOptIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abhaHealthId => $composableBuilder(
    column: $table.abhaHealthId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredInputLanguage => $composableBuilder(
    column: $table.preferredInputLanguage,
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

  GeneratedColumn<bool> get isCycleTrackingEnabled => $composableBuilder(
    column: $table.isCycleTrackingEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get averageCycleLength => $composableBuilder(
    column: $table.averageCycleLength,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPeriodDate => $composableBuilder(
    column: $table.lastPeriodDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subscriptionTier => $composableBuilder(
    column: $table.subscriptionTier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monthlyGroceryBudgetInr => $composableBuilder(
    column: $table.monthlyGroceryBudgetInr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nutritionPeriodizationPhase => $composableBuilder(
    column: $table.nutritionPeriodizationPhase,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodizationPhaseStartedAt =>
      $composableBuilder(
        column: $table.periodizationPhaseStartedAt,
        builder: (column) => column,
      );

  GeneratedColumn<int> get timezoneOffsetMinutes => $composableBuilder(
    column: $table.timezoneOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preferredDIPHour => $composableBuilder(
    column: $table.preferredDIPHour,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get whatsAppOptIn => $composableBuilder(
    column: $table.whatsAppOptIn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get abhaHealthId => $composableBuilder(
    column: $table.abhaHealthId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredInputLanguage => $composableBuilder(
    column: $table.preferredInputLanguage,
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
                Value<bool?> isCycleTrackingEnabled = const Value.absent(),
                Value<int?> averageCycleLength = const Value.absent(),
                Value<DateTime?> lastPeriodDate = const Value.absent(),
                Value<String> subscriptionTier = const Value.absent(),
                Value<double> monthlyGroceryBudgetInr = const Value.absent(),
                Value<String> nutritionPeriodizationPhase =
                    const Value.absent(),
                Value<DateTime?> periodizationPhaseStartedAt =
                    const Value.absent(),
                Value<int> timezoneOffsetMinutes = const Value.absent(),
                Value<int> preferredDIPHour = const Value.absent(),
                Value<bool> whatsAppOptIn = const Value.absent(),
                Value<String?> abhaHealthId = const Value.absent(),
                Value<String> preferredInputLanguage = const Value.absent(),
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
                isCycleTrackingEnabled: isCycleTrackingEnabled,
                averageCycleLength: averageCycleLength,
                lastPeriodDate: lastPeriodDate,
                subscriptionTier: subscriptionTier,
                monthlyGroceryBudgetInr: monthlyGroceryBudgetInr,
                nutritionPeriodizationPhase: nutritionPeriodizationPhase,
                periodizationPhaseStartedAt: periodizationPhaseStartedAt,
                timezoneOffsetMinutes: timezoneOffsetMinutes,
                preferredDIPHour: preferredDIPHour,
                whatsAppOptIn: whatsAppOptIn,
                abhaHealthId: abhaHealthId,
                preferredInputLanguage: preferredInputLanguage,
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
                Value<bool?> isCycleTrackingEnabled = const Value.absent(),
                Value<int?> averageCycleLength = const Value.absent(),
                Value<DateTime?> lastPeriodDate = const Value.absent(),
                Value<String> subscriptionTier = const Value.absent(),
                Value<double> monthlyGroceryBudgetInr = const Value.absent(),
                Value<String> nutritionPeriodizationPhase =
                    const Value.absent(),
                Value<DateTime?> periodizationPhaseStartedAt =
                    const Value.absent(),
                Value<int> timezoneOffsetMinutes = const Value.absent(),
                Value<int> preferredDIPHour = const Value.absent(),
                Value<bool> whatsAppOptIn = const Value.absent(),
                Value<String?> abhaHealthId = const Value.absent(),
                Value<String> preferredInputLanguage = const Value.absent(),
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
                isCycleTrackingEnabled: isCycleTrackingEnabled,
                averageCycleLength: averageCycleLength,
                lastPeriodDate: lastPeriodDate,
                subscriptionTier: subscriptionTier,
                monthlyGroceryBudgetInr: monthlyGroceryBudgetInr,
                nutritionPeriodizationPhase: nutritionPeriodizationPhase,
                periodizationPhaseStartedAt: periodizationPhaseStartedAt,
                timezoneOffsetMinutes: timezoneOffsetMinutes,
                preferredDIPHour: preferredDIPHour,
                whatsAppOptIn: whatsAppOptIn,
                abhaHealthId: abhaHealthId,
                preferredInputLanguage: preferredInputLanguage,
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
typedef $$UserScoresTableCreateCompanionBuilder =
    UserScoresCompanion Function({
      required String localId,
      required String userId,
      required String scoreType,
      required double value,
      required DateTime computedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$UserScoresTableUpdateCompanionBuilder =
    UserScoresCompanion Function({
      Value<String> localId,
      Value<String> userId,
      Value<String> scoreType,
      Value<double> value,
      Value<DateTime> computedAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$UserScoresTableFilterComposer
    extends Composer<_$AppDatabase, $UserScoresTable> {
  $$UserScoresTableFilterComposer({
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

  ColumnFilters<String> get scoreType => $composableBuilder(
    column: $table.scoreType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $UserScoresTable> {
  $$UserScoresTableOrderingComposer({
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

  ColumnOrderings<String> get scoreType => $composableBuilder(
    column: $table.scoreType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserScoresTable> {
  $$UserScoresTableAnnotationComposer({
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

  GeneratedColumn<String> get scoreType =>
      $composableBuilder(column: $table.scoreType, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$UserScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserScoresTable,
          UserScore,
          $$UserScoresTableFilterComposer,
          $$UserScoresTableOrderingComposer,
          $$UserScoresTableAnnotationComposer,
          $$UserScoresTableCreateCompanionBuilder,
          $$UserScoresTableUpdateCompanionBuilder,
          (
            UserScore,
            BaseReferences<_$AppDatabase, $UserScoresTable, UserScore>,
          ),
          UserScore,
          PrefetchHooks Function()
        > {
  $$UserScoresTableTableManager(_$AppDatabase db, $UserScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> scoreType = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<DateTime> computedAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserScoresCompanion(
                localId: localId,
                userId: userId,
                scoreType: scoreType,
                value: value,
                computedAt: computedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String userId,
                required String scoreType,
                required double value,
                required DateTime computedAt,
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserScoresCompanion.insert(
                localId: localId,
                userId: userId,
                scoreType: scoreType,
                value: value,
                computedAt: computedAt,
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

typedef $$UserScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserScoresTable,
      UserScore,
      $$UserScoresTableFilterComposer,
      $$UserScoresTableOrderingComposer,
      $$UserScoresTableAnnotationComposer,
      $$UserScoresTableCreateCompanionBuilder,
      $$UserScoresTableUpdateCompanionBuilder,
      (UserScore, BaseReferences<_$AppDatabase, $UserScoresTable, UserScore>),
      UserScore,
      PrefetchHooks Function()
    >;
typedef $$OrganizationAccountsTableCreateCompanionBuilder =
    OrganizationAccountsCompanion Function({
      required String localId,
      Value<String?> azureId,
      required String organizationName,
      required String accountType,
      required String planTier,
      required int seatLimit,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$OrganizationAccountsTableUpdateCompanionBuilder =
    OrganizationAccountsCompanion Function({
      Value<String> localId,
      Value<String?> azureId,
      Value<String> organizationName,
      Value<String> accountType,
      Value<String> planTier,
      Value<int> seatLimit,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$OrganizationAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $OrganizationAccountsTable> {
  $$OrganizationAccountsTableFilterComposer({
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

  ColumnFilters<String> get azureId => $composableBuilder(
    column: $table.azureId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planTier => $composableBuilder(
    column: $table.planTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seatLimit => $composableBuilder(
    column: $table.seatLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrganizationAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrganizationAccountsTable> {
  $$OrganizationAccountsTableOrderingComposer({
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

  ColumnOrderings<String> get azureId => $composableBuilder(
    column: $table.azureId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planTier => $composableBuilder(
    column: $table.planTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seatLimit => $composableBuilder(
    column: $table.seatLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrganizationAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrganizationAccountsTable> {
  $$OrganizationAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get azureId =>
      $composableBuilder(column: $table.azureId, builder: (column) => column);

  GeneratedColumn<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planTier =>
      $composableBuilder(column: $table.planTier, builder: (column) => column);

  GeneratedColumn<int> get seatLimit =>
      $composableBuilder(column: $table.seatLimit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OrganizationAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrganizationAccountsTable,
          OrganizationAccount,
          $$OrganizationAccountsTableFilterComposer,
          $$OrganizationAccountsTableOrderingComposer,
          $$OrganizationAccountsTableAnnotationComposer,
          $$OrganizationAccountsTableCreateCompanionBuilder,
          $$OrganizationAccountsTableUpdateCompanionBuilder,
          (
            OrganizationAccount,
            BaseReferences<
              _$AppDatabase,
              $OrganizationAccountsTable,
              OrganizationAccount
            >,
          ),
          OrganizationAccount,
          PrefetchHooks Function()
        > {
  $$OrganizationAccountsTableTableManager(
    _$AppDatabase db,
    $OrganizationAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrganizationAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrganizationAccountsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OrganizationAccountsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> azureId = const Value.absent(),
                Value<String> organizationName = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String> planTier = const Value.absent(),
                Value<int> seatLimit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrganizationAccountsCompanion(
                localId: localId,
                azureId: azureId,
                organizationName: organizationName,
                accountType: accountType,
                planTier: planTier,
                seatLimit: seatLimit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                Value<String?> azureId = const Value.absent(),
                required String organizationName,
                required String accountType,
                required String planTier,
                required int seatLimit,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OrganizationAccountsCompanion.insert(
                localId: localId,
                azureId: azureId,
                organizationName: organizationName,
                accountType: accountType,
                planTier: planTier,
                seatLimit: seatLimit,
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

typedef $$OrganizationAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrganizationAccountsTable,
      OrganizationAccount,
      $$OrganizationAccountsTableFilterComposer,
      $$OrganizationAccountsTableOrderingComposer,
      $$OrganizationAccountsTableAnnotationComposer,
      $$OrganizationAccountsTableCreateCompanionBuilder,
      $$OrganizationAccountsTableUpdateCompanionBuilder,
      (
        OrganizationAccount,
        BaseReferences<
          _$AppDatabase,
          $OrganizationAccountsTable,
          OrganizationAccount
        >,
      ),
      OrganizationAccount,
      PrefetchHooks Function()
    >;
typedef $$EmployeeEnrollmentsTableCreateCompanionBuilder =
    EmployeeEnrollmentsCompanion Function({
      required String localId,
      required String userId,
      required String organizationId,
      required DateTime enrolledAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$EmployeeEnrollmentsTableUpdateCompanionBuilder =
    EmployeeEnrollmentsCompanion Function({
      Value<String> localId,
      Value<String> userId,
      Value<String> organizationId,
      Value<DateTime> enrolledAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$EmployeeEnrollmentsTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeEnrollmentsTable> {
  $$EmployeeEnrollmentsTableFilterComposer({
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

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enrolledAt => $composableBuilder(
    column: $table.enrolledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeeEnrollmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeEnrollmentsTable> {
  $$EmployeeEnrollmentsTableOrderingComposer({
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

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enrolledAt => $composableBuilder(
    column: $table.enrolledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeeEnrollmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeEnrollmentsTable> {
  $$EmployeeEnrollmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get enrolledAt => $composableBuilder(
    column: $table.enrolledAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$EmployeeEnrollmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeeEnrollmentsTable,
          EmployeeEnrollment,
          $$EmployeeEnrollmentsTableFilterComposer,
          $$EmployeeEnrollmentsTableOrderingComposer,
          $$EmployeeEnrollmentsTableAnnotationComposer,
          $$EmployeeEnrollmentsTableCreateCompanionBuilder,
          $$EmployeeEnrollmentsTableUpdateCompanionBuilder,
          (
            EmployeeEnrollment,
            BaseReferences<
              _$AppDatabase,
              $EmployeeEnrollmentsTable,
              EmployeeEnrollment
            >,
          ),
          EmployeeEnrollment,
          PrefetchHooks Function()
        > {
  $$EmployeeEnrollmentsTableTableManager(
    _$AppDatabase db,
    $EmployeeEnrollmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeEnrollmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeEnrollmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmployeeEnrollmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<DateTime> enrolledAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeEnrollmentsCompanion(
                localId: localId,
                userId: userId,
                organizationId: organizationId,
                enrolledAt: enrolledAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String userId,
                required String organizationId,
                required DateTime enrolledAt,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeEnrollmentsCompanion.insert(
                localId: localId,
                userId: userId,
                organizationId: organizationId,
                enrolledAt: enrolledAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeeEnrollmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeeEnrollmentsTable,
      EmployeeEnrollment,
      $$EmployeeEnrollmentsTableFilterComposer,
      $$EmployeeEnrollmentsTableOrderingComposer,
      $$EmployeeEnrollmentsTableAnnotationComposer,
      $$EmployeeEnrollmentsTableCreateCompanionBuilder,
      $$EmployeeEnrollmentsTableUpdateCompanionBuilder,
      (
        EmployeeEnrollment,
        BaseReferences<
          _$AppDatabase,
          $EmployeeEnrollmentsTable,
          EmployeeEnrollment
        >,
      ),
      EmployeeEnrollment,
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
typedef $$MenstrualSymptomLogsTableCreateCompanionBuilder =
    MenstrualSymptomLogsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime logDate,
      required bool hasMenstrualFlow,
      Value<double?> basalBodyTemperature,
      Value<bool?> positiveLhTest,
      required String physicalSymptoms,
      Value<int?> restingHeartRate,
      Value<double?> hrvMs,
    });
typedef $$MenstrualSymptomLogsTableUpdateCompanionBuilder =
    MenstrualSymptomLogsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> logDate,
      Value<bool> hasMenstrualFlow,
      Value<double?> basalBodyTemperature,
      Value<bool?> positiveLhTest,
      Value<String> physicalSymptoms,
      Value<int?> restingHeartRate,
      Value<double?> hrvMs,
    });

class $$MenstrualSymptomLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MenstrualSymptomLogsTable> {
  $$MenstrualSymptomLogsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasMenstrualFlow => $composableBuilder(
    column: $table.hasMenstrualFlow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basalBodyTemperature => $composableBuilder(
    column: $table.basalBodyTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get positiveLhTest => $composableBuilder(
    column: $table.positiveLhTest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get physicalSymptoms => $composableBuilder(
    column: $table.physicalSymptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrvMs => $composableBuilder(
    column: $table.hrvMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenstrualSymptomLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MenstrualSymptomLogsTable> {
  $$MenstrualSymptomLogsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasMenstrualFlow => $composableBuilder(
    column: $table.hasMenstrualFlow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basalBodyTemperature => $composableBuilder(
    column: $table.basalBodyTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get positiveLhTest => $composableBuilder(
    column: $table.positiveLhTest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get physicalSymptoms => $composableBuilder(
    column: $table.physicalSymptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrvMs => $composableBuilder(
    column: $table.hrvMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenstrualSymptomLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenstrualSymptomLogsTable> {
  $$MenstrualSymptomLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<bool> get hasMenstrualFlow => $composableBuilder(
    column: $table.hasMenstrualFlow,
    builder: (column) => column,
  );

  GeneratedColumn<double> get basalBodyTemperature => $composableBuilder(
    column: $table.basalBodyTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get positiveLhTest => $composableBuilder(
    column: $table.positiveLhTest,
    builder: (column) => column,
  );

  GeneratedColumn<String> get physicalSymptoms => $composableBuilder(
    column: $table.physicalSymptoms,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hrvMs =>
      $composableBuilder(column: $table.hrvMs, builder: (column) => column);
}

class $$MenstrualSymptomLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MenstrualSymptomLogsTable,
          MenstrualSymptomLog,
          $$MenstrualSymptomLogsTableFilterComposer,
          $$MenstrualSymptomLogsTableOrderingComposer,
          $$MenstrualSymptomLogsTableAnnotationComposer,
          $$MenstrualSymptomLogsTableCreateCompanionBuilder,
          $$MenstrualSymptomLogsTableUpdateCompanionBuilder,
          (
            MenstrualSymptomLog,
            BaseReferences<
              _$AppDatabase,
              $MenstrualSymptomLogsTable,
              MenstrualSymptomLog
            >,
          ),
          MenstrualSymptomLog,
          PrefetchHooks Function()
        > {
  $$MenstrualSymptomLogsTableTableManager(
    _$AppDatabase db,
    $MenstrualSymptomLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenstrualSymptomLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenstrualSymptomLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MenstrualSymptomLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<bool> hasMenstrualFlow = const Value.absent(),
                Value<double?> basalBodyTemperature = const Value.absent(),
                Value<bool?> positiveLhTest = const Value.absent(),
                Value<String> physicalSymptoms = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<double?> hrvMs = const Value.absent(),
              }) => MenstrualSymptomLogsCompanion(
                id: id,
                userId: userId,
                logDate: logDate,
                hasMenstrualFlow: hasMenstrualFlow,
                basalBodyTemperature: basalBodyTemperature,
                positiveLhTest: positiveLhTest,
                physicalSymptoms: physicalSymptoms,
                restingHeartRate: restingHeartRate,
                hrvMs: hrvMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime logDate,
                required bool hasMenstrualFlow,
                Value<double?> basalBodyTemperature = const Value.absent(),
                Value<bool?> positiveLhTest = const Value.absent(),
                required String physicalSymptoms,
                Value<int?> restingHeartRate = const Value.absent(),
                Value<double?> hrvMs = const Value.absent(),
              }) => MenstrualSymptomLogsCompanion.insert(
                id: id,
                userId: userId,
                logDate: logDate,
                hasMenstrualFlow: hasMenstrualFlow,
                basalBodyTemperature: basalBodyTemperature,
                positiveLhTest: positiveLhTest,
                physicalSymptoms: physicalSymptoms,
                restingHeartRate: restingHeartRate,
                hrvMs: hrvMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenstrualSymptomLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MenstrualSymptomLogsTable,
      MenstrualSymptomLog,
      $$MenstrualSymptomLogsTableFilterComposer,
      $$MenstrualSymptomLogsTableOrderingComposer,
      $$MenstrualSymptomLogsTableAnnotationComposer,
      $$MenstrualSymptomLogsTableCreateCompanionBuilder,
      $$MenstrualSymptomLogsTableUpdateCompanionBuilder,
      (
        MenstrualSymptomLog,
        BaseReferences<
          _$AppDatabase,
          $MenstrualSymptomLogsTable,
          MenstrualSymptomLog
        >,
      ),
      MenstrualSymptomLog,
      PrefetchHooks Function()
    >;
typedef $$RecoveryLogsTableCreateCompanionBuilder =
    RecoveryLogsCompanion Function({
      required String localId,
      required String userId,
      required DateTime logDate,
      required int readinessScore,
      required String confidenceTier,
      required int sleepQuality,
      required int sorenessLevel,
      required int stressLevel,
      required int energyLevel,
      Value<double?> restingHR,
      Value<double?> hrv,
      required String sorenessRegions,
      Value<int> sleepNeedMinutes,
      Value<int> sleepPerformanceScore,
      Value<double> dailyStrainScore,
      Value<String> illnessRiskStatus,
      required String prescribedActionsJson,
      required String recoveryDriversJson,
      required String syncStatus,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RecoveryLogsTableUpdateCompanionBuilder =
    RecoveryLogsCompanion Function({
      Value<String> localId,
      Value<String> userId,
      Value<DateTime> logDate,
      Value<int> readinessScore,
      Value<String> confidenceTier,
      Value<int> sleepQuality,
      Value<int> sorenessLevel,
      Value<int> stressLevel,
      Value<int> energyLevel,
      Value<double?> restingHR,
      Value<double?> hrv,
      Value<String> sorenessRegions,
      Value<int> sleepNeedMinutes,
      Value<int> sleepPerformanceScore,
      Value<double> dailyStrainScore,
      Value<String> illnessRiskStatus,
      Value<String> prescribedActionsJson,
      Value<String> recoveryDriversJson,
      Value<String> syncStatus,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RecoveryLogsTableFilterComposer
    extends Composer<_$AppDatabase, $RecoveryLogsTable> {
  $$RecoveryLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidenceTier => $composableBuilder(
    column: $table.confidenceTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sorenessLevel => $composableBuilder(
    column: $table.sorenessLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get restingHR => $composableBuilder(
    column: $table.restingHR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrv => $composableBuilder(
    column: $table.hrv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sorenessRegions => $composableBuilder(
    column: $table.sorenessRegions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepNeedMinutes => $composableBuilder(
    column: $table.sleepNeedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepPerformanceScore => $composableBuilder(
    column: $table.sleepPerformanceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyStrainScore => $composableBuilder(
    column: $table.dailyStrainScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illnessRiskStatus => $composableBuilder(
    column: $table.illnessRiskStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prescribedActionsJson => $composableBuilder(
    column: $table.prescribedActionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recoveryDriversJson => $composableBuilder(
    column: $table.recoveryDriversJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecoveryLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecoveryLogsTable> {
  $$RecoveryLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidenceTier => $composableBuilder(
    column: $table.confidenceTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sorenessLevel => $composableBuilder(
    column: $table.sorenessLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get restingHR => $composableBuilder(
    column: $table.restingHR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrv => $composableBuilder(
    column: $table.hrv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sorenessRegions => $composableBuilder(
    column: $table.sorenessRegions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepNeedMinutes => $composableBuilder(
    column: $table.sleepNeedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepPerformanceScore => $composableBuilder(
    column: $table.sleepPerformanceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyStrainScore => $composableBuilder(
    column: $table.dailyStrainScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illnessRiskStatus => $composableBuilder(
    column: $table.illnessRiskStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prescribedActionsJson => $composableBuilder(
    column: $table.prescribedActionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recoveryDriversJson => $composableBuilder(
    column: $table.recoveryDriversJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecoveryLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecoveryLogsTable> {
  $$RecoveryLogsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<int> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidenceTier => $composableBuilder(
    column: $table.confidenceTier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sorenessLevel => $composableBuilder(
    column: $table.sorenessLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get restingHR =>
      $composableBuilder(column: $table.restingHR, builder: (column) => column);

  GeneratedColumn<double> get hrv =>
      $composableBuilder(column: $table.hrv, builder: (column) => column);

  GeneratedColumn<String> get sorenessRegions => $composableBuilder(
    column: $table.sorenessRegions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepNeedMinutes => $composableBuilder(
    column: $table.sleepNeedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepPerformanceScore => $composableBuilder(
    column: $table.sleepPerformanceScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dailyStrainScore => $composableBuilder(
    column: $table.dailyStrainScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get illnessRiskStatus => $composableBuilder(
    column: $table.illnessRiskStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prescribedActionsJson => $composableBuilder(
    column: $table.prescribedActionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recoveryDriversJson => $composableBuilder(
    column: $table.recoveryDriversJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecoveryLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecoveryLogsTable,
          RecoveryLog,
          $$RecoveryLogsTableFilterComposer,
          $$RecoveryLogsTableOrderingComposer,
          $$RecoveryLogsTableAnnotationComposer,
          $$RecoveryLogsTableCreateCompanionBuilder,
          $$RecoveryLogsTableUpdateCompanionBuilder,
          (
            RecoveryLog,
            BaseReferences<_$AppDatabase, $RecoveryLogsTable, RecoveryLog>,
          ),
          RecoveryLog,
          PrefetchHooks Function()
        > {
  $$RecoveryLogsTableTableManager(_$AppDatabase db, $RecoveryLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecoveryLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecoveryLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecoveryLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<int> readinessScore = const Value.absent(),
                Value<String> confidenceTier = const Value.absent(),
                Value<int> sleepQuality = const Value.absent(),
                Value<int> sorenessLevel = const Value.absent(),
                Value<int> stressLevel = const Value.absent(),
                Value<int> energyLevel = const Value.absent(),
                Value<double?> restingHR = const Value.absent(),
                Value<double?> hrv = const Value.absent(),
                Value<String> sorenessRegions = const Value.absent(),
                Value<int> sleepNeedMinutes = const Value.absent(),
                Value<int> sleepPerformanceScore = const Value.absent(),
                Value<double> dailyStrainScore = const Value.absent(),
                Value<String> illnessRiskStatus = const Value.absent(),
                Value<String> prescribedActionsJson = const Value.absent(),
                Value<String> recoveryDriversJson = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecoveryLogsCompanion(
                localId: localId,
                userId: userId,
                logDate: logDate,
                readinessScore: readinessScore,
                confidenceTier: confidenceTier,
                sleepQuality: sleepQuality,
                sorenessLevel: sorenessLevel,
                stressLevel: stressLevel,
                energyLevel: energyLevel,
                restingHR: restingHR,
                hrv: hrv,
                sorenessRegions: sorenessRegions,
                sleepNeedMinutes: sleepNeedMinutes,
                sleepPerformanceScore: sleepPerformanceScore,
                dailyStrainScore: dailyStrainScore,
                illnessRiskStatus: illnessRiskStatus,
                prescribedActionsJson: prescribedActionsJson,
                recoveryDriversJson: recoveryDriversJson,
                syncStatus: syncStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String userId,
                required DateTime logDate,
                required int readinessScore,
                required String confidenceTier,
                required int sleepQuality,
                required int sorenessLevel,
                required int stressLevel,
                required int energyLevel,
                Value<double?> restingHR = const Value.absent(),
                Value<double?> hrv = const Value.absent(),
                required String sorenessRegions,
                Value<int> sleepNeedMinutes = const Value.absent(),
                Value<int> sleepPerformanceScore = const Value.absent(),
                Value<double> dailyStrainScore = const Value.absent(),
                Value<String> illnessRiskStatus = const Value.absent(),
                required String prescribedActionsJson,
                required String recoveryDriversJson,
                required String syncStatus,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RecoveryLogsCompanion.insert(
                localId: localId,
                userId: userId,
                logDate: logDate,
                readinessScore: readinessScore,
                confidenceTier: confidenceTier,
                sleepQuality: sleepQuality,
                sorenessLevel: sorenessLevel,
                stressLevel: stressLevel,
                energyLevel: energyLevel,
                restingHR: restingHR,
                hrv: hrv,
                sorenessRegions: sorenessRegions,
                sleepNeedMinutes: sleepNeedMinutes,
                sleepPerformanceScore: sleepPerformanceScore,
                dailyStrainScore: dailyStrainScore,
                illnessRiskStatus: illnessRiskStatus,
                prescribedActionsJson: prescribedActionsJson,
                recoveryDriversJson: recoveryDriversJson,
                syncStatus: syncStatus,
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

typedef $$RecoveryLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecoveryLogsTable,
      RecoveryLog,
      $$RecoveryLogsTableFilterComposer,
      $$RecoveryLogsTableOrderingComposer,
      $$RecoveryLogsTableAnnotationComposer,
      $$RecoveryLogsTableCreateCompanionBuilder,
      $$RecoveryLogsTableUpdateCompanionBuilder,
      (
        RecoveryLog,
        BaseReferences<_$AppDatabase, $RecoveryLogsTable, RecoveryLog>,
      ),
      RecoveryLog,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      required String conversationId,
      required String senderType,
      required String messageContent,
      required DateTime createdAt,
      Value<String?> sourcesJson,
      Value<String?> localAttachmentPath,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      Value<String> conversationId,
      Value<String> senderType,
      Value<String> messageContent,
      Value<DateTime> createdAt,
      Value<String?> sourcesJson,
      Value<String?> localAttachmentPath,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
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

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderType => $composableBuilder(
    column: $table.senderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageContent => $composableBuilder(
    column: $table.messageContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localAttachmentPath => $composableBuilder(
    column: $table.localAttachmentPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderType => $composableBuilder(
    column: $table.senderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageContent => $composableBuilder(
    column: $table.messageContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localAttachmentPath => $composableBuilder(
    column: $table.localAttachmentPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderType => $composableBuilder(
    column: $table.senderType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageContent => $composableBuilder(
    column: $table.messageContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get sourcesJson => $composableBuilder(
    column: $table.sourcesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localAttachmentPath => $composableBuilder(
    column: $table.localAttachmentPath,
    builder: (column) => column,
  );
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessage,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessage,
            BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
          ),
          ChatMessage,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> senderType = const Value.absent(),
                Value<String> messageContent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> sourcesJson = const Value.absent(),
                Value<String?> localAttachmentPath = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                conversationId: conversationId,
                senderType: senderType,
                messageContent: messageContent,
                createdAt: createdAt,
                sourcesJson: sourcesJson,
                localAttachmentPath: localAttachmentPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String conversationId,
                required String senderType,
                required String messageContent,
                required DateTime createdAt,
                Value<String?> sourcesJson = const Value.absent(),
                Value<String?> localAttachmentPath = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                senderType: senderType,
                messageContent: messageContent,
                createdAt: createdAt,
                sourcesJson: sourcesJson,
                localAttachmentPath: localAttachmentPath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessage,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessage,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage>,
      ),
      ChatMessage,
      PrefetchHooks Function()
    >;
typedef $$EscalationEventsTableCreateCompanionBuilder =
    EscalationEventsCompanion Function({
      Value<int> id,
      required String userId,
      required String reason,
      required String briefing,
      required DateTime escalatedAt,
      Value<DateTime?> resolvedAt,
    });
typedef $$EscalationEventsTableUpdateCompanionBuilder =
    EscalationEventsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> reason,
      Value<String> briefing,
      Value<DateTime> escalatedAt,
      Value<DateTime?> resolvedAt,
    });

class $$EscalationEventsTableFilterComposer
    extends Composer<_$AppDatabase, $EscalationEventsTable> {
  $$EscalationEventsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get briefing => $composableBuilder(
    column: $table.briefing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get escalatedAt => $composableBuilder(
    column: $table.escalatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EscalationEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EscalationEventsTable> {
  $$EscalationEventsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get briefing => $composableBuilder(
    column: $table.briefing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get escalatedAt => $composableBuilder(
    column: $table.escalatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EscalationEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EscalationEventsTable> {
  $$EscalationEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get briefing =>
      $composableBuilder(column: $table.briefing, builder: (column) => column);

  GeneratedColumn<DateTime> get escalatedAt => $composableBuilder(
    column: $table.escalatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$EscalationEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EscalationEventsTable,
          EscalationEvent,
          $$EscalationEventsTableFilterComposer,
          $$EscalationEventsTableOrderingComposer,
          $$EscalationEventsTableAnnotationComposer,
          $$EscalationEventsTableCreateCompanionBuilder,
          $$EscalationEventsTableUpdateCompanionBuilder,
          (
            EscalationEvent,
            BaseReferences<
              _$AppDatabase,
              $EscalationEventsTable,
              EscalationEvent
            >,
          ),
          EscalationEvent,
          PrefetchHooks Function()
        > {
  $$EscalationEventsTableTableManager(
    _$AppDatabase db,
    $EscalationEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EscalationEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EscalationEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EscalationEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> briefing = const Value.absent(),
                Value<DateTime> escalatedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => EscalationEventsCompanion(
                id: id,
                userId: userId,
                reason: reason,
                briefing: briefing,
                escalatedAt: escalatedAt,
                resolvedAt: resolvedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String reason,
                required String briefing,
                required DateTime escalatedAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
              }) => EscalationEventsCompanion.insert(
                id: id,
                userId: userId,
                reason: reason,
                briefing: briefing,
                escalatedAt: escalatedAt,
                resolvedAt: resolvedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EscalationEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EscalationEventsTable,
      EscalationEvent,
      $$EscalationEventsTableFilterComposer,
      $$EscalationEventsTableOrderingComposer,
      $$EscalationEventsTableAnnotationComposer,
      $$EscalationEventsTableCreateCompanionBuilder,
      $$EscalationEventsTableUpdateCompanionBuilder,
      (
        EscalationEvent,
        BaseReferences<_$AppDatabase, $EscalationEventsTable, EscalationEvent>,
      ),
      EscalationEvent,
      PrefetchHooks Function()
    >;
typedef $$StepLogsTableCreateCompanionBuilder =
    StepLogsCompanion Function({
      Value<int> id,
      required int steps,
      required String syncBatchId,
      required DateTime loggedAt,
      required DateTime hlcPhysicalTime,
      required int hlcLogicalCounter,
      required String hlcNodeId,
    });
typedef $$StepLogsTableUpdateCompanionBuilder =
    StepLogsCompanion Function({
      Value<int> id,
      Value<int> steps,
      Value<String> syncBatchId,
      Value<DateTime> loggedAt,
      Value<DateTime> hlcPhysicalTime,
      Value<int> hlcLogicalCounter,
      Value<String> hlcNodeId,
    });

class $$StepLogsTableFilterComposer
    extends Composer<_$AppDatabase, $StepLogsTable> {
  $$StepLogsTableFilterComposer({
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

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
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

class $$StepLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $StepLogsTable> {
  $$StepLogsTableOrderingComposer({
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

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
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

class $$StepLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StepLogsTable> {
  $$StepLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

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

class $$StepLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepLogsTable,
          StepLog,
          $$StepLogsTableFilterComposer,
          $$StepLogsTableOrderingComposer,
          $$StepLogsTableAnnotationComposer,
          $$StepLogsTableCreateCompanionBuilder,
          $$StepLogsTableUpdateCompanionBuilder,
          (StepLog, BaseReferences<_$AppDatabase, $StepLogsTable, StepLog>),
          StepLog,
          PrefetchHooks Function()
        > {
  $$StepLogsTableTableManager(_$AppDatabase db, $StepLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<String> syncBatchId = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<DateTime> hlcPhysicalTime = const Value.absent(),
                Value<int> hlcLogicalCounter = const Value.absent(),
                Value<String> hlcNodeId = const Value.absent(),
              }) => StepLogsCompanion(
                id: id,
                steps: steps,
                syncBatchId: syncBatchId,
                loggedAt: loggedAt,
                hlcPhysicalTime: hlcPhysicalTime,
                hlcLogicalCounter: hlcLogicalCounter,
                hlcNodeId: hlcNodeId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int steps,
                required String syncBatchId,
                required DateTime loggedAt,
                required DateTime hlcPhysicalTime,
                required int hlcLogicalCounter,
                required String hlcNodeId,
              }) => StepLogsCompanion.insert(
                id: id,
                steps: steps,
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

typedef $$StepLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepLogsTable,
      StepLog,
      $$StepLogsTableFilterComposer,
      $$StepLogsTableOrderingComposer,
      $$StepLogsTableAnnotationComposer,
      $$StepLogsTableCreateCompanionBuilder,
      $$StepLogsTableUpdateCompanionBuilder,
      (StepLog, BaseReferences<_$AppDatabase, $StepLogsTable, StepLog>),
      StepLog,
      PrefetchHooks Function()
    >;
typedef $$SleepLogsTableCreateCompanionBuilder =
    SleepLogsCompanion Function({
      Value<int> id,
      required String userId,
      required int sleepMinutes,
      required int awakeMinutes,
      required int remMinutes,
      required int lightMinutes,
      required int deepMinutes,
      required int sleepQuality,
      required double hrvMs,
      required DateTime sleepDate,
      required String syncBatchId,
      required DateTime hlcPhysicalTime,
      required int hlcLogicalCounter,
      required String hlcNodeId,
    });
typedef $$SleepLogsTableUpdateCompanionBuilder =
    SleepLogsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<int> sleepMinutes,
      Value<int> awakeMinutes,
      Value<int> remMinutes,
      Value<int> lightMinutes,
      Value<int> deepMinutes,
      Value<int> sleepQuality,
      Value<double> hrvMs,
      Value<DateTime> sleepDate,
      Value<String> syncBatchId,
      Value<DateTime> hlcPhysicalTime,
      Value<int> hlcLogicalCounter,
      Value<String> hlcNodeId,
    });

class $$SleepLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepMinutes => $composableBuilder(
    column: $table.sleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awakeMinutes => $composableBuilder(
    column: $table.awakeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remMinutes => $composableBuilder(
    column: $table.remMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lightMinutes => $composableBuilder(
    column: $table.lightMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deepMinutes => $composableBuilder(
    column: $table.deepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hrvMs => $composableBuilder(
    column: $table.hrvMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sleepDate => $composableBuilder(
    column: $table.sleepDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
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

class $$SleepLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepMinutes => $composableBuilder(
    column: $table.sleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awakeMinutes => $composableBuilder(
    column: $table.awakeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remMinutes => $composableBuilder(
    column: $table.remMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lightMinutes => $composableBuilder(
    column: $table.lightMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deepMinutes => $composableBuilder(
    column: $table.deepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hrvMs => $composableBuilder(
    column: $table.hrvMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sleepDate => $composableBuilder(
    column: $table.sleepDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
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

class $$SleepLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepLogsTable> {
  $$SleepLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get sleepMinutes => $composableBuilder(
    column: $table.sleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awakeMinutes => $composableBuilder(
    column: $table.awakeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remMinutes => $composableBuilder(
    column: $table.remMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lightMinutes => $composableBuilder(
    column: $table.lightMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deepMinutes => $composableBuilder(
    column: $table.deepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hrvMs =>
      $composableBuilder(column: $table.hrvMs, builder: (column) => column);

  GeneratedColumn<DateTime> get sleepDate =>
      $composableBuilder(column: $table.sleepDate, builder: (column) => column);

  GeneratedColumn<String> get syncBatchId => $composableBuilder(
    column: $table.syncBatchId,
    builder: (column) => column,
  );

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

class $$SleepLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepLogsTable,
          SleepLog,
          $$SleepLogsTableFilterComposer,
          $$SleepLogsTableOrderingComposer,
          $$SleepLogsTableAnnotationComposer,
          $$SleepLogsTableCreateCompanionBuilder,
          $$SleepLogsTableUpdateCompanionBuilder,
          (SleepLog, BaseReferences<_$AppDatabase, $SleepLogsTable, SleepLog>),
          SleepLog,
          PrefetchHooks Function()
        > {
  $$SleepLogsTableTableManager(_$AppDatabase db, $SleepLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> sleepMinutes = const Value.absent(),
                Value<int> awakeMinutes = const Value.absent(),
                Value<int> remMinutes = const Value.absent(),
                Value<int> lightMinutes = const Value.absent(),
                Value<int> deepMinutes = const Value.absent(),
                Value<int> sleepQuality = const Value.absent(),
                Value<double> hrvMs = const Value.absent(),
                Value<DateTime> sleepDate = const Value.absent(),
                Value<String> syncBatchId = const Value.absent(),
                Value<DateTime> hlcPhysicalTime = const Value.absent(),
                Value<int> hlcLogicalCounter = const Value.absent(),
                Value<String> hlcNodeId = const Value.absent(),
              }) => SleepLogsCompanion(
                id: id,
                userId: userId,
                sleepMinutes: sleepMinutes,
                awakeMinutes: awakeMinutes,
                remMinutes: remMinutes,
                lightMinutes: lightMinutes,
                deepMinutes: deepMinutes,
                sleepQuality: sleepQuality,
                hrvMs: hrvMs,
                sleepDate: sleepDate,
                syncBatchId: syncBatchId,
                hlcPhysicalTime: hlcPhysicalTime,
                hlcLogicalCounter: hlcLogicalCounter,
                hlcNodeId: hlcNodeId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required int sleepMinutes,
                required int awakeMinutes,
                required int remMinutes,
                required int lightMinutes,
                required int deepMinutes,
                required int sleepQuality,
                required double hrvMs,
                required DateTime sleepDate,
                required String syncBatchId,
                required DateTime hlcPhysicalTime,
                required int hlcLogicalCounter,
                required String hlcNodeId,
              }) => SleepLogsCompanion.insert(
                id: id,
                userId: userId,
                sleepMinutes: sleepMinutes,
                awakeMinutes: awakeMinutes,
                remMinutes: remMinutes,
                lightMinutes: lightMinutes,
                deepMinutes: deepMinutes,
                sleepQuality: sleepQuality,
                hrvMs: hrvMs,
                sleepDate: sleepDate,
                syncBatchId: syncBatchId,
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

typedef $$SleepLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepLogsTable,
      SleepLog,
      $$SleepLogsTableFilterComposer,
      $$SleepLogsTableOrderingComposer,
      $$SleepLogsTableAnnotationComposer,
      $$SleepLogsTableCreateCompanionBuilder,
      $$SleepLogsTableUpdateCompanionBuilder,
      (SleepLog, BaseReferences<_$AppDatabase, $SleepLogsTable, SleepLog>),
      SleepLog,
      PrefetchHooks Function()
    >;
typedef $$BpReadingsTableCreateCompanionBuilder =
    BpReadingsCompanion Function({
      Value<int> id,
      required int systolic,
      required int diastolic,
      required DateTime measuredAt,
      required String recordingMethod,
    });
typedef $$BpReadingsTableUpdateCompanionBuilder =
    BpReadingsCompanion Function({
      Value<int> id,
      Value<int> systolic,
      Value<int> diastolic,
      Value<DateTime> measuredAt,
      Value<String> recordingMethod,
    });

class $$BpReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $BpReadingsTable> {
  $$BpReadingsTableFilterComposer({
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

  ColumnFilters<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordingMethod => $composableBuilder(
    column: $table.recordingMethod,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BpReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BpReadingsTable> {
  $$BpReadingsTableOrderingComposer({
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

  ColumnOrderings<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordingMethod => $composableBuilder(
    column: $table.recordingMethod,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BpReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BpReadingsTable> {
  $$BpReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<int> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordingMethod => $composableBuilder(
    column: $table.recordingMethod,
    builder: (column) => column,
  );
}

class $$BpReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BpReadingsTable,
          BpReading,
          $$BpReadingsTableFilterComposer,
          $$BpReadingsTableOrderingComposer,
          $$BpReadingsTableAnnotationComposer,
          $$BpReadingsTableCreateCompanionBuilder,
          $$BpReadingsTableUpdateCompanionBuilder,
          (
            BpReading,
            BaseReferences<_$AppDatabase, $BpReadingsTable, BpReading>,
          ),
          BpReading,
          PrefetchHooks Function()
        > {
  $$BpReadingsTableTableManager(_$AppDatabase db, $BpReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BpReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BpReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BpReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> systolic = const Value.absent(),
                Value<int> diastolic = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<String> recordingMethod = const Value.absent(),
              }) => BpReadingsCompanion(
                id: id,
                systolic: systolic,
                diastolic: diastolic,
                measuredAt: measuredAt,
                recordingMethod: recordingMethod,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int systolic,
                required int diastolic,
                required DateTime measuredAt,
                required String recordingMethod,
              }) => BpReadingsCompanion.insert(
                id: id,
                systolic: systolic,
                diastolic: diastolic,
                measuredAt: measuredAt,
                recordingMethod: recordingMethod,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BpReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BpReadingsTable,
      BpReading,
      $$BpReadingsTableFilterComposer,
      $$BpReadingsTableOrderingComposer,
      $$BpReadingsTableAnnotationComposer,
      $$BpReadingsTableCreateCompanionBuilder,
      $$BpReadingsTableUpdateCompanionBuilder,
      (BpReading, BaseReferences<_$AppDatabase, $BpReadingsTable, BpReading>),
      BpReading,
      PrefetchHooks Function()
    >;
typedef $$GlucoseReadingsTableCreateCompanionBuilder =
    GlucoseReadingsCompanion Function({
      Value<int> id,
      required double glucoseValue,
      required String mealTag,
      required DateTime measuredAt,
    });
typedef $$GlucoseReadingsTableUpdateCompanionBuilder =
    GlucoseReadingsCompanion Function({
      Value<int> id,
      Value<double> glucoseValue,
      Value<String> mealTag,
      Value<DateTime> measuredAt,
    });

class $$GlucoseReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $GlucoseReadingsTable> {
  $$GlucoseReadingsTableFilterComposer({
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

  ColumnFilters<double> get glucoseValue => $composableBuilder(
    column: $table.glucoseValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealTag => $composableBuilder(
    column: $table.mealTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GlucoseReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $GlucoseReadingsTable> {
  $$GlucoseReadingsTableOrderingComposer({
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

  ColumnOrderings<double> get glucoseValue => $composableBuilder(
    column: $table.glucoseValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealTag => $composableBuilder(
    column: $table.mealTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GlucoseReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GlucoseReadingsTable> {
  $$GlucoseReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get glucoseValue => $composableBuilder(
    column: $table.glucoseValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealTag =>
      $composableBuilder(column: $table.mealTag, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );
}

class $$GlucoseReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GlucoseReadingsTable,
          GlucoseReading,
          $$GlucoseReadingsTableFilterComposer,
          $$GlucoseReadingsTableOrderingComposer,
          $$GlucoseReadingsTableAnnotationComposer,
          $$GlucoseReadingsTableCreateCompanionBuilder,
          $$GlucoseReadingsTableUpdateCompanionBuilder,
          (
            GlucoseReading,
            BaseReferences<
              _$AppDatabase,
              $GlucoseReadingsTable,
              GlucoseReading
            >,
          ),
          GlucoseReading,
          PrefetchHooks Function()
        > {
  $$GlucoseReadingsTableTableManager(
    _$AppDatabase db,
    $GlucoseReadingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GlucoseReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GlucoseReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GlucoseReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> glucoseValue = const Value.absent(),
                Value<String> mealTag = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
              }) => GlucoseReadingsCompanion(
                id: id,
                glucoseValue: glucoseValue,
                mealTag: mealTag,
                measuredAt: measuredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double glucoseValue,
                required String mealTag,
                required DateTime measuredAt,
              }) => GlucoseReadingsCompanion.insert(
                id: id,
                glucoseValue: glucoseValue,
                mealTag: mealTag,
                measuredAt: measuredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GlucoseReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GlucoseReadingsTable,
      GlucoseReading,
      $$GlucoseReadingsTableFilterComposer,
      $$GlucoseReadingsTableOrderingComposer,
      $$GlucoseReadingsTableAnnotationComposer,
      $$GlucoseReadingsTableCreateCompanionBuilder,
      $$GlucoseReadingsTableUpdateCompanionBuilder,
      (
        GlucoseReading,
        BaseReferences<_$AppDatabase, $GlucoseReadingsTable, GlucoseReading>,
      ),
      GlucoseReading,
      PrefetchHooks Function()
    >;
typedef $$FoodReferencesTableCreateCompanionBuilder =
    FoodReferencesCompanion Function({
      required String id,
      required String foodName,
      required double defaultServingG,
      required String servingDescription,
      required double calories,
      required double proteinG,
      required double carbsG,
      required double fatG,
      required int glycemicIndex,
      required double fiberG,
      required int satietyIndex,
      required String searchTerms,
      Value<int> rowid,
    });
typedef $$FoodReferencesTableUpdateCompanionBuilder =
    FoodReferencesCompanion Function({
      Value<String> id,
      Value<String> foodName,
      Value<double> defaultServingG,
      Value<String> servingDescription,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<int> glycemicIndex,
      Value<double> fiberG,
      Value<int> satietyIndex,
      Value<String> searchTerms,
      Value<int> rowid,
    });

class $$FoodReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $FoodReferencesTable> {
  $$FoodReferencesTableFilterComposer({
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

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get glycemicIndex => $composableBuilder(
    column: $table.glycemicIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get satietyIndex => $composableBuilder(
    column: $table.satietyIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchTerms => $composableBuilder(
    column: $table.searchTerms,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodReferencesTable> {
  $$FoodReferencesTableOrderingComposer({
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

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get glycemicIndex => $composableBuilder(
    column: $table.glycemicIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberG => $composableBuilder(
    column: $table.fiberG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get satietyIndex => $composableBuilder(
    column: $table.satietyIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchTerms => $composableBuilder(
    column: $table.searchTerms,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodReferencesTable> {
  $$FoodReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingDescription => $composableBuilder(
    column: $table.servingDescription,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<int> get glycemicIndex => $composableBuilder(
    column: $table.glycemicIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberG =>
      $composableBuilder(column: $table.fiberG, builder: (column) => column);

  GeneratedColumn<int> get satietyIndex => $composableBuilder(
    column: $table.satietyIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get searchTerms => $composableBuilder(
    column: $table.searchTerms,
    builder: (column) => column,
  );
}

class $$FoodReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodReferencesTable,
          FoodReference,
          $$FoodReferencesTableFilterComposer,
          $$FoodReferencesTableOrderingComposer,
          $$FoodReferencesTableAnnotationComposer,
          $$FoodReferencesTableCreateCompanionBuilder,
          $$FoodReferencesTableUpdateCompanionBuilder,
          (
            FoodReference,
            BaseReferences<_$AppDatabase, $FoodReferencesTable, FoodReference>,
          ),
          FoodReference,
          PrefetchHooks Function()
        > {
  $$FoodReferencesTableTableManager(
    _$AppDatabase db,
    $FoodReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodReferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<double> defaultServingG = const Value.absent(),
                Value<String> servingDescription = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<int> glycemicIndex = const Value.absent(),
                Value<double> fiberG = const Value.absent(),
                Value<int> satietyIndex = const Value.absent(),
                Value<String> searchTerms = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodReferencesCompanion(
                id: id,
                foodName: foodName,
                defaultServingG: defaultServingG,
                servingDescription: servingDescription,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                glycemicIndex: glycemicIndex,
                fiberG: fiberG,
                satietyIndex: satietyIndex,
                searchTerms: searchTerms,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String foodName,
                required double defaultServingG,
                required String servingDescription,
                required double calories,
                required double proteinG,
                required double carbsG,
                required double fatG,
                required int glycemicIndex,
                required double fiberG,
                required int satietyIndex,
                required String searchTerms,
                Value<int> rowid = const Value.absent(),
              }) => FoodReferencesCompanion.insert(
                id: id,
                foodName: foodName,
                defaultServingG: defaultServingG,
                servingDescription: servingDescription,
                calories: calories,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                glycemicIndex: glycemicIndex,
                fiberG: fiberG,
                satietyIndex: satietyIndex,
                searchTerms: searchTerms,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodReferencesTable,
      FoodReference,
      $$FoodReferencesTableFilterComposer,
      $$FoodReferencesTableOrderingComposer,
      $$FoodReferencesTableAnnotationComposer,
      $$FoodReferencesTableCreateCompanionBuilder,
      $$FoodReferencesTableUpdateCompanionBuilder,
      (
        FoodReference,
        BaseReferences<_$AppDatabase, $FoodReferencesTable, FoodReference>,
      ),
      FoodReference,
      PrefetchHooks Function()
    >;
typedef $$MicronutrientLogsTableCreateCompanionBuilder =
    MicronutrientLogsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime logDate,
      Value<double> ironMg,
      Value<double> vitaminB12Mcg,
      Value<double> vitaminD3Iu,
      Value<double> calciumMg,
      Value<double> magnesiumMg,
      Value<double> zincMg,
      Value<double> folateMcg,
      Value<double> omega3G,
    });
typedef $$MicronutrientLogsTableUpdateCompanionBuilder =
    MicronutrientLogsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> logDate,
      Value<double> ironMg,
      Value<double> vitaminB12Mcg,
      Value<double> vitaminD3Iu,
      Value<double> calciumMg,
      Value<double> magnesiumMg,
      Value<double> zincMg,
      Value<double> folateMcg,
      Value<double> omega3G,
    });

class $$MicronutrientLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MicronutrientLogsTable> {
  $$MicronutrientLogsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ironMg => $composableBuilder(
    column: $table.ironMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vitaminB12Mcg => $composableBuilder(
    column: $table.vitaminB12Mcg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vitaminD3Iu => $composableBuilder(
    column: $table.vitaminD3Iu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calciumMg => $composableBuilder(
    column: $table.calciumMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get magnesiumMg => $composableBuilder(
    column: $table.magnesiumMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get zincMg => $composableBuilder(
    column: $table.zincMg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get folateMcg => $composableBuilder(
    column: $table.folateMcg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get omega3G => $composableBuilder(
    column: $table.omega3G,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MicronutrientLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MicronutrientLogsTable> {
  $$MicronutrientLogsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ironMg => $composableBuilder(
    column: $table.ironMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vitaminB12Mcg => $composableBuilder(
    column: $table.vitaminB12Mcg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vitaminD3Iu => $composableBuilder(
    column: $table.vitaminD3Iu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calciumMg => $composableBuilder(
    column: $table.calciumMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get magnesiumMg => $composableBuilder(
    column: $table.magnesiumMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get zincMg => $composableBuilder(
    column: $table.zincMg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get folateMcg => $composableBuilder(
    column: $table.folateMcg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get omega3G => $composableBuilder(
    column: $table.omega3G,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MicronutrientLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MicronutrientLogsTable> {
  $$MicronutrientLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<double> get ironMg =>
      $composableBuilder(column: $table.ironMg, builder: (column) => column);

  GeneratedColumn<double> get vitaminB12Mcg => $composableBuilder(
    column: $table.vitaminB12Mcg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vitaminD3Iu => $composableBuilder(
    column: $table.vitaminD3Iu,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calciumMg =>
      $composableBuilder(column: $table.calciumMg, builder: (column) => column);

  GeneratedColumn<double> get magnesiumMg => $composableBuilder(
    column: $table.magnesiumMg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get zincMg =>
      $composableBuilder(column: $table.zincMg, builder: (column) => column);

  GeneratedColumn<double> get folateMcg =>
      $composableBuilder(column: $table.folateMcg, builder: (column) => column);

  GeneratedColumn<double> get omega3G =>
      $composableBuilder(column: $table.omega3G, builder: (column) => column);
}

class $$MicronutrientLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MicronutrientLogsTable,
          MicronutrientLog,
          $$MicronutrientLogsTableFilterComposer,
          $$MicronutrientLogsTableOrderingComposer,
          $$MicronutrientLogsTableAnnotationComposer,
          $$MicronutrientLogsTableCreateCompanionBuilder,
          $$MicronutrientLogsTableUpdateCompanionBuilder,
          (
            MicronutrientLog,
            BaseReferences<
              _$AppDatabase,
              $MicronutrientLogsTable,
              MicronutrientLog
            >,
          ),
          MicronutrientLog,
          PrefetchHooks Function()
        > {
  $$MicronutrientLogsTableTableManager(
    _$AppDatabase db,
    $MicronutrientLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MicronutrientLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MicronutrientLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MicronutrientLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<double> ironMg = const Value.absent(),
                Value<double> vitaminB12Mcg = const Value.absent(),
                Value<double> vitaminD3Iu = const Value.absent(),
                Value<double> calciumMg = const Value.absent(),
                Value<double> magnesiumMg = const Value.absent(),
                Value<double> zincMg = const Value.absent(),
                Value<double> folateMcg = const Value.absent(),
                Value<double> omega3G = const Value.absent(),
              }) => MicronutrientLogsCompanion(
                id: id,
                userId: userId,
                logDate: logDate,
                ironMg: ironMg,
                vitaminB12Mcg: vitaminB12Mcg,
                vitaminD3Iu: vitaminD3Iu,
                calciumMg: calciumMg,
                magnesiumMg: magnesiumMg,
                zincMg: zincMg,
                folateMcg: folateMcg,
                omega3G: omega3G,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime logDate,
                Value<double> ironMg = const Value.absent(),
                Value<double> vitaminB12Mcg = const Value.absent(),
                Value<double> vitaminD3Iu = const Value.absent(),
                Value<double> calciumMg = const Value.absent(),
                Value<double> magnesiumMg = const Value.absent(),
                Value<double> zincMg = const Value.absent(),
                Value<double> folateMcg = const Value.absent(),
                Value<double> omega3G = const Value.absent(),
              }) => MicronutrientLogsCompanion.insert(
                id: id,
                userId: userId,
                logDate: logDate,
                ironMg: ironMg,
                vitaminB12Mcg: vitaminB12Mcg,
                vitaminD3Iu: vitaminD3Iu,
                calciumMg: calciumMg,
                magnesiumMg: magnesiumMg,
                zincMg: zincMg,
                folateMcg: folateMcg,
                omega3G: omega3G,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MicronutrientLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MicronutrientLogsTable,
      MicronutrientLog,
      $$MicronutrientLogsTableFilterComposer,
      $$MicronutrientLogsTableOrderingComposer,
      $$MicronutrientLogsTableAnnotationComposer,
      $$MicronutrientLogsTableCreateCompanionBuilder,
      $$MicronutrientLogsTableUpdateCompanionBuilder,
      (
        MicronutrientLog,
        BaseReferences<
          _$AppDatabase,
          $MicronutrientLogsTable,
          MicronutrientLog
        >,
      ),
      MicronutrientLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserScoresTableTableManager get userScores =>
      $$UserScoresTableTableManager(_db, _db.userScores);
  $$OrganizationAccountsTableTableManager get organizationAccounts =>
      $$OrganizationAccountsTableTableManager(_db, _db.organizationAccounts);
  $$EmployeeEnrollmentsTableTableManager get employeeEnrollments =>
      $$EmployeeEnrollmentsTableTableManager(_db, _db.employeeEnrollments);
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
  $$MenstrualSymptomLogsTableTableManager get menstrualSymptomLogs =>
      $$MenstrualSymptomLogsTableTableManager(_db, _db.menstrualSymptomLogs);
  $$RecoveryLogsTableTableManager get recoveryLogs =>
      $$RecoveryLogsTableTableManager(_db, _db.recoveryLogs);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
  $$EscalationEventsTableTableManager get escalationEvents =>
      $$EscalationEventsTableTableManager(_db, _db.escalationEvents);
  $$StepLogsTableTableManager get stepLogs =>
      $$StepLogsTableTableManager(_db, _db.stepLogs);
  $$SleepLogsTableTableManager get sleepLogs =>
      $$SleepLogsTableTableManager(_db, _db.sleepLogs);
  $$BpReadingsTableTableManager get bpReadings =>
      $$BpReadingsTableTableManager(_db, _db.bpReadings);
  $$GlucoseReadingsTableTableManager get glucoseReadings =>
      $$GlucoseReadingsTableTableManager(_db, _db.glucoseReadings);
  $$FoodReferencesTableTableManager get foodReferences =>
      $$FoodReferencesTableTableManager(_db, _db.foodReferences);
  $$MicronutrientLogsTableTableManager get micronutrientLogs =>
      $$MicronutrientLogsTableTableManager(_db, _db.micronutrientLogs);
}
