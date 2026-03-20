import 'package:drift/drift.dart';
import '../app_database.dart';

part 'lists_dao.g.dart';

@DriftAccessor(tables: [Lists])
class ListsDao extends DatabaseAccessor<AppDatabase> with _$ListsDaoMixin {
  final AppDatabase db;

  ListsDao(this.db) : super(db);

  Future<List<ListEntity>> getAllLists() =>
      (select(lists)..where((l) => l.isDeleted.equals(false))).get();

  Stream<List<ListEntity>> watchAllLists() =>
      (select(lists)..where((l) => l.isDeleted.equals(false))).watch();

  Future<int> insertList(ListEntity list) =>
      into(lists).insert(list, mode: InsertMode.insertOrReplace);

  Future<bool> updateList(ListEntity list) =>
      update(lists).replace(list);

  Future<int> softDeleteList(String id) {
    return (update(lists)..where((l) => l.id.equals(id)))
        .write(ListsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now().toUtc()),
        ));
  }
}
