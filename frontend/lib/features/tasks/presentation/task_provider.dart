import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/database/database.dart';
import '../data/repository/task_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchTasks();
});

class TaskNotifier extends Notifier<AsyncValue<void>> {
  TaskRepository get repository => ref.read(taskRepositoryProvider);

  @override
  AsyncValue<void> build() {
    Future.microtask(() => repository.fetchRemoteTasksAndMerge());
    return const AsyncData(null);
  }

  Future<void> addTask(String title, {String? description}) async {
    state = const AsyncLoading();
    try {
      await repository.addTask(title, description: description);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      await repository.toggleTaskCompletion(task);
    } catch (e) {
      print('Toggle failed: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);
    } catch (e) {
      print('Delete failed: $e');
    }
  }
}

final taskNotifierProvider = NotifierProvider<TaskNotifier, AsyncValue<void>>(() {
  return TaskNotifier();
});
