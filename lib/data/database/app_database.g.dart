// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TrainingPlansTable extends TrainingPlans
    with TableInfo<$TrainingPlansTable, TrainingPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experienceMeta = const VerificationMeta(
    'experience',
  );
  @override
  late final GeneratedColumn<String> experience = GeneratedColumn<String>(
    'experience',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionMinutesMeta = const VerificationMeta(
    'sessionMinutes',
  );
  @override
  late final GeneratedColumn<int> sessionMinutes = GeneratedColumn<int>(
    'session_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    id,
    goal,
    experience,
    sessionMinutes,
    version,
    createdAt,
    updatedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('experience')) {
      context.handle(
        _experienceMeta,
        experience.isAcceptableOrUnknown(data['experience']!, _experienceMeta),
      );
    } else if (isInserting) {
      context.missing(_experienceMeta);
    }
    if (data.containsKey('session_minutes')) {
      context.handle(
        _sessionMinutesMeta,
        sessionMinutes.isAcceptableOrUnknown(
          data['session_minutes']!,
          _sessionMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionMinutesMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      experience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience'],
      )!,
      sessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_minutes'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TrainingPlansTable createAlias(String alias) {
    return $TrainingPlansTable(attachedDatabase, alias);
  }
}

class TrainingPlan extends DataClass implements Insertable<TrainingPlan> {
  final String id;
  final String goal;
  final String experience;
  final int sessionMinutes;
  final int version;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  const TrainingPlan({
    required this.id,
    required this.goal,
    required this.experience,
    required this.sessionMinutes,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal'] = Variable<String>(goal);
    map['experience'] = Variable<String>(experience);
    map['session_minutes'] = Variable<int>(sessionMinutes);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TrainingPlansCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlansCompanion(
      id: Value(id),
      goal: Value(goal),
      experience: Value(experience),
      sessionMinutes: Value(sessionMinutes),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isActive: Value(isActive),
    );
  }

  factory TrainingPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlan(
      id: serializer.fromJson<String>(json['id']),
      goal: serializer.fromJson<String>(json['goal']),
      experience: serializer.fromJson<String>(json['experience']),
      sessionMinutes: serializer.fromJson<int>(json['sessionMinutes']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goal': serializer.toJson<String>(goal),
      'experience': serializer.toJson<String>(experience),
      'sessionMinutes': serializer.toJson<int>(sessionMinutes),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  TrainingPlan copyWith({
    String? id,
    String? goal,
    String? experience,
    int? sessionMinutes,
    int? version,
    String? createdAt,
    String? updatedAt,
    bool? isActive,
  }) => TrainingPlan(
    id: id ?? this.id,
    goal: goal ?? this.goal,
    experience: experience ?? this.experience,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isActive: isActive ?? this.isActive,
  );
  TrainingPlan copyWithCompanion(TrainingPlansCompanion data) {
    return TrainingPlan(
      id: data.id.present ? data.id.value : this.id,
      goal: data.goal.present ? data.goal.value : this.goal,
      experience: data.experience.present
          ? data.experience.value
          : this.experience,
      sessionMinutes: data.sessionMinutes.present
          ? data.sessionMinutes.value
          : this.sessionMinutes,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlan(')
          ..write('id: $id, ')
          ..write('goal: $goal, ')
          ..write('experience: $experience, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goal,
    experience,
    sessionMinutes,
    version,
    createdAt,
    updatedAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlan &&
          other.id == this.id &&
          other.goal == this.goal &&
          other.experience == this.experience &&
          other.sessionMinutes == this.sessionMinutes &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isActive == this.isActive);
}

class TrainingPlansCompanion extends UpdateCompanion<TrainingPlan> {
  final Value<String> id;
  final Value<String> goal;
  final Value<String> experience;
  final Value<int> sessionMinutes;
  final Value<int> version;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const TrainingPlansCompanion({
    this.id = const Value.absent(),
    this.goal = const Value.absent(),
    this.experience = const Value.absent(),
    this.sessionMinutes = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrainingPlansCompanion.insert({
    required String id,
    required String goal,
    required String experience,
    required int sessionMinutes,
    this.version = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goal = Value(goal),
       experience = Value(experience),
       sessionMinutes = Value(sessionMinutes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TrainingPlan> custom({
    Expression<String>? id,
    Expression<String>? goal,
    Expression<String>? experience,
    Expression<int>? sessionMinutes,
    Expression<int>? version,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goal != null) 'goal': goal,
      if (experience != null) 'experience': experience,
      if (sessionMinutes != null) 'session_minutes': sessionMinutes,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrainingPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? goal,
    Value<String>? experience,
    Value<int>? sessionMinutes,
    Value<int>? version,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return TrainingPlansCompanion(
      id: id ?? this.id,
      goal: goal ?? this.goal,
      experience: experience ?? this.experience,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (experience.present) {
      map['experience'] = Variable<String>(experience.value);
    }
    if (sessionMinutes.present) {
      map['session_minutes'] = Variable<int>(sessionMinutes.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
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
    return (StringBuffer('TrainingPlansCompanion(')
          ..write('id: $id, ')
          ..write('goal: $goal, ')
          ..write('experience: $experience, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrainingPlanDaysTable extends TrainingPlanDays
    with TableInfo<$TrainingPlanDaysTable, TrainingPlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingPlanDaysTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, weekday, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plan_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingPlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {planId, weekday},
  ];
  @override
  TrainingPlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlanDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $TrainingPlanDaysTable createAlias(String alias) {
    return $TrainingPlanDaysTable(attachedDatabase, alias);
  }
}

class TrainingPlanDay extends DataClass implements Insertable<TrainingPlanDay> {
  final int id;
  final String planId;
  final int weekday;
  final int orderIndex;
  const TrainingPlanDay({
    required this.id,
    required this.planId,
    required this.weekday,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<String>(planId);
    map['weekday'] = Variable<int>(weekday);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  TrainingPlanDaysCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlanDaysCompanion(
      id: Value(id),
      planId: Value(planId),
      weekday: Value(weekday),
      orderIndex: Value(orderIndex),
    );
  }

  factory TrainingPlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlanDay(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      weekday: serializer.fromJson<int>(json['weekday']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<String>(planId),
      'weekday': serializer.toJson<int>(weekday),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  TrainingPlanDay copyWith({
    int? id,
    String? planId,
    int? weekday,
    int? orderIndex,
  }) => TrainingPlanDay(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    weekday: weekday ?? this.weekday,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  TrainingPlanDay copyWithCompanion(TrainingPlanDaysCompanion data) {
    return TrainingPlanDay(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlanDay(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('weekday: $weekday, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, weekday, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlanDay &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.weekday == this.weekday &&
          other.orderIndex == this.orderIndex);
}

class TrainingPlanDaysCompanion extends UpdateCompanion<TrainingPlanDay> {
  final Value<int> id;
  final Value<String> planId;
  final Value<int> weekday;
  final Value<int> orderIndex;
  const TrainingPlanDaysCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  TrainingPlanDaysCompanion.insert({
    this.id = const Value.absent(),
    required String planId,
    required int weekday,
    required int orderIndex,
  }) : planId = Value(planId),
       weekday = Value(weekday),
       orderIndex = Value(orderIndex);
  static Insertable<TrainingPlanDay> custom({
    Expression<int>? id,
    Expression<String>? planId,
    Expression<int>? weekday,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (weekday != null) 'weekday': weekday,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  TrainingPlanDaysCompanion copyWith({
    Value<int>? id,
    Value<String>? planId,
    Value<int>? weekday,
    Value<int>? orderIndex,
  }) {
    return TrainingPlanDaysCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      weekday: weekday ?? this.weekday,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('weekday: $weekday, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $TrainingPlanEquipmentTable extends TrainingPlanEquipment
    with TableInfo<$TrainingPlanEquipmentTable, TrainingPlanEquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingPlanEquipmentTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, equipment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plan_equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingPlanEquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {planId, equipment},
  ];
  @override
  TrainingPlanEquipmentData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlanEquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
    );
  }

  @override
  $TrainingPlanEquipmentTable createAlias(String alias) {
    return $TrainingPlanEquipmentTable(attachedDatabase, alias);
  }
}

class TrainingPlanEquipmentData extends DataClass
    implements Insertable<TrainingPlanEquipmentData> {
  final int id;
  final String planId;
  final String equipment;
  const TrainingPlanEquipmentData({
    required this.id,
    required this.planId,
    required this.equipment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<String>(planId);
    map['equipment'] = Variable<String>(equipment);
    return map;
  }

  TrainingPlanEquipmentCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlanEquipmentCompanion(
      id: Value(id),
      planId: Value(planId),
      equipment: Value(equipment),
    );
  }

  factory TrainingPlanEquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlanEquipmentData(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      equipment: serializer.fromJson<String>(json['equipment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<String>(planId),
      'equipment': serializer.toJson<String>(equipment),
    };
  }

  TrainingPlanEquipmentData copyWith({
    int? id,
    String? planId,
    String? equipment,
  }) => TrainingPlanEquipmentData(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    equipment: equipment ?? this.equipment,
  );
  TrainingPlanEquipmentData copyWithCompanion(
    TrainingPlanEquipmentCompanion data,
  ) {
    return TrainingPlanEquipmentData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlanEquipmentData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('equipment: $equipment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, equipment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlanEquipmentData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.equipment == this.equipment);
}

class TrainingPlanEquipmentCompanion
    extends UpdateCompanion<TrainingPlanEquipmentData> {
  final Value<int> id;
  final Value<String> planId;
  final Value<String> equipment;
  const TrainingPlanEquipmentCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.equipment = const Value.absent(),
  });
  TrainingPlanEquipmentCompanion.insert({
    this.id = const Value.absent(),
    required String planId,
    required String equipment,
  }) : planId = Value(planId),
       equipment = Value(equipment);
  static Insertable<TrainingPlanEquipmentData> custom({
    Expression<int>? id,
    Expression<String>? planId,
    Expression<String>? equipment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (equipment != null) 'equipment': equipment,
    });
  }

  TrainingPlanEquipmentCompanion copyWith({
    Value<int>? id,
    Value<String>? planId,
    Value<String>? equipment,
  }) {
    return TrainingPlanEquipmentCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      equipment: equipment ?? this.equipment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlanEquipmentCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('equipment: $equipment')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES training_plans (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
    'scheduled_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planVersionMeta = const VerificationMeta(
    'planVersion',
  );
  @override
  late final GeneratedColumn<int> planVersion = GeneratedColumn<int>(
    'plan_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _planSnapshotMeta = const VerificationMeta(
    'planSnapshot',
  );
  @override
  late final GeneratedColumn<String> planSnapshot = GeneratedColumn<String>(
    'plan_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseCountMeta = const VerificationMeta(
    'exerciseCount',
  );
  @override
  late final GeneratedColumn<int> exerciseCount = GeneratedColumn<int>(
    'exercise_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedOutsideAppMeta =
      const VerificationMeta('completedOutsideApp');
  @override
  late final GeneratedColumn<bool> completedOutsideApp = GeneratedColumn<bool>(
    'completed_outside_app',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed_outside_app" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    scheduledDate,
    completedAt,
    title,
    goal,
    planVersion,
    planSnapshot,
    durationMinutes,
    exerciseCount,
    completedOutsideApp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('plan_version')) {
      context.handle(
        _planVersionMeta,
        planVersion.isAcceptableOrUnknown(
          data['plan_version']!,
          _planVersionMeta,
        ),
      );
    }
    if (data.containsKey('plan_snapshot')) {
      context.handle(
        _planSnapshotMeta,
        planSnapshot.isAcceptableOrUnknown(
          data['plan_snapshot']!,
          _planSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('exercise_count')) {
      context.handle(
        _exerciseCountMeta,
        exerciseCount.isAcceptableOrUnknown(
          data['exercise_count']!,
          _exerciseCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseCountMeta);
    }
    if (data.containsKey('completed_outside_app')) {
      context.handle(
        _completedOutsideAppMeta,
        completedOutsideApp.isAcceptableOrUnknown(
          data['completed_outside_app']!,
          _completedOutsideAppMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedOutsideAppMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      ),
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_date'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_at'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      planVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_version'],
      )!,
      planSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_snapshot'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      exerciseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_count'],
      )!,
      completedOutsideApp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed_outside_app'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String? planId;
  final String scheduledDate;
  final String completedAt;
  final String title;
  final String goal;
  final int planVersion;
  final String? planSnapshot;
  final int durationMinutes;
  final int exerciseCount;
  final bool completedOutsideApp;
  const WorkoutSession({
    required this.id,
    this.planId,
    required this.scheduledDate,
    required this.completedAt,
    required this.title,
    required this.goal,
    required this.planVersion,
    this.planSnapshot,
    required this.durationMinutes,
    required this.exerciseCount,
    required this.completedOutsideApp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    map['scheduled_date'] = Variable<String>(scheduledDate);
    map['completed_at'] = Variable<String>(completedAt);
    map['title'] = Variable<String>(title);
    map['goal'] = Variable<String>(goal);
    map['plan_version'] = Variable<int>(planVersion);
    if (!nullToAbsent || planSnapshot != null) {
      map['plan_snapshot'] = Variable<String>(planSnapshot);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['exercise_count'] = Variable<int>(exerciseCount);
    map['completed_outside_app'] = Variable<bool>(completedOutsideApp);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      scheduledDate: Value(scheduledDate),
      completedAt: Value(completedAt),
      title: Value(title),
      goal: Value(goal),
      planVersion: Value(planVersion),
      planSnapshot: planSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(planSnapshot),
      durationMinutes: Value(durationMinutes),
      exerciseCount: Value(exerciseCount),
      completedOutsideApp: Value(completedOutsideApp),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      planId: serializer.fromJson<String?>(json['planId']),
      scheduledDate: serializer.fromJson<String>(json['scheduledDate']),
      completedAt: serializer.fromJson<String>(json['completedAt']),
      title: serializer.fromJson<String>(json['title']),
      goal: serializer.fromJson<String>(json['goal']),
      planVersion: serializer.fromJson<int>(json['planVersion']),
      planSnapshot: serializer.fromJson<String?>(json['planSnapshot']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      exerciseCount: serializer.fromJson<int>(json['exerciseCount']),
      completedOutsideApp: serializer.fromJson<bool>(
        json['completedOutsideApp'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planId': serializer.toJson<String?>(planId),
      'scheduledDate': serializer.toJson<String>(scheduledDate),
      'completedAt': serializer.toJson<String>(completedAt),
      'title': serializer.toJson<String>(title),
      'goal': serializer.toJson<String>(goal),
      'planVersion': serializer.toJson<int>(planVersion),
      'planSnapshot': serializer.toJson<String?>(planSnapshot),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'exerciseCount': serializer.toJson<int>(exerciseCount),
      'completedOutsideApp': serializer.toJson<bool>(completedOutsideApp),
    };
  }

  WorkoutSession copyWith({
    String? id,
    Value<String?> planId = const Value.absent(),
    String? scheduledDate,
    String? completedAt,
    String? title,
    String? goal,
    int? planVersion,
    Value<String?> planSnapshot = const Value.absent(),
    int? durationMinutes,
    int? exerciseCount,
    bool? completedOutsideApp,
  }) => WorkoutSession(
    id: id ?? this.id,
    planId: planId.present ? planId.value : this.planId,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    completedAt: completedAt ?? this.completedAt,
    title: title ?? this.title,
    goal: goal ?? this.goal,
    planVersion: planVersion ?? this.planVersion,
    planSnapshot: planSnapshot.present ? planSnapshot.value : this.planSnapshot,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    exerciseCount: exerciseCount ?? this.exerciseCount,
    completedOutsideApp: completedOutsideApp ?? this.completedOutsideApp,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      title: data.title.present ? data.title.value : this.title,
      goal: data.goal.present ? data.goal.value : this.goal,
      planVersion: data.planVersion.present
          ? data.planVersion.value
          : this.planVersion,
      planSnapshot: data.planSnapshot.present
          ? data.planSnapshot.value
          : this.planSnapshot,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      exerciseCount: data.exerciseCount.present
          ? data.exerciseCount.value
          : this.exerciseCount,
      completedOutsideApp: data.completedOutsideApp.present
          ? data.completedOutsideApp.value
          : this.completedOutsideApp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('title: $title, ')
          ..write('goal: $goal, ')
          ..write('planVersion: $planVersion, ')
          ..write('planSnapshot: $planSnapshot, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('exerciseCount: $exerciseCount, ')
          ..write('completedOutsideApp: $completedOutsideApp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    scheduledDate,
    completedAt,
    title,
    goal,
    planVersion,
    planSnapshot,
    durationMinutes,
    exerciseCount,
    completedOutsideApp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.scheduledDate == this.scheduledDate &&
          other.completedAt == this.completedAt &&
          other.title == this.title &&
          other.goal == this.goal &&
          other.planVersion == this.planVersion &&
          other.planSnapshot == this.planSnapshot &&
          other.durationMinutes == this.durationMinutes &&
          other.exerciseCount == this.exerciseCount &&
          other.completedOutsideApp == this.completedOutsideApp);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String?> planId;
  final Value<String> scheduledDate;
  final Value<String> completedAt;
  final Value<String> title;
  final Value<String> goal;
  final Value<int> planVersion;
  final Value<String?> planSnapshot;
  final Value<int> durationMinutes;
  final Value<int> exerciseCount;
  final Value<bool> completedOutsideApp;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.title = const Value.absent(),
    this.goal = const Value.absent(),
    this.planVersion = const Value.absent(),
    this.planSnapshot = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.exerciseCount = const Value.absent(),
    this.completedOutsideApp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    this.planId = const Value.absent(),
    required String scheduledDate,
    required String completedAt,
    required String title,
    required String goal,
    this.planVersion = const Value.absent(),
    this.planSnapshot = const Value.absent(),
    required int durationMinutes,
    required int exerciseCount,
    required bool completedOutsideApp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduledDate = Value(scheduledDate),
       completedAt = Value(completedAt),
       title = Value(title),
       goal = Value(goal),
       durationMinutes = Value(durationMinutes),
       exerciseCount = Value(exerciseCount),
       completedOutsideApp = Value(completedOutsideApp);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? planId,
    Expression<String>? scheduledDate,
    Expression<String>? completedAt,
    Expression<String>? title,
    Expression<String>? goal,
    Expression<int>? planVersion,
    Expression<String>? planSnapshot,
    Expression<int>? durationMinutes,
    Expression<int>? exerciseCount,
    Expression<bool>? completedOutsideApp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (title != null) 'title': title,
      if (goal != null) 'goal': goal,
      if (planVersion != null) 'plan_version': planVersion,
      if (planSnapshot != null) 'plan_snapshot': planSnapshot,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (exerciseCount != null) 'exercise_count': exerciseCount,
      if (completedOutsideApp != null)
        'completed_outside_app': completedOutsideApp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? planId,
    Value<String>? scheduledDate,
    Value<String>? completedAt,
    Value<String>? title,
    Value<String>? goal,
    Value<int>? planVersion,
    Value<String?>? planSnapshot,
    Value<int>? durationMinutes,
    Value<int>? exerciseCount,
    Value<bool>? completedOutsideApp,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      title: title ?? this.title,
      goal: goal ?? this.goal,
      planVersion: planVersion ?? this.planVersion,
      planSnapshot: planSnapshot ?? this.planSnapshot,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      completedOutsideApp: completedOutsideApp ?? this.completedOutsideApp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (planVersion.present) {
      map['plan_version'] = Variable<int>(planVersion.value);
    }
    if (planSnapshot.present) {
      map['plan_snapshot'] = Variable<String>(planSnapshot.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (exerciseCount.present) {
      map['exercise_count'] = Variable<int>(exerciseCount.value);
    }
    if (completedOutsideApp.present) {
      map['completed_outside_app'] = Variable<bool>(completedOutsideApp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('title: $title, ')
          ..write('goal: $goal, ')
          ..write('planVersion: $planVersion, ')
          ..write('planSnapshot: $planSnapshot, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('exerciseCount: $exerciseCount, ')
          ..write('completedOutsideApp: $completedOutsideApp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionExercisesTable extends WorkoutSessionExercises
    with TableInfo<$WorkoutSessionExercisesTable, WorkoutSessionExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    position,
    name,
    catalogId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_session_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSessionExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionId, position},
  ];
  @override
  WorkoutSessionExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      ),
    );
  }

  @override
  $WorkoutSessionExercisesTable createAlias(String alias) {
    return $WorkoutSessionExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutSessionExercise extends DataClass
    implements Insertable<WorkoutSessionExercise> {
  final int id;
  final String sessionId;
  final int position;
  final String name;
  final String? catalogId;
  const WorkoutSessionExercise({
    required this.id,
    required this.sessionId,
    required this.position,
    required this.name,
    this.catalogId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || catalogId != null) {
      map['catalog_id'] = Variable<String>(catalogId);
    }
    return map;
  }

  WorkoutSessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      position: Value(position),
      name: Value(name),
      catalogId: catalogId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogId),
    );
  }

  factory WorkoutSessionExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionExercise(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      catalogId: serializer.fromJson<String?>(json['catalogId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'catalogId': serializer.toJson<String?>(catalogId),
    };
  }

  WorkoutSessionExercise copyWith({
    int? id,
    String? sessionId,
    int? position,
    String? name,
    Value<String?> catalogId = const Value.absent(),
  }) => WorkoutSessionExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    position: position ?? this.position,
    name: name ?? this.name,
    catalogId: catalogId.present ? catalogId.value : this.catalogId,
  );
  WorkoutSessionExercise copyWithCompanion(
    WorkoutSessionExercisesCompanion data,
  ) {
    return WorkoutSessionExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('catalogId: $catalogId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, position, name, catalogId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.position == this.position &&
          other.name == this.name &&
          other.catalogId == this.catalogId);
}

class WorkoutSessionExercisesCompanion
    extends UpdateCompanion<WorkoutSessionExercise> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> position;
  final Value<String> name;
  final Value<String?> catalogId;
  const WorkoutSessionExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.catalogId = const Value.absent(),
  });
  WorkoutSessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int position,
    required String name,
    this.catalogId = const Value.absent(),
  }) : sessionId = Value(sessionId),
       position = Value(position),
       name = Value(name);
  static Insertable<WorkoutSessionExercise> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? catalogId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (catalogId != null) 'catalog_id': catalogId,
    });
  }

  WorkoutSessionExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<int>? position,
    Value<String>? name,
    Value<String?>? catalogId,
  }) {
    return WorkoutSessionExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      position: position ?? this.position,
      name: name ?? this.name,
      catalogId: catalogId ?? this.catalogId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('catalogId: $catalogId')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetEntriesTable extends WorkoutSetEntries
    with TableInfo<$WorkoutSetEntriesTable, WorkoutSetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exercisePositionMeta = const VerificationMeta(
    'exercisePosition',
  );
  @override
  late final GeneratedColumn<int> exercisePosition = GeneratedColumn<int>(
    'exercise_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loadKgMeta = const VerificationMeta('loadKg');
  @override
  late final GeneratedColumn<double> loadKg = GeneratedColumn<double>(
    'load_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exercisePosition,
    setIndex,
    repetitions,
    loadKg,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_position')) {
      context.handle(
        _exercisePositionMeta,
        exercisePosition.isAcceptableOrUnknown(
          data['exercise_position']!,
          _exercisePositionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exercisePositionMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('load_kg')) {
      context.handle(
        _loadKgMeta,
        loadKg.isAcceptableOrUnknown(data['load_kg']!, _loadKgMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionId, exercisePosition, setIndex},
  ];
  @override
  WorkoutSetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exercisePosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_position'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      loadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_kg'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
    );
  }

  @override
  $WorkoutSetEntriesTable createAlias(String alias) {
    return $WorkoutSetEntriesTable(attachedDatabase, alias);
  }
}

class WorkoutSetEntry extends DataClass implements Insertable<WorkoutSetEntry> {
  final int id;
  final String sessionId;
  final int exercisePosition;
  final int setIndex;
  final int? repetitions;
  final double? loadKg;
  final int? durationSeconds;
  const WorkoutSetEntry({
    required this.id,
    required this.sessionId,
    required this.exercisePosition,
    required this.setIndex,
    this.repetitions,
    this.loadKg,
    this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_position'] = Variable<int>(exercisePosition);
    map['set_index'] = Variable<int>(setIndex);
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    if (!nullToAbsent || loadKg != null) {
      map['load_kg'] = Variable<double>(loadKg);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    return map;
  }

  WorkoutSetEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetEntriesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exercisePosition: Value(exercisePosition),
      setIndex: Value(setIndex),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      loadKg: loadKg == null && nullToAbsent
          ? const Value.absent()
          : Value(loadKg),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
    );
  }

  factory WorkoutSetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetEntry(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exercisePosition: serializer.fromJson<int>(json['exercisePosition']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      loadKg: serializer.fromJson<double?>(json['loadKg']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exercisePosition': serializer.toJson<int>(exercisePosition),
      'setIndex': serializer.toJson<int>(setIndex),
      'repetitions': serializer.toJson<int?>(repetitions),
      'loadKg': serializer.toJson<double?>(loadKg),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
    };
  }

  WorkoutSetEntry copyWith({
    int? id,
    String? sessionId,
    int? exercisePosition,
    int? setIndex,
    Value<int?> repetitions = const Value.absent(),
    Value<double?> loadKg = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
  }) => WorkoutSetEntry(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exercisePosition: exercisePosition ?? this.exercisePosition,
    setIndex: setIndex ?? this.setIndex,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    loadKg: loadKg.present ? loadKg.value : this.loadKg,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
  );
  WorkoutSetEntry copyWithCompanion(WorkoutSetEntriesCompanion data) {
    return WorkoutSetEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exercisePosition: data.exercisePosition.present
          ? data.exercisePosition.value
          : this.exercisePosition,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      loadKg: data.loadKg.present ? data.loadKg.value : this.loadKg,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetEntry(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exercisePosition: $exercisePosition, ')
          ..write('setIndex: $setIndex, ')
          ..write('repetitions: $repetitions, ')
          ..write('loadKg: $loadKg, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exercisePosition,
    setIndex,
    repetitions,
    loadKg,
    durationSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetEntry &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exercisePosition == this.exercisePosition &&
          other.setIndex == this.setIndex &&
          other.repetitions == this.repetitions &&
          other.loadKg == this.loadKg &&
          other.durationSeconds == this.durationSeconds);
}

class WorkoutSetEntriesCompanion extends UpdateCompanion<WorkoutSetEntry> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<int> exercisePosition;
  final Value<int> setIndex;
  final Value<int?> repetitions;
  final Value<double?> loadKg;
  final Value<int?> durationSeconds;
  const WorkoutSetEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exercisePosition = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.loadKg = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  WorkoutSetEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required int exercisePosition,
    required int setIndex,
    this.repetitions = const Value.absent(),
    this.loadKg = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exercisePosition = Value(exercisePosition),
       setIndex = Value(setIndex);
  static Insertable<WorkoutSetEntry> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<int>? exercisePosition,
    Expression<int>? setIndex,
    Expression<int>? repetitions,
    Expression<double>? loadKg,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exercisePosition != null) 'exercise_position': exercisePosition,
      if (setIndex != null) 'set_index': setIndex,
      if (repetitions != null) 'repetitions': repetitions,
      if (loadKg != null) 'load_kg': loadKg,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  WorkoutSetEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<int>? exercisePosition,
    Value<int>? setIndex,
    Value<int?>? repetitions,
    Value<double?>? loadKg,
    Value<int?>? durationSeconds,
  }) {
    return WorkoutSetEntriesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exercisePosition: exercisePosition ?? this.exercisePosition,
      setIndex: setIndex ?? this.setIndex,
      repetitions: repetitions ?? this.repetitions,
      loadKg: loadKg ?? this.loadKg,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exercisePosition.present) {
      map['exercise_position'] = Variable<int>(exercisePosition.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (loadKg.present) {
      map['load_kg'] = Variable<double>(loadKg.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exercisePosition: $exercisePosition, ')
          ..write('setIndex: $setIndex, ')
          ..write('repetitions: $repetitions, ')
          ..write('loadKg: $loadKg, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $ScheduledTrainingSessionsTable extends ScheduledTrainingSessions
    with TableInfo<$ScheduledTrainingSessionsTable, ScheduledTrainingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledTrainingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
    'scheduled_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalDateMeta = const VerificationMeta(
    'originalDate',
  );
  @override
  late final GeneratedColumn<String> originalDate = GeneratedColumn<String>(
    'original_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIndexMeta = const VerificationMeta(
    'sessionIndex',
  );
  @override
  late final GeneratedColumn<int> sessionIndex = GeneratedColumn<int>(
    'session_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseCountMeta = const VerificationMeta(
    'exerciseCount',
  );
  @override
  late final GeneratedColumn<int> exerciseCount = GeneratedColumn<int>(
    'exercise_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planVersionMeta = const VerificationMeta(
    'planVersion',
  );
  @override
  late final GeneratedColumn<int> planVersion = GeneratedColumn<int>(
    'plan_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _planSnapshotMeta = const VerificationMeta(
    'planSnapshot',
  );
  @override
  late final GeneratedColumn<String> planSnapshot = GeneratedColumn<String>(
    'plan_snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduledDate,
    originalDate,
    sessionIndex,
    title,
    focus,
    durationMinutes,
    exerciseCount,
    planVersion,
    planSnapshot,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_training_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledTrainingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('original_date')) {
      context.handle(
        _originalDateMeta,
        originalDate.isAcceptableOrUnknown(
          data['original_date']!,
          _originalDateMeta,
        ),
      );
    }
    if (data.containsKey('session_index')) {
      context.handle(
        _sessionIndexMeta,
        sessionIndex.isAcceptableOrUnknown(
          data['session_index']!,
          _sessionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionIndexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(
        _focusMeta,
        focus.isAcceptableOrUnknown(data['focus']!, _focusMeta),
      );
    } else if (isInserting) {
      context.missing(_focusMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('exercise_count')) {
      context.handle(
        _exerciseCountMeta,
        exerciseCount.isAcceptableOrUnknown(
          data['exercise_count']!,
          _exerciseCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseCountMeta);
    }
    if (data.containsKey('plan_version')) {
      context.handle(
        _planVersionMeta,
        planVersion.isAcceptableOrUnknown(
          data['plan_version']!,
          _planVersionMeta,
        ),
      );
    }
    if (data.containsKey('plan_snapshot')) {
      context.handle(
        _planSnapshotMeta,
        planSnapshot.isAcceptableOrUnknown(
          data['plan_snapshot']!,
          _planSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledTrainingSession map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledTrainingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_date'],
      )!,
      originalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_date'],
      ),
      sessionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_index'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      focus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      exerciseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_count'],
      )!,
      planVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_version'],
      )!,
      planSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_snapshot'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ScheduledTrainingSessionsTable createAlias(String alias) {
    return $ScheduledTrainingSessionsTable(attachedDatabase, alias);
  }
}

class ScheduledTrainingSession extends DataClass
    implements Insertable<ScheduledTrainingSession> {
  final String id;
  final String scheduledDate;
  final String? originalDate;
  final int sessionIndex;
  final String title;
  final String focus;
  final int durationMinutes;
  final int exerciseCount;
  final int planVersion;
  final String planSnapshot;
  final String status;
  const ScheduledTrainingSession({
    required this.id,
    required this.scheduledDate,
    this.originalDate,
    required this.sessionIndex,
    required this.title,
    required this.focus,
    required this.durationMinutes,
    required this.exerciseCount,
    required this.planVersion,
    required this.planSnapshot,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['scheduled_date'] = Variable<String>(scheduledDate);
    if (!nullToAbsent || originalDate != null) {
      map['original_date'] = Variable<String>(originalDate);
    }
    map['session_index'] = Variable<int>(sessionIndex);
    map['title'] = Variable<String>(title);
    map['focus'] = Variable<String>(focus);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['exercise_count'] = Variable<int>(exerciseCount);
    map['plan_version'] = Variable<int>(planVersion);
    map['plan_snapshot'] = Variable<String>(planSnapshot);
    map['status'] = Variable<String>(status);
    return map;
  }

  ScheduledTrainingSessionsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledTrainingSessionsCompanion(
      id: Value(id),
      scheduledDate: Value(scheduledDate),
      originalDate: originalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(originalDate),
      sessionIndex: Value(sessionIndex),
      title: Value(title),
      focus: Value(focus),
      durationMinutes: Value(durationMinutes),
      exerciseCount: Value(exerciseCount),
      planVersion: Value(planVersion),
      planSnapshot: Value(planSnapshot),
      status: Value(status),
    );
  }

  factory ScheduledTrainingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledTrainingSession(
      id: serializer.fromJson<String>(json['id']),
      scheduledDate: serializer.fromJson<String>(json['scheduledDate']),
      originalDate: serializer.fromJson<String?>(json['originalDate']),
      sessionIndex: serializer.fromJson<int>(json['sessionIndex']),
      title: serializer.fromJson<String>(json['title']),
      focus: serializer.fromJson<String>(json['focus']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      exerciseCount: serializer.fromJson<int>(json['exerciseCount']),
      planVersion: serializer.fromJson<int>(json['planVersion']),
      planSnapshot: serializer.fromJson<String>(json['planSnapshot']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduledDate': serializer.toJson<String>(scheduledDate),
      'originalDate': serializer.toJson<String?>(originalDate),
      'sessionIndex': serializer.toJson<int>(sessionIndex),
      'title': serializer.toJson<String>(title),
      'focus': serializer.toJson<String>(focus),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'exerciseCount': serializer.toJson<int>(exerciseCount),
      'planVersion': serializer.toJson<int>(planVersion),
      'planSnapshot': serializer.toJson<String>(planSnapshot),
      'status': serializer.toJson<String>(status),
    };
  }

  ScheduledTrainingSession copyWith({
    String? id,
    String? scheduledDate,
    Value<String?> originalDate = const Value.absent(),
    int? sessionIndex,
    String? title,
    String? focus,
    int? durationMinutes,
    int? exerciseCount,
    int? planVersion,
    String? planSnapshot,
    String? status,
  }) => ScheduledTrainingSession(
    id: id ?? this.id,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    originalDate: originalDate.present ? originalDate.value : this.originalDate,
    sessionIndex: sessionIndex ?? this.sessionIndex,
    title: title ?? this.title,
    focus: focus ?? this.focus,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    exerciseCount: exerciseCount ?? this.exerciseCount,
    planVersion: planVersion ?? this.planVersion,
    planSnapshot: planSnapshot ?? this.planSnapshot,
    status: status ?? this.status,
  );
  ScheduledTrainingSession copyWithCompanion(
    ScheduledTrainingSessionsCompanion data,
  ) {
    return ScheduledTrainingSession(
      id: data.id.present ? data.id.value : this.id,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      originalDate: data.originalDate.present
          ? data.originalDate.value
          : this.originalDate,
      sessionIndex: data.sessionIndex.present
          ? data.sessionIndex.value
          : this.sessionIndex,
      title: data.title.present ? data.title.value : this.title,
      focus: data.focus.present ? data.focus.value : this.focus,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      exerciseCount: data.exerciseCount.present
          ? data.exerciseCount.value
          : this.exerciseCount,
      planVersion: data.planVersion.present
          ? data.planVersion.value
          : this.planVersion,
      planSnapshot: data.planSnapshot.present
          ? data.planSnapshot.value
          : this.planSnapshot,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledTrainingSession(')
          ..write('id: $id, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('originalDate: $originalDate, ')
          ..write('sessionIndex: $sessionIndex, ')
          ..write('title: $title, ')
          ..write('focus: $focus, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('exerciseCount: $exerciseCount, ')
          ..write('planVersion: $planVersion, ')
          ..write('planSnapshot: $planSnapshot, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scheduledDate,
    originalDate,
    sessionIndex,
    title,
    focus,
    durationMinutes,
    exerciseCount,
    planVersion,
    planSnapshot,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledTrainingSession &&
          other.id == this.id &&
          other.scheduledDate == this.scheduledDate &&
          other.originalDate == this.originalDate &&
          other.sessionIndex == this.sessionIndex &&
          other.title == this.title &&
          other.focus == this.focus &&
          other.durationMinutes == this.durationMinutes &&
          other.exerciseCount == this.exerciseCount &&
          other.planVersion == this.planVersion &&
          other.planSnapshot == this.planSnapshot &&
          other.status == this.status);
}

class ScheduledTrainingSessionsCompanion
    extends UpdateCompanion<ScheduledTrainingSession> {
  final Value<String> id;
  final Value<String> scheduledDate;
  final Value<String?> originalDate;
  final Value<int> sessionIndex;
  final Value<String> title;
  final Value<String> focus;
  final Value<int> durationMinutes;
  final Value<int> exerciseCount;
  final Value<int> planVersion;
  final Value<String> planSnapshot;
  final Value<String> status;
  final Value<int> rowid;
  const ScheduledTrainingSessionsCompanion({
    this.id = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.originalDate = const Value.absent(),
    this.sessionIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.focus = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.exerciseCount = const Value.absent(),
    this.planVersion = const Value.absent(),
    this.planSnapshot = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledTrainingSessionsCompanion.insert({
    required String id,
    required String scheduledDate,
    this.originalDate = const Value.absent(),
    required int sessionIndex,
    required String title,
    required String focus,
    required int durationMinutes,
    required int exerciseCount,
    this.planVersion = const Value.absent(),
    this.planSnapshot = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduledDate = Value(scheduledDate),
       sessionIndex = Value(sessionIndex),
       title = Value(title),
       focus = Value(focus),
       durationMinutes = Value(durationMinutes),
       exerciseCount = Value(exerciseCount);
  static Insertable<ScheduledTrainingSession> custom({
    Expression<String>? id,
    Expression<String>? scheduledDate,
    Expression<String>? originalDate,
    Expression<int>? sessionIndex,
    Expression<String>? title,
    Expression<String>? focus,
    Expression<int>? durationMinutes,
    Expression<int>? exerciseCount,
    Expression<int>? planVersion,
    Expression<String>? planSnapshot,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (originalDate != null) 'original_date': originalDate,
      if (sessionIndex != null) 'session_index': sessionIndex,
      if (title != null) 'title': title,
      if (focus != null) 'focus': focus,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (exerciseCount != null) 'exercise_count': exerciseCount,
      if (planVersion != null) 'plan_version': planVersion,
      if (planSnapshot != null) 'plan_snapshot': planSnapshot,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledTrainingSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? scheduledDate,
    Value<String?>? originalDate,
    Value<int>? sessionIndex,
    Value<String>? title,
    Value<String>? focus,
    Value<int>? durationMinutes,
    Value<int>? exerciseCount,
    Value<int>? planVersion,
    Value<String>? planSnapshot,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ScheduledTrainingSessionsCompanion(
      id: id ?? this.id,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      originalDate: originalDate ?? this.originalDate,
      sessionIndex: sessionIndex ?? this.sessionIndex,
      title: title ?? this.title,
      focus: focus ?? this.focus,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      planVersion: planVersion ?? this.planVersion,
      planSnapshot: planSnapshot ?? this.planSnapshot,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (originalDate.present) {
      map['original_date'] = Variable<String>(originalDate.value);
    }
    if (sessionIndex.present) {
      map['session_index'] = Variable<int>(sessionIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (exerciseCount.present) {
      map['exercise_count'] = Variable<int>(exerciseCount.value);
    }
    if (planVersion.present) {
      map['plan_version'] = Variable<int>(planVersion.value);
    }
    if (planSnapshot.present) {
      map['plan_snapshot'] = Variable<String>(planSnapshot.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledTrainingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('originalDate: $originalDate, ')
          ..write('sessionIndex: $sessionIndex, ')
          ..write('title: $title, ')
          ..write('focus: $focus, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('exerciseCount: $exerciseCount, ')
          ..write('planVersion: $planVersion, ')
          ..write('planSnapshot: $planSnapshot, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalGoalsTable extends PersonalGoals
    with TableInfo<$PersonalGoalsTable, PersonalGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    targetValue,
    exerciseName,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PersonalGoalsTable createAlias(String alias) {
    return $PersonalGoalsTable(attachedDatabase, alias);
  }
}

class PersonalGoal extends DataClass implements Insertable<PersonalGoal> {
  final String id;
  final String type;
  final double targetValue;
  final String? exerciseName;
  final String createdAt;
  const PersonalGoal({
    required this.id,
    required this.type,
    required this.targetValue,
    this.exerciseName,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['target_value'] = Variable<double>(targetValue);
    if (!nullToAbsent || exerciseName != null) {
      map['exercise_name'] = Variable<String>(exerciseName);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  PersonalGoalsCompanion toCompanion(bool nullToAbsent) {
    return PersonalGoalsCompanion(
      id: Value(id),
      type: Value(type),
      targetValue: Value(targetValue),
      exerciseName: exerciseName == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseName),
      createdAt: Value(createdAt),
    );
  }

  factory PersonalGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalGoal(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      exerciseName: serializer.fromJson<String?>(json['exerciseName']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'targetValue': serializer.toJson<double>(targetValue),
      'exerciseName': serializer.toJson<String?>(exerciseName),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  PersonalGoal copyWith({
    String? id,
    String? type,
    double? targetValue,
    Value<String?> exerciseName = const Value.absent(),
    String? createdAt,
  }) => PersonalGoal(
    id: id ?? this.id,
    type: type ?? this.type,
    targetValue: targetValue ?? this.targetValue,
    exerciseName: exerciseName.present ? exerciseName.value : this.exerciseName,
    createdAt: createdAt ?? this.createdAt,
  );
  PersonalGoal copyWithCompanion(PersonalGoalsCompanion data) {
    return PersonalGoal(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalGoal(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, targetValue, exerciseName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalGoal &&
          other.id == this.id &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.exerciseName == this.exerciseName &&
          other.createdAt == this.createdAt);
}

class PersonalGoalsCompanion extends UpdateCompanion<PersonalGoal> {
  final Value<String> id;
  final Value<String> type;
  final Value<double> targetValue;
  final Value<String?> exerciseName;
  final Value<String> createdAt;
  final Value<int> rowid;
  const PersonalGoalsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalGoalsCompanion.insert({
    required String id,
    required String type,
    required double targetValue,
    this.exerciseName = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       targetValue = Value(targetValue),
       createdAt = Value(createdAt);
  static Insertable<PersonalGoal> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<double>? targetValue,
    Expression<String>? exerciseName,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<double>? targetValue,
    Value<String?>? exerciseName,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return PersonalGoalsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      exerciseName: exerciseName ?? this.exerciseName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalGoalsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataData extends DataClass implements Insertable<AppMetadataData> {
  final String key;
  final String value;
  const AppMetadataData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetadataData copyWith({String? key, String? value}) =>
      AppMetadataData(key: key ?? this.key, value: value ?? this.value);
  AppMetadataData copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrainingPlansTable trainingPlans = $TrainingPlansTable(this);
  late final $TrainingPlanDaysTable trainingPlanDays = $TrainingPlanDaysTable(
    this,
  );
  late final $TrainingPlanEquipmentTable trainingPlanEquipment =
      $TrainingPlanEquipmentTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutSessionExercisesTable workoutSessionExercises =
      $WorkoutSessionExercisesTable(this);
  late final $WorkoutSetEntriesTable workoutSetEntries =
      $WorkoutSetEntriesTable(this);
  late final $ScheduledTrainingSessionsTable scheduledTrainingSessions =
      $ScheduledTrainingSessionsTable(this);
  late final $PersonalGoalsTable personalGoals = $PersonalGoalsTable(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  late final Index workoutSessionsScheduledDateIdx = Index(
    'workout_sessions_scheduled_date_idx',
    'CREATE INDEX workout_sessions_scheduled_date_idx ON workout_sessions (scheduled_date)',
  );
  late final Index workoutSessionsCompletedAtIdx = Index(
    'workout_sessions_completed_at_idx',
    'CREATE INDEX workout_sessions_completed_at_idx ON workout_sessions (completed_at)',
  );
  late final Index scheduledTrainingSessionsDateIdx = Index(
    'scheduled_training_sessions_date_idx',
    'CREATE UNIQUE INDEX scheduled_training_sessions_date_idx ON scheduled_training_sessions (scheduled_date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trainingPlans,
    trainingPlanDays,
    trainingPlanEquipment,
    workoutSessions,
    workoutSessionExercises,
    workoutSetEntries,
    scheduledTrainingSessions,
    personalGoals,
    appMetadata,
    workoutSessionsScheduledDateIdx,
    workoutSessionsCompletedAtIdx,
    scheduledTrainingSessionsDateIdx,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'training_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('training_plan_days', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'training_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('training_plan_equipment', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'training_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('workout_session_exercises', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_set_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TrainingPlansTableCreateCompanionBuilder =
    TrainingPlansCompanion Function({
      required String id,
      required String goal,
      required String experience,
      required int sessionMinutes,
      Value<int> version,
      required String createdAt,
      required String updatedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$TrainingPlansTableUpdateCompanionBuilder =
    TrainingPlansCompanion Function({
      Value<String> id,
      Value<String> goal,
      Value<String> experience,
      Value<int> sessionMinutes,
      Value<int> version,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$TrainingPlansTableReferences
    extends BaseReferences<_$AppDatabase, $TrainingPlansTable, TrainingPlan> {
  $$TrainingPlansTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TrainingPlanDaysTable, List<TrainingPlanDay>>
  _trainingPlanDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trainingPlanDays,
    aliasName: 'training_plans__id__training_plan_days__plan_id',
  );

  $$TrainingPlanDaysTableProcessedTableManager get trainingPlanDaysRefs {
    final manager = $$TrainingPlanDaysTableTableManager(
      $_db,
      $_db.trainingPlanDays,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trainingPlanDaysRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TrainingPlanEquipmentTable,
    List<TrainingPlanEquipmentData>
  >
  _trainingPlanEquipmentRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trainingPlanEquipment,
        aliasName: 'training_plans__id__training_plan_equipment__plan_id',
      );

  $$TrainingPlanEquipmentTableProcessedTableManager
  get trainingPlanEquipmentRefs {
    final manager = $$TrainingPlanEquipmentTableTableManager(
      $_db,
      $_db.trainingPlanEquipment,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trainingPlanEquipmentRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'training_plans__id__workout_sessions__plan_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrainingPlansTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableFilterComposer({
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

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trainingPlanDaysRefs(
    Expression<bool> Function($$TrainingPlanDaysTableFilterComposer f) f,
  ) {
    final $$TrainingPlanDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingPlanDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlanDaysTableFilterComposer(
            $db: $db,
            $table: $db.trainingPlanDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trainingPlanEquipmentRefs(
    Expression<bool> Function($$TrainingPlanEquipmentTableFilterComposer f) f,
  ) {
    final $$TrainingPlanEquipmentTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trainingPlanEquipment,
          getReferencedColumn: (t) => t.planId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrainingPlanEquipmentTableFilterComposer(
                $db: $db,
                $table: $db.trainingPlanEquipment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableOrderingComposer({
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

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrainingPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> trainingPlanDaysRefs<T extends Object>(
    Expression<T> Function($$TrainingPlanDaysTableAnnotationComposer a) f,
  ) {
    final $$TrainingPlanDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trainingPlanDays,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlanDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingPlanDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trainingPlanEquipmentRefs<T extends Object>(
    Expression<T> Function($$TrainingPlanEquipmentTableAnnotationComposer a) f,
  ) {
    final $$TrainingPlanEquipmentTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trainingPlanEquipment,
          getReferencedColumn: (t) => t.planId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrainingPlanEquipmentTableAnnotationComposer(
                $db: $db,
                $table: $db.trainingPlanEquipment,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrainingPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingPlansTable,
          TrainingPlan,
          $$TrainingPlansTableFilterComposer,
          $$TrainingPlansTableOrderingComposer,
          $$TrainingPlansTableAnnotationComposer,
          $$TrainingPlansTableCreateCompanionBuilder,
          $$TrainingPlansTableUpdateCompanionBuilder,
          (TrainingPlan, $$TrainingPlansTableReferences),
          TrainingPlan,
          PrefetchHooks Function({
            bool trainingPlanDaysRefs,
            bool trainingPlanEquipmentRefs,
            bool workoutSessionsRefs,
          })
        > {
  $$TrainingPlansTableTableManager(_$AppDatabase db, $TrainingPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> experience = const Value.absent(),
                Value<int> sessionMinutes = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingPlansCompanion(
                id: id,
                goal: goal,
                experience: experience,
                sessionMinutes: sessionMinutes,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goal,
                required String experience,
                required int sessionMinutes,
                Value<int> version = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrainingPlansCompanion.insert(
                id: id,
                goal: goal,
                experience: experience,
                sessionMinutes: sessionMinutes,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainingPlansTable, TrainingPlan>(table),
                  $$TrainingPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                trainingPlanDaysRefs = false,
                trainingPlanEquipmentRefs = false,
                workoutSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trainingPlanDaysRefs) db.trainingPlanDays,
                    if (trainingPlanEquipmentRefs) db.trainingPlanEquipment,
                    if (workoutSessionsRefs) db.workoutSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trainingPlanDaysRefs)
                        await $_getPrefetchedDataByColumns<
                          TrainingPlan,
                          $TrainingPlansTable,
                          TrainingPlanDay,
                          $TrainingPlanDaysTable
                        >(
                          currentTable: table,
                          referencedTable: $$TrainingPlansTableReferences
                              ._trainingPlanDaysRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrainingPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).trainingPlanDaysRefs,
                          currentColumn: 'id',
                          referencedColumn: 'plan_id',
                          typedResults: items,
                        ),
                      if (trainingPlanEquipmentRefs)
                        await $_getPrefetchedDataByColumns<
                          TrainingPlan,
                          $TrainingPlansTable,
                          TrainingPlanEquipmentData,
                          $TrainingPlanEquipmentTable
                        >(
                          currentTable: table,
                          referencedTable: $$TrainingPlansTableReferences
                              ._trainingPlanEquipmentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrainingPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).trainingPlanEquipmentRefs,
                          currentColumn: 'id',
                          referencedColumn: 'plan_id',
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          TrainingPlan,
                          $TrainingPlansTable,
                          WorkoutSession,
                          $WorkoutSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TrainingPlansTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrainingPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'plan_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TrainingPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingPlansTable,
      TrainingPlan,
      $$TrainingPlansTableFilterComposer,
      $$TrainingPlansTableOrderingComposer,
      $$TrainingPlansTableAnnotationComposer,
      $$TrainingPlansTableCreateCompanionBuilder,
      $$TrainingPlansTableUpdateCompanionBuilder,
      (TrainingPlan, $$TrainingPlansTableReferences),
      TrainingPlan,
      PrefetchHooks Function({
        bool trainingPlanDaysRefs,
        bool trainingPlanEquipmentRefs,
        bool workoutSessionsRefs,
      })
    >;
typedef $$TrainingPlanDaysTableCreateCompanionBuilder =
    TrainingPlanDaysCompanion Function({
      Value<int> id,
      required String planId,
      required int weekday,
      required int orderIndex,
    });
typedef $$TrainingPlanDaysTableUpdateCompanionBuilder =
    TrainingPlanDaysCompanion Function({
      Value<int> id,
      Value<String> planId,
      Value<int> weekday,
      Value<int> orderIndex,
    });

final class $$TrainingPlanDaysTableReferences
    extends
        BaseReferences<_$AppDatabase, $TrainingPlanDaysTable, TrainingPlanDay> {
  $$TrainingPlanDaysTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrainingPlansTable _planIdTable(_$AppDatabase db) => db.trainingPlans
      .createAlias('training_plan_days__plan_id__training_plans__id');

  $$TrainingPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$TrainingPlansTableTableManager(
      $_db,
      $_db.trainingPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrainingPlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingPlanDaysTable> {
  $$TrainingPlanDaysTableFilterComposer({
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

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$TrainingPlansTableFilterComposer get planId {
    final $$TrainingPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableFilterComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingPlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingPlanDaysTable> {
  $$TrainingPlanDaysTableOrderingComposer({
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

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrainingPlansTableOrderingComposer get planId {
    final $$TrainingPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableOrderingComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingPlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingPlanDaysTable> {
  $$TrainingPlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$TrainingPlansTableAnnotationComposer get planId {
    final $$TrainingPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingPlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingPlanDaysTable,
          TrainingPlanDay,
          $$TrainingPlanDaysTableFilterComposer,
          $$TrainingPlanDaysTableOrderingComposer,
          $$TrainingPlanDaysTableAnnotationComposer,
          $$TrainingPlanDaysTableCreateCompanionBuilder,
          $$TrainingPlanDaysTableUpdateCompanionBuilder,
          (TrainingPlanDay, $$TrainingPlanDaysTableReferences),
          TrainingPlanDay,
          PrefetchHooks Function({bool planId})
        > {
  $$TrainingPlanDaysTableTableManager(
    _$AppDatabase db,
    $TrainingPlanDaysTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingPlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingPlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingPlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => TrainingPlanDaysCompanion(
                id: id,
                planId: planId,
                weekday: weekday,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String planId,
                required int weekday,
                required int orderIndex,
              }) => TrainingPlanDaysCompanion.insert(
                id: id,
                planId: planId,
                weekday: weekday,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrainingPlanDaysTable, TrainingPlanDay>(table),
                  $$TrainingPlanDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.planId,
                        referencedTable: $$TrainingPlanDaysTableReferences
                            ._planIdTable(db),
                        referencedColumn: $$TrainingPlanDaysTableReferences
                            ._planIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrainingPlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingPlanDaysTable,
      TrainingPlanDay,
      $$TrainingPlanDaysTableFilterComposer,
      $$TrainingPlanDaysTableOrderingComposer,
      $$TrainingPlanDaysTableAnnotationComposer,
      $$TrainingPlanDaysTableCreateCompanionBuilder,
      $$TrainingPlanDaysTableUpdateCompanionBuilder,
      (TrainingPlanDay, $$TrainingPlanDaysTableReferences),
      TrainingPlanDay,
      PrefetchHooks Function({bool planId})
    >;
typedef $$TrainingPlanEquipmentTableCreateCompanionBuilder =
    TrainingPlanEquipmentCompanion Function({
      Value<int> id,
      required String planId,
      required String equipment,
    });
typedef $$TrainingPlanEquipmentTableUpdateCompanionBuilder =
    TrainingPlanEquipmentCompanion Function({
      Value<int> id,
      Value<String> planId,
      Value<String> equipment,
    });

final class $$TrainingPlanEquipmentTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrainingPlanEquipmentTable,
          TrainingPlanEquipmentData
        > {
  $$TrainingPlanEquipmentTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrainingPlansTable _planIdTable(_$AppDatabase db) => db.trainingPlans
      .createAlias('training_plan_equipment__plan_id__training_plans__id');

  $$TrainingPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<String>('plan_id')!;

    final manager = $$TrainingPlansTableTableManager(
      $_db,
      $_db.trainingPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrainingPlanEquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingPlanEquipmentTable> {
  $$TrainingPlanEquipmentTableFilterComposer({
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

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  $$TrainingPlansTableFilterComposer get planId {
    final $$TrainingPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableFilterComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingPlanEquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingPlanEquipmentTable> {
  $$TrainingPlanEquipmentTableOrderingComposer({
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

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrainingPlansTableOrderingComposer get planId {
    final $$TrainingPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableOrderingComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingPlanEquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingPlanEquipmentTable> {
  $$TrainingPlanEquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  $$TrainingPlansTableAnnotationComposer get planId {
    final $$TrainingPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrainingPlanEquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingPlanEquipmentTable,
          TrainingPlanEquipmentData,
          $$TrainingPlanEquipmentTableFilterComposer,
          $$TrainingPlanEquipmentTableOrderingComposer,
          $$TrainingPlanEquipmentTableAnnotationComposer,
          $$TrainingPlanEquipmentTableCreateCompanionBuilder,
          $$TrainingPlanEquipmentTableUpdateCompanionBuilder,
          (TrainingPlanEquipmentData, $$TrainingPlanEquipmentTableReferences),
          TrainingPlanEquipmentData,
          PrefetchHooks Function({bool planId})
        > {
  $$TrainingPlanEquipmentTableTableManager(
    _$AppDatabase db,
    $TrainingPlanEquipmentTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingPlanEquipmentTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TrainingPlanEquipmentTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TrainingPlanEquipmentTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> equipment = const Value.absent(),
              }) => TrainingPlanEquipmentCompanion(
                id: id,
                planId: planId,
                equipment: equipment,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String planId,
                required String equipment,
              }) => TrainingPlanEquipmentCompanion.insert(
                id: id,
                planId: planId,
                equipment: equipment,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $TrainingPlanEquipmentTable,
                    TrainingPlanEquipmentData
                  >(table),
                  $$TrainingPlanEquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.planId,
                        referencedTable: $$TrainingPlanEquipmentTableReferences
                            ._planIdTable(db),
                        referencedColumn: $$TrainingPlanEquipmentTableReferences
                            ._planIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrainingPlanEquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingPlanEquipmentTable,
      TrainingPlanEquipmentData,
      $$TrainingPlanEquipmentTableFilterComposer,
      $$TrainingPlanEquipmentTableOrderingComposer,
      $$TrainingPlanEquipmentTableAnnotationComposer,
      $$TrainingPlanEquipmentTableCreateCompanionBuilder,
      $$TrainingPlanEquipmentTableUpdateCompanionBuilder,
      (TrainingPlanEquipmentData, $$TrainingPlanEquipmentTableReferences),
      TrainingPlanEquipmentData,
      PrefetchHooks Function({bool planId})
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      Value<String?> planId,
      required String scheduledDate,
      required String completedAt,
      required String title,
      required String goal,
      Value<int> planVersion,
      Value<String?> planSnapshot,
      required int durationMinutes,
      required int exerciseCount,
      required bool completedOutsideApp,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String?> planId,
      Value<String> scheduledDate,
      Value<String> completedAt,
      Value<String> title,
      Value<String> goal,
      Value<int> planVersion,
      Value<String?> planSnapshot,
      Value<int> durationMinutes,
      Value<int> exerciseCount,
      Value<bool> completedOutsideApp,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrainingPlansTable _planIdTable(_$AppDatabase db) => db.trainingPlans
      .createAlias('workout_sessions__plan_id__training_plans__id');

  $$TrainingPlansTableProcessedTableManager? get planId {
    final $_column = $_itemColumn<String>('plan_id');
    if ($_column == null) return null;
    final manager = $$TrainingPlansTableTableManager(
      $_db,
      $_db.trainingPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $WorkoutSessionExercisesTable,
    List<WorkoutSessionExercise>
  >
  _workoutSessionExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutSessionExercises,
        aliasName:
            'workout_sessions__id__workout_session_exercises__session_id',
      );

  $$WorkoutSessionExercisesTableProcessedTableManager
  get workoutSessionExercisesRefs {
    final manager = $$WorkoutSessionExercisesTableTableManager(
      $_db,
      $_db.workoutSessionExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSetEntriesTable, List<WorkoutSetEntry>>
  _workoutSetEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutSetEntries,
        aliasName: 'workout_sessions__id__workout_set_entries__session_id',
      );

  $$WorkoutSetEntriesTableProcessedTableManager get workoutSetEntriesRefs {
    final manager = $$WorkoutSetEntriesTableTableManager(
      $_db,
      $_db.workoutSetEntries,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSetEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
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

  ColumnFilters<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planVersion => $composableBuilder(
    column: $table.planVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planSnapshot => $composableBuilder(
    column: $table.planSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completedOutsideApp => $composableBuilder(
    column: $table.completedOutsideApp,
    builder: (column) => ColumnFilters(column),
  );

  $$TrainingPlansTableFilterComposer get planId {
    final $$TrainingPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableFilterComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSessionExercisesRefs(
    Expression<bool> Function($$WorkoutSessionExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSessionExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExercisesTableFilterComposer(
                $db: $db,
                $table: $db.workoutSessionExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> workoutSetEntriesRefs(
    Expression<bool> Function($$WorkoutSetEntriesTableFilterComposer f) f,
  ) {
    final $$WorkoutSetEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetEntriesTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planVersion => $composableBuilder(
    column: $table.planVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planSnapshot => $composableBuilder(
    column: $table.planSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completedOutsideApp => $composableBuilder(
    column: $table.completedOutsideApp,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrainingPlansTableOrderingComposer get planId {
    final $$TrainingPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableOrderingComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<int> get planVersion => $composableBuilder(
    column: $table.planVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planSnapshot => $composableBuilder(
    column: $table.planSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completedOutsideApp => $composableBuilder(
    column: $table.completedOutsideApp,
    builder: (column) => column,
  );

  $$TrainingPlansTableAnnotationComposer get planId {
    final $$TrainingPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.trainingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrainingPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.trainingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSessionExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionExercisesTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutSessionExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSessionExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSessionExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSessionExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workoutSetEntriesRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetEntriesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSetEntries,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSetEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSetEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({
            bool planId,
            bool workoutSessionExercisesRefs,
            bool workoutSetEntriesRefs,
          })
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<String> scheduledDate = const Value.absent(),
                Value<String> completedAt = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<int> planVersion = const Value.absent(),
                Value<String?> planSnapshot = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> exerciseCount = const Value.absent(),
                Value<bool> completedOutsideApp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                planId: planId,
                scheduledDate: scheduledDate,
                completedAt: completedAt,
                title: title,
                goal: goal,
                planVersion: planVersion,
                planSnapshot: planSnapshot,
                durationMinutes: durationMinutes,
                exerciseCount: exerciseCount,
                completedOutsideApp: completedOutsideApp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> planId = const Value.absent(),
                required String scheduledDate,
                required String completedAt,
                required String title,
                required String goal,
                Value<int> planVersion = const Value.absent(),
                Value<String?> planSnapshot = const Value.absent(),
                required int durationMinutes,
                required int exerciseCount,
                required bool completedOutsideApp,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                planId: planId,
                scheduledDate: scheduledDate,
                completedAt: completedAt,
                title: title,
                goal: goal,
                planVersion: planVersion,
                planSnapshot: planSnapshot,
                durationMinutes: durationMinutes,
                exerciseCount: exerciseCount,
                completedOutsideApp: completedOutsideApp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planId = false,
                workoutSessionExercisesRefs = false,
                workoutSetEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSessionExercisesRefs) db.workoutSessionExercises,
                    if (workoutSetEntriesRefs) db.workoutSetEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._planIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._planIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSessionExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          WorkoutSessionExercise,
                          $WorkoutSessionExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._workoutSessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                      if (workoutSetEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          WorkoutSetEntry,
                          $WorkoutSetEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._workoutSetEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({
        bool planId,
        bool workoutSessionExercisesRefs,
        bool workoutSetEntriesRefs,
      })
    >;
typedef $$WorkoutSessionExercisesTableCreateCompanionBuilder =
    WorkoutSessionExercisesCompanion Function({
      Value<int> id,
      required String sessionId,
      required int position,
      required String name,
      Value<String?> catalogId,
    });
typedef $$WorkoutSessionExercisesTableUpdateCompanionBuilder =
    WorkoutSessionExercisesCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<int> position,
      Value<String> name,
      Value<String?> catalogId,
    });

final class $$WorkoutSessionExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSessionExercisesTable,
          WorkoutSessionExercise
        > {
  $$WorkoutSessionExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias(
        'workout_session_exercises__session_id__workout_sessions__id',
      );

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionExercisesTable> {
  $$WorkoutSessionExercisesTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionExercisesTable> {
  $$WorkoutSessionExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionExercisesTable> {
  $$WorkoutSessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionExercisesTable,
          WorkoutSessionExercise,
          $$WorkoutSessionExercisesTableFilterComposer,
          $$WorkoutSessionExercisesTableOrderingComposer,
          $$WorkoutSessionExercisesTableAnnotationComposer,
          $$WorkoutSessionExercisesTableCreateCompanionBuilder,
          $$WorkoutSessionExercisesTableUpdateCompanionBuilder,
          (WorkoutSessionExercise, $$WorkoutSessionExercisesTableReferences),
          WorkoutSessionExercise,
          PrefetchHooks Function({bool sessionId})
        > {
  $$WorkoutSessionExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionExercisesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutSessionExercisesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutSessionExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> catalogId = const Value.absent(),
              }) => WorkoutSessionExercisesCompanion(
                id: id,
                sessionId: sessionId,
                position: position,
                name: name,
                catalogId: catalogId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required int position,
                required String name,
                Value<String?> catalogId = const Value.absent(),
              }) => WorkoutSessionExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                position: position,
                name: name,
                catalogId: catalogId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WorkoutSessionExercisesTable,
                    WorkoutSessionExercise
                  >(table),
                  $$WorkoutSessionExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable:
                            $$WorkoutSessionExercisesTableReferences
                                ._sessionIdTable(db),
                        referencedColumn:
                            $$WorkoutSessionExercisesTableReferences
                                ._sessionIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionExercisesTable,
      WorkoutSessionExercise,
      $$WorkoutSessionExercisesTableFilterComposer,
      $$WorkoutSessionExercisesTableOrderingComposer,
      $$WorkoutSessionExercisesTableAnnotationComposer,
      $$WorkoutSessionExercisesTableCreateCompanionBuilder,
      $$WorkoutSessionExercisesTableUpdateCompanionBuilder,
      (WorkoutSessionExercise, $$WorkoutSessionExercisesTableReferences),
      WorkoutSessionExercise,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$WorkoutSetEntriesTableCreateCompanionBuilder =
    WorkoutSetEntriesCompanion Function({
      Value<int> id,
      required String sessionId,
      required int exercisePosition,
      required int setIndex,
      Value<int?> repetitions,
      Value<double?> loadKg,
      Value<int?> durationSeconds,
    });
typedef $$WorkoutSetEntriesTableUpdateCompanionBuilder =
    WorkoutSetEntriesCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<int> exercisePosition,
      Value<int> setIndex,
      Value<int?> repetitions,
      Value<double?> loadKg,
      Value<int?> durationSeconds,
    });

final class $$WorkoutSetEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSetEntriesTable,
          WorkoutSetEntry
        > {
  $$WorkoutSetEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_set_entries__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetEntriesTable> {
  $$WorkoutSetEntriesTableFilterComposer({
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

  ColumnFilters<int> get exercisePosition => $composableBuilder(
    column: $table.exercisePosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetEntriesTable> {
  $$WorkoutSetEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get exercisePosition => $composableBuilder(
    column: $table.exercisePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadKg => $composableBuilder(
    column: $table.loadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetEntriesTable> {
  $$WorkoutSetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exercisePosition => $composableBuilder(
    column: $table.exercisePosition,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loadKg =>
      $composableBuilder(column: $table.loadKg, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetEntriesTable,
          WorkoutSetEntry,
          $$WorkoutSetEntriesTableFilterComposer,
          $$WorkoutSetEntriesTableOrderingComposer,
          $$WorkoutSetEntriesTableAnnotationComposer,
          $$WorkoutSetEntriesTableCreateCompanionBuilder,
          $$WorkoutSetEntriesTableUpdateCompanionBuilder,
          (WorkoutSetEntry, $$WorkoutSetEntriesTableReferences),
          WorkoutSetEntry,
          PrefetchHooks Function({bool sessionId})
        > {
  $$WorkoutSetEntriesTableTableManager(
    _$AppDatabase db,
    $WorkoutSetEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> exercisePosition = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<double?> loadKg = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
              }) => WorkoutSetEntriesCompanion(
                id: id,
                sessionId: sessionId,
                exercisePosition: exercisePosition,
                setIndex: setIndex,
                repetitions: repetitions,
                loadKg: loadKg,
                durationSeconds: durationSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required int exercisePosition,
                required int setIndex,
                Value<int?> repetitions = const Value.absent(),
                Value<double?> loadKg = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
              }) => WorkoutSetEntriesCompanion.insert(
                id: id,
                sessionId: sessionId,
                exercisePosition: exercisePosition,
                setIndex: setIndex,
                repetitions: repetitions,
                loadKg: loadKg,
                durationSeconds: durationSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetEntriesTable, WorkoutSetEntry>(table),
                  $$WorkoutSetEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$WorkoutSetEntriesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$WorkoutSetEntriesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetEntriesTable,
      WorkoutSetEntry,
      $$WorkoutSetEntriesTableFilterComposer,
      $$WorkoutSetEntriesTableOrderingComposer,
      $$WorkoutSetEntriesTableAnnotationComposer,
      $$WorkoutSetEntriesTableCreateCompanionBuilder,
      $$WorkoutSetEntriesTableUpdateCompanionBuilder,
      (WorkoutSetEntry, $$WorkoutSetEntriesTableReferences),
      WorkoutSetEntry,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$ScheduledTrainingSessionsTableCreateCompanionBuilder =
    ScheduledTrainingSessionsCompanion Function({
      required String id,
      required String scheduledDate,
      Value<String?> originalDate,
      required int sessionIndex,
      required String title,
      required String focus,
      required int durationMinutes,
      required int exerciseCount,
      Value<int> planVersion,
      Value<String> planSnapshot,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$ScheduledTrainingSessionsTableUpdateCompanionBuilder =
    ScheduledTrainingSessionsCompanion Function({
      Value<String> id,
      Value<String> scheduledDate,
      Value<String?> originalDate,
      Value<int> sessionIndex,
      Value<String> title,
      Value<String> focus,
      Value<int> durationMinutes,
      Value<int> exerciseCount,
      Value<int> planVersion,
      Value<String> planSnapshot,
      Value<String> status,
      Value<int> rowid,
    });

class $$ScheduledTrainingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledTrainingSessionsTable> {
  $$ScheduledTrainingSessionsTableFilterComposer({
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

  ColumnFilters<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalDate => $composableBuilder(
    column: $table.originalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionIndex => $composableBuilder(
    column: $table.sessionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get planVersion => $composableBuilder(
    column: $table.planVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planSnapshot => $composableBuilder(
    column: $table.planSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduledTrainingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledTrainingSessionsTable> {
  $$ScheduledTrainingSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalDate => $composableBuilder(
    column: $table.originalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionIndex => $composableBuilder(
    column: $table.sessionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get planVersion => $composableBuilder(
    column: $table.planVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planSnapshot => $composableBuilder(
    column: $table.planSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduledTrainingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledTrainingSessionsTable> {
  $$ScheduledTrainingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalDate => $composableBuilder(
    column: $table.originalDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionIndex => $composableBuilder(
    column: $table.sessionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get planVersion => $composableBuilder(
    column: $table.planVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planSnapshot => $composableBuilder(
    column: $table.planSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ScheduledTrainingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledTrainingSessionsTable,
          ScheduledTrainingSession,
          $$ScheduledTrainingSessionsTableFilterComposer,
          $$ScheduledTrainingSessionsTableOrderingComposer,
          $$ScheduledTrainingSessionsTableAnnotationComposer,
          $$ScheduledTrainingSessionsTableCreateCompanionBuilder,
          $$ScheduledTrainingSessionsTableUpdateCompanionBuilder,
          (
            ScheduledTrainingSession,
            BaseReferences<
              _$AppDatabase,
              $ScheduledTrainingSessionsTable,
              ScheduledTrainingSession
            >,
          ),
          ScheduledTrainingSession,
          PrefetchHooks Function()
        > {
  $$ScheduledTrainingSessionsTableTableManager(
    _$AppDatabase db,
    $ScheduledTrainingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledTrainingSessionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ScheduledTrainingSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ScheduledTrainingSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scheduledDate = const Value.absent(),
                Value<String?> originalDate = const Value.absent(),
                Value<int> sessionIndex = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> exerciseCount = const Value.absent(),
                Value<int> planVersion = const Value.absent(),
                Value<String> planSnapshot = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduledTrainingSessionsCompanion(
                id: id,
                scheduledDate: scheduledDate,
                originalDate: originalDate,
                sessionIndex: sessionIndex,
                title: title,
                focus: focus,
                durationMinutes: durationMinutes,
                exerciseCount: exerciseCount,
                planVersion: planVersion,
                planSnapshot: planSnapshot,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scheduledDate,
                Value<String?> originalDate = const Value.absent(),
                required int sessionIndex,
                required String title,
                required String focus,
                required int durationMinutes,
                required int exerciseCount,
                Value<int> planVersion = const Value.absent(),
                Value<String> planSnapshot = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduledTrainingSessionsCompanion.insert(
                id: id,
                scheduledDate: scheduledDate,
                originalDate: originalDate,
                sessionIndex: sessionIndex,
                title: title,
                focus: focus,
                durationMinutes: durationMinutes,
                exerciseCount: exerciseCount,
                planVersion: planVersion,
                planSnapshot: planSnapshot,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $ScheduledTrainingSessionsTable,
                    ScheduledTrainingSession
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ScheduledTrainingSessionsTable,
                    ScheduledTrainingSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduledTrainingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledTrainingSessionsTable,
      ScheduledTrainingSession,
      $$ScheduledTrainingSessionsTableFilterComposer,
      $$ScheduledTrainingSessionsTableOrderingComposer,
      $$ScheduledTrainingSessionsTableAnnotationComposer,
      $$ScheduledTrainingSessionsTableCreateCompanionBuilder,
      $$ScheduledTrainingSessionsTableUpdateCompanionBuilder,
      (
        ScheduledTrainingSession,
        BaseReferences<
          _$AppDatabase,
          $ScheduledTrainingSessionsTable,
          ScheduledTrainingSession
        >,
      ),
      ScheduledTrainingSession,
      PrefetchHooks Function()
    >;
typedef $$PersonalGoalsTableCreateCompanionBuilder =
    PersonalGoalsCompanion Function({
      required String id,
      required String type,
      required double targetValue,
      Value<String?> exerciseName,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$PersonalGoalsTableUpdateCompanionBuilder =
    PersonalGoalsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<double> targetValue,
      Value<String?> exerciseName,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$PersonalGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalGoalsTable> {
  $$PersonalGoalsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalGoalsTable> {
  $$PersonalGoalsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalGoalsTable> {
  $$PersonalGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PersonalGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalGoalsTable,
          PersonalGoal,
          $$PersonalGoalsTableFilterComposer,
          $$PersonalGoalsTableOrderingComposer,
          $$PersonalGoalsTableAnnotationComposer,
          $$PersonalGoalsTableCreateCompanionBuilder,
          $$PersonalGoalsTableUpdateCompanionBuilder,
          (
            PersonalGoal,
            BaseReferences<_$AppDatabase, $PersonalGoalsTable, PersonalGoal>,
          ),
          PersonalGoal,
          PrefetchHooks Function()
        > {
  $$PersonalGoalsTableTableManager(_$AppDatabase db, $PersonalGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<String?> exerciseName = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalGoalsCompanion(
                id: id,
                type: type,
                targetValue: targetValue,
                exerciseName: exerciseName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required double targetValue,
                Value<String?> exerciseName = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PersonalGoalsCompanion.insert(
                id: id,
                type: type,
                targetValue: targetValue,
                exerciseName: exerciseName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonalGoalsTable, PersonalGoal>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PersonalGoalsTable,
                    PersonalGoal
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalGoalsTable,
      PersonalGoal,
      $$PersonalGoalsTableFilterComposer,
      $$PersonalGoalsTableOrderingComposer,
      $$PersonalGoalsTableAnnotationComposer,
      $$PersonalGoalsTableCreateCompanionBuilder,
      $$PersonalGoalsTableUpdateCompanionBuilder,
      (
        PersonalGoal,
        BaseReferences<_$AppDatabase, $PersonalGoalsTable, PersonalGoal>,
      ),
      PersonalGoal,
      PrefetchHooks Function()
    >;
typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataData,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataData,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
          ),
          AppMetadataData,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppMetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppMetadataTable, AppMetadataData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppMetadataTable,
                    AppMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataData,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataData,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
      ),
      AppMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrainingPlansTableTableManager get trainingPlans =>
      $$TrainingPlansTableTableManager(_db, _db.trainingPlans);
  $$TrainingPlanDaysTableTableManager get trainingPlanDays =>
      $$TrainingPlanDaysTableTableManager(_db, _db.trainingPlanDays);
  $$TrainingPlanEquipmentTableTableManager get trainingPlanEquipment =>
      $$TrainingPlanEquipmentTableTableManager(_db, _db.trainingPlanEquipment);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSessionExercisesTableTableManager get workoutSessionExercises =>
      $$WorkoutSessionExercisesTableTableManager(
        _db,
        _db.workoutSessionExercises,
      );
  $$WorkoutSetEntriesTableTableManager get workoutSetEntries =>
      $$WorkoutSetEntriesTableTableManager(_db, _db.workoutSetEntries);
  $$ScheduledTrainingSessionsTableTableManager get scheduledTrainingSessions =>
      $$ScheduledTrainingSessionsTableTableManager(
        _db,
        _db.scheduledTrainingSessions,
      );
  $$PersonalGoalsTableTableManager get personalGoals =>
      $$PersonalGoalsTableTableManager(_db, _db.personalGoals);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
}
