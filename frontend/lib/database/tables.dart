import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Tasks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  // Offline Sync Columns
  TextColumn get syncStatus => text().withDefault(const Constant('pending_insert'))(); // pending_insert, pending_update, pending_delete, synced
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now().toUtc())();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
