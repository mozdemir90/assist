import 'package:drift/drift.dart';
import '../app_database.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  final AppDatabase db;

  TasksDao(this.db) : super(db);

  Future<List<TaskEntity>> getAllTasks() =>
      (select(tasks)..where((t) => t.isDeleted.equals(false))).get();

  Stream<List<TaskEntity>> watchAllTasks() =>
      (select(tasks)..where((t) => t.isDeleted.equals(false))).watch();

  Future<int> insertTask(TaskEntity task) =>
      into(tasks).insert(task, mode: InsertMode.insertOrReplace);

  Future<bool> updateTask(TaskEntity task) => update(tasks).replace(task);

  // Soft delete logic for sync purposes
  Future<int> softDeleteTask(String id) {
    return (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
