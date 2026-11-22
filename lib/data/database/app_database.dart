import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class TrainingPlans extends Table {
  TextColumn get id => text()();
  TextColumn get goal => text()();
  TextColumn get experience => text()();
  IntColumn get sessionMinutes => integer()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TrainingPlanDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get planId =>
      text().references(TrainingPlans, #id, onDelete: KeyAction.cascade)();
  IntColumn get weekday => integer()();
  IntColumn get orderIndex => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {planId, weekday},
  ];
}

class TrainingPlanEquipment extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get planId =>
      text().references(TrainingPlans, #id, onDelete: KeyAction.cascade)();
  TextColumn get equipment => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {planId, equipment},
  ];
}

@TableIndex(
  name: 'workout_sessions_scheduled_date_idx',
  columns: {#scheduledDate},
)
@TableIndex(name: 'workout_sessions_completed_at_idx', columns: {#completedAt})
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get planId => text().nullable().references(
    TrainingPlans,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get scheduledDate => text()();
  TextColumn get completedAt => text()();
  TextColumn get title => text()();
  TextColumn get goal => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get exerciseCount => integer()();
  BoolColumn get completedOutsideApp => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutSessionExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get name => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {sessionId, position},
  ];
}

class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    TrainingPlans,
    TrainingPlanDays,
    TrainingPlanEquipment,
    WorkoutSessions,
    WorkoutSessionExercises,
    AppMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const activePlanId = 'active';

  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'forza'));

  static final instance = AppDatabase();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
