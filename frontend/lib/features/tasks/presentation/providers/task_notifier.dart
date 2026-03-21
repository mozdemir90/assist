import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/task_repository.dart';
import '../../domain/task_model.dart';

final taskListProvider = StreamProvider<List<TaskModel>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  Future.microtask(() => repo.fetchAndSyncTasks());
  return repo.watchTasks();
});

class TaskNotifierActions {
  final TaskRepository repo;

  TaskNotifierActions(this.repo);

  Future<void> addTask(String title, {String description = '', String? listId}) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      listId: listId,
    );
    await repo.createTask(task);
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );
    await repo.updateTask(updatedTask);
  }

  Future<void> deleteTask(String id) async {
    await repo.deleteTask(id);
  }
}

final taskNotifierActionsProvider = Provider<TaskNotifierActions>((ref) {
  return TaskNotifierActions(ref.watch(taskRepositoryProvider));
});
