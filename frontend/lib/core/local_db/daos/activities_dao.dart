import 'package:drift/drift.dart';
import '../app_database.dart';

part 'activities_dao.g.dart';

@DriftAccessor(tables: [Activities])
class ActivitiesDao extends DatabaseAccessor<AppDatabase>
    with _$ActivitiesDaoMixin {
  final AppDatabase db;

  ActivitiesDao(this.db) : super(db);

  Future<List<ActivityEntity>> getAllActivities() =>
      (select(activities)..where((a) => a.isDeleted.equals(false))).get();

  Future<List<ActivityEntity>> getAllActivitiesForSync() => select(activities).get();

  Stream<List<ActivityEntity>> watchAllActivities() {
    return (select(activities)
          ..where((a) => a.isDeleted.equals(false))
          ..orderBy([
            (a) =>
                OrderingTerm(expression: a.startTime, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<ActivityEntity>> watchActivitiesByTaskId(String taskId) {
    return (select(activities)
          ..where((a) => a.taskId.equals(taskId) & a.isDeleted.equals(false))
          ..orderBy([
            (a) =>
                OrderingTerm(expression: a.startTime, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<int> insertActivity(Insertable<ActivityEntity> activity) =>
      into(activities).insert(activity, mode: InsertMode.insertOrReplace);

  Future<bool> updateActivity(ActivityEntity activity) =>
      update(activities).replace(activity);

  // Soft delete logic for sync purposes
  Future<int> softDeleteActivity(String id) {
    return (update(activities)..where((a) => a.id.equals(id))).write(
      ActivitiesCompanion(
        isDeleted: const Value(true),
        syncStatus: const Value('pending_update'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
