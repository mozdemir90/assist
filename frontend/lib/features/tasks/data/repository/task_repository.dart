import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/database.dart';
import '../remote/task_remote_data_source.dart';
import 'package:drift/drift.dart' as drift;

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(
    ref.watch(databaseProvider),
    ref.watch(taskRemoteDataSourceProvider),
  );
});

class TaskRepository {
  final AppDatabase _localDb;
  final TaskRemoteDataSource _remoteApi;

  TaskRepository(this._localDb, this._remoteApi);

  Stream<List<Task>> watchTasks() {
    return _localDb.watchAllTasks();
  }

  Future<void> addTask(String title, {String? description}) async {
    // 1. Optimistically insert into local DB as 'pending_insert'
    final newTaskCompanion = TasksCompanion(
      title: drift.Value(title),
      description: drift.Value.absentIfNull(description),
      syncStatus: const drift.Value('pending_insert'),
    );

    // localDb insert returns the ID, but we generated a UUID client-side.
    // To get the exact object, we'd need to query it or map the companion.
    // For simplicity, we just insert.
    await _localDb.insertTask(newTaskCompanion);

    // 2. Trigger background sync
    _syncPendingChanges();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    // 1. Optimistic local update
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      syncStatus: 'pending_update',
      updatedAt: DateTime.now().toUtc(),
    );
    await _localDb.updateTask(updatedTask);

    // 2. Trigger background sync
    _syncPendingChanges();
  }

  Future<void> deleteTask(String id) async {
    // 1. Soft delete locally
    await _localDb.softDeleteTask(id);

    // 2. Trigger background sync
    _syncPendingChanges();
  }

  /// Extremely basic sync algorithm for Phase 1.
  /// In a real production app, this should be handled by an Isolate/WorkManager.
  Future<void> _syncPendingChanges() async {
    try {
      final pendingTasks = await (_localDb.select(_localDb.tasks)
            ..where((t) => t.syncStatus.isNotIn(['synced'])))
          .get();

      for (final task in pendingTasks) {
        if (task.syncStatus == 'pending_insert') {
          await _remoteApi.createTask({
            'id': task.id, // Pass the locally generated UUID to the backend
            'title': task.title,
            'description': task.description,
            'is_completed': task.isCompleted,
          });
          // Mark as synced
          await _localDb.updateTask(task.copyWith(syncStatus: 'synced'));
        } else if (task.syncStatus == 'pending_update') {
          // Assuming backend IDs and local IDs map correctly.
          await _remoteApi.updateTask(task.id, {
            'title': task.title,
            'description': task.description,
            'is_completed': task.isCompleted,
          });
          await _localDb.updateTask(task.copyWith(syncStatus: 'synced'));
        } else if (task.syncStatus == 'pending_delete') {
          await _remoteApi.deleteTask(task.id);
          // Optionally hard delete locally after successful server sync
          await (_localDb.delete(_localDb.tasks)..where((t) => t.id.equals(task.id))).go();
        }
      }
    } catch (e) {
      // Ignore network errors during sync. It will retry on next operation.
      print('Sync failed. Will retry later. Error: $e');
    }
  }

  /// Pull from server (e.g. on app start)
  Future<void> fetchRemoteTasksAndMerge() async {
    try {
      final remoteTasks = await _remoteApi.fetchTasks();
      for (final rTask in remoteTasks) {
        // Very basic merge: overwrite local data (last-write-wins could be implemented here)
        final taskEntity = Task(
          id: rTask['id'],
          title: rTask['title'],
          description: rTask['description'],
          isCompleted: rTask['is_completed'],
          syncStatus: 'synced',
          updatedAt: rTask['updated_at'] != null ? DateTime.parse(rTask['updated_at']) : DateTime.now().toUtc(),
          isDeleted: rTask['is_deleted'] ?? false,
        );

        // Insert or replace based on ID. Drift's replace() requires the record to exist.
        // insert(..., mode: InsertMode.insertOrReplace) is better.
        await _localDb.into(_localDb.tasks).insert(taskEntity, mode: drift.InsertMode.insertOrReplace);
      }
    } catch (e) {
      print('Failed to pull remote tasks: $e');
    }
  }
}
