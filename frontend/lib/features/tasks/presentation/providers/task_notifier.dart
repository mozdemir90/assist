import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/task_repository.dart';
import '../../domain/task_model.dart';

final taskByIdProvider = StreamProvider.autoDispose.family<TaskModel, String>((ref, id) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchTasks().map((tasks) => tasks.firstWhere((t) => t.id == id, orElse: () => throw Exception('Task not found')));
});

final taskListProvider = StreamProvider.family<List<TaskModel>, String?>((
  ref,
  listId,
) {
  final repo = ref.watch(taskRepositoryProvider);
  Future.microtask(() => repo.fetchAndSyncTasks());
  return repo.watchTasks().map((tasks) {
    if (listId != null) {
      return tasks.where((t) => t.listId == listId).toList();
    }
    // Smart Focus Logic for the main page (listId == null):
    // 1. Show all tasks with a deadline (regardless of list)
    // 2. Show tasks with NO list and NO deadline (Inbox)
    final filtered = tasks.where((t) {
      final hasDeadline = t.deadline != null;
      final hasNoList = t.listId == null;
      return hasDeadline || hasNoList;
    }).toList();

    // Sorting:
    // 1. Tasks with deadlines first (earliest first)
    // 2. Tasks without deadlines after
    filtered.sort((a, b) {
      if (a.deadline != null && b.deadline != null) {
        return a.deadline!.compareTo(b.deadline!);
      }
      if (a.deadline != null) return -1;
      if (b.deadline != null) return 1;
      return 0; // Same (inbox)
    });
    return filtered;
  });
});

class TaskNotifierActions {
  final TaskRepository repo;

  TaskNotifierActions(this.repo);

  Future<void> addTask(
    String title, {
    String description = '',
    String? listId,
    String? deadline,
  }) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      listId: listId,
      deadline: deadline,
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
