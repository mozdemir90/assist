import 'package:drift/drift.dart';
import '../app_database.dart';

part 'reminders_dao.g.dart';

@DriftAccessor(tables: [Reminders])
class RemindersDao extends DatabaseAccessor<AppDatabase> with _$RemindersDaoMixin {
  final AppDatabase db;

  RemindersDao(this.db) : super(db);

  Future<List<ReminderEntity>> getAllReminders() =>
      (select(reminders)..where((r) => r.isDeleted.equals(false))).get();

  Future<List<ReminderEntity>> getAllRemindersForSync() => select(reminders).get();

  Stream<List<ReminderEntity>> watchAllReminders() =>
      (select(reminders)..where((r) => r.isDeleted.equals(false))).watch();

  Future<int> insertReminder(ReminderEntity reminder) =>
      into(reminders).insert(reminder, mode: InsertMode.insertOrReplace);

  Future<bool> updateReminder(ReminderEntity reminder) =>
      update(reminders).replace(reminder);

  Future<int> softDeleteReminder(String id) {
    return (update(reminders)..where((r) => r.id.equals(id))).write(
      RemindersCompanion(
        isDeleted: const Value(true),
        syncStatus: const Value('pending_update'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
