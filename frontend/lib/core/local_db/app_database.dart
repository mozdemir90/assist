import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'daos/tasks_dao.dart';
import 'daos/activities_dao.dart';
import 'daos/lists_dao.dart';
import '../logger/app_logger.dart';

part 'app_database.g.dart';

// Lists Table
@DataClassName('ListEntity')
class Lists extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get color => text().nullable()();
  TextColumn get userId => text()();

  // Sync
  TextColumn get syncStatus => text().withDefault(const Constant('pending_insert'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tasks Table
@DataClassName('TaskEntity')
class Tasks extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get userId => text()();
  TextColumn get listId => text().nullable()();

  // Notification & Deadline
  DateTimeColumn get deadline => dateTime().nullable()();
  BoolColumn get remindViaEmail => boolean().withDefault(const Constant(false))();

  // Sync
  TextColumn get syncStatus => text().withDefault(const Constant('pending_insert'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Activities Table
@DataClassName('ActivityEntity')
class Activities extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()(); // Seconds
  TextColumn get userId => text()();

  // Sync
  TextColumn get syncStatus => text().withDefault(const Constant('pending_insert'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Reminders Table
@DataClassName('ReminderEntity')
class Reminders extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get message => text().nullable()();
  DateTimeColumn get triggerTime => dateTime()();
  BoolColumn get isSent => boolean().withDefault(const Constant(false))();

  TextColumn get taskId => text().nullable()();
  TextColumn get activityId => text().nullable()();
  TextColumn get userId => text()();

  // Sync
  TextColumn get syncStatus => text().withDefault(const Constant('pending_insert'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}


@DriftDatabase(tables: [Lists, Tasks, Activities, Reminders], daos: [ListsDao, TasksDao, ActivitiesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.createTable(lists);
          await m.addColumn(tasks, tasks.listId);
        }
        if (from < 3) {
          await m.addColumn(tasks, tasks.deadline);
          await m.addColumn(tasks, tasks.remindViaEmail);
        }
        if (from < 4) {
          await m.addColumn(tasks, tasks.syncStatus);
          await m.addColumn(lists, lists.syncStatus);
          await m.addColumn(activities, activities.syncStatus);
          await m.addColumn(reminders, reminders.syncStatus);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'offline_first_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            appLogger.w('Missing browser features: ${result.missingFeatures}');
          }
        },
      ),
    );
  }
}

@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
