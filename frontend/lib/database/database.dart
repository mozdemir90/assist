import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(
    name: 'task_sync_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  ));

  @override
  int get schemaVersion => 1;

  // Stream of all tasks that are not marked as deleted locally
  Stream<List<Task>> watchAllTasks() {
    return (select(tasks)..where((t) => t.isDeleted.equals(false))).watch();
  }

  Future<int> insertTask(TasksCompanion task) {
    return into(tasks).insert(task);
  }

  Future<bool> updateTask(Task task) {
    return update(tasks).replace(task);
  }

  Future<int> softDeleteTask(String id) {
    return (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isDeleted: const Value(true),
        syncStatus: const Value('pending_delete'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
