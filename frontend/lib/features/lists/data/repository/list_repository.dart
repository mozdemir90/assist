import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/local_db/app_database.dart';
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

  Stream<List<ListEntity>> watchLists() {
    return _db.listsDao.watchAllLists();
  }

  Future<void> syncLists() async {
    await _pushPendingChanges();
    try {
      final response = await _dio.get('/lists/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        for (var item in data) {
          final listModel = ListModel.fromJson(item);
          await _db.listsDao.insertList(ListEntity(
              id: listModel.id,
              name: listModel.name,
              color: listModel.color,
              userId: '', // Ideally retrieved from auth or backend
              syncStatus: 'synced',
            ),
          );
        }
      }
    } catch (e) {
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
    }
  }

  Future<void> createList(String name, String color) async {
    final uuid = const Uuid().v4();
    final companion = ListEntity(
      id: uuid,
      name: name,
      color: color,
      userId: 'offline_placeholder',
      syncStatus: 'pending_insert',
      isDeleted: false,
    );
    await _db.listsDao.insertList(companion);
    syncLists();
  }

  Future<void> deleteList(String id) async {
    await _db.listsDao.softDeleteList(id);
    syncLists();
  }
}
