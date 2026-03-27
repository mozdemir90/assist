import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/local_db/app_database.dart';
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

  Stream<List<ListEntity>> watchLists() {
    return _db.listsDao.watchAllLists();
  }

  Future<void> syncLists() async {
    try {
      final response = await _apiClient.dio.get('/lists/');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        for (var item in data) {
          final listModel = ListModel.fromJson(item);
          await _db.listsDao.insertList(
            ListEntity(
              id: listModel.id,
              name: listModel.name,
              color: listModel.color,
              userId: '', // Ideally retrieved from auth or backend
              syncStatus: 'synced',
              isDeleted: false,
            ),
          );
        }
      }
    } catch (e) {
      // Offline fallback
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
    try {
      await _apiClient.dio.post(
        '/lists/',
        data: {'id': uuid, 'name': name, 'color': color},
      );
    } catch (e) {
      // Saved locally, will sync later
    }
  }

  Future<void> deleteList(String id) async {
    await _db.listsDao.softDeleteList(id);
    try {
      await _apiClient.dio.delete('/lists/$id');
    } catch (e) {
      // Saved locally, will sync later
    }
  }
}
