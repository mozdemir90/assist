import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../tasks/data/task_repository.dart';
import '../../../activities/data/activity_repository.dart';
import '../../../lists/data/repository/list_repository.dart';
<<<<<<< Updated upstream

final syncProvider = Provider((ref) {
  return SyncManager(ref);
=======
import '../../../core/logger/app_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final syncProvider = Provider((ref) {
  final manager = SyncManager(ref);
  manager.initConnectivityListener();
  return manager;
>>>>>>> Stashed changes
});

class SyncManager {
  final Ref _ref;
<<<<<<< Updated upstream

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
  }
=======
  bool _isSyncing = false;

  SyncManager(this._ref);

  void initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        appLogger.i('Network restored. Initiating background sync...');
        syncAll();
      }
    });
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    appLogger.i('Starting global sync');

    // We should ideally sync lists first because tasks might depend on list_id
    try {
      await _ref.read(listRepositoryProvider).syncLists();
    } catch (e, st) {
      appLogger.e('Sync lists failed', error: e, stackTrace: st);
    }

    try {
      await _ref.read(taskRepositoryProvider).fetchAndSyncTasks();
    } catch (e, st) {
      appLogger.e('Sync tasks failed', error: e, stackTrace: st);
    }

    try {
      await _ref.read(activityRepositoryProvider).fetchAndSyncActivities();
    } catch (e, st) {
      appLogger.e('Sync activities failed', error: e, stackTrace: st);
    }

    _isSyncing = false;
    appLogger.i('Global sync completed');
  }
>>>>>>> Stashed changes
}
