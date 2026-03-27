import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/local_db/daos/tasks_dao.dart';
import '../domain/task_model.dart';
import 'task_api_service.dart';

part 'task_repository.g.dart';

class TaskRepository {
  final TasksDao _localDb;
  final TaskApiService _apiService;

  TaskRepository(this._localDb, this._apiService);

  // Read: Stream local data for instant UI updates (Offline First)
  Stream<List<TaskModel>> watchTasks() {
    return _localDb.watchAllTasks().map((entities) {
      return entities
          .map(
            (e) => TaskModel(
              id: e.id,
              title: e.title,
              description: e.description ?? '',
              isCompleted: e.isCompleted,
              userId: e.userId,
              listId: e.listId,
              deadline: e.deadline?.toIso8601String(),
              remindViaEmail: e.remindViaEmail,
              updatedAt: e.updatedAt?.toIso8601String(),
              isDeleted: e.isDeleted,
            ),
          )
          .toList();
    });
  }

  // Sync: Fetch from API and update local DB
  Future<void> fetchAndSyncTasks() async {
    try {
      final remoteTasks = await _apiService.getTasks();
      for (final task in remoteTasks) {
        await _localDb.insertTask(
          TaskEntity(
            id: task.id,
            title: task.title,
            description: task.description,
            isCompleted: task.isCompleted,
            userId: task.userId ?? '',
            listId: task.listId,
            deadline: task.deadline != null
                ? DateTime.parse(task.deadline!)
                : null,
            remindViaEmail: task.remindViaEmail,
            syncStatus: 'synced',
            updatedAt: task.updatedAt != null
                ? DateTime.parse(task.updatedAt!)
                : null,
            isDeleted: task.isDeleted,
          ),
        );
      }
    } on DioException catch (e) {
      // Ignore network errors, allow app to function offline
      print('Network sync failed: \${e.message}');
    }
  }

  // Create: Insert locally, then try to sync
  Future<void> createTask(TaskModel task) async {
    // 1. Save locally for instant UI
    final localTask = TaskEntity(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      userId: task.userId ?? 'offline_placeholder',
      listId: task.listId,
      deadline: task.deadline != null ? DateTime.parse(task.deadline!) : null,
      remindViaEmail: task.remindViaEmail,
      syncStatus: 'pending_insert',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
    );
    await _localDb.insertTask(localTask);

    // 2. Try to sync to backend
    try {
      final createdRemote = await _apiService.createTask(task);
      // Update local with any remote-generated fields (like real userId)
      await _localDb.insertTask(
        TaskEntity(
          id: createdRemote.id,
          title: createdRemote.title,
          description: createdRemote.description,
          isCompleted: createdRemote.isCompleted,
          userId: createdRemote.userId ?? '',
          listId: createdRemote.listId,
          deadline: createdRemote.deadline != null
              ? DateTime.parse(createdRemote.deadline!)
              : null,
          remindViaEmail: createdRemote.remindViaEmail,
          syncStatus: 'synced',
          updatedAt: createdRemote.updatedAt != null
              ? DateTime.parse(createdRemote.updatedAt!)
              : null,
          isDeleted: createdRemote.isDeleted,
        ),
      );
    } on DioException catch (_) {
      // Silently fail if offline. Next fetchAndSyncTasks or a dedicated SyncWorker will catch it.
    }
  }

  // Update
  Future<void> updateTask(TaskModel task) async {
    final localTask = TaskEntity(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      userId: task.userId ?? 'offline_placeholder',
      listId: task.listId,
      deadline: task.deadline != null ? DateTime.parse(task.deadline!) : null,
      remindViaEmail: task.remindViaEmail,
      syncStatus: 'pending_update',
      updatedAt: DateTime.now().toUtc(),
      isDeleted: task.isDeleted,
    );
    await _localDb.updateTask(localTask);

    try {
      await _apiService.updateTask(task);
      await _localDb.updateTask(localTask.copyWith(syncStatus: 'synced'));
    } on DioException catch (_) {}
  }

  // Delete (Soft Delete for sync)
  Future<void> deleteTask(String id) async {
    await _localDb.softDeleteTask(id);

    try {
      await _apiService.deleteTask(id);
    } on DioException catch (_) {}
  }
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(taskApiServiceProvider);
  return TaskRepository(db.tasksDao, api);
}
