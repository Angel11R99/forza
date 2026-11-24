import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class TrainingPlans extends Table {
  TextColumn get id => text()();
  TextColumn get goal => text()();
  TextColumn get experience => text()();
  IntColumn get sessionMinutes => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
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
  IntColumn get planVersion => integer().withDefault(const Constant(1))();
  TextColumn get planSnapshot => text().nullable()();
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
  TextColumn get catalogId => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {sessionId, position},
  ];
}

class WorkoutSetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get exercisePosition => integer()();
  IntColumn get setIndex => integer()();
  IntColumn get repetitions => integer().nullable()();
  RealColumn get loadKg => real().nullable()();
  IntColumn get durationSeconds => integer().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {sessionId, exercisePosition, setIndex},
  ];
}

@TableIndex(
  name: 'scheduled_training_sessions_date_idx',
  columns: {#scheduledDate},
  unique: true,
)
class ScheduledTrainingSessions extends Table {
  TextColumn get id => text()();
  TextColumn get scheduledDate => text()();
  TextColumn get originalDate => text().nullable()();
  IntColumn get sessionIndex => integer()();
  TextColumn get title => text()();
  TextColumn get focus => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get exerciseCount => integer()();
  IntColumn get planVersion => integer().withDefault(const Constant(1))();
  TextColumn get planSnapshot => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PersonalGoals extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  RealColumn get targetValue => real()();
  TextColumn get exerciseName => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(
  name: 'body_measurements_date_idx',
  columns: {#measurementDate},
  unique: true,
)
class BodyMeasurements extends Table {
  TextColumn get measurementDate => text()();
  RealColumn get weightKg => real()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get armCm => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {measurementDate};
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
    WorkoutSetEntries,
    ScheduledTrainingSessions,
    PersonalGoals,
    BodyMeasurements,
    AppMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const activePlanId = 'active';

  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'forza'));

  static final instance = AppDatabase();

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(workoutSetEntries);
      if (from < 3) await migrator.createTable(scheduledTrainingSessions);
      if (from < 4) await migrator.createTable(personalGoals);
      if (from < 5) {
        await migrator.addColumn(trainingPlans, trainingPlans.version);
        await migrator.addColumn(workoutSessions, workoutSessions.planVersion);
        await migrator.addColumn(workoutSessions, workoutSessions.planSnapshot);
        await migrator.addColumn(
          workoutSessionExercises,
          workoutSessionExercises.catalogId,
        );
        if (from >= 3) {
          await migrator.addColumn(
            scheduledTrainingSessions,
            scheduledTrainingSessions.planVersion,
          );
          await migrator.addColumn(
            scheduledTrainingSessions,
            scheduledTrainingSessions.planSnapshot,
          );
        }
      }
      if (from < 6) await migrator.createTable(bodyMeasurements);
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
