import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import 'package:drift/drift.dart' as drift;

final databaseProvider = Provider<AppDatabase>((ref) {
  try {
    final db = AppDatabase();
    ref.onDispose(() => db.close());
    return db;
  } catch (e, st) {
    print('🔥 DB Init Error: $e\n$st');
    rethrow;
  }
});

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  try {
    final db = ref.watch(databaseProvider);
    return db.watchAllTasks();
  } catch (e, st) {
    print('🔥 StreamProvider Error: $e\n$st');
    rethrow;
  }
});

class TaskNotifier extends Notifier<AsyncValue<void>> {
  AppDatabase get db => ref.read(databaseProvider);

  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

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

final taskNotifierProvider = NotifierProvider<TaskNotifier, AsyncValue<void>>(() {
  return TaskNotifier();
});
