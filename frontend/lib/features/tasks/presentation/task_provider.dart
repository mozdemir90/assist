import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import 'package:drift/drift.dart' as drift;

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllTasks();
});

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase db;

  TaskNotifier(this.db) : super(const AsyncData(null));

  Future<void> addTask(String title, {String? description}) async {
    state = const AsyncLoading();
    try {
      await db.insertTask(TasksCompanion(
        title: drift.Value(title),
        description: drift.Value.absentIfNull(description),
      ));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    await db.updateTask(task.copyWith(
      isCompleted: !task.isCompleted,
      syncStatus: 'pending_update',
      updatedAt: DateTime.now().toUtc(),
    ));
  }

  Future<void> deleteTask(String id) async {
    await db.softDeleteTask(id);
  }
}

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  return TaskNotifier(ref.watch(databaseProvider));
});
