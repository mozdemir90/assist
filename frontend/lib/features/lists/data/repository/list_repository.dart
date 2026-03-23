<<<<<<< Updated upstream
=======
import 'package:dio/dio.dart';
>>>>>>> Stashed changes
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/local_db/app_database.dart';
<<<<<<< Updated upstream
import '../model/list_model.dart';

final listRepositoryProvider = Provider<ListRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final db = ref.watch(appDatabaseProvider);
  return ListRepository(apiClient, db);
});

class ListRepository {
  final ApiClient _apiClient;
  final AppDatabase _db;

  ListRepository(this._apiClient, this._db);
=======
import '../../../../core/logger/app_logger.dart';
import '../model/list_model.dart';
import 'package:drift/drift.dart';

final listRepositoryProvider = Provider<ListRepository>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  final db = ref.watch(appDatabaseProvider);
  return ListRepository(dio, db);
});

class ListRepository {
  final Dio _dio;
  final AppDatabase _db;

  ListRepository(this._dio, this._db);
>>>>>>> Stashed changes

  Stream<List<ListEntity>> watchLists() {
    return _db.listsDao.watchAllLists();
  }

  Future<void> syncLists() async {
<<<<<<< Updated upstream
    try {
      final response = await _apiClient.dio.get('/lists/');
=======
    await _pushPendingChanges();
    try {
      final response = await _dio.get('/lists/');
>>>>>>> Stashed changes
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        for (var item in data) {
          final listModel = ListModel.fromJson(item);
          await _db.listsDao.insertList(ListEntity(
              id: listModel.id,
              name: listModel.name,
              color: listModel.color,
              userId: '', // Ideally retrieved from auth or backend
<<<<<<< Updated upstream
              isDeleted: false,
=======
              syncStatus: 'synced',
>>>>>>> Stashed changes
            ),
          );
        }
      }
    } catch (e) {
<<<<<<< Updated upstream
      // Offline fallback
=======
      appLogger.w('Failed to pull lists: $e');
    }
  }

  Future<void> _pushPendingChanges() async {
    final pendingLists = await _db.listsDao.getPendingLists();
    for (final lst in pendingLists) {
      try {
        if (lst.syncStatus == 'pending_insert') {
          await _dio.post('/lists/', data: {
            'id': lst.id,
            'name': lst.name,
            'color': lst.color,
          });
        } else if (lst.syncStatus == 'pending_update') {
          await _dio.put('/lists/${lst.id}', data: {
            'name': lst.name,
            'color': lst.color,
          });
        } else if (lst.syncStatus == 'pending_delete') {
          await _dio.delete('/lists/${lst.id}');
        }
        await _db.listsDao.updateList(lst.copyWith(syncStatus: 'synced'));
      } catch (e) {
        // Skip and retry next time
      }
>>>>>>> Stashed changes
    }
  }

  Future<void> createList(String name, String color) async {
    final uuid = const Uuid().v4();
    final companion = ListEntity(
      id: uuid,
      name: name,
      color: color,
      userId: 'offline_placeholder',
<<<<<<< Updated upstream
      isDeleted: false,
    );
    await _db.listsDao.insertList(companion);
    try {
      await _apiClient.dio.post('/lists/', data: {
        'id': uuid,
        'name': name,
        'color': color,
      });
    } catch (e) {
      // Saved locally, will sync later
    }
=======
      syncStatus: 'pending_insert',
      isDeleted: false,
    );
    await _db.listsDao.insertList(companion);
    syncLists();
>>>>>>> Stashed changes
  }

  Future<void> deleteList(String id) async {
    await _db.listsDao.softDeleteList(id);
<<<<<<< Updated upstream
    try {
      await _apiClient.dio.delete('/lists/$id');
    } catch (e) {
      // Saved locally, will sync later
    }
=======
    syncLists();
>>>>>>> Stashed changes
  }
}
