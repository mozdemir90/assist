import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../tasks/data/task_repository.dart';
import '../../../activities/data/activity_repository.dart';
import '../../../lists/data/repository/list_repository.dart';
import '../../../reminders/data/repository/reminder_repository.dart';

final syncProvider = Provider((ref) {
  return SyncManager(ref);
});

class SyncManager {
  final Ref _ref;

  SyncManager(this._ref);

  Future<void> syncAll() async {
    // Fire and forget sync requests
    Future.microtask(() async {
      try {
        await _ref.read(listRepositoryProvider).syncLists();
      } catch (e) {}
    });

    Future.microtask(() async {
      try {
        await _ref.read(taskRepositoryProvider).fetchAndSyncTasks();
      } catch (e) {}
    });

    Future.microtask(() async {
      try {
        await _ref.read(activityRepositoryProvider).fetchAndSyncActivities();
      } catch (e) {}
    });

    Future.microtask(() async {
      try {
        await _ref.read(reminderRepositoryProvider).fetchAndSyncReminders();
      } catch (e) {}
    });
  }
}
