// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lists_dao.dart';

// ignore_for_file: type=lint
mixin _$ListsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ListsTable get lists => attachedDatabase.lists;
  ListsDaoManager get managers => ListsDaoManager(this);
}

class ListsDaoManager {
  final _$ListsDaoMixin _db;
  ListsDaoManager(this._db);
  $$ListsTableTableManager get lists =>
      $$ListsTableTableManager(_db.attachedDatabase, _db.lists);
}
