import 'package:dio/dio.dart';
<<<<<<< Updated upstream
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/local_db/daos/tasks_dao.dart';
=======
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/local_db/daos/tasks_dao.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/error/exceptions.dart';
>>>>>>> Stashed changes
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
          .map((e) => TaskModel(
                id: e.id,
                title: e.title,
                description: e.description ?? '',
                isCompleted: e.isCompleted,
                userId: e.userId,
                listId: e.listId,
<<<<<<< Updated upstream
=======
                deadline: e.deadline?.toIso8601String(),
                remindViaEmail: e.remindViaEmail,
>>>>>>> Stashed changes
                updatedAt: e.updatedAt?.toIso8601String(),
                isDeleted: e.isDeleted,
              ))
          .toList();
    });
  }

  // Sync: Fetch from API and update local DB
  Future<void> fetchAndSyncTasks() async {
<<<<<<< Updated upstream
=======
    await _pushPendingChanges();

>>>>>>> Stashed changes
    try {
      final remoteTasks = await _apiService.getTasks();
      for (final task in remoteTasks) {
        await _localDb.insertTask(TaskEntity(
          id: task.id,
          title: task.title,
          description: task.description,
          isCompleted: task.isCompleted,
          userId: task.userId ?? '',
          listId: task.listId,
<<<<<<< Updated upstream
=======
          deadline: task.deadline != null ? DateTime.parse(task.deadline!) : null,
          remindViaEmail: task.remindViaEmail,
          syncStatus: 'synced',
>>>>>>> Stashed changes
          updatedAt: task.updatedAt != null ? DateTime.parse(task.updatedAt!) : null,
          isDeleted: task.isDeleted,
        ));
      }
    } on DioException catch (e) {
<<<<<<< Updated upstream
      // Ignore network errors, allow app to function offline
      print('Network sync failed: \${e.message}');
=======
      appLogger.w('Network sync failed for tasks: \${e.message}');
    } catch (e, st) {
      appLogger.e('Unexpected error during task sync', error: e, stackTrace: st);
    }
  }

  Future<void> _pushPendingChanges() async {
    final pendingTasks = await _localDb.getPendingTasks();

    for (final taskEntity in pendingTasks) {
      final taskModel = TaskModel(
        id: taskEntity.id,
        title: taskEntity.title,
        description: taskEntity.description ?? '',
        isCompleted: taskEntity.isCompleted,
        userId: taskEntity.userId,
        listId: taskEntity.listId,
        deadline: taskEntity.deadline?.toIso8601String(),
        remindViaEmail: taskEntity.remindViaEmail,
        isDeleted: taskEntity.isDeleted,
      );

      try {
        if (taskEntity.syncStatus == 'pending_insert') {
          await _apiService.createTask(taskModel);
        } else if (taskEntity.syncStatus == 'pending_update') {
          await _apiService.updateTask(taskModel);
        } else if (taskEntity.syncStatus == 'pending_delete') {
          await _apiService.deleteTask(taskEntity.id);
        }

        await _localDb.updateTask(taskEntity.copyWith(syncStatus: 'synced'));
      } on DioException catch (_) {
        // Skip and retry later
      } catch (e, st) {
        appLogger.e('Failed to push pending task change', error: e, stackTrace: st);
      }
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
      deadline: task.deadline != null ? DateTime.parse(task.deadline!) : null,
      remindViaEmail: task.remindViaEmail,
      syncStatus: 'pending_insert',
>>>>>>> Stashed changes
      updatedAt: DateTime.now().toUtc(),
      isDeleted: false,
    );
    await _localDb.insertTask(localTask);
<<<<<<< Updated upstream

    // 2. Try to sync to backend
    try {
      final createdRemote = await _apiService.createTask(task);
      // Update local with any remote-generated fields (like real userId)
       await _localDb.insertTask(TaskEntity(
          id: createdRemote.id,
          title: createdRemote.title,
          description: createdRemote.description,
          isCompleted: createdRemote.isCompleted,
          userId: createdRemote.userId ?? '',
          listId: createdRemote.listId,
          updatedAt: createdRemote.updatedAt != null ? DateTime.parse(createdRemote.updatedAt!) : null,
          isDeleted: createdRemote.isDeleted,
        ));
    } on DioException catch (_) {
       // Silently fail if offline. Next fetchAndSyncTasks or a dedicated SyncWorker will catch it.
    }
=======
    fetchAndSyncTasks();
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
      deadline: task.deadline != null ? DateTime.parse(task.deadline!) : null,
      remindViaEmail: task.remindViaEmail,
      syncStatus: 'pending_update',
>>>>>>> Stashed changes
      updatedAt: DateTime.now().toUtc(),
      isDeleted: task.isDeleted,
    );
    await _localDb.updateTask(localTask);
<<<<<<< Updated upstream

    try {
      await _apiService.updateTask(task);
    } on DioException catch (_) {}
=======
    fetchAndSyncTasks();
>>>>>>> Stashed changes
  }

  // Delete (Soft Delete for sync)
  Future<void> deleteTask(String id) async {
    await _localDb.softDeleteTask(id);
<<<<<<< Updated upstream

    try {
      await _apiService.deleteTask(id);
    } on DioException catch (_) {}
=======
    fetchAndSyncTasks();
>>>>>>> Stashed changes
  }
}

@riverpod
<<<<<<< Updated upstream
TaskRepository taskRepository(Ref ref) {
=======
TaskRepository taskRepository(TaskRepositoryRef ref) {
>>>>>>> Stashed changes
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(taskApiServiceProvider);
  return TaskRepository(db.tasksDao, api);
}
